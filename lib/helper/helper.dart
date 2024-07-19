// push , pop in Buildcontext

import 'package:flutter/material.dart';

extension FlutterNavigation on BuildContext {
  Future push<T>(Widget route) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) => route));
  }
}

extension Flutter on BuildContext {
  void pop<T>(Widget route, [T? result]) {
    return Navigator.of(this).pop<T>(result);
  }
}

extension FlutterLog on BuildContext {
  Future pushReplacement<T>(Widget route) {
    return Navigator.of(this)
        .pushReplacement(MaterialPageRoute(builder: (_) => route));
  }
}
