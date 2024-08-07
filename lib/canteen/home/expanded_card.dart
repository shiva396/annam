import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/firebase/firebase_operations.dart';
import 'package:projrect_annam/const/color_extension.dart';
import 'package:projrect_annam/utils/custom_text.dart';

import '../../utils/color_data.dart';

class ExpandableCard extends ConsumerStatefulWidget {
  const ExpandableCard(
      {super.key,
      required this.orderedData,
      required this.studentName,
      required this.studentId});
  final Map<String, dynamic> orderedData;
  final String studentName;
  final String studentId;

  @override
  ExpandableCardState createState() => ExpandableCardState();
}

class ExpandableCardState extends ConsumerState<ExpandableCard> {
  bool _isExpanded = false;
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    CustomColorData colorData = CustomColorData.from(ref);

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
              title: const CustomText(
                text: 'Name: John Doe',
              ),
              subtitle: const CustomText(text: 'Time: 2:00 PM'),
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
                        padding: const EdgeInsets.all(16.0),
                        child: Table(
                          border: TableBorder.all(
                              color: colorData.primaryColor(.9)),
                          children: const [
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomText(text: 'Item 1'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomText(text: 'Description 1'),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomText(text: 'Item 2'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomText(text: 'Description 2'),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomText(text: 'Item 3'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CustomText(text: 'Description 3'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const CustomText(
                              text: 'Amount Paid: 100 Rs',
                            ),
                            OutlinedButton(
                              onPressed: () {
                                // Handle checkout button press
                                if (checked == false) {
                                  setState(() {
                                    checked = true;
                                  });
                                  FirebaseOperations.checkOutItems(
                                    studentId: widget.studentId,
                                  );
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: checked == false
                                    ? colorData.secondaryColor(1)
                                    : colorData.primaryColor(.2),
                                side: BorderSide(
                                  color: checked == false
                                      ? colorData.primaryColor(.9)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: CustomText(
                                text: 'Checked Out',
                                color: colorData.fontColor(1),
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
