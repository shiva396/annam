import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projrect_annam/const/static_data.dart';
import 'package:projrect_annam/utils/extension_methods.dart';

import '../../utils/calandar_picker.dart';
import '../../const/image_const.dart';
import '../../utils/color_data.dart';
import '../../utils/custom_text.dart';
import '../../utils/size_data.dart';
import '../orders/my_cart.dart';

class StudentHistory extends ConsumerStatefulWidget {
  final UserRole userRole;
  const StudentHistory({required this.userRole, super.key});

  @override
  ConsumerState<StudentHistory> createState() => _StudentHistoryState();
}

class _StudentHistoryState extends ConsumerState<StudentHistory> {
  DateTime selectedDate = DateTime.now();

  _showDatePicker() {
    showDatePicker(
            context: context,
            barrierDismissible: false,
            firstDate: DateTime(2024),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        if (value != null) {
          selectedDate = value;
        } else {
          selectedDate = DateTime.now();
        }
      });
    }).onError((e, s) {
      context.showSnackBar(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    double height = sizeData.height;
    double width = sizeData.width;
    CustomColorData colorData = CustomColorData.from(ref);
    return SafeArea(
      child: Scaffold(
          body: Container(
        margin: EdgeInsets.only(
          left: width * 0.04,
          right: width * 0.04,
          top: height * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "History",
                    size: sizeData.header,
                    color: colorData.fontColor(1),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            _showDatePicker();
                          },
                          icon: Icon(Icons.sort_outlined)),
                      IconButton(
                        onPressed: () {
                          context.push(CartView());
                        },
                        icon: Image.asset(
                          ImageConst.shoppingCart,
                          width: sizeData.superLarge,
                          height: sizeData.superLarge,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              CalandarPicker(
                selectedDate: selectedDate.toString().trim().split(' ').first,
                userRole: widget.userRole,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
