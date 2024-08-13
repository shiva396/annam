import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projrect_annam/cattle/menu/home.dart';
import 'package:projrect_annam/history/cattle_history.dart';
import 'package:projrect_annam/history/ngo_history.dart';
import 'package:projrect_annam/history/student_history.dart';
import 'package:projrect_annam/ngo/history/history_data.dart';
import 'package:projrect_annam/students/history/history_data.dart';
import 'package:projrect_annam/students/history/order_history.dart';
import 'package:projrect_annam/utils/search.dart';
import 'package:projrect_annam/utils/shimmer.dart';
import 'package:lottie/lottie.dart';

import '../canteen/CanteenCattle/card_model.dart';
import '../canteen/CanteenNGO/card_model.dart';
import '../canteen/home/expanded_card.dart';
import '../const/static_data.dart';
import '../firebase/firebase_operations.dart';
import 'custom_text.dart';
import 'size_data.dart';

class CalandarPicker extends StatefulWidget {
  final UserRole userRole;
  final String selectedDate;
  String? selectedRoleCanteenHistory;
  CalandarPicker(
      {super.key,
      required this.userRole,
      required this.selectedDate,
      this.selectedRoleCanteenHistory});

  @override
  State<CalandarPicker> createState() => _CalandarPickerState();
}

class _CalandarPickerState extends State<CalandarPicker> {
  TextEditingController searchController = TextEditingController();
  String studentSearchText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;

    return SingleChildScrollView(
        child: _buildSingleDatePickerWithValue(
      height: height,
    ));
  }

  Widget _buildSingleDatePickerWithValue({required double height}) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: height * 0.02),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(
                text: 'Selected Date :  ',
              ),
              const SizedBox(height: 10),
              CustomText(
                text: widget.selectedDate,
              ),
              const SizedBox(height: 10),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
          if (UserRole.canteenOwner == widget.userRole) ...[
            if (widget.selectedRoleCanteenHistory == "Student") ...[
              CanteenStudentHistoryData(
                selectedDate: widget.selectedDate,
              )
            ],
            if (widget.selectedRoleCanteenHistory == "Cattle") ...[
              CanteenCattleHistoryData(
                selectedDate: widget.selectedDate,
              )
            ],
            if (widget.selectedRoleCanteenHistory == "Ngo") ...[
              CanteenNgoHistoryData(
                selectedDate: widget.selectedDate,
              )
            ]
          ],
          if (UserRole.student == widget.userRole) ...[
            StudentHistoryData(
              selectedDate: widget.selectedDate,
            )
          ],
          if (widget.userRole == UserRole.ngo) ...[
            NgoHistoryData(
              selectedDate: widget.selectedDate,
            )
          ]
        ],
      ),
    );
  }
}
