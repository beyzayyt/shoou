import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserBlogList extends StatefulWidget {
  UserBlogList({super.key, required this.blog, this.selectedList, this.isHomePage = false});
  final List blog;
  List? selectedList;
  final bool isHomePage;

  @override
  State<UserBlogList> createState() => _UserBlogListState();
}

class _UserBlogListState extends State<UserBlogList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      child: ListView.separated(
        separatorBuilder: (context, index) => !widget.isHomePage ? const SizedBox.shrink() : const Divider(),
        itemCount: widget.blog.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> data = widget.blog[index] as Map<String, dynamic>;
          return Row(
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
                      data['title'] ?? '',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data['content'] ?? '',
                      style: const TextStyle(fontSize: 14),
                      maxLines: widget.isHomePage ? null : 2,
                      overflow: widget.isHomePage ? null : TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
