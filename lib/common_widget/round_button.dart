import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../const/color_extension.dart';
import '../utils/color_data.dart';
import '../utils/custom_text.dart';

enum RoundButtonType { bgPrimary, textPrimary }

class RoundButton extends ConsumerWidget {
  final VoidCallback onPressed;
  final String title;
  final RoundButtonType type;
  final double fontSize;
  const RoundButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.fontSize = 16,
      this.type = RoundButtonType.bgPrimary});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        CustomColorData colorData = CustomColorData.from(ref);
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: type == RoundButtonType.bgPrimary ? null : Border.all(color:colorData.primaryColor(.9) , width: 1),
          color: type == RoundButtonType.bgPrimary ?  colorData.primaryColor(.9): colorData.secondaryColor(.9),
          borderRadius: BorderRadius.circular(28),
        ),
        child:CustomText(
         text: title,
          
        ),
      ),
    );
  }
}
