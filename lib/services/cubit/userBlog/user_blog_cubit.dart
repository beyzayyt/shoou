import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_you/services/blog_service.dart';
import 'package:show_you/services/cubit/userBlog/user_blog_state.dart';

class UserBlogCubit extends Cubit<UserBlogState> {
  UserBlogCubit() : super(UserAddBlogInitial());

  final BlogService userBlogService = BlogService();

  Future<void> saveUserBlog(String title, String content) async {
    emit(UserAddBlogInitial());
    try {
      emit(UserAddBlogCompliting());
      var savedUser = await userBlogService.addUserBlogService(title, content);

      if (savedUser.errorMessage.isEmpty) {
        emit(UserAddBlogCompleted(savedUser));
      } else {
        emit(UserAddBlogFailed("userResult.errorMessage"));
      }
    } catch (e) {
      emit(UserAddBlogFailed('Create blog failed'));
    }
  }

  Future<void> showUserBlog() async {
    emit(ShowUserBlogInitial());
    try {
      emit(ShowUserBlogCompliting());
      var blogs = await userBlogService.showUserBlogService();

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
