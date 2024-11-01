import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../utils/responsive.dart';

class DropDownButton extends StatelessWidget {
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
  final double? dropdownItemWidth;

  const DropDownButton({
    super.key,
    required this.hintText,
    this.height,
    this.width,
    required this.items,
    this.selectedValue,
    this.onChanged,
    this.containerColor,
    required this.textColor,
    this.hintfontsize,
    this.fontfamily,
    this.dropdownItemWidth,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          hintText,
          style: TextStyle(
            color: Color(0xFF4F5762),
            fontFamily: fontfamily ?? "Lora-Regular",
            fontWeight: FontWeight.w400,
            fontSize: hintfontsize ?? 16,
          ),
        ),
        items: items
            .map((String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              color: Color(0xFF4F5762),
              fontFamily: fontfamily ?? "Lora-Regular",
              fontWeight: FontWeight.w400,
              fontSize: hintfontsize ?? 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ))
            .toList(),
        value: items.contains(selectedValue) ? selectedValue : null,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: height,
          width: width,
          padding: EdgeInsets.only(left: 22, right: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Responsive.isMobile(context)? 4 :10),
            color: containerColor,
           boxShadow: [
          BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 3,
          blurRadius: 12,
          offset: const Offset(0, 1),
        ),
        ],
          ),
          elevation:0
        ),
        iconStyleData: IconStyleData(
          icon: Image.asset(
            'assets/images/drop_down_img.png',
            width: Responsive.isMobile(context)
                ? 12
                : Responsive.isTablet(context)
                ? 12
                : 18,
            height: Responsive.isMobile(context)
                ?12
                : Responsive.isTablet(context)
                ? 12
                : 18,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          width: width,
          decoration: BoxDecoration(
            borderRadius:BorderRadius.circular(Responsive.isMobile(context)? 4 :10),
          ),
          offset: const Offset(-0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius:  Radius.circular(Responsive.isMobile(context)? 4 :10),
            thickness: MaterialStateProperty.all<double>(2),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
