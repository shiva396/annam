import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/cattle/cattle_maintab.dart';
import 'package:projrect_annam/const/static_data.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/canteen/canteen_main_tab.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/ngo/menu/home.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';
import '../students/student_main_tab.dart';
import '../utils/size_data.dart';

class RoleSeperationPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const RoleSeperationPage({super.key, required this.userData});
  @override
  State<RoleSeperationPage> createState() => _RoleSeperationPageState();
}

class _RoleSeperationPageState extends State<RoleSeperationPage> {
  String _selectedRole = 'student';
  String _selectedCollege = '';
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _organizationController = TextEditingController();
  TextEditingController _coordinatorController = TextEditingController();

  List<DropdownMenuItem<String>> _dropdownItems = [];

  @override
  void initState() {
    super.initState();
    _fetchDropdownItems();
  }

  Future<void> _fetchDropdownItems() async {
    QuerySnapshot snapshot = await FirebaseOperations.firebaseInstance
        .collection('institutions')
        .get();
    Set<DropdownMenuItem<String>> items = snapshot.docs.map((doc) {
      return DropdownMenuItem<String>(
        value: doc.id,
        child: CustomText(text: doc.id),
      );
    }).toSet();

    setState(() {
      _dropdownItems = items.toList();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _organizationController.dispose();
    _coordinatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConst.backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(ImageConst.logo),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(10),
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              hintText: 'Choose a role',
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            dropdownColor: Colors
                                .orange[100], // Color when dropdown is open
                            value: _selectedRole,
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                value: 'student',
                                child: CustomText(text: 'Student'),
                              ),
                              DropdownMenuItem(
                                value: 'cattle_owner',
                                child: CustomText(text: 'Cattle Owner'),
                              ),
                              DropdownMenuItem(
                                value: 'canteen_owner',
                                child: CustomText(text: 'Canteen Owner'),
                              ),
                              DropdownMenuItem(
                                value: 'ngo',
                                child: CustomText(text: 'NGO'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (_selectedRole == UserRole.student.asString) ...[
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                                isExpanded: true,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  hintText: 'Choose College',
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                ),
                                dropdownColor: Colors.orange[100],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCollege = value!;
                                  });
                                },
                                items: _dropdownItems),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                          if (_selectedRole ==
                              UserRole.cattleOwner.asString) ...[
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                labelText: 'Address',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (_selectedRole ==
                              UserRole.canteenOwner.asString) ...[
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Canteen Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                                isExpanded: true,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  hintText: 'Choose College',
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                ),
                                dropdownColor: Colors.orange[100],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCollege = value!;
                                  });
                                },
                                items: _dropdownItems),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                labelText: 'Address',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                          if (_selectedRole == UserRole.ngo.asString) ...[
                            TextField(
                              controller: _organizationController,
                              decoration: const InputDecoration(
                                labelText: 'Name of Organization',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _coordinatorController,
                              decoration: const InputDecoration(
                                labelText: 'Coordinator Number',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                          const SizedBox(
                              height: 20), // Added space at the bottom
                          ElevatedButton(
                            onPressed: () async {
                              // Data store to firebase

                              if (_selectedRole == UserRole.student.asString) {
                                if (_nameController.text.trim().isNotEmpty &&
                                    _selectedCollege.isNotEmpty &&
                                    _phoneController.text.trim().isNotEmpty) {
                                  widget.userData.addAll({
                                    'name': _nameController.text.trim(),
                                    'collegeName': _selectedCollege,
                                    'phoneNumber': _phoneController.text.trim(),
                                    'image': ""
                                  });
                                } else {
                                  context.showSnackBar("Fill all");
                                }
                              } else if (_selectedRole ==
                                  UserRole.canteenOwner.asString) {
                                widget.userData.addAll({
                                  'name': _nameController.text.trim(),
                                  'collegeName': _selectedCollege,
                                  'phoneNumber': _phoneController.text.trim(),
                                  'address': _addressController.text.trim(),
                                  'image': "",
                                  'categories': {},
                                  'todayOrders': []
                                });
                              } else if (_selectedRole ==
                                  UserRole.cattleOwner.asString) {
                                widget.userData.addAll({
                                  'name': _nameController.text.trim(),
                                  'phoneNumber': _phoneController.text.trim(),
                                  'address': _addressController.text.trim(),
                                  'image': "",
                                });
                              } else if (_selectedRole ==
                                  UserRole.ngo.asString) {
                                // TODO : Validate them
                                widget.userData.addAll({
                                  'organization':
                                      _organizationController.text.trim(),
                                  'phoneNumber': _phoneController.text.trim(),
                                  'co-ordinator-phoneNumber':
                                      _coordinatorController.text.trim(),
                                });
                              } else {}
                              try {
                                FirebaseOperations.firebaseAuth
                                    .createUserWithEmailAndPassword(
                                        email: widget.userData['email'],
                                        password: widget.userData['password'])
                                    .onError((e, s) {
                                  context.showSnackBar(e.toString());
                                  context.pop();
                                  throw Error();
                                }).then((v) async {
                                  try {
                                    DocumentReference docRef = FirebaseFirestore
                                        .instance
                                        .collection('role')
                                        .doc('role');
                                    DocumentSnapshot docSnapshot =
                                        await docRef.get();
                                    Map<String, dynamic> roleMap =
                                        docSnapshot.get('role') ?? {};
                                    if (docSnapshot.exists) {
                                      if (!roleMap.containsKey(
                                          widget.userData['email'])) {
                                        roleMap[widget.userData['email']] =
                                            _selectedRole;

                                        await docRef.update({
                                          'role': roleMap,
                                        });
                                      } else {
                                        context.showSnackBar("Already exist");
                                      }
                                    } else {
                                      roleMap[widget.userData['email']] =
                                          _selectedRole;
                                      FirebaseFirestore.instance
                                          .collection('role')
                                          .doc('role')
                                          .set({
                                        'role': roleMap,
                                      });
                                    }
                                  } catch (e) {
                                    context.showSnackBar(e.toString());
                                  }

                                  if (_selectedRole ==
                                      UserRole.canteenOwner.asString) {
                                    Map<String, dynamic> user = {
                                      FirebaseOperations.firebaseAuth
                                          .currentUser!.uid: widget.userData
                                    };
                                    FirebaseOperations.firebaseInstance
                                        .collection('college')
                                        .doc(_selectedCollege.trim())
                                        .set(user, SetOptions(merge: true));
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CanteenOwner(
                                          collegeName: _selectedCollege,
                                        ),
                                      ),
                                    );
                                  } else {
                                    FirebaseOperations.firebaseInstance
                                        .collection(_selectedRole)
                                        .doc(FirebaseOperations
                                            .firebaseAuth.currentUser!.uid
                                            .trim())
                                        .set(widget.userData)
                                        .whenComplete(() {
                                      if (_selectedRole ==
                                          UserRole.student.asString) {
                                        context.pushReplacement(
                                          MainTabView(
                                            role: 'student',
                                          ),
                                        );
                                      } else if (_selectedRole ==
                                          UserRole.ngo.asString) {
                                        context.pushReplacement(NgoHome());
                                      } else if (_selectedRole ==
                                          UserRole.cattleOwner.asString) {
                                        context.pushReplacement(CattleOwner());
                                      }
                                    });
                                  }
                                });
                              } catch (e) {
                                context.showSnackBar(e.toString());
                                context.pop();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.orange),
                            ),
                            child: const CustomText(
                              text: 'Save',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
