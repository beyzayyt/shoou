import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UsersBlogList extends StatefulWidget {
  UsersBlogList({super.key, required this.blog, this.selectedList, this.isHomePage = false, this.userid});
  final List blog;
  List? selectedList;
  final bool isHomePage;
  String? userid;

  @override
  State<UsersBlogList> createState() => _UsersBlogListState();
}

class _UsersBlogListState extends State<UsersBlogList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      child: ListView.separated(
        separatorBuilder: (context, index) => !widget.isHomePage ? const SizedBox(height: 4) : const Divider(),
        itemCount: widget.blog.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> data = widget.blog[index] as Map<String, dynamic>;
          return widget.isHomePage || data['userid'] == widget.userid
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Expanded(
                      child: Column(
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
                    ),
                  ],
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
