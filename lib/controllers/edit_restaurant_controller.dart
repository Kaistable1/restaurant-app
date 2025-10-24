import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/controllers/add_restaurants_controller.dart';
import 'package:savrly/controllers/amenities_sub_screen_controller.dart';
import 'package:savrly/controllers/experiences_sub_screen_controller.dart';
import 'package:savrly/controllers/menu_sub_screen_controller.dart';
import 'package:savrly/controllers/operating_hours_sub_screen_controller.dart';
import 'package:savrly/models/resaturant_model.dart';

class EditRestaurantController extends GetxController {
  final restaurantController = Get.find<AddRestaurantTabController>();
  RestaurantModel? restaurantDetailsModel;

  @override
  void onInit() {
    restaurantDetailsModel = restaurantController.restaurantModel;
    // fillAllVariable();
    super.onInit();
  }

  @override
  void onClose() {
    // Clean up when controller is disposed
    cleanupAllControllers();
    super.onClose();
  }

  /// Cleanup method to clear all data when exiting edit mode
  void cleanupAllControllers() {
    final addRestaurantController = Get.find<AddRestaurantTabController>();

    // Clear the main add restaurant controller
    addRestaurantController.clearFields();

    // Clear amenities controller if registered
    if (Get.isRegistered<AmenitiesSubScreenController>()) {
      final amenitiesController = Get.find<AmenitiesSubScreenController>();
      amenitiesController.clearFields();
    }

    // Clear experiences controller if registered
    if (Get.isRegistered<ExperiencesSubScreenController>()) {
      final experiencesController = Get.find<ExperiencesSubScreenController>();
      experiencesController.clearFields();
      experiencesController.events.clear();
    }

    // Clear menu controller if registered
    if (Get.isRegistered<MenuSubScreenController>()) {
      final menuController = Get.find<MenuSubScreenController>();
      menuController.clearFields();
    }

    // Clear operating hours controller if registered
    if (Get.isRegistered<OperatingHoursSubScreenController>()) {
      final operatingHoursController =
          Get.find<OperatingHoursSubScreenController>();
      operatingHoursController.daySwitches.clear();
      operatingHoursController.slotStates.clear();
      operatingHoursController.slotTimes.clear();
    }
  }

  // fillAllVariable() async {
  //   try {
  //     if (restaurantDetailsModel != null) {
  //       await fillAllVarsInRestManagmentController();
  //       await Future.delayed(const Duration(seconds: 1));
  //       await fillAllVarsforAmmenitiesController();
  //       await Future.delayed(const Duration(seconds: 1));
  //
  //       await fillAllVarsforExperiencesController();
  //       await Future.delayed(const Duration(seconds: 1));
  //
  //       await fillAllVarsforOperatingHoursController();
  //       await Future.delayed(const Duration(seconds: 1));
  //
  //       await fillAllVarsforMenuController();
  //       await Future.delayed(const Duration(seconds: 1));
  //     }
  //   } catch (e) {
  //     print('Error $e');
  //   }
  // }

  // Fill variables in AddRestaurantTabController (Basic Info)
  fillAllVarsInRestManagmentController() {
    final addRestaurantController = Get.put(AddRestaurantTabController());
    restaurantDetailsModel = restaurantController.restaurantModel;

    if (restaurantDetailsModel != null) {
      addRestaurantController.restaurantNameController.text =
          restaurantDetailsModel!.resName;
      addRestaurantController.emailController.text =
          restaurantDetailsModel!.resEmail;
      addRestaurantController.assignPasswordController.text =
          restaurantDetailsModel!.password;
      addRestaurantController.areaController.text =
          restaurantDetailsModel!.address;
      addRestaurantController.instagramController.text =
          restaurantDetailsModel!.socialLink;
      addRestaurantController.tiktokLinkController.text =
          restaurantDetailsModel!.socialMedia;

      //PHONE NUMBER AND WEBISTE INFORMATIO ADDED
      addRestaurantController.websiteUrlController.text =
          restaurantDetailsModel!.websiteUrl;
      addRestaurantController.phoneNoController.text =
          restaurantDetailsModel!.phoneNo;

      addRestaurantController.selectedState.value =
          restaurantDetailsModel!.state;

      addRestaurantController.selectedCity.value = restaurantDetailsModel!.city;
      print('restuant city ------${restaurantDetailsModel?.city}');
      addRestaurantController.selectedSpokenLanguage.value =
          restaurantDetailsModel!.spokenLanguage;
      addRestaurantController.currentRestaurantID =
          restaurantDetailsModel!.docID;
      addRestaurantController.uploadedImage.clear();
      if (restaurantDetailsModel!.imagesList.isNotEmpty) {
        for (var url in restaurantDetailsModel!.imagesList) {
          addRestaurantController.uploadedImage.add(
            UploadedImageModel(url: url),
          );
        }
      } else {
        addRestaurantController.uploadedImage.add(
          UploadedImageModel(url: restaurantDetailsModel?.logoImage),
        );
      }

      addRestaurantController.latitude.value = restaurantDetailsModel!.latitude;
      addRestaurantController.longitude.value =
          restaurantDetailsModel!.longitude;
      addRestaurantController.zipCodeController.text =
          restaurantDetailsModel!.zipCode;

      // Set cityController text for manual typing support
      addRestaurantController.cityController.text =
          restaurantDetailsModel!.city;

      addRestaurantController.update();
    }
  }

  fillAllVarsforAmmenitiesController() async {
    final amenitiesController = Get.find<AmenitiesSubScreenController>();
    restaurantDetailsModel = restaurantController.restaurantModel;

    // ✅ Wait until all data is loaded
    while (amenitiesController.facilities.isEmpty ||
        amenitiesController.vibes.isEmpty ||
        amenitiesController.experiences.isEmpty ||
        amenitiesController.entertainment.isEmpty ||
        amenitiesController.dietaryPreferences.isEmpty ||
        amenitiesController.atmosphere.isEmpty ||
        amenitiesController.priceRange.isEmpty) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    if (restaurantDetailsModel != null) {
      for (var facility in amenitiesController.facilities) {
        facility['isChecked'] =
            restaurantDetailsModel!.facilityList.contains(facility['name']);
      }

      for (var dietary in amenitiesController.dietaryPreferences) {
        dietary['isChecked'] =
            restaurantDetailsModel!.dietaryList.contains(dietary['name']);
      }

      for (var vibe in amenitiesController.vibes) {
        vibe['isChecked'] =
            restaurantDetailsModel!.vibesList.contains(vibe['name']);
      }

      for (var experience in amenitiesController.experiences) {
        experience['isChecked'] = restaurantDetailsModel!.experiencesList
            .contains(experience['name']);
      }

      for (var entertainment in amenitiesController.entertainment) {
        entertainment['isChecked'] = restaurantDetailsModel!.entertainmentList
            .contains(entertainment['name']);
      }

      for (var atm in amenitiesController.atmosphere) {
        atm['isChecked'] =
            restaurantDetailsModel!.atmosphereList.contains(atm['name']);
      }

      for (var price in amenitiesController.priceRange) {
        price['isChecked'] =
            restaurantDetailsModel!.priceRange == price['name'];
      }

      // ✅ Refresh lists
      amenitiesController.facilities.refresh();
      amenitiesController.dietaryPreferences.refresh();
      amenitiesController.vibes.refresh();
      amenitiesController.experiences.refresh();
      amenitiesController.entertainment.refresh();
      amenitiesController.atmosphere.refresh();
      amenitiesController.priceRange.refresh();

      amenitiesController.update();
    }
  }

  Future<void> fillAllVarsforExperiencesController() async {
    // ❌ Delete previous instance to avoid old data
    if (Get.isRegistered<ExperiencesSubScreenController>()) {
      Get.delete<ExperiencesSubScreenController>();
    }

    // ✅ Create a new instance
    final experiencesController = Get.put(ExperiencesSubScreenController());
    final addController = Get.find<AddRestaurantTabController>();

    // ✅ Wait for restaurantModel and its list to be available
    while (addController.restaurantModel == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final restaurantDetailsModel = addController.restaurantModel!;

    // ✅ Just in case list is still loading
    if (restaurantDetailsModel.entertainmentScheduleList.isEmpty) {
      // Optional: Add an artificial delay or skip filling if needed
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // ✅ Clear old events and update UI
    experiencesController.events.clear();
    experiencesController.update();

    // ✅ Safely map list to maps
    final maps = await Future.wait(
      restaurantDetailsModel.entertainmentScheduleList
          .map((item) async => item.toMap()),
    );

    // ✅ Add mapped data and refresh UI
    experiencesController.events.addAll(maps);
    experiencesController.events.refresh();
    experiencesController.update();
  }

  Future<void> fillAllVarsforOperatingHoursController() async {
    if (Get.isRegistered<OperatingHoursSubScreenController>()) {
      Get.delete<OperatingHoursSubScreenController>(); // ❌ Clear old data
    }
    final operatingHoursController =
        Get.put(OperatingHoursSubScreenController()); // ✅ Fresh state

    // Step 1: Clear previous data
    operatingHoursController.daySwitches.clear();
    operatingHoursController.daySwitchControllers.clear();
    operatingHoursController.slotStates.clear();
    operatingHoursController.slotTimes.clear();

    // Step 2: Initialize default values for 7 days
    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    for (var day in daysOfWeek) {
      operatingHoursController.daySwitches[day] = false;
      operatingHoursController.daySwitchControllers[day] =
          ValueNotifier<bool>(false);
      operatingHoursController.slotStates[day] = {
        'Breakfast': false,
        'Brunch': false,
        'Lunch': false,
        'Dinner': false,
      };
      operatingHoursController.slotTimes[day] = {
        'Breakfast': '',
        'Brunch': '',
        'Lunch': '',
        'Dinner': '',
      };
    }

    restaurantDetailsModel = restaurantController.restaurantModel;

    if (restaurantDetailsModel != null) {
      // Step 3: Fetch operating hours from Firestore subcollection
      final snapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantDetailsModel!.docID)
          .collection('operatingHours')
          .get();

      for (var doc in snapshot.docs) {
        final day = doc.id;
        final data = doc.data();

        // Check if all slots are closed
        bool allClosed = true;
        for (var meal in ['Breakfast', 'Brunch', 'Lunch', 'Dinner']) {
          if (data[meal] != null && data[meal]['isClosed'] == false) {
            allClosed = false;
            break;
          }
        }

        // Update day switches
        operatingHoursController.daySwitches[day] = !allClosed;
        operatingHoursController.daySwitchControllers[day]!.value = !allClosed;

        // Update slots
        for (var meal in ['Breakfast', 'Brunch', 'Lunch', 'Dinner']) {
          if (data[meal] != null && data[meal]['isClosed'] == false) {
            operatingHoursController.slotStates[day]![meal] = true;
            operatingHoursController.slotTimes[day]![meal] =
                '${data[meal]['startTime']} - ${data[meal]['endTime']}';
          } else {
            operatingHoursController.slotStates[day]![meal] = false;
            operatingHoursController.slotTimes[day]![meal] = '';
          }
        }
      }

      operatingHoursController.daySwitches.refresh();
      operatingHoursController.slotStates.refresh();
      operatingHoursController.slotTimes.refresh();
      operatingHoursController.update();
    }
  }

  // Fill variables in MenuSubScreenController (Menu)
  fillAllVarsforMenuController() {
    final menuController = Get.put(MenuSubScreenController());
    restaurantDetailsModel = restaurantController.restaurantModel;

    if (restaurantDetailsModel != null) {
      menuController.specialConditionsController.text =
          restaurantDetailsModel!.specialConditions;
      if (restaurantDetailsModel!.menuList.isNotEmpty) {
        final menu = restaurantDetailsModel!.menuList.first;
        menuController.selectedCuisine.value = menu.cuisineType;
        menuController.isFoodMenuSelected.value = menu.menuType == 'food';
        menuController.isDrinkMenuSelected.value = menu.menuType == 'drink';
        menuController.uploadedImages.clear();
        for (var url in menu.foodImages) {
          menuController.uploadedImages.add(UploadedImageModel(url: url));
        }
      }
      menuController.update();
    }
    print(
        'menuController.specialConditionsController.text ${menuController.specialConditionsController.text}');
  }
}
