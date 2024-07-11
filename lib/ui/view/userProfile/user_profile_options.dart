import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:show_you/data/localization/local_keys.dart';
import 'package:show_you/data/models/saved_user_model.dart';
import 'package:show_you/services/cubit/userInfo/user_information_cubit.dart';
import 'package:show_you/services/cubit/userInfo/user_information_state.dart';
import 'package:show_you/ui/page/user_profile_form_page.dart';

typedef StringToVoidFunc = void Function(String);

// ignore: must_be_immutable
class UserProfileEdit extends StatefulWidget {
  UserProfileEdit({super.key, required this.savedUserModel, required this.onSubmit});
  SavedUserModel? savedUserModel;
  final Function(SavedUserModel value) onSubmit;

  @override
  State<UserProfileEdit> createState() => _UserProfileEditState();
}

class _UserProfileEditState extends State<UserProfileEdit> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
      child: ValueListenableBuilder(
        valueListenable: Hive.box('userprofile').listenable(),
        builder: (context, box, child) {
          return BlocProvider<UserInformationCubit>(
            create: (context) => UserInformationCubit()..showUserInfo(box.get('documentId') ?? ''),
            child: BlocListener<UserInformationCubit, UserInformationState>(
              listener: (context, state) async {
                if (state is ShowUserInformationCompleted) {}
              },
              child: BlocBuilder<UserInformationCubit, UserInformationState>(
                builder: (context, state) {
                  return InkWell(
                      onTap: () async {
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfileFormPage(savedUserModel: state is ShowUserInformationCompleted ? state.user : null)),
                        );

                        widget.onSubmit(result);
                        if (context.mounted) {
                          await context.read<UserInformationCubit>().showUserInfo(box.get('documentId') ?? '');
                        }
                      },
                      child: Text(
                        LocaleKeys.editProfile.tr(),
                        style: const TextStyle(color: Color.fromRGBO(66, 27, 115, 1)),
                      ));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
