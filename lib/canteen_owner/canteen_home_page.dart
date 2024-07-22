import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';
import 'package:projrect_annam/canteen_owner/expanded_card.dart';

class CanteenMainPage extends StatefulWidget {
  const CanteenMainPage({super.key});

  @override
  State<CanteenMainPage> createState() => _CanteenMainPageState();
}

class _CanteenMainPageState extends State<CanteenMainPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
        ),
        SizedBox(
          height: 20,
          child: Text(
            "Today Items",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          height: 700,
          child: SingleChildScrollView(
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseOperations.firebaseInstance
                    .collection('college')
                    .doc('sairam')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  Map<String, dynamic> datas =
                      snapshot.data!.data() as Map<String, dynamic>;
                  List studentsOrder =
                      datas[FirebaseOperations.firebaseAuth.currentUser!.uid]
                              ['todayOrders'] ??
                          [];

                  return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseOperations.firebaseInstance
                          .collection('student')
                          .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
                          .collection('orders')
                          .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, innerSnapshot) {
                        if (!innerSnapshot.hasData)
                          return CircularProgressIndicator();
                        print(innerSnapshot.data!.data());
                        return Column(
                          children: [
                            ExpandableCard(),
                          ],
                        );
                      });
                }),
          ),
        )
      ],
    );
  }
}
