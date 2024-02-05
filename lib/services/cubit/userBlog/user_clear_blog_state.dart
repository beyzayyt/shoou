class UserClearBlogState {
  UserClearBlogState();
}

class UserClearBlogInitial extends UserClearBlogState {}

class UserClearBlogCompliting extends UserClearBlogState {}

class UserClearBlogCompleted extends UserClearBlogState {
  final bool isClear;
  UserClearBlogCompleted(this.isClear);

  List<Object> get props => [];
}

class UserClearBlogFailed extends UserClearBlogState {
  final String errorMessage;
  UserClearBlogFailed(this.errorMessage);

  List<Object> get props => [errorMessage];
}


class UserClearBlogItemInitial extends UserClearBlogState {}

class UserClearBlogItemCompliting extends UserClearBlogState {}

class UserClearBlogItemCompleted extends UserClearBlogState {
  final bool isClear;
  UserClearBlogItemCompleted(this.isClear);

  List<Object> get props => [];
}

class UserClearBlogItemFailed extends UserClearBlogState {
  final String errorMessage;
  UserClearBlogItemFailed(this.errorMessage);

  List<Object> get props => [errorMessage];
}