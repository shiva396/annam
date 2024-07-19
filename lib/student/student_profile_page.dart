import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';
import 'package:projrect_annam/auth/login_signup.dart';
import 'package:projrect_annam/common_widget/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projrect_annam/helper/helper.dart';

import '../common/color_extension.dart';
import '../common_widget/round_textfield.dart';
import '../view/more/my_order_view.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({
    super.key,
  });

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  bool changeData = false;

  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  TextEditingController collegeController = TextEditingController();

  void dispose() {
    super.dispose();
    txtAddress.dispose();
    txtConfirmPassword.dispose();
    txtEmail.dispose();
    txtMobile.dispose();
    txtPassword.dispose();
    collegeController.dispose();
    txtName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: StreamBuilder<Object>(
            stream: FirebaseOperations.firebaseInstance
                .collection('student')
                .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();
              DocumentSnapshot obj = snapshot.data as DocumentSnapshot;

              String name = obj.get('name') ?? '';
              String phoneNumber = obj.get('phoneNumber') ?? '';
              String email = obj.get('email') ?? '';
              String collegeName = obj.get('collegeName') ?? '';
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                      child: image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(File(image!.path),
                                  width: 100, height: 100, fit: BoxFit.cover),
                            )
                          : Icon(
                              Icons.person,
                              size: 65,
                              color: TColor.secondaryText,
                            ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        // image =
                        //     await picker.pickImage(source: ImageSource.gallery);

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
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (con) => LoginSignUp()),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: RoundTitleTextfield(
                        readOnly: !changeData,
                        title: "Name",
                        hintText: changeData ? "Enter Name" : name,
                        controller: txtName,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: RoundTitleTextfield(
                        title: "Email",
                        readOnly: !changeData,
                        hintText: changeData ? "Enter Email" : email,
                        keyboardType: TextInputType.emailAddress,
                        controller: txtEmail,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: RoundTitleTextfield(
                        title: "Mobile No",
                        readOnly: !changeData,
                        hintText: changeData ? "Enter Mobile No" : phoneNumber,
                        controller: txtMobile,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: RoundTitleTextfield(
                        title: "Address",
                        readOnly: !changeData,
                        hintText: "Enter Address",
                        controller: txtAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: RoundTitleTextfield(
                        readOnly: !changeData,
                        title: "Password",
                        hintText: "* * * * * ",
                        obscureText: true,
                        controller: txtPassword,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: RoundTitleTextfield(
                        readOnly: !changeData,
                        title: "College Name",
                        hintText:
                            changeData ? 'Enter College Name' : collegeName,
                        obscureText: true,
                        controller: collegeController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: RoundTitleTextfield(
                        readOnly: !changeData,
                        title: "Confirm Password",
                        hintText: "* * * * * *",
                        obscureText: true,
                        controller: txtConfirmPassword,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    changeData
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: RoundButton(
                                title: "Save",
                                onPressed: () async {
                                  Map<String, dynamic> data = {};
                                  if (txtName.text.trim().isNotEmpty) {
                                    data['name'] = txtName.text.trim();
                                  }
                                  if (txtEmail.text.trim().isNotEmpty) {
                                    data['email'] =
                                        txtEmail.text.trim().toLowerCase();
                                  }
                                  if (txtMobile.text.trim().isNotEmpty) {
                                    data['phoneNumber'] = txtMobile.text.trim();
                                  }
                                  if (collegeController.text
                                      .trim()
                                      .isNotEmpty) {
                                    data['collegeName'] =
                                        collegeController.text.trim();
                                  }
                                  // Editing data
                                  FirebaseOperations.firebaseInstance
                                      .collection('student')
                                      .doc(FirebaseOperations
                                          .firebaseAuth.currentUser!.uid)
                                      .update(data);

                                  setState(() {
                                    changeData = false;
                                  });
                                }),
                          )
                        : const SizedBox(
                            height: 20,
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                  ]);
            }),
      ),
    ));
  }
}
