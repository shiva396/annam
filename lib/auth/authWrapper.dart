import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';
import 'package:projrect_annam/auth/login_signup.dart';
import 'package:projrect_annam/canteen_owner/canteen_main_tab.dart';
import 'package:projrect_annam/student/student_main_tab.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseOperations.firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the auth state
          return Center(child: const CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data is User) {
          // User is signed in, navigate to the desired page

          return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseOperations.firebaseInstance
                  .collection('role')
                  .doc('role')
                  .snapshots(),
              builder: (context, innerData) {
                if (!innerData.hasData) return CircularProgressIndicator();
                Map<String, dynamic> allUsers = (innerData.data!.get('role'));
                if (allUsers.containsKey(snapshot.data!.email)) {
                  String role = allUsers[snapshot.data!.email];
                  if (role == 'student') {
                    return MainTabView(
                      role: role,
                    );
                  } else if (role == 'canteen_owner') {
                    try {
                      StreamBuilder<QuerySnapshot>(
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

                      return SizedBox();
                    } catch (e) {
                      print('Error checking documents: $e');
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
          // User is not signed in, navigate to the sign-in screen
          return const LoginSignUp(); // Replace YourSignInScreen with the actual sign-in screen widget
        }
      },
    );
  }
}
