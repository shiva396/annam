import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/const/static_data.dart';
import 'package:projrect_annam/ngo/history/history.dart';
import 'package:projrect_annam/ngo/menu/home.dart';
import 'package:projrect_annam/ngo/profile/profile_page.dart';
import 'package:projrect_annam/utils/helper_methods.dart';

import '../common_widget/tab_button.dart';
import '../const/image_const.dart';
import '../firebase/firebase_operations.dart';
import '../students/more/more.dart';
import '../utils/color_data.dart';

class NgoMainTab extends ConsumerStatefulWidget {
  const NgoMainTab({
    super.key,
  });

  @override
  ConsumerState<NgoMainTab> createState() => _NgoMainTabState();
}

class _NgoMainTabState extends ConsumerState<NgoMainTab> {
  Widget? selectPageView;
  void initState() {
    super.initState();
    selectPageView = NgoHome();
  }

  int selctTab = 0;
  PageStorageBucket storageBucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    CustomColorData colorData = CustomColorData.from(ref);
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseOperations.firebaseInstance
            .collection('ngo')
            .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData && selectPageView != null)
            return Scaffold(
              body: overlayContent(
                  context: context, imagePath: "assets/rive/loading.riv"),
            );

          Map<String, dynamic> ngoData =
              snapshot.data!.data() as Map<String, dynamic>;

          return SafeArea(
            child: Scaffold(
              body: PageStorage(bucket: storageBucket, child: selectPageView!),
              bottomNavigationBar: BottomAppBar(
                surfaceTintColor: colorData.fontColor(.8),
                shadowColor: Colors.black,
                elevation: 1,
                notchMargin: 12,
                height: 64,
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
                              selectPageView = NgoHome();
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
                              selectPageView = const NgoHistory(
                                userRole: UserRole.ngo,
                              );
                            }
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          isSelected: selctTab == 1),
                      TabButton(
                          title: "Profile",
                          icon: ImageConst.profiletab,
                          onTap: () {
                            if (selctTab != 3) {
                              selctTab = 3;
                              selectPageView = NgoProfilePage(ngoData: ngoData);
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
                        isSelected: selctTab == 4,
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
