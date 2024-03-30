import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_cubit.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_state.dart';
import 'package:show_you/services/cubit/userPhoto/user_photo_cubit.dart';
import 'package:show_you/services/cubit/userPhoto/user_photo_state.dart';
import 'package:show_you/ui/user_profile_page.dart';
import 'package:show_you/ui/view/users_blog_list.dart';
import 'package:show_you/ui/view/users_photo_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('userid').listenable(),
      builder: (context, box, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<UserShowBlogCubit>(
              create: (BuildContext context) => UserShowBlogCubit()..showUserBlog(box.get('userid') ?? ''),
            ),
            BlocProvider<UserPhotoCubit>(create: (BuildContext context) => UserPhotoCubit()..fetchImages(true)),
          ],
          child: BlocBuilder<UserShowBlogCubit, UserShowBlogState>(
            builder: (context, stateshowblog) {
              return DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    bottom: const TabBar(
                      tabs: [
                        Tab(text: 'Photos'),
                        Tab(text: 'Blogs'),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      BlocBuilder<UserPhotoCubit, UserPhotoState>(
                        builder: (context, fetchuserphotostate) {
                          if (fetchuserphotostate is FetchUserPhotoCompliting) {
                            return SizedBox(
                              width: 50,
                              height: 50,
                              child: Lottie.asset(
                                'assets/lottie/loading_animation.json',
                                fit: BoxFit.fill,
                              ),
                            );
                          }
                          return fetchuserphotostate is FetchUserPhotoCompleted
                              ? Center(
                                  child: UserPhotoListView(images: fetchuserphotostate.images),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      if (stateshowblog is ShowUserBlogCompleted && stateshowblog.blogs != null)
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: UsersBlogList(blog: stateshowblog.blogs ?? [], isHomePage: true, userid: box.get('userid') ?? ''),
                        ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserProfilePage()),
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
