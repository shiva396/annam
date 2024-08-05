import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/common_widget/round_button.dart';
import 'package:projrect_annam/const/image_const.dart';

import '../../const/color_extension.dart';
import '../../utils/color_data.dart';
import '../../utils/custom_text.dart';
import '../../utils/size_data.dart';

class CheckoutMessageView extends ConsumerStatefulWidget {
  const CheckoutMessageView({super.key});

  @override
  ConsumerState<CheckoutMessageView> createState() =>
      _CheckoutMessageViewState();
}

class _CheckoutMessageViewState extends ConsumerState<CheckoutMessageView> {
  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      width: width,
      decoration: BoxDecoration(
          color: colorData.fontColor(.8),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: colorData.primaryColor(.9),
                  size: 25,
                ),
              )
            ],
          ),
          Image.asset(
            ImageConst.thankYou,
            width: width * 0.55,
          ),
          const SizedBox(
            height: 25,
          ),
          CustomText(
            text: "Thank You!",
          ),
          const SizedBox(
            height: 8,
          ),
          CustomText(
            text: "for your order",
          ),
          const SizedBox(
            height: 25,
          ),
          CustomText(
            text:
                "Your Order is now being processed. We will let you know once the order is picked from the outlet. Check the status of your Order",
          ),
          const SizedBox(
            height: 35,
          ),
          RoundButton(title: "Track My Order", onPressed: () {}),
          TextButton(
            onPressed: () {},
            child: CustomText(
              text: "Back To Home",
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
