import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/responsive.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final double? height;
  final double? width;
  final List<String> items;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final Color? containerColor;
  final Color textColor;
  final double? hintfontsize;
  final String? fontfamily;

  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.items,
    this.selectedValue,
    this.onChanged,
    this.containerColor,
    this.textColor = Colors.grey,
    this.height,
    this.width, this.hintfontsize, this.fontfamily,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(Responsive.isMobile(context)? 4 :10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        icon: Align(
          alignment: Alignment.topLeft, // Aligns the dropdown icon to the right and center
          child: Image.asset(
            'assets/images/drop_down_img.png',
            width: Responsive.isMobile(context)? 8:Responsive.isTablet(context)? 12:18,
            height: Responsive.isMobile(context)? 8:Responsive.isTablet(context)? 12:18,
          ),
        ),
        value: items.contains(selectedValue) ? selectedValue : null,
        onChanged: onChanged,
        hint: Center(
          child: Text(
            hintText,
            style:  TextStyle(
              color: Color(0xFF4F5762),
              fontFamily: fontfamily??"Lora-Regular",
              fontWeight: FontWeight.w400,
              fontSize: hintfontsize ??16,
            ),
          ),
        ),
        decoration:  InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
              top: Responsive.isMobile(context)? 6:14, bottom: Responsive.isMobile(context)? 20:12,
              left: Responsive.isMobile(context)? 9:20,right: Responsive.isMobile(context)? 9:20
          ), // Center the content vertically
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style:  TextStyle(
                color: AppColors.botomSheetColor,
                fontSize: Responsive.isMobile(context)? 7:14,
                fontFamily: 'Nunito-Regular'
              ),
            ),
          );
        }).toList(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select an option';
          }
          return null;
        },
      ),
    );
  }
}
