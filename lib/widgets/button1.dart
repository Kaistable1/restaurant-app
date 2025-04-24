import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String laBelText;
  final VoidCallback? ontapp;
  final double? height;
  final double? width;
  final Color? textColor;
  final Color? borderColor;
  final Color? containerColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final BorderRadiusGeometry? radius;
  bool isPrefixIcon;
  bool isBorder;
  final Widget? iconWidget;
  final List<BoxShadow>? shadow;
  final double? borderwidth;
  final String? fontFamily;
  final EdgeInsetsGeometry? padding;

  CustomButton({
    super.key,
    required this.laBelText,
    this.ontapp,
    this.height = 45,
    this.width,
    this.textColor,
    this.borderColor,
    this.containerColor,
    this.radius,
    this.isPrefixIcon = false,
    this.isBorder = false,
    this.iconWidget,
    this.shadow,
    this.fontWeight,
    this.fontSize,
    this.borderwidth,
    this.fontFamily,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: ontapp,
        child: Container(
          padding: padding,
          height: height ?? 48,
          width: width ?? Get.width,
          decoration: BoxDecoration(
            border: isBorder == true
                ? Border.all(
                    color: borderColor ?? primaryColor,
                    width: borderwidth ?? 1,
                  )
                : null,
            color: containerColor ?? primaryColor,
            borderRadius: radius ?? BorderRadius.circular(10),
            boxShadow: shadow ??
                [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    // Light color for a subtle shadow
                    offset: const Offset(0, 4),
                    // Moves the shadow downward
                    blurRadius: 8,
                    // Controls the softness of the shadow
                    spreadRadius: 0, // Controls the spread of the shadow
                  ),
                ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isPrefixIcon == true ? iconWidget! : const SizedBox(),
              isPrefixIcon == true
                  ? const SizedBox(width: 6)
                  : const SizedBox(width: 0),
              FittedBox(
                fit: BoxFit.contain,
                child: Center(
                  child: Text(
                    laBelText,
                    style: headingText.copyWith(
                      color: textColor ?? white,
                      fontSize: fontSize ?? 16,
                      fontWeight: fontWeight ?? FontWeight.w400,
                      fontFamily:
                          fontFamily ?? GoogleFonts.nunitoSans().fontFamily,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
