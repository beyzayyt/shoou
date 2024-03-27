import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:show_you/services/cubit/userPhoto/user_photo_cubit.dart';
import 'package:show_you/services/cubit/userPhoto/user_photo_state.dart';

class TakePicturePage extends StatefulWidget {
  const TakePicturePage({super.key});

  @override
  State<TakePicturePage> createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  File? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Photos",
        ),
      ),
      body: BlocProvider<UserPhotoCubit>(
        create: (context) => UserPhotoCubit()..fetchImages(),
        child: BlocBuilder<UserPhotoCubit, UserPhotoState>(
          builder: (context, state) {
            if (state is FetchUserPhotoCompleted) {
              var images = state.images;
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = images[index];
                    return Padding(padding: const EdgeInsets.only(top: 50.0), child: Image.network('${data['url']}'));
                  },
                ),
              );
            }
            return Column(
              children: [
                Center(
                  child: _image == null ? const Text('No image selected.') : Image.file(_image!),
                ),
                ElevatedButton(
                  onPressed: () async {
                    getImage(context);
                  },
                  child: Text(_image == null ? 'Select image' : 'Select new image'),
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
