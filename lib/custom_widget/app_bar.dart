import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  bool showLead;
  Widget? backButton;
  Widget? titleWidget;
  Function()? onTap;

  CustomAppBar({super.key, this.showLead = true, this.backButton, this.titleWidget, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    title: titleWidget,
    leading: showLead ? backButton ?? BackButton(onPressed: onTap) : null,
    );

      SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          showLead ? GestureDetector(
            onTap: onTap ?? ()=>Get.back(),
            child: backButton ?? Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.transparent,
              child: Icon(Icons.arrow_back_rounded, size: 24, color: Colors.black),
            ),
          ) : const SizedBox(),


        ]
      ),
    );
  }
}
