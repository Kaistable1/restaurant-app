import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';


profileTabWidget({
  required BuildContext context,
  required int index,
  required int selectIndex,
  required String text,


}) {
  final size = MediaQuery.of(context).size;
  bool isMobile = size.width < 600;
  bool isLargeScreen = size.width > 1600;

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding:
        EdgeInsets.symmetric(horizontal: index == selectIndex ? 18 : 18),
        child: Align(
          alignment: index != selectIndex && index == 0
              ? Alignment.center
              : index != selectIndex && index == 1
              ? Alignment.center
              : Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                color: index == selectIndex ? primaryColor : blackColor,
                fontWeight: FontWeight.w800,
                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                fontSize: isMobile?10:14),
            textAlign:
            TextAlign.center, // Center the text within the container
          ),
        ),
      ),
      const SizedBox(
        height: 6,
      ),
      if (index == selectIndex) ...{
        Container(
          width: selectIndex ==1?130:90, // Adjust the width to your desired value
          height: 2,
          decoration: const ShapeDecoration(
            color: primaryColor,
            shape: RoundedRectangleBorder(

            ),
          ),
        ),
      }
    ],
  );
}
