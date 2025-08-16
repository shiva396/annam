import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/utils/custom_network_image.dart';
import 'package:projrect_annam/utils/custom_text.dart';

import '../../const/static_data.dart';
import '../../utils/color_data.dart';
import '../../utils/size_data.dart';

class CattleCardModel extends ConsumerWidget {
  const CattleCardModel(
      {super.key,
      required this.from,
      required this.phoneNumber,
      required this.canteenOwnerId,
      required this.time,
      required this.imageUrl,
      required this.collegename,
      required this.weight,
      required this.location});
  final String collegename;
  final String imageUrl;
  final String phoneNumber;

  final String weight;
  final  From from;
  final String time;
  final String canteenOwnerId;
  final String location;

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
                    url: imageUrl.isEmpty ? null : imageUrl,
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
                    text: "Weight : ",
                    color: colorData.fontColor(1),
                    size: sizeData.subHeader,
                  ),
                  CustomText(
                    text: weight.toString(),
                    color: colorData.fontColor(1),
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
                        FirebaseOperations.acceptCanteenCattlePost(
                          collegeName: collegename,
                          canttenOwnerId: canteenOwnerId,
                          timeKey: time,
                        );
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      child: Text("Decline"),
                      onPressed: () {
                        FirebaseOperations.declineCanteenCanttlePost(
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
