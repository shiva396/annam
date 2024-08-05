import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/student/more/about_us_view.dart';
import 'package:projrect_annam/student/more/payment_details_view.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';

import '../../const/color_extension.dart';
import '../../utils/color_data.dart';
import '../../utils/size_data.dart';
import 'my_order_view.dart';

class MoreView extends ConsumerStatefulWidget {
  const MoreView({super.key});

  @override
 ConsumerState<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends ConsumerState<MoreView> {
  List moreArr = [
    {
      "index": "1",
      "name": "Payment Details",
      "image": ImageConst.more_pay,
      "base": 0
    },
    {
      "index": "2",
      "name": "My Orders",
      "image": ImageConst.myOrders,
      "base": 0
    },
    {
      "index": "3",
      "name": "About Us",
      "image":ImageConst.aboutUs,
      "base": 0
    },
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 46,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     CustomText(text: 
                        "More",
                      
                      ),
                      IconButton(
                        onPressed: () {
                          context.push(const MyOrderView());
                        },
                        icon: Image.asset(
                         ImageConst.shoppingCart,
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: moreArr.length,
                    itemBuilder: (context, index) {
                      var mObj = moreArr[index] as Map? ?? {};
                      var countBase = mObj["base"] as int? ?? 0;
                      return InkWell(
                        onTap: () {
                          switch (mObj["index"].toString()) {
                            case "1":
                              context.push(const PaymentDetailsView());
      
                              break;
      
                            case "2":
                              context.push(const MyOrderView());
                              break;
      
                            case "3":
                              context.push( AboutUsView());
                              break;
      
                            default:
                              context.push(const PaymentDetailsView());
                              break;
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                                decoration: BoxDecoration(
                                    color: colorData.fontColor(.9),
                                    borderRadius: BorderRadius.circular(5)),
                                margin: const EdgeInsets.only(right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: colorData.fontColor(.6),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      alignment: Alignment.center,
                                      child: Image.asset(mObj["image"].toString(),
                                          width: 25,
                                          height: 25,
                                          fit: BoxFit.contain),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child:CustomText(text: 
                                        mObj["name"].toString(),
                                      )
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    if (countBase > 0)
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(12.5)),
                                        alignment: Alignment.center,
                                        child:CustomText(text: 
                                          countBase.toString(),
                                        ),
                                      ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: colorData.secondaryColor(.9),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Image.asset(ImageConst.backNext,
                                    width: 10,
                                    height: 10,
                                    color: colorData.secondaryColor(.9)),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
