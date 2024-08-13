import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:projrect_annam/canteen/home/expanded_card.dart';
import 'package:projrect_annam/const/static_data.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/ngo/menu/card_model.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/search.dart';
import 'package:projrect_annam/utils/shimmer.dart';
import 'package:projrect_annam/utils/size_data.dart';

import '../../cattle/menu/card_model.dart';

class NgoHistoryData extends StatefulWidget {
  const NgoHistoryData({super.key, required this.selectedDate});
  final String selectedDate;

  @override
  State<NgoHistoryData> createState() => _NgoHistoryDataState();
}

class _NgoHistoryDataState extends State<NgoHistoryData> {
  TextEditingController searchController = TextEditingController();
  String studentSearchText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;
    return Column(
      children: [
        CustomSearchBar(
            onClear: () {
              setState(() {
                studentSearchText = "";
              });
            },
            onSubmitted: (c) {},
            onChanged: (v) {
              setState(() {
                studentSearchText = "";
                studentSearchText = v;
              });
            },
            controller: searchController,
            hintText: "Search by Order Id"),
        SizedBox(
          height: height * 0.01,
        ),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseOperations.firebaseInstance
                .collection('ngo')
                .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
                .collection('history')
                .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return ShimmerEffect();
              if (snapshot.data!.exists) {
                List todayData = [];
                List<Future<void>> futures = [];
                Map<String, dynamic> historyData =
                    snapshot.data!.data() as Map<String, dynamic>;
                historyData.forEach((k, v) {
                  if (k.toLowerCase().startsWith(widget.selectedDate)) {
                    print(historyData[k]);
                    futures.add(FirebaseOperations.fetchCanteenOwnerData(
                            collegeName: historyData[k]['collegeName'],
                            canteenOwnerID: historyData[k]['canteenId'])
                        .then((vv) {
                      Map<String, dynamic> item = v;
                      Map<String, dynamic> itemData = Map.from(v)
                        ..remove('collegeName')
                        ..remove('canteenId')
                        ..remove('personPurchased')
                        ..remove('checkOut')
                        ..remove('checkOut')
                        ..remove('notNeeded');
                      String itemName = itemData.keys.first;
                      item['collegeName'] = vv['collegeName'];
                      item['address'] = vv['address'] ?? "";
                      item['phoneNumber'] = vv['phoneNumber'] ?? "";
                      item['image'] = vv['image'] ?? "";
                      item['canteenOwnerId'] = historyData[k]['canteenId'];
                      item['time'] = k;
                      item['item'] = itemName;
                      item['quantity'] = itemData[itemName];
                      item['canteenName'] = vv['name'];
                      todayData.add(item);
                    }));
                  }
                });

                return FutureBuilder<void>(
                    future: Future.wait(futures),
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState !=
                          ConnectionState.done) {
                        return ShimmerEffect();
                      }

                      return SizedBox(
                        height: height * 0.65,
                        child: ListView.builder(
                          itemCount: todayData.length,
                          itemBuilder: (context, index) {
                            return NgoCardModel(
                              from: From.history,
                                canteenOwnerId: todayData[index]
                                    ['canteenOwnerId'],
                                time: todayData[index]['time'],
                                imageUrl: todayData[index]['image'],
                                phoneNo: todayData[index]['phoneNumber'],
                                canteenName: todayData[index]['collegeName'],
                                collegename: todayData[index]['collegeName'],
                                item: todayData[index]['item'],
                                quantity: todayData[index]['quantity'],
                                location: todayData[index]['address']);
                          },
                        ),
                      );
                    });
              } else {
                return CustomText(text: "No History Data");
              }

              // List<ExpandableCard> studentorderWidgets = [];
              // int studentcount = 0;

              // for (var doc in ) {
              //   Map<String, dynamic> dataMap = doc.data();
              //   String orderId = doc.id;

              //   // Access the single map field in the document
              //   String mapFieldName = dataMap.keys.first;
              //   String onlyDate = (mapFieldName.split(' ').first);

              //   // Check if the target date exists as a key in the map
              //   if (onlyDate.toString() == widget.selectedDate) {
              //     Map<String, dynamic> historyData = dataMap[mapFieldName];

              //     if (historyData['canteenId'] ==
              //         FirebaseOperations.firebaseAuth.currentUser!.uid) {
              //       studentcount += 1;
              //       if (orderId
              //           .toLowerCase()
              //           .startsWith(studentSearchText.toLowerCase())) {
              //         studentorderWidgets.add(ExpandableCard(
              //             from: From.history,
              //             orderedData: historyData,
              //             studentName: historyData['studentName'],
              //             orderId: orderId,
              //             studentId: historyData['studentId']));
              //       }
              //     }
              //   }
              // }
              // if (studentorderWidgets.isNotEmpty) {
              //   return SizedBox(
              //     height: height * 0.63,
              //     child: ListView(
              //       children: studentorderWidgets,
              //     ),
              //   );
              // }
              // if (studentcount == 0 && studentorderWidgets.isEmpty) {
              //   return Center(
              //     child:
              //         LottieBuilder.asset("assets/lottie/no data found.json"),
              //   );
              //  CustomText(
              //       text: "No Orders placed at this selected Date");
              // }
              // return CustomText(text: "Search not Found");
            }),
      ],
    );
  }
}
