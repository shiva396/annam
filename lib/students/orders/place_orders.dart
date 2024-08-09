import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/utils/shimmer_effect.dart';
import 'package:projrect_annam/theme/theme_provider.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';
import 'package:projrect_annam/utils/helper_methods.dart';

import '../../const/color_extension.dart';
import '../../utils/color_data.dart';
import '../../utils/size_data.dart';
import 'my_cart.dart';
import 'items.dart';

class PlaceOrders extends ConsumerStatefulWidget {
  const PlaceOrders({super.key});

  @override
  ConsumerState<PlaceOrders> createState() => _PlaceOrdersState();
}

class _PlaceOrdersState extends ConsumerState<PlaceOrders> {
  TextEditingController txtSearch = TextEditingController();
  String _selectedCanteen = "";
  int indexing = 0;

  @override
  void dispose() {
    txtSearch.dispose();
    super.dispose();
  }

  bool _showLoading = true;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showLoading = false;
      });
    });
  }

  List<String> allId = [];
  List<String> allCanteenOwners = [];
  List<String> allCategories = [];
  String _selectedCanteenId = "";
  bool keyboardOn = true;

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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Place Orders",
                      size: sizeData.header,
                      color: colorData.fontColor(1),
                    ),
                    IconButton(
                      onPressed: () {
                        context.push(CartView());
                      },
                      icon: Image.asset(
                        ImageConst.shoppingCart,
                        width: sizeData.superLarge,
                        height: sizeData.superLarge,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseOperations.firebaseInstance
                      .collection('student')
                      .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || _showLoading)
                      return ShimmerEffect();

                    Map<String, dynamic> data =
                        (snapshot.data!.data() as Map<String, dynamic>);
                    String collegeName = data['collegeName'];

                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseOperations.firebaseInstance
                          .collection('college')
                          .doc(collegeName)
                          .snapshots(),
                      builder: (context, innersnapshot) {
                        if (!innersnapshot.hasData) return ShimmerEffect();

                        Map<String, dynamic> canteenOwnersId =
                            innersnapshot.data!.data() as Map<String, dynamic>;

                        List<DropdownMenuEntry<String>> item =
                            canteenOwnersId.keys.map((doc) {
                          allCanteenOwners.add(canteenOwnersId[doc]['name']);
                          allId.add(doc);
                          Map<String, dynamic> category = (canteenOwnersId[doc]
                              ['categories']) as Map<String, dynamic>;

                          return DropdownMenuEntry<String>(
                            value: canteenOwnersId[doc]['name'],
                            label: canteenOwnersId[doc]['name'],
                          );
                        }).toList();
                        return Column(
                          children: [
                            DropdownMenu<String>(
                              hintText: "Search Canteen",
                              textStyle: TextStyle(
                                  color: colorData.fontColor(1),
                                  fontSize: sizeData.medium,
                                  fontWeight: FontWeight.bold),
                              requestFocusOnTap: keyboardOn,
                              searchCallback:
                                  (List<DropdownMenuEntry<String>> entries,
                                      String query) {
                                if (query.isEmpty) {
                                  return null;
                                }
                                final int index = entries.indexWhere(
                                    (DropdownMenuEntry<String> entry) => entry
                                        .label
                                        .toLowerCase()
                                        .startsWith(query.toLowerCase()));

                                return index != -1 ? index : null;
                              },
                              expandedInsets: EdgeInsets.all(width * 0.008),
                              enableSearch: true,
                              onSelected: (value) {
                                setState(() {
                                  keyboardOn = false;
                                  _selectedCanteen = value!;
                                  _selectedCanteenId = allId.elementAt(
                                      allCanteenOwners
                                          .indexOf(_selectedCanteen));
                                  allCategories = [];
                                  allCategories.addAll(
                                      canteenOwnersId[_selectedCanteenId]
                                              ['categories']
                                          .keys);
                                });
                              },
                              dropdownMenuEntries: item,
                            ),
                            _selectedCanteen != ""
                                ? SizedBox(
                                    height: height * 0.9,
                                    child: allCategories.length != 0
                                        ? ListView.builder(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            itemCount: allCategories.length,
                                            itemBuilder: ((context, index) {
                                              int stockInHand = 0;
                                              Map<String, dynamic> datas =
                                                  canteenOwnersId[
                                                              _selectedCanteenId]
                                                          ['categories']
                                                      [allCategories[index]];

                                              datas.keys.forEach((e) {
                                                if (datas[e]['stockInHand'] ==
                                                    true) {
                                                  stockInHand += 1;
                                                }
                                                return (datas[e]
                                                    ['stockInHand']);
                                              });

                                              return GestureDetector(
                                                onTap: () {
                                                  context.push(MenuItemsView(
                                                    categoryName:
                                                        allCategories[index],
                                                    collegeName: collegeName,
                                                    selectedCategory:
                                                        allCategories[index],
                                                    selectedCanteen:
                                                        _selectedCanteenId,
                                                    canteenData: canteenOwnersId[
                                                                _selectedCanteenId]
                                                            ['categories']
                                                        [allCategories[index]],
                                                  ));
                                                },
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  margin: const EdgeInsets.only(
                                                      top: 15,
                                                      bottom: 8,
                                                      left: 10,
                                                      right: 10),
                                                  height: height * 0.08,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                          boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black12,
                                                          blurRadius: 7,
                                                          offset: Offset(0, 4),
                                                        )
                                                      ]),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const SizedBox(
                                                        width: 25,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            CustomText(
                                                              text:
                                                                  allCategories[
                                                                      index],
                                                              size: sizeData
                                                                  .medium,
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            CustomText(
                                                              text: "Items Available :   " +
                                                                  stockInHand
                                                                      .toString(),
                                                              size: sizeData
                                                                  .small,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 35,
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        17.5),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black12,
                                                                  blurRadius: 4,
                                                                  offset:
                                                                      Offset(0,
                                                                          2)),
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black45,
                                                                  blurRadius: 4,
                                                                  offset:
                                                                      Offset(
                                                                          0, 2))
                                                            ]),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Image.asset(
                                                          ImageConst.backNext,
                                                          width: 15,
                                                          height: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                          )
                                        : Column(
                                            children: [
                                              Container(
                                                child: Lottie.asset(
                                                    "assets/lottie/person.json"),
                                              ),
                                              CustomText(
                                                text:
                                                    "No food Found at this moment",
                                                weight: FontWeight.bold,
                                                size: sizeData.medium,
                                                color: colorData.fontColor(1),
                                              )
                                            ],
                                          ),
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        height: 500,
                                        width: 500,
                                        child: Lottie.asset(
                                            "assets/lottie/person.json"),
                                      ),
                                      CustomText(
                                        text: "Choose Canteen",
                                        weight: FontWeight.bold,
                                        size: sizeData.medium,
                                        color: colorData.fontColor(1),
                                      )
                                    ],
                                  ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
