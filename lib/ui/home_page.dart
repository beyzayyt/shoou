import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_cubit.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_state.dart';
import 'package:show_you/ui/user_profile_page.dart';
import 'package:show_you/ui/view/user_blog_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('userid').listenable(
      
      ),
      builder: (context, box, child) {
        return  MultiBlocProvider(
        providers: [
          BlocProvider<UserShowBlogCubit>(
            create: (BuildContext context) => UserShowBlogCubit()..showUserBlog(box.get('userid')),
          ),
        ],
        child: BlocBuilder<UserShowBlogCubit, UserShowBlogState>(
          builder: (context, stateshowblog) {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'Blogs'),
                      Tab(text: 'Photos'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    if (stateshowblog is ShowUserBlogCompleted && stateshowblog.blogs != null)
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: UserBlogList(blog: stateshowblog.blogs ?? [], isHomePage: true),
                      ),
                    const Center(
                      child: Text('Content for Tab 2'),
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  const UserProfilePage()),
                    );
      
                    if (context.mounted) context.read<UserShowBlogCubit>().showUserBlog(box.get('userid'));
                  },
                  child: const Icon(Icons.person),
                ),
              ),
            );
          },
        ),
      );
      },
      
    );
  }
}
