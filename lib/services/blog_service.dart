import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:show_you/data/models/saved_blog_model.dart';

class BlogService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<SavedBlog> addUserBlogService(String title, String content) async {
    try {
      db.collection('userblog').add({
        'title': title,
        'content': content,
      }).then((DocumentReference doc) => print('DocumentSnapshot added with ID: blog service ${doc.id}'));
      SavedBlog user = SavedBlog(title: title, content: content);
      return user;
    } on FirebaseAuthException catch (e) {
      return SavedBlog(errorMessage: e.message!);
    }
  }

  Future<List<Object?>?> showUserBlogService() async {
    CollectionReference collection = FirebaseFirestore.instance.collection('userblog');

    try {
      QuerySnapshot querySnapshot = await collection.get();

      // Get data from docs and convert map to List
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allData.toList();
    } on FirebaseAuthException catch (e) {
      // return SavedBlog(errorMessage: e.message!);
    }
    return null;
  }

  Future<bool> clearUserAllBlogService() async {
    CollectionReference collection = FirebaseFirestore.instance.collection('userblog');

    try {
      var snapshots = await collection.get();
      snapshots.docs[0].reference.delete();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  Future<bool> clearUserBlogItemService(int id) async {
    CollectionReference collection = FirebaseFirestore.instance.collection('userblog');
    try {
      var snapshots = await collection.get();
      snapshots.docs[id].reference.delete();

      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }
}
