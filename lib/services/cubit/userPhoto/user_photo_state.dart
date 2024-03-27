class UserPhotoState {
  UserPhotoState();
}

class UploadUserPhotoInitial extends UserPhotoState {}

class UploadUserPhotoCompliting extends UserPhotoState {}

class UploadUserPhotoCompleted extends UserPhotoState {
  final List<Object?>? blogs;
  UploadUserPhotoCompleted(this.blogs);

  List<Object> get props => [];
}

class UploadUserPhotoFailed extends UserPhotoState {
  final String errorMessage;
  UploadUserPhotoFailed(this.errorMessage);

  List<Object> get props => [errorMessage];
}