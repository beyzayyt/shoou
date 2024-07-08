import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:show_you/data/localization/local_keys.dart';
import 'package:show_you/data/models/saved_user_model.dart';
import 'package:show_you/services/cubit/userInfo/user_information_cubit.dart';
import 'package:show_you/services/cubit/userInfo/user_information_state.dart';
import 'package:show_you/ui/page/create_bloge_page.dart';
import 'package:show_you/ui/page/user_profile_form_page.dart';

typedef StringToVoidFunc = void Function(String);

// ignore: must_be_immutable
class UserProfileOptions extends StatefulWidget {
  UserProfileOptions({super.key, required this.savedUserModel, required this.onSubmit});
  SavedUserModel? savedUserModel;
  final Function(SavedUserModel value) onSubmit;

  @override
  State<UserProfileOptions> createState() => _UserProfileOptionsState();
}

class _UserProfileOptionsState extends State<UserProfileOptions> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BlogPage()),
                );
              },
              child: Text(
                LocaleKeys.accountBlogs.tr(),
                style: const TextStyle(
                  color: Color.fromRGBO(66, 27, 115, 1),
                  // fontStyle: FontStyle.italic,
                ),
              )),
          ValueListenableBuilder(
            valueListenable: Hive.box('userprofile').listenable(),
            builder: (context, box, child) {
              return BlocProvider<UserInformationCubit>(
                create: (context) => UserInformationCubit()..showUserInfo(box.get('documentId') ?? ''),
                child: BlocListener<UserInformationCubit, UserInformationState>(
                  listener: (context, state) async {
                    print("listener is trying");
                    if (state is ShowUserInformationCompleted) {
                      print("listener ${state.user!.userLastName}");
                    }
                  },
                  child: BlocBuilder<UserInformationCubit, UserInformationState>(
                    builder: (context, state) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserProfileFormPage(savedUserModel: state is ShowUserInformationCompleted ? state.user : null)),
                            );

                            widget.onSubmit(result);
                            if (context.mounted) {
                              await context.read<UserInformationCubit>().showUserInfo(box.get('documentId') ?? '');
                            }
                          },
                          child: Text(
                            LocaleKeys.editProfile.tr(),
                            style: const TextStyle(
                              color: Color.fromRGBO(66, 27, 115, 1),
                              // fontStyle: FontStyle.italic,
                            ),
                          ));
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
