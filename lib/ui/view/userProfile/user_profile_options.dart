import 'package:flutter/material.dart';
import 'package:show_you/data/models/saved_user_model.dart';
import 'package:show_you/ui/create_bloge_page.dart';
import 'package:show_you/ui/user_profile_form_page.dart';

typedef StringToVoidFunc = void Function(String);

// ignore: must_be_immutable
class UserProfileOptions extends StatelessWidget {
  UserProfileOptions({super.key, required this.savedUserModel, required this.onSubmit});
  SavedUserModel? savedUserModel;
  final Function(SavedUserModel value) onSubmit;

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
              child: const Text(
                'Your Blog',
                style: TextStyle(
                  color: Color.fromRGBO(66, 27, 115, 1),
                  fontStyle: FontStyle.italic,
                ),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(),
              onPressed: () => null,
              child: const Text(
                'Your Photos',
                style: TextStyle(
                  color: Color.fromRGBO(66, 27, 115, 1),
                  fontStyle: FontStyle.italic,
                ),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(),
              onPressed: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfileFormPage()),
                );
                onSubmit(result);
              },
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: Color.fromRGBO(66, 27, 115, 1),
                  fontStyle: FontStyle.italic,
                ),
              )),
        ],
      ),
    );
  }
}
