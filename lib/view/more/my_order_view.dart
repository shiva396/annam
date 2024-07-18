import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';
import 'package:projrect_annam/common/color_extension.dart';
import 'package:projrect_annam/common_widget/round_button.dart';

import 'checkout_view.dart';

class MyOrderView extends StatefulWidget {
  const MyOrderView({super.key});

  @override
  State<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends State<MyOrderView> {
  int totalAmount = 0;
  List itemArr = [
    {"name": "Beef Burger", "qty": "1", "price": 16.0},
    {"name": "Classic Burger", "qty": "1", "price": 14.0},
    {"name": "Cheese Chicken Burger", "qty": "1", "price": 17.0},
    {"name": "Chicken Legs Basket", "qty": "1", "price": 15.0},
    {"name": "French Fires Large", "qty": "1", "price": 6.0}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: TColor.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        icon: Image.asset("assets/img/btn_back.png",
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
                StreamBuilder(
                    stream: FirebaseOperations.firebaseInstance
                        .collection('student')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('orders')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      List canteenOwners =
                          (snapshot.data!.data()!.keys).toList();
                      Map<String, dynamic> canteenOrders =
                          (snapshot.data!.data() as Map<String, dynamic>);

                      return SizedBox(
                        height: 750,
                        child: ListView.builder(
                            itemCount: canteenOwners.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseOperations.firebaseInstance
                                      .collection('college')
                                      .doc('sairam')
                                      .snapshots(),
                                  builder: (context, innersnapshot) {
                                    if (!innersnapshot.hasData)
                                      return CircularProgressIndicator();
                                    Map<String, dynamic> obj =
                                        innersnapshot.data!.data()
                                            as Map<String, dynamic>;
                                    String canteenName =
                                        obj[canteenOwners[index]]['name'];
                                    Map<String, dynamic> items =
                                        canteenOrders[canteenOwners[index]];

                                    List itemElements = items.values.map((v) {
                                      return v;
                                    }).toList();

                                    Map Ordereditems = Map.fromIterables(
                                        List.generate(itemElements.length, (v) {
                                          return v;
                                        }),
                                        itemElements);
                                    // For removing time here may encounter an error
                                    String time = Ordereditems.remove(
                                        Ordereditems.length - 1);

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
                                                fontWeight: FontWeight.bold),
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
                                              itemCount: Ordereditems.length,
                                              separatorBuilder:
                                                  ((context, index) => Divider(
                                                        indent: 25,
                                                        endIndent: 25,
                                                        color: TColor
                                                            .secondaryText
                                                            .withOpacity(0.5),
                                                        height: 1,
                                                      )),
                                              itemBuilder: ((context, index) {
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
                                                        "\$${Ordereditems[index]["price"].toString()}",
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Divider(
                                                  color: TColor.secondaryText
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
                                                              FontWeight.w700),
                                                    ),
                                                    Text(
                                                      "\$68",
                                                      style: TextStyle(
                                                          color: TColor.primary,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700),
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
                                                              FontWeight.w700),
                                                    ),
                                                    Text(
                                                      "\$2",
                                                      style: TextStyle(
                                                          color: TColor.primary,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Divider(
                                                  color: TColor.secondaryText
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
                                                              FontWeight.w700),
                                                    ),
                                                    Text(
                                                      totalAmount.toString(),
                                                      style: TextStyle(
                                                          color: TColor.primary,
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w700),
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
                                                      Ordereditems.map((k, v) {
                                                        data[k.toString()] = v;
                                                        return MapEntry(k, v);
                                                      });

                                                      FirebaseOperations
                                                          .pushToHistory(
                                                        timeStamp: time,
                                                        data: data,
                                                      ).whenComplete(() {
                                                        FirebaseOperations
                                                            .deleteOrders(
                                                                canteenId:
                                                                    canteenOwners[
                                                                        index]);
                                                      });
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) =>
                                                      //         const CheckoutView(),
                                                      //   ),
                                                      // );
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
                    }),
              ],
            ),
          ),
        ));
  }
}

// Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 15, horizontal: 25),
//                             child: Row(
//                               children: [
//                                 ClipRRect(
//                                     borderRadius: BorderRadius.circular(15),
//                                     child: Image.asset(
//                                       "assets/img/shop_logo.png",
//                                       width: 80,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                     )),
//                                 const SizedBox(
//                                   width: 8,
//                                 ),
//                                 StreamBuilder(
//                                     stream: FirebaseOperations.firebaseInstance
//                                         .collection('student')
//                                         .doc(FirebaseAuth
//                                             .instance.currentUser!.uid)
//                                         .collection('orders')
//                                         .doc(FirebaseAuth
//                                             .instance.currentUser!.uid)
//                                         .snapshots(),
//                                     builder: (context, snapshot) {
//                                       if (!snapshot.hasData)
//                                         return CircularProgressIndicator();
//                                     
//                                       return Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "King Burgers",
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                   color: TColor.primaryText,
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.w700),
//                                             ),
//                                             const SizedBox(
//                                               height: 4,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: [
//                                                 Image.asset(
//                                                   "assets/img/rate.png",
//                                                   width: 10,
//                                                   height: 10,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 4,
//                                                 ),
//                                                 Text(
//                                                   "4.9",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                       color: TColor.primary,
//                                                       fontSize: 12),
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 8,
//                                                 ),
//                                                 Text(
//                                                   "(124 Ratings)",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                       color:
//                                                           TColor.secondaryText,
//                                                       fontSize: 12),
//                                                 ),
//                                               ],
//                                             ),
//                                             const SizedBox(
//                                               height: 4,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   "Burger",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                       color:
//                                                           TColor.secondaryText,
//                                                       fontSize: 12),
//                                                 ),
//                                                 Text(
//                                                   " . ",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                       color: TColor.primary,
//                                                       fontSize: 12),
//                                                 ),
//                                                 Text(
//                                                   "Western Food",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                       color:
//                                                           TColor.secondaryText,
//                                                       fontSize: 12),
//                                                 ),
//                                               ],
//                                             ),
//                                             const SizedBox(
//                                               height: 4,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: [
//                                                 Image.asset(
//                                                   "assets/img/location-pin.png",
//                                                   width: 13,
//                                                   height: 13,
//                                                   fit: BoxFit.contain,
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 4,
//                                                 ),
//                                                 Expanded(
//                                                   child: Text(
//                                                     "No 03, 4th Lane, Newyork",
//                                                     textAlign: TextAlign.left,
//                                                     style: TextStyle(
//                                                         color: TColor
//                                                             .secondaryText,
//                                                         fontSize: 12),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     }),
//                               ],
//                             ),
//                           ),
