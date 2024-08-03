import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projrect_annam/helper/helper.dart';
import 'package:rive/rive.dart';

// snackbar
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customBar(
    {required BuildContext context, required String text}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(5.0),
      content: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
      ),
    ),
  );
}

// Show loading
Future<void> loadingImage(
    {required BuildContext context, required String imagePath}) async {
  return context.push(await showDialog(
    barrierColor: Colors.transparent,
    context: context,
    builder: (context) => Container(
      height: 500,
      width: 500,
      child: RiveAnimation.asset(
        behavior: RiveHitTestBehavior.translucent,
        imagePath,
      ),
    ),
  ));
}

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

