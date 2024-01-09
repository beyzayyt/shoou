import 'package:firebase_auth/firebase_auth.dart';
import 'package:show_you/data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  Future<UserModel> signUp(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        await signIn(email.trim(), password.trim());
        return UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
        );
      }
    } on FirebaseAuthException catch (e) {
      return UserModel(errorMessage: e.message!);
    }
    return UserModel();
  }

  Future<void> signOut() async {
    if (firebaseUser != null) {
      await FirebaseAuth.instance.signOut();
    }
  }

  Future<UserModel> signIn(String email, String password) async {
    try {
       if (firebaseUser != null) {
       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final User? firebaseUser = userCredential.user;
      return UserModel(
          id: firebaseUser!.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
        );
    }
    } on FirebaseAuthException catch(e) {
      return UserModel(errorMessage: e.message!);
    }
    return UserModel();
   
  }
}
