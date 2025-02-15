import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/text_styles.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? btnColor;
  final String btnText;
  final Color? borderColor;
  final Function()? onTap;
  final Color? btnTextColor;
  final TextStyle? btnTextStyle;

  const CustomButton({
    super.key,
    this.height,
    this.width,
    this.btnColor,
    required this.btnText,
    required this.onTap,
    this.btnTextColor,
    this.borderColor,
    this.btnTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: width ?? double.infinity,
      height: height ?? 48,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: borderColor ?? blackColor,
          width: 1,
        ),
      ),
      color: btnColor ?? blackColor,
      onPressed: onTap,
      child: Text(btnText, style: btnTextStyle ?? btnTextCustom),
    );
  }
}
