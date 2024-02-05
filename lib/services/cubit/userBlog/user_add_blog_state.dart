import 'package:show_you/data/models/saved_blog_model.dart';

class UserAddBlogState {
  UserAddBlogState();
}

class UserAddBlogInitial extends UserAddBlogState {}

class UserAddBlogCompliting extends UserAddBlogState {}

class UserAddBlogCompleted extends UserAddBlogState {
  final SavedBlog savedUser;
  UserAddBlogCompleted(this.savedUser);

  List<Object> get props => [];
}

class UserAddBlogFailed extends UserAddBlogState {
  final String errorMessage;
  UserAddBlogFailed(this.errorMessage);

  List<Object> get props => [errorMessage];
}
