class UserPhotoState {
  UserPhotoState();
}

class UploadUserPhotoInitial extends UserPhotoState {}

class UploadUserPhotoCompliting extends UserPhotoState {}

class UploadUserPhotoCompleted extends UserPhotoState {
  final String? downloadUrl;
  UploadUserPhotoCompleted(this.downloadUrl);

  List<Object> get props => [];
}

class UploadUserPhotoFailed extends UserPhotoState {
  final String errorMessage;
  UploadUserPhotoFailed(this.errorMessage);

  List<Object> get props => [errorMessage];
}

class FetchUserPhotoInitial extends UserPhotoState {}

class FetchUserPhotoCompliting extends UserPhotoState {}

class FetchUserPhotoCompleted extends UserPhotoState {
  final List<Map<String, dynamic>> images;
  FetchUserPhotoCompleted(this.images);

  List<Object> get props => [];
}

class FetchUserPhotoFailed extends UserPhotoState {
  final String errorMessage;
  FetchUserPhotoFailed(this.errorMessage);

  List<Object> get props => [errorMessage];
}
