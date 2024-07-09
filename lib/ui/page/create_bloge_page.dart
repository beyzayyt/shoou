import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:show_you/data/localization/local_keys.dart';
import 'package:show_you/services/cubit/userBlog/user_add_blog_cubit.dart';
import 'package:show_you/services/cubit/userBlog/user_add_blog_state.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_cubit.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_state.dart';
import 'package:show_you/services/cubit/userBlog/user_clear_blog_cubit.dart';
import 'package:show_you/services/cubit/userBlog/user_clear_blog_state.dart';
import 'package:show_you/ui/view/loading_animation.dart';
import 'package:show_you/ui/view/users_blog_list.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  bool isSelected = false;
  List selectedList = [];
  List temporaryBlog = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.accountBlogs.tr(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services_outlined),
            tooltip: 'cleaning',
            onPressed: () {
              print("selected list $selectedList");
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('userid').listenable(),
        builder: (context, box, child) {
          var userid = box.get('userid') ?? '';
          return MultiBlocProvider(
            providers: [
              BlocProvider<UserShowBlogCubit>(
                create: (BuildContext context) => UserShowBlogCubit()..showUserBlog(userid),
              ),
              BlocProvider<UserClearBlogCubit>(
                create: (BuildContext bcontext) => UserClearBlogCubit(),
              ),
              BlocProvider<UserAddBlogCubit>(
                create: (BuildContext bcontext) => UserAddBlogCubit(),
              ),
            ],
            child: MultiBlocListener(
              listeners: [
                BlocListener<UserClearBlogCubit, UserClearBlogState>(listener: (context, state) {
                  if (state is UserClearBlogItemCompleted) {
                    context.read<UserShowBlogCubit>().showUserBlog(userid);
                    return;
                  }
                  if (state is UserClearBlogCompleted) {
                    context.read<UserShowBlogCubit>().showUserBlog(userid);
                    return;
                  }
                }),
              ],
              child: Column(children: [
                BlocConsumer<UserShowBlogCubit, UserShowBlogState>(
                  builder: (context, state) {
                    if (state is ShowUserBlogCompliting) {
                      return const LoadingAnimation();
                    } else if (state is ShowUserBlogCompleted && state.blogs != null) {
                      return UserBlogList(selectedList: selectedList, blog: state.blogs ?? [], userid: userid);
                    } else {
                      return Text(LocaleKeys.problemShowingBlogs.tr());
                    }
                  },
                  listener: (BuildContext context, UserShowBlogState state) {},
                ),
                BlocBuilder<UserShowBlogCubit, UserShowBlogState>(builder: (context, state) {
                  return Row(
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                              onPressed: () => context.read<UserClearBlogCubit>().clearUserBlog(userid), child: Text(LocaleKeys.clearAllBlogs.tr())),
                          const SizedBox(
                            width: 16,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateBlogPage(userid: userid)),
                                );
                                if (context.mounted && result != null) context.read<UserShowBlogCubit>().showUserBlog(userid);
                              },
                              child: Text(LocaleKeys.addNewBlog.tr())),
                          ElevatedButton(
                              onPressed: () => context
                                  .read<UserClearBlogCubit>()
                                  .clearUserBlogItemService(selectedList, userid)
                                  .whenComplete(() => selectedList = []),
                              child: Text(LocaleKeys.chooseAndDeleteItem.tr()))
                        ],
                      ),
                    ],
                  );
                }),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class CreateBlogPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  CreateBlogPage({super.key, required this.userid});
  final String userid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Blog Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider<UserAddBlogCubit>(
          create: (context) => UserAddBlogCubit(),
          child: BlocListener<UserAddBlogCubit, UserAddBlogState>(
            listener: (context, state) async {
              if (state is UserAddBlogCompleted) {
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
                return;
              }
            },
            child: BlocBuilder<UserAddBlogCubit, UserAddBlogState>(
              builder: (context, state) {
                return Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: contentController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ValueListenableBuilder(
                      valueListenable: Hive.box('userprofile').listenable(),
                      builder: (context, box, child) {
                        var userProfilePhoto = box.get('profilePhotoUrl') ?? '';
                        return ElevatedButton(
                          onPressed: () async {
                            await context
                                .read<UserAddBlogCubit>()
                                .addUserBlog(titleController.text.trim(), contentController.text.trim(), userid, userProfilePhoto);
                          },
                          child: const Text('Submit'),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
