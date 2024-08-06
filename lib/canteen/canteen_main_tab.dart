import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/canteen/canteen_history.dart';
import 'package:projrect_annam/canteen/canteen_home_page.dart';
import 'package:projrect_annam/canteen/canteen_profile_page.dart';
import 'package:projrect_annam/canteen/creation.dart';
import 'package:projrect_annam/const/color_extension.dart';
import 'package:projrect_annam/common_widget/tab_button.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/students/more/more.dart';
import 'package:projrect_annam/utils/color_data.dart';

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
  void initState() {
    selectPageView = Creation(collegeName: widget.collegeName);
    super.initState();
  }

  int selctTab = 0;
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
          if (!snapshot.hasData && selectPageView != null)
            return CircularProgressIndicator();

          Map<String, dynamic> canteenOwnerData = snapshot.data!
                  .get(FirebaseOperations.firebaseAuth.currentUser!.uid)
              as Map<String, dynamic>;

          return SafeArea(
            child: Scaffold(
              body: PageStorage(bucket: storageBucket, child: selectPageView!),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniCenterDocked,
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
                  backgroundColor:
                      selctTab == 2 ?  colorData.primaryColor(.9): colorData.primaryColor(.2),
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
                      TabButton(
                          title: "Menu",
                          icon: ImageConst.menutab,
                          onTap: () {
                            if (selctTab != 0) {
                              selctTab = 0;
                              selectPageView = Creation(
                                collegeName: widget.collegeName,
                              );
                            }
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          isSelected: selctTab == 0),
                      TabButton(
                          title: "History",
                          icon: ImageConst.offertab,
                          onTap: () {
                            if (selctTab != 1) {
                              selctTab = 1;
                              selectPageView = const CanteenHistory();
                            }
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          isSelected: selctTab == 1),
                      const SizedBox(
                        width: 40,
                        height: 40,
                      ),
                      TabButton(
                          title: "Profile",
                          icon: ImageConst.profiletab,
                          onTap: () {
                            if (selctTab != 3) {
                              selctTab = 3;
                              selectPageView = CanteenProfilePage(
                                canteenOwnerData: canteenOwnerData,
                              );
                            }
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          isSelected: selctTab == 3),
                      TabButton(
                          title: "More",
                          icon: ImageConst.moretab,
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
            ),
          );
        });
  }
}
