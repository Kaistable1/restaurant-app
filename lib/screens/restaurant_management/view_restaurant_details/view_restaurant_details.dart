import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/text_styles.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/amenities_sub_screen_controller.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../controllers/menu_sub_screen_controller.dart';
import '../../../widgets/customheader_widget.dart';

class ViewRestaurantDetails extends StatelessWidget {
  ViewRestaurantDetails({super.key});

  final drawerController = Get.put(DrawerControllerX());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool mobileView = screenWidth < 1000;
    double paddingValue = mobileView ? 16 : 24;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: paddingValue),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingValue),
          child: CustomHeaderWidget(
            back: true,
            onBackTap: () {
              drawerController.viewRestaurantsDetails.value = false;
            },
            title: 'View Restaurant',
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(paddingValue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: screenHeight * 0.24,
                  width: mobileView ? screenWidth : screenWidth * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/restaurant_details_img.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                BasicInfoContainer(
                  screenHeight: screenHeight,
                  mobileView: mobileView,
                  screenWidth: screenWidth,
                  title: 'Basic Information',
                  restaurantName: 'Sushi Haven',
                  location: 'Islamabad',
                  contact: '92323356564',
                  social: 'Instagram, Tiktok',
                ),
                SizedBox(height: 16),
                FacilitiesContainer(
                  screenHeight: screenHeight,
                  mobileView: mobileView,
                  screenWidth: screenWidth,
                  title: 'Facilities & Services',
                ),
                const SizedBox(height: 16),
                DietaryPreferencesContainer(
                  screenHeight: screenHeight,
                  mobileView: mobileView,
                  screenWidth: screenWidth,
                  title: 'Dietary Preferences',
                ),
                SizedBox(height: 16),
                AtmospherePriceRangeContainer(
                  screenHeight: screenHeight,
                  mobileView: mobileView,
                  screenWidth: screenWidth,
                  title: 'Atmosphere & Price Range',
                ),
                const SizedBox(height: 16),
                SpecialConditionsContainer(
                  screenHeight: screenHeight,
                  mobileView: mobileView,
                  screenWidth: screenWidth,
                  title: 'Special Conditions',
                ),
                const SizedBox(height: 16),
                OperatingHoursContainer(
                  screenHeight: screenHeight,
                  mobileView: mobileView,
                  screenWidth: screenWidth,
                  title: 'Operating Hours',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BasicInfoContainer extends StatelessWidget {
  const BasicInfoContainer({
    super.key,
    required this.screenHeight,
    required this.mobileView,
    required this.screenWidth,
    required this.title,
    required this.restaurantName,
    required this.location,
    required this.contact,
    required this.social,
  });

  final double screenHeight;
  final bool mobileView;
  final double screenWidth;
  final String title;
  final String restaurantName;
  final String location;
  final String contact;
  final String social;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: screenHeight * 0.24,
      width: mobileView ? screenWidth : screenWidth * 0.35,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: dimWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
          ),
          SizedBox(height: 16),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Restaurant name: ',
                  style: simpleText.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: restaurantName,
                  style: simpleText.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Location: ',
                  style: simpleText.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: location,
                  style: simpleText.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Contact: ',
                  style: simpleText.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: contact,
                  style: simpleText.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Social: ',
                  style: simpleText.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: social,
                  style: simpleText.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FacilitiesContainer extends StatelessWidget {
  const FacilitiesContainer({
    super.key,
    required this.screenHeight,
    required this.mobileView,
    required this.screenWidth,
    required this.title,
  });

  final double screenHeight;
  final bool mobileView;
  final double screenWidth;
  final String title;

  @override
  Widget build(BuildContext context) {
    final amenitiesController = Get.put(
      AmenitiesSubScreenController(),
      permanent: false,
    ); // Get the controller

    return Container(
      width: mobileView ? screenWidth : screenWidth * 0.35,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: dimWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
          ),
          SizedBox(height: 16),
          Obx(() {
            // Get selected facilities
            final selectedFacilities =
                amenitiesController.getSelectedFacilities();

            if (selectedFacilities.isEmpty) {
              return Text(
                'No facilities selected',
                style: simpleText.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: secondaryColor,
                ),
              );
            }

            return Wrap(
              spacing: 8.0, // Horizontal spacing between items
              runSpacing: 8.0, // Vertical spacing between rows
              children:
                  selectedFacilities.map((facility) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        facility,
                        style: simpleText.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: secondaryColor,
                        ),
                      ),
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }
}

class DietaryPreferencesContainer extends StatelessWidget {
  const DietaryPreferencesContainer({
    super.key,
    required this.screenHeight,
    required this.mobileView,
    required this.screenWidth,
    required this.title,
  });

  final double screenHeight;
  final bool mobileView;
  final double screenWidth;
  final String title;

  @override
  Widget build(BuildContext context) {
    // Initialize the controller if not already present
    final amenitiesController = Get.put(
      AmenitiesSubScreenController(),
      permanent: false,
    );

    return Container(
      width: mobileView ? screenWidth : screenWidth * 0.35,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: dimWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
          ),
          const SizedBox(height: 16),
          Obx(() {
            // Get selected dietary preferences
            final selectedDietaryPreferences =
                amenitiesController.getSelectedDietaryPreferences();

            if (selectedDietaryPreferences.isEmpty) {
              return Text(
                'No dietary preferences selected',
                style: simpleText.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: secondaryColor,
                ),
              );
            }

            return Wrap(
              spacing: 8.0, // Horizontal spacing between items
              runSpacing: 8.0, // Vertical spacing between rows
              children:
                  selectedDietaryPreferences.map((preference) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        preference,
                        style: simpleText.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: secondaryColor,
                        ),
                      ),
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }
}

class AtmospherePriceRangeContainer extends StatelessWidget {
  const AtmospherePriceRangeContainer({
    super.key,
    required this.screenHeight,
    required this.mobileView,
    required this.screenWidth,
    required this.title,
  });

  final double screenHeight;
  final bool mobileView;
  final double screenWidth;
  final String title;

  @override
  Widget build(BuildContext context) {
    // Initialize the controller if not already present
    final amenitiesController = Get.put(
      AmenitiesSubScreenController(),
      permanent: false,
    );

    return Container(
      width: mobileView ? screenWidth : screenWidth * 0.35,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: dimWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
          ),
          const SizedBox(height: 16),
          Obx(() {
            // Get selected atmosphere and price range
            final selectedAtmosphere =
                amenitiesController.getSelectedAtmosphere();
            final selectedPriceRange =
                amenitiesController.getSelectedPriceRange();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Atmosphere
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Atmosphere: ',
                      style: simpleText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child:
                          selectedAtmosphere.isEmpty
                              ? Text(
                                'None selected',
                                style: simpleText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: secondaryColor,
                                ),
                              )
                              : Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children:
                                    selectedAtmosphere.map((atmosphere) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          atmosphere,
                                          style: simpleText.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: secondaryColor,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 12), // Space between rows
                // Row 2: Price Range
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price Range: ',
                      style: simpleText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child:
                          selectedPriceRange.isEmpty
                              ? Text(
                                'None selected',
                                style: simpleText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: secondaryColor,
                                ),
                              )
                              : Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children:
                                    selectedPriceRange.map((price) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          price,
                                          style: simpleText.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: secondaryColor,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class SpecialConditionsContainer extends StatelessWidget {
  const SpecialConditionsContainer({
    super.key,
    required this.screenHeight,
    required this.mobileView,
    required this.screenWidth,
    required this.title,
  });

  final double screenHeight;
  final bool mobileView;
  final double screenWidth;
  final String title;

  @override
  Widget build(BuildContext context) {
    final menuController = Get.put(MenuSubScreenController(), permanent: false);

    return Container(
      width: mobileView ? screenWidth : screenWidth * 0.35,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: dimWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final specialConditions = menuController.getSpecialConditions();
            final selectedMenuTypes = menuController.getSelectedMenuTypes();
            final uploadedImages = menuController.getUploadedImages();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Special Conditions Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Special Conditions: ',
                      style: simpleText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        specialConditions.isEmpty
                            ? 'None provided'
                            : specialConditions,
                        style: simpleText.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Menu Type Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu Type: ',
                      style: simpleText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child:
                          selectedMenuTypes.isEmpty
                              ? Text(
                                'None selected',
                                style: simpleText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: secondaryColor,
                                ),
                              )
                              : Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children:
                                    selectedMenuTypes.map((type) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          type,
                                          style: simpleText.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: secondaryColor,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Discount Type Section (Hardcoded as "Coming Soon")
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discount Type: ',
                      style: simpleText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Coming Soon',
                        style: simpleText.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Food Images Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Food Images: ',
                      style: simpleText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child:
                          uploadedImages.isEmpty
                              ? Text(
                                'No images uploaded',
                                style: simpleText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: secondaryColor,
                                ),
                              )
                              : SizedBox(
                                height: mobileView ? 100 : 130,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: uploadedImages.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: Container(
                                        width: mobileView ? 140 : 180,
                                        height: mobileView ? 100 : 130,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          image: DecorationImage(
                                            image: MemoryImage(
                                              uploadedImages[index],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class OperatingHoursContainer extends StatelessWidget {
  const OperatingHoursContainer({
    super.key,
    required this.screenHeight,
    required this.mobileView,
    required this.screenWidth,
    required this.title,
  });

  final double screenHeight;
  final bool mobileView;
  final double screenWidth;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mobileView ? screenWidth : screenWidth * 0.52,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: dimWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
          ),
          const SizedBox(height: 16),
          // Table-like structure using Row and Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading Row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Days',
                      style: simpleText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: mobileView ? 14 : 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Breakfast',
                      style: simpleText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: mobileView ? 14 : 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Lunch',
                      style: simpleText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: mobileView ? 14 : 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Brunch',
                      style: simpleText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: mobileView ? 14 : 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Dinner',
                      style: simpleText.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: mobileView ? 14 : 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Data Rows
              buildDayRow(
                'Monday',
                '8:00AM - 11:00AM',
                '12:00PM - 3:00PM',
                '-',
                '6:00PM - 10:00PM',
              ),
              buildDayRow(
                'Tuesday',
                '8:00AM - 11:00AM',
                '12:00PM - 3:00PM',
                '-',
                '6:00PM - 10:00PM',
              ),
              buildDayRow(
                'Wednesday',
                '8:00AM - 11:00AM',
                '12:00PM - 3:00PM',
                '-',
                '6:00PM - 10:00PM',
              ),
              buildDayRow(
                'Thursday',
                '8:00AM - 11:00AM',
                '12:00PM - 3:00PM',
                '-',
                '6:00PM - 10:00PM',
              ),
              buildDayRow(
                'Friday',
                '8:00AM - 11:00AM',
                '12:00PM - 3:00PM',
                '3:00PM - 5:00PM',
                '6:00PM - 11:00PM',
              ),
              buildDayRow(
                'Saturday',
                '-',
                '12:00PM - 3:00PM',
                '3:00PM - 5:00PM',
                '6:00PM - 11:00PM',
              ),
              buildDayRow(
                'Sunday',
                '-',
                '-',
                '10:00AM - 2:00PM',
                '6:00PM - 9:00PM',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDayRow(
    String day,
    String breakfast,
    String lunch,
    String brunch,
    String dinner,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              day,
              style: simpleText.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: mobileView ? 9 : 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              breakfast,
              style: simpleText.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: mobileView ? 8 : 14,
                color: secondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              lunch,
              style: simpleText.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: mobileView ? 8 : 14,
                color: secondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              brunch,
              style: simpleText.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: mobileView ? 8 : 14,
                color: secondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              dinner,
              style: simpleText.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: mobileView ? 8 : 14,
                color: secondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
