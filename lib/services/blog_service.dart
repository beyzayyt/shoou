import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:show_you/data/models/saved_blog_model.dart';

class BlogService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<SavedBlog> addUserBlogService(String title, String content,String userid) async {
    try {
      db.collection(userid).add({
        'title': title,
        'content': content,
      });

      SavedBlog user = SavedBlog(title: title, content: content);

      return user;
    } on FirebaseAuthException catch (e) {
      return SavedBlog(errorMessage: e.message!);
    }
  }

  Future<List<Object?>?> showUserBlogService(String userid) async {
    CollectionReference collection = FirebaseFirestore.instance.collection(userid);
    try {
      QuerySnapshot querySnapshot = await collection.get();
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allData;
    } catch (e) {}
    return null;
  }

  Future<bool> clearUserAllBlogService(String userid) async {
    CollectionReference collection = FirebaseFirestore.instance.collection(userid);

    try {
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearUserBlogItemService(List idList, String userid) async {
    CollectionReference collection = FirebaseFirestore.instance.collection(userid);
    try {
      var snapshots = await collection.get();

      for (var id in idList) {
        await snapshots.docs[id].reference.delete();
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
