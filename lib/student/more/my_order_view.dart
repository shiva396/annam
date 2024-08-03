import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';
import 'package:projrect_annam/common/color_extension.dart';
import 'package:projrect_annam/common_widget/round_button.dart';
import 'package:projrect_annam/helper/image_const.dart';
import 'package:projrect_annam/helper/utils.dart';

class MyOrderView extends StatefulWidget {
  const MyOrderView({
    super.key,
  });

  @override
  State<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends State<MyOrderView> {
  bool _showLoading = true;
  @override
  void initState() {
    super.initState();
    // Set a delay of 2 seconds before allowing the main content to show
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _showLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: TColor.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset(ImageConst.backButton,
                          width: 20, height: 20),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        "My Order",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
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
                            return Center(child: Text("An error occurred."));
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(child: Text("No orders found."));
                          }
                          Map<String, dynamic> canteenOrders =
                              snapshot.data!.docs.first.data()!
                                  as Map<String, dynamic>;
                          List canteenOwners = (canteenOrders.keys).toList();

                          return SizedBox(
                            height: 750,
                            child: ListView.builder(
                                itemCount: canteenOwners.length,
                                itemBuilder: (context, index) {
                                  return StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseOperations
                                          .firebaseInstance
                                          .collection('college')
                                          .doc(collegeName)
                                          .snapshots(),
                                      builder: (context, innersnapshot) {
                                        if (!innersnapshot.hasData )
                                          return overlayContent(
                                              context: context,
                                              imagePath:
                                                  "assets/rive/loading.riv");
                                        Map<String, dynamic> obj =
                                            innersnapshot.data!.data()
                                                as Map<String, dynamic>;
                                        String canteenName =
                                            obj[canteenOwners[index]]['name'];
                                        Map<String, dynamic> items =
                                            canteenOrders[canteenOwners[index]];

                                        Map<String, dynamic> finalData = {};
                                        items.map((k, v) {
                                          if (k != "time" &&
                                              k != "checkOut" &&
                                              k != "totalAmount") {
                                            finalData.addAll({k: v});
                                          }
                                          return MapEntry(k, v);
                                        });
                                        print(finalData);

                                        List itemElements =
                                            finalData.values.map((v) {
                                          return v;
                                        }).toList();

                                        Map Ordereditems = Map.fromIterables(
                                            List.generate(finalData.length,
                                                (v) {
                                              return v;
                                            }),
                                            itemElements);

                                        String time = items['time'];
                                        bool checkOut = items['checkOut'];
                                        int amount = int.parse(
                                            items['totalAmount'].toString());

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                canteenName,
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: TColor.textfield),
                                                child: ListView.separated(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemCount:
                                                      Ordereditems.length,
                                                  separatorBuilder: ((context,
                                                          index) =>
                                                      Divider(
                                                        indent: 25,
                                                        endIndent: 25,
                                                        color: TColor
                                                            .secondaryText
                                                            .withOpacity(0.5),
                                                        height: 1,
                                                      )),
                                                  itemBuilder:
                                                      ((context, index) {
                                                    return Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 15,
                                                          horizontal: 25),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "${Ordereditems[index]["name"].toString()} x${Ordereditems[index]["quantity"].toString()}",
                                                              style: TextStyle(
                                                                  color: TColor
                                                                      .primaryText,
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          Text(
                                                            "${Ordereditems[index]["price"].toString()} \u{20B9}",
                                                            style: TextStyle(
                                                                color: TColor
                                                                    .primaryText,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Divider(
                                                      color: TColor
                                                          .secondaryText
                                                          .withOpacity(0.5),
                                                      height: 1,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Sub Total",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: TColor
                                                                  .primaryText,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        Text(
                                                          "68 \u{20B9}",
                                                          style: TextStyle(
                                                              color: TColor
                                                                  .primary,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
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
                                                        Text(
                                                          "Delivery Cost",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: TColor
                                                                  .primaryText,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        Text(
                                                          "2 \u{20B9}",
                                                          style: TextStyle(
                                                              color: TColor
                                                                  .primary,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Divider(
                                                      color: TColor
                                                          .secondaryText
                                                          .withOpacity(0.5),
                                                      height: 1,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Total",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: TColor
                                                                  .primaryText,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        Text(
                                                          amount.toString() +
                                                              ' \u{20B9}',
                                                          style: TextStyle(
                                                              color: TColor
                                                                  .primary,
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 25,
                                                    ),
                                                    RoundButton(
                                                        title: "Checkout",
                                                        onPressed: () {
                                                          // History Push
                                                          Ordereditems.addAll({
                                                            'canttenName':
                                                                canteenName
                                                          });

                                                          Map<String, dynamic>
                                                              data = {};
                                                          Ordereditems.map(
                                                              (k, v) {
                                                            data[k.toString()] =
                                                                v;
                                                            return MapEntry(
                                                                k, v);
                                                          });
                                                        }),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
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
