import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/canteen/home/expanded_card.dart';
import 'package:projrect_annam/utils/shimmer_effect.dart';

import '../../utils/color_data.dart';
import '../../utils/custom_text.dart';
import '../../utils/size_data.dart';

class CanteenMainPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> canteenOwnerData;
  const CanteenMainPage({super.key, required this.canteenOwnerData});

  @override
  ConsumerState<CanteenMainPage> createState() => _CanteenMainPageState();
}

class _CanteenMainPageState extends ConsumerState<CanteenMainPage> {
  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
                child: CustomText(
                  text: "Today Items",
                  size: sizeData.header,
                  
                ),
              ),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseOperations.firebaseInstance
                      .collection('college')
                      .doc(widget.canteenOwnerData['collegeName']
                          .toString()
                          .trim())
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return ShimmerEffect();

                    Map<String, dynamic> datas =
                        snapshot.data!.data() as Map<String, dynamic>;

                    List studentsOrder =
                        datas[FirebaseOperations.firebaseAuth.currentUser!.uid]
                                ['todayOrders'] ??
                            [];

                    if (studentsOrder.isEmpty)
                      return Center(child: CustomText(text: "No Orders Today"));

                    return ListView.builder(
                        itemCount: studentsOrder.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseOperations.firebaseInstance
                                .collection('student')
                                .doc(studentsOrder[index])
                                .snapshots(),
                            builder: (context, innerSnapshot) {
                              if (!innerSnapshot.hasData)
                                return ShimmerEffect();
                              String studentName =
                                  innerSnapshot.data!.get('name');

                              return StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseOperations.firebaseInstance
                                      .collection('student')
                                      .doc(studentsOrder[index])
                                      .collection('orders')
                                      .doc(studentsOrder[index])
                                      .snapshots(),
                                  builder: (context, mostinnersnapshot) {
                                    if (!mostinnersnapshot.hasData)
                                      return ShimmerEffect();
                                    Map<String, dynamic> obj =
                                        mostinnersnapshot.data!.data()
                                            as Map<String, dynamic>;

                                    Map<String, dynamic> data = obj[
                                            FirebaseOperations.firebaseAuth
                                                .currentUser!.uid] ??
                                        {};
                                    if (data.isNotEmpty) {
                                      return ExpandableCard(
                                        studentId: studentsOrder[index],
                                        studentName: studentName,
                                        orderedData: data,
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  });
                            },
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
