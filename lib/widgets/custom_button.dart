import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';

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
    this.height = 48,
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
    return InkWell(
      onTap: ontapp,
      child: Container(
        padding: padding,
        height: height ?? 48,
        width: width ?? Get.width,
        decoration: BoxDecoration(
          border: isBorder == true
              ? Border.all(
                  color: borderColor ?? AppColors.primaryColor,
                  width: borderwidth ?? 1)
              : null,
          color: containerColor ?? AppColors.primaryColor,
          borderRadius: radius ?? BorderRadius.circular(10),
          boxShadow: shadow ??
              [
                BoxShadow(
                  color: Colors.white.withOpacity(0.4), // Shadow color
                  spreadRadius: 1, // Spread radius
                  blurRadius: 8, // Blur radius
                  offset: const Offset(0, 2), // Offset in the x, y direction
                ),
              ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isPrefixIcon == true ? iconWidget! : const SizedBox(),
            isPrefixIcon == true
                ? const SizedBox(
                    width: 8,
                  )
                : const SizedBox(
                    width: 0,
                  ),
            FittedBox(
              fit: BoxFit.contain,
              child: Center(
                child: Text(
                  laBelText,
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
