import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_cubit.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_state.dart';

class CreateBlogPage extends StatefulWidget {
  const CreateBlogPage({super.key});

  @override
  State<CreateBlogPage> createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> {
  bool resultState = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Blog")),
      body: BlocProvider<UserBlogCubit>(
        create: (context) => UserBlogCubit()..showUserBlog(),
        child: BlocListener<UserBlogCubit, UserBlogState>(
          listener: (context, state) {
            
          },
          child: Column(children: [
            BlocBuilder<UserBlogCubit, UserBlogState>(
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
                  return Wrap(
                      children: state.blogs!.map((item) {
                    Map<String, dynamic> data = item as Map<String, dynamic>;
                    return Column(
                      children: [
                        Text(data['title'] ?? ''),
                        Text(data['content'] ?? ''),
                      ],
                    );
                  }).toList());
                } else {
                  return const Text("Trouble with blog");
                }
              },
            ),
            BlocProvider<UserBlogCubit>(
              create: (context) => UserBlogCubit(),
              child: BlocBuilder<UserBlogCubit, UserBlogState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreatePostPage()),
                      );

                      if (context.mounted && result == true) {
                        // Refresh the blog list when returning from CreatePostPage
                        await context.read<UserBlogCubit>().showUserBlog();
                      }
                    },
                    child: const Text("Create blog"),
                  );
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class CreatePostPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  CreatePostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Blog Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider<UserBlogCubit>(
          create: (context) => UserBlogCubit(),
          child: BlocListener<UserBlogCubit, UserBlogState>(
            listener: (context, state) async {
              if (state is UserAddBlogCompleted) {
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
                return;
              }
            },
            child: BlocBuilder<UserBlogCubit, UserBlogState>(
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
                        await context.read<UserBlogCubit>().saveUserBlog(titleController.text, contentController.text);
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
