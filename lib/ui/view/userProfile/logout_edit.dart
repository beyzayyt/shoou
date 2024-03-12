import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_you/data/models/saved_user_model.dart';
import 'package:show_you/services/cubit/authentication/authentication_cubit.dart';
import 'package:show_you/services/cubit/authentication/authentication_state.dart';
import 'package:show_you/ui/authentication_page.dart';
import 'package:show_you/ui/profile_informations_page.dart';

// ignore: must_be_immutable
class LogOutandEdit extends StatelessWidget {
  LogOutandEdit({super.key, required this.savedUserModel});
  SavedUserModel? savedUserModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileInformationsPage(savedUserModel: savedUserModel)),
                );
              },
              child: const Text(
                "Profile informations",
                style: TextStyle(color: Color.fromRGBO(66, 27, 115, 1), fontStyle: FontStyle.italic),
              )),
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(),
            child: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) async {
                if (state is SignOutCompleted) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthenticatePage()),
                  );
                }
              },
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return InkWell(
                      onTap: () async {
                        await context.read<AuthCubit>().signOutUser();
                      },
                      child: const Text(
                        "Log out",
                        style: TextStyle(color: Color.fromRGBO(66, 27, 115, 1), fontStyle: FontStyle.italic),
                      ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
