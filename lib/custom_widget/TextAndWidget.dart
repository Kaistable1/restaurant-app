import 'package:flutter/material.dart';
import 'package:kaistable_website/custom_widget/separate_text_field.dart';

import '../constants/app_colors.dart';

class TextAndFieldWidget extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? readOnly;
  final TextEditingController? controller;
  final bool isSuffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;

  const TextAndFieldWidget({
    super.key,
    required this.labelText,
    this.hintText,
    this.suffixIcon,
    this.readOnly = false,
    this.prefixIcon,
    this.controller,
    this.isSuffixIcon = false,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'Nunito-Sans',
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        CustomSeparateTextField(
          hintText: hintText,
          controller: controller!,
          isSuffixIcon: isSuffixIcon,
          keyboardType: keyboardType,
          isShadow: true,
          readOnly: readOnly ?? false,
          obscureText: obscureText,
          suffixIcon: suffixIcon,
          validator: validator,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
