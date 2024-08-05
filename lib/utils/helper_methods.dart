import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

Widget overlayContent(
    {required BuildContext context, required String imagePath}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: 500,
        width: 500,
        child: RiveAnimation.asset(
          behavior: RiveHitTestBehavior.translucent,
          imagePath,
        ),
      ),
    ],
  );
}
