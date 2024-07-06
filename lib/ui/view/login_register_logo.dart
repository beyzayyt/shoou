import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginRegisterTitleLogo extends StatelessWidget {
  const LoginRegisterTitleLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/image/first_title.svg',
        ),
        const SizedBox(
          height: 16,
        ),
        SvgPicture.asset(
          'assets/image/second_title.svg',
        ),
      ],
    );
  }
}
