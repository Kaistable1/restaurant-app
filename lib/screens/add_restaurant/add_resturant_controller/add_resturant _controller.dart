import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_web_app/main.dart';
import 'package:restaurant_web_app/screens/add_restaurant/edit_restaurant/edit_resturant.dart';
import 'package:restaurant_web_app/universal_models/restaurant_model.dart';
import 'package:restaurant_web_app/widgets/loading_dialog.dart';
import 'package:restaurant_web_app/widgets/no_internet_dialog.dart';

import '../../../../constants/colors.dart';
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

  void saveOperatingHours() async {
    final operatingHoursData = generateOperatingHours();

    // Reference to the current restaurant document
    final restaurantDoc = FirebaseFirestore.instance
        .collection('restaurants')
        .doc(auth.currentUser!.uid);

    // Use Firestore batch for atomic writes
    final batch = FirebaseFirestore.instance.batch();

    operatingHoursData.forEach((day, meals) {
      final dayDoc = restaurantDoc.collection('operatingHours').doc(day);

      // Prepare the data to save for the day
      Map<String, dynamic> mealDetails = {};
      meals.forEach((meal, details) {
        mealDetails[meal] = {
          "startTime":
              details["startTime"] ?? "", // Default empty string if null
          "endTime": details["endTime"] ?? "", // Default empty string if null
          "isClosed": details["isClosed"] ?? false, // Default `false` if null
        };
      });

      // Add the data to the batch
      batch.set(dayDoc, mealDetails);
    });

    // Commit the batch to Firestore
    try {
      await batch.commit();
      print("Operating hours successfully saved as a sub-collection!");
    } catch (e) {
      print("Error saving operating hours: $e");
    }
  }



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
        Get.back();
        Get.snackbar("Success", "Data updated successfully!");
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

  onTapOperatingHours(BuildContext context) {
    List<EntertainmentScheduleModel> entertainmentSchedules = [];

    for (int i = 0; i < eventNames.length; i++) {
      Map<String, dynamic> schedule = {
        "eventName": eventNames[i] ?? '',
        "eventBy": byValues[i] ?? '',
        "day": selectedDays[i] ?? '',
        "date": selectedDates[i] != null
            ? DateFormat('dd MMM, yyyy').format(selectedDates[i]!)
            : '',
        'startTime': selectedTimes[i]["from"]?.format(context) ?? '',
        'endTime': selectedTimes[i]["to"]?.format(context) ?? '',
        'isSelected': checkBoxValues[i] ?? false,
      };

      // Convert Map to EntertainmentScheduleModel
      entertainmentSchedules.add(EntertainmentScheduleModel.fromMap(schedule));
    }

    // Assign the list to restaurantModel
    restaurantModel.entertainmentScheduleList = entertainmentSchedules;

    print(restaurantModel.entertainmentScheduleList);

    Get.to(() => OperatingHourScreen1(
          isFromButtonClick: true,
        ));
  }
///
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
    Get.to(() => FacilitiesScreen(isFromButtonClick: true));
  }

  void saveNextScreenReal() {
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

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///facilities model

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

  // void selectEntertainment(String entertainmentOption) {
  //   selectedEntertainment.value = entertainmentOption;
  // }

  void selectPriceRange(String priceRangeOption) {
    selectedPriceRange.value = priceRangeOption;
  }

  // void selectReservation(String reservationOption) {
  //   selectedReservation.value = reservationOption;
  // }

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

  //////////////////////////////////
  ///EventTableController
  final List<String> eventNames = [
    "Live Music",
  ].obs;

  final List<String> byValues = [
    "Neil Young",
  ].obs;

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
    1,
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

  RxString aboutError = ''.obs;

  void nextSave() {
    bool isValid = true;
    if (aboutTextController.text.isEmpty) {
      aboutError.value = "Enter your Text";
      isValid = false;
    } else {
      // You can add more validation rules here (e.g., minimum length, valid characters)
      if (aboutTextController.text.length < 3) {
        aboutError.value = "Text must be at least 3 characters";
        isValid = false;
      } else {
        aboutError.value = '';
      }

      if (isValid) {
        Get.snackbar("Success", "Data saved successfully!",
            backgroundColor: AppColors.primaryColor,
            colorText: Colors.white,
            maxWidth: 400);
        Get.to(() => EditRestaurantScreen(
              isFromButtonClick: true,
            ));
        aboutTextController.clear();
      }
    }
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
