import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/text_styles.dart';
import 'CustomDropDownWidget.dart';
import 'custom_textfield.dart';

class TextAndFieldsOrDropDown extends StatelessWidget {
  const TextAndFieldsOrDropDown({
    super.key,
    this.isDropDown = false,
    this.fieldHintText,
    this.dropHintText,
    this.items,
    this.currentValue, // Add this to pass the current dropdown value
    this.fieldController,
    this.fieldValidator,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    required this.labelText,
    this.inputFormatters,
    this.fieldSuffixIcon,
    this.isObscure = false,
    this.dropDownValidator,
    this.maxLines = 1,
    this.readOnly = false,
    this.ontap,
  });

  final bool isDropDown;
  final String labelText;
  final String? fieldHintText;
  final String? dropHintText;
  final List<String>? items;
  final String? currentValue; // New parameter for the current dropdown value
  final TextEditingController? fieldController;
  final String? Function(String?)? fieldValidator;
  final TextInputType keyboardType;
  final dynamic Function(String?)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? fieldSuffixIcon;
  final bool isObscure;
  final String? Function(String?)? dropDownValidator;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
        ),
        SizedBox(height: 10),
        isDropDown == false
            ? CustomTextField(
          ontap: ontap,
          readOnly: readOnly,
          maxLines: maxLines,
          controller: fieldController,
          hintText: fieldHintText,
          validator: fieldValidator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          suffixIcon: fieldSuffixIcon,
          isObscure: isObscure,
        )
            : CustomDropDownWidget(
          hint: dropHintText!,
          items: items!,
          value: currentValue, // Pass the current value to the dropdown
          onChanged: onChanged!,
          validator: dropDownValidator,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}