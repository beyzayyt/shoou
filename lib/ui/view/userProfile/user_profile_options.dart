import 'package:flutter/material.dart';
import 'package:show_you/data/models/saved_user_model.dart';
import 'package:show_you/ui/create_bloge_page.dart';
import 'package:show_you/ui/user_profile_form_page.dart';

// ignore: must_be_immutable
class UserProfileOptions extends StatefulWidget {
  UserProfileOptions({super.key, required this.savedUserModel});
  SavedUserModel? savedUserModel;

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
                setState(() {
                  widget.savedUserModel = result;
                });
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