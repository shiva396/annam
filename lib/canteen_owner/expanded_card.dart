import 'package:flutter/material.dart';
import 'package:projrect_annam/common/color_extension.dart';

class ExpandableCard extends StatefulWidget {
  const ExpandableCard({super.key});

  @override
  ExpandableCardState createState() => ExpandableCardState();
}

class ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded = false;
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Card(
        color: TColor.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              title: const Text(
                'Name: John Doe',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Time: 2:00 PM'),
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
                          border: TableBorder.all(color: TColor.primary),
                          children: const [
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Item 1'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Description 1'),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Item 2'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Description 2'),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Item 3'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Description 3'),
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
                            const Text(
                              'Amount Paid: 100 Rs',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                // Handle checkout button press
                                if (checked == false) {
                                  setState(() {
                                    checked = true;
                                  });
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: checked == false
                                    ? Colors.white
                                    : Colors.grey.shade400,
                                side: BorderSide(
                                  color: checked == false
                                      ? TColor.primary
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                'Checked Out',
                                style: TextStyle(
                                  color: checked == false
                                      ? TColor.primary
                                      : Colors.black,
                                ),
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
