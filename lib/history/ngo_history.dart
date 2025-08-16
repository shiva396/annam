import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/canteen/CanteenNGO/card_model.dart';
import 'package:projrect_annam/utils/search.dart';

import '../firebase/firebase_operations.dart';
import '../utils/custom_text.dart';
import '../utils/shimmer.dart';
import '../utils/size_data.dart';

class CanteenNgoHistoryData extends StatefulWidget {
  const CanteenNgoHistoryData({super.key, required this.selectedDate});
  final String selectedDate;

  @override
  State<CanteenNgoHistoryData> createState() => _CanteenNgoHistoryDataState();
}

class _CanteenNgoHistoryDataState extends State<CanteenNgoHistoryData> {
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
              setState(() {});
            },
            onSubmitted: (c) {},
            onChanged: (v) {
              setState(() {});
            },
            controller: searchController,
            hintText: "NGO"),
        SizedBox(
          height: height * 0.01,
        ),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseOperations.firebaseInstance
                .collection('ngo_posts')
                .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
                .snapshots(),
            builder: (context, ngosnapshot) {
              if (!ngosnapshot.hasData) return ShimmerEffect();

              List ngoCheckedOutItems = [];
              List ngoNotpurchased = [];
              Map<String, dynamic> datas =
                  ngosnapshot.data!.data() as Map<String, dynamic>;

              datas.forEach((key, v) {
                if (key.startsWith(widget.selectedDate)) {
                  Map<String, dynamic> value = datas[key];

                  Map<String, dynamic>? filtered = Map.from(value)
                    ..remove('checkOut')
                    ..remove('notNeeded')
                    ..remove('personPurchased');

                  String itemName = filtered.keys.first;

                  value['itemName'] = itemName;

                  value['quantity'] = filtered[itemName];

                  if (value.containsKey('personPurchased')) {
                    fetchDataFromNgo(cattleId: value['personPurchased'])
                        .then((v) async {
                      value.addAll(v);
                    });
                    ngoCheckedOutItems.add(value);
                  } else {
                    value['time'] = key;
                    ngoNotpurchased.add(value);
                  }
                }
              });

              int count = 0;

              if (ngoNotpurchased.isNotEmpty) {
                return SizedBox(
                    height: height * 0.63,
                    child: ListView(
                        children: List.generate(
                            ngoNotpurchased.length,
                            (index) => CanteenNgoCardModel(
                                  item: ngoNotpurchased[index]['itemName'],
                                  quantity: ngoNotpurchased[index]['quantity'],
                                ))));
              } else {
                if (count == 0 && ngoNotpurchased.isEmpty) {
                  return CustomText(
                      text: "No Orders placed at this selected Date");
                }
                return CustomText(text: "Search not Found");
              }
            }),
      ],
    );
  }
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
