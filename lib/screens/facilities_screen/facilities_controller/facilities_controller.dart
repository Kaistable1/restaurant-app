import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';

import '../../entertainment_screen/entertainment_screen.dart';

class FacilitiesController extends GetxController {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  // RxString descriptionError = ''.obs;
  RxString linkError = ''.obs;

  void saveAndNext() {
    bool isValid = true;

    // Clear any previous error messages
    // descriptionError.value = '';
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

    // Validate the description field
    // if (descriptionController.text.isEmpty) {
    //   descriptionError.value = "Enter description";
    //   isValid = false;
    // } else if (descriptionController.text.length < 5) {
    //   descriptionError.value = "Description must be at least 5 characters";
    //   isValid = false;
    // }

    // Validate the link field
    // if (linkController.text.isEmpty) {
    //   linkError.value = "Enter link";
    //   isValid = false;
    // } else if (!linkController.text.startsWith("http://") &&
    //     !linkController.text.startsWith("https://")) {
    //   linkError.value =
    //       "Enter a valid URL starting with 'http://' or 'https://'";
    //   isValid = false;
    // }

    // If all validations pass, show success message and proceed
    if (isValid) {
      // Clear any errors
      // descriptionError.value = '';

      Get.snackbar('Success',
          'All fields selected and validated. Proceeding to next step.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.primaryColor,
          maxWidth: 400,
          colorText: AppColors.whiteColor);
      Get.to(() => Entertainment_Screen(
            isFromButtonClick: true,
          ));
      facilitySelection.clear();
      atmosphereSelection.clear();
      dietarySelection.clear();
      // entertainmentSelection.clear();
      pricerange.clear();

      descriptionController.clear();
      linkController.clear();
    }
  }

  var selectedFacility = ''.obs;
  var selectedAtmosphere = ''.obs;
  var selectedDietary = ''.obs;
  var selectedEntertainment = ''.obs;
  var selectedPriceRange = ''.obs;
  var selectedSocialMedia = 'Tiktok'.obs;
  RxList facilitySelection = [].obs;
  RxList dietarySelection = [].obs;
  // RxList entertainmentSelection = [].obs;
  RxList atmosphereSelection = [].obs;

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
  // var entertainment = <String>[
  //   'Live Music',
  //   'DJ Nights',
  //   'Karaoke',
  //   'Trivia Nights',
  //   'Sports Screenings',
  //   'Hookah'
  // ].obs;
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

  void selectDietary(String dietaryOption) {
    selectedDietary.value = dietaryOption;
  }

  // void selectEntertainment(String entertainmentOption) {
  //   selectedEntertainment.value = entertainmentOption;
  // }

  void selectPriceRange(String priceRangeOption) {
    selectedPriceRange.value = priceRangeOption;
  }

  // void selectReservation(String reservationOption) {
  //   selectedReservation.value = reservationOption;
  // }

  // Set the selected atmosphere
  void selectAtmosphere(String atmosphereOption) {
    selectedAtmosphere.value = atmosphereOption;
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

  // void addEntertainment(String entertainmentOption) {
  //   if (!entertainment.contains(entertainmentOption)) {
  //     entertainment.add(entertainmentOption);
  //   }
  // }

  void addReservation(String reservationOption) {
    if (!reservation.contains(reservationOption)) {
      reservation.add(reservationOption);
    }
  }
}
