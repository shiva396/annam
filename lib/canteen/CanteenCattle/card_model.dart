import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/utils/color_data.dart';
import 'package:projrect_annam/utils/custom_network_image.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/size_data.dart';

class CanteenCattleCardModel extends ConsumerWidget {
  CanteenCattleCardModel({required this.time, required this.itemweight});

  final String itemweight;
  final String time;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;
    CustomColorData colorData = CustomColorData.from(ref);
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Container(
        decoration:
            BoxDecoration(color: colorData.secondaryColor(1), boxShadow: [
          BoxShadow(
              color: Colors.black38,
              offset: Offset(2, 2),
              spreadRadius: 3,
              blurRadius: 5)
        ]),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                children: [
                  CustomText(
                    text: "Time : ",
                    color: colorData.fontColor(1),
                    size: sizeData.subHeader,
                  ),
                  CustomText(
                    text: time,
                    size: sizeData.regular,
                  )
                ],
              ),
              Row(
                children: [
                  CustomText(
                    text: "Item Weight: ",
                    color: colorData.fontColor(1),
                    size: sizeData.subHeader,
                  ),
                  CustomText(
                    text: itemweight,
                    size: sizeData.regular,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
