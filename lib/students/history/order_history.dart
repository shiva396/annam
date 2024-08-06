import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/utils/extension_methods.dart';

import '../../canteen/calandar_picker.dart';
import '../../const/image_const.dart';
import '../../utils/color_data.dart';
import '../../utils/custom_text.dart';
import '../../utils/size_data.dart';
import '../orders/my_order.dart';

class StudentHistory extends ConsumerStatefulWidget {
  const StudentHistory({super.key});

  @override
  ConsumerState<StudentHistory> createState() => _StudentHistoryState();
}

class _StudentHistoryState extends ConsumerState<StudentHistory> {
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
                IconButton(
                  onPressed: () {
                    context.push(MyOrderView());
                  },
                  icon: Image.asset(
                    ImageConst.shoppingCart,
                    width: sizeData.superLarge,
                    height: sizeData.superLarge,
                  ),
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
