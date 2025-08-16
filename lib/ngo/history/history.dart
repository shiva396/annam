import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/const/static_data.dart';
import 'package:projrect_annam/utils/calandar_picker.dart';

import '../../students/orders/my_cart.dart';
import '../../utils/color_data.dart';
import '../../utils/custom_text.dart';
import '../../utils/size_data.dart';

class NgoHistory extends ConsumerStatefulWidget {
  final UserRole userRole;
  // DateTime selectedDate = DateTime.now();
  NgoHistory({required this.userRole, super.key});

  @override
  ConsumerState<NgoHistory> createState() => _NgoHistoryState();
}

class _NgoHistoryState extends ConsumerState<NgoHistory> {
  DateTime selectedDate = DateTime.now();

  _showDatePicker() {
    showDatePicker(
            barrierDismissible: false,
            context: context,
            firstDate: DateTime(2024),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
      if (value != null) {
          selectedDate = value;
        } else {
          selectedDate = DateTime.now();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;
    CustomColorData colorData = CustomColorData.from(ref);
    return SafeArea(
      child: Scaffold(
          body: Container(
        margin: EdgeInsets.only(
          left: width * 0.04,
          right: width * 0.04,
          top: height * 0.02,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "History",
                  size: sizeData.header,
                  color: colorData.fontColor(1),
                ),
                IconButton(
                    onPressed: () {
                      _showDatePicker();
                    },
                    icon: Icon(Icons.sort_outlined)),
              ],
            ),
            CalandarPicker(
              selectedDate: selectedDate.toString().trim().split(' ').first,
              userRole: widget.userRole,
            ),
          ],
        ),
      )),
    );
  }
}
