import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';
import 'package:projrect_annam/common/color_extension.dart';
import 'package:projrect_annam/common_widget/tab_button.dart';

import 'menu/menu_view.dart';
import 'more/more_view.dart';
import 'My Orders/order_history.dart';
import 'student_profile_page.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key, required this.role});
  final String role;

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selctTab = 0;
  PageStorageBucket storageBucket = PageStorageBucket();
  Widget selectPageView = const MenuView();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: FirebaseOperations.firebaseInstance
            .collection('student')
            .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox();
          DocumentSnapshot obj = snapshot.data as DocumentSnapshot;
          Map<String, dynamic> studentData =
              (obj.data()) as Map<String, dynamic>;
          return Scaffold(
            body: PageStorage(bucket: storageBucket, child: selectPageView),
            backgroundColor: const Color(0xfff5f5f5),
            bottomNavigationBar: BottomAppBar(
              surfaceTintColor: TColor.white,
              shadowColor: Colors.black,
              elevation: 1,
              height: 64,
              shape: const CircularNotchedRectangle(),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TabButton(
                        title: "Orders",
                        icon: "assets/img/tab_menu.png",
                        onTap: () {
                          if (selctTab != 0) {
                            selctTab = 0;
                            selectPageView = const MenuView();
                          }
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        isSelected: selctTab == 0),
                    TabButton(
                        title: "History",
                        icon: "assets/img/tab_offer.png",
                        onTap: () {
                          if (selctTab != 1) {
                            selctTab = 1;
                            selectPageView = const OfferView();
                          }
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        isSelected: selctTab == 1),
                    TabButton(
                        title: "Profile",
                        icon: "assets/img/tab_profile.png",
                        onTap: () {
                          if (selctTab != 3) {
                            selctTab = 3;
                            selectPageView = StudentProfilePage(
                              studentData: studentData,
                            );
                          }
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        isSelected: selctTab == 3),
                    TabButton(
                        title: "More",
                        icon: "assets/img/tab_more.png",
                        onTap: () {
                          if (selctTab != 4) {
                            selctTab = 4;
                            selectPageView = const MoreView();
                          }
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        isSelected: selctTab == 4),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
