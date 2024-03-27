
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
      var savedUser = await userPhotoService.uploadImage(file);

      // if (savedUser.errorMessage.isEmpty) {
      //   emit(UploadUserPhotoCompleted(savedUser));
      // } else {
      //   emit(UploadUserPhotoFailed("userResult.errorMessage"));
      // }
    } catch (e) {
      emit(UploadUserPhotoFailed('Create blog failed'));
    }
  }
}
