import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:projrect_annam/const/static_data.dart';
import 'package:projrect_annam/utils/calandar_picker.dart';

import '../../students/orders/my_cart.dart';
import '../../utils/color_data.dart';
import '../../utils/custom_text.dart';
import '../../utils/size_data.dart';

class CanteenHistory extends ConsumerStatefulWidget {
  final UserRole userRole;
  const CanteenHistory({required this.userRole, super.key});

  @override
  ConsumerState<CanteenHistory> createState() => _CanteenHistoryState();
}

class _CanteenHistoryState extends ConsumerState<CanteenHistory> {
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

  String choosedItem = "Ngo";

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
        child: SingleChildScrollView(
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
                  Row(
                    children: [
                      DropdownButton<String>(
                          hint: Text(choosedItem),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          items: [
                            DropdownMenuItem(
                              value: "Student",
                              child: Text("Student"),
                            ),
                            DropdownMenuItem(
                              value: "Cattle",
                              child: Text("Cattle"),
                            ),
                            DropdownMenuItem(
                              value: "Ngo",
                              child: Text("Ngo"),
                            ),
                          ],
                          onChanged: (v) {
                            setState(() {
                              choosedItem = v!;
                            });
                          }),
                      IconButton(
                          onPressed: () {
                            _showDatePicker();
                          },
                          icon: Icon(Icons.sort)),
                    ],
                  )
                ],
              ),
              CalandarPicker(
                selectedRoleCanteenHistory: choosedItem,
                selectedDate: selectedDate.toString().trim().split(' ').first,
                userRole: widget.userRole,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
