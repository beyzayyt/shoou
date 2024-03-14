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
        // Retrieve data from the document
        Object data = documentSnapshot.data()!;
        // Access fields in the data map
        // var field1 = data['field1'];
        // var field2 = data['field2'];
        var map = Map<String, dynamic>.from(data as Map<dynamic, dynamic>);
        // Do something with the data
        print('Field 1: $data');
        print('Field 2: $map');
        // return data;
        return SavedUserModel.fromJson(map);
        // print('Field 2: $field2');
      } else {
        print('Document does not exist');
      }
    } catch (e) {}
    return null;
  }
}
