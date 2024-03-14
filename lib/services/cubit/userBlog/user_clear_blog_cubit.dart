import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_you/services/blog_service.dart';
import 'package:show_you/services/cubit/userBlog/user_clear_blog_state.dart';

class UserClearBlogCubit extends Cubit<UserClearBlogState> {
  UserClearBlogCubit() : super(UserClearBlogInitial());

  final BlogService userBlogService = BlogService();

  Future<void> clearUserBlog(String  userid) async {
    emit(UserClearBlogInitial());
    try {
      emit(UserClearBlogCompliting());
      var blogs = await userBlogService.clearUserAllBlogService(userid);

      if (blogs) {
        emit(UserClearBlogCompleted(blogs));
      } else {
        emit(UserClearBlogFailed("clear.blogs.errorMessage"));
      }
    } catch (e) {
      emit(UserClearBlogFailed('clear blogs failed'));
    }
  }

  Future<void> clearUserBlogItemService(List idList, String userid) async {
    emit(UserClearBlogItemInitial());
    try {
      emit(UserClearBlogItemCompliting());
      var result = await userBlogService.clearUserBlogItemService(idList, userid);

      if (result) {
        emit(UserClearBlogItemCompleted(result));
      } else {
        emit(UserClearBlogItemFailed("clear.blogs.item.errorMessage"));
      }
    } catch (e) {
      emit(UserClearBlogItemFailed('clear blog item failed'));
    }
  }
}
