import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/const/static_data.dart';

import '../../firebase/firebase_operations.dart';
import '../../utils/color_data.dart';
import '../../utils/custom_text.dart';
import '../../utils/shimmer.dart';
import '../../utils/size_data.dart';
import 'card_model.dart';

class NgoHome extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(
        left: width * 0.04,
        right: width * 0.04,
        top: height * 0.02,
      ),
      child: Column(
        children: [
          CustomText(
            text: "Today Deals",
            size: sizeData.superHeader,
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseOperations.firebaseInstance
                  .collection('ngo_posts')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return ShimmerEffect();
                List todayData = [];
                List<Future<void>> futures = [];

                for (var i in snapshot.data!.docs) {
                  Map<String, dynamic> data = i.data();
                  String collegeName = i.data()['collegeName'];
                  String? address;
                  String? phoneNumber;
                  String? image;
                  String? canteenName;
                  futures.add(FirebaseOperations.fetchCanteenOwnerData(
                          collegeName: collegeName, canteenOwnerID: i.id)
                      .then((vv) {
                    address = (vv['address']);
                    phoneNumber = vv['phoneNumber'];
                    canteenName = vv['name'];

                    image = vv['image'];

                    data.forEach((k, v) {
                      String? itemName;
                      Map<String, dynamic>? itemData;

                      if (data[k] is Map<String, dynamic>) {
                        itemData = Map.from(data[k])
                          ..remove('checkOut')
                          ..remove('notNeeded');
                        itemName = itemData.keys.first;
                      }

                      if (k.startsWith(currentDate)) {
                        Map<String, dynamic> item = v;

                        item['collegeName'] = collegeName;
                        item['address'] = address ?? "";
                        item['phoneNumber'] = phoneNumber ?? "";
                        item['image'] = image ?? "";
                        item['canteenOwnerId'] = i.id;
                        item['time'] = k;
                        item['item'] = itemName;
                        item['quantity'] = itemData![itemName];
                        item['canteenName'] = canteenName ?? "";

                        if (data[k]['checkOut'] == false) {
                          List<dynamic> notNeededDynamic = data[k]['notNeeded'];
                          if (!(notNeededDynamic.contains(FirebaseOperations
                                  .firebaseAuth.currentUser!.uid)) &&
                              data[k]['checkOut'] == false) {
                            todayData.add(item);
                          }
                        }
                      }
                    });
                    
                  }));
                }

                return FutureBuilder<void>(
                    future: Future.wait(futures),
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState !=
                          ConnectionState.done) {
                        return ShimmerEffect();
                      }

                      return Expanded(
                        child: ListView.builder(
                          itemCount: todayData.length,
                          itemBuilder: (context, index) {
                            return NgoCardModel(
                              from: From.orders,
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
              })
        ],
      ),
    ));
  }
}

List<List<String>> val = [
  [
    "Sri Sai Insitute of technology",
    "Chappati",
    "20",
    "Sai Leo Nagar,West Tambaram Poonthandalam, Village, Chennai, Tamil Nadu 602109"
  ]
];
