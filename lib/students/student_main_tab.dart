import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/const/static_data.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/const/color_extension.dart';
import 'package:projrect_annam/common_widget/tab_button.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/utils/helper_methods.dart';

import '../utils/color_data.dart';
import '../utils/size_data.dart';
import 'orders/place_orders.dart';
import 'more/more.dart';
import 'history/order_history.dart';
import 'profile/profile_page.dart';

class MainTabView extends ConsumerStatefulWidget {
  const MainTabView({super.key, required this.role});
  final String role;

  @override
  ConsumerState<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends ConsumerState<MainTabView> {
  int selctTab = 1;
  PageStorageBucket storageBucket = PageStorageBucket();
  Widget? selectPageView;
  void initState() {
    super.initState();

    selectPageView = const StudentHistory(
      userRole: UserRole.student,
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return StreamBuilder<Object>(
        stream: FirebaseOperations.firebaseInstance
            .collection('student')
            .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData && selectPageView != null)
            return overlayContent(
                context: context, imagePath: 'assets/rive/loading.riv');
          DocumentSnapshot obj = snapshot.data as DocumentSnapshot;
          Map<String, dynamic> studentData =
              (obj.data()) as Map<String, dynamic>;
          return SafeArea(
            child: Scaffold(
              body: PageStorage(bucket: storageBucket, child: selectPageView!),
              backgroundColor: const Color(0xfff5f5f5),
              bottomNavigationBar: BottomAppBar(
                surfaceTintColor: colorData.primaryColor(.9),
                shadowColor: Colors.black,
                elevation: 1,
                height: 64,
                shape: const CircularNotchedRectangle(),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AnimatedContainer(
                        duration:
                            Duration(milliseconds: 300), 
                        curve: Curves.easeInOut, 
                        height:
                            selctTab == 0 ? 60 : 50, 
                        width: selctTab == 0 ? 80 : 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selctTab == 0
                              ? Colors.black38.withOpacity(0.2)
                              : Colors.transparent, 
                        ),
                        child: TabButton(
                          title: "Orders",
                          icon: ImageConst.shoppingCart,
                          onTap: () {
                            if (selctTab != 0) {
                              setState(() {
                                selctTab = 0;
                                selectPageView = const PlaceOrders();
                              });
                            }
                          },
                          isSelected: selctTab == 0,
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: selctTab == 1 ? 60 : 50,
                        width: selctTab == 1 ? 80 : 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selctTab == 1
                              ? Colors.black38.withOpacity(0.2)
                              : Colors.transparent,
                        ),
                        child: TabButton(
                          title: "History",
                          icon: ImageConst.offertab,
                          onTap: () {
                            if (selctTab != 1) {
                              setState(() {
                                selctTab = 1;
                                selectPageView = StudentHistory(
                                  userRole: UserRole.student,
                                );
                              });
                            }
                          },
                          isSelected: selctTab == 1,
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: selctTab == 3 ? 60 : 50,
                        width: selctTab == 3 ? 80 : 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selctTab == 3
                              ? Colors.black38.withOpacity(0.2)
                              : Colors.transparent,
                        ),
                        child: TabButton(
                          title: "Profile",
                          icon: ImageConst.profiletab,
                          onTap: () {
                            if (selctTab != 3) {
                              setState(() {
                                selctTab = 3;
                                selectPageView = StudentProfilePage(
                                  studentData: studentData,
                                );
                              });
                            }
                          },
                          isSelected: selctTab == 3,
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: selctTab == 4 ? 60 : 50,
                        width: selctTab == 4 ? 80 : 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selctTab == 4
                              ? Colors.black38.withOpacity(0.2)
                              : Colors.transparent,
                        ),
                        child: TabButton(
                          title: "More",
                          icon: ImageConst.moretab,
                          onTap: () {
                            if (selctTab != 4) {
                              setState(() {
                                selctTab = 4;
                                selectPageView = const MoreView();
                              });
                            }
                          },
                          isSelected: selctTab == 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
