import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/app_colors.dart';
import 'package:savrly/constants/text_styles.dart';

import '../../../../controllers/amenities_sub_screen_controller.dart';
import '../../../../widgets/button.dart';

class AmenitiesSubScreen extends StatelessWidget {
  AmenitiesSubScreen({super.key});

  final controller = Get.put(AmenitiesSubScreenController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 1000;
    double buttonTextSize = mobileView ? 11 : 16;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Facilities/Service
            _buildSection(
              context: context,
              title: 'Facilities/Service',
              isExpanded: controller.isFacilitiesExpanded,
              toggleExpanded: controller.toggleFacilitiesExpanded,
              items: controller.facilities,
              toggleCheckbox: controller.toggleFacilitiesCheckbox,
              addItem: controller.addFacilities,
              mobileView: mobileView,
              buttonTextSize: buttonTextSize,
            ),

            const SizedBox(height: 24),

            // 2. Dietary Preferences
            _buildSection(
              context: context,
              title: 'Dietary Preferences',
              isExpanded: controller.isDietaryExpanded,
              toggleExpanded: controller.toggleDietaryExpanded,
              items: controller.dietaryPreferences,
              toggleCheckbox: controller.toggleDietaryCheckbox,
              addItem: controller.addDietaryPreference,
              mobileView: mobileView,
              buttonTextSize: buttonTextSize,
            ),
            const SizedBox(height: 24),

            // 3. Atmosphere
            _buildSection(
              context: context,
              title: 'Atmosphere',
              isExpanded: controller.isAtmosphereExpanded,
              toggleExpanded: controller.toggleAtmosphereExpanded,
              items: controller.atmosphere,
              toggleCheckbox: controller.toggleAtmosphereCheckbox,
              addItem: controller.addAtmosphere,
              mobileView: mobileView,
              buttonTextSize: buttonTextSize,
            ),

            const SizedBox(height: 24),

            // 4. Vibes
            _buildSection(
              context: context,
              title: 'Vibes',
              isExpanded: controller.isVibesExpanded,
              toggleExpanded: controller.toggleVibesExpanded,
              items: controller.vibes,
              toggleCheckbox: controller.toggleVibesCheckbox,
              addItem: controller.addVibes,
              mobileView: mobileView,
              buttonTextSize: buttonTextSize,
            ),

            const SizedBox(height: 24),

            // 5. Experiences
            _buildSection(
              context: context,
              title: 'Experiences',
              isExpanded: controller.isExperiencesExpanded,
              toggleExpanded: controller.toggleExperiencesExpanded,
              items: controller.experiences,
              toggleCheckbox: controller.toggleExperiencesCheckbox,
              addItem: controller.addExperiences,
              mobileView: mobileView,
              buttonTextSize: buttonTextSize,
            ),

            const SizedBox(height: 24),

            // 6. Entertainment
            _buildSection(
              context: context,
              title: 'Entertainment',
              isExpanded: controller.isEntertainmentExpanded,
              toggleExpanded: controller.toggleEntertainmentExpanded,
              items: controller.entertainment,
              toggleCheckbox: controller.toggleEntertainmentCheckbox,
              addItem: controller.addEntertainment,
              mobileView: mobileView,
              buttonTextSize: buttonTextSize,
            ),

            const SizedBox(height: 24),

            // 7. Price Range
            _buildSection(
              context: context,
              title: 'Price Range',
              isExpanded: controller.isPriceRangeExpanded,
              toggleExpanded: controller.togglePriceRangeExpanded,
              items: controller.priceRange,
              toggleCheckbox: controller.togglePriceRangeCheckbox,
              addItem: controller.addPriceRange,
              mobileView: mobileView,
              buttonTextSize: buttonTextSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required RxBool isExpanded,
    required VoidCallback toggleExpanded,
    required RxList<Map<String, dynamic>> items,
    required Function(int) toggleCheckbox,
    required Future<void> Function() addItem,
    required bool mobileView,
    required double buttonTextSize,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: toggleExpanded,
          child: SizedBox(
            width: mobileView ? Get.width * 0.8 : Get.width * 0.4,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
                  ),
                  Obx(
                    () => Icon(
                      isExpanded.value ? Icons.expand_less : Icons.expand_more,
                      size: mobileView ? 20 : 28,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() {
          if (!isExpanded.value) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              ...items.map((item) {
                int index = items.indexOf(item);
                String name = item['name'];
                bool isChecked = item['isChecked'];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          CustomCheckbox(
                            isChecked: isChecked,
                            onTap: () => toggleCheckbox(index),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            name,
                            style: simpleText.copyWith(
                              fontSize: mobileView ? 14 : 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 0.1,
                        width: mobileView ? Get.width * 0.8 : Get.width * 0.4,
                        color: primaryColor,
                      ),
                    ),
                  ],
                );
              }).toList(),
              const SizedBox(height: 16),
              Row(
                children: [
                  CustomCheckbox(
                    isChecked: false,
                    isPlusIcon: true,
                    onTap: addItem,
                  ),
                  const SizedBox(width: 16),
                  CustomButton(
                    laBelText: 'Add More',
                    fontSize: buttonTextSize,
                    isBorder: true,
                    height: mobileView ? 40 : 45,
                    width: mobileView ? Get.width * 0.65 : Get.width * 0.24,
                    shadow: [],
                    containerColor: white,
                    borderColor: primaryColor.withOpacity(0.3),
                    textColor: secondaryColor,
                    ontapp: addItem,
                  ),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final bool isPlusIcon;
  final VoidCallback onTap;

  const CustomCheckbox({
    super.key,
    required this.isChecked,
    this.isPlusIcon = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 1000;
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: mobileView ? 16 : 24,
          height: mobileView ? 16 : 24,
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(4),
            color: isChecked ? primaryColor : Colors.transparent,
          ),
          child: isPlusIcon
              ? Icon(
                  Icons.add,
                  size: mobileView ? 10 : 16,
                  color: secondaryColor,
                )
              : (isChecked
                  ? Icon(
                      Icons.check,
                      size: mobileView ? 10 : 16,
                      color: Colors.white,
                    )
                  : null),
        ),
      ),
    );
  }
}
