import 'package:flutter/material.dart';
import 'package:show_you/data/models/saved_user_model.dart';
import 'package:show_you/ui/view/userProfile/logout_edit.dart';
import 'package:show_you/ui/view/userProfile/user_profile_options.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  SavedUserModel savedUserModel = SavedUserModel();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant UserProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MY ACCOUNT',
        ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(alignment: Alignment.topCenter, children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1682687982423-295485af248a?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            savedUserModel.userName.isEmpty ? 'You can add your name' : savedUserModel.userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Color.fromRGBO(66, 27, 115, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            UserProfileOptions(savedUserModel: savedUserModel),
            const SizedBox(
              height: 50,
            ),
            LogOutandEdit(
              savedUserModel: savedUserModel,
            ),
          ],
        ),
      ),
    );
  }
}
