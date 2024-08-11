import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/common_widget/round_icon_button.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';
import 'package:projrect_annam/utils/page_header.dart';

import '../../const/image_const.dart';
import '../../utils/color_data.dart';
import '../../utils/size_data.dart';
import 'my_cart.dart';

class ItemDetailsView extends ConsumerStatefulWidget {
  final String itemName;
  final String price;
  final String selectedCanteen;
  final String categoryName;
  final String collegeName;
  final String imagePath;
  const ItemDetailsView(
      {super.key,
      required this.categoryName,
      required this.itemName,
      required this.price,
      required this.imagePath,
      required this.selectedCanteen,
      required this.collegeName});

  @override
  ConsumerState<ItemDetailsView> createState() => _ItemDetailsViewState();
}

class _ItemDetailsViewState extends ConsumerState<ItemDetailsView> {
  double price = 0.0;
  int qty = 1;
  bool isFav = false;
  @override
  void initState() {
    price = int.parse(widget.price).toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.network(
              widget.imagePath,
              width: width,
              height: width,
              fit: BoxFit.cover,
            ),
            Container(
              width: width,
              height: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.transparent,
                  colorData.primaryColor(.2),
                  Colors.transparent,
                  Colors.black
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: height * 0.42,
                        ),
                        Container(
                          height: height * 0.50,
                          decoration: BoxDecoration(
                              color: colorData.primaryColor(.2),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: CustomText(
                                    text: widget.itemName,
                                    size: sizeData.superHeader,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IgnorePointer(
                                            ignoring: false,
                                            child: RatingBar.builder(
                                              initialRating: 4,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 20,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1.0),
                                              itemBuilder: (context, _) => Icon(
                                                  Icons.star,
                                                  color: colorData
                                                      .primaryColor(.9)),
                                              onRatingUpdate: (rating) {},
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          CustomText(
                                            text: " 4 Star Ratings",
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          CustomText(
                                            text:
                                                "₹${price.toStringAsFixed(2)}",
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          CustomText(
                                            text: "/per Portion",
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Divider(
                                      color: colorData.secondaryColor(.9),
                                      height: 1,
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Row(
                                    children: [
                                      CustomText(
                                        text: "Number of Portions",
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          qty = qty - 1;

                                          if (qty < 1) {
                                            qty = 1;
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          height: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: colorData.primaryColor(.9),
                                              borderRadius:
                                                  BorderRadius.circular(12.5)),
                                          child: CustomText(
                                            text: "-",
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        height: 25,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: colorData.primaryColor(.9),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.5)),
                                        child: CustomText(
                                          text: qty.toString(),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          qty = qty + 1;

                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          height: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: colorData.primaryColor(.9),
                                              borderRadius:
                                                  BorderRadius.circular(12.5)),
                                          child: CustomText(
                                            text: "+",
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 220,
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        width: width * 0.25,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          color: colorData.primaryColor(.9),
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(35),
                                              bottomRight: Radius.circular(35)),
                                        ),
                                      ),
                                      Center(
                                        child: Stack(
                                          alignment: Alignment.centerRight,
                                          children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 8,
                                                    left: 10,
                                                    right: 20),
                                                width: width - 80,
                                                height: 120,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black12,
                                                          blurRadius: 12,
                                                          offset: Offset(0, 4))
                                                    ]),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CustomText(
                                                      text: "Total Price",
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    CustomText(
                                                      text:
                                                          "₹${(price * qty).toString()}",
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    SizedBox(
                                                      width: 130,
                                                      height: 25,
                                                      child: RoundIconButton(
                                                          title: "Add to Cart",
                                                          icon: ImageConst
                                                              .shoppingAdd,
                                                          color: colorData
                                                              .primaryColor(.9),
                                                          onPressed: () {
                                                            FirebaseOperations.addCartItems(
                                                                    categoryName:
                                                                        widget
                                                                            .categoryName,
                                                                    collegeName:
                                                                        widget
                                                                            .collegeName,
                                                                    canteenName:
                                                                        widget
                                                                            .selectedCanteen,
                                                                    itemName: widget
                                                                        .itemName,
                                                                    price: widget
                                                                        .price,
                                                                    quantity: qty
                                                                        .toString())
                                                                .whenComplete(
                                                                    () {
                                                              context.pop();
                                                              context.pop();
                                                            });
                                                          }),
                                                    )
                                                  ],
                                                )),
                                            InkWell(
                                              onTap: () {
                                                context.push(CartView());
                                              },
                                              child: Container(
                                                width: 45,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            22.5),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Colors.black12,
                                                          blurRadius: 4,
                                                          offset: Offset(0, 2)),
                                                      BoxShadow(
                                                          color: Colors.black45,
                                                          blurRadius: 4,
                                                          offset: Offset(0, 2))
                                                    ]),
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                    ImageConst.shoppingCart,
                                                    width: 20,
                                                    height: 20,
                                                    color: colorData
                                                        .primaryColor(.9)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    Container(
                      height: width - 20,
                      alignment: Alignment.bottomRight,
                      margin: const EdgeInsets.only(right: 4),
                      child: InkWell(
                          onTap: () {
                            isFav = !isFav;
                            setState(() {});
                          },
                          child: Image.asset(
                              isFav
                                  ? ImageConst.favorite
                                  : ImageConst.unfavorite,
                              width: 70,
                              height: 70)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: width * 0.04,
                right: width * 0.04,
                top: height * 0.02,
              ),
              child: PageHeader(
                title: "",
                secondaryWidget: IconButton(
                  onPressed: () {
                    context.push(CartView());
                  },
                  icon: Image.asset(
                    ImageConst.shoppingCart,
                    width: sizeData.superLarge,
                    height: sizeData.superLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
