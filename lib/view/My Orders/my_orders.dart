import 'package:flutter/material.dart';
import 'package:projrect_annam/common/color_extension.dart';
import 'package:projrect_annam/common_widget/round_button.dart';
import 'package:projrect_annam/view/My%20Orders/orders_card.dart';

import '../../common_widget/popular_resutaurant_row.dart';
import '../more/my_order_view.dart';

class OfferView extends StatefulWidget {
  const OfferView({super.key});

  @override
  State<OfferView> createState() => _OfferViewState();
}

class _OfferViewState extends State<OfferView> {
  TextEditingController txtSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Orders",
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 800,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MyOrdersCard(),
                      MyOrdersCard(),
                      MyOrdersCard(),
                      MyOrdersCard(),
                      MyOrdersCard(),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ]),
    ));
  }
}
