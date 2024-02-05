class UserShowBlogState {
  UserShowBlogState();
}

class ShowUserBlogInitial extends UserShowBlogState {}

class ShowUserBlogCompliting extends UserShowBlogState {}

class ShowUserBlogCompleted extends UserShowBlogState {
  final List<Object?>? blogs;
  ShowUserBlogCompleted(this.blogs);

  List<Object> get props => [];
}

class ShowUserBlogFailed extends UserShowBlogState {
  final String errorMessage;
  ShowUserBlogFailed(this.errorMessage);

  List<Object> get props => [errorMessage];
}