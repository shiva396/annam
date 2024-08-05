import 'package:flutter/material.dart';

import '../const/color_extension.dart';
import '../utils/custom_text.dart';

class TabButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String icon;
  final bool isSelected;
  const TabButton(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 19,
            height: 19,
            // color: isSelected ? TColor.primary : TColor.placeholder,
          ),
          const SizedBox(
            height: 4,
          ),
          CustomText(
         text:    title,
            // style: TextStyle(
            //   color: isSelected ? TColor.primary : TColor.placeholder,
            //   fontSize: 12,
            //   fontWeight: FontWeight.w500,
            // ),
          )
        ],
      ),
    );
  }
}
