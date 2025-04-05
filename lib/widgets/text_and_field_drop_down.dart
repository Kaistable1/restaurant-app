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
    this.fieldController,
    this.fieldValidator,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.labelText,
    this.inputFormatters,
  });

  final bool isDropDown;
  final String? labelText;
  final String? fieldHintText;
  final String? dropHintText;
  final List<String>? items;
  final TextEditingController? fieldController;
  final String? Function(String?)? fieldValidator;
  final TextInputType keyboardType;
  final dynamic Function(String?)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText!,
          style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
        ),
        SizedBox(height: 10),
        isDropDown == false
            ? CustomTextField(
              controller: fieldController,
              hintText: fieldHintText,
              validator: fieldValidator,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
            )
            : CustomDropDownWidget(
              hint: dropHintText!,
              items: items!,
              onChanged: onChanged!,
            ),
        SizedBox(height: 16),
      ],
    );
  }
}
