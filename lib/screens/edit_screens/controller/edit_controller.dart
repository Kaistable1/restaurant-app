import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/main.dart';
import 'package:restaurant_web_app/universal_models/restaurant_model.dart';
import 'package:restaurant_web_app/widgets/loading_dialog.dart';
import 'package:restaurant_web_app/widgets/no_internet_dialog.dart';

import '../../entertainment_screen/entertainment_screen.dart';
import '../../operating_hour_screen/operating_hour_screen.dart';
import '../../restaurant_detail_screen/restaurant_detail_screen.dart';

class EditScreenController extends GetxController {
  /// on tap to add all details in db
  Future<void> updateRestaurantData(
      BuildContext context, RestaurantModel restaurantModel) async {
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
      restaurantModel.latitude = longitude.value;
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
        Get.snackbar('Update', 'Your data is successfully updated.');
        Get.to(() => RestaurantDetailScreen(
              isFromButtonClick: true,
            ));
      }).catchError((error) {
        print("Update Error: $error");
        Get.snackbar("Error", "Failed to update data: $error");
      });
    } catch (e) {
      print("Exception: $e");
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      Get.back();
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

  var latitude = 37.42796133580664.obs;
  var longitude = 122.085749655962.obs;

  ///facility controller
  // Observable variables to track the selected facility and atmosphere
  var selectedFacility = ''.obs;
  var selectedPriceRange = ''.obs;
  var selectedSocialMedia = 'Tiktok'.obs;
  RxList<String> facilitySelection = <String>[].obs;
  RxList<String> dietarySelection = <String>[].obs;
  RxList<String> atmosphereSelection = <String>[].obs;


  var selectedAtmosphere = ''.obs;
  final TextEditingController facilitiesTextController =
  TextEditingController();
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
  // Add a new facility
  void addFacility(String facility) {
    if (!facilities.contains(facility)) {
      facilities.add(facility);
    }
  }
  // Set the selected atmosphere
  void selectAtmosphere(String atmosphereOption) {
    selectedAtmosphere.value = atmosphereOption;
  }


  // Add a new atmosphere option
  void addAtmosphere(String atmosphereOption) {
    if (!atmosphere.contains(atmosphereOption)) {
      atmosphere.add(atmosphereOption);
    }
  }

  void adddietary(String dietaryOption) {
    if (!dietary.contains(dietaryOption)) {
      dietary.add(dietaryOption);
    }
  }

  void selectPriceRange(String priceRangeOption) {
    selectedPriceRange.value = priceRangeOption;
  }

  void addPriceRange(String priceRangeOption) {
    if (!pricerange.contains(priceRangeOption)) {
      pricerange.add(priceRangeOption);
    }
  }
  ///save button of facilities
  void saveAndNext(BuildContext context,RestaurantModel restaurantModel ) {

    print('hsvdhd');
    bool isValid = true;

    // Clear any previous error messages
    // descriptionError.value = '';
    // linkError.value = '';

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

    if (  restaurantModel.specialConditions.text =='') {
      Get.snackbar(
        "Special Conditions Required",
        "Please enter special conditions before saving.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      isValid = false;
    }

    if (  restaurantModel.socialLink.text =='') {
      Get.snackbar(
        "Special Conditions Required",
        "Please enter special conditions before saving.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      isValid = false;
    }
    // If all validations pass, show success message and proceed
    if (isValid) {
      // Clear any errors
      // descriptionError.value = '';
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
      Get.back();
      updateRestaurantData(context, restaurantModel);
      // Get.to(() => Entertainment_Screen(
      //   isFromButtonClick: true,
      // ));

      // descriptionController.clear();
      // linkController.clear();
    }
  }

///edit entertainment
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
  void toggleCheckbox(int index) {
    checkBoxValues[index] = !checkBoxValues[index];
    update();
  }

  void addCustomEvent(String eventName, String byName) {
    eventNames.add(eventName);
    byValues.add(byName);
    checkBoxValues.add(false); // Add a checkbox for the new entry
    selectedDays.add(null);
    selectedDates.add(null);
    selectedTimes.add({"from": null, "to": null});
  }
  void onTapEntertainment(BuildContext context, RestaurantModel restaurantModel) {
    if (eventNames.isEmpty ||
        byValues.isEmpty ||
        selectedDays.isEmpty ||
        selectedDates.isEmpty ||
        selectedTimes.isEmpty) {
      loadingDialog(
          button: true,
          message: 'Please fill in all details before continuing.');
      return;
    }

    List<EntertainmentScheduleModel> entertainmentSchedules = [];

    for (int i = 0; i < eventNames.length; i++) {
      if (eventNames[i].trim().isEmpty ||
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

    // Delay state update until after the widget tree has finished building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      restaurantModel.entertainmentScheduleList = entertainmentSchedules;
      updateRestaurantData(context,restaurantModel);
      // Navigate only after updating state
      // Get.to(() => OperatingHourScreen1(isFromButtonClick: true));
    });
  }

}
