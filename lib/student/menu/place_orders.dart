import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';
import 'package:projrect_annam/helper/helper.dart';
import 'package:projrect_annam/helper/image_const.dart';

import '../../common/color_extension.dart';
import '../more/my_order_view.dart';
import 'menu_items_view.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  TextEditingController txtSearch = TextEditingController();
  String _selectedCanteen = "";
  int indexing = 0;

  @override
  void dispose() {
    txtSearch.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  List<String> allId = [];
  List<String> allCanteenOwners = [];
  List<String> allCategories = [];
  String _selectedCanteenId = "";
  bool keyboardOn = true;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Place Orders",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
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
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseOperations.firebaseInstance
                    .collection('student')
                    .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  Map<String, dynamic> data =
                      (snapshot.data!.data() as Map<String, dynamic>);
                  String collegeName = data['collegeName'];

                  return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseOperations.firebaseInstance
                        .collection('college')
                        .doc(collegeName)
                        .snapshots(),
                    builder: (context, innersnapshot) {
                      if (!innersnapshot.hasData)
                        return CircularProgressIndicator();

                      Map<String, dynamic> canteenOwnersId =
                          innersnapshot.data!.data() as Map<String, dynamic>;

                      List<DropdownMenuEntry<String>> item =
                          canteenOwnersId.keys.map((doc) {
                        allCanteenOwners.add(canteenOwnersId[doc]['name']);
                        allId.add(doc);
                        return DropdownMenuEntry<String>(
                          value: canteenOwnersId[doc]['name'],
                          label: canteenOwnersId[doc]['name'],
                        );
                      }).toList();
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.zero,
                            child: DropdownMenu<String>(
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
                              expandedInsets: EdgeInsets.all(30),
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
                          ),
                          _selectedCanteen != ""
                              ? SizedBox(
                                  height: 500,
                                  child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 8,
                                        height: media.height * 0.8,
                                        width: media.width * 0.27,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 30),
                                          decoration: BoxDecoration(
                                            color: TColor.primary,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(35),
                                                    bottomRight:
                                                        Radius.circular(35)),
                                          ),
                                        ),
                                      ),
                                      ListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30, horizontal: 20),
                                        itemCount: allCategories.length,
                                        itemBuilder: ((context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              context.push(MenuItemsView(
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
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  margin: const EdgeInsets.only(
                                                      top: 15,
                                                      bottom: 8,
                                                      right: 20),
                                                  width: media.width - 100,
                                                  height: 90,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(25),
                                                              bottomLeft: Radius
                                                                  .circular(25),
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10)),
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
                                                            Text(
                                                              allCategories[
                                                                  index],
                                                              style: TextStyle(
                                                                  color: TColor
                                                                      .primaryText,
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              canteenOwnersId[
                                                                          _selectedCanteenId]
                                                                      [
                                                                      'categories']
                                                                  .keys
                                                                  .length
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: TColor
                                                                      .secondaryText,
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
                                                                BorderRadius
                                                                    .circular(
                                                                        17.5),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black12,
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
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
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
    );
  }
}
