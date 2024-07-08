import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class UserBlogList extends StatefulWidget {
  UserBlogList({super.key, required this.blog, this.selectedList, this.isHomePage = false, this.userid});
  final List blog;
  List? selectedList;
  final bool isHomePage;
  String? userid;

  @override
  State<UserBlogList> createState() => _UsersBlogListState();
}

class _UsersBlogListState extends State<UserBlogList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        child: ListView.separated(
          // separatorBuilder: (context, index) => !widget.isHomePage ? const SizedBox(height: 4) : const Divider(),
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemCount: widget.blog.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data = widget.blog[index] as Map<String, dynamic>;
            return widget.isHomePage || data['userid'] == widget.userid
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !widget.isHomePage
                          ? Checkbox(
                              value: widget.selectedList?.contains(index),
                              onChanged: (bool? newValue) {
                                setState(() {
                                  if (newValue!) {
                                    widget.selectedList?.add(index);
                                  } else {
                                    widget.selectedList?.remove(index);
                                  }
                                });
                              },
                            )
                          : const SizedBox.shrink(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        child: Card(
                          color: Colors.white,
                          child: Expanded(
                            child: Row(
                              children: [
                                (data['userProfilePhoto'] == null || data['userProfilePhoto'].isEmpty)
                                    ? SvgPicture.asset(
                                        'assets/image/person_asset.svg',
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(data['userProfilePhoto']),
                                      ),
                                const SizedBox(
                                  width: 24,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['username'] != null ? data['username'].toString().toUpperCase() : 'Anonymous',
                                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      data['title'] ?? '',
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      data['content'] ?? '',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                                      maxLines: widget.isHomePage ? null : 2,
                                      overflow: widget.isHomePage ? null : TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
