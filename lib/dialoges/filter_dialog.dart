import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/filter_selection_controller.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown.dart';

final controller = Get.put(FilterSelectionController());

void filterSelectionDialogueBox() {
  showDialog(
    context: Get.context!,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 16, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter',
                        style: TextStyle(
                          color: AppColors.bottomSheetColor,
                          fontFamily: "Nunito-Bold",
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.lightGrey,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Location',
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: "Nunito-Bold",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Obx(
                                  () => DropDownButton(
                                    hintText: 'Country',
                                    fontfamily: 'Nunito-Sans',
                                    items: const ["USA", "France"],
                                    containerColor: const Color(0xFFFFFFFF),
                                    textColor: Colors.grey,
                                    onChanged: (value) {
                                      controller.selectedCountry.value = value!;
                                    },
                                    selectedValue:
                                        controller.selectedCountry.value,
                                    height: 32,
                                    width: 160,
                                    hintfontsize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Obx(
                                  () => DropDownButton(
                                    height: 32,
                                    width: 180,
                                    hintText: "City",
                                    fontfamily: 'Nunito-Sans',
                                    hintfontsize: 14,
                                    dropdownItemWidth: 100,
                                    items: controller.selectedCountry.value ==
                                            'USA'
                                        ? const [
                                            "New York",
                                            "Los Angeles",
                                          ]
                                        : const [
                                            "Paris",
                                          ],
                                    selectedValue:
                                        controller.selectedCity.value,
                                    onChanged: (value) {
                                      controller.selectedCity.value = value!;
                                    },
                                    containerColor: const Color(0xFFFFFFFF),
                                    textColor: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Language',
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: "Nunito-Bold",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Obx(
                            () => DropDownButton(
                              hintText: 'Language',
                              fontfamily: 'Nunito-Sans',
                              items: const [
                                "English",
                                "French",
                                "Spanish",
                              ],
                              containerColor: const Color(0xFFFFFFFF),
                              textColor: Colors.grey,
                              onChanged: (value) {
                                controller.selectedLanguage.value = value!;
                              },
                              selectedValue: controller.selectedLanguage.value,
                              height: 32,
                              width: 160,
                              hintfontsize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Cuisines',
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: "Nunito-Bold",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              double availableWidth = constraints.maxWidth;
                              return Obx(
                                () => Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      ...List.generate(
                                        controller.filterNames.length,
                                        (index) {
                                          final name =
                                              controller.filterNames[index];
                                          final isSelected = controller
                                              .selectedFilters
                                              .contains(name);
                                          return ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: availableWidth / 1,
                                            ),
                                            child: FilterSelectionWidgetForHome(
                                              name: name,
                                              isSelected: isSelected,
                                              onTap: () =>
                                                  controller.toggleFilter(name),
                                            ),
                                          );
                                        },
                                      ),
                                    ]),
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Discount Type',
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: "Nunito-Bold",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              double availableWidth = constraints.maxWidth;
                              return Obx(
                                () => Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      ...List.generate(
                                        controller.discountType.length,
                                        (index) {
                                          final name =
                                              controller.discountType[index];
                                          final isSelected = controller
                                              .selectedDiscounts
                                              .contains(name);
                                          return ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: availableWidth / 1,
                                            ),
                                            child: FilterSelectionWidgetForHome(
                                              name: name,
                                              isSelected: isSelected,
                                              onTap: () => controller
                                                  .toggleDiscounts(name),
                                            ),
                                          );
                                        },
                                      ),
                                    ]),
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Time of Day',
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: "Nunito-Bold",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              double availableWidth = constraints.maxWidth;
                              return Obx(
                                () => Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      ...List.generate(
                                        controller.timeOfDay.length,
                                        (index) {
                                          final name =
                                              controller.timeOfDay[index];
                                          final isSelected = controller
                                              .selectedTimeOfDay
                                              .contains(name);
                                          return ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: availableWidth / 1,
                                            ),
                                            child: FilterSelectionWidgetForHome(
                                              name: name,
                                              isSelected: isSelected,
                                              onTap: () => controller
                                                  .toggleTimeOfDay(name),
                                            ),
                                          );
                                        },
                                      ),
                                    ]),
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Atmospheres',
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: "Nunito-Bold",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              double availableWidth = constraints.maxWidth;
                              return Obx(
                                () => Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      ...List.generate(
                                        controller.atmosphere.length,
                                        (index) {
                                          final name =
                                              controller.atmosphere[index];
                                          final isSelected = controller
                                              .selectedAtmosphere
                                              .contains(name);
                                          return ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: availableWidth / 1,
                                            ),
                                            child: FilterSelectionWidgetForHome(
                                              name: name,
                                              isSelected: isSelected,
                                              onTap: () => controller
                                                  .toggleAtmosphere(name),
                                            ),
                                          );
                                        },
                                      ),
                                    ]),
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Facilities/services',
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: "Nunito-Bold",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: 350,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double availableWidth = constraints.maxWidth;
                                return Obx(
                                  () => Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        ...List.generate(
                                          controller.facilities.length,
                                          (index) {
                                            final name =
                                                controller.facilities[index];
                                            final isSelected = controller
                                                .selectedFacilities
                                                .contains(name);
                                            return ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth: availableWidth / 1,
                                              ),
                                              child:
                                                  FilterSelectionWidgetForHome(
                                                name: name,
                                                isSelected: isSelected,
                                                onTap: () => controller
                                                    .toggleFacilities(name),
                                              ),
                                            );
                                          },
                                        ),
                                      ]),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Dietary Preferences',
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: "Nunito-Bold",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: 350,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double availableWidth = constraints.maxWidth;
                                return Obx(
                                  () => Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        ...List.generate(
                                          controller.dietaryPreferences.length,
                                          (index) {
                                            final name = controller
                                                .dietaryPreferences[index];
                                            final isSelected = controller
                                                .selectedDietary
                                                .contains(name);
                                            return ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth: availableWidth / 1,
                                              ),
                                              child:
                                                  FilterSelectionWidgetForHome(
                                                name: name,
                                                isSelected: isSelected,
                                                onTap: () => controller
                                                    .toggleDietary(name),
                                              ),
                                            );
                                          },
                                        ),
                                      ]),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Experience',
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: "Nunito-Bold",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: 350,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double availableWidth = constraints.maxWidth;
                                return Obx(
                                  () => Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        ...List.generate(
                                          controller.entertainment.length,
                                          (index) {
                                            final name =
                                                controller.entertainment[index];
                                            final isSelected = controller
                                                .selectedEntertainment
                                                .contains(name);
                                            return ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth: availableWidth / 1,
                                              ),
                                              child:
                                                  FilterSelectionWidgetForHome(
                                                name: name,
                                                isSelected: isSelected,
                                                onTap: () => controller
                                                    .toggleEntertainment(name),
                                              ),
                                            );
                                          },
                                        ),
                                      ]),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Price Range',
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: "Nunito-Bold",
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: 350,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double availableWidth = constraints.maxWidth;
                                return Obx(
                                  () => Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        ...List.generate(
                                          controller.priceRange.length,
                                          (index) {
                                            final name =
                                                controller.priceRange[index];
                                            final isSelected = controller
                                                .selectedPriceRange
                                                .contains(name);
                                            return ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxWidth: availableWidth / 1,
                                              ),
                                              child:
                                                  FilterSelectionWidgetForHome(
                                                name: name,
                                                isSelected: isSelected,
                                                onTap: () => controller
                                                    .togglePriceRange(name),
                                              ),
                                            );
                                          },
                                        ),
                                      ]),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: CustomButton(
                              laBelText: 'Apply',
                              height: 40,
                              width: 170,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Nunito-Sans',
                              textColor: Colors.white,
                              ontapp: () {
                                controller.aggregateSelectedFilters();
                                Get.back();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class FilterSelectionWidgetForHome extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterSelectionWidgetForHome({
    Key? key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primaryColor, width: 1),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.darkGrey,
            fontFamily: "Nunito-Sans",
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
