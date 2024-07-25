import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';
import 'package:projrect_annam/canteen_owner/expanded_card.dart';

class CanteenMainPage extends StatefulWidget {
  final Map<String, dynamic> canteenOwnerData;
  const CanteenMainPage({super.key, required this.canteenOwnerData});

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
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseOperations.firebaseInstance
                .collection('college')
                .doc(widget.canteenOwnerData['collegeName'].toString().trim())
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

              return SizedBox(
                height: 700,
                child: ListView.builder(
                    itemCount: studentsOrder.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseOperations.firebaseInstance
                            .collection('student')
                            .doc(studentsOrder[index])
                            .snapshots(),
                        builder: (context, innerSnapshot) {
                          if (!innerSnapshot.hasData)
                            return CircularProgressIndicator();
                          String studentName = innerSnapshot.data!.get('name');

                          return StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseOperations.firebaseInstance
                                  .collection('student')
                                  .doc(studentsOrder[index])
                                  .collection('orders')
                                  .doc(studentsOrder[index])
                                  .snapshots(),
                              builder: (context, mostinnersnapshot) {
                                if (!mostinnersnapshot.hasData)
                                  return CircularProgressIndicator();
                                Map<String, dynamic> obj =
                                    mostinnersnapshot.data!.data()
                                        as Map<String, dynamic>;
                                
                                return  ExpandableCard(
                                  studentId: studentsOrder[index],
                                  studentName: studentName,
                                  orderedData: obj,
                                );
                              });
                        },
                      );
                    }),
              );
            },
          ),
        )
      ],
    );
  }
}
