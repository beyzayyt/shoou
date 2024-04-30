import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:show_you/data/models/saved_user_model.dart';
import 'package:show_you/services/cubit/userPhoto/user_photo_cubit.dart';
import 'package:show_you/services/cubit/userPhoto/user_photo_state.dart';
import 'package:show_you/ui/home_page.dart';
import 'package:show_you/ui/view/userProfile/logout_edit.dart';
import 'package:show_you/ui/view/userProfile/user_profile_options.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  SavedUserModel savedUserModel = SavedUserModel();
  File? _image;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant UserProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MY ACCOUNT',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(alignment: Alignment.topCenter, children: [
                BlocProvider<UserPhotoCubit>(
                  create: (context) => UserPhotoCubit(),
                  child: Column(
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(top: 50.0),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: AssetImage('assets/images/profile_image.jpg'),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: Hive.box('userprofile').listenable(),
                              builder: (context, box, child) {
                                return Text(
                                  box.isEmpty ? 'You can add your name' : box.get('userName'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Color.fromRGBO(66, 27, 115, 1),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            UserProfileOptions(
              savedUserModel: savedUserModel,
              onSubmit: (SavedUserModel value) => {
                setState(() {
                  savedUserModel = value;
                })
              },
            ),
            const SizedBox(
              height: 50,
            ),
            LogOutandEdit(
              savedUserModel: savedUserModel,
            ),
          ],
        ),
      ),
    );
  }

  Future getImage(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          context.read<UserPhotoCubit>().uploadPhoto(_image!);
        } else {
          print('No image selected.');
        }
      });
      return await pickedFile?.readAsBytes();
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}
