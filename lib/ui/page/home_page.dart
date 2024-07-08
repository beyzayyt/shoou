import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:show_you/data/localization/local_keys.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_cubit.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_state.dart';
import 'package:show_you/services/cubit/userPhoto/user_photo_cubit.dart';
import 'package:show_you/ui/page/user_profile_page.dart';
import 'package:show_you/ui/view/users_blog_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    String formattedDate = "${now.day}/${now.month}/${now.year}";
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
                length: 1,
                child: Scaffold(
                  appBar: AppBar(
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getGreeting(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    bottom: TabBar(
                      tabs: [
                        Tab(text: LocaleKeys.blog.tr()),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      // BlocBuilder<UserPhotoCubit, UserPhotoState>(
                      //   builder: (context, fetchuserphotostate) {
                      //     if (fetchuserphotostate is FetchUserPhotoCompliting) {
                      //       return const LoadingAnimation();
                      //     }
                      //     return fetchuserphotostate is FetchUserPhotoCompleted
                      //         ? UserPhotoListView(images: fetchuserphotostate.images)
                      //         : const SizedBox.shrink();
                      //   },
                      // ),
                      if (stateshowblog is ShowUserBlogCompleted && stateshowblog.blogs != null)
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: UserBlogList(blog: stateshowblog.blogs ?? [], isHomePage: true, userid: box.get('userid') ?? ''),
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

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return LocaleKeys.goodMorning.tr();
    } else if (hour < 18) {
      return LocaleKeys.goodAfternoon.tr();
    } else {
      return LocaleKeys.goodEvening.tr();
    }
  }
}
