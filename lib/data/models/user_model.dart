class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String errorMessage;
  final bool isNewUser;
  UserModel({this.id = '', this.email = '', this.displayName = '', this.errorMessage = '', this.isNewUser = false});
}
