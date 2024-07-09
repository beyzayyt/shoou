import 'package:flutter/material.dart';

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
  late List<bool>? showFullText;

  @override
  void initState() {
    super.initState();
    showFullText = widget.isHomePage ? List<bool>.filled(widget.blog.length, false) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        height: widget.isHomePage ? null : MediaQuery.of(context).size.height / 2,
        child: ListView.separated(
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
                        width: widget.isHomePage ? MediaQuery.of(context).size.width - 20 : MediaQuery.of(context).size.width - 100,
                        child: GestureDetector(
                          onTap: () => _toggleText(index),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 2,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      (data['userProfilePhoto'] == null || data['userProfilePhoto'].isEmpty)
                                          ? const Icon(
                                              Icons.person,
                                              size: 30,
                                            )
                                          : SizedBox(
                                              width: 30,
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(data['userProfilePhoto']),
                                              ),
                                            ),
                                      const SizedBox(
                                        width: 24,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['username'] != null ? data['username'].toString().toUpperCase() : 'Anonymous',
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                            ),
                                            Text(
                                              data['title'] ?? '',
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
                                            ),
                                            Text(
                                              data['content'] ?? '',
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87),
                                              maxLines: widget.isHomePage ? (!showFullText![index] ? 2 : null) : null,
                                              overflow: widget.isHomePage ? (!showFullText![index] ? TextOverflow.ellipsis : null) : null,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      HomePageIconButton(homeicon: HomeIcons.like),
                                      HomePageIconButton(homeicon: HomeIcons.commnet),
                                      HomePageIconButton(homeicon: HomeIcons.share),
                                    ],
                                  ),
                                ],
                              ),
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

  void _toggleText(int index) {
    setState(() {
      showFullText![index] = !showFullText![index];
    });
  }
}

enum HomeIcons {
  like,
  commnet,
  share,
}

// ignore: must_be_immutable
class HomePageIconButton extends StatelessWidget {
  HomeIcons? homeicon;
  HomePageIconButton({
    this.homeicon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 20,
      icon: getIcon(homeicon!),
      color: Theme.of(context).primaryColor,
      onPressed: () {
        // Handle like button press
      },
    );
  }

  Icon getIcon(HomeIcons icon) {
    if (icon == HomeIcons.like) {
      return const Icon(Icons.thumb_up);
    } else if (icon == HomeIcons.commnet) {
      return const Icon(Icons.comment);
    }
    return const Icon(Icons.share);
  }
}
