import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/app_colors.dart';

import '../constants/text_styles.dart';

class AmenitiesSubScreenController extends GetxController {
  // Expanded states for each section
  var isFacilitiesExpanded = false.obs;
  var isDietaryExpanded = false.obs;
  var isAtmosphereExpanded = false.obs;
  var isPriceRangeExpanded = false.obs;

  // Lists for each section
  var facilities = <Map<String, dynamic>>[
    {'name': 'Wi-Fi', 'isChecked': false},
    {'name': 'Parking', 'isChecked': false},
    {'name': 'Air Conditioning', 'isChecked': false},
  ].obs;

  var dietaryPreferences = <Map<String, dynamic>>[
    {'name': 'Vegetarian', 'isChecked': false},
    {'name': 'Vegan', 'isChecked': false},
    {'name': 'Gluten-Free', 'isChecked': false},
  ].obs;

  var atmosphere = <Map<String, dynamic>>[
    {'name': 'Casual', 'isChecked': false},
    {'name': 'Formal', 'isChecked': false},
    {'name': 'Family-Friendly', 'isChecked': false},
  ].obs;

  var priceRange = <Map<String, dynamic>>[
    {'name': '\$ (Budget)', 'isChecked': false},
    {'name': '\$\$ (Moderate)', 'isChecked': false},
    {'name': '\$\$\$ (Luxury)', 'isChecked': false},
  ].obs;

  // Toggle expanded states
  void toggleFacilitiesExpanded() => isFacilitiesExpanded.value = !isFacilitiesExpanded.value;
  void toggleDietaryExpanded() => isDietaryExpanded.value = !isDietaryExpanded.value;
  void toggleAtmosphereExpanded() => isAtmosphereExpanded.value = !isAtmosphereExpanded.value;
  void togglePriceRangeExpanded() => isPriceRangeExpanded.value = !isPriceRangeExpanded.value;

  // Toggle checkbox states
  void toggleFacilitiesCheckbox(int index) {
    facilities[index]['isChecked'] = !facilities[index]['isChecked'];
    facilities.refresh();
  }

  void toggleDietaryCheckbox(int index) {
    dietaryPreferences[index]['isChecked'] = !dietaryPreferences[index]['isChecked'];
    dietaryPreferences.refresh();
  }

  void toggleAtmosphereCheckbox(int index) {
    atmosphere[index]['isChecked'] = !atmosphere[index]['isChecked'];
    atmosphere.refresh();
  }

  void togglePriceRangeCheckbox(int index) {
    priceRange[index]['isChecked'] = !priceRange[index]['isChecked'];
    priceRange.refresh();
  }

  // Add new items with dialogs
  Future<void> addFacilities() async {
    final result = await _showAddDialog('Add Facility/Service');
    if (result != null) {
      facilities.add({'name': result, 'isChecked': false});
      facilities.refresh();
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
            hintText: 'Enter $title (e.g., ${title.split(' ').last == 'Range' ? '\$\$' : 'Keto'})',
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
    bool dietaryValid = dietaryPreferences.any((item) => item['isChecked'] == true);
    bool atmosphereValid = atmosphere.any((item) => item['isChecked'] == true);
    bool priceRangeValid = priceRange.any((item) => item['isChecked'] == true);

    return {
      'facilities': facilitiesValid,
      'dietary': dietaryValid,
      'atmosphere': atmosphereValid,
      'priceRange': priceRangeValid,
    };
  }
}
