import 'package:show_you/data/models/saved_user_model.dart';

class UserInformationState {
  UserInformationState();
}

class UserInformationInitial extends UserInformationState {}

class UserInformationCompliting extends UserInformationState {}

class UserInformationCompleted extends UserInformationState {
  final SavedUserModel savedUser;
  UserInformationCompleted(this.savedUser);

  List<Object> get props => [];
}

class UserInformationFailed extends UserInformationState {
  final String errorMessage;
  UserInformationFailed(this.errorMessage);

  List<Object> get props => [errorMessage];
}
