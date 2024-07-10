import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:show_you/data/localization/local_keys.dart';
import 'package:show_you/data/models/saved_user_model.dart';
import 'package:show_you/services/cubit/userBlog/user_add_blog_cubit.dart';
import 'package:show_you/services/cubit/userBlog/user_add_blog_state.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_cubit.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_state.dart';
import 'package:show_you/services/cubit/userBlog/user_clear_blog_cubit.dart';
import 'package:show_you/services/cubit/userBlog/user_clear_blog_state.dart';
import 'package:show_you/ui/view/loading_animation.dart';
import 'package:show_you/ui/view/userProfile/change_language.dart';
import 'package:show_you/ui/view/userProfile/logout_edit.dart';
import 'package:show_you/ui/view/userProfile/user_profile_options.dart';
import 'package:show_you/ui/view/users_blog_list.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  bool isSelected = false;
  List selectedList = [];
  List temporaryBlog = [];
  SavedUserModel savedUserModel = SavedUserModel();
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
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(
                  child: Stack(alignment: Alignment.topCenter, children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ValueListenableBuilder(
                        valueListenable: Hive.box('userprofile').listenable(),
                        builder: (context, box, child) {
                          return Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: box.get('profilePhotoUrl') == null || box.get('profilePhotoUrl') == ""
                                      ? SvgPicture.asset(
                                          'assets/image/person_asset.svg',
                                        )
                                      : CircleAvatar(
                                          radius: 70,
                                          backgroundImage: NetworkImage(box.get('profilePhotoUrl')),
                                        )),
                              Text(
                                box.isEmpty ? LocaleKeys.accountnamedescription.tr() : box.get('userName'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(66, 27, 115, 1),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ]),
                ),
                UserProfileEdit(
                  savedUserModel: savedUserModel,
                  onSubmit: (SavedUserModel value) => {
                    setState(() {
                      savedUserModel = value;
                    })
                  },
                ),
                LogOut(
                  savedUserModel: savedUserModel,
                ),
                ChangeLanguage(savedUserModel: savedUserModel),
                BlocBuilder<UserShowBlogCubit, UserShowBlogState>(builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                          onTap: () async {
                            await context.read<UserClearBlogCubit>().clearUserBlog(userid);
                          },
                          child: Text(
                            LocaleKeys.clearAllBlogs.tr(),
                            style: const TextStyle(color: Color.fromRGBO(66, 27, 115, 1)),
                          )),
                      InkWell(
                          onTap: () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CreateBlogPage(userid: userid)),
                            );
                            if (context.mounted && result != null) context.read<UserShowBlogCubit>().showUserBlog(userid);
                          },
                          child: Text(
                            LocaleKeys.addNewBlog.tr(),
                            style: const TextStyle(color: Color.fromRGBO(66, 27, 115, 1)),
                          )),
                      InkWell(
                          onTap: () =>
                              context.read<UserClearBlogCubit>().clearUserBlogItemService(selectedList, userid).whenComplete(() => selectedList = []),
                          child: Text(
                            LocaleKeys.chooseAndDeleteItem.tr(),
                            style: const TextStyle(color: Color.fromRGBO(66, 27, 115, 1)),
                          )),
                    ],
                  );
                }),
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
