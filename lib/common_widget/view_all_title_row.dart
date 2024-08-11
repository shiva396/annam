import 'package:flutter/material.dart';

import '../utils/custom_text.dart';

class ViewAllTitleRow extends StatelessWidget {
  final String title;
  final VoidCallback onView;
  const ViewAllTitleRow({super.key, required this.title, required this.onView });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       CustomText(
        text:   title,
          
        ),
        TextButton(
          onPressed: onView,
          child:CustomText(
          text:   "View all",
           
          ),
        ),
      ],
    );
  }
}