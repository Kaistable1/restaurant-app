import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import '../controller/search_controller.dart';

// Build a selectable filter row (Country, City, Language)
Widget buildFilterSection(String title, List<String> options,
    RxString selectedValue, Function(String) onSelect) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.headingTextColor,
          fontWeight: FontWeight.w700,
          fontFamily: 'Nunito-Sans',
        ),
      ),
      const SizedBox(height: 8),

      // Main container with rounded corners
      Container(
        width: Get.width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Soft shadow
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 2), // Shadow appears at bottom
            ),
          ],
          // border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.asMap().entries.map((entry) {
            int index = entry.key;
            String option = entry.value;
            bool isSelected = selectedValue.value == option;

            return GestureDetector(
              onTap: () => onSelect(option),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withOpacity(.3)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Nunito-Sans',
                      ),
                    ),
                  ),

                  // Add vertical divider `|` except for the last item
                  if (index != options.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text("|",
                          style: TextStyle(color: AppColors.primaryColor)),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),

      const SizedBox(height: 10),
    ],
  );
}

// Build expandable filters with checkboxes
Widget buildCheckboxFilter(String title, FilterController controller) {
  return Column(
    children: [
      Obx(() {
        int selectedCount = controller.getSelectedCount(title);
        return Theme(
          data: ThemeData(
            dividerColor: Colors.transparent, // No divider inside the dropdown
            expansionTileTheme: const ExpansionTileThemeData(
              iconColor: AppColors.primaryColor, // Green dropdown arrow
            ),
          ),
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                if (selectedCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "$selectedCount",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            trailing: const Icon(Icons.keyboard_arrow_down,
                color: AppColors.primaryColor),
            children: controller.filterOptions[title]!.map((option) {
              return Obx(() {
                bool isChecked =
                    controller.selectedFilters[title]!.contains(option);
                return ListTile(
                  contentPadding: EdgeInsets.zero, // Reduce vertical padding
                  dense: true,
                  leading: Checkbox(
                    activeColor: AppColors.primaryColor, // Green checkbox
                    value: isChecked,

                    onChanged: (value) =>
                        controller.toggleFilter(title, option),
                  ),
                  title: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.headingTextColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Nunito-Sans',
                    ),
                  ),
                  onTap: () {
                    controller.toggleFilter(title, option);
                  },
                );
              });
            }).toList(),
          ),
        );
      }),

      // ✅ Green Divider Between Each Filter Section (NOT inside dropdown)
      Divider(
        color: AppColors.primaryColor,
        thickness: .3, // Bold green line for better visibility
      ),
    ],
  );
}
