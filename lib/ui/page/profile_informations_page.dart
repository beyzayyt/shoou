import 'package:flutter/material.dart';
import 'package:show_you/data/models/saved_user_model.dart';

// ignore: must_be_immutable
class ProfileInformationsPage extends StatelessWidget {
  ProfileInformationsPage({super.key, required this.savedUserModel});
  SavedUserModel? savedUserModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text(
          'PRP',
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: 3,
          itemBuilder: (context, index) {
            // Map<String, dynamic> data = widget.blog[index] as Map<String, dynamic>;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "isim",
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "data['content'] ?? ''",
                        style: const TextStyle(fontSize: 14),
                        // maxLines: widget.isHomePage ? null : 2,
                        // overflow: widget.isHomePage ? null : TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
