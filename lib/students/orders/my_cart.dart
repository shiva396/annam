import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/students/orders/my_orders.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';
import 'package:projrect_annam/utils/helper_methods.dart';
import 'package:projrect_annam/utils/page_header.dart';

import '../../utils/color_data.dart';
import '../../utils/size_data.dart';

class CartView extends ConsumerStatefulWidget {
  const CartView({
    super.key,
  });

  @override
  ConsumerState<CartView> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {
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
                title: "My Carts",
                secondaryWidget: IconButton(
                  onPressed: () {
                    context.push(MyOrders());
                  },
                  icon: Image.asset(
                    ImageConst.shoppingCart,
                    width: sizeData.superLarge,
                    height: sizeData.superLarge,
                  ),
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
                            .collection('cart')
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
                                        if (!innersnapshot.hasData)
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
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              CustomText(
                                                text: canteenName,
                                                size: sizeData.header,
                                                color: colorData.fontColor(1),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: colorData
                                                        .secondaryColor(.9)),
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
                                                        color: colorData
                                                            .primaryColor(1),
                                                        height: 2,
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
                                                            child: CustomText(
                                                              text:
                                                                  "${Ordereditems[index]["name"].toString()} x${Ordereditems[index]["quantity"].toString()}",
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          CustomText(
                                                            text:
                                                                "${Ordereditems[index]["price"].toString()} \u{20B9}",
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
                                                      color: colorData
                                                          .primaryColor(1),
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
                                                          text: amount
                                                                  .toString() +
                                                              ' \u{20B9}',
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 25,
                                                    ),
                                                    Center(
                                                      child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(),
                                                              backgroundColor:
                                                                  colorData
                                                                      .primaryColor(
                                                                          1)),
                                                          child: CustomText(
                                                            text:
                                                                "Place Orders",
                                                            size: sizeData
                                                                .subHeader,
                                                            color: colorData
                                                                .secondaryColor(
                                                                    1),
                                                          ),
                                                          onPressed: () {
                                                            // History Push
                                                            Ordereditems
                                                                .addAll({
                                                              'canttenName':
                                                                  canteenName,
                                                              'canttenId':
                                                                  canteenOwners[
                                                                      index]
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
                                                            FirebaseOperations
                                                                .placeOrders(
                                                              collegeName:
                                                                  collegeName,
                                                              canttenOwnerId:
                                                                  canteenOwners[
                                                                      index],
                                                              data: data,
                                                            ).whenComplete(() {
                                                              context.showSnackBar(
                                                                  "Order Placed Sucessfully");
                                                            });
                                                          }),
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
