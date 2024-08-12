import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/cattle/cattle_maintab.dart';
import 'package:projrect_annam/const/static_data.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/auth/login_signup.dart';
import 'package:projrect_annam/canteen/canteen_main_tab.dart';
import 'package:projrect_annam/ngo/main_tab.dart';

import 'package:projrect_annam/students/student_main_tab.dart';
import 'package:projrect_annam/utils/extension_methods.dart';
import 'package:projrect_annam/utils/helper_methods.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseOperations.firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return overlayContent(
              context: context, imagePath: 'assets/rive/404.riv');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return overlayContent(
              context: context, imagePath: 'assets/rive/loading.riv');
        } else if (snapshot.hasData && snapshot.data is User) {
          return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseOperations.firebaseInstance
                  .collection('role')
                  .doc('role')
                  .snapshots(),
              builder: (context, innerData) {
                if (!innerData.hasData)
                  return overlayContent(
                      context: context, imagePath: 'assets/rive/loading.riv');

                Map<String, dynamic> allUsers = (innerData.data!.get('role'));

                if (allUsers.containsKey(snapshot.data!.email)) {
                  String role = allUsers[snapshot.data!.email];

                  if (role == UserRole.student.asString) {
                    return MainTabView(
                      role: role,
                    );
                  } else if (role == UserRole.canteenOwner.asString) {
                    try {
                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('college')
                              .snapshots(),
                          builder: (context, collegeSnapshot) {
                            if (!collegeSnapshot.hasData)
                              return overlayContent(
                                  context: context,
                                  imagePath: 'assets/rive/loading.riv');
                            String collegeName = "";

                            collegeSnapshot.data!.docs.forEach((v) {
                              Map<String, dynamic> abc =
                                  v.data() as Map<String, dynamic>;

                              if (abc.containsKey(FirebaseOperations
                                  .firebaseAuth.currentUser!.uid)) {
                                collegeName = v.id;
                              }
                            },);

                            if (collegeName.isNotEmpty) {
                              return CanteenOwner(collegeName: collegeName);
                            } else {
                              return LoginSignUp();
                            }
                          },);
                    } catch (e) {
                      context.showSnackBar('Error checking documents: $e');
                      return SizedBox();
                    }
                  } else if (role == UserRole.ngo.asString) {
                    return NgoMainTab();
                  } else if (role == UserRole.cattleOwner.asString) {
                    return CattleOwner();
                  }
                  {
                    return SizedBox();
                  }
                } else {
                  return SizedBox();
                }
              },);
        } else {
          return const LoginSignUp();
        }
      },
    );
  }
}
