import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';
import '../more/my_order_view.dart';
import 'menu_items_view.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  List menuArr = [
    {
      "name": "Food",
      "image": "assets/img/menu_1.png",
      "items_count": "120",
    },
    {
      "name": "Beverages",
      "image": "assets/img/menu_2.png",
      "items_count": "220",
    },
    {
      "name": "Desserts",
      "image": "assets/img/menu_3.png",
      "items_count": "155",
    },
    {
      "name": "Promotions",
      "image": "assets/img/menu_4.png",
      "items_count": "25",
    },
  ];
  List<DropdownMenuItem<String>> _dropdownItems = [];
  List<String> _uniqueId = [];
  List<String> _name = [];
  TextEditingController txtSearch = TextEditingController();
  String _selectedCategory = "";
  int indexing = 0;

  @override
  void initState() {
    _fetchDropdownItems();

    super.initState();
  }

  Future<void> _fetchDropdownItems() async {
    DocumentSnapshot snapshot = await FirebaseOperations.firebaseInstance
        .collection('college')
        .doc('sairam')
        .get();
    Map<String, dynamic> items = snapshot.data() as Map<String, dynamic>;
    _uniqueId.addAll(items.keys.toList());

    List<DropdownMenuItem<String>> ite = items.keys.map((doc) {
      _name.add(items[doc]['name']);
      return DropdownMenuItem<String>(
        value: items[doc]['name'],
        child: Text(items[doc]['name']),
      );
    }).toList();

    setState(() {
      _dropdownItems = ite.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Menu",
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyOrderView()));
                    },
                    icon: Image.asset(
                      "assets/img/shopping_cart.png",
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
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Choose a role',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),

                dropdownColor: const Color.fromARGB(
                    255, 197, 196, 194), // Color when dropdown is open

                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                    indexing = _name.indexOf(_selectedCategory);
                  });
                },
                items: _dropdownItems,
              ),
            ),
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned(
                  left: 0,
                  top: 8,
                  height: media.height * 0.8,
                  width: media.width * 0.27,
                  child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      color: TColor.primary,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(35),
                          bottomRight: Radius.circular(35)),
                    ),
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseOperations.firebaseInstance
                      .collection('college')
                      .doc('sairam')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!(snapshot.hasData && _uniqueId.isNotEmpty))
                      return Center(child: CircularProgressIndicator());
                    List allCategories = [];
                    Map<String, dynamic> obj =
                        snapshot.data!.data() as Map<String, dynamic>;
                    Map<String, dynamic>? categories =
                        (obj[_uniqueId.elementAt(indexing)]['categories']);

                    if (categories != null) {
                      allCategories.addAll(categories.keys.toList());
                      return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: allCategories.length,
                          itemBuilder: ((context, index) {
                            var mObj = menuArr[index] as Map? ?? {};
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MenuItemsView(
                                      selectedCanteen: _uniqueId[indexing],
                                      selectedCategory: allCategories[index],
                                      mObj: mObj,
                                    ),
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
                                        ]),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        mObj["image"].toString(),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              allCategories[index],
                                              style: TextStyle(
                                                  color: TColor.primaryText,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              categories[allCategories[index]]
                                                  .values
                                                  .length
                                                  .toString(),
                                              style: TextStyle(
                                                  color: TColor.secondaryText,
                                                  fontSize: 11),
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
                                                  offset: Offset(0, 2))
                                            ]),
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          "assets/img/btn_next.png",
                                          width: 15,
                                          height: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }));
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
