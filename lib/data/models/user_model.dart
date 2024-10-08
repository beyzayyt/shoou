class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String errorMessage;
  final bool isNewUser;
  final String userName;
  final String userLastName;
  final String userNickname;
  final String userMobilePhone;
  final String userBirthDate;
  UserModel({
    this.id = '',
    this.email = '',
    this.displayName = '',
    this.errorMessage = '',
    this.isNewUser = false,
    this.userName = '',
    this.userLastName = '',
    this.userMobilePhone = '',
    this.userBirthDate = '',
    this.userNickname = '',
  });
}
