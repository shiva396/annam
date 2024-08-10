import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/auth/login_signup.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/theme/color_palette.dart';
import 'package:projrect_annam/theme/theme_toggle.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';

import '../../const/color_extension.dart';
import '../../common_widget/round_textfield.dart';
import '../../utils/color_data.dart';
import '../../utils/custom_network_image.dart';
import '../../utils/helper_methods.dart';
import '../../utils/size_data.dart';
import '../orders/my_cart.dart';

class StudentProfilePage extends ConsumerStatefulWidget {
  const StudentProfilePage({
    super.key,
    required this.studentData,
  });
  final Map<String, dynamic> studentData;

  @override
  ConsumerState<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends ConsumerState<StudentProfilePage> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  bool changeData = false;

  TextEditingController txtName = TextEditingController();

  TextEditingController txtMobile = TextEditingController();

  void dispose() {
    super.dispose();
    txtMobile.dispose();
    txtName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    String name = widget.studentData['name'] ?? '';
    String phoneNumber = widget.studentData['phoneNumber'] ?? '';
    String email = widget.studentData['email'] ?? '';
    String collegeName = widget.studentData['collegeName'] ?? '';
    String profileUrl = widget.studentData['image'] ?? '';
    
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Profile",
                      size: sizeData.header,
                      color: colorData.fontColor(1),
                    ),
                    Row(
                      children: [
                        ThemeToggle(),
                        IconButton(
                          onPressed: () {
                            context.push(CartView());
                          },
                          icon: Image.asset(
                            ImageConst.shoppingCart,
                            width: sizeData.superLarge,
                            height: sizeData.superLarge,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  width: width * 0.23,
                  height: width * 0.23,
                  decoration: BoxDecoration(
                    color: colorData.fontColor(.9),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () async {
                      
                      changeData
                          ? image = await picker.pickImage(
                              source: ImageSource.gallery)
                          : null;
                    },
                    child: image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(File(image!.path),
                                width: 100, height: 100, fit: BoxFit.cover),
                          )
                        : profileUrl.isNotEmpty
                            ? CustomNetworkImage(
                                url: profileUrl,
                                size: width * 0.9,
                                radius: width * 0.9,
                              )
                            : Icon(Icons.person,
                                size: 65, color: colorData.primaryColor(.8)),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      changeData = true;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                        text: "Edit Profile",
                        size: sizeData.regular,
                        color: colorData.fontColor(1),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Image.asset(
                        ImageConst.editPencil,
                        height: 30,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                CustomText(
                  text: name,
                  size: sizeData.header,
                  color: colorData.primaryColor(1),
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
                  child: CustomText(
                    text: "Sign Out",
                    size: sizeData.medium,
                    color: colorData.primaryColor(.8),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ColorPalette(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: RoundTitleTextfield(
                    readOnly: !changeData,
                    title: "Name",
                    hintText: changeData ? "Enter Name" : name,
                    controller: txtName,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: RoundTitleTextfield(
                    title: "Email",
                    readOnly: true,
                    hintText: email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: RoundTitleTextfield(
                    title: "Mobile No",
                    readOnly: !changeData,
                    hintText: changeData ? "Enter Mobile No" : phoneNumber,
                    controller: txtMobile,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                                Map<String, dynamic> data = {};
                                if (txtName.text.trim().isNotEmpty) {
                                  data['name'] = txtName.text.trim();
                                }
                                if (txtMobile.text.trim().isNotEmpty) {
                                  data['phoneNumber'] = txtMobile.text.trim();
                                }

                                if (image != null) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return overlayContent(
                                            context: context,
                                            imagePath:
                                                'assets/rive/loading.riv');
                                      });
                                  UploadTask dataUploaded = FirebaseOperations
                                      .firebaseStorage
                                      .ref(
                                          'students/${FirebaseOperations.firebaseAuth.currentUser!.uid}')
                                      .putFile(File(image!.path));
                                  TaskSnapshot cases =
                                      await dataUploaded.whenComplete(() {});
                                  String imagePath =
                                      await cases.ref.getDownloadURL();
                                  data['image'] = imagePath;
                                }
                                // Editing data
                                if (data.isNotEmpty) {
                                  FirebaseOperations.firebaseInstance
                                      .collection('student')
                                      .doc(FirebaseOperations
                                          .firebaseAuth.currentUser!.uid)
                                      .update(data);

                                  setState(() {
                                    changeData = false;
                                  });
                                  context.pop();
                                } else {
                                  setState(() {
                                    changeData = false;
                                  });
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
                                  changeData = false;
                                });
                              }),
                        ],
                      )
                    : const SizedBox(
                        height: 20,
                      ),
                const SizedBox(
                  height: 20,
                ),
              ])),
        ),
      ),
    );
  }
}
