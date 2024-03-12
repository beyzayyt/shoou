import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:show_you/data/models/saved_user_model.dart';

class UserInformationService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<SavedUserModel> userInformationService(
      String userName, String userLastName, String userNickname, String userMobilePhone, String userBirthDate) async {
    try {
      db.collection('userinfo').add({
        'userName': userName,
        'userLastName': userLastName,
        'userNickname': userNickname,
        'userMobilePhone': userMobilePhone,
        'userBirthDate': userBirthDate,
      });
      SavedUserModel user = SavedUserModel(
          userName: userName, userLastName: userLastName, userNickname: userNickname, userMobilePhone: userMobilePhone, userBirthDate: userBirthDate);
      var box = await Hive.openBox('userprofile');
      box.add(user.userName);
      return user;
    } on FirebaseAuthException catch (e) {
      return SavedUserModel(errorMessage: e.message!);
    }
  }
}
