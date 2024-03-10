import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:show_you/services/cubit/userBlog/user_add_blog_cubit.dart';
import 'package:show_you/services/cubit/userBlog/user_add_blog_state.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_cubit.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_state.dart';
import 'package:show_you/services/cubit/userBlog/user_clear_blog_cubit.dart';
import 'package:show_you/services/cubit/userBlog/user_clear_blog_state.dart';
import 'package:show_you/ui/view/user_blog_list.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  bool isSelected = false;
  List selectedList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BLOG",
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<UserShowBlogCubit>(
            create: (BuildContext context) => UserShowBlogCubit()..showUserBlog(),
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
                context.read<UserShowBlogCubit>().showUserBlog();
                return;
              }
              if (state is UserClearBlogCompleted) {
                context.read<UserShowBlogCubit>().showUserBlog();
                return;
              }
            }),
          ],
          child: Column(children: [
            BlocConsumer<UserShowBlogCubit, UserShowBlogState>(
              builder: (context, state) {
                if (state is ShowUserBlogCompliting) {
                  return SizedBox(
                    width: 50,
                    height: 50,
                    child: Lottie.asset(
                      'assets/lottie/loading_animation.json',
                      fit: BoxFit.fill,
                    ),
                  );
                } else if (state is ShowUserBlogCompleted && state.blogs != null) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: UserBlogList(selectedList: selectedList, blog: state.blogs ?? []),
                    ),
                  );
                } else {
                  return const Text("Trouble with blog");
                }
              },
              listener: (BuildContext context, UserShowBlogState state) {},
            ),
            BlocBuilder<UserShowBlogCubit, UserShowBlogState>(builder: (context, state) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: () => context.read<UserClearBlogCubit>().clearUserBlog(), child: const Text("Clear All Blogs")),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CreateBlogPage()),
                            );
                            if (context.mounted && result != null) context.read<UserShowBlogCubit>().showUserBlog();
                          },
                          child: const Text("Add New Blog")),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () =>
                          context.read<UserClearBlogCubit>().clearUserBlogItemService(selectedList).whenComplete(() => selectedList = []),
                      child: const Text("Choose and delete item"))
                ],
              );
            }),
          ]),
        ),
      ),
    );
  }
}

class CreateBlogPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  CreateBlogPage({Key? key}) : super(key: key);

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
                    ElevatedButton(
                      onPressed: () async {
                        await context.read<UserAddBlogCubit>().addUserBlog(titleController.text, contentController.text);
                      },
                      child: const Text('Submit'),
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
