import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:show_you/data/models/saved_user_model.dart';
import 'package:show_you/ui/create_bloge_page.dart';
import 'package:show_you/ui/user_profile_form_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant UserProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  SavedUserModel savedUserModel = SavedUserModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Account',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1682687982423-295485af248a?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        savedUserModel.userName.isEmpty ? 'You can add your name' : savedUserModel.userName,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const AddPhoto(),
                const Divider(),
                const WriteBlog(),
                const Divider(),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Account Settings"),
                    InkWell(
                      onTap: () async {
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UserProfileFormPage()),
                        );
                        setState(() {
                          savedUserModel = result;
                        });
                      },
                      child: const Text(
                        "Edit Profile",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class WriteBlog extends StatelessWidget {
  const WriteBlog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateBlogPage()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your blog",
            style: TextStyle(fontSize: 16),
          ),
          SvgPicture.asset(
            'assets/image/write_blog.svg',
            width: 50,
            height: 100,
          ),
        ],
      ),
    );
  }
}

class AddPhoto extends StatelessWidget {
  const AddPhoto({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Photos",
            style: TextStyle(fontSize: 16),
          ),
          SvgPicture.asset(
            'assets/image/add_photo.svg',
            width: 50,
            height: 100,
          ),
        ],
      ),
    );
  }
}
