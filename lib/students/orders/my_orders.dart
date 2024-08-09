import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/utils/color_data.dart';
import 'package:projrect_annam/utils/extension_methods.dart';
import 'package:projrect_annam/utils/helper_methods.dart';
import 'package:projrect_annam/utils/page_header.dart';
import 'package:projrect_annam/utils/size_data.dart';

import '../../firebase/firebase_operations.dart';
import '../../utils/custom_text.dart';

class MyOrders extends ConsumerStatefulWidget {
  const MyOrders({
    super.key,
  });

  @override
  ConsumerState<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends ConsumerState<MyOrders> {
  bool _showLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _showLoading = false;
      });
    });
  }

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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              PageHeader(
                title: "My Orders",
              ),
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseOperations.firebaseInstance
                      .collection('student')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, outersnapshot) {
                    if (!outersnapshot.hasData || _showLoading)
                      return overlayContent(
                          context: context,
                          imagePath: "assets/rive/loading.riv");
                    String collegeName = outersnapshot.data!.get('collegeName');
                    return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseOperations.firebaseInstance
                            .collection('student')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('orders')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return overlayContent(
                                context: context,
                                imagePath: "assets/rive/loading.riv");
                          }

                          if (snapshot.hasError && collegeName.isNotEmpty) {
                            return overlayContent(
                                context: context, imagePath: "");
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: CustomText(text: "No orders found."),
                            );
                          }
                          Map<String, dynamic> data = snapshot.data!.docs.first
                              .data()! as Map<String, dynamic>;
                          print(data);
                          List<String> orderedIds = data.keys.toList();
                          List<String> canteenName = [];
                          List<String> canteenIds = [];
                          List<String> timing = [];
                          List<String> totalAmount = [];
                          List<bool> checkouts = [];
                          Map<String, dynamic> filteredData = {};
                          for (var key in data.keys) {
                            Map<String, dynamic> specificData = data[key];
                            canteenName.add(specificData['canteenName']);
                            canteenIds.add(specificData['canteenId']);
                            timing.add(specificData['time']);
                            totalAmount.add(specificData['totalAmount']);
                            checkouts.add(specificData['checkOut']);
                            filteredData.addAll(Map.from(specificData)
                              ..remove('totalAmount')
                              ..remove('checkOut')
                              ..remove('canteenId')
                              ..remove('canteenName')
                              ..remove('time'));
                          }
                          print(filteredData);

                          return SizedBox(
                            height: 750,
                            child: ListView.builder(
                                itemCount: orderedIds.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        CustomText(
                                          text:
                                              "Order Id : " + orderedIds[index],
                                          size: sizeData.header,
                                          color: colorData.fontColor(1),
                                        ),
                                        CustomText(
                                          text: "Name : " + canteenName[index],
                                          size: sizeData.header,
                                          color: colorData.fontColor(1),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  colorData.secondaryColor(.9)),
                                          child: ListView.separated(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            itemCount: filteredData.length,
                                            separatorBuilder:
                                                ((context, index) => Divider(
                                                      indent: 25,
                                                      endIndent: 25,
                                                      color: colorData
                                                          .primaryColor(1),
                                                      height: 2,
                                                    )),
                                            itemBuilder: ((context, index) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 25),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: CustomText(
                                                        text: filteredData[index
                                                                    .toString()]
                                                                ['name'] +
                                                            "  *  " +
                                                            filteredData[index
                                                                    .toString()]
                                                                ['quantity'],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    CustomText(
                                                      text: filteredData[index
                                                                  .toString()]
                                                              ['price'] +
                                                          " \u{20B9}",
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    text: "Sub Total",
                                                  ),
                                                  CustomText(
                                                    text: "68 \u{20B9}",
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    text: "Delivery Cost",
                                                  ),
                                                  CustomText(
                                                    text: "2 \u{20B9}",
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Divider(
                                                color:
                                                    colorData.primaryColor(1),
                                                height: 2,
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    text: "Total",
                                                  ),
                                                  CustomText(
                                                    text: totalAmount[index]
                                                            .toString() +
                                                        ' \u{20B9}',
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 25,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          );
                        });
                  }),
            ]),
          ),
        ),
      ),
    );
  }
}
