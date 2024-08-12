import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/canteen/CanteenNGO/ngo.dart';
import 'package:projrect_annam/canteen/CanteenCattle/cattle.dart';
import 'package:projrect_annam/const/image_const.dart';
import 'package:projrect_annam/const/static_data.dart';
import 'package:projrect_annam/students/more/about_us.dart';
import 'package:projrect_annam/students/more/payment_details.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';

import '../../utils/color_data.dart';
import '../../utils/page_header.dart';
import '../../utils/size_data.dart';
import '../orders/my_cart.dart';
import '../orders/my_orders.dart';

class MoreView extends ConsumerStatefulWidget {
  final Map<String, dynamic>? canteenData;
  final UserRole from;
  const MoreView({
    required this.from,
    this.canteenData,
    super.key,
  });

  @override
  ConsumerState<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends ConsumerState<MoreView> {
  List moreArr = [];

  @override
  void initState() {
    super.initState();
    moreArr.addAll(
      [
        {
          "index": "1",
          "name": "Payment Details",
          "image": ImageConst.more_pay,
          "base": 0
        },
        widget.from == UserRole.student
            ? {
                "index": "2",
                "name": "My Orders",
                "image": ImageConst.myOrders,
                "base": 0
              }
            : {},
        {
          "index": "3",
          "name": "About Us",
          "image": ImageConst.aboutUs,
          "base": 0
        },
        UserRole.canteenOwner == widget.from
            ? {
                "index": "5",
                "name": "Cattle",
                "image": ImageConst.aboutUs,
                "base": 0
              }
            : {},
        UserRole.canteenOwner == widget.from
            ? {
                "index": "6",
                "name": "NGO",
                "image": ImageConst.aboutUs,
                "base": 0
              }
            : {},
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "More",
                      size: sizeData.header,
                      color: colorData.fontColor(1),
                    ),
                    IconButton(
                      onPressed: () {
                        context.push(const CartView());
                      },
                      icon: Image.asset(
                        ImageConst.shoppingCart,
                        width: sizeData.superLarge,
                        height: sizeData.superLarge,
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: moreArr.length,
                    itemBuilder: (context, index) {
                      if (moreArr[index].isNotEmpty) {
                        var mObj = moreArr[index] as Map? ?? {};
                        var countBase = mObj["base"] as int? ?? 0;

                        return InkWell(
                          onTap: () {
                            switch (mObj["index"].toString()) {
                              case "1":
                                context.push(const PaymentDetailsView());

                                break;

                              case "2":
                                context.push(MyOrders());
                                break;

                              case "3":
                                context.push(AboutUsView());
                                break;
                              case "5":
                                context.push(CanteenCattle(
                                  canteenData: widget.canteenData!,
                                ));

                                break;
                              case "6":
                                context.push(CanteenNgo());
                                break;

                              default:
                                break;
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 12),
                                  decoration: BoxDecoration(
                                      color: colorData.secondaryColor(.9),
                                      borderRadius: BorderRadius.circular(5)),
                                  margin: const EdgeInsets.only(right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: height * 0.05,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: colorData.primaryColor(.6),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                            mObj["image"].toString(),
                                            width: 25,
                                            height: 25,
                                            fit: BoxFit.contain),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          child: CustomText(
                                        text: mObj["name"].toString(),
                                      )),
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
                                          child: CustomText(
                                            text: countBase.toString(),
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
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2)),
                                        BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 4,
                                            offset: Offset(0, 2))
                                      ],
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Image.asset(ImageConst.backNext,
                                      width: 10,
                                      height: 10,
                                      color: colorData.primaryColor(1)),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
