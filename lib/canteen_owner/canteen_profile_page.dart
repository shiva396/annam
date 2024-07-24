import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';
import 'package:projrect_annam/auth/login_signup.dart';
import 'package:projrect_annam/common_widget/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projrect_annam/helper/helper.dart';

import '../common/color_extension.dart';
import '../common_widget/round_textfield.dart';
import '../view/more/my_order_view.dart';

class CanteenProfilePage extends StatefulWidget {
  const CanteenProfilePage({
    super.key,
    required this.canteenOwnerData,
  });
  final Map<String, dynamic> canteenOwnerData;

  @override
  State<CanteenProfilePage> createState() => _CanteenProfilePageState();
}

class _CanteenProfilePageState extends State<CanteenProfilePage> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  bool changeData = false;

  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  void dispose() {
    super.dispose();
    txtAddress.dispose();
    txtConfirmPassword.dispose();
    txtMobile.dispose();
    txtPassword.dispose();
    txtName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.canteenOwnerData['name'] ?? '';
    String phoneNumber = widget.canteenOwnerData['phoneNumber'] ?? '';
    String email = widget.canteenOwnerData['email'] ?? '';
    String collegeName = widget.canteenOwnerData['collegeName'] ?? '';
    String profileUrl = widget.canteenOwnerData['image'] ?? '';
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(
              height: 46,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profile",
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    onPressed: () {
                      context.push(const MyOrderView());
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
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: TColor.placeholder,
                borderRadius: BorderRadius.circular(50),
              ),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () async {
                  changeData
                      ? image =
                          await picker.pickImage(source: ImageSource.gallery)
                      : null;
                },
                child: image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(File(image!.path),
                            width: 100, height: 100, fit: BoxFit.cover),
                      )
                    : profileUrl.isNotEmpty
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(profileUrl),
                          )
                        : Icon(
                            Icons.person,
                            size: 65,
                            color: TColor.secondaryText,
                          ),
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                setState(() {
                  changeData = true;
                });
              },
              icon: Icon(
                Icons.edit,
                color: TColor.primary,
                size: 12,
              ),
              label: Text(
                "Edit Profile",
                style: TextStyle(color: TColor.primary, fontSize: 12),
              ),
            ),
            Text(
              name,
              style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            TextButton(
              onPressed: () {
                FirebaseOperations.firebaseAuth.signOut();
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (con) => LoginSignUp()),
                    (v) {
                  return false;
                });
              },
              child: Text(
                "Sign Out",
                style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: RoundTitleTextfield(
                readOnly: !changeData,
                title: "Name",
                hintText: changeData ? "Enter Name" : name,
                controller: txtName,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: RoundTitleTextfield(
                title: "Email",
                readOnly: true,
                hintText: email,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: RoundTitleTextfield(
                title: "Mobile No",
                readOnly: !changeData,
                hintText: changeData ? "Enter Mobile No" : phoneNumber,
                controller: txtMobile,
                keyboardType: TextInputType.phone,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: RoundTitleTextfield(
                title: "Address",
                readOnly: !changeData,
                hintText: "Enter Address",
                controller: txtAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: RoundTitleTextfield(
                readOnly: true,
                title: "College Name",
                hintText: collegeName,
                obscureText: true,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            changeData
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: RoundButton(
                                title: "Save",
                                onPressed: () async {
                                  Map<String, dynamic> data = {};
                                  if (txtName.text.trim().isNotEmpty) {
                                    data['name'] = txtName.text.trim();
                                  }
                                  if (txtMobile.text.trim().isNotEmpty) {
                                    data['phoneNumber'] = txtMobile.text.trim();
                                  }
                                  // Editing data
                                  if (image != null) {
                                    UploadTask dataUploaded = FirebaseOperations
                                        .firebaseStorage
                                        .ref(
                                            'canteenOwner/${FirebaseOperations.firebaseAuth.currentUser!.uid}/profileImage/')
                                        .putFile(File(image!.path));
                                    TaskSnapshot cases =
                                        await dataUploaded.whenComplete(() {});
                                    String imagePath =
                                        await cases.ref.getDownloadURL();
                                    data['image'] = imagePath;
                                  }
                                  Map<String, dynamic> userdata = {
                                    FirebaseOperations
                                        .firebaseAuth.currentUser!.uid: data
                                  };
                                  if (data.isNotEmpty) {
                                    FirebaseOperations.firebaseInstance
                                        .collection('college')
                                        .doc(widget
                                            .canteenOwnerData['collegeName'])
                                        .set(userdata, SetOptions(merge: true));

                                    setState(() {
                                      changeData = false;
                                    });
                                  } else {
                                    setState(() {
                                      changeData = false;
                                    });
                                  }
                                })),
                      ),
                      SizedBox(
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: RoundButton(
                              title: "Cancel",
                              onPressed: () async {
                                setState(() {
                                  changeData = false;
                                });
                              }),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(
                    height: 20,
                  ),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }
}
