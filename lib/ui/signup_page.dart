import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:show_you/data/models/user_model.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
 
  var incomingTitle = "";
  var incomingContent = "";

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserModel?> signUp(String email,
    String password,) async {
     try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return null;
    // try {
    //   await FirebaseAuth.instance.createUserWithEmailAndPassword(email: t1.text, password: t2.text).then((kullanici) {
    //     FirebaseFirestore.instance
    //         .collection("user_information")
    //         .doc(t1.text)
    //         .set({'key1': t1.text, 'key2': t2.text}).whenComplete(() => print("Kullanıcı firestore veritabanına eklendi"));
    //   });
    // } on FirebaseAuthException catch (e) {
    //   print('Failed with error code: ${e.code}');
    //   print(e.message);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[100],
        elevation: 0,
        title: Text("LocaleKeys.signUpButton.tr()", style: Theme.of(context).textTheme.titleMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: MediaQuery.of(context).size.height / 2,
          margin: const EdgeInsets.fromLTRB(0, 90, 0, 0),
          child: Center(
              child: Column(
            children: [
              TextFormField(
                cursorColor: Colors.amber,
                keyboardType: TextInputType.emailAddress,
                controller: t1,
                decoration: InputDecoration(
                  hintText: "E-mail",
                  hintStyle: Theme.of(context).textTheme.titleMedium,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor), borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                cursorColor: Colors.amber,
                keyboardType: TextInputType.text,
                controller: t2,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: Theme.of(context).textTheme.subtitle1,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor), borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: () {
                     signUp(t1.text, t2.text);
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Text('j'))
              // ListTile(
              //   title: Text(incomingTitle),
              //   subtitle: Text(incomingContent),
              // ),
            ],
          )),
        ),
      ),
    );
  }
}
