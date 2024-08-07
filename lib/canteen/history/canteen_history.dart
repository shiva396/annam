import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/utils/calandar_picker.dart';

import '../../students/orders/my_order.dart';
import '../../utils/color_data.dart';
import '../../utils/custom_text.dart';
import '../../utils/size_data.dart';

class CanteenHistory extends ConsumerStatefulWidget {
  const CanteenHistory({super.key});

  @override
  ConsumerState<CanteenHistory> createState() => _CanteenHistoryState();
}

class _CanteenHistoryState extends ConsumerState<CanteenHistory> {
  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;
    CustomColorData colorData = CustomColorData.from(ref);
    return SafeArea(
      child: Scaffold(
          body: Container(
        margin: EdgeInsets.only(
          left: width * 0.04,
          right: width * 0.04,
          top: height * 0.02,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "History",
                  size: sizeData.header,
                  color: colorData.fontColor(1),
                ),
              ],
            ),
            CalandarPicker(),
          ],
        ),
      )),
    );
  }
}
