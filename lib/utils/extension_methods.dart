import 'package:flutter/material.dart';

import 'custom_text.dart';

extension FlutterNavigation on BuildContext {
  Future push<T>(Widget route) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) => route));
  }

  void pop<T>([T? result]) {
    return Navigator.of(this).pop<T>();
  }

  Future pushReplacement<T>(Widget route) {
    return Navigator.of(this)
        .pushReplacement(MaterialPageRoute(builder: (_) => route));
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
          content: Center(
        child: CustomText(
          maxLine: 4,
          text: message,
          color: Colors.white,
          weight: FontWeight.w700,
        ),
      )),
    );
  }
}
