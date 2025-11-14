// lib/widgets/home_widgets/filter_widget.dart
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/bottom_sheet.dart';
import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../custom_widget/separate_text_field.dart';
import '../../screens/home_screen/happy_hours/happy_hours.dart';
import '../../screens/home_screen/home_controller/filter_selection_controller.dart';
import '../../screens/home_screen/home_controller/home_location_controller.dart';

class FilterWidget extends StatelessWidget {
  final HomeLocationController controller = Get.put(HomeLocationController());
  final FilterSelectionController filterController =
      Get.put(FilterSelectionController());
  final List<String> items = ['Happy Hours'];
  final List<String> diningItems = ['Breakfast', 'Lunch', 'Dinner', 'Brunch'];
  final RxBool isTapped = false.obs;
  final RxBool showFilterOptions = false.obs;

  FilterWidget({super.key}) {
    controller.selectedTop.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 10.0, left: 12, right: 10, bottom: 6),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: CustomSeparateTextField(
                    controller: controller.searchController,
                    hintText: 'Try searching for restaurant name',
                    hintStyle: const TextStyle(
                      color: AppColors.hintText,
                      fontFamily: "Nunito-Regular",
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                    isPrefixIcon: true,
                    isShadow: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: 4, top: 8, bottom: 8, right: 0),
                      child: Image.asset(
                        'assets/images/search_icon.png',
                        fit: BoxFit.contain,
                        height: 20,
                        width: 20,
                      ),
                    ),
                    isSuffixIcon: true,
                    suffixIcon: Container(
                      height: 38,
                      width: 66,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Search',
                          style: TextStyle(
                            color: AppColors.bottomSheetColor,
                            fontFamily: "Nunito-Bold",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => showFilterBottomSheet(context),
                child: Image.asset(
                  'assets/images/filter_image__.png',
                  width: 32,
                  height: 30,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SelectedFilterWidgets extends StatelessWidget {
  final String filterName;
  final VoidCallback? onTap;

  const SelectedFilterWidgets({
    super.key,
    required this.filterName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        // your Flutter SDK prefers withValues over withOpacity
        color: AppColors.primaryColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            filterName,
            style: const TextStyle(
              color: AppColors.textColor,
              fontFamily: "Nunito-Sans",
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onTap,
            child:
                const Icon(Icons.close, color: AppColors.textColor, size: 14),
          ),
        ],
      ),
    );
  }
}

class FilterBox extends StatelessWidget {
  final HomeLocationController controller = Get.put(HomeLocationController());
  final List<String> items = ['Happy Hours', 'Dinner discount'];
  final List<String> diningItems = ['Breakfast', 'Lunch', 'Dinner', 'Brunch'];

  FilterBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 7),
      child: Container(
        width: Get.width,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFEEEFF2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(width: 11),
            InkWell(
              onTap: () => controller.selectedTop.value = '',
              child: const Text(
                'Filter:',
                style: TextStyle(
                  fontFamily: 'Nunito-Regular',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    controller.top.length,
                    (index) {
                      // current can be any type, convert to String only when rendering
                      final dynamic currentDynamic = controller.top[index];
                      final dynamic selectedTopDynamic =
                          controller.selectedTop.value;

                      final bool isSelected =
                          (selectedTopDynamic != null &&
                              selectedTopDynamic == currentDynamic) ||
                              (currentDynamic == 'Discount' &&
                                  selectedTopDynamic != null &&
                                  items.contains(selectedTopDynamic)) ||
                              (currentDynamic == 'Dining' &&
                                  selectedTopDynamic != null &&
                                  diningItems.contains(selectedTopDynamic));

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: InkWell(
                          onTap: () {
                            if (currentDynamic != 'Discount') {
                              controller.selectedTop.value = currentDynamic;
                            }
                          },
                          child: Container(
                            height: 26,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.whiteColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: currentDynamic == 'Discount'
                                  ? _buildDiscountDropdown(context)
                                  : currentDynamic == 'Dining'
                                      ? _buildDiningDropdown(context)
                                      : _buildTextChip(
                                          currentDynamic, isSelected),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountDropdown(BuildContext context) {
    final dynamic selectedTopDynamic = controller.selectedTop.value;

    String? dropdownValue;
    if (selectedTopDynamic != null &&
        items.contains(selectedTopDynamic)) {
      dropdownValue = selectedTopDynamic.toString();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4, right: 4, left: 20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          iconStyleData: IconStyleData(
            icon: Image.asset(
              'assets/images/drop_down_img.png',
              width: 10,
              height: 10,
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            width: 200,
            maxHeight: 200,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          value: dropdownValue,
          hint: const Text(
            'Discount',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGrey,
              fontFamily: 'Nunito-Regular',
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Checkbox(
                    fillColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) => states.contains(MaterialState.selected)
                          ? AppColors.primaryColor
                          : AppColors.whiteColor,
                    ),
                    side: const BorderSide(color: AppColors.primaryColor),
                    value: dropdownValue == item,
                    onChanged: (selected) {
                      controller.selectedTop.value =
                          selected == true ? item : '';
                      Get.to<HappyHours>(() => const HappyHours());
                    },
                  ),
                  Text(
                    item,
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 10 : 14,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            controller.selectedTop.value =
                (value == dropdownValue) ? '' : (value ?? '');
            Get.to<HappyHours>(() => const HappyHours());
          },
        ),
      ),
    );
  }

  Widget _buildDiningDropdown(BuildContext context) {
    final dynamic selectedTopDynamic = controller.selectedTop.value;

    String? dropdownValue;
    if (selectedTopDynamic != null &&
        diningItems.contains(selectedTopDynamic)) {
      dropdownValue = selectedTopDynamic.toString();
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          iconStyleData: IconStyleData(
            icon: Image.asset(
              'assets/images/drop_down_img.png',
              width: 10,
              height: 10,
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            width: 200,
            maxHeight: 200,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          value: dropdownValue,
          hint: Padding(
            padding: const EdgeInsets.only(right: 10, left: 8),
            child: Text(
              'Dining',
              style: TextStyle(
                fontSize: Responsive.isMobile(context) ? 10 : 14,
                color: AppColors.darkGrey,
              ),
            ),
          ),
          items: diningItems.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Checkbox(
                    fillColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) => states.contains(MaterialState.selected)
                          ? AppColors.primaryColor
                          : AppColors.whiteColor,
                    ),
                    side: const BorderSide(color: AppColors.primaryColor),
                    value: dropdownValue == item,
                    onChanged: (selected) {
                      controller.selectedTop.value =
                          selected == true ? item : '';
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    item,
                    style: TextStyle(fontSize: 10, color: AppColors.darkGrey),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            controller.selectedTop.value =
                (value == dropdownValue) ? '' : (value ?? '');
          },
        ),
      ),
    );
  }

  Widget _buildTextChip(dynamic text, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Text(
        text.toString(),
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 10,
          color: isSelected ? AppColors.primaryColor : AppColors.darkGrey,
          fontFamily: 'Nunito-Regular',
        ),
      ),
    );
  }
}
