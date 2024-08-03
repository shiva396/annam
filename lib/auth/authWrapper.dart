import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';
import 'package:projrect_annam/auth/login_signup.dart';
import 'package:projrect_annam/canteen_owner/canteen_main_tab.dart';
import 'package:projrect_annam/helper/helper.dart';
import 'package:projrect_annam/helper/utils.dart';
import 'package:projrect_annam/student/student_main_tab.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseOperations.firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Overlay(
            
          );
        } else if (snapshot.hasData && snapshot.data is User) {
          return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseOperations.firebaseInstance
                  .collection('role')
                  .doc('role')
                  .snapshots(),
              builder: (context, innerData) {
                if (!innerData.hasData)
                  return Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );

                Map<String, dynamic> allUsers = (innerData.data!.get('role'));

                if (allUsers.containsKey(snapshot.data!.email)) {
                  String role = allUsers[snapshot.data!.email];

                  if (role == 'student') {
                    return MainTabView(
                      role: role,
                    );
                  } else if (role == 'canteen_owner') {
                    try {
                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('college')
                              .snapshots(),
                          builder: (context, collegeSnapshot) {
                            if (!collegeSnapshot.hasData)
                              return CircularProgressIndicator();
                            String collegeName = "";

                            collegeSnapshot.data!.docs.forEach((v) {
                              Map<String, dynamic> abc =
                                  v.data() as Map<String, dynamic>;

                              if (abc.containsKey(FirebaseOperations
                                  .firebaseAuth.currentUser!.uid)) {
                                collegeName = v.id;
                              }
                            });

                            if (collegeName.isNotEmpty) {
                              return CanteenOwner(collegeName: collegeName);
                            } else {
                              return LoginSignUp();
                            }
                          });
                    } catch (e) {
                      customBar(
                          text: 'Error checking documents: $e',
                          context: context);
                      return SizedBox();
                    }
                  } else {
                    return SizedBox();
                  }
                } else {
                  return SizedBox();
                }
              });
        } else {
          return const LoginSignUp();
        }
      },
    );
  }
}
