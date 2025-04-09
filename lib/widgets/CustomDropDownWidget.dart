import 'package:flutter/material.dart';
import 'package:savrly/constants/text_styles.dart';
import '../constants/app_colors.dart';

class CustomDropDownWidget extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value; // Add this to set the current selected value
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropDownWidget({
    required this.hint,
    required this.items,
    required this.onChanged,this.value,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value != null && items.contains(value) ? value : null, // Set the current value
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: simpleText.copyWith(
          color: secondaryColor.withOpacity(0.4),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: lightColor),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightColor),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(Icons.arrow_drop_down, color: primaryColor),
      items:
          items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: simpleText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: blackColor,
                ),
              ),
            );
          }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
