import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/filter_selection_controller.dart';
import '../controller/search_controller.dart';
import 'custom_button.dart';
import 'filter_widget.dart';

void showFilterBottomSheet() {
  final FilterController controller = Get.put(FilterController());

  Get.bottomSheet(
    Container(
      height: Get.height * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Row (Cancel & Clear All)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                ),
                GestureDetector(
                  onTap: controller.clearAll,
                  child: const Text("Clear all",
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // // Country, City, and Language Selection
            // Obx(() => buildFilterSection("Country", controller.countries,
            //     controller.selectedCountry, controller.selectCountry)),
            // Obx(() => buildFilterSection("City", controller.cities,
            //     controller.selectedCity, controller.selectCity)),
            // Obx(() => buildFilterSection("Language", controller.languages,
            //     controller.selectedLanguage, controller.selectLanguage)),

            Text(
              'Filter',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.headingTextColor,
                fontWeight: FontWeight.w700,
                fontFamily: 'Nunito-Sans',
              ),
            ),

            // Expandable Filter Sections with Checkboxes
            ...controller.filterOptions.keys
                .map((category) => buildCheckboxFilter(category, controller))
                .toList(),

            const SizedBox(height: 20),

            // Apply Button
            Obx(
              () => CustomButton(
                laBelText: "Apply (${controller.getTotalSelected()})",
                ontapp: () {
                  final filterSelectionController =
                      Get.find<FilterSelectionController>();
                  filterSelectionController.aggregateSelectedFilters();
                  Get.back();
                },
                height: 48,
                containerColor: AppColors.primaryColor,
                textColor: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                radius: BorderRadius.circular(8),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
