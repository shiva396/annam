import 'package:flutter/material.dart';
import 'package:projrect_annam/common/color_extension.dart';
import 'package:projrect_annam/helper/utils.dart';
import 'package:rive/rive.dart' as rive;

class OfferView extends StatefulWidget {
  const OfferView({super.key});

  @override
  State<OfferView> createState() => _OfferViewState();
}

class _OfferViewState extends State<OfferView> {
  TextEditingController txtSearch = TextEditingController();

  @override
  void dispose() {
    txtSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 400,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  TColor.primary,
                  Colors.white,
                ],
                stops: [0.5, 0.5],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              child: Column(
                children: [
                  SizedBox(
                    height: 130,
                  ),
                  CircleAvatar(
                    radius: 58,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                    ),
                  ),
                  Text("Name"),
                  ElevatedButton(
                    onPressed: () {
                      loadingImage(
                          context: context,
                          imagePath: "assets/rive/spiral.riv");
                    },
                    child: Text("Edt"),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder()),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
