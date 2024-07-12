import 'package:flutter/material.dart';
import 'package:projrect_annam/canteen_owner/expanded_card.dart';

class CanteenMainPage extends StatefulWidget {
  const CanteenMainPage({super.key});

  @override
  State<CanteenMainPage> createState() => _CanteenMainPageState();
}

class _CanteenMainPageState extends State<CanteenMainPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 80,
        ),
        SizedBox(
          height: 20,
          child: Text(
            "Today Items",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          height: 720,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ExpandableCard(),
                ExpandableCard(),
                ExpandableCard(),
                ExpandableCard(),
                ExpandableCard(),
                ExpandableCard(),
                ExpandableCard(),
                ExpandableCard(),
                ExpandableCard(),
                ExpandableCard(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
