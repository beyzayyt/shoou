import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:show_you/data/models/saved_user_model.dart';

class UserInformationService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<SavedUserModel> userInformationService(
      String userName, String userLastName, String userNickname, String userMobilePhone, String userBirthDate) async {
    try {
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('userinfo');
      DocumentReference newDocRef = await collectionReference.add({
        'userName': userName,
        'userLastName': userLastName,
        'userNickname': userNickname,
        'userMobilePhone': userMobilePhone,
        'userBirthDate': userBirthDate,
      });
      String documentId = newDocRef.id;
      SavedUserModel user = SavedUserModel(
          userName: userName,
          userLastName: userLastName,
          userNickname: userNickname,
          userMobilePhone: userMobilePhone,
          userBirthDate: userBirthDate,
          documentId: documentId);
      var box = await Hive.openBox('userprofile');
      box.put('userName', user.userName);
      box.put('documentId', user.documentId);
      return user;
    } on FirebaseAuthException catch (e) {
      return SavedUserModel(errorMessage: e.message!);
    }
  }

  Future<SavedUserModel?> showUserInformationService(String documentId) async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('userinfo');
      DocumentSnapshot documentSnapshot = await collection.doc(documentId).get();
      if (documentSnapshot.exists) {
        Object data = documentSnapshot.data()!;
        var map = Map<String, dynamic>.from(data as Map<dynamic, dynamic>);
        return SavedUserModel.fromJson(map);
      } else {
        print('user does not exist');
      }
    } catch (e) {}
    return null;
  }
}
