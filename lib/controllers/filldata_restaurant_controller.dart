import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/controllers/add_restaurants_controller.dart';
import 'package:restaurant_web_app/controllers/amenities_sub_screen_controller.dart';
import 'package:restaurant_web_app/controllers/experiences_sub_screen_controller.dart';
import 'package:restaurant_web_app/controllers/menu_sub_screen_controller.dart';
import 'package:restaurant_web_app/controllers/operating_hours_sub_screen_controller.dart';
import 'package:restaurant_web_app/main.dart';
import 'package:restaurant_web_app/models/resaturant_model.dart';

class FillDataRestaurantController extends GetxController {
  final restaurantController = Get.put(AddRestaurantTabController());
  RestaurantModel? restaurantDetailsModel;

  @override
  void onInit() {
    fetchRestaurantData(); // Call the fetch function when controller initializes
    super.onInit();
  }

  // Function to fetch restaurant data from Firestore
  Future<void> fetchRestaurantData() async {
    try {
      // Get the restaurant docID from the currentRestaurantOwner claim model
      String? restaurantDocID =
          currentRestaurantOwner.value?.restaurantData.docID;

      if (restaurantDocID == null || restaurantDocID.isEmpty) {
        print('No restaurant docID found in currentRestaurantOwner');
        return;
      }

      print('📍 Fetching restaurant data for docID: $restaurantDocID');

      // Reference to the Firestore collection 'restaurants' and document with restaurant docID
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantDocID)
          .get();

      // Check if document exists
      if (doc.exists) {
        // Convert Firestore data to RestaurantModel
        restaurantDetailsModel =
            RestaurantModel.fromMap(doc.data() as Map<String, dynamic>);
        print('✅ Restaurant data loaded: ${restaurantDetailsModel!.resName}');
        print('📸 Images: ${restaurantDetailsModel!.imagesList}');
        restaurantController.restaurantModel = restaurantDetailsModel;
        update();
        // Fill all variables after fetching data
        await fillAllVariable();
      } else {
        print('❌ No restaurant data found for docID: $restaurantDocID');
      }
    } catch (e) {
      print('❌ Error fetching restaurant data: $e');
    }
  }

  fillAllVariable() async {
    try {
      if (restaurantDetailsModel != null) {
        await fillAllVarsInRestManagmentController();
        await Future.delayed(const Duration(seconds: 1));
        await fillAllVarsforAmmenitiesController();
        await Future.delayed(const Duration(seconds: 1));

        await fillAllVarsforExperiencesController();
        await Future.delayed(const Duration(seconds: 1));

        await fillAllVarsforOperatingHoursController();
        await Future.delayed(const Duration(seconds: 1));

        await fillAllVarsforMenuController();
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      print('Error $e');
    }
  }

  // Fill variables in AddRestaurantTabController (Basic Info)
  Future<void> fillAllVarsInRestManagmentController() async {
    final addRestaurantController = Get.put(AddRestaurantTabController());

    print('🔍 Starting fillAllVarsInRestManagmentController');
    print(
        '🔍 restaurantDetailsModel is null: ${restaurantDetailsModel == null}');
    if (restaurantDetailsModel != null) {
      print(
          '🔍 restaurantDetailsModel.imagesList length: ${restaurantDetailsModel!.imagesList.length}');
      print(
          '🔍 restaurantDetailsModel.imagesList: ${restaurantDetailsModel!.imagesList}');
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

      // Set state and city
      addRestaurantController.selectedState.value =
          restaurantDetailsModel!.country;
      addRestaurantController.selectedCity.value = restaurantDetailsModel!.city;
      // IMPORTANT: Also set the cityController text for the new TextField implementation
      addRestaurantController.cityController.text =
          restaurantDetailsModel!.city;

      // Set phone, website, and zip code
      addRestaurantController.phoneNoController.text =
          restaurantDetailsModel!.phoneNo;
      addRestaurantController.websiteUrlController.text =
          restaurantDetailsModel!.websiteUrl;
      addRestaurantController.zipCodeController.text =
          restaurantDetailsModel!.zipCode;

      addRestaurantController.selectedSpokenLanguage.value =
          restaurantDetailsModel!.spokenLanguage;
      addRestaurantController.currentRestaurantID =
          restaurantDetailsModel!.docID;

      print(
          '🧹 Clearing existing uploadedImage list (current size: ${addRestaurantController.uploadedImage.length})');
      addRestaurantController.uploadedImage.clear();
      print(
          '🧹 After clear, uploadedImage length: ${addRestaurantController.uploadedImage.length}');

      print(
          '📸 Loading ${restaurantDetailsModel!.imagesList.length} images from restaurant data');
      print('📸 Image URLs from restaurantDetailsModel:');
      for (int i = 0; i < restaurantDetailsModel!.imagesList.length; i++) {
        String url = restaurantDetailsModel!.imagesList[i];
        print('  [$i] Adding image URL: $url');
        addRestaurantController.uploadedImage.add(
          UploadedImageModel(url: url),
        );
        print(
            '  [$i] uploadedImage length after add: ${addRestaurantController.uploadedImage.length}');
      }
      print(
          '✅ Total images in uploadedImage list: ${addRestaurantController.uploadedImage.length}');
      print('✅ uploadedImage contents:');
      for (int i = 0; i < addRestaurantController.uploadedImage.length; i++) {
        final img = addRestaurantController.uploadedImage[i];
        print(
            '  [$i] url: ${img.url}, bytes: ${img.bytes != null ? "has bytes" : "null"}');
      }

      addRestaurantController.latitude.value =
          restaurantController.latitude.value;
      addRestaurantController.longitude.value =
          restaurantController.longitude.value;

      // Force update to ensure UI rebuilds
      addRestaurantController.uploadedImage.refresh();
      addRestaurantController.update();

      print(
          '🔄 Controller updated. Final image count: ${addRestaurantController.uploadedImage.length}');
    }
  }

  // Fill variables in AmenitiesSubScreenController (Amenities)
  fillAllVarsforAmmenitiesController() {
    final amenitiesController = Get.put(AmenitiesSubScreenController());

    if (restaurantDetailsModel != null) {
      // Update facilities
      for (var facility in amenitiesController.facilities) {
        facility['isChecked'] =
            restaurantDetailsModel!.facilityList.contains(facility['name']);
      }

      // Update dietary preferences
      for (var dietary in amenitiesController.dietaryPreferences) {
        dietary['isChecked'] =
            restaurantDetailsModel!.dietaryList.contains(dietary['name']);
      }

      // Update atmosphere
      for (var atm in amenitiesController.atmosphere) {
        atm['isChecked'] =
            restaurantDetailsModel!.atmosphereList.contains(atm['name']);
      }

      // Update price range
      for (var price in amenitiesController.priceRange) {
        price['isChecked'] =
            restaurantDetailsModel!.priceRange == price['name'];
      }

      amenitiesController.facilities.refresh();
      amenitiesController.dietaryPreferences.refresh();
      amenitiesController.atmosphere.refresh();
      amenitiesController.priceRange.refresh();
      amenitiesController.update();
    }
  }

  // Fill variables in ExperiencesSubScreenController (Experiences)
  Future<void> fillAllVarsforExperiencesController() async {
    final experiencesController = Get.put(ExperiencesSubScreenController());
    restaurantDetailsModel = restaurantController.restaurantModel;

    if (restaurantDetailsModel != null &&
        restaurantDetailsModel!.entertainmentScheduleList != null) {
      experiencesController.events.clear();

      // Map each item to a Future<Map<String, dynamic>> and resolve all futures
      final maps = await Future.wait(
        restaurantDetailsModel!.entertainmentScheduleList.map(
          (item) => item.toMap(),
        ),
      );

      // Add the resolved maps to events
      experiencesController.events.addAll(maps);

      experiencesController.events.refresh();
      experiencesController.update();
    }
  }

  // Fill variables in OperatingHoursSubScreenController (Operating Hours)
  Future<void> fillAllVarsforOperatingHoursController() async {
    final operatingHoursController =
        Get.put(OperatingHoursSubScreenController());
    restaurantDetailsModel = restaurantController.restaurantModel;

    if (restaurantDetailsModel != null &&
        restaurantDetailsModel!.docID != null) {
      // Fetch operating hours from Firestore subcollection
      final snapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantDetailsModel!.docID)
          .collection('operatingHours')
          .get();

      for (var doc in snapshot.docs) {
        final day = doc.id;
        final data = doc.data();

        // Initialize daySwitches and daySwitchControllers if not set
        operatingHoursController.daySwitches[day] ??= true;
        operatingHoursController.daySwitchControllers[day] ??=
            ValueNotifier<bool>(true);

        // Check if all slots are closed
        bool allClosed = true;
        for (var meal in ['Breakfast', 'Brunch', 'Lunch', 'Dinner']) {
          if (data[meal] != null && data[meal]['isClosed'] == false) {
            allClosed = false;
            break;
          }
        }

        // Update daySwitches and daySwitchControllers
        operatingHoursController.daySwitches[day] = !allClosed;
        operatingHoursController.daySwitchControllers[day]!.value = !allClosed;

        // Update slot states and times
        for (var meal in ['Breakfast', 'Brunch', 'Lunch', 'Dinner']) {
          operatingHoursController.slotStates[day]![meal] =
              data[meal] != null && data[meal]['isClosed'] == false;
          if (data[meal] != null && data[meal]['isClosed'] == false) {
            operatingHoursController.slotTimes[day]![meal] =
                '${data[meal]['startTime']} - ${data[meal]['endTime']}';
          } else {
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
        menuController.selectedCuisine.value = menu.cuisineType ?? '';
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
