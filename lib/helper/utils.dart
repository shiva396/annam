import 'package:flutter/material.dart';

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

// toCamelCase

String toTitle({required String text}) {
  return text.substring(0).toUpperCase() +
      text.substring(1, text.length).toLowerCase();
}

String toLowerString({required String text}) {
  return text.toLowerCase();
}
