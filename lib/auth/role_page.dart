import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';
import 'package:projrect_annam/canteen_owner/canteen_owner.dart';
import '../student/main_tabview.dart';

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
  TextEditingController _collegeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _organizationController = TextEditingController();
  TextEditingController _coordinatorController = TextEditingController();

  List<DropdownMenuItem<String>> _dropdownItems = [];

  @override
  void initState() {
    super.initState();
    _fetchDropdownItems();
  }

  Future<void> _fetchDropdownItems() async {
    QuerySnapshot snapshot =
        await FirebaseOperations.firebaseInstance.collection('college').get();
    Set<DropdownMenuItem<String>> items = snapshot.docs.map((doc) {
      print(doc.id);
      return DropdownMenuItem<String>(
        value: doc.id,
        child: Text(doc.id),
      );
    }).toSet();

    setState(() {
      _dropdownItems = items.toList();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _collegeController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _organizationController.dispose();
    _coordinatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange, // fallback background color

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/img/logo.png'), // logo
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width *
                        0.8, // Adjusted width for responsiveness
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                          dropdownColor:
                              Colors.orange[100], // Color when dropdown is open
                          value: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                          items: [
                            DropdownMenuItem(
                              value: 'student',
                              child: Text('Student'),
                            ),
                            DropdownMenuItem(
                              value: 'cattle_owner',
                              child: Text('Cattle Owner'),
                            ),
                            DropdownMenuItem(
                              value: 'canteen_owner',
                              child: Text('Canteen Owner'),
                            ),
                            DropdownMenuItem(
                              value: 'ngo',
                              child: Text('NGO'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (_selectedRole == 'student') ...[
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _collegeController,
                            decoration: const InputDecoration(
                              labelText: 'College Name',
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
                        ],
                        if (_selectedRole == 'cattle_owner') ...[
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
                          TextField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _stateController,
                            decoration: const InputDecoration(
                              labelText: 'State',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                        if (_selectedRole == 'canteen_owner') ...[
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
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                          const SizedBox(height: 10),
                          TextField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: 'City',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _stateController,
                            decoration: const InputDecoration(
                              labelText: 'State',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                        if (_selectedRole == 'ngo') ...[
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
                        const SizedBox(height: 20), // Added space at the bottom
                        ElevatedButton(
                          onPressed: () async {
                            // Data store to firebase

                            if (_selectedRole == 'student') {
                              if (_nameController.text.trim().isNotEmpty &&
                                  _collegeController.text.trim().isNotEmpty &&
                                  _phoneController.text.trim().isNotEmpty) {
                                widget.userData.addAll({
                                  'name': _nameController.text.trim(),
                                  'collegeName': _collegeController.text.trim(),
                                  'phoneNumber': _phoneController.text.trim()
                                });
                              } else {
                                print("Fill all");
                              }
                            } else if (_selectedRole == 'canteen_owner') {
                              widget.userData.addAll({
                                'name': _nameController.text.trim(),
                                'collegeName': _selectedCollege,
                                'phoneNumber': _phoneController.text.trim(),
                                'address': _addressController.text.trim(),
                                'city': _cityController.text.trim(),
                                'state': _stateController.text.trim()
                              });
                            } else if (_selectedRole == '') {
                            } else if (_selectedRole == '') {
                            } else {}

                            FirebaseOperations.firebaseAuth
                                .createUserWithEmailAndPassword(
                                    email: widget.userData['email'],
                                    password: widget.userData['password'])
                                .then((v) async {
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
                                  if (!roleMap
                                      .containsKey(widget.userData['email'])) {
                                    roleMap[widget.userData['email']] =
                                        _selectedRole;

                                    await docRef.update({
                                      'role': roleMap,
                                    });
                                  } else {
                                    print('Already exist');
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
                                print(e.toString());
                              }
                              if (_selectedRole == 'canteen_owner') {
                                FirebaseOperations.firebaseInstance
                                    .collection('college')
                                    .doc(_selectedCollege)
                                    .collection(_nameController.text.trim())
                                    .doc(FirebaseOperations
                                        .firebaseAuth.currentUser!.uid
                                        .toString())
                                    .set(widget.userData);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CanteenOwner(
                                              role: 'canteen_owner',
                                            )));
                              } else {
                                FirebaseOperations.firebaseInstance
                                    .collection(_selectedRole)
                                    .doc(FirebaseOperations
                                        .firebaseAuth.currentUser!.uid
                                        .toString())
                                    .set(widget.userData)
                                    .whenComplete(() {
                                  if (_selectedRole == 'student') {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainTabView(
                                          role: 'student',
                                        ),
                                      ),
                                    );
                                  } else {}
                                });
                              }
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.orange),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
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
    );
  }
}
