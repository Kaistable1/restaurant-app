import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? hintTextStyle;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final String? errorText;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final int? maxLines;
  final bool readOnly;
  final double borderRadius;
  final Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    this.height,
    this.width,
    this.prefixIcon,
    this.suffixIcon,
    this.hintTextStyle,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.errorText,
    this.onSaved,
    this.validator,
    this.fillColor,
    this.maxLines = 1,
    this.readOnly = false,
    this.borderRadius = 10.0,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: (hasFocus) {},
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: fillColor ?? cardColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: bdrColor.withOpacity(0.1),
                  blurRadius: 2.0,
                  spreadRadius: .5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              onChanged: onChanged,
              readOnly: readOnly,
              maxLines: maxLines,
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              onSaved: onSaved,
              validator: validator,
              style: simpleText,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                hintText: hintText,
                hintStyle: hintTextStyle ?? hintTextField,
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: hintColor.withOpacity(.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: hintColor.withOpacity(.1)),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: hintColor.withOpacity(.1)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(color: hintColor.withOpacity(.1)),
                ),
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorText!,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
