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

  @override
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
        if (!snapshot.hasData && selectPageView != null) {
          return Scaffold(
            body: overlayContent(
                context: context, imagePath: "assets/rive/loading.riv"),
          );
        }

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
                    _buildTabButton(
                      context,
                      "Menu",
                      ImageConst.menutab,
                      selctTab == 0,
                      () {
                        _onTabSelected(0, NgoHome());
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
                          const NgoHistory(userRole: UserRole.ngo),
                        );
                      },
                    ),
                    _buildTabButton(
                      context,
                      "Profile",
                      ImageConst.profiletab,
                      selctTab == 3,
                      () {
                        _onTabSelected(3, NgoProfilePage(ngoData: ngoData));
                      },
                    ),
                    _buildTabButton(
                      context,
                      "More",
                      ImageConst.moretab,
                      selctTab == 4,
                      () {
                        _onTabSelected(4, const MoreView(from: UserRole.ngo,));
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
