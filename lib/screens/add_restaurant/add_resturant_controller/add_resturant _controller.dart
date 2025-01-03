import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../facilities_screen/facilities.dart';

class AddRestaurantController extends GetxController {
  // Global key to manage the form state
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Add a flag to indicate if the data is saved
  RxBool isDataSaved = false.obs;
  RxString restaurantsNameError = ''.obs;
  RxString addressError = ''.obs;
  RxString phoneError = ''.obs;
  RxString cityError = ''.obs;
  RxString zipCodeError = ''.obs;
  // RxString cusineError = ''.obs;

  // Text editing controllers for form fields
  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  // TextEditingController cuisineController = TextEditingController();

  // List for added cuisines
  List<String> addedCuisines = [];
  void saveNext() {
    bool isValid = true;

    // Validate Restaurant Name
    if (restaurantNameController.text.isEmpty) {
      restaurantsNameError.value = "Enter Restaurant Name";
      isValid = false;
    } else {
      // You can add more validation rules here (e.g., minimum length, valid characters)
      if (restaurantNameController.text.length < 3) {
        restaurantsNameError.value =
            "Restaurant Name must be at least 3 characters";
        isValid = false;
      } else {
        restaurantsNameError.value = '';
      }
    }

    // Validate Address
    if (addressController.text.isEmpty) {
      addressError.value = "Enter your address";
      isValid = false;
    } else if (addressController.text.length < 5) {
      addressError.value =
          "Address is too short. It must be at least 5 characters.";
      isValid = false;
    } else if (!RegExp(r'^[a-zA-Z0-9\s,.-]+$')
        .hasMatch(addressController.text)) {
      addressError.value = "Address contains invalid characters.";
      isValid = false;
    } else if (!RegExp(r'[a-zA-Z]').hasMatch(addressController.text) ||
        !RegExp(r'\d').hasMatch(addressController.text)) {
      addressError.value = "Address must include both letters and numbers.";
      isValid = false;
    } else {
      addressError.value = '';
    }

    // Validate City
    if (cityController.text.isEmpty) {
      cityError.value = "Enter your city name";
      isValid = false;
    } else if (cityController.text.length < 2) {
      cityError.value =
          "City name is too short. It must be at least 2 characters.";
      isValid = false;
    } else if (!RegExp(r'^[a-zA-Z\s-]+$').hasMatch(cityController.text)) {
      cityError.value =
          "City name can only contain letters, spaces, or hyphens.";
      isValid = false;
    } else {
      cityError.value = '';
    }

    // Validate Zip Code
    if (zipCodeController.text.isEmpty) {
      zipCodeError.value = "Enter your zip code";
      isValid = false;
    } else if (!RegExp(r'^\d{4}$').hasMatch(zipCodeController.text)) {
      zipCodeError.value =
          "Zip code must be exactly 4 digits and only contain numbers.";
      isValid = false;
    } else {
      zipCodeError.value = '';
    }

    // // Validate Cuisines
    // if (addedCuisines.isEmpty) {
    //   cusineError.value = "Add your cuisine";
    //   isValid = false;
    // } else {
    //   cusineError.value = '';
    // }

    if (isValid) {
      Get.snackbar("Success", "Data saved successfully!",
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.white,
          maxWidth: 400);

      restaurantNameController.clear();
      addressController.clear();
      cityController.clear();
      zipCodeController.clear();
      phoneController.clear();
      // cuisineController.clear();
      // addedCuisines.clear();
      update();
    }
  }

  void saveNextScreen() {
    bool isValid = true;

    // Validate Restaurant Name
    if (restaurantNameController.text.isEmpty) {
      restaurantsNameError.value = "Enter Restaurant Name";
      isValid = false;
    } else {
      // You can add more validation rules here (e.g., minimum length, valid characters)
      if (restaurantNameController.text.length < 3) {
        restaurantsNameError.value =
            "Restaurant Name must be at least 3 characters";
        isValid = false;
      } else {
        restaurantsNameError.value = '';
      }
    }

    // Validate Address
    if (addressController.text.isEmpty) {
      addressError.value = "Enter your address";
      isValid = false;
    } else if (addressController.text.length < 5) {
      addressError.value =
          "Address is too short. It must be at least 5 characters.";
      isValid = false;
    } else if (!RegExp(r'^[a-zA-Z0-9\s,.-]+$')
        .hasMatch(addressController.text)) {
      addressError.value = "Address contains invalid characters.";
      isValid = false;
    } else if (!RegExp(r'[a-zA-Z]').hasMatch(addressController.text) ||
        !RegExp(r'\d').hasMatch(addressController.text)) {
      addressError.value = "Address must include both letters and numbers.";
      isValid = false;
    } else {
      addressError.value = '';
    }

    // Validate Phone Number
    if (phoneController.text.isEmpty) {
      phoneError.value = "Please enter your phone number";
      isValid = false;
    } else if (!RegExp(r'^\d{7,15}$').hasMatch(phoneController.text)) {
      phoneError.value = "Phone number must be 7 to 15 digits long.";
      isValid = false;
    } else {
      phoneError.value = '';
      isValid = true;
    }

    // Validate City
    if (cityController.text.isEmpty) {
      cityError.value = "Enter your city name";
      isValid = false;
    } else if (cityController.text.length < 2) {
      cityError.value =
          "City name is too short. It must be at least 2 characters.";
      isValid = false;
    } else if (!RegExp(r'^[a-zA-Z\s-]+$').hasMatch(cityController.text)) {
      cityError.value =
          "City name can only contain letters, spaces, or hyphens.";
      isValid = false;
    } else {
      cityError.value = '';
    }

    // Validate Zip Code
    if (zipCodeController.text.isEmpty) {
      zipCodeError.value = "Enter your zip code";
      isValid = false;
    } else if (!RegExp(r'^\d{5}$').hasMatch(zipCodeController.text)) {
      zipCodeError.value =
          "Zip code must be exactly 5 digits and only contain numbers.";
      isValid = false;
    } else {
      zipCodeError.value = '';
    }

    // Validate Cuisines
    // if (addedCuisines.isEmpty) {
    //   cusineError.value = "Add your cuisine";
    //   isValid = false;
    // } else {
    //   cusineError.value = '';
    // }

    if (isValid) {
      Get.snackbar("Success", "Data saved successfully!",
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.white,
          maxWidth: 400);
      Get.to(() => FacilitiesScreen(isFromButtonClick: true));

      restaurantNameController.clear();
      addressController.clear();
      cityController.clear();
      zipCodeController.clear();
      phoneController.clear();
      // cuisineController.clear();
      // addedCuisines.clear();
      update();
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
}

// Model class for location data
class LocationListModel {
  final String timeText;
  final String persentText;

  LocationListModel({
    required this.timeText,
    required this.persentText,
  });
}
