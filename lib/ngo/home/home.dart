import 'package:flutter/material.dart';

class utils {
  static Text cardText(
      {required text,
      Color color = Colors.black,
      double? fs = 14,
      FontWeight fw = FontWeight.w500}) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: fs, fontWeight: fw),
    );
  }

  static Widget button(
      {required Color color,
      required String text,
      required Function makecall}) {
    return GestureDetector(
      onTap: () {
        makecall;
      },
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(text),
        ),
      ),
    );
  }
}

class CardModel extends StatelessWidget {
  const CardModel(
      {super.key,
      required this.collegename,
      required this.item,
      required this.quantity,
      required this.location});
  final String collegename;
  final String item;
  final int quantity;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black38,
              offset: Offset(2, 2),
              spreadRadius: 3,
              blurRadius: 5)
        ]),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person_2),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  utils.cardText(text: collegename),
                ],
              ),
              utils.cardText(
                text: "Item : $item",
              ),
              utils.cardText(
                text: "Quantity : $quantity",
              ),
              utils.cardText(
                text: "Location : $location",
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  utils.button(
                      color: Colors.greenAccent,
                      text: "Accept",
                      makecall: () {}),
                  utils.button(
                      color: Colors.redAccent, text: "Decline", makecall: () {})
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<List<String>> val = [
  [
    "Sri Sai Insitute of technology",
    "Chappati",
    "20",
    "Sai Leo Nagar,West Tambaram Poonthandalam, Village, Chennai, Tamil Nadu 602109"
  ]
];

class NgoHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Container(height: 100, child: Center(child: Text("Today Deals"))),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: ListView.builder(
                itemCount: val.length,
                itemBuilder: (context, index) {
                  return CardModel(
                      collegename: val[index][0],
                      item: val[index][1],
                      quantity: int.parse(val[index][2]),
                      location: val[index][3]);
                },
              ),
            ),
          )
        ],
      ),
    ));
  }
}
