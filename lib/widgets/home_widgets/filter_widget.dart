import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../custom_widget/separate_text_field.dart';
import '../../dialoges/filter_dialog.dart';
import '../../screens/home_screen/happy_hours/happy_hours.dart';
import '../../screens/home_screen/home_controller/filter_selection_controller.dart';
import '../../screens/home_screen/home_controller/home_location_controller.dart';

class FilterWidget extends StatelessWidget {
  final HomeLocationController controller = Get.put(HomeLocationController());
  final FilterSelectionController filterController =
      Get.put(FilterSelectionController());
  final List<String> items = [
    'Happy Hours',
  ];
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
                  hintStyle: TextStyle(
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
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
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
              )),
              SizedBox(
                width: 4,
              ),
              GestureDetector(
                onTap: () {
                  filterSelectionDialogueBox();
                  filterController.toggleFilterListVisibility();
                },
                child: Image.asset(
                  'assets/images/filter_image__.png',
                  width: 32,
                  height: 30,
                ),
              ),
            ],
          ),
        ),
        Obx(
              () => filterController.isFilterListVisible.value &&
              filterController.aggregatedFilters.isNotEmpty
              ? Column(
            children: [
              SizedBox(height: 10),
              Padding( 
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 280,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double availableWidth = constraints.maxWidth;
                            return Obx(
                                  () => Wrap(
                                direction: Axis.horizontal,
                                spacing: 7,
                                runSpacing: 10,
                                children: [
                                  ...filterController.aggregatedFilters
                                      .map((filterName) {
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: availableWidth / 1,
                                      ),
                                      child: SelectedFilterWidgets(
                                        filterName: filterName,
                                        onTap: () {
                                          filterController.aggregatedFilters
                                              .remove(filterName);
                                          // Hide the filter list if it's empty after removal
                                          if (filterController
                                              .aggregatedFilters.isEmpty) {
                                            filterController
                                                .isFilterListVisible
                                                .value = false;
                                          }
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        filterController.aggregatedFilters.clear();
                        filterController.isFilterListVisible.value = false;
                      },
                      child: Text(
                        'clear all',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: "Nunito-Sans",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}

class SelectedFilterWidgets extends StatelessWidget {
  final String filterName;
  final void Function()? onTap;

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
        color: AppColors.primaryColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              filterName,
              style: TextStyle(
                color: AppColors.textColor,
                fontFamily: "Nunito-Sans",
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            width: 6,
          ),
          GestureDetector(
            onTap: onTap,
            child: Icon(
              Icons.close,
              color: AppColors.textColor,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class FilterBox extends StatelessWidget {
  final HomeLocationController controller = Get.put(HomeLocationController());
  final List<String> items = [
    'Happy Hours',
    'Dinner discount',
  ];
  final List<String> diningItems = ['Breakfast', 'Lunch', 'Dinner', 'Brunch'];

  FilterBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 7,
        right: 7,
      ),
      child: Container(
        width: Get.width,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFEEEFF2),
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 11,
            ),
            InkWell(
              onTap: () {
                controller.selectedTop.value = '';
              },
              child: Text(
                'Filter:',
                style: TextStyle(
                  fontFamily: 'Nunito-Regular',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                  controller.top.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Obx(() {
                        return InkWell(
                          onTap: () {
                            if (controller.top[index] != 'Discount') {
                              controller.selectedTop.value =
                                  controller.top[index];
                            }
                          },
                          child: Container(
                            height: 26,
                            decoration: BoxDecoration(
                              color: controller.selectedTop.value ==
                                          controller.top[index] ||
                                      (controller.top[index] == 'Discount' &&
                                          items.contains(
                                              controller.selectedTop.value)) ||
                                      (controller.top[index] == 'Dining' &&
                                          diningItems.contains(
                                              controller.selectedTop.value))
                                  ? AppColors
                                      .whiteColor // White background if selected
                                  : Colors.transparent,
                              // Transparent background if not selected
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: controller.top[index] == 'Discount'
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          top: 4,
                                          bottom: 4,
                                          right: 4,
                                          left: 20),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          value: items.contains(
                                                  controller.selectedTop.value)
                                              ? controller.selectedTop.value
                                              : null,
                                          hint: Text(
                                            'Discount',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.darkGrey,
                                              fontFamily: 'Nunito-Regular',
                                            ),
                                          ),
                                          selectedItemBuilder:
                                              (BuildContext context) {
                                            return items.map((String item) {
                                              return Text(
                                                item,
                                                style: TextStyle(
                                                  color: AppColors.darkGrey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10,
                                                  fontFamily: 'Nunito-Regular',
                                                ),
                                              );
                                            }).toList();
                                          },
                                          items: items.map((String item) {
                                            return DropdownMenuItem<String>(
                                              value: item,
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .resolveWith<Color>(
                                                      (Set<MaterialState>
                                                          states) {
                                                        if (states.contains(
                                                            MaterialState
                                                                .selected)) {
                                                          return AppColors
                                                              .primaryColor;
                                                        }
                                                        return AppColors
                                                            .whiteColor;
                                                      },
                                                    ),
                                                    side: MaterialStateBorderSide
                                                        .resolveWith(
                                                            (Set<MaterialState>
                                                                states) {
                                                      return BorderSide(
                                                          color: AppColors
                                                              .primaryColor);
                                                    }),
                                                    value: controller
                                                            .selectedTop
                                                            .value ==
                                                        item,
                                                    // Ensure the correct item is checked
                                                    onChanged:
                                                        (bool? isSelected) {
                                                      if (isSelected == true) {
                                                        // If the item is selected, set it as the selected value
                                                        controller.selectedTop
                                                            .value = item;
                                                      } else {
                                                        // If the item is unselected, reset the selected value
                                                        controller.selectedTop
                                                                .value =
                                                            ''; // Set to null or empty string to unselect
                                                      }
                                                      Get.to(
                                                          () => HappyHours());
                                                      // Close dropdown after selection/unselection
                                                    },
                                                  ),
                                                  Text(
                                                    item,
                                                    style: TextStyle(
                                                      color: AppColors.darkGrey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize:
                                                          Responsive.isMobile(
                                                                  context)
                                                              ? 10
                                                              : 14,
                                                      fontFamily:
                                                          'Nunito-Regular',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue ==
                                                controller.selectedTop.value) {
                                              // If the selected value is clicked again, unselect it
                                              controller.selectedTop.value =
                                                  ''; // Set to null or empty string to unselect
                                            } else {
                                              controller.selectedTop.value =
                                                  newValue!;
                                            }
                                            Get.to(() => HappyHours());
                                          },
                                        ),
                                      ),
                                    )
                                  : controller.top[index] == 'Dining'
                                      ? Padding(
                                          padding: EdgeInsets.all(4),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              iconStyleData: IconStyleData(
                                                icon: Image.asset(
                                                  'assets/images/drop_down_img.png',
                                                  width: 10,
                                                  height: 10,
                                                ),
                                              ),
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                width: 200,
                                                maxHeight: 200,
                                                decoration: BoxDecoration(
                                                  color: AppColors.whiteColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              value: diningItems.contains(
                                                      controller
                                                          .selectedTop.value)
                                                  ? controller.selectedTop.value
                                                  : null,
                                              // Fallback to null if no matching item is found
                                              hint: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10, left: 8),
                                                child: Text(
                                                  'Dining',
                                                  style: TextStyle(
                                                    fontSize:
                                                        Responsive.isMobile(
                                                                context)
                                                            ? 10
                                                            : 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.darkGrey,
                                                    fontFamily:
                                                        'Nunito-Regular',
                                                  ),
                                                ),
                                              ),
                                              selectedItemBuilder:
                                                  (BuildContext context) {
                                                return diningItems
                                                    .map((String item) {
                                                  return Text(
                                                    item,
                                                    style: TextStyle(
                                                      color: AppColors.darkGrey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 10,
                                                      fontFamily:
                                                          'Nunito-Regular',
                                                    ),
                                                  );
                                                }).toList();
                                              },
                                              items: diningItems
                                                  .map((String item) {
                                                return DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Row(
                                                    children: [
                                                      Checkbox(
                                                        fillColor:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    Color>(
                                                          (Set<MaterialState>
                                                              states) {
                                                            if (states.contains(
                                                                MaterialState
                                                                    .selected)) {
                                                              return AppColors
                                                                  .primaryColor;
                                                            }
                                                            return AppColors
                                                                .whiteColor;
                                                          },
                                                        ),
                                                        side: MaterialStateBorderSide
                                                            .resolveWith((Set<
                                                                    MaterialState>
                                                                states) {
                                                          return BorderSide(
                                                              color: AppColors
                                                                  .primaryColor);
                                                        }),
                                                        value: controller
                                                                .selectedTop
                                                                .value ==
                                                            item,
                                                        // Ensure the correct item is checked
                                                        onChanged:
                                                            (bool? isSelected) {
                                                          if (isSelected ==
                                                              true) {
                                                            controller
                                                                .selectedTop
                                                                .value = item;
                                                          } else {
                                                            controller
                                                                .selectedTop
                                                                .value = '';
                                                          }
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      Text(
                                                        item,
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .darkGrey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 10,
                                                          fontFamily:
                                                              'Nunito-Regular',
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                if (newValue ==
                                                    controller
                                                        .selectedTop.value) {
                                                  // If the selected value is clicked again, unselect it
                                                  controller.selectedTop.value =
                                                      ''; // Set to null or empty string to unselect
                                                } else {
                                                  controller.selectedTop.value =
                                                      newValue!;
                                                }
                                              },
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Text(
                                            controller.top[index],
                                            style: TextStyle(
                                              fontWeight: controller
                                                          .selectedTop.value !=
                                                      controller.top[index]
                                                  ? FontWeight.w500
                                                  : FontWeight.w700,
                                              fontSize: 10,
                                              color: controller
                                                          .selectedTop.value !=
                                                      controller.top[index]
                                                  ? AppColors.darkGrey
                                                  : AppColors.primaryColor,
                                              fontFamily: 'Nunito-Regular',
                                            ),
                                          ),
                                        ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
