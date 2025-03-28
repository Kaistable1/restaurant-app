import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

import '../main.dart';
import '../screens/nav_bar/main_screen.dart';
import 'custom_button.dart';

class ShowCaseContainer extends StatelessWidget {
  double width;
  String text;
  BuildContext showcaseContext;
  bool last;
  void Function()? onNext;
  ShowCaseContainer({
    super.key,
    required this.width,
    required this.text,
    required this.showcaseContext,
    required this.last,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: width,
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Text(text),
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: width,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CustomButton(
            ontapp: () {
              if (ShowCaseWidget.of(showcaseContext) != null) {
                ShowCaseWidget.of(showcaseContext).dismiss();
              }

              showcaseInProgress.value = false;

              Future.delayed(Duration(milliseconds: 300), () {
                Get.offAll(MainScreen());
              });
            },
            laBelText: 'Skip',
            fontSize: 12,
            fontWeight: FontWeight.w300,
            textColor: Colors.white,
            width: 50,
            height: 30,
            radius: BorderRadius.circular(15),
          ),
          CustomButton(
            ontapp: onNext ?? () {
              if (last) {
                ShowCaseWidget.of(showcaseContext).dismiss();
              } else {
                ShowCaseWidget.of(showcaseContext).next();
              }
            },
            laBelText: last ? 'Done' : 'Next',
            fontSize: 12,
            fontWeight: FontWeight.w300,
            textColor: Colors.white,
            width: 50,
            height: 30,
            radius: BorderRadius.circular(15),
          ),
        ]),
      ),
      const SizedBox(height: 16),
    ]);
  }
}
