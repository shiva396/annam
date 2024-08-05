import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/const/color_extension.dart';
import 'package:projrect_annam/utils/custom_text.dart';
import 'package:projrect_annam/utils/extension_methods.dart';

import '../../const/image_const.dart';
import '../../utils/color_data.dart';
import '../../utils/size_data.dart';
import 'my_order_view.dart';

class AboutUsView extends ConsumerWidget {
   AboutUsView({super.key});

  List aboutTextArr = [
    "Project Annam is an initative that is working towards reducing malnutrition and making access to healthy food easier for children",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        child:CustomText(text: 
                          "About Us",
                         
                        ),
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
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: aboutTextArr.length,
                  itemBuilder: ((context, index) {
                    var txt = aboutTextArr[index] as String? ?? "";
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                                color:colorData.primaryColor(.9),
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child:CustomText(text: 
                              txt,
                            
                            ),
                          ),
                        ],
                      ),
                    );
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
