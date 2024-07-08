import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Lottie.asset(
        'assets/lottie/loading_animation.json',
        fit: BoxFit.fill,
      ),
    );
  }
}
