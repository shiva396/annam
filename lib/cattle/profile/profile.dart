import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/auth/login_signup.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projrect_annam/utils/color_data.dart';
import 'package:projrect_annam/utils/custom_network_image.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';
import 'package:projrect_annam/utils/helper_methods.dart';

import '../../common_widget/round_textfield.dart';
import '../../const/image_const.dart';
import '../../students/orders/my_cart.dart';
import '../../theme/color_palette.dart';
import '../../theme/theme_toggle.dart';
import '../../utils/size_data.dart';

class CattleProfile extends ConsumerStatefulWidget {
  const CattleProfile({
    super.key,
    // required this.ngoData,
  });
  // final Map<String, dynamic> ngoData;

  @override
  ConsumerState<CattleProfile> createState() => _CattleProfileState();
}

class _CattleProfileState extends ConsumerState<CattleProfile> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  Future<void> selectProfileImage() async {
    dynamic imageFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = imageFile;
    });
  }

  bool changeData = false;

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cordinatorPhoneNumberController =
      TextEditingController();
  TextEditingController organizationNameController = TextEditingController();

  void dispose() {
    super.dispose();
    phoneNumberController.dispose();
    cordinatorPhoneNumberController.dispose();
    organizationNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);

    double height = sizeData.height;
    double width = sizeData.width;
    // String co_ordinatorPhoneNumber =
    //     widget.ngoData['co-ordinator-phoneNumber'] ?? '';
    // String phoneNumber = widget.ngoData['phoneNumber'] ?? '';
    // String email = widget.ngoData['email'] ?? '';
    // String organization = widget.ngoData['organization'] ?? '';
    // String profileUrl = widget.ngoData['image'] ?? '';
    String co_ordinatorPhoneNumber = '';
    String phoneNumber = '';
    String email = '';
    String organization = '';
    String profileUrl = '';
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
                      ThemeToggle(),
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
                      onTap: () {
                        selectProfileImage();
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
                                  size: 65,
                                  color: colorData.secondaryColor(.9)),
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
                    text: organization,
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
                      title: "Organization",
                      hintText: changeData ? "Enter Name" : organization,
                      controller: organizationNameController,
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
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: RoundTitleTextfield(
                      title: "Cordinator mobile No",
                      readOnly: !changeData,
                      hintText: changeData
                          ? "Enter Mobile No"
                          : co_ordinatorPhoneNumber,
                      controller: cordinatorPhoneNumberController,
                      keyboardType: TextInputType.phone,
                    ),
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
                                  if (organizationNameController.text
                                      .trim()
                                      .isNotEmpty) {
                                    data['organization'] =
                                        organizationNameController.text.trim();
                                  }
                                  if (phoneNumberController.text
                                      .trim()
                                      .isNotEmpty) {
                                    data['phoneNumber'] =
                                        phoneNumberController.text.trim();
                                  }
                                  if (cordinatorPhoneNumberController.text
                                      .trim()
                                      .isNotEmpty) {
                                    data['co-ordinator-phoneNumber'] =
                                        cordinatorPhoneNumberController.text
                                            .trim();
                                  }
                                  // Editing data
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
                                            'ngo/${FirebaseOperations.firebaseAuth.currentUser!.uid}/profileImage/')
                                        .putFile(File(image!.path));
                                    TaskSnapshot cases =
                                        await dataUploaded.whenComplete(() {});
                                    String imagePath =
                                        await cases.ref.getDownloadURL();
                                    data['image'] = imagePath;
                                  }
                                  Map<String, dynamic> userdata = data;
                                  if (data.isNotEmpty) {
                                    FirebaseOperations.firebaseInstance
                                        .collection('ngo')
                                        .doc(FirebaseOperations
                                            .firebaseAuth.currentUser!.uid)
                                        .update(userdata);

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
                                    image = null;
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
                ]),
          ),
        ),
      ),
    );
  }
}
