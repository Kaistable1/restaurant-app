import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final FontWeight? fontWeight;
  final String title;
  final String? prefixIcon;

  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? borderClr, textColor;
  final Color? iconClr;
  final bool isPrefixIcon;
  final bool isSuffixIcon;
  final double borderRadius;
  final double suffixIconSize;
  final bool applyCustomColor;
  final double? fontSize;
  final TextStyle? textStyle;

  final double? textIconWidth;
  final Widget? suffixIconWidget;
  final List<BoxShadow>? boxShadow;

  const CustomButton({
    super.key,
    this.width = 70,
    required this.title,
    this.backgroundColor = AppColors.primaryColor,
    this.borderClr = Colors.transparent,
    this.height = 51,
    this.prefixIcon,
    this.isPrefixIcon = false,
    this.isSuffixIcon = false,
    this.onPressed,
    this.iconClr,
    this.fontWeight,
    this.textColor,
    this.borderRadius = 10,
    this.suffixIconSize = 24,
    this.applyCustomColor = false,
    this.fontSize = 16,
    this.suffixIconWidget,
    this.textIconWidth = 12,
    this.textStyle,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderClr!,
          ),
          boxShadow: boxShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isPrefixIcon == true)
              ImageIcon(
                AssetImage(prefixIcon!),
                size: 24,
                color: iconClr,
              ),
            if (isPrefixIcon == true) const SizedBox(width: 12),
            Text(
              title,
              style: textStyle,
            ),
            if (isSuffixIcon == true) SizedBox(width: textIconWidth),
            if (isSuffixIcon == true) Container(child: suffixIconWidget),
            // ImageIcon(
            //   AssetImage(suffixIcon!),
            //   size: suffixIconSize,
            //   color: iconClr,
            // ),
          ],
        ),
      ),
    );
  }
}
