import 'package:flutter/material.dart';

enum UserRole {
  student,
  canteenOwner,
  cattleOwner,
  ngo;

  get asString {
    switch (this) {
      case UserRole.student:
        return 'student';
      case UserRole.canteenOwner:
        return 'canteen_owner';
      case UserRole.cattleOwner:
        return 'cattle_owner';
      case UserRole.ngo:
        return 'ngo';
      default:
        return 'unknown';
    }
  }
}

const List<Color> primaryColors = [
  Color(0XFFFFAA57),
  Color(0XFF5D44F8),
  Color(0XFFFA61D7),
  Color(0XFF2ADDC7),
];

enum From { history, orders }

String currentDate = DateTime.now().toString().split(' ').first;
