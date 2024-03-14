
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_you/services/blog_service.dart';
import 'package:show_you/services/cubit/userBlog/user_add_blog_state.dart';

class UserAddBlogCubit extends Cubit<UserAddBlogState> {
  UserAddBlogCubit() : super(UserAddBlogInitial());

  final BlogService userBlogService = BlogService();

  Future<void> addUserBlog(String title, String content,String userid) async {
    emit(UserAddBlogInitial());
    try {
      emit(UserAddBlogCompliting());
      var savedUser = await userBlogService.addUserBlogService(title, content, userid);

      if (savedUser.errorMessage.isEmpty) {
        emit(UserAddBlogCompleted(savedUser));
      } else {
        emit(UserAddBlogFailed("userResult.errorMessage"));
      }
    } catch (e) {
      emit(UserAddBlogFailed('Create blog failed'));
    }
  }
}
