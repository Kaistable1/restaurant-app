import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaistable_website/constants/app_colors.dart';


datSelectionWidget({
  required int index,
  required int selectIndex,
  required String text,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding:
        EdgeInsets.symmetric(horizontal: index == selectIndex ? 11 : 0),
        child: Align(
          alignment: index != selectIndex && index == 0
              ? Alignment.center
              : index != selectIndex && index == 1
              ? Alignment.center
              : Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                color: index == selectIndex ? AppColors.primaryColor : AppColors.textColor,
                fontWeight: FontWeight.w800,
                fontFamily: 'Quicksand-bold',
                fontSize: 12),
            textAlign:
            TextAlign.center, // Center the text within the container
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      if (index == selectIndex) ...{
        Container(
          width: 109, // Adjust the width to your desired value
          height: 4,
          decoration: const ShapeDecoration(
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
        ),
      }
    ],
  );
}
