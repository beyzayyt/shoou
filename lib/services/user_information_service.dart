import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInformationService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> userInformationService(String userName, String userLastName, String userNickname, String userMobilePhone, String userBirthDate) async {
    try {
      db.collection('userinfo').add({
        'userName': userName,
        'userLastName': userLastName,
        'userNickname': userNickname,
        'userMobilePhone': userMobilePhone,
        'userBirthDate': userBirthDate,
      }).then((DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'));
      return true;
    } on FirebaseAuthException catch (e) {
      print("error message $e");
      return false;
    }
  }
}
