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

  Future<List<Map<String, dynamic>>> fetchImages() async {
    List<Map<String, dynamic>> files = [];
    ListResult result = await FirebaseStorage.instance.ref().child('images').child(auth.currentUser!.uid).child('userphoto/').list();
    final List<Reference> allFiles = result.items;
    print(allFiles.length);

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      print('result is $fileUrl');

      files.add({
        'url': fileUrl,
      });
    });

    return files;
  }
}
