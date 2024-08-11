import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/utils/custom_text.dart';

import '../../const/static_data.dart';
import '../../utils/color_data.dart';
import '../../utils/size_data.dart';

class ExpandableCard extends ConsumerStatefulWidget {
  const ExpandableCard(
      {super.key,
      required this.from,
      required this.orderedData,
      required this.studentName,
      required this.orderId,
      required this.studentId});
  final Map<String, dynamic>? orderedData;
  final String orderId;
  final String studentName;
  final String studentId;
  final From from;

  @override
  ExpandableCardState createState() => ExpandableCardState();
}

class ExpandableCardState extends ConsumerState<ExpandableCard> {
  bool _isExpanded = false;
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    Map<String, dynamic>? filteredData;

    if (widget.orderedData != null) {
      filteredData = Map.from(widget.orderedData!)
        ..remove('totalAmount')
        ..remove('checkOut')
        ..remove('time')
        ..remove('canteenName')
        ..remove('canteenId')
        ..remove('studentId')
        ..remove('studentName');
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Card(
        color: colorData.secondaryColor(.9),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.orderId,
                  ),
                  CustomText(
                    text: widget.studentName,
                  ),
                ],
              ),
              subtitle: CustomText(text: widget.orderedData!['time']),
              trailing: IconButton(
                icon: Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
            _isExpanded
                ? Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: colorData.secondaryColor(.9)),
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: filteredData!.length,
                                separatorBuilder: ((context, index) => Divider(
                                      indent: 25,
                                      endIndent: 25,
                                      color: colorData.primaryColor(1),
                                      height: 2,
                                    )),
                                itemBuilder: ((context, index) {
                                  List<String> items =
                                      (filteredData!.keys.toList());
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 25),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: CustomText(
                                            text: filteredData[items[index]]
                                                    ['name'] +
                                                "  *  " +
                                                filteredData[items[index]]
                                                    ['quantity'],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        CustomText(
                                          text:
                                              "${filteredData[items[index]]['price']} \u{20B9}",
                                        )
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(
                                    color: colorData.primaryColor(1),
                                    height: 2,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: "Total",
                                      ),
                                      CustomText(
                                        text: widget.orderedData!['totalAmount']
                                                .toString() +
                                            ' \u{20B9}',
                                      )
                                    ],
                                  ),
                                  widget.from == From.orders
                                      ? Column(
                                          children: [
                                            const SizedBox(
                                              height: 25,
                                            ),
                                            Center(
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(),
                                                      backgroundColor: colorData
                                                          .primaryColor(1)),
                                                  child: CustomText(
                                                    text: "Checkout",
                                                    size: sizeData.subHeader,
                                                    color: colorData
                                                        .secondaryColor(1),
                                                  ),
                                                  onPressed: () {
                                                    FirebaseOperations
                                                        .checkOutItems(
                                                      orderId: widget.orderId,
                                                      studentId:
                                                          widget.studentId,
                                                    );
                                                  }),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
