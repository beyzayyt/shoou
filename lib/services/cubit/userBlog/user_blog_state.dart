import 'package:show_you/data/models/saved_blog_model.dart';

class UserBlogState {
  UserBlogState();
}

class UserAddBlogInitial extends UserBlogState {}

class UserAddBlogCompliting extends UserBlogState {}

class UserAddBlogCompleted extends UserBlogState {
  final SavedBlog savedUser;
  UserAddBlogCompleted(this.savedUser);

  List<Object> get props => [];
}

class UserAddBlogFailed extends UserBlogState {
  final String errorMessage;
  UserAddBlogFailed(this.errorMessage);

  List<Object> get props => [errorMessage];
}

class ShowUserBlogInitial extends UserBlogState {}

class ShowUserBlogCompliting extends UserBlogState {}

class ShowUserBlogCompleted extends UserBlogState {
  final List<Object?>? blogs;
  ShowUserBlogCompleted(this.blogs);

  List<Object> get props => [];
}

class ShowUserBlogFailed extends UserBlogState {
  final String errorMessage;
  ShowUserBlogFailed(this.errorMessage);

  List<Object> get props => [errorMessage];
}