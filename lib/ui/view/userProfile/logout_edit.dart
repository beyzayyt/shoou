import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_you/data/localization/local_keys.dart';
import 'package:show_you/data/models/saved_user_model.dart';
import 'package:show_you/services/cubit/authentication/authentication_cubit.dart';
import 'package:show_you/services/cubit/authentication/authentication_state.dart';
import 'package:show_you/ui/page/authentication_page.dart';

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
                      child: Text(
                        LocaleKeys.logOut.tr(),
                        style: const TextStyle(color: Color.fromRGBO(66, 27, 115, 1), fontStyle: FontStyle.italic),
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
