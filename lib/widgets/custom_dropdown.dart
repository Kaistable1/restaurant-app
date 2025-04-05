import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';

class DropDownButton extends StatelessWidget {
  RxBool isExpanded = false.obs;
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

  DropDownButton({
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
    final isScrollable = items.length > 3;

    return Obx(
      () => SizedBox(
        width: width,
        // height: height,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            onMenuStateChange: (isOpen) {
              isExpanded.value = isOpen;
            },
            hint: Text(
              hintText,
              style: TextStyle(
                color: Color(0xFF4F5762),
                fontFamily: fontfamily ?? "Lora-Regular",
                fontWeight: FontWeight.w400,
                fontSize: 14,
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
                          fontSize: 14,
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
                borderRadius: BorderRadius.circular(10),
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
              elevation: 0,
            ),
            iconStyleData: IconStyleData(
              icon: isExpanded.value
                  ? Icon(
                      Icons.expand_less_rounded,
                      color: AppColors.primaryColor,
                    )
                  : Icon(
                      Icons.expand_more,
                      color: AppColors.primaryColor,
                    ),
              iconSize: 30,
            ),
            dropdownStyleData: DropdownStyleData(
              // width: width,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              offset: const Offset(0, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: Radius.circular(8),
                thickness: MaterialStateProperty.all<double>(2),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
              // maxHeight: isScrollable ? 140.0 : null,
            ),
            menuItemStyleData: const MenuItemStyleData(
              // height: 40,
              padding: EdgeInsets.only(left: 16, right: 16),
            ),
          ),
        ),
      ),
    );
  }
}
