import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';
import 'package:projrect_annam/helper/utils.dart';

class Creation extends StatefulWidget {
  final String collegeName;
  const Creation({super.key, required this.collegeName});

  @override
  State<Creation> createState() => _CreationState();
}

class _CreationState extends State<Creation> {
  @override
  void dispose() {
    image = null;
    super.dispose();
  }

  final ImagePicker picker = ImagePicker();
  XFile? image;

  Future<void> selectFile() async {
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (file != null) {
      image = file;
    }
  }

  void _editItem(
      {required String itemName,
      required String categoryName,
      required bool data}) {
    TextEditingController nameController =
        TextEditingController(text: itemName);
    TextEditingController priceController =
        TextEditingController(text: categoryName);
    bool selected = data;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Item',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              StatefulBuilder(builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Stock in Hand"),
                    Switch(
                      value: selected,
                      onChanged: (v) {
                        state(() {
                          selected = v;
                        });
                      },
                    ),
                  ],
                );
              })
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                FirebaseOperations.editItems(
                  categoryName: categoryName,
                  collegeName: widget.collegeName,
                  newitemName: nameController.text.trim(),
                  itemPrice: priceController.text.trim(),
                  itemImageUrl: 'itemImageUrl',
                  olditemName: itemName,
                  stockInHand: selected,
                ).whenComplete(
                  () => Navigator.pop(context),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _addItem({required String categoryName}) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  selectFile();
                },
                child: image == null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.amber,
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.amber,
                        backgroundImage: FileImage(File(image!.path)),
                      ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                print(categoryName);
                if (categoryName.isNotEmpty &&
                    nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    image != null) {
                  UploadTask dataUploaded = FirebaseOperations.firebaseStorage
                      .ref(
                          'canteenOwners/${FirebaseOperations.firebaseAuth.currentUser!.uid + "1"}/${categoryName}/${nameController.text.trim()}')
                      .putFile(File(image!.path));
                  TaskSnapshot cases = await dataUploaded.whenComplete(() {});
                  String imagePath = await cases.ref.getDownloadURL();

                  FirebaseOperations.addItems(
                          categoryName: categoryName,
                          collegeName: widget.collegeName,
                          itemName: nameController.text.trim(),
                          itemPrice: priceController.text.trim(),
                          itemImageUrl: image!)
                      .whenComplete(() => Navigator.of(context).pop());
                } else {
                  customBar(context: context, text: "Add All details");
                }
              },
            ),
          ],
        );
      },
    );
  }

  void initState() {
    super.initState();
  }

  Future<void> showAddCategoryDialog(BuildContext context) async {
    String categoryName = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: TextField(
            onChanged: (value) {
              categoryName = value;
            },
            decoration: const InputDecoration(hintText: "Enter category name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                FirebaseOperations.addCategories(
                        categoryName: categoryName,
                        collegeName: widget.collegeName)
                    .whenComplete(() => Navigator.of(context).pop());
              },
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
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Welcome to,\nProducts gallery",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            showAddCategoryDialog(context);
                          },
                          child: Container(
                            height: 20,
                            width: 100,
                            child: const Text(
                              "Add Category",
                              style: TextStyle(
                                color: Color.fromARGB(255, 2, 93, 150),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseOperations.firebaseInstance
                        .collection('college')
                        .doc(widget.collegeName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      Map<String, dynamic> data = snapshot.data!.get(
                          FirebaseOperations.firebaseAuth.currentUser!
                              .uid)['categories'] as Map<String, dynamic>;

                      List<String> categories = data.keys.toList();
                      if (categories.isNotEmpty) {
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 9),
                              child: SizedBox(
                                width: width,
                                height: 50,
                                child: ListView.builder(
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
                                              selectedCategory =
                                                  categories[index];
                                            });
                                          },
                                          child: AnimatedContainer(
                                            color: Colors.transparent,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            margin: const EdgeInsets.all(5),
                                            width: 100,
                                            height: 30,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    categories[index]
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: current == index
                                                          ? 16
                                                          : 12,
                                                      color: current == index
                                                          ? Colors.black
                                                          : Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: selectedCategory ==
                                              categories[index],
                                          child: Container(
                                            width: 5,
                                            height: 5,
                                            decoration: const BoxDecoration(
                                                color: Colors.deepPurpleAccent,
                                                shape: BoxShape.circle),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            ListView.builder(
                              itemCount: data[categories[current]].length + 1,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                List<String> items =
                                    data[categories[current]].keys.toList();

                                if (index + 1 ==
                                    data[categories[current]].length + 1) {
                                  return Card(
                                    color: Color(0xFFE6E6E6),
                                    margin: EdgeInsets.all(10.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ListTile(
                                      leading: Icon(Icons.add),
                                      title: Text('Add New Item'),
                                      onTap: () => _addItem(
                                          categoryName: selectedCategory),
                                    ),
                                  );
                                } else {
                                  return Card(
                                    color: Color(0xFFE6E6E6),
                                    margin: EdgeInsets.all(10.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            data[categories[current]]
                                                            [items[index]]
                                                        ['imageUrl'] !=
                                                    "empty"
                                                ? NetworkImage(
                                                    data[categories[current]]
                                                            [items[index]]
                                                        ['imageUrl'])
                                                : null,
                                      ),
                                      title: Text(data[categories[current]]
                                          [items[index]]['name']),
                                      subtitle: Text(data[categories[current]]
                                          [items[index]]['price']),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              bool stockData =
                                                  data[categories[current]]
                                                          [items[index]]
                                                      ['stockInHand'];

                                              _editItem(
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
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              FirebaseOperations.removeItems(
                                                categoryName: selectedCategory,
                                                collegeName: widget.collegeName,
                                                itemName:
                                                    data[categories[current]]
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
                          ],
                        );
                      } else {
                        return Center(
                          child: Text("No categories"),
                        );
                      }
                    })
              ],
            )));
  }
}
