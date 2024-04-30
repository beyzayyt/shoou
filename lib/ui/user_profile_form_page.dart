import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:show_you/data/models/saved_user_model.dart';
import 'package:show_you/services/cubit/userInfo/user_information_cubit.dart';
import 'package:show_you/services/cubit/userInfo/user_information_state.dart';

// ignore: must_be_immutable
class UserProfileFormPage extends StatefulWidget {
  UserProfileFormPage({super.key, this.savedUserModel, this.profilePhotoUrl});
  SavedUserModel? savedUserModel;
  String? profilePhotoUrl;

  @override
  State<UserProfileFormPage> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfileFormPage> {
  late TextEditingController userName, userNickname, userLastName, userMobilePhone, userBirthDate;

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
      appBar: AppBar(
        title: const Text(
          'EDIT ACCOUNT',
        ),
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
                          const CircleAvatar(
                            radius: 75,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1682687982423-295485af248a?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            ),
                          ),
                          const SizedBox(height: 24),
                          UserInformationTextField(
                            userName: userName,
                            hintText: "User name",
                          ),
                          UserInformationTextField(
                            userName: userLastName,
                            hintText: "User Lastname",
                          ),
                          UserInformationTextField(userName: userNickname, hintText: "User Nickname"),
                          UserInformationTextField(
                            userName: userMobilePhone,
                            hintText: "Mobile Phone",
                            keyboardType: TextInputType.phone,
                          ),
                          UserInformationTextField(
                            userName: userBirthDate,
                            hintText: "User Birth Day",
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
                                          userName.text, userLastName.text, userNickname.text, userMobilePhone.text, userBirthDate.text),
                                      child: const Text(
                                        'Save',
                                        style: TextStyle(color: Color.fromRGBO(66, 27, 115, 1)),
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

  void loadInitialTextField() {
    userName.text = widget.savedUserModel?.userName ?? '';
    userNickname.text = widget.savedUserModel?.userNickname ?? '';
    userLastName.text = widget.savedUserModel?.userLastName ?? '';
    userMobilePhone.text = widget.savedUserModel?.userMobilePhone ?? '';
    userBirthDate.text = widget.savedUserModel?.userBirthDate ?? '';
  }
}

class UserInformationTextField extends StatelessWidget {
  const UserInformationTextField({super.key, required this.userName, required this.hintText, this.keyboardType, this.initialValue});

  final TextEditingController userName;
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
        controller: userName,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );
  }
}
