import 'package:flutter/material.dart';
import 'package:projrect_annam/Firebase/firebase_operations.dart';
import 'package:projrect_annam/cattle/history/history.dart';
import 'package:projrect_annam/cattle/menu/home.dart';
import 'package:projrect_annam/cattle/profile/profile.dart';
import 'package:projrect_annam/common_widget/tab_button.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/utils/color_data.dart';
import 'package:projrect_annam/utils/helper_methods.dart';
import 'package:projrect_annam/utils/size_data.dart';
import 'package:flutter_riverpod/src/consumer.dart';

class CattleOwner extends ConsumerStatefulWidget {
  const CattleOwner({super.key});

  @override
  ConsumerState<CattleOwner> createState() => _CattleOwnerState();
}

class _CattleOwnerState extends ConsumerState<CattleOwner> {
  int selctTab = 1;
  Widget? selectPageView;
  PageStorageBucket storageBucket = PageStorageBucket();
  @override
  void initState() {
    // selectPageView = const
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return StreamBuilder<Object>(
      stream: FirebaseOperations.firebaseInstance
          .collection('cattle')
          .doc(FirebaseOperations.firebaseAuth.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData && selectPageView != null) {
          return overlayContent(
              context: context, imagePath: 'assets/rive/loading.riv');
        }

        return SafeArea(
          child: Scaffold(
            body: PageStorage(bucket: storageBucket, child: selectPageView!),
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
                      "History",
                      ImageConst.offertab,
                      selctTab == 0,
                      () {
                        _onTabSelected(0, const CattleHistory());
                      },
                    ),
                    _buildTabButton(
                      context,
                      "Home",
                      ImageConst.hometab,
                      selctTab == 1,
                      () {
                        _onTabSelected(
                          1,
                          CattleHome(),
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
                          CattleProfile(),
                        );
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
