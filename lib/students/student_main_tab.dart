import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/const/static_data.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';

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

  @override
  void initState() {
    super.initState();

    selectPageView = const StudentHistory(
      userRole: UserRole.student,
    );
  }

  @override
  void dispose() {
    // Clean up any resources here if necessary
    super.dispose();
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
        if (!snapshot.hasData && selectPageView != null) {
          return overlayContent(
              context: context, imagePath: 'assets/rive/loading.riv');
        }

        DocumentSnapshot obj = snapshot.data as DocumentSnapshot;
        Map<String, dynamic> studentData = (obj.data()) as Map<String, dynamic>;

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
                    _buildTabButton(
                      context,
                      "Orders",
                      ImageConst.shoppingCart,
                      selctTab == 0,
                      () {
                        _onTabSelected(0, const PlaceOrders());
                      },
                    ),
                    _buildTabButton(
                      context,
                      "History",
                      ImageConst.offertab,
                      selctTab == 1,
                      () {
                        _onTabSelected(
                          1,
                          StudentHistory(userRole: UserRole.student),
                        );
                      },
                    ),
                    _buildTabButton(
                      context,
                      "Profile",
                      ImageConst.profiletab,
                      selctTab == 3,
                      () {
                        _onTabSelected(
                          3,
                          StudentProfilePage(studentData: studentData),
                        );
                      },
                    ),
                    _buildTabButton(
                      context,
                      "More",
                      ImageConst.moretab,
                      selctTab == 4,
                      () {
                        _onTabSelected(4, const MoreView(from:  UserRole.student,));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTabSelected(int index, Widget pageView) {
    if (selctTab != index && mounted) {
      setState(() {
        selctTab = index;
        selectPageView = pageView;
      });
    }
  }

  Widget _buildTabButton(
    BuildContext context,
    String title,
    String icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isSelected ? 60 : 50,
      width: isSelected ? 80 : 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:
            isSelected ? Colors.black38.withOpacity(0.2) : Colors.transparent,
      ),
      child: TabButton(
        title: title,
        icon: icon,
        onTap: onTap,
        isSelected: isSelected,
      ),
    );
  }
}
