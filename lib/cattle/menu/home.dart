import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/color_data.dart';
import '../../utils/custom_text.dart';
import '../../utils/size_data.dart';
import 'package:projrect_annam/cattle/menu/card_model.dart';

class CattleHome extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(
        left: width * 0.04,
        right: width * 0.04,
        top: height * 0.02,
      ),
      child: Column(
        children: [
          CustomText(
            text: "Today Deals",
            size: sizeData.superHeader,
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: val.length,
              itemBuilder: (context, index) {
                return CardModel(
                    collegename: val[index][0],
              
                    weight: int.parse(val[index][1]),
                    location: val[index][2]);
              },
            ),
          )
        ],
      ),
    ));
  }
}

List<List<String>> val = [
  [
    "Sri Sai Insitute of technology",
    "20",
    "Sai Leo Nagar,West Tambaram Poonthandalam, Village, Chennai, Tamil Nadu 602109"
  ]
];
