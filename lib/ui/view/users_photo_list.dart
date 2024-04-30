import 'package:flutter/material.dart';

class UserPhotoListView extends StatelessWidget {
  const UserPhotoListView({
    super.key,
    required this.images,
  });

  final List<Map<String, dynamic>> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: images.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> data = images[index];
          return Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.network(
                '${data['url']}',
                fit: BoxFit.fill,
              ));
        },
      ),
    );
  }
}
