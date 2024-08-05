import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/const/color_extension.dart';
import 'package:projrect_annam/common_widget/round_button.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/utils/custom_text.dart';

import '../../utils/color_data.dart';
import '../../utils/size_data.dart';
import 'checkout_message_view.dart';

class CheckoutView extends ConsumerStatefulWidget {
  const CheckoutView({super.key});

  @override
  ConsumerState<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends ConsumerState<CheckoutView> {
  List paymentArr = [
    {"name": "Cash on delivery", "icon": ImageConst.cash},
    {"name": "**** **** **** 2187", "icon": ImageConst.visa},
    {"name": "test@gmail.com", "icon": ImageConst.paypal},
  ];

  int selectMethod = -1;

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: colorData.fontColor(.9),
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
                          text: "Checkout",
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Delivery Address",
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomText(
                              text: "653 Nostrand Ave.\nBrooklyn, NY 11216",
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          TextButton(
                            onPressed: () {
                              // context.push(const ChangeAddressView());
                            },
                            child: CustomText(
                              text: "Change",
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration:
                      BoxDecoration(color: colorData.secondaryColor(.9)),
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Payment method",
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.add,
                                color: colorData.primaryColor(.9)),
                            label: CustomText(
                              text: "Add Card",
                            ),
                          )
                        ],
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: paymentArr.length,
                          itemBuilder: (context, index) {
                            var pObj = paymentArr[index] as Map? ?? {};
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 15.0),
                              decoration: BoxDecoration(
                                  color: colorData.secondaryColor(.9),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: colorData.secondaryColor(.9))),
                              child: Row(
                                children: [
                                  Image.asset(pObj["icon"].toString(),
                                      width: 50,
                                      height: 20,
                                      fit: BoxFit.contain),
                                  // const SizedBox(width: 8),
                                  Expanded(
                                    child: CustomText(
                                      text: pObj["name"],
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectMethod = index;
                                      });
                                    },
                                    child: Icon(
                                      selectMethod == index
                                          ? Icons.radio_button_on
                                          : Icons.radio_button_off,
                                      color: colorData.primaryColor(.9),
                                      size: 15,
                                    ),
                                  )
                                ],
                              ),
                            );
                          })
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration:
                      BoxDecoration(color: colorData.secondaryColor(.9)),
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Sub Total",
                          ),
                          CustomText(
                            text: "\$68",
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Delivery Cost",
                          ),
                          CustomText(
                            text: "\$2",
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Discount",
                          ),
                          CustomText(
                            text: "-\$4",
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Divider(
                        color: colorData.secondaryColor(.9),
                        height: 1,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Total",
                          ),
                          CustomText(
                            text: "\$66",
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration:
                      BoxDecoration(color: colorData.secondaryColor(.9)),
                  height: 8,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: RoundButton(
                      title: "Send Order",
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) {
                              return const CheckoutMessageView();
                            });
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
