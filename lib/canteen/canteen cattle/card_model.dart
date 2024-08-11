import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/utils/color_data.dart';
import 'package:projrect_annam/utils/custom_network_image.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/size_data.dart';

class CanteenCattleCardModel extends ConsumerWidget {
  CanteenCattleCardModel(
      {this.collegename,
      required this.itemweight,

      this.location});

  final String? collegename;
  final String itemweight;
  final String? location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;
    CustomColorData colorData = CustomColorData.from(ref);
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomNetworkImage(
                    size: 50,
                    radius: 50,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: CustomText(
                        text: collegename ?? "Sairam",
                        size: sizeData.superHeader,
                        color: colorData.fontColor(1)),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
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
              Wrap(
                children: [
                  CustomText(
                    text: "Location : ",
                    color: colorData.fontColor(1),
                    size: sizeData.subHeader,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    color: colorData.fontColor(1),
                    text: location ?? "Chennai",
                    maxLine: 3,
                    size: sizeData.regular,
                    align: TextAlign.justify,
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
