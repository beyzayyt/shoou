import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:show_you/services/cubit/userPhoto/user_photo_cubit.dart';
import 'package:show_you/services/cubit/userPhoto/user_photo_state.dart';

class TakePicturePage extends StatefulWidget {
  const TakePicturePage({super.key});

  @override
  State<TakePicturePage> createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  File? _image;
  String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Photos",
        ),
      ),
      body: BlocProvider<UserPhotoCubit>(
        create: (context) => UserPhotoCubit(),
        child: BlocBuilder<UserPhotoCubit, UserPhotoState>(
          builder: (context, state) {
            return Column(
              children: [
                Center(
                  child: _image == null ? const Text('No image selected.') : Image.file(_image!),
                ),
                ElevatedButton(
                  onPressed: () async {
                    getImage(context);
                  },
                  child: const Text('Select image'),
                ),
              ],
            );
          },
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
