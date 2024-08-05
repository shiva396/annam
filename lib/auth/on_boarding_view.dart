import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/auth/authWrapper.dart';
import 'package:projrect_annam/const/color_extension.dart';
import 'package:projrect_annam/common_widget/round_button.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/utils/color_data.dart';
import 'package:projrect_annam/utils/extension_methods.dart';
import 'package:projrect_annam/utils/size_data.dart';

import '../utils/custom_text.dart';

class OnBoardingView extends ConsumerStatefulWidget {
  const OnBoardingView({super.key});

  @override
  ConsumerState<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends ConsumerState<OnBoardingView> {
  int selectPage = 0;
  PageController controller = PageController();

  List pageArr = [
    {
      "title": "Find Food You Love",
      "subtitle":
          "Discover the best foods from over 1,000\nrestaurants and fast delivery to your\ndoorstep",
      "image": ImageConst.onboarding1,
    },
    {
      "title": "Fast Delivery",
      "subtitle": "Fast food delivery to your home, office\n wherever you are",
      "image": ImageConst.onboarding2,
    },
    {
      "title": "Live Tracking",
      "subtitle":
          "Real time tracking of your food on the app\nonce you placed the order",
      "image": ImageConst.onboarding3,
    },
  ];

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {
        selectPage = controller.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomColorData colorData = CustomColorData.from(ref);
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            PageView.builder(
              controller: controller,
              itemCount: pageArr.length,
              itemBuilder: ((context, index) {
                var pObj = pageArr[index] as Map? ?? {};
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: width,
                      height: width,
                      alignment: Alignment.center,
                      child: Image.asset(
                        pObj["image"].toString(),
                        width: width * 0.65,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: width * 0.2,
                    ),
                    CustomText(
                      text: pObj["title"].toString(),
                    ),
                    SizedBox(
                      height: width * 0.05,
                    ),
                    CustomText(
                      text: pObj["subtitle"].toString(),
                    ),
                    SizedBox(
                      height: width * 0.20,
                    ),
                  ],
                );
              }),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pageArr.map((e) {
                    var index = pageArr.indexOf(e);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                          color: index == selectPage
                              ? colorData.primaryColor(.9)
                              : colorData.secondaryColor(.2),
                          borderRadius: BorderRadius.circular(4)),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: height * 0.28,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: RoundButton(
                      title: "Next",
                      onPressed: () {
                        if (selectPage >= 2) {
                          context.pushReplacement(AuthWrapper());
                        } else {
                          setState(() {
                            selectPage = selectPage + 1;
                            controller.animateToPage(selectPage,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.bounceInOut);
                          });
                        }
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
