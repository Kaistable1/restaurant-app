
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final bool readOnly;
  final int? maxLines;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;

  final double? maxHeight;
  final double? maxWidth;

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
    this.maxLines = 1,
    this.errorText,
    this.inputFormatters,
    this.maxHeight,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TextFormField remains with fixed height even with errors
        TextFormField(
          style: TextStyle(fontFamily: GoogleFonts.nunitoSans().fontFamily),
          controller: controller,
          obscureText: isObscure,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLines: maxLines,
          validator: validator,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            labelStyle: simpleText.copyWith(
                fontSize: 16, color: backgroundBlack, fontWeight: FontWeight.w500),
            hintStyle: TextStyle(
              fontFamily: GoogleFonts.nunitoSans().fontFamily,
              color: hintTextColor ?? secondaryColor.withOpacity(0.7),
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
            prefixIconConstraints: BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(vertical: 19, horizontal: 16),
            errorText: errorText, // Ensuring error text is always in place
          ),
        ),
      ],
    );
  }
}

