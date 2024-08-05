import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'color_data.dart';
import 'custom_back_button.dart';
import 'custom_text.dart';
import 'size_data.dart';

class PageHeader extends ConsumerWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.secondaryWidget,
  });
  final String title;
  final Widget? secondaryWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: Alignment.center,
          child: CustomText(
            text: title.toUpperCase(),
            size: sizeData.header,
            color: colorData.fontColor(1),
            weight: FontWeight.w600,
            height: 2,
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          child: CustomBackButton(),
        ),
        secondaryWidget != null
            ? Positioned(right: 0, child: secondaryWidget!)
            : const SizedBox()
      ],
    );
  }
}
