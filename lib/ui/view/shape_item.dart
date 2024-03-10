import 'package:flutter/material.dart';

class ShapeItem extends StatelessWidget {
  const ShapeItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        width: double.infinity,
        height: 150,
        color: const Color.fromRGBO(214, 188, 246, 1),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 4, size.height / 2, size.width / 2, size.height);
    path.quadraticBezierTo(size.width * 3 / 4, size.height / 2, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}