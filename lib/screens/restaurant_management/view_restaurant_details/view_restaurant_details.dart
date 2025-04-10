import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/text_styles.dart';
import 'package:savrly/controllers/add_restaurants_controller.dart';
import 'package:savrly/controllers/restaurant_management_controller.dart';
import 'package:savrly/models/operatingHour.dart';
import 'package:savrly/models/resaturant_model.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/amenities_sub_screen_controller.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../widgets/customheader_widget.dart';

class ViewRestaurantDetails extends StatelessWidget {
  ViewRestaurantDetails({super.key});

  final drawerController = Get.put(DrawerControllerX());
  final resturantController = Get.find<RestaurantManagementController>();
  final addRestaurantController = Get.find<AddRestaurantTabController>();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool mobileView = screenWidth < 1000;
    double paddingValue = mobileView ? 16 : 24;
    RestaurantModel restaurant = addRestaurantController.restaurantModel!;
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
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
                        image: NetworkImage(
                          restaurant.logoImage ??
                              'https://via.placeholder.com/150',
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
                    restaurantName: restaurant.resName,
                    location: restaurant.address,
                    social: '${restaurant.instaLink}, ${restaurant.tiktokLink}',
                  ),
                  SizedBox(height: 16),
                  FacilitiesContainer(
                    screenHeight: screenHeight,
                    mobileView: mobileView,
                    screenWidth: screenWidth,
                    title: 'Facilities & Services',
                    entries: restaurant.facilityList.join(', '),
                  ),
                  const SizedBox(height: 16),
                  DietaryPreferencesContainer(
                    screenHeight: screenHeight,
                    mobileView: mobileView,
                    screenWidth: screenWidth,
                    entries: restaurant.dietaryList.join(', '),
                    title: 'Dietary Preferences',
                  ),
                  SizedBox(height: 16),
                  AtmospherePriceRangeContainer(
                    screenHeight: screenHeight,
                    mobileView: mobileView,
                    screenWidth: screenWidth,
                    atmosphere: restaurant.atmosphereList.join(', '),
                    priceRange: restaurant.priceRange,
                    title: 'Atmosphere & Price Range',
                  ),
                  const SizedBox(height: 16),
                  SpecialConditionsContainer(
                    screenHeight: screenHeight,
                    mobileView: mobileView,
                    screenWidth: screenWidth,
                    title: 'Special Conditions',
                    selectedMenuTypes: restaurant.menuList.isEmpty
                        ? MenuModel(
                            cuisineType: '', foodImages: [], menuType: '')
                        : restaurant.menuList.first,
                    specialConditions: restaurant.specialConditions,
                    uploadedImages: restaurant.menuList.isNotEmpty
                        ? restaurant.menuList[0].foodImages
                        : [],
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
    required this.social,
  });

  final double screenHeight;
  final bool mobileView;
  final double screenWidth;
  final String title;
  final String restaurantName;
  final String location;
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
    required this.entries,
    required this.title,
  });

  final double screenHeight;
  final bool mobileView;
  final double screenWidth;
  final String title;
  final String entries;

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
                entries,
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
              children: selectedFacilities.map((facility) {
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
    required this.entries,
    required this.screenWidth,
    required this.title,
  });

  final double screenHeight;
  final bool mobileView;
  final double screenWidth;
  final String title;
  final String entries;

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
                entries,
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
              children: selectedDietaryPreferences.map((preference) {
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
    required this.atmosphere,
    required this.priceRange,
    required this.title,
  });

  final double screenHeight;
  final bool mobileView;
  final double screenWidth;
  final String title;
  final String atmosphere;
  final String priceRange;

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
                      child: selectedAtmosphere.isEmpty
                          ? Text(
                              atmosphere,
                              style: simpleText.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: secondaryColor,
                              ),
                            )
                          : Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: selectedAtmosphere.map((atmosphere) {
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
                      child: selectedPriceRange.isEmpty
                          ? Text(
                              priceRange,
                              style: simpleText.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: secondaryColor,
                              ),
                            )
                          : Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: selectedPriceRange.map((price) {
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
    required this.specialConditions,
    required this.uploadedImages,
    required this.selectedMenuTypes,
    required this.title,
  });

  final double screenHeight;
  final bool mobileView;
  final double screenWidth;
  final String title;
  final specialConditions;
  final MenuModel selectedMenuTypes;
  final uploadedImages;
  @override
  Widget build(BuildContext context) {
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
          Column(
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
                      specialConditions,
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
                    child: selectedMenuTypes.menuType.isEmpty
                        ? Text(
                            'None selected',
                            style: simpleText.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: secondaryColor,
                            ),
                          )
                        : Text(
                            selectedMenuTypes.menuType,
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
                    child: uploadedImages.isEmpty
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
                                        image: NetworkImage(
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
          ),
        ],
      ),
    );
  }
}

class OperatingHoursContainer extends StatelessWidget {
  OperatingHoursContainer({
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
  final controller = Get.find<RestaurantManagementController>();
  final addController = Get.find<AddRestaurantTabController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<OperatingHours>>(
      stream:
          controller.getOperatingHours(addController.restaurantModel?.docID ?? ''),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
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
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
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
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
            child: const Text('No operating hours available'),
          );
        }

        final operatingHoursList = snapshot.data!;

        // Sort days in the correct order (Monday to Sunday)
        final List<String> daysOrder = [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday'
        ];
        operatingHoursList.sort((a, b) =>
            daysOrder.indexOf(a.day).compareTo(daysOrder.indexOf(b.day)));

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
                  ...operatingHoursList.map((hours) {
                    return buildDayRow(
                      hours.day,
                      _formatMealTime(hours.breakfast),
                      _formatMealTime(hours.lunch),
                      _formatMealTime(hours.brunch),
                      _formatMealTime(hours.dinner),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatMealTime(Map<String, dynamic> mealData) {
    if (mealData['isClosed'] == true) {
      return '-';
    }
    final startTime = mealData['startTime'] ?? 'N/A';
    final endTime = mealData['endTime'] ?? 'N/A';
    return '$startTime - $endTime';
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
