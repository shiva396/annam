import 'package:flutter/material.dart';
import 'package:projrect_annam/canteen/calandar_picker.dart';

class CanteenHistory extends StatefulWidget {
  const CanteenHistory({super.key});

  @override
  State<CanteenHistory> createState() => _CanteenHistoryState();
}

class _CanteenHistoryState extends State<CanteenHistory> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: const Scaffold(
        body: CalandarPicker(),
      ),
    );
  }
}
