import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

class CustomSeparateTextField extends StatelessWidget {
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextEditingController controller;
  final String? labelText;
  final FontWeight? fontWeight;
  final bool isSuffixIcon;
  final bool isPrefixIcon;
  final String? hintText;
  final double borderRadius;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final double fontSize;
  final int? maxLines;
  final Color? labelColor;
  final bool isBorder;
  final double? borderWidth;
  final Color? borderColor;
  final bool isShadow;
  final bool? filled;
  final Color? fillColor;
  final double elevation;
  final String? suffixText;
  final void Function(String)? onChanged;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;
  final Color? suffixTextColor;
  final bool readOnly;
  final bool? autofocus;
  final TextStyle? hintStyle;

  const CustomSeparateTextField({
    super.key,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    required this.controller,
    this.labelText,
    this.enabled = true,
    this.maxLines = 1,
    this.hintText,
    this.borderRadius = 10,
    this.fontWeight = FontWeight.w400,
    this.suffixIcon,
    this.fontSize = 16 * (5/4),
    this.isSuffixIcon = false,
    this.labelColor,
    this.isPrefixIcon = false,
    this.prefixIcon,
    this.isBorder = false,
    this.borderWidth,
    this.borderColor = AppColors.bgColor,
    this.isShadow = false,
    this.filled = false,
    this.fillColor = AppColors.whiteColor,
    this.elevation = 0,
    this.suffixText,
    this.onChanged,
    this.prefixText,
    this.inputFormatters,
    this.suffixTextColor,
    this.readOnly = false,
    this.autofocus = false,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    BorderSide borderSide = isBorder
        ? BorderSide(width: borderWidth ?? 1, color: borderColor!)
        : BorderSide.none; // No border if isBorder is false

    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          isShadow == true
              ? const BoxShadow(
            color: Color(0x26333333),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0.5,
          )
              : BoxShadow(color: fillColor!),
        ],
      ),
      child: TextFormField(
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        maxLines: maxLines,
        autofocus: autofocus!,
        readOnly: readOnly,
        obscuringCharacter: '∗',
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText,
        controller: controller,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          fontFamily: 'Nunito-Sans',
          color: AppColors.blackColor,
        ),
        decoration: InputDecoration(
          prefixText: prefixText,
          alignLabelWithHint: true,
          enabled: enabled,
          fillColor: fillColor,
          filled: filled,
          contentPadding:  EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          suffixText: suffixText,
          suffixStyle: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
            fontFamily: 'Nunito-Sans',
            color: suffixTextColor,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
            fontFamily: 'Nunito-Sans',
            color: AppColors.blackColor,
          ),
          hintText: hintText,
          hintStyle: hintStyle ??
             TextStyle(
                color: AppColors.hintText,
                fontWeight: FontWeight.w400,
                fontSize: 16 * (5/4),
                fontFamily: 'Nunito-Sans',
              ),
          suffixIcon: isSuffixIcon ? suffixIcon : null,
          prefixIcon: isPrefixIcon ? prefixIcon : null,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: OutlineInputBorder(
            borderSide: borderSide,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: borderSide,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: borderSide,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: borderSide,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: borderSide,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: borderSide,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

