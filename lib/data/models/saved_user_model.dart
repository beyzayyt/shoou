import 'package:hive/hive.dart';
part 'saved_user_model.g.dart';

@HiveType(typeId: 1)
class SavedUserModel {
  @HiveField(0)
  final String userName;

  @HiveField(1)
  final String userLastName;

  @HiveField(2)
  final String userNickname;

  @HiveField(3)
  final String userMobilePhone;

  @HiveField(4)
  final String userBirthDate;

  @HiveField(5)
  final String errorMessage;

  @HiveField(6)
  final String documentId;

  SavedUserModel(
      {this.userName = '',
      this.userLastName = '',
      this.userMobilePhone = '',
      this.userBirthDate = '',
      this.userNickname = '',
      this.errorMessage = '',
      this.documentId = ''});

      factory SavedUserModel.fromJson(Map<String, dynamic> json) {
    return SavedUserModel(
      userBirthDate: json['userBirthDate'],
      userLastName: json['userLastName'],
      userMobilePhone: json['userMobilePhone'],
      userNickname: json['userNickname'],
      userName: json['userName'],
    );
  }
}
