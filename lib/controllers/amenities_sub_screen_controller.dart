import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/app_colors.dart';
import 'package:savrly/controllers/add_restaurants_controller.dart';
import 'package:savrly/widgets/global_functions.dart';

import '../constants/text_styles.dart';

class AmenitiesSubScreenController extends GetxController {
  // Expanded states for each section
  var isFacilitiesExpanded = false.obs;
  var isDietaryExpanded = false.obs;
  var isAtmosphereExpanded = false.obs;
  var isPriceRangeExpanded = false.obs;
  var isVibesExpanded = false.obs;

  // Lists for each section
  var facilities = <Map<String, dynamic>>[
    {'name': 'Free wi-fi', 'isChecked': false},
    {'name': 'Private dinning', 'isChecked': false},
    {'name': 'Parking', 'isChecked': false},
    {'name': 'Takeout', 'isChecked': false},
    {'name': 'Drive-thru', 'isChecked': false},
    {'name': 'Outdoor seating', 'isChecked': false},
    {'name': 'Kid-Friendly', 'isChecked': false},
    {'name': 'Pet-Friendly', 'isChecked': false},
    {'name': 'Rest room', 'isChecked': false},
    {'name': 'Wheelchair accessibility', 'isChecked': false},
    {'name': 'High chairs', 'isChecked': false},
  ].obs;

  var dietaryPreferences = <Map<String, dynamic>>[
    {'name': 'Vegan & Plant-Based', 'isChecked': false},
    {'name': 'Vegetarian', 'isChecked': false},
    {'name': 'Vegan', 'isChecked': false},
    {'name': 'Gluten-Free', 'isChecked': false},
    {'name': 'Pescatarian', 'isChecked': false},
    {'name': 'Flexitarian', 'isChecked': false},
    {'name': 'Raw Food', 'isChecked': false},
    {'name': 'Keto', 'isChecked': false},
    {'name': 'Paleo', 'isChecked': false},
  ].obs;

  var atmosphere = <Map<String, dynamic>>[
    {'name': 'Casual Dining', 'isChecked': false},
    {'name': 'Fine Dining', 'isChecked': false},
    {'name': 'Fast Food', 'isChecked': false},
    {'name': 'Date Night', 'isChecked': false},
    {'name': 'Candlelit', 'isChecked': false},
    {'name': 'Outdoor', 'isChecked': false},
    {'name': 'Rooftop', 'isChecked': false},
    {'name': 'Ocean View', 'isChecked': false},
  ].obs;

  var vibes = <Map<String, dynamic>>[
    {'name': 'Lively', 'isChecked': false},
    {'name': 'Chill', 'isChecked': false},
    {'name': 'Flirty', 'isChecked': false},
    {'name': 'Bougie', 'isChecked': false},
    {'name': 'Low key', 'isChecked': false},
    {'name': 'Turn Up', 'isChecked': false},
    {'name': 'Take Out', 'isChecked': false},
    {'name': 'Happy Hours', 'isChecked': false},
    {'name': 'Open Bar', 'isChecked': false},
  ].obs;

  var priceRange = <Map<String, dynamic>>[
    {'name': '\$ (Budget-Friendly)', 'isChecked': false},
    {'name': '\$\$ (Moderate)', 'isChecked': false},
    {'name': '\$\$\$ (Premium)', 'isChecked': false},
    {'name': '\$\$\$\$ (Luxury)', 'isChecked': false},
  ].obs;

  // Toggle expanded states
  void toggleFacilitiesExpanded() =>
      isFacilitiesExpanded.value = !isFacilitiesExpanded.value;
  void toggleDietaryExpanded() =>
      isDietaryExpanded.value = !isDietaryExpanded.value;
  void toggleAtmosphereExpanded() =>
      isAtmosphereExpanded.value = !isAtmosphereExpanded.value;

  void toggleVibesExpanded() => isVibesExpanded.value = !isVibesExpanded.value;

  void togglePriceRangeExpanded() =>
      isPriceRangeExpanded.value = !isPriceRangeExpanded.value;

  // Toggle checkbox states
  void toggleFacilitiesCheckbox(int index) {
    facilities[index]['isChecked'] = !facilities[index]['isChecked'];
    facilities.refresh();
  }

  void toggleDietaryCheckbox(int index) {
    dietaryPreferences[index]['isChecked'] =
        !dietaryPreferences[index]['isChecked'];
    dietaryPreferences.refresh();
  }

  void toggleAtmosphereCheckbox(int index) {
    atmosphere[index]['isChecked'] = !atmosphere[index]['isChecked'];
    atmosphere.refresh();
  }

  void toggleVibesCheckbox(int index) {
    vibes[index]['isChecked'] = !vibes[index]['isChecked'];
    vibes.refresh();
  }

  void togglePriceRangeCheckbox(int index) {
    for (int i = 0; i < priceRange.length; i++) {
      priceRange[i]['isChecked'] = i == index;
    }
    priceRange.refresh();
  }

  Future<void> addFacilities() async {
    // Example: Add a new facility (could be from user input via dialog)
    String newFacility = await _showAddFacilityDialog(); // Hypothetical method
    if (newFacility.isNotEmpty) {
      facilities.add({'name': newFacility, 'isChecked': false});
    }
  }

  Future<void> addDietaryPreference() async {
    final result = await _showAddDialog('Add Dietary Preference');
    if (result != null) {
      dietaryPreferences.add({'name': result, 'isChecked': false});
      dietaryPreferences.refresh();
    }
  }

  Future<void> addAtmosphere() async {
    final result = await _showAddDialog('Add Atmosphere');
    if (result != null) {
      atmosphere.add({'name': result, 'isChecked': false});
      atmosphere.refresh();
    }
  }

  Future<void> addVibes() async {
    final result = await _showAddDialog('Add Vibes');
    if (result != null) {
      vibes.add({'name': result, 'isChecked': false});
      vibes.refresh();
    }
  }

  Future<void> addPriceRange() async {
    final result = await _showAddDialog('Add Price Range');
    if (result != null) {
      priceRange.add({'name': result, 'isChecked': false});
      priceRange.refresh();
    }
  }

  // Helper method for showing dialog
  Future<String?> _showAddDialog(String title) async {
    final TextEditingController textController = TextEditingController();
    return await Get.dialog<String>(
      AlertDialog(
        title: Text(
          title,
          style: headingText.copyWith(fontSize: 20),
        ),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText:
                'Enter $title (e.g., ${title.split(' ').last == 'Range' ? '\$\$' : 'Keto'})',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: simpleText.copyWith(color: redColor)),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                Get.back(result: textController.text.trim());
              }
            },
            child: Text('Add', style: simpleText.copyWith(color: primaryColor)),
          ),
        ],
      ),
    );
  }

  // Check if at least one item is selected in each section
  Map<String, bool> areAmenitiesValid() {
    bool facilitiesValid = facilities.any((item) => item['isChecked'] == true);
    bool dietaryValid =
        dietaryPreferences.any((item) => item['isChecked'] == true);
    bool atmosphereValid = atmosphere.any((item) => item['isChecked'] == true);
    bool priceRangeValid = priceRange.any((item) => item['isChecked'] == true);
    bool vibesValid = vibes.any((item) => item['isChecked'] == true);

    return {
      'facilities': facilitiesValid,
      'dietary': dietaryValid,
      'atmosphere': atmosphereValid,
      'priceRange': priceRangeValid,
      'vibes': vibesValid
    };
  }

  // Clear all fields
  void clearFields() {
    for (var item in facilities) {
      item['isChecked'] = false;
    }
    for (var item in dietaryPreferences) {
      item['isChecked'] = false;
    }
    for (var item in atmosphere) {
      item['isChecked'] = false;
    }
    for (var item in priceRange) {
      item['isChecked'] = false;
    }

    for (var item in vibes) {
      item['isChecked'] = false;
    }

    facilities.refresh();
    dietaryPreferences.refresh();
    atmosphere.refresh();
    priceRange.refresh();
    vibes.refresh();
  }

  List<String> getSelectedDietaryPreferences() {
    return dietaryPreferences
        .where((item) => item['isChecked'] == true)
        .map((item) => item['name'] as String)
        .toList();
  }

  // Helper to get selected facilities
  List<String> getSelectedFacilities() {
    return facilities
        .where((item) => item['isChecked'] == true)
        .map((item) => item['name'] as String)
        .toList();
  }

  List<String> getSelectedAtmosphere() {
    return atmosphere
        .where((item) => item['isChecked'] == true)
        .map((item) => item['name'] as String)
        .toList();
  }

  List<String> getSelectedVibes() {
    return vibes
        .where((item) => item['isChecked'] == true)
        .map((item) => item['name'] as String)
        .toList();
  }

  List<String> getSelectedPriceRange() {
    return priceRange
        .where((item) => item['isChecked'] == true)
        .map((item) => item['name'] as String)
        .toList();
  }

  // Placeholder for adding a new facility (implement as needed)
  Future<String> _showAddFacilityDialog() async {
    // Add your dialog logic here to get user input
    return 'New Facility'; // Example return
  }

  //backend

  addAmenities() async {
    try {
      loadingDialog();

      final addRestaurantTabController = Get.find<AddRestaurantTabController>();
      final restaurantID = addRestaurantTabController.restaurantModel!.docID;

      print('restaurantID ${restaurantID}');
      if (restaurantID.isEmpty) {
        throw Exception("Restaurant ID is missing");
      }
      print(' setp 1');
      // 👇 Step 1: Get selected lists separately
      final atmosphereList = getSelectedAtmosphere();
      final vibesList = getSelectedVibes();
      final dietaryList = getSelectedDietaryPreferences();
      final facilityList = getSelectedFacilities();
      final priceRange = getSelectedPriceRange();
      print(' setp 2');

      // 👇 Step 2: Prepare the data map
      final restaurantData = {
        'vibesList': vibesList,
        'atmopshereList': atmosphereList,
        'dietaryList': dietaryList,
        'facilityList': facilityList,
        'priceRange': priceRange.isEmpty ? '' : priceRange.first,
      };
      print(' setp 3');

      // 👇 Step 3: Update Firestore
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantID)
          .update(restaurantData);
      print(' setp 4');

      // 👇 Step 4: UI updates
      Get.back();
      clearFields();
      addRestaurantTabController.selectedIndex.value++;

      Get.snackbar(
        'Success',
        'Amenities added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back();
      print('error $e');
      Get.snackbar('Error', 'Failed to add amenities: $e');
      print('❌ Error adding amenities: $e');
    }
  }
}
