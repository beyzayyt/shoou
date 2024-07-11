import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:show_you/data/localization/local_keys.dart';
import 'package:show_you/data/models/saved_user_model.dart';
import 'package:show_you/services/cubit/userInfo/user_information_cubit.dart';
import 'package:show_you/services/cubit/userInfo/user_information_state.dart';
import 'package:show_you/services/cubit/userPhoto/user_photo_cubit.dart';
import 'package:show_you/services/cubit/userPhoto/user_photo_state.dart';
import 'package:show_you/ui/view/login_register_logo.dart';

// ignore: must_be_immutable
class UserProfileFormPage extends StatefulWidget {
  UserProfileFormPage({super.key, this.savedUserModel});
  SavedUserModel? savedUserModel;

  @override
  State<UserProfileFormPage> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfileFormPage> {
  late TextEditingController userName, userNickname, userLastName, userMobilePhone, userBirthDate;
  File? _image;
  String? profilePhotoUrl;

  @override
  void initState() {
    super.initState();
    userName = TextEditingController();
    userNickname = TextEditingController();
    userLastName = TextEditingController();
    userMobilePhone = TextEditingController();
    userBirthDate = TextEditingController();
    loadInitialTextField();
  }

  @override
  void dispose() {
    userName.dispose();
    userNickname.dispose();
    userLastName.dispose();
    userMobilePhone.dispose();
    userBirthDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 245, 231, 192),
      backgroundColor: const Color.fromARGB(255, 240, 220, 160),
      appBar: AppBar(
        title: Text(LocaleKeys.editMyAccount.tr(),
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).primaryColor,
            )),
        forceMaterialTransparency: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: ValueListenableBuilder(
              valueListenable: Hive.box('userprofile').listenable(),
              builder: (context, box, child) {
                return BlocProvider<UserInformationCubit>(
                  create: (context) => UserInformationCubit()..showUserInfo(box.get('documentId') ?? ''),
                  child: BlocBuilder<UserInformationCubit, UserInformationState>(
                    builder: (BuildContext context, UserInformationState state) {
                      return Column(
                        children: [
                          BlocProvider<UserPhotoCubit>(
                            create: (context) => UserPhotoCubit(),
                            child: BlocBuilder<UserPhotoCubit, UserPhotoState>(
                              builder: (context, state) {
                                return BlocListener<UserPhotoCubit, UserPhotoState>(
                                  listener: (context, state) {
                                    if (state is UploadUserPhotoCompleted && state.downloadUrl != null) {
                                      setState(() {
                                        profilePhotoUrl = state.downloadUrl!;
                                      });
                                    }
                                  },
                                  child: BlocBuilder<UserPhotoCubit, UserPhotoState>(
                                    builder: (bcontext, state) {
                                      if (state is UploadUserPhotoCompleted && state.downloadUrl != null) {
                                        return CircleAvatar(
                                          radius: 70,
                                          backgroundImage: NetworkImage(state.downloadUrl!),
                                        );
                                      }
                                      return Padding(
                                          padding: const EdgeInsets.only(top: 50.0),
                                          child: box.get('profilePhotoUrl').toString().isEmpty || box.get('profilePhotoUrl') == null
                                              ? Stack(children: [
                                                  const LoginRegisterTitleLogo(),
                                                  Positioned(
                                                    top: 90,
                                                    left: 150,
                                                    child: InkWell(
                                                      onTap: () => getImage(context),
                                                      child: const Icon(
                                                        Icons.add_a_photo,
                                                        size: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ])
                                              : CircleAvatar(
                                                  radius: 70,
                                                  backgroundImage: NetworkImage(box.get('profilePhotoUrl')),
                                                ));
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          UserInformationTextField(
                            controller: userName,
                            hintText: LocaleKeys.userName.tr(),
                          ),
                          UserInformationTextField(
                            controller: userLastName,
                            hintText: LocaleKeys.userLastName.tr(),
                          ),
                          UserInformationTextField(controller: userNickname, hintText: LocaleKeys.userNickname.tr()),
                          UserInformationTextField(
                            controller: userMobilePhone,
                            hintText: LocaleKeys.userMobilePhone.tr(),
                            keyboardType: TextInputType.phone,
                          ),
                          UserInformationTextField(
                            controller: userBirthDate,
                            hintText: LocaleKeys.userBirthDate.tr(),
                            keyboardType: TextInputType.datetime,
                          ),
                          const SizedBox(height: 24),
                          BlocProvider<UserInformationCubit>(
                            create: (context) => UserInformationCubit(),
                            child: BlocListener<UserInformationCubit, UserInformationState>(
                              listener: (context, state) {
                                if (state is UserInformationCompleted) {
                                  Navigator.pop(context, state.savedUser);
                                }
                              },
                              child: BlocBuilder<UserInformationCubit, UserInformationState>(
                                builder: (context, state) {
                                  return ElevatedButton(
                                      style: ElevatedButton.styleFrom(),
                                      onPressed: () => context.read<UserInformationCubit>().saveUserInformations(
                                          userName.text,
                                          userLastName.text,
                                          userNickname.text,
                                          userMobilePhone.text,
                                          userBirthDate.text,
                                          profilePhotoUrl ?? box.get('profilePhotoUrl') ?? ''),
                                      child: Text(
                                        LocaleKeys.save.tr(),
                                        style: const TextStyle(color: Color.fromRGBO(66, 27, 115, 1)),
                                      ));
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
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

  void loadInitialTextField() {
    userName.text = widget.savedUserModel?.userName ?? '';
    userNickname.text = widget.savedUserModel?.userNickname ?? '';
    userLastName.text = widget.savedUserModel?.userLastName ?? '';
    userMobilePhone.text = widget.savedUserModel?.userMobilePhone ?? '';
    userBirthDate.text = widget.savedUserModel?.userBirthDate ?? '';
  }
}

class UserInformationTextField extends StatelessWidget {
  const UserInformationTextField({super.key, required this.controller, required this.hintText, this.keyboardType, this.initialValue});

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: const Color.fromRGBO(66, 27, 115, 1)),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(66, 27, 115, 1),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(66, 27, 115, 1)), borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );
  }
}

  // decoration: BoxDecoration(
  //                             border: Border.all(
  //                               color: const Color.fromRGBO(66, 27, 115, 1),
  //                               width: 1.0,
  //                             ),
  //                             borderRadius: BorderRadius.circular(8.0),
  //                           ),