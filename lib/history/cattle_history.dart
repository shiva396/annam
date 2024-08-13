import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:projrect_annam/canteen/home/expanded_card.dart';
import 'package:projrect_annam/const/static_data.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/size_data.dart';

import '../canteen/CanteenCattle/card_model.dart';
import '../firebase/firebase_operations.dart';
import '../utils/search.dart';
import '../utils/shimmer.dart';

class CanteenCattleHistoryData extends StatefulWidget {
  const CanteenCattleHistoryData({super.key, required this.selectedDate});
  final String selectedDate;

  @override
  State<CanteenCattleHistoryData> createState() =>
      _CanteenCattleHistoryDataState();
}

class _CanteenCattleHistoryDataState extends State<CanteenCattleHistoryData> {
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
            hintText: "Cattle"),
        SizedBox(
          height: height * 0.01,
        ),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseOperations.firebaseInstance
                .collection('cattle_posts')
                .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return ShimmerEffect();
              List cattleCheckedOutItems = [];
              List cattleNotpurchased = [];
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              print(data);

              data.forEach((k, v) {
                if (k.startsWith(widget.selectedDate)) {
                  Map<String, dynamic> values = data[k];
                  if (values.containsKey('personPurchased')) {
                    fetchDataFromCanteen(cattleId: values['personPurchased'])
                        .then((v) async {
                      values.addAll(v);
                    });
                    cattleCheckedOutItems.add(values);
                  } else {
                    values['time'] = k;
                    cattleNotpurchased.add(values);
                  }
                }
              });

              int count = 0;

              if (cattleNotpurchased.isNotEmpty) {
                return SizedBox(
                    // height: height * 0.67,
                    height: height * 0.63,
                    child: ListView(
                      children: List.generate(
                        cattleNotpurchased.length,
                        (index) => CanteenCattleCardModel(
                          itemweight:
                              cattleNotpurchased[index]['weight'].toString(),
                          time: cattleNotpurchased[index]['time'].toString(),
                        ),
                      ),
                    ));
              } else {
                if (count == 0 && cattleNotpurchased.isEmpty) {
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
