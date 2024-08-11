import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/canteen/canteen%20cattle/card_model.dart';

import 'package:projrect_annam/utils/custom_text.dart';

class CanteenCattle extends ConsumerStatefulWidget {
  const CanteenCattle({super.key});

  @override
  ConsumerState<CanteenCattle> createState() => _CanteenCattleState();
}

class _CanteenCattleState extends ConsumerState<CanteenCattle> {
  void _createPost(context) {
    TextEditingController itemweightcontroller = TextEditingController();

    DateTime timenow = DateTime.now();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: 'Add Item',
                  size: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: itemweightcontroller,
                  decoration: InputDecoration(label: Text("Item Name")),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomText(
                    text:
                        "Current time : ${timenow.toString().substring(0, timenow.toString().length - 7)}")
              ],
            ),
          );
        });
  }

  List<List<String>> val = [
    ["20"],
    ["20"],
    ["20"],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            //Act as app bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_back_ios_new_rounded)),
                CustomText(text: "Cattle post"),
                IconButton(
                    onPressed: () {
                      _createPost(context);
                    },
                    icon: Icon(Icons.add))
              ],
            ),

            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 500,
              child: ListView.builder(
                  itemCount: val.length,
                  itemBuilder: (context, index) {
                    return CanteenCattleCardModel(itemweight: val[index][0]);
                  }),
            )
          ],
        ),
      )),
    );
  }
}
