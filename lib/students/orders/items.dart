import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:projrect_annam/common_widget/round_textfield.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';
import 'package:projrect_annam/utils/page_header.dart';

import '../../utils/color_data.dart';
import '../../utils/search.dart';
import '../../utils/size_data.dart';
import 'my_cart.dart';
import 'item_details.dart';

class MenuItemsView extends ConsumerStatefulWidget {
  final Map<String, dynamic> canteenData;
  final String categoryName;
  final String collegeName;
  final String selectedCanteen;
  final String selectedCategory;
  const MenuItemsView(
      {super.key,
      required this.categoryName,
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
  List<String> searchedItems = [];
  @override
  void dispose() {
    txtSearch.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    function();
    searchedItems = List.from(items);
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
                CustomSearchBar(
                  onClear: () {
                    setState(() {
                      searchedItems = List.from(items);
                    });
                  },
                  onChanged: (v) {
                    if (v.isEmpty) {
                      setState(() {});
                    }
                    items.forEach((e) {
                      if (e.toLowerCase().startsWith(v.toLowerCase())) {
                        setState(() {});
                        searchedItems = [];
                        searchedItems.add(e);
                      }
                    });
                  },
                  onSubmitted: (v) {
                    if (txtSearch.text.isEmpty) {
                      setState(() {
                        searchedItems = List.from(items);
                      });
                    }
                    if (v.isNotEmpty && !items.contains(v)) {
                      setState(() {
                        searchedItems = [];
                      });
                    }
                  },
                  controller: txtSearch,
                  hintText: "Search for Food",
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
                        itemCount: searchedItems.length,
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                ItemDetailsView(
                                  categoryName: widget.categoryName,
                                  imagePath:
                                      widget.canteenData[searchedItems[index]]
                                          ['imageUrl'],
                                  collegeName: widget.collegeName,
                                  selectedCanteen: widget.selectedCanteen,
                                  itemName:
                                      widget.canteenData[searchedItems[index]]
                                          ['name'],
                                  price:
                                      widget.canteenData[searchedItems[index]]
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
                                        backgroundImage: NetworkImage(widget
                                                .canteenData[
                                            searchedItems[index]]['imageUrl']),
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
                                            text: widget.canteenData[
                                                searchedItems[index]]['name'],
                                            size: sizeData.header,
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          CustomText(
                                            text: widget.canteenData[
                                                searchedItems[index]]['price'],
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
