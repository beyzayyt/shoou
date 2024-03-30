import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class UploadImageService {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> uploadImage(File file) async {
    var uuid = const Uuid();

    Reference ref = storage.ref().child('images').child(auth.currentUser!.uid).child('userphoto/${uuid.v1()}');

    UploadTask uploadTask = ref.putFile(File(file.path));
    TaskSnapshot snapshot = await uploadTask.catchError((err) {
      print('AError: $err');
      return err;
    }, test: (error) {
      return error is int && error >= 400;
    });
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<List<Map<String, dynamic>>> fetchImages(bool isHomePage) async {
    List<Map<String, dynamic>> files = [];
    ListResult? result;
    ListResult? lastResult;
    List<Reference> allFiles = [];

    if (isHomePage) {
      result = await FirebaseStorage.instance.ref().child('images').listAll();
      for (var id = 0; id < result.prefixes.length; id++) {
        lastResult = await FirebaseStorage.instance.ref().child(result.prefixes[id].fullPath).child('userphoto/').list();
        allFiles.addAll(lastResult.items);
      }
    } else {
      result = await FirebaseStorage.instance.ref().child('images').child(auth.currentUser!.uid).child('userphoto/').list();
      allFiles = result.items;
    }

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      files.add({
        'url': fileUrl,
      });
    });

    return files;
  }
}
