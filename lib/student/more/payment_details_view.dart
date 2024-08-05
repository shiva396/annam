import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/const/color_extension.dart';
import 'package:projrect_annam/common_widget/round_icon_button.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/student/more/add_card_view.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';

import '../../common_widget/round_button.dart';
import '../../utils/color_data.dart';
import '../../utils/size_data.dart';
import 'my_order_view.dart';

class PaymentDetailsView extends ConsumerStatefulWidget {
  const PaymentDetailsView({super.key});

  @override
  ConsumerState<PaymentDetailsView> createState() => _PaymentDetailsViewState();
}

class _PaymentDetailsViewState extends ConsumerState<PaymentDetailsView> {
  List cardArr = [
    {
      "icon": ImageConst.visa,
      "card": "**** **** **** 2187",
    }
  ];

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 46,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Image.asset(ImageConst.backButton,
                            width: 20, height: 20),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: CustomText(
                          text: "Payment Details",
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.push(const MyOrderView());
                        },
                        icon: Image.asset(
                          ImageConst.backButton,
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: CustomText(
                    text: "Customize your payment method",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(
                    color: colorData.secondaryColor(.9),
                    height: 1,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: colorData.fontColor(.8),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15,
                            offset: Offset(0, 9))
                      ]),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Cash/Card On Delivery",
                            ),
                            Image.asset(
                              ImageConst.check,
                              width: 20,
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Divider(
                          color: colorData.secondaryColor(.9),
                          height: 1,
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: cardArr.length,
                        itemBuilder: ((context, index) {
                          var cObj = cardArr[index] as Map? ?? {};
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 35),
                            child: Row(
                              children: [
                                Image.asset(
                                  cObj["icon"].toString(),
                                  width: 50,
                                  height: 35,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: CustomText(
                                    text: cObj["card"].toString(),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 28,
                                  child: RoundButton(
                                    title: 'Delete Card',
                                    fontSize: 12,
                                    onPressed: () {},
                                    type: RoundButtonType.textPrimary,
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Divider(
                          color: colorData.secondaryColor(.9),
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Other Methods",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: RoundIconButton(
                      title: "Add Another Credit/Debit Card",
                      icon: ImageConst.addCard,
                      color: colorData.primaryColor(.9),
                      fontSize: 16,
                      onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return const AddCardView();
                            });
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCardView() ));
                      }),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
