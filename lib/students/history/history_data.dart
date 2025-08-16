import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/canteen/home/expanded_card.dart';
import 'package:projrect_annam/const/static_data.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/utils/search.dart';
import 'package:projrect_annam/utils/shimmer.dart';
import 'package:projrect_annam/utils/size_data.dart';

import '../../utils/custom_text.dart';

class StudentHistoryData extends StatefulWidget {
  const StudentHistoryData({super.key, required this.selectedDate});
  final String selectedDate;

  @override
  State<StudentHistoryData> createState() => _StudentHistoryDataState();
}

class _StudentHistoryDataState extends State<StudentHistoryData> {
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
        SizedBox(
          height: height * 0.02,
        ),
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
            hintText: "Search by Canteen Name"),
        SizedBox(
          height: height * 0.02,
        ),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseOperations.firebaseInstance
                .collection('orders_history')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return ShimmerEffect();
              List<ExpandableCard> orderWidgets = [];
              int count = 0;

              for (var doc in snapshot.data!.docs) {
                Map<String, dynamic> dataMap = doc.data();
                String orderId = doc.id;

                String mapFieldName = dataMap.keys.first;

                if (mapFieldName.startsWith(widget.selectedDate)) {
                  Map<String, dynamic> historyData = dataMap[mapFieldName];
                  if (historyData['studentId'] ==
                      FirebaseOperations.firebaseAuth.currentUser!.uid) {
                    count += 1;
                    if (historyData['canteenName']
                        .toString()
                        .toLowerCase()
                        .startsWith(studentSearchText.toLowerCase())) {
                      orderWidgets.add(ExpandableCard(
                          from: From.history,
                          orderedData: historyData,
                          studentName: historyData['canteenName'],
                          orderId: orderId,
                          studentId: historyData['studentId']));
                    }
                  }
                }
              }
              if (orderWidgets.isNotEmpty) {
                return SizedBox(
                  height: height * 0.63,
                  child: ListView(
                    children: orderWidgets,
                  ),
                );
              }
              if (orderWidgets.isEmpty && count == 0)
                return CustomText(
                    text: "No Orders placed at this selected Date");
              return CustomText(text: "Search Not Found");
            })
      ],
    );
  }
}
