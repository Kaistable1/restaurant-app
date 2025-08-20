import 'dart:math' show asin, cos, pi, pow, sin, sqrt;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';

import '../../../../constants/app_colors.dart';

class CategoryController extends GetxController {
  var selectedIndex = (-1).obs; // Stores only one selected index
  var selectedMileIndex = (-1).obs; // Stores only one selected index
  RxString selectedCat = ''.obs;
  RxString selectedMiles = ''.obs;
  RxDouble userLatitude = 0.0.obs;
  RxDouble userLongitude = 0.0.obs;
  final List<String> categories = ["Concert", "Festival", "Sports", 'Distance'];
  final List<String> miles = ["5 Miles", "10 Miles", "15 Miles", "20 Miles"];

  void selectCategory(int index) {
    selectedIndex.value = index; // Only one selection at a time
    selectedCat.value = categories[index];
  }

  void selectMiles(int index) {
    selectedMileIndex.value = index; // Only one selection at a time
    selectedMiles.value = miles[index];
  }

  double calculateDistance(double lat2, double lon2) {
    print('user lati ${userLatitude.value}');
    print('user long ${userLongitude.value}');
    const double earthRadius = 3958.8; // Radius of Earth in miles
    double dLat = _toRadians(lat2 - userLatitude.value);
    double dLon = _toRadians(lon2 - userLongitude.value);
    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(userLatitude.value)) *
            cos(_toRadians(lat2)) *
            pow(sin(dLon / 2), 2);
    double c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  final locationController = Get.find<HomeLocationController>();
  getCurrentLatLong(context) async {
    Position userLocation =
        await locationController.getCurrentLocation(context);
    userLatitude.value = userLocation.latitude;
    userLongitude.value = userLocation.longitude;
  }
}

class HorizontalCategorySelector extends StatelessWidget {
  final List<String> categoriesImages = [
    "assets/images/concert_icon.png",
    "assets/images/festival_icon.png",
    "assets/images/sports_icon.png",
    "assets/images/distance.png"
  ];
  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          return Obx(() {
            bool isSelected = controller.selectedIndex.value == index;
            return GestureDetector(
              onTap: () =>
                  controller.selectCategory(index), // Select only one at a time
              child: Container(
                width: 102,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        categoriesImages[index],
                        color: isSelected
                            ? AppColors.whiteColor
                            : AppColors.primaryColor,
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        controller.categories[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.whiteColor
                              : AppColors.bottomSheetColor,
                          fontFamily: 'Nunito-Bold',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

class HorizontalMiles extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.miles.length,
        itemBuilder: (context, index) {
          return Obx(() {
            bool isSelected = controller.selectedMileIndex.value == index;
            return GestureDetector(
              onTap: () =>
                  controller.selectMiles(index), // Select only one at a time
              child: Container(
                width: 102,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/distance.png",
                        color: isSelected
                            ? AppColors.whiteColor
                            : AppColors.primaryColor,
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        controller.miles[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.whiteColor
                              : AppColors.bottomSheetColor,
                          fontFamily: 'Nunito-Bold',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
