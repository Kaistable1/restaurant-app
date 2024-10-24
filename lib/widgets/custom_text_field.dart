import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/responsive.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final Color? containerColor;
  final Color textColor;
  final double? height;
  final double? width;
  final double? hintfontsize;
  final String? fontfamily;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final int? maxLines;
  final String? prefixImagePath;
  final double? imgHeight;
  final double? imgWidth;
  final Widget? suffexWidget;
  final bool isShadow;
  final FontWeight? hintfontWeight;// Add this line

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.containerColor,
    this.textColor = Colors.grey,
    this.height,
    this.width,
    this.hintfontsize,
    this.fontfamily,
    this.controller,
    this.onChanged,
    this.maxLines,
    this.prefixImagePath, this.imgHeight, this.imgWidth, this.suffexWidget, this.isShadow = true, this.hintfontWeight, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: containerColor ?? Colors.white, // Set container color
        borderRadius: BorderRadius.circular(Responsive.isMobile(context) ? 4 : 10),
        boxShadow: isShadow // Conditional expression
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 1),
          )
        ]
            : [],
      ),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          color: textColor,
          fontFamily: fontfamily ?? "Lora-Regular",
          fontSize: hintfontsize ?? 16,
        ),
        cursorColor: AppColors.textColor,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF4F5762),
            fontFamily: fontfamily ?? "Lora-Regular",
            fontWeight: hintfontWeight??FontWeight.w400,
            fontSize: hintfontsize ?? 16,
          ),
          border: InputBorder.none, // Removes the default border
          contentPadding: EdgeInsets.only(
            top: Responsive.isMobile(context) ? 6 : 12,
            bottom: Responsive.isMobile(context) ? 20 : 12,
            left: Responsive.isMobile(context) ? 9 : 14,
            right: Responsive.isMobile(context) ? 9 : 20,
          ),
          suffix: suffexWidget,
          prefixIcon: prefixImagePath != null // Add this check for prefix icon
              ? Padding(
            padding:  EdgeInsets.all(Responsive.isMobile(context) ? 12 :14),
            child: Image.asset(
              prefixImagePath!,
              fit: BoxFit.contain,
              height: imgHeight ,
              width: imgWidth,
            ),
          )
              : null,
          // Use null if no prefix image is provided
        ),
      ),
    );
  }
}
