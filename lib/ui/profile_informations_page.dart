import 'package:flutter/material.dart';
import 'package:show_you/data/models/saved_user_model.dart';

// ignore: must_be_immutable
class ProfileInformationsPage extends StatelessWidget {
  ProfileInformationsPage({super.key, required this.savedUserModel});
  SavedUserModel? savedUserModel;

  @override
  Widget build(BuildContext context) {
    return Text(savedUserModel!.userName);
  }
}
