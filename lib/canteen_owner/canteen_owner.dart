import 'package:flutter/material.dart';
import 'package:projrect_annam/canteen_owner/canteen_history.dart';
import 'package:projrect_annam/canteen_owner/canteen_main_page.dart';
import 'package:projrect_annam/common/color_extension.dart';
import 'package:projrect_annam/common_widget/tab_button.dart';
import 'package:projrect_annam/view/home/home_view.dart';
import 'package:projrect_annam/view/main_tabview/main_tabview.dart';
import 'package:projrect_annam/view/menu/menu_view.dart';
import 'package:projrect_annam/view/more/more_view.dart';
import 'package:projrect_annam/view/offer/offer_view.dart';
import 'package:projrect_annam/view/profile/profile_view.dart';

class CanteenOwner extends StatefulWidget {
  const CanteenOwner({super.key});

  @override
  State<CanteenOwner> createState() => _CanteenOwnerState();
}

class _CanteenOwnerState extends State<CanteenOwner> {
  int selctTab = 2;
  Widget selectPageView = const CanteenMainPage();
  PageStorageBucket storageBucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: storageBucket, child: selectPageView),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            if (selctTab != 2) {
              selctTab = 2;
              selectPageView = const CanteenMainPage();
            }
            if (mounted) {
              setState(() {});
            }
          },
          shape: const CircleBorder(),
          backgroundColor: selctTab == 2 ? TColor.primary : TColor.placeholder,
          child: Image.asset(
            "assets/img/tab_home.png",
            width: 30,
            height: 30,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: TColor.white,
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
                  icon: "assets/img/tab_menu.png",
                  onTap: () {
                    if (selctTab != 0) {
                      selctTab = 0;
                      // selectPageView = const MenuView();
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
                  icon: "assets/img/tab_profile.png",
                  onTap: () {
                    if (selctTab != 3) {
                      selctTab = 3;
                      selectPageView = const ProfileView();
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
  }
}
