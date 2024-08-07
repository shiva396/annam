import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:projrect_annam/const/color_extension.dart';
import 'package:projrect_annam/common_widget/round_textfield.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';
import 'package:projrect_annam/utils/page_header.dart';

import '../../utils/color_data.dart';
import '../../utils/size_data.dart';
import 'my_cart.dart';
import 'item_details.dart';

class MenuItemsView extends ConsumerStatefulWidget {
  final Map<String, dynamic> canteenData;
  final String collegeName;
  final String selectedCanteen;
  final String selectedCategory;
  const MenuItemsView(
      {super.key,
      required this.canteenData,
      required this.selectedCanteen,
      required this.collegeName,
      required this.selectedCategory});

  @override
  ConsumerState<MenuItemsView> createState() => _MenuItemsViewState();
}

class _MenuItemsViewState extends ConsumerState<MenuItemsView> {
  TextEditingController txtSearch = TextEditingController();
  List<String> items = [];
  @override
  void dispose() {
    txtSearch.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    function();
  }

  void function() {
    Map<String, dynamic> abc = widget.canteenData;
    abc.map((k, v) {
      if (v['stockInHand'] == true) {
        items.add(k);
      }
      return MapEntry(k, v);
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
            child: Column(
              children: [
                PageHeader(
                  title: widget.selectedCategory,
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
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RoundTextfield(
                    hintText: "Search Food",
                    controller: txtSearch,
                    left: Container(
                      alignment: Alignment.center,
                      width: width * 0.08,
                      child: Image.asset(
                        ImageConst.search,
                        width: sizeData.superLarge,
                        height: sizeData.superLarge,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                items.length == 0
                    ? Column(
                        children: [
                          Container(
                            child: Lottie.asset("assets/lottie/person.json"),
                          ),
                          CustomText(
                            text: "No food Found at this moment",
                            weight: FontWeight.bold,
                            size: sizeData.medium,
                            color: colorData.fontColor(1),
                          )
                        ],
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: items.length,
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                ItemDetailsView(
                                  imagePath: widget.canteenData[items[index]]
                                      ['imageUrl'],
                                  collegeName: widget.collegeName,
                                  selectedCanteen: widget.selectedCanteen,
                                  itemName: widget.canteenData[items[index]]
                                      ['name'],
                                  price: widget.canteenData[items[index]]
                                      ['price'],
                                ),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 15, bottom: 8, right: 20),
                                  width: width - 100,
                                  height: height * 0.099,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        bottomLeft: Radius.circular(25),
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 7,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: width * 0.085,
                                        backgroundImage: NetworkImage(
                                            widget.canteenData[items[index]]
                                                ['imageUrl']),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text:
                                                widget.canteenData[items[index]]
                                                    ['name'],
                                            size: sizeData.header,
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          CustomText(
                                            text:
                                                widget.canteenData[items[index]]
                                                    ['price'],
                                            size: sizeData.medium,
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
                                              BorderRadius.circular(17.5),
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
                                        ImageConst.backNext,
                                        width: 15,
                                        height: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
