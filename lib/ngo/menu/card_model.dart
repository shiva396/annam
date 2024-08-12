import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/utils/custom_network_image.dart';
import 'package:projrect_annam/utils/custom_text.dart';

import '../../utils/color_data.dart';
import '../../utils/size_data.dart';

class CardModel extends ConsumerWidget {
  const CardModel(
      {super.key,
      required this.collegename,
      required this.canteenOwnerId,
      required this.item,
      required this.imageUrl,
      required this.canteenName,
      required this.phoneNo,
      required this.time,
      required this.quantity,
      required this.location});
  final String collegename;
  final String item;
  final int quantity;
  final String location;
  final String imageUrl;
  final String time;
  final String canteenOwnerId;
  final String canteenName;
  final String phoneNo;

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
                    url: imageUrl.isNotEmpty ? imageUrl : null,
                    size: 50,
                    radius: 50,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: CustomText(
                        text: collegename,
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
                    text: "Quantity : ",
                    color: colorData.fontColor(1),
                    size: sizeData.subHeader,
                  ),
                  CustomText(
                    text: quantity.toString(),
                    color: colorData.fontColor(1),
                    size: sizeData.regular,
                  )
                ],
              ),
              Row(
                children: [
                  CustomText(
                    text: "Item : ",
                    color: colorData.fontColor(1),
                    size: sizeData.subHeader,
                  ),
                  CustomText(
                    text: item,
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
                    text: location,
                    maxLine: 3,
                    size: sizeData.regular,
                    align: TextAlign.justify,
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      child: Text("Accept"),
                      onPressed: () {
                        FirebaseOperations.acceptCanteenNgoPost(
                            canttenOwnerId: canteenOwnerId,
                            timeKey: time,
                            canteenName: canteenName,
                            phoneNo: phoneNo);
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      child: Text("Decline"),
                      onPressed: () {
                        FirebaseOperations.declineCanteenNgoPost(
                            canttenOwnerId: canteenOwnerId, timeKey: time);
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
