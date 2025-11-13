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
  // final double? topPadding;
  final bool isShadow;
  final FontWeight? hintfontWeight;
  final Widget? suffixIcon;

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
    this.prefixImagePath,
    this.imgHeight,
    this.imgWidth,
    this.suffexWidget,
    this.isShadow = true,
    this.hintfontWeight,
    // this.topPadding,
    this.suffixIcon, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: containerColor ?? Colors.white, // Set container color
        borderRadius: BorderRadius.circular(10),
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
          fontFamily: fontfamily ?? "Nunito-Regular",
          fontSize: hintfontsize ?? 16,
        ),
        cursorColor: AppColors.textColor,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF98A2B3),
            fontFamily: fontfamily ?? "Nunito-Regular",
            fontWeight: hintfontWeight ?? FontWeight.w400,
            fontSize: hintfontsize ?? 16,
          ),
          border: InputBorder.none,
          // Removes the default border
          contentPadding: EdgeInsets.only(
            top: 11,
            // bottom: Responsive.isMobile(context) ? 20 : 12,
            left: 14,
            // right: Responsive.isMobile(context) ? 9 : 20,
          ),
          suffix: suffexWidget,
          suffixIcon: suffixIcon,
          prefixIcon: prefixImagePath != null // Add this check for prefix icon
              ? Padding(
                  padding: EdgeInsets.all(15),
                  child: Image.asset(
                    prefixImagePath!,
                    fit: BoxFit.contain,
                    height: imgHeight,
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
