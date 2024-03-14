import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_you/services/blog_service.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_state.dart';

class UserShowBlogCubit extends Cubit<UserShowBlogState> {
  UserShowBlogCubit() : super(ShowUserBlogInitial());

  final BlogService userBlogService = BlogService();

  Future<void> showUserBlog(String userid) async {
    emit(ShowUserBlogInitial());
    try {
      emit(ShowUserBlogCompliting());
      var blogs = await userBlogService.showUserBlogService(userid);

      if (blogs != null) {
        emit(ShowUserBlogCompleted(blogs));
      } else {
        emit(ShowUserBlogFailed("blogs.errorMessage"));
      }
    } catch (e) {
      emit(ShowUserBlogFailed('show blogs failed'));
    }
  }
}
