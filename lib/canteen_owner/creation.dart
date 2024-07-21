import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';

class Creation extends StatefulWidget {
  final String collegeName;
  Creation({super.key, required this.collegeName});
  final ImagePicker picker = ImagePicker();

  @override
  State<Creation> createState() => _CreationState();
}

class _CreationState extends State<Creation> {
  XFile? imageFile;
  @override
  void initState() {
    super.initState();
  }

  selectFile() async {
    XFile? file = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1800, maxWidth: 1800);

    if (file!.name.isNotEmpty) {
      setState(() {
        imageFile = XFile(file.path);
      });
    }
  }

  void _editItem(String itemName, String categoryName) {
    TextEditingController nameController =
        TextEditingController(text: tabs[categoryName][itemName]['name']);
    TextEditingController priceController =
        TextEditingController(text: tabs[categoryName][itemName]['price']);

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
                  categoryName,
                  widget.collegeName,
                  nameController.text.trim(),
                  priceController.text.trim(),
                  'itemImageUrl',
                  itemName,
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

  void _addItem(
    String categoryName,
  ) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item'),
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
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  selectFile();
                },
                child: Text("Add Image"),
                style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(111, 207, 201, 214)),
              ),
              SizedBox(
                height: 10,
              ),
              nameController.text.isNotEmpty
                  ? Card(
                      color: Color(0xFFE6E6E6),
                      margin: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        leading: imageFile!.name.isNotEmpty
                            ? CircleAvatar(
                                child: Image.file(
                                  File(imageFile!.path),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CircleAvatar(),
                        title: Text(nameController.text ?? " "),
                        subtitle: Text(priceController.text ?? " "),
                      ))
                  : Text("Preview")
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
              onPressed: () {
                if (categoryName.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  FirebaseOperations.addItems(
                          categoryName,
                          widget.collegeName,
                          nameController.text.trim(),
                          priceController.text.trim(),
                          'itemImageUrl')
                      .whenComplete(() => Navigator.of(context).pop());
                }
              },
            ),
          ],
        );
      },
    );
  }

  // */
  Map<String, dynamic> tabs = {
    "Lunch": <String, dynamic>{
      "apple": <String, dynamic>{
        'name': "apple",
        'price': '20',
      }
    },
  };

  Future<void> fetchData() async {
    Map<String, dynamic> fetchedData =
        await FirebaseOperations.fetchData(widget.collegeName)
            as Map<String, dynamic>;
    setState(() {
      tabs.addAll(fetchedData);
    });
  }

  Future<void> showAddCategoryDialog(BuildContext context) async {
    String categoryName = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
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
                        categoryName, widget.collegeName)
                    .whenComplete(() => Navigator.of(context).pop());
                setState(() {
                  fetchData();
                });
              },
            ),
          ],
        );
      },
    );
  }

  int current = 0;
  String selectedCategory = "Lunch";
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List<String> keys = tabs.keys.toList();
    List<String> itemValue =
        tabs[selectedCategory].keys.toList() as List<String>;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
            SizedBox(
              width: width,
              height: 50,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: keys.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            current = index;
                            selectedCategory = keys[index];
                          });
                        },
                        child: AnimatedContainer(
                          color: Colors.transparent,
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.all(5),
                          width: 100,
                          height: 30,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  keys[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: current == index ? 16 : 12,
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
                        visible: current == index,
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
            Expanded(
              child: SingleChildScrollView(
                  child: ListView.builder(
                itemCount: tabs[selectedCategory].length + 1,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == tabs[selectedCategory].length) {
                    return Card(
                      color: Color(0xFFE6E6E6),
                      margin: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.add),
                        title: Text('Add New Item'),
                        onTap: () => _addItem(selectedCategory),
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
                            // backgroundImage: AssetImage(listData[index]['image']!),
                            ),
                        title: Text(tabs[selectedCategory][itemValue[index]]
                                ['name'] ??
                            ""),
                        subtitle: Text(tabs[selectedCategory][itemValue[index]]
                                ['price'] ??
                            ""),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _editItem(
                                    tabs[selectedCategory][itemValue[index]]
                                        ['name'],
                                    selectedCategory);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                FirebaseOperations.removeItems(
                                  selectedCategory,
                                  widget.collegeName,
                                  tabs[selectedCategory][itemValue[index]]
                                      ['name'],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
