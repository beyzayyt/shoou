import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:show_you/data/localization/local_keys.dart';
import 'package:show_you/data/models/saved_user_model.dart';
import 'package:show_you/services/cubit/userPhoto/user_photo_cubit.dart';
import 'package:show_you/ui/page/home_page.dart';
import 'package:show_you/ui/view/userProfile/change_language.dart';
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
        title: Text(
          LocaleKeys.myAccount.tr(),
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
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box('userprofile').listenable(),
                    builder: (context, box, child) {
                      return Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: box.get('profilePhotoUrl') == null || box.get('profilePhotoUrl') == ""
                                  ? SvgPicture.asset(
                                      'assets/image/person_asset.svg',
                                    )
                                  : CircleAvatar(
                                      radius: 70,
                                      backgroundImage: NetworkImage(box.get('profilePhotoUrl')),
                                    )),
                          Text(
                            box.isEmpty ? LocaleKeys.accountnamedescription.tr() : box.get('userName'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Color.fromRGBO(66, 27, 115, 1),
                            ),
                          ),
                        ],
                      );
                    },
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
            ChangeLanguage(savedUserModel: savedUserModel)
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
