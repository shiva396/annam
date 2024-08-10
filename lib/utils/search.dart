import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common_widget/round_textfield.dart';
import '../const/image_const.dart';
import 'color_data.dart';
import 'size_data.dart';

class CustomSearchBar extends ConsumerWidget {
  final void Function(String) onChanged;
  final void Function(String) onSubmitted;
  final void Function() onClear;
  final TextEditingController controller;
  final String hintText;
  const CustomSearchBar(
      {required this.onChanged,
      required this.onSubmitted,
      required this.onClear,
      required this.controller,
      required this.hintText,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RoundTextfield(
        onChanged: onChanged,
        hintText: hintText,
        controller: controller,
        onSubmitted: onSubmitted,
        right: GestureDetector(
          onTap: () {
            controller.clear();
            onClear();
          },
          child: Container(
            alignment: Alignment.center,
            width: width * 0.08,
            child: Image.asset(
              ImageConst.wrong,
              width: sizeData.superLarge,
              height: sizeData.subHeader,
            ),
          ),
        ),
        left: Container(
          alignment: Alignment.center,
          width: width * 0.08,
          child: Image.asset(
            ImageConst.search,
            width: sizeData.superLarge,
            height: sizeData.superLarge,
          ),
        ),
      ),
    );
  }
}
