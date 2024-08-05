import 'package:flutter/material.dart';
import 'package:projrect_annam/canteen/calandar_picker.dart';

import '../utils/size_data.dart';

class CanteenHistory extends StatefulWidget {
  const CanteenHistory({super.key});

  @override
  State<CanteenHistory> createState() => _CanteenHistoryState();
}

class _CanteenHistoryState extends State<CanteenHistory> {
  @override
  Widget build(BuildContext context) {
      CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;
    return SafeArea(
      child: const Scaffold(
        body: CalandarPicker()
      ),
    );
  }
}
