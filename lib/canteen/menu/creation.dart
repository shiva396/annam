import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/utils/custom_network_image.dart';
import 'package:projrect_annam/utils/extension_methods.dart';
import 'package:projrect_annam/utils/helper_methods.dart';
import 'package:projrect_annam/utils/shimmer_effect.dart';

import '../../utils/color_data.dart';
import '../../utils/custom_text.dart';
import '../../utils/size_data.dart';

class Creation extends ConsumerStatefulWidget {
  final String collegeName;
  const Creation({super.key, required this.collegeName});

  @override
  ConsumerState<Creation> createState() => _CreationState();
}

class _CreationState extends ConsumerState<Creation> {
  final ImagePicker picker = ImagePicker();

  void _editItem(
      {required String itemName,
      required int count,
      required String categoryName,
      required String imageUrl,
      required bool data,
      required height,
      required String price,
      required width}) {
    //Image Picker Function Logic
    XFile? imageData;

    Future selectImageFile(BuildContext context, StateSetter setState) async {
      XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        imageData = image;
      });
    }

    TextEditingController nameController =
        TextEditingController(text: itemName);
    TextEditingController priceController = TextEditingController(text: price);
    TextEditingController countController =
        TextEditingController(text: count.toString());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: CustomText(
                text: 'Edit Item',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      selectImageFile(context, setState);
                    },
                    child: imageData == null
                        ? CustomNetworkImage(
                            size: 70,
                            radius: 70,
                            url: imageUrl,
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.amber,
                            backgroundImage: FileImage(File(imageData!.path)),
                          ),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Price '),
                  ),
                  TextField(
                    controller: countController,
                    decoration: InputDecoration(labelText: 'Count'),
                  ),
                  // StatefulBuilder(builder: (context, state) {
                  //   return Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       CustomText(text: "Stock in Hand"),
                  //       Switch(
                  //         value: selected,
                  //         onChanged: (v) {
                  //           state(() {
                  //             selected = v;
                  //           });
                  //         },
                  //       ),
                  //     ],
                  //   );
                  // })
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Save"),
                            Image.asset(
                              "assets/images/correct.png",
                              height: height * 0.03,
                              width: width * 0.1,
                            )
                          ],
                        ),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return overlayContent(
                                    context: context,
                                    imagePath: "assets/rive/loading.riv");
                              });
                          FirebaseOperations.editItems(
                            count: int.parse(countController.text.trim()),
                            oldImagePath: imageUrl,
                            newImagePath: imageData,
                            categoryName: categoryName,
                            collegeName: widget.collegeName,
                            newitemName: nameController.text.trim(),
                            itemPrice: priceController.text.trim(),
                            olditemName: itemName,
                          ).whenComplete(() {
                            context.pop();
                            context.pop();
                          });
                        }),
                    ElevatedButton(
                        child: Row(
                          children: [
                            Text("Cancel"),
                            Image.asset(
                              "assets/images/wrong.png",
                              height: height * 0.03,
                              width: width * 0.1,
                            )
                          ],
                        ),
                        onPressed: () {
                          //Clear the image if cancelled without saving
                          setState(() {
                            imageData = null;
                          });
                          context.pop();
                        }),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addItem(
      {required String categoryName,
      required double width,
      required double height,
      required CustomSizeData sizeData}) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController countController = TextEditingController();

//Seletimg image logic.
    XFile? imageData;
    Future selectImageFile(BuildContext context, StateSetter setState) async {
      XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        imageData = image;
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: CustomText(
                text: 'Add Item',
                size: sizeData.subHeader,
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      selectImageFile(context, setState);
                    },
                    child: imageData == null
                        ? CustomNetworkImage(size: 70, radius: 70)
                        : CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.amber,
                            backgroundImage: FileImage(File(imageData!.path)),
                          ),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Price \u20B9'),
                  ),
                  TextField(
                    controller: countController,
                    decoration: InputDecoration(labelText: 'Count '),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Save"),
                            Image.asset(
                              "assets/images/correct.png",
                              height: height * 0.03,
                              width: width * 0.1,
                            )
                          ],
                        ),
                        onPressed: () async {
                          if (categoryName.isNotEmpty &&
                              nameController.text.isNotEmpty &&
                              priceController.text.isNotEmpty &&
                              countController.text.isNotEmpty &&
                              imageData != null) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return overlayContent(
                                      context: context,
                                      imagePath: "assets/rive/loading.riv");
                                });

                            FirebaseOperations.addItems(
                                    count:
                                        int.parse(countController.text.trim()),
                                    categoryName: categoryName,
                                    collegeName: widget.collegeName,
                                    context: context,
                                    itemName: nameController.text.trim(),
                                    itemPrice: priceController.text.trim(),
                                    itemImageUrl: imageData!)
                                .whenComplete(() {
                              context.pop();
                              context.pop();
                            });
                          } else {
                            context.showSnackBar("Add All details");
                          }
                        }),
                    ElevatedButton(
                        child: Row(
                          children: [
                            Text("Cancel"),
                            Image.asset(
                              "assets/images/wrong.png",
                              height: height * 0.03,
                              width: width * 0.1,
                            )
                          ],
                        ),
                        onPressed: () async {
                          setState(() {
                            imageData = null;
                          });
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void initState() {
    super.initState();
  }

  Future<void> showAddCategoryDialog(
      {required BuildContext context,
      required double width,
      required double height,
      required CustomSizeData sizeData}) async {
    String categoryName = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CustomText(text: 'Add Category'),
          content: TextField(
            onChanged: (value) {
              categoryName = value;
            },
            decoration: const InputDecoration(hintText: "Enter category name"),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Save"),
                        Image.asset(
                          "assets/images/correct.png",
                          height: height * 0.03,
                          width: width * 0.1,
                        )
                      ],
                    ),
                    onPressed: () async {
                      if (categoryName.isNotEmpty) {
                        FirebaseOperations.addCategories(
                                context: context,
                                categoryName: categoryName,
                                collegeName: widget.collegeName)
                            .whenComplete(() => Navigator.of(context).pop());
                      } else {
                        context.showSnackBar("Enter the field");
                      }
                    }),
                ElevatedButton(
                    child: Row(
                      children: [
                        Text("Cancel"),
                        Image.asset(
                          "assets/images/wrong.png",
                          height: height * 0.03,
                          width: width * 0.1,
                        )
                      ],
                    ),
                    onPressed: () async {
                      context.pop();
                    }),
              ],
            ),
          ],
        );
      },
    );
  }

  int current = 0;
  String selectedCategory = "";
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Welcome to Products gallery",
                size: sizeData.header,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "All Categories",
                    size: sizeData.medium,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                    ),
                    onPressed: () {
                      showAddCategoryDialog(
                          context: context,
                          sizeData: sizeData,
                          height: height,
                          width: width);
                    },
                    child: const CustomText(
                      text: "Add Category",
                    ),
                  ),
                ],
              ),
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseOperations.firebaseInstance
                      .collection('college')
                      .doc(widget.collegeName)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return ShimmerEffect();
                    Map<String, dynamic> data = snapshot.data!.get(
                        FirebaseOperations.firebaseAuth.currentUser!
                            .uid)['categories'] as Map<String, dynamic>;

                    List<String> categories = data.keys.toList();
                    if (categories.isNotEmpty) {
                      return Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9),
                          child: SizedBox(
                            height: 50,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: categories.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, index) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          current = index;
                                          selectedCategory = categories[index];
                                        });
                                      },
                                      child: AnimatedContainer(
                                        color: Colors.transparent,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.all(5),
                                        width: 100,
                                        height: 30,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomText(
                                                text: categories[index]
                                                    .toString(),
                                                size: sizeData.medium,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          selectedCategory == categories[index],
                                      child: Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                            color: colorData.primaryColor(1),
                                            shape: BoxShape.circle),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        selectedCategory.isNotEmpty
                            ? SizedBox(
                                height: sizeData.height * 0.60,
                                child: ListView.builder(
                                  itemCount:
                                      data[categories[current]].length + 1,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    List<String> items =
                                        data[categories[current]].keys.toList();

                                    if (index + 1 ==
                                        data[categories[current]].length + 1) {
                                      return Card(
                                        color: colorData.secondaryColor(1),
                                        margin: EdgeInsets.all(10.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: ListTile(
                                            leading: Icon(Icons.add),
                                            title: CustomText(
                                                text: 'Add New Item'),
                                            onTap: () {
                                              _addItem(
                                                  sizeData: sizeData,
                                                  categoryName:
                                                      selectedCategory,
                                                  width: width,
                                                  height: height);
                                            }),
                                      );
                                    } else {
                                      return Card(
                                        color: colorData.secondaryColor(1),
                                        margin: EdgeInsets.all(10.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: ListTile(
                                          leading: CustomNetworkImage(
                                            url: data[categories[current]]
                                                            [items[index]]
                                                        ['imageUrl'] !=
                                                    "empty"
                                                ? data[categories[current]]
                                                    [items[index]]['imageUrl']
                                                : null,
                                            size: 50,
                                            radius: 50,
                                          ),
                                          title: CustomText(
                                            text: data[categories[current]]
                                                [items[index]]['name'],
                                            size: sizeData.medium,
                                          ),
                                          subtitle: CustomText(
                                            text: data[categories[current]]
                                                    [items[index]]['price'] +
                                                "  " +
                                                '\u20B9',
                                            size: sizeData.medium,
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CustomText(
                                                  text:
                                                      "Count : ${data[categories[current]][items[index]]['count'].toString()}"),
                                              IconButton(
                                                icon: Image.asset(
                                                  ImageConst.editPencil,
                                                  height: sizeData.superLarge,
                                                  width: sizeData.superLarge,
                                                ),
                                                onPressed: () {
                                                  bool stockData =
                                                      data[categories[current]]
                                                              [items[index]]
                                                          ['stockInHand'];

                                                  _editItem(
                                                      count:
                                                          data[categories[current]]
                                                                  [items[index]]
                                                              ['count'],
                                                      price:
                                                          data[categories[current]]
                                                                  [items[index]]
                                                              ['price'],
                                                      imageUrl:
                                                          data[categories[current]]
                                                                  [items[index]]
                                                              ['imageUrl'],
                                                      height: height,
                                                      width: width,
                                                      itemName:
                                                          data[categories[current]]
                                                                  [items[index]]
                                                              ['name'],
                                                      categoryName:
                                                          selectedCategory,
                                                      data: stockData);
                                                },
                                              ),
                                              IconButton(
                                                icon: Image.asset(
                                                  ImageConst.delete,
                                                  height: sizeData.superLarge,
                                                  width: sizeData.superLarge,
                                                ),
                                                onPressed: () {
                                                  FirebaseOperations
                                                      .removeItems(
                                                    categoryName:
                                                        selectedCategory,
                                                    collegeName:
                                                        widget.collegeName,
                                                    itemName: data[
                                                            categories[current]]
                                                        [items[index]]['name'],
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              )
                            : Column(
                                children: [
                                  Container(
                                    child: Lottie.asset(
                                        "assets/lottie/person.json"),
                                  ),
                                  CustomText(
                                    text: "Choose Category",
                                    weight: FontWeight.bold,
                                    size: sizeData.medium,
                                    color: colorData.fontColor(1),
                                  )
                                ],
                              ),
                      ]);
                    } else {
                      return Center(
                        child: CustomText(text: "No categories"),
                      );
                    }
                  })
            ],
          ),
        ),
      )),
    );
  }
}
