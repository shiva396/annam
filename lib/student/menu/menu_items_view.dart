import 'package:flutter/material.dart';
import 'package:projrect_annam/const/color_extension.dart';
import 'package:projrect_annam/common_widget/round_textfield.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';

import '../more/my_order_view.dart';
import 'item_details_view.dart';

class MenuItemsView extends StatefulWidget {
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
  State<MenuItemsView> createState() => _MenuItemsViewState();
}

class _MenuItemsViewState extends State<MenuItemsView> {
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
    var media = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 46,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        child: CustomText(
                          text: widget.selectedCategory.toString(),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.push(MyOrderView());
                        },
                        icon: Image.asset(
                          ImageConst.shoppingCart,
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RoundTextfield(
                    hintText: "Search Food",
                    controller: txtSearch,
                    left: Container(
                      alignment: Alignment.center,
                      width: 30,
                      child: Image.asset(
                        ImageConst.search,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.push(
                          ItemDetailsView(
                            collegeName: widget.collegeName,
                            selectedCanteen: widget.selectedCanteen,
                            itemName: widget.canteenData[items[index]]['name'],
                            price: widget.canteenData[items[index]]['price'],
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: 15, bottom: 8, right: 20),
                            width: media.width - 100,
                            height: 90,
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
                                )
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
                                  radius: 40,
                                  backgroundImage: NetworkImage(widget
                                      .canteenData[items[index]]['imageUrl']),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: widget.canteenData[items[index]]
                                          ['name'],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    CustomText(
                                      text: widget.canteenData[items[index]]
                                          ['price'],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(17.5),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12,
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
