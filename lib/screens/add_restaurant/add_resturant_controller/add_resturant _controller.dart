import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_web_app/main.dart';
import 'package:restaurant_web_app/screens/add_restaurant/edit_restaurant/edit_resturant.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/restaurant_detail_screen.dart';
import 'package:restaurant_web_app/universal_models/operating_hours.dart';
import 'package:restaurant_web_app/universal_models/restaurant_model.dart';
import 'package:restaurant_web_app/widgets/loading_dialog.dart';
import 'package:restaurant_web_app/widgets/no_internet_dialog.dart';

import '../../../../constants/colors.dart';
import '../../../testing.dart';
import '../../../universal_models/discount_model.dart';

import '../../../widgets/global_functions.dart';
import '../../entertainment_screen/entertainment_screen.dart';
import '../../facilities_screen/facilities.dart';
import '../../operating_hour_screen/operating_hour_screen.dart';

class AddRestaurantController extends GetxController {
  ///backend

  RestaurantModel restaurantModel = RestaurantModel.initialize();

  Map<String, dynamic> generateOperatingHours() {
    return mealTimes.map((day, meals) {
      return MapEntry(
        day,
        meals.map((meal, details) {
          return MapEntry(
            meal,
            (details["isClosed"] as bool) ?? false
                ? {"isClosed": true}
                : {
                    "startTime": details["From"],
                    "endTime": details["To"],
                    "isClosed": false,
                  },
          );
        }),
      );
    });
  }

  /// on tap to add all details in db
  Future<void> updateRestaurantData(BuildContext context) async {
    try {
      loadingDialog(message: 'Please wait !!', loading: true);

      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        Get.back();
        showNoInternetDialog();
        return;
      }

      final restaurantRef = FirebaseFirestore.instance
          .collection('restaurants')
          .doc(auth.currentUser!.uid);

      final currentDataSnapshot = await restaurantRef.get();
      if (!currentDataSnapshot.exists) {
        throw Exception("Restaurant data not found.");
      }
      Map<String, dynamic> currentData = currentDataSnapshot.data()!;
      restaurantModel.longitude = longitude.value;
      restaurantModel.latitude = latitude.value;
      Map<String, dynamic> newData = await restaurantModel.toMap();

      Map<String, dynamic> updatedFields = {};

      newData.forEach((key, value) {
        if (value != null && value != '' && currentData[key] != value) {
          updatedFields[key] = value;
        }
      });

      // Special handling for `entertainmentScheduleList` to compare nested lists
      if (newData.containsKey('entertainmentScheduleList')) {
        List currentSchedule = currentData['entertainmentScheduleList'] ?? [];
        List newSchedule = newData['entertainmentScheduleList'] ?? [];

        if (!_listEquals(currentSchedule, newSchedule)) {
          updatedFields['entertainmentScheduleList'] = newSchedule;
        }
      }

      // Handle no changes
      if (updatedFields.isEmpty) {
        Get.back();
        Get.snackbar("No Changes", "No data to update.");
        return;
      }

      // Update Firestore
      await restaurantRef.update(updatedFields).then((_) {


        // Get.offAll(RestaurantDetailScreen());
        // Get.snackbar("Success", "Data updated successfully!");
      }).catchError((error) {
        print("Update Error: $error");
        Get.snackbar("Error", "Failed to update data: $error");
      });
    } catch (e) {
      print("Exception: $e");
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      showDoneDialog(context);
      // Get.back();
    }
  }

// Helper function to compare lists
  bool _listEquals(List list1, List list2) {
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }

  ///onTap of entertainment

  // void onTapEntertainment(BuildContext context) {
  //   if (eventNames.isEmpty ||
  //       byValues.isEmpty ||
  //       selectedDays.isEmpty ||
  //       selectedDates.isEmpty ||
  //       selectedTimes.isEmpty) {
  //     loadingDialog(
  //         button: true,
  //         message: 'Please fill in all details before continuing.');
  //     return;
  //   }
  //
  //   List<EntertainmentScheduleModel> entertainmentSchedules = [];
  //
  //   for (int i = 0; i < eventNames.length; i++) {
  //     if (eventNames[i].trim().isEmpty ||
  //         byValues[i].trim().isEmpty ||
  //         selectedDays.length <= i ||
  //         selectedDays[i] == null ||
  //         selectedDays[i]!.trim().isEmpty ||
  //         selectedDates.length <= i ||
  //         selectedDates[i] == null ||
  //         selectedTimes.length <= i ||
  //         selectedTimes[i]["from"] == null ||
  //         selectedTimes[i]["to"] == null) {
  //       loadingDialog(
  //           button: true,
  //           message: 'Please fill in all details before continuing.');
  //       return;
  //     }
  //
  //     String formattedDate =
  //         DateFormat('dd MMM, yyyy').format(selectedDates[i]!);
  //
  //     Map<String, dynamic> schedule = {
  //       "eventName": eventNames[i],
  //       "eventBy": byValues[i],
  //       "day": selectedDays[i]!,
  //       "date": formattedDate,
  //       'startTime': selectedTimes[i]["from"]?.format(context) ?? '',
  //       'endTime': selectedTimes[i]["to"]?.format(context) ?? '',
  //       'isSelected':
  //           checkBoxValues.length > i ? checkBoxValues[i] ?? false : false,
  //     };
  //
  //     entertainmentSchedules.add(EntertainmentScheduleModel.fromMap(schedule));
  //   }
  //
  //   // Delay state update until after the widget tree has finished building
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     restaurantModel.entertainmentScheduleList = entertainmentSchedules;
  //
  //     // Navigate only after updating state
  //     Get.to(() => OperatingHourScreen1(isFromButtonClick: true));
  //   });
  // }
  void onTapEntertainment(BuildContext context) {
    bool hasStartedFilling = eventNames.any((name) => name.trim().isNotEmpty);

    if (!hasStartedFilling) {
      // No event names added, allow navigation
      Get.to(() => OperatingHourScreen1(isFromButtonClick: true));
      return;
    }

    List<EntertainmentScheduleModel> entertainmentSchedules = [];

    for (int i = 0; i < eventNames.length; i++) {
      if (eventNames[i].trim().isNotEmpty) {
        // Ensure all details are provided if an event name exists
        if (byValues.length <= i ||
            byValues[i].trim().isEmpty ||
            selectedDays.length <= i ||
            selectedDays[i] == null ||
            selectedDays[i]!.trim().isEmpty ||
            selectedDates.length <= i ||
            selectedDates[i] == null ||
            selectedTimes.length <= i ||
            selectedTimes[i]["from"] == null ||
            selectedTimes[i]["to"] == null) {
          loadingDialog(
              button: true,
              message: 'Please fill in all details before continuing.');
          return;
        }

        String formattedDate =
        DateFormat('dd MMM, yyyy').format(selectedDates[i]!);

        Map<String, dynamic> schedule = {
          "eventName": eventNames[i],
          "eventBy": byValues[i],
          "day": selectedDays[i]!,
          "date": formattedDate,
          'startTime': selectedTimes[i]["from"]?.format(context) ?? '',
          'endTime': selectedTimes[i]["to"]?.format(context) ?? '',
          'isSelected':
          checkBoxValues.length > i ? checkBoxValues[i] ?? false : false,
        };

        entertainmentSchedules.add(EntertainmentScheduleModel.fromMap(schedule));
      }
    }

    // Update state after widget tree finishes building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      restaurantModel.entertainmentScheduleList = entertainmentSchedules;
      Get.to(() => OperatingHourScreen1(isFromButtonClick: true));
    });
  }

  ///save discount

  var items = <ItemModel>[].obs;
  var categoryItems = <CategoryModel>[].obs;
  RxList<Uint8List> memoryImages = RxList<Uint8List>();

  /// Function to upload images to Firebase and return their URLs
  Future<List<RxString>> uploadImagesToFirebase(List<Uint8List> images) async {
    List<RxString> imageUrls = [];
    List<Uint8List> imagesCopy = List.from(images); // 🔥 Fix: Create a copy

    for (var image in imagesCopy) {
      try {
        String imageUrl = await uploadImageToFirebase("items", image);
        imageUrls.add(imageUrl.obs); // Convert String to RxString
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    return imageUrls;
  }

  final TextEditingController offerController = TextEditingController();
  String? selected_menuType;
  String? selected_cuisne;

  /// Function to add an item with uploaded images

  void addItem(String name, String description, String price) async {
    if (name.isEmpty || description.isEmpty || price.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (memoryImages.isEmpty) {
      Get.snackbar(
        "Error",
        "Please add at least one image.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 🔹 Step 1: Add item immediately with a placeholder image
    final newItem = ItemModel(
      cuisineMenu: name,
      cuisineName: description,
      offer: price,
      itemImages: RxList<RxString>(), // Initially empty, will update later
      itemMemoryImages:
          RxList<Uint8List>.from(memoryImages), // Show local images first
    );

    items.add(newItem); // Add to UI immediately

    // 🔹 Step 2: Start uploading images in the background
    uploadImagesToFirebase(List.from(memoryImages)).then((uploadedUrls) {
      newItem.itemImages.addAll(uploadedUrls); // Update images after upload
      items.refresh(); // 🔄 Refresh UI when upload completes
    });

    // 🔹 Step 3: Clear fields immediately (without blocking UI)
    selected_menuType = '';
    // selected_cuisne = '';
    offerController.clear();
    memoryImages.clear();
  }

  /// Save category to Firestore
  Future<void> saveCategoryToFirestore() async {
    assignDiscountData(); // Assign values before saving

    if (discountModel == null) {
      print("No discount data to save.");
      return;
    }

    Get.defaultDialog(
      title: 'Saving Data',
      content: const CircularProgressIndicator(),
      barrierDismissible: false,
    );

    try {
      // 🔥 Fix: Upload images before saving
      // for (var category in discountModel!.menu) {
      //   for (var item in category.items) {
      //     List<String> imageUrls = [];
      //
      //     for (var image in List.from(item.itemMemoryImages)) { // 🔥 Fix: Copy list
      //       String uploadedUrl = await uploadImageToFirebase('items', image);
      //       imageUrls.add(uploadedUrl);
      //     }
      //
      //     // 🔥 Fix: Convert RxString to String before storing in Firestore
      //     item.itemImages.clear();
      //     item.itemImages.addAll(imageUrls.map((url) => RxString(url)));
      //
      //     print('Final itemImages: ${item.itemImages.map((e) => e.value).toList()}');
      //   }
      // }

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(auth.currentUser!.uid)
          .collection("MealMenu")
          .add(discountModel!.toMap());

      Get.back();
      print('Data saved to Firestore successfully!');
      categoryItems.clear();
      discountModel = null; // Reset after saving
      Get.snackbar("Discount", "Discount is successfully saved",
          maxWidth: 400, backgroundColor: AppColors.primaryColor);
    } catch (e) {
      print('Error saving data to Firestore: $e');
    }
  }

  final TextEditingController fromTimeHourController = TextEditingController();
  final TextEditingController fromTimeMintController = TextEditingController();
  final TextEditingController toTimeMintController = TextEditingController();
  final TextEditingController toTimeHourController = TextEditingController();
  void addCategoryAndSubcategory(String category, String subcategory,
      {String? fromDate,
      String? toDate,
      String? percentageValue,
      String? FromTime,
      String? ToTime,
      String? discountType,
      fromTimeType,
      String? toTimeType,
      required bool lifeTime,
      required bool isAllDay}) {
    if (items.isNotEmpty) {
      categoryItems.add(CategoryModel(
        fromDate: fromDate ?? '',
        toDate: toDate ?? '',
        lifeTime: lifeTime,
        isAllDay: isAllDay,
        percentageValue: percentageValue ?? '',
        fromTime: FromTime ?? '',
        toTime: ToTime ?? '',
        discountType: discountType ?? '',
        toTimeType: toTimeType ?? '',
        items: items.toList(),
      ));
      items.clear();
      fromTimeHourController.clear();
      fromTimeMintController.clear();
      toTimeMintController.clear();
      toTimeHourController.clear();

    }
  }

  //
  DiscountModel? discountModel;
  // Function to assign data to the discount model before saving
  void assignDiscountData() {
    if (categoryItems.isNotEmpty) {
      discountModel = DiscountModel(
        discountType: categoryItems.first.discountType,
        fromDate: categoryItems.first.fromDate,
        toDate: categoryItems.first.toDate,
        menu: categoryItems.toList(),
        timestamp: DateTime.now(), // Will be replaced with Firestore timestamp
      );
    }

    categoryItems.clear();
  }

  ///
  Future<RestaurantModel> getRestaurantById() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(auth.currentUser!.uid)
          .get();
      if (doc.exists) {
        return RestaurantModel.fromDocumentSnapshot(
            doc.data() as DocumentSnapshot<Map<String, dynamic>>);
      } else {
        throw Exception("Restaurant not found");
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  ///add operating hour function
  Future<void> saveAllOperatingHours() async {
    print("Saving Operating Hours...");

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print("Error: User not logged in.");
      return;
    }

    for (var day in mealTimes.keys) {
      // Create a map to hold meal periods for the current day
      Map<String, dynamic> mealsMap = {};

      // Check if the day is toggled off
      if (dayToggles[day] == false) {
        print("$day is toggled off. Saving all meals as closed...");
        // Mark all meals as closed for this day
        for (var meal in mealTimes[day]!.keys) {
          mealsMap[meal] = {"isClosed": true};
        }
      } else {
        // Iterate over meal periods for the active day
        for (var meal in mealTimes[day]!.keys) {
          // Check if the meal is active
          if (cellToggles[day]![meal] == false) {
            mealsMap[meal] = {"isClosed": true}; // Mark meal as closed
            continue;
          }

          // Get the meal's start and end time
          final fromTime = mealTimes[day]![meal]!['From'];
          final toTime = mealTimes[day]![meal]!['To'];

          // Skip invalid times
          if (fromTime == null ||
              fromTime.isEmpty ||
              toTime == null ||
              toTime.isEmpty) {
            print("Skipping $meal on $day: Invalid times.");
            mealsMap[meal] = {"isClosed": true}; // Save as closed
            continue;
          }

          // Add meal period to the day's map
          mealsMap[meal] = {
            "isClosed": false,
            "startTime": fromTime,
            "endTime": toTime,
          };
        }
      }

      // Save the day's meals map to Firestore
      try {
        await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(uid)
            .collection('operatingHours')
            .doc(day) // Day as document
            .set(mealsMap); // Meals as map
        print("$day saved successfully in Firestore.");
      } catch (e) {
        print("Error saving $day: $e");
      }
    }

    print("All operating hours saved successfully.");
  }

  void saveEntertainmentData(context) {
    List<Map<String, dynamic>> entertainmentSchedules = [];

    for (int i = 0; i < eventNames.length; i++) {
      Map<String, dynamic> schedule = {
        "eventName": eventNames[i],
        "eventBy": byValues[i],
        "day": selectedDays[i],
        "date": selectedDates[i] != null
            ? DateFormat('dd MMM,  yyyy').format(selectedDates[i]!)
            : null,
        'startTime': selectedTimes[i]["from"]?.format(context),
        'endTime': selectedTimes[i]["to"]?.format(context),
        'isSelected': checkBoxValues[i],
      };
      entertainmentSchedules.add(schedule);
    }

    // Save the data to Firestore
    FirebaseFirestore.instance
        .collection('restaurants')
        .doc(auth.currentUser!.uid)
        .update({
      'entertainmentScheduleList': entertainmentSchedules,
    }).then((_) {
      Get.snackbar("Success", "Entertainment data saved successfully!");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to save data: $error");
    });
  }

  // Add a new entertainment schedule to a restaurant
  Future<void> addEntertainmentSchedule(
      EntertainmentScheduleModel newSchedule) async {
    try {
      // Fetch the restaurant document
      RestaurantModel restaurant = await getRestaurantById();

      // Add the new schedule to the list
      restaurant.entertainmentScheduleList ??= [];
      restaurant.entertainmentScheduleList!.add(newSchedule);

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(auth.currentUser!.uid)
          .update({
        'entertainmentScheduleList': restaurant.entertainmentScheduleList
            .map((schedule) => schedule.toMap())
            .toList(),
      });

      Get.snackbar("Success", "Entertainment schedule added successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to add schedule: $e");
    }
  }

  ///frontend
  // Global key to manage the form state
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Add a flag to indicate if the data is saved
  RxBool isDataSaved = false.obs;
  RxString restaurantsNameError = ''.obs;
  RxString resAboutError = ''.obs;
  RxString addressError = ''.obs;
  RxString phoneError = ''.obs;
  RxString cityError = ''.obs;
  RxString countryError = ''.obs;
  RxString zipCodeError = ''.obs;
  RxString aboutError = ''.obs;

  // Text editing controllers for form fields
  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  // TextEditingController cuisineController = TextEditingController();

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  // List for added cuisines
  List<String> addedCuisines = [];

  void saveNextScreenTemporary() {
    Get.to(() => FacilitiesScreen(isFromButtonClick: true));
  }

  void saveNextScreen() {
    bool isValid = true;

    // Log all values before validation
    print("Restaurant Name: ${restaurantModel.resName.text}");
    print("About: ${restaurantModel.about.text}");
    print("Address: ${restaurantModel.address.text}");
    print("Phone: ${restaurantModel.phoneNumber.text}");
    print("City: ${restaurantModel.city.text}");
    print("Country: ${restaurantModel.country.text}");
    print("Zip Code: ${restaurantModel.zipCode.text}");

    // ✅ Validate Restaurant Name
    if (restaurantModel.resName.text.isEmpty) {
      restaurantsNameError.value = "Enter Restaurant Name";
      isValid = false;
    } else if (restaurantModel.resName.text.length < 3) {
      restaurantsNameError.value =
          "Restaurant Name must be at least 3 characters";
      isValid = false;
    } else {
      restaurantsNameError.value = '';
    }

    // ✅ Validate About
    if (restaurantModel.about.text.isEmpty) {
      aboutError.value = "Enter about restaurant.";
      isValid = false;
    } else if (restaurantModel.about.text.length < 3) {
      aboutError.value = "About restaurant must be at least 3 characters";
      isValid = false;
    } else {
      aboutError.value = '';
    }

    // ✅ Validate Address
    if (restaurantModel.address.text.isEmpty) {
      addressError.value = "Enter your address";
      isValid = false;
    } else if (restaurantModel.address.text.length < 5) {
      addressError.value =
          "Address is too short. It must be at least 5 characters.";
      isValid = false;
    } else {
      addressError.value = '';
    }

    // ✅ Validate Phone Number
    if (restaurantModel.phoneNumber.text.isEmpty) {
      phoneError.value = "Please enter your phone number";
      isValid = false;
    } else if (!RegExp(r'^\d{7,15}$')
        .hasMatch(restaurantModel.phoneNumber.text)) {
      phoneError.value = "Phone number must be 7 to 15 digits long.";
      isValid = false;
    } else {
      phoneError.value = '';
    }

    // ✅ Validate City
    if (restaurantModel.city.text.isEmpty) {
      cityError.value = "Enter your city name";
      isValid = false;
    } else if (restaurantModel.city.text.length < 2) {
      cityError.value =
          "City name is too short. It must be at least 2 characters.";
      isValid = false;
    } else if (!RegExp(r'^[a-zA-Z\s-]+$').hasMatch(restaurantModel.city.text)) {
      cityError.value =
          "City name can only contain letters, spaces, or hyphens.";
      isValid = false;
    } else {
      cityError.value = '';
    }

    // ✅ Validate Country
    if (restaurantModel.country.text.isEmpty) {
      countryError.value = "Enter your country name";
      isValid = false;
    } else if (restaurantModel.country.text.length < 2) {
      countryError.value =
          "Country name is too short. It must be at least 2 characters.";
      isValid = false;
    } else {
      countryError.value = '';
    }

    // ✅ Validate Zip Code
    if (restaurantModel.zipCode.text.isEmpty) {
      zipCodeError.value = "Enter your zip code";
      isValid = false;
    } else if (!RegExp(r'^\d{5}$').hasMatch(restaurantModel.zipCode.text)) {
      zipCodeError.value =
          "Zip code must be exactly 5 digits and only contain numbers.";
      isValid = false;
    } else {
      zipCodeError.value = '';
    }
    // ✅ Validate Logo Image

    print("Validation Status: $isValid");

    if (isValid) {
      if (restaurantModel.logoImageMemory.value.isEmpty) {
        Get.snackbar("Please wait !!!", "Please add a logo!",
            backgroundColor: AppColors.primaryColor,
            colorText: Colors.white,
            maxWidth: 400);
      } else if (restaurantModel.resImageMemory.isEmpty) {
        Get.snackbar("Please wait !!!", "Please add restaurant images!",
            backgroundColor: AppColors.primaryColor,
            colorText: Colors.white,
            maxWidth: 400);
      } else {
        print("Navigating to FacilitiesScreen...");
        Get.snackbar("Success", "Data saved successfully!",
            backgroundColor: AppColors.primaryColor,
            colorText: Colors.white,
            maxWidth: 400);
        Get.to(() => FacilitiesScreen(isFromButtonClick: true));
      }
    }
  }

  void onNext() {
    if (isDataSaved.value) {
      // Proceed to the next screen
      Get.to(() => FacilitiesScreen(isFromButtonClick: true));
    } else {
      Get.snackbar('Error', 'Please save your data first');
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///facilities model

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  RxString descriptionError = ''.obs;
  RxString linkError = ''.obs;

  ///save button of facilities
  void saveAndNext() {
    bool isValid = true;

    // Clear any previous error messages
    descriptionError.value = '';
    linkError.value = '';

    // Check if at least one option is selected from each list
    if (facilitySelection.isEmpty ||
        atmosphereSelection.isEmpty ||
        dietarySelection.isEmpty ||
        selectedPriceRange.value.isEmpty) {
      // Show error if any selection is missing
      Get.snackbar('Error', 'Please select at least one option from each list.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primaryColor,
          maxWidth: 400,
          colorText: AppColors.whiteColor);
      isValid = false;
    }

    if (restaurantModel.specialConditions.text == '') {
      Get.snackbar(
        "Special Conditions Required",
        "Please enter special conditions before saving.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.white,
        maxWidth: 400,
        duration: Duration(seconds: 2),
      );
      isValid = false;
    }

    if (restaurantModel.socialLink.text == '') {
      Get.snackbar(
        "Link Required",
        "Please enter Link before saving.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.white,
        maxWidth: 400,
        duration: Duration(seconds: 2),
      );
      isValid = false;
    }

    if (isValid) {
      ///assigning things

      restaurantModel.dietaryList.value = dietarySelection;
      restaurantModel.socialMedia = selectedSocialMedia;
      restaurantModel.priceRange = selectedPriceRange;
      restaurantModel.atmopshereList.value = atmosphereSelection;
      restaurantModel.facilityList.value = facilitySelection;
      Get.snackbar('Success',
          'All fields selected and validated. Proceeding to next step.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primaryColor,
          maxWidth: 400,
          colorText: AppColors.whiteColor);
      Get.to(() => Entertainment_Screen(
            isFromButtonClick: true,
          ));

      descriptionController.clear();
      linkController.clear();
    }
  }

  var selectedFacility = ''.obs;

  var selectedPriceRange = ''.obs;
  var selectedSocialMedia = 'Tiktok'.obs;
  RxList<String> facilitySelection = <String>[].obs;
  RxList<String> dietarySelection = <String>[].obs;
  // RxList entertainmentSelection = [].obs;
  RxList<String> atmosphereSelection = <String>[].obs;

  // Observable list for facilities
  var facilities = <String>[
    'Free wi-fi',
    'Parking',
    'Takeout',
    'Drive-thru',
    'Wheelchair accessibility',
    'High chairs',
    'Restrooms',
    'Outdoor seating',
    'Private dining',
    'Kid-Friendly',
    'Pet-Friendly',
    'Keto-Friendly'
  ].obs;
  var socialMedia = ['Tiktok', 'Instagram', 'Facebook', 'Twitter'];
  var dietary = <String>[
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Dairy-Free',
  ].obs;

  var reservation = <String>[
    'No reservation needed',
    'Reservation Required',
    'Walk-Ins Welcome',
  ].obs;
  var pricerange = <String>[
    '\$(Budget-Friendly)',
    '\$\$(Moderate)',
    '\$\$\$(Premium)',
    '\$\$\$\$(Luxury)',
  ].obs;
  // Observable list for atmosphere options
  var atmosphere =
      <String>['Casual dining', 'Fast dining', 'Fine dining', 'Pop'].obs;

  // Set the selected facility
  void selectFacility(String facility) {
    selectedFacility.value = facility;
  }

  void selectPriceRange(String priceRangeOption) {
    selectedPriceRange.value = priceRangeOption;
  }

  // Add a new facility
  void addFacility(String facility) {
    if (!facilities.contains(facility)) {
      facilities.add(facility);
    }
  }

  void adddietary(String dietaryOption) {
    if (!dietary.contains(dietaryOption)) {
      dietary.add(dietaryOption);
    }
  }

  void addPriceRange(String priceRangeOption) {
    if (!pricerange.contains(priceRangeOption)) {
      pricerange.add(priceRangeOption);
    }
  }

  // Add a new atmosphere option
  void addAtmosphere(String atmosphereOption) {
    if (!atmosphere.contains(atmosphereOption)) {
      atmosphere.add(atmosphereOption);
    }
  }

  //////////////////////////////////
  ///EventTableController
  final List<String> eventNames = <String>[].obs;

  final List<String> byValues = <String>[].obs;

  final List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  final selectedDays = List<String?>.filled(7, null).obs;
  final selectedDates = List<DateTime?>.filled(7, null).obs;
  final selectedTimes = List<Map<String, TimeOfDay?>>.generate(
    0,
    (_) => {"from": null, "to": null},
  ).obs;

  final customEventController = TextEditingController();
  final customByController = TextEditingController();
  final checkBoxValues = List<bool>.filled(6, false).obs;

  void addCustomEvent(String eventName, String byName) {
    eventNames.add(eventName);
    byValues.add(byName);
    checkBoxValues.add(false); // Add a checkbox for the new entry
    selectedDays.add(null);
    selectedDates.add(null);
    selectedTimes.add({"from": null, "to": null});
  }

  void toggleCheckbox(int index) {
    checkBoxValues[index] = !checkBoxValues[index];
    update();
  }

  ///////////////////////////////////////////////////////////////////////////////
  ///operating hours

  final TextEditingController aboutTextController = TextEditingController();

  ///going to meal screen from
  void nextSave() async {
    Get.snackbar("Success", "Data saved successfully!",
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.white,
        maxWidth: 400);
    Get.to(() => EditRestaurantScreen(
          isFromButtonClick: true,
        ));

    await saveAllOperatingHours();
  }

  // Stores the selected times for each meal of each day
  var mealTimes = <String, Map<String, Map<String, String>>>{}.obs;
  var dayToggles = <String, bool>{}.obs;
  var cellToggles = <String, Map<String, bool>>{}.obs;

  AddRestaurantController() {
    for (var day in days) {
      mealTimes[day] = {
        'Breakfast': {'From': '', 'To': ''},
        'Brunch': {'From': '', 'To': ''},
        'Lunch': {'From': '', 'To': ''},
        'Dinner': {'From': '', 'To': ''},
        'Late Night': {'From': '', 'To': ''},
      };
      dayToggles[day] = true; // Default toggle is ON
      cellToggles[day] = {
        'Breakfast': true,
        'Brunch': true,
        'Lunch': true,
        'Dinner': true,
        'Late Night': true,
      };
    }
  }

  Future<void> selectTime(
      BuildContext context, String day, String meal, String type) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      mealTimes[day]![meal]![type] = picked.format(context);
      mealTimes.refresh();
    }
  }

  final toDateController = TextEditingController();
  final fromDateController = TextEditingController();
  final toTimeController = TextEditingController();

  final fromTimeMinuteController = TextEditingController();
}
