import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool isObscure;
  final bool isFilled;
  final Color fillColor;
  final Color borderColor;
  final Color? hintTextColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final double borderRadius;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;

  final bool readOnly;
  final int? maxLines;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
    final VoidCallback? ontap;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.isObscure = false,
    this.isFilled = false,
    this.fillColor = Colors.transparent,
    this.borderColor = lightColor,
    this.hintTextColor,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.borderRadius = 12.0,
    this.validator,
    this.readOnly = false,
    this.onChanged,
    this.maxLines = 1,
    this.errorText,
    this.inputFormatters, this.ontap, // Initialize errorText
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;
    return TextFormField(
      onTap: ontap,
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      validator: validator,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        labelStyle: simpleText.copyWith(
          fontSize: 16,
          color: backgroundBlack,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: simpleText.copyWith(
          color: hintTextColor ?? secondaryColor.withOpacity(0.4),
          fontSize: mobileView ? 14 : 16,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        alignLabelWithHint: true,
        filled: isFilled,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        prefixIcon: prefixIcon,
        prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(vertical: 19, horizontal: 16),
        errorText: errorText,
        
      ),
    );
  }
}
