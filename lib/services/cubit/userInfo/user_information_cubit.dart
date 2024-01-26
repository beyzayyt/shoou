import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_you/services/cubit/userInfo/user_information_state.dart';
import 'package:show_you/services/user_information_service.dart';

class UserInformationCubit extends Cubit<UserInformationState> {
  UserInformationCubit() : super(UserInformationInitial());

  final UserInformationService userInfoService = UserInformationService();

  Future<void> saveUserInfo(String userName, String userLastName, String userNickname, String userMobilePhone, String userBirthDate) async {
    emit(UserInformationInitial());
    try {
      emit(UserInformationCompliting());
      var savedUser = await userInfoService.userInformationService(userName, userLastName, userNickname, userMobilePhone, userBirthDate);

      if (savedUser.errorMessage.isEmpty) {
        emit(UserInformationCompleted(savedUser));
      } else {
        emit(UserInformationFailed("userResult.errorMessage"));
      }
    } catch (e) {
      emit(UserInformationFailed('Create user failed'));
    }
  }
}
