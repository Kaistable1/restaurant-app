import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/app_colors.dart';

class PreferencesSelectionWidget extends StatelessWidget {
  final String name;
  final String dinningImage;
  final bool isSelected;

  const PreferencesSelectionWidget({
    super.key,
    required this.name,
    required this.dinningImage,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 66,
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 220,
                child: Text(
                  name,
                  style: TextStyle(
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                    color: isSelected ? Colors.white : AppColors.lightGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 13*(5/4),
                  ),
                ),
              ),
              Image.asset(
                dinningImage,
                height: 54,
                width: 54,
                fit: BoxFit.fill,
              )
            ],
          ),
        ),
        SizedBox(
          height: 14,
        ),
      ],
    );
  }
}
