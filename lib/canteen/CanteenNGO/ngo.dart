import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/canteen/CanteenNGO/card_model.dart';
import 'package:projrect_annam/const/static_data.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';
import 'package:projrect_annam/utils/page_header.dart';
import 'package:projrect_annam/utils/shimmer.dart';

import '../../utils/color_data.dart';
import '../../utils/size_data.dart';

class CanteenNgo extends ConsumerStatefulWidget {
  const CanteenNgo({super.key, required this.canteenData});
  final Map<String, dynamic> canteenData;

  @override
  ConsumerState<CanteenNgo> createState() => _CanteenNgoState();
}

class _CanteenNgoState extends ConsumerState<CanteenNgo> {
  void createPost({
    required BuildContext context,
  }) {
    TextEditingController itemnamecontroller = TextEditingController();
    TextEditingController itemcountcontroller = TextEditingController();
    DateTime timenow = DateTime.now();
    CustomSizeData sizeData = CustomSizeData.from(context);

    double height = sizeData.height;
    double width = sizeData.width;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: 'Add Item',
                    size: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: itemnamecontroller,
                    decoration: InputDecoration(label: Text("Item Name")),
                  ),
                  TextField(
                    controller: itemcountcontroller,
                    decoration: InputDecoration(label: Text("Item Count")),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomText(
                      text:
                          "Current time : ${timenow.toString().substring(0, timenow.toString().length - 7)}")
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Save"),
                            Image.asset(
                              "assets/images/correct.png",
                              height: height * 0.03,
                              width: width * 0.1,
                            )
                          ],
                        ),
                        onPressed: () async {
                          if (itemcountcontroller.text.isNotEmpty &&
                              itemnamecontroller.text.isNotEmpty) {
                            FirebaseOperations.postToNgoOwners(
                              itemName: itemnamecontroller.text,
                              quantity: int.parse(
                                  itemcountcontroller.text.trim().toString()),
                              phoneNo: widget.canteenData['phoneNumber'],
                              image: widget.canteenData['image'],
                              address: widget.canteenData['address'],
                              collegeName: widget.canteenData['collegeName'],
                            ).whenComplete(() {
                              context.pop();
                            });
                          } else {
                            context.showSnackBar("Enter all the details");
                          }
                        }),
                    ElevatedButton(
                      child: Row(
                        children: [
                          Text("Cancel"),
                          Image.asset(
                            "assets/images/wrong.png",
                            height: height * 0.03,
                            width: width * 0.1,
                          )
                        ],
                      ),
                      onPressed: () => context.pop(),
                    )
                  ],
                )
              ]);
        });
  }

  List<List<String>> val = [
    ["poori", "20"],
    ["poori", "20"],
    ["poori", "20"],
  ];

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                PageHeader(
                  title: "NGO",
                  secondaryWidget: IconButton(
                      onPressed: () => createPost(context: context),
                      icon: Icon(Icons.abc)),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseOperations.firebaseInstance
                      .collection('ngo_posts')
                      .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!(snapshot.hasData && snapshot.data!.exists))
                      return ShimmerEffect();
                    Map<String, dynamic> allData = snapshot.data!.data() ?? {};
                    Map<String, dynamic> data = Map.from(allData)
                      ..remove('address')
                      ..remove('collegeName')
                      ..remove('image')
                      ..remove('phoneNumber');
                    List<String> timings = data.keys.toList();

                    if (timings.isNotEmpty)
                      return SizedBox(
                        height: height * 0.8,
                        child: ListView.builder(
                            itemCount: timings.length,
                            itemBuilder: (context, index) {
                              if (timings[index]
                                  .toString()
                                  .startsWith(currentDate)) {
                                Map<String, dynamic> finalData =
                                    Map.from(data[timings[index]])
                                      ..remove('checkOut')
                                      ..remove('notNeeded')
                                      ..remove('personPurchased');
                                String item = (finalData.keys.first);

                                return CanteenNgoCardModel(
                                  item: item,
                                  quantity:
                                      int.parse(finalData[item].toString()),
                                );
                              } else {
                                return null;
                              }
                            },),
                      );
                    return CustomText(text: "Please Use + icon to Post");
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
