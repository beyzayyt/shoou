class SavedUserModel {
  final String userName;
  final String userLastName;
  final String userNickname;
  final String userMobilePhone;
  final String userBirthDate;
  final String errorMessage;
  SavedUserModel({
    this.userName = '',
    this.userLastName = '',
    this.userMobilePhone = '',
    this.userBirthDate = '',
    this.userNickname = '',
    this.errorMessage = '',
  });
}
