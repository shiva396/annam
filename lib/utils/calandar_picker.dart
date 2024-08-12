import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/utils/search.dart';
import 'package:projrect_annam/utils/shimmer.dart';
import 'package:lottie/lottie.dart';

import '../canteen/home/expanded_card.dart';
import '../const/static_data.dart';
import '../firebase/firebase_operations.dart';
import 'custom_text.dart';
import 'size_data.dart';

class CalandarPicker extends StatefulWidget {
  final UserRole userRole;
  final String selectedDate;
  String? selectedRoleCanteenHistory;
  CalandarPicker(
      {super.key,
      required this.userRole,
      required this.selectedDate,
      this.selectedRoleCanteenHistory});

  @override
  State<CalandarPicker> createState() => _CalandarPickerState();
}

class _CalandarPickerState extends State<CalandarPicker> {
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

    return SingleChildScrollView(
        child: _buildSingleDatePickerWithValue(
      height: height,
    ));
  }

  Widget _buildSingleDatePickerWithValue({required double height}) {
    return SizedBox(
      width: 900,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: height * 0.02),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(
                text: 'Selected Date :  ',
              ),
              const SizedBox(height: 10),
              CustomText(
                text: widget.selectedDate,
              ),
              const SizedBox(height: 10),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
          if (UserRole.canteenOwner == widget.userRole) ...[
            if (widget.selectedRoleCanteenHistory == "Student") ...[
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

                      // Access the single map field in the document
                      String mapFieldName = dataMap.keys.first;
                      String onlyDate = (mapFieldName.split(' ').first);

                      // Check if the target date exists as a key in the map
                      if (onlyDate.toString() == widget.selectedDate) {
                        Map<String, dynamic> historyData =
                            dataMap[mapFieldName];

                        if (historyData['canteenId'] ==
                            FirebaseOperations.firebaseAuth.currentUser!.uid) {
                          count += 1;
                          if (orderId
                              .toLowerCase()
                              .startsWith(studentSearchText.toLowerCase())) {
                            orderWidgets.add(ExpandableCard(
                                from: From.history,
                                orderedData: historyData,
                                studentName: historyData['studentName'],
                                orderId: orderId,
                                studentId: historyData['studentId']));
                          }
                        }
                      }
                    }
                    if (orderWidgets.isNotEmpty)
                      return SizedBox(
                        height: 200,
                        child: ListView(
                          children: orderWidgets,
                        ),
                      );
                    if (count == 0 && orderWidgets.isEmpty) {
                      return Center(
                      child: LottieBuilder.asset(
                          "assets/lottie/no data found.json"),
                    );
                     CustomText(
                          text: "No Orders placed at this selected Date");
                    }
                    return CustomText(text: "Search not Found");
                  }),
            ],
            if (widget.selectedRoleCanteenHistory == "Cattle") ...[
              CustomSearchBar(
                  onClear: () {
                    setState(() {});
                  },
                  onSubmitted: (c) {},
                  onChanged: (v) {
                    setState(() {});
                  },
                  controller: searchController,
                  hintText: "Search by Order Id"),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseOperations.firebaseInstance
                      .collection('cattle_posts')
                      .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return ShimmerEffect();
                    List checkedOutItems = [];
                    List notpurchased = [];
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;

                    data.forEach((k, v) {
                      if (k.startsWith(widget.selectedDate)) {
                        Map<String, dynamic> values = data[k];
                        if (values.containsKey('personPurchased')) {
                          fetchDataFromCanteen(
                                  cattleId: values['personPurchased'])
                              .then((v) async {
                            values.addAll(v);
                          });
                          checkedOutItems.add(values);
                        } else {
                          values['time'] = k;
                          notpurchased.add(values);
                        }
                      }
                    });

                    int count = 0;

                    if (checkedOutItems.isNotEmpty)
                      return SizedBox(
                        height: 200,
                        child: ListView(
                            children: List.generate(
                                checkedOutItems.length,
                                (index) => Text(checkedOutItems[index]['weight']
                                    .toString()))),
                      );
                    if (count == 0 && checkedOutItems.isEmpty) {
                      return CustomText(
                          text: "No Orders placed at this selected Date");
                    }
                    return CustomText(text: "Search not Found");
                  }),
            ],
            if (widget.selectedRoleCanteenHistory == "Ngo") ...[
              CustomSearchBar(
                  onClear: () {
                    setState(() {});
                  },
                  onSubmitted: (c) {},
                  onChanged: (v) {
                    setState(() {});
                  },
                  controller: searchController,
                  hintText: "Search by Order Id"),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseOperations.firebaseInstance
                      .collection('ngo_posts')
                      .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return ShimmerEffect();
                    List checkedOutItems = [];
                    List notpurchased = [];
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;

                    data.forEach((k, v) {
                      if (k.startsWith(widget.selectedDate)) {
                        Map<String, dynamic> values = data[k];
                        print(values);
                        Map<String, dynamic> filteredData = Map.from(values)
                          ..remove('checkOut')
                          ..remove('notNeeded')
                          ..remove('personPurchased');
                        String itemName = filteredData.keys.first;
                        String quantity = filteredData[itemName].toString();
                        values['itemName'] = itemName;
                        values['quantity'] = quantity;
                        if (values.containsKey('personPurchased')) {
                          fetchDataFromNgo(cattleId: values['personPurchased'])
                              .then((v) async {
                            values.addAll(v);
                          });
                          checkedOutItems.add(values);
                        } else {
                          values['time'] = k;
                          notpurchased.add(values);
                        }
                      }
                    });

                    int count = 0;

                    if (checkedOutItems.isNotEmpty)
                      return SizedBox(
                        height: 200,
                        child: ListView(
                            children: List.generate(
                                checkedOutItems.length,
                                (index) => Text(checkedOutItems[index]
                                        ['itemName']
                                    .toString()))),
                      );
                    if (count == 0 && checkedOutItems.isEmpty) {
                      return CustomText(
                          text: "No Orders placed at this selected Date");
                    }
                    return CustomText(text: "Search not Found");
                  }),
            ]
          ],
          if (UserRole.student == widget.userRole) ...[
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
                      height: 200,
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
          ]
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>> fetchDataFromCanteen(
    {required String cattleId}) async {
  DocumentSnapshot<Map<String, dynamic>> innersnapshot =
      await FirebaseOperations.firebaseInstance
          .collection('cattle_owner')
          .doc(cattleId)
          .get();
  Map<String, dynamic> data = innersnapshot.data() as Map<String, dynamic>;

  return data;
}

Future<Map<String, dynamic>> fetchDataFromNgo(
    {required String cattleId}) async {
  DocumentSnapshot<Map<String, dynamic>> innersnapshot =
      await FirebaseOperations.firebaseInstance
          .collection('ngo')
          .doc(cattleId)
          .get();
  Map<String, dynamic> data = innersnapshot.data() as Map<String, dynamic>;

  return data;
}
