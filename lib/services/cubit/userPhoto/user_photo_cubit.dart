import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_you/services/cubit/userPhoto/user_photo_state.dart';
import 'package:show_you/services/upload_image_service.dart';

class UserPhotoCubit extends Cubit<UserPhotoState> {
  UserPhotoCubit() : super(UploadUserPhotoInitial());

  final UploadImageService userPhotoService = UploadImageService();

  Future<void> uploadPhoto(File file) async {
    emit(UploadUserPhotoInitial());
    try {
      emit(UploadUserPhotoCompliting());
      var downloadUrl = await userPhotoService.uploadImage(file);

      if (downloadUrl.isNotEmpty) {
        emit(UploadUserPhotoCompleted(downloadUrl));
      } else {
        emit(UploadUserPhotoFailed("Download url failed"));
      }
    } catch (e) {
      emit(UploadUserPhotoFailed('Download url failed'));
    }
  }

  Future<void> fetchImages(bool isHomePage) async {
    emit(FetchUserPhotoInitial());
    try {
      emit(FetchUserPhotoCompliting());
      var images = await userPhotoService.fetchImages(isHomePage);

      if (images.isNotEmpty) {
        emit(FetchUserPhotoCompleted(images));
      } else {
        emit(FetchUserPhotoFailed("Fetch images failed"));
      }
    } catch (e) {
      emit(FetchUserPhotoFailed('Fetch images failed'));
    }
  }
}
