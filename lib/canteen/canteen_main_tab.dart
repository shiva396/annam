import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/const/static_data.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/canteen/history/canteen_history.dart';
import 'package:projrect_annam/canteen/home/canteen_home_page.dart';

import 'package:projrect_annam/ngo/profile/profile_page.dart';
import 'package:projrect_annam/canteen/menu/creation.dart';
import 'package:projrect_annam/common_widget/tab_button.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/students/more/more.dart';
import 'package:projrect_annam/utils/color_data.dart';
import 'package:projrect_annam/utils/helper_methods.dart';

import 'profile/profile_page.dart';

class CanteenOwner extends ConsumerStatefulWidget {
  const CanteenOwner({
    super.key,
    required this.collegeName,
  });

  final String collegeName;

  @override
  ConsumerState<CanteenOwner> createState() => _CanteenOwnerState();
}

class _CanteenOwnerState extends ConsumerState<CanteenOwner> {
  Widget? selectPageView;

  @override
  void initState() {
    selectPageView = CanteenHistory(userRole: UserRole.canteenOwner);
    super.initState();
  }

  int selctTab = 1;
  PageStorageBucket storageBucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    CustomColorData colorData = CustomColorData.from(ref);
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseOperations.firebaseInstance
          .collection('college')
          .doc(widget.collegeName)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData && selectPageView != null) {
          return Scaffold(
            body: overlayContent(
                context: context, imagePath: "assets/rive/loading.riv"),
          );
        }

        Map<String, dynamic> canteenOwnerData =
            snapshot.data!.get(FirebaseOperations.firebaseAuth.currentUser!.uid)
                as Map<String, dynamic>;

        return SafeArea(
          child: Scaffold(
            body: PageStorage(bucket: storageBucket, child: selectPageView!),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: SizedBox(
              width: 60,
              height: 60,
              child: FloatingActionButton(
                onPressed: () {
                  if (selctTab != 2) {
                    selctTab = 2;
                    selectPageView = CanteenMainPage(
                      canteenOwnerData: canteenOwnerData,
                    );
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
                shape: const CircleBorder(),
                backgroundColor: selctTab == 2
                    ? colorData.primaryColor(.9)
                    : colorData.primaryColor(.3),
                child: Image.asset(
                  ImageConst.hometab,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              surfaceTintColor: colorData.fontColor(.8),
              shadowColor: Colors.black,
              elevation: 1,
              notchMargin: 12,
              height: 64,
              shape: const CircularNotchedRectangle(),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTabButton(
                      context,
                      "Menu",
                      ImageConst.menutab,
                      selctTab == 0,
                      () {
                        _onTabSelected(
                          0,
                          Creation(collegeName: widget.collegeName),
                        );
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
                          const CanteenHistory(
                            userRole: UserRole.canteenOwner,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 40, // Ensures space for the FAB
                      height: 40,
                    ),
                    _buildTabButton(
                      context,
                      "Profile",
                      ImageConst.profiletab,
                      selctTab == 3,
                      () {
                        _onTabSelected(
                          3,
                          CanteenProfilePage(
                            canteenOwnerData: canteenOwnerData,
                          ),
                        );
                      },
                    ),
                    _buildTabButton(
                      context,
                      "More",
                      ImageConst.moretab,
                      selctTab == 4,
                      () {
                        _onTabSelected(
                            4,
                            MoreView(
                              from: UserRole.canteenOwner,
                              canteenData: canteenOwnerData,
                            ));
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
