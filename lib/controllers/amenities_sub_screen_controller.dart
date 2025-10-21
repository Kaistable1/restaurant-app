import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/app_colors.dart';
import 'package:restaurant_web_app/constants/text_styles.dart';
import 'package:restaurant_web_app/controllers/add_restaurants_controller.dart';
import 'package:restaurant_web_app/widgets/loading_dialog.dart';

class AmenitiesSubScreenController extends GetxController {
  // Expanded states for each section
  var isFacilitiesExpanded = false.obs;
  var isDietaryExpanded = false.obs;
  var isAtmosphereExpanded = false.obs;
  var isPriceRangeExpanded = false.obs;
  var isVibesExpanded = false.obs;
  var isExperiencesExpanded = false.obs;
  var isEntertainmentExpanded = false.obs;

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
    {'name': 'Date Night', 'isChecked': false},
    {'name': 'Hidden Gems', 'isChecked': false},
    {'name': 'Trendy & Social', 'isChecked': false},
    {'name': 'High Vibe', 'isChecked': false},
    {'name': 'Chill & Cozy', 'isChecked': false},
  ].obs;

  var experiences = <Map<String, dynamic>>[
    {'name': 'Brunch', 'isChecked': false},
    {'name': 'Outdoor', 'isChecked': false},
    {'name': 'Happy Hour', 'isChecked': false},
    {'name': 'Rooftop', 'isChecked': false},
    {'name': 'Water/Beachside', 'isChecked': false},
    {'name': 'Late Night', 'isChecked': false},
    {'name': 'Show', 'isChecked': false},
  ].obs;

  var entertainment = <Map<String, dynamic>>[
    {'name': 'Live Music', 'isChecked': false},
    {'name': 'DJ Nights', 'isChecked': false},
    {'name': 'Comedy', 'isChecked': false},
    {'name': 'Karaoke', 'isChecked': false},
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

  void toggleExperiencesExpanded() =>
      isExperiencesExpanded.value = !isExperiencesExpanded.value;

  void toggleEntertainmentExpanded() =>
      isEntertainmentExpanded.value = !isEntertainmentExpanded.value;

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

  void toggleExperiencesCheckbox(int index) {
    experiences[index]['isChecked'] = !experiences[index]['isChecked'];
    experiences.refresh();
  }

  void toggleEntertainmentCheckbox(int index) {
    entertainment[index]['isChecked'] = !entertainment[index]['isChecked'];
    entertainment.refresh();
  }

  void togglePriceRangeCheckbox(int index) {
    for (int i = 0; i < priceRange.length; i++) {
      priceRange[i]['isChecked'] = i == index;
    }
    priceRange.refresh();
  }

  Future<void> addFacilities() async {
    final result = await _showAddDialog('Add Facility');
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

  Future<void> addVibes() async {
    final result = await _showAddDialog('Add Vibes');
    if (result != null) {
      vibes.add({'name': result, 'isChecked': false});
      vibes.refresh();
    }
  }

  Future<void> addExperiences() async {
    final result = await _showAddDialog('Add Experiences');
    if (result != null) {
      experiences.add({'name': result, 'isChecked': false});
      experiences.refresh();
    }
  }

  Future<void> addEntertainment() async {
    final result = await _showAddDialog('Add Entertainment');
    if (result != null) {
      entertainment.add({'name': result, 'isChecked': false});
      entertainment.refresh();
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
    bool experiencesValid =
        experiences.any((item) => item['isChecked'] == true);
    bool entertainmentValid =
        entertainment.any((item) => item['isChecked'] == true);

    return {
      'facilities': facilitiesValid,
      'dietary': dietaryValid,
      'atmosphere': atmosphereValid,
      'priceRange': priceRangeValid,
      'vibes': vibesValid,
      'experiences': experiencesValid,
      'entertainment': entertainmentValid,
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
    for (var item in experiences) {
      item['isChecked'] = false;
    }
    for (var item in entertainment) {
      item['isChecked'] = false;
    }

    facilities.refresh();
    dietaryPreferences.refresh();
    atmosphere.refresh();
    priceRange.refresh();
    vibes.refresh();
    experiences.refresh();
    entertainment.refresh();
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

  List<String> getSelectedExperiences() {
    return experiences
        .where((item) => item['isChecked'] == true)
        .map((item) => item['name'] as String)
        .toList();
  }

  List<String> getSelectedEntertainment() {
    return entertainment
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

  //backend

  addAmenities() async {
    try {
      loadingDialog(loading: true, message: 'Adding amenities...');

      final addRestaurantTabController = Get.find<AddRestaurantTabController>();
      final restaurantID = addRestaurantTabController.currentRestaurantID;

      print('restaurantID $restaurantID');
      if (restaurantID.isEmpty) {
        throw Exception("Restaurant ID is missing");
      }
      print(' setp 1');
      // 👇 Step 1: Get selected lists separately
      final atmosphereList = getSelectedAtmosphere();
      final vibesList = getSelectedVibes();
      final experiencesList = getSelectedExperiences();
      final entertainmentList = getSelectedEntertainment();
      final dietaryList = getSelectedDietaryPreferences();
      final facilityList = getSelectedFacilities();
      final priceRangeList = getSelectedPriceRange();
      print(' setp 2');

      // 👇 Step 2: Prepare the data map
      final restaurantData = {
        'vibesList': vibesList,
        'experiencesList': experiencesList,
        'entertainmentList': entertainmentList,
        'atmopshereList': atmosphereList,
        'dietaryList': dietaryList,
        'facilityList': facilityList,
        'priceRange': priceRangeList.isEmpty ? '' : priceRangeList.first,
      };
      print(' setp 3');

      // 👇 Step 3: Update Firestore
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantID)
          .update(restaurantData);
      print(' setp 4');

      // 👇 Step 4: Update local restaurant model with new data
      if (addRestaurantTabController.restaurantModel != null) {
        addRestaurantTabController.restaurantModel!.facilityList = facilityList;
        addRestaurantTabController.restaurantModel!.dietaryList = dietaryList;
        addRestaurantTabController.restaurantModel!.atmosphereList =
            atmosphereList;
        addRestaurantTabController.restaurantModel!.vibesList = vibesList;
        addRestaurantTabController.restaurantModel!.experiencesList =
            experiencesList;
        addRestaurantTabController.restaurantModel!.entertainmentList =
            entertainmentList;
        addRestaurantTabController.restaurantModel!.priceRange =
            priceRangeList.isEmpty ? '' : priceRangeList.first;
      }

      // 👇 Step 5: UI updates
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
