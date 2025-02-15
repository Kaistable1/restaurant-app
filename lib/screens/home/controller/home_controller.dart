import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main_screen.dart';

class HomeController extends GetxController {
  var selectedOption = "Option 1".obs; // Default selected option
  var isLoading = false.obs; // Loading state
  TextEditingController searchController =
      TextEditingController(); // Search field controller
  var errorMessage = "".obs; // Error message state

  void setSelected(String value) {
    selectedOption.value = value;
  }

  void search() async {
    if (searchController.text.trim().isEmpty) {
      errorMessage.value = "Please enter the restaurant name";
      return;
    }

    errorMessage.value = ""; // Clear error if valid input
    isLoading.value = true; // Show progress indicator
    await Future.delayed(Duration(seconds: 2)); // Simulate search delay
    isLoading.value = false; // Hide progress indicator
    Get.offAll(() => MainScreen(), arguments: 1); // Navigate to SearchScreen
  }
}
