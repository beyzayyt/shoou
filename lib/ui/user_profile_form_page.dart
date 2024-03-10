import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_you/services/cubit/userInfo/user_information_cubit.dart';
import 'package:show_you/services/cubit/userInfo/user_information_state.dart';

class UserProfileFormPage extends StatefulWidget {
  const UserProfileFormPage({super.key});

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
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1682687982423-295485af248a?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  ),
                ),
                const SizedBox(height: 24),
                UserInformationTextField(userName: userName, hintText: "User name"),
                UserInformationTextField(userName: userLastName, hintText: "User Lastname"),
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
                            onPressed: () => context
                                .read<UserInformationCubit>()
                                .saveUserInfo(userName.text, userLastName.text, userNickname.text, userMobilePhone.text, userBirthDate.text),
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Color.fromRGBO(66, 27, 115, 1)),
                            ));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserInformationTextField extends StatelessWidget {
  const UserInformationTextField({super.key, required this.userName, required this.hintText, this.keyboardType});

  final TextEditingController userName;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: userName,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: const Color.fromARGB(255, 138, 133, 138)),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 97, 94, 97)),
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 138, 133, 138)), borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );
  }
}
