import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImageService {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> uploadImage(File file) async {
    Reference ref = storage.ref().child('images').child(auth.currentUser!.uid).child('userphoto');

    
    UploadTask uploadTask = ref.putFile(File(file.path));
    TaskSnapshot snapshot = await uploadTask.catchError((err) {
      print('AError: $err'); // Prints 401.
    }, test: (error) {
      return error is int && error >= 400;
    });
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
