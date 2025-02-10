import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_web_app/constants/colors.dart';

class AuthTextField extends StatelessWidget {
  final TextStyle inputStyle;
  final TextStyle hintStyle;
  final double? width;
  final double? height;
  final double borderRadius;
  final int maxLine;
  final String? hintText;
  final String? errorText; // Add this line
  final Color borderColor;
  final Color? fillColor;
  final Color? cursorColor;
  final bool obscureText;
  final bool enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsets? contentPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final List<BoxShadow>? boxShadow;
  final bool expands;
  final List<TextInputFormatter>? inputFormatterslist;

  const AuthTextField({
    super.key,
    required this.inputStyle,
    required this.hintStyle,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.hintText = '',
    this.errorText, // Add this line
    this.borderColor =  Colors.transparent,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.fillColor,
    this.cursorColor = Colors.blue,
    this.contentPadding,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.enabled = true,
    this.maxLine = 1,
    this.expands = false,
    this.boxShadow,
    this.inputFormatterslist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        boxShadow: boxShadow,
      ),
      child: TextFormField(
        inputFormatters: inputFormatterslist,
        expands: expands,
        style: inputStyle,
        obscuringCharacter: '∗',
        obscureText: obscureText,
        validator: validator,
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onTap: onTap,
        cursorColor: cursorColor,
        cursorOpacityAnimates: true,
        maxLines: expands ? null : maxLine,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:TextStyle(color: AppColors.whiteColor,fontWeight: FontWeight.w200 ) ,
          errorText: errorText, // Add this line to display error text
          filled: fillColor != null,
          fillColor: fillColor,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          contentPadding: contentPadding,
          enabled: enabled,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor,
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor,
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor,
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: Colors.red, // Color changed for error
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: Colors.red, // Color changed for focused error
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
        ),
      ),
    );
  }
}
