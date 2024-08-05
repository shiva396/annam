import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/const/color_extension.dart';
import 'package:projrect_annam/utils/custom_text.dart';

import '../../utils/color_data.dart';
import '../../utils/size_data.dart';


class OfferView extends ConsumerStatefulWidget {
  const OfferView({super.key});

  @override
  ConsumerState<OfferView> createState() => _OfferViewState();
}

class _OfferViewState extends ConsumerState<OfferView> {
  TextEditingController txtSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    txtSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 400,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                 colorData.primaryColor(.9),
                  Colors.white,
                ],
                stops: [0.5, 0.5],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              child: Column(
                children: [
                  SizedBox(
                    height: 130,
                  ),
                  CircleAvatar(
                    radius: 58,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                    ),
                  ),
                  CustomText(text: "Name"),
                  ElevatedButton(
                    onPressed: () {
                      
                    },
                    child: CustomText(text: "Edit"),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder()),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
