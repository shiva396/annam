import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/canteen/CanteenCattle/card_model.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';

import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';
import 'package:projrect_annam/utils/page_header.dart';
import 'package:projrect_annam/utils/shimmer.dart';

import '../../utils/color_data.dart';
import '../../utils/size_data.dart';

class CanteenCattle extends ConsumerStatefulWidget {
  final Map<String, dynamic> canteenData;
  const CanteenCattle({required this.canteenData, super.key});

  @override
  ConsumerState<CanteenCattle> createState() => _CanteenCattleState();
}

class _CanteenCattleState extends ConsumerState<CanteenCattle> {
  void createPost({required BuildContext context}) {
    TextEditingController itemweightcontroller = TextEditingController();
    CustomSizeData sizeData = CustomSizeData.from(context);

    double height = sizeData.height;
    double width = sizeData.width;
    DateTime timenow = DateTime.now();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: 'Add Details',
                    size: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: itemweightcontroller,
                    decoration: InputDecoration(label: Text("Weight in Kg")),
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
                          FirebaseOperations.postToCattleOwners(
                                  phoneNo: widget.canteenData['phoneNumber'],
                                  image: widget.canteenData['image'],
                                  address: widget.canteenData['address'],
                                  collegeName:
                                      widget.canteenData['collegeName'],
                                  weight: double.parse(
                                      itemweightcontroller.text.trim()))
                              .whenComplete(() {
                            context.pop();
                          });
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
    ["20"],
    ["20"],
    ["20"],
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
                  title: "Cattle",
                  secondaryWidget: IconButton(
                      onPressed: () {
                        createPost(context: context);
                      },
                      icon: Icon(Icons.abc)),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseOperations.firebaseInstance
                        .collection('cattle_posts')
                        .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData && !snapshot.data!.exists)
                        return ShimmerEffect();
                      Map<String, dynamic> allData =
                          snapshot.data!.data() ?? {};
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
                                  return CanteenCattleCardModel(
                                      time: timings[index],
                                      itemweight: data[timings[index]]['weight']
                                          .toString());
                                }));
                      return CustomText(text: "Please Use + icon to Post");
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
