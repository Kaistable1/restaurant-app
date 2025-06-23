import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaistable_website/models/resaturant_model.dart';

class FilterSelectionController extends GetxController {
  // List of filter names
  final filterNames = [
    'italian',
    'mexican',
    'asian',
    'vegetarian',
    'vegan',
    'american',
  ];
  RxString selectedCountry = ''.obs;
  RxString selectedCity = ''.obs;
  RxString selectedLanguage = ''.obs;

  final selectedFilters = <String>[].obs;
  final selectedDiscounts = <String>[].obs;
  final selectedAtmosphere = <String>[].obs;
  final selectedFacilities = <String>[].obs;
  final selectedEntertainment = <String>[].obs;
  final selectedDietary = <String>[].obs;
  final selectedPriceRange = <String>[].obs;
  final selectedTimeOfDay = <String>[].obs;
  final selectedTrending = <String>[].obs;

  void clearAll() {
    selectedCountry.value = '';
    selectedCity.value = '';
    selectedLanguage.value = '';

    selectedFilters.clear();
    selectedDiscounts.clear();
    selectedAtmosphere.clear();
    selectedFacilities.clear();
    selectedEntertainment.clear();
    selectedDietary.clear();
    selectedPriceRange.clear();
    selectedTimeOfDay.clear();

    aggregatedFilters.clear(); // 🛑 Clear master list

    // 🟢 Re-aggregate from now empty filters
    aggregateSelectedFilters();

    update();
    Get.back(); // Update GetX listeners/UI
  }

  void toggleFilter(String name) {
    if (selectedFilters.contains(name)) {
      selectedFilters.remove(name);
    } else {
      selectedFilters.add(name);
    }
  }

  final discountType = [
    'percentage off',
    'happy hour specials',
  ];

  void toggleDiscounts(String name) {
    if (selectedDiscounts.contains(name)) {
      selectedDiscounts.remove(name);
    } else {
      selectedDiscounts.add(name);
    }
  }

  final timeOfDay = [
    'Breakfast',
    'Brunch',
    'Lunch',
    'Dinner',
    'Late Night',
  ];

  void toggleTimeOfDay(String name) {
    if (selectedTimeOfDay.contains(name)) {
      selectedTimeOfDay.remove(name);
    } else {
      selectedTimeOfDay.add(name);
    }
  }

  final atmosphere = [
    'casual dining',
    'fine dining',
    'fast casual',
    'pop',
  ];

  void toggleAtmosphere(String name) {
    if (selectedAtmosphere.contains(name)) {
      selectedAtmosphere.remove(name);
    } else {
      selectedAtmosphere.add(name);
    }
  }

  final facilities = [
    'free wi-fi',
    'private dinning',
    'parking',
    'takeout',
    'drive-thru',
    'outdoor seating',
    'kid-Friendly',
    'pet-Friendly',
    'rest room',
    'wheelchair accessibility',
    'high chairs',
  ];

  void toggleFacilities(String name) {
    if (selectedFacilities.contains(name)) {
      selectedFacilities.remove(name);
    } else {
      selectedFacilities.add(name);
    }
  }

  final entertainment = [
    'live music',
    'dj nights',
    'karaoke',
    'trivia nights',
    'sports screenings',
    'hookah',
  ];

  void toggleEntertainment(String name) {
    if (selectedEntertainment.contains(name)) {
      selectedEntertainment.remove(name);
    } else {
      selectedEntertainment.add(name);
    }
  }

  final dietaryPreferences = [
    'vegetarian',
    'vegan',
    'gluten-free',
    'dairy-free',
    'keto-friendly',
  ];

  void toggleDietary(String name) {
    if (selectedDietary.contains(name)) {
      selectedDietary.remove(name);
    } else {
      selectedDietary.add(name);
    }
  }

  final priceRange = [
    '\$(Budget-Friendly)',
    '\$\$(Moderate)',
    '\$\$\$(Premium)',
    '\$\$\$\$(Luxury)',
  ];

  void togglePriceRange(String name) {
    if (selectedPriceRange.contains(name)) {
      selectedPriceRange.remove(name);
    } else {
      selectedPriceRange.add(name);
    }
  }

  ///-----------------------------------------------------///
  ///
  ///
  ///

  var aggregatedFilters = <String>[].obs;

  void aggregateSelectedFilters() {
    aggregatedFilters.clear();
    if (selectedCity.value.isNotEmpty) {
      aggregatedFilters.add(selectedCity.value);
    }
    if (selectedLanguage.value.isNotEmpty) {
      aggregatedFilters.add(selectedLanguage.value);
    }
    aggregatedFilters.addAll(selectedFilters);
    aggregatedFilters.addAll(selectedDiscounts);
    aggregatedFilters.addAll(selectedTimeOfDay);
    aggregatedFilters.addAll(selectedAtmosphere);
    aggregatedFilters.addAll(selectedFacilities);
    aggregatedFilters.addAll(selectedDietary);
    aggregatedFilters.addAll(selectedEntertainment);
    aggregatedFilters.addAll(selectedPriceRange);

    print("🎯 Selected Filters: $aggregatedFilters");
  }

  var isFilterListVisible = false.obs;

  void toggleFilterListVisibility() {
    isFilterListVisible.value = !isFilterListVisible.value;
  }

// Inside FilterSelectionController class:

  var filteredRestaurantsFuture = Future.value(<RestaurantModel>[]).obs;

  Future<void> updateFilteredRestaurants(
      List<RestaurantModel> allRestaurants) async {
    print("⚙️ Step 1: Total Restaurants = ${allRestaurants.length}");

    List<RestaurantModel> initialFiltered = filterByAllCriteria(allRestaurants);
    print("🔎 Step 2: After Criteria Filter = ${initialFiltered.length}");

    if (selectedTimeOfDay.isNotEmpty) {
      final result = await _getFilteredRestaurants(initialFiltered);
      print("⏰ Step 3: After Time Filter = ${result.length}");
      filteredRestaurantsFuture.value = Future(() async => result);
    } else {
      print("✅ Step 3: No Time Filter Applied");
      filteredRestaurantsFuture.value = Future(() async => initialFiltered);
    }

    update(); // ensure UI refresh
  }

  List<RestaurantModel> filterByAllCriteria(List<RestaurantModel> restaurants) {
    print("⚙️ Step 1: Total Restaurants = ${restaurants.length}");
    final filters = aggregatedFilters.map((e) => e.toLowerCase()).toList();

    List<RestaurantModel> result = restaurants.where((r) {
      bool matches = false;

      if (selectedCity.isNotEmpty && filters.contains(r.city.toLowerCase())) {
        matches = true;
      }

      if (!matches &&
          selectedAtmosphere.isNotEmpty &&
          r.atmosphereList.any((a) => filters.contains(a.toLowerCase()))) {
        matches = true;
      }

      if (!matches &&
          selectedFacilities.isNotEmpty &&
          r.facilityList.any((f) => filters.contains(f.toLowerCase()))) {
        matches = true;
      }

      if (!matches &&
          selectedFilters.isNotEmpty &&
          r.menuList
              .any((m) => filters.contains(m.cuisineType.toLowerCase()))) {
        matches = true;
      }

      if (!matches &&
          selectedEntertainment.isNotEmpty &&
          r.entertainmentScheduleList
              .any((e) => filters.contains(e.eventName.toLowerCase()))) {
        matches = true;
      }

      if (!matches &&
          selectedDietary.isNotEmpty &&
          r.dietaryList.any((d) => filters.contains(d.toLowerCase()))) {
        matches = true;
      }

      if (!matches &&
          selectedPriceRange.isNotEmpty &&
          filters.contains(r.priceRange.toLowerCase())) {
        matches = true;
      }

      return matches;
    }).toList();

    print("🔎 Step 2: After Criteria Filter = ${result.length}");
    return result;
  }

  Future<Map<String, dynamic>?> getOperatingHours(String restaurantId) async {
    try {
      String currentDay = DateFormat('EEEE').format(DateTime.now());
      // Reference to the operatinghour subcollection of the restaurant
      var operatingHoursDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .collection('operatingHours')
          .doc(currentDay) // Assuming weekdays document
          .get();

      if (operatingHoursDoc.exists) {
        return operatingHoursDoc.data();
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching operating hours: $e');
      return null;
    }
  }

//....................

  Future<List<RestaurantModel>> _getFilteredRestaurants(
      List<RestaurantModel> restaurants) async {
    List<RestaurantModel> filteredRestaurants = [];
    List<String> timeOfDayList = aggregatedFilters;

    for (var restaurant in restaurants) {
      // Fetch operating hours for the restaurant
      var operatingHours = await getOperatingHours(restaurant.docID);

      if (operatingHours != null) {
        // Loop through the selected timeOfDay values from the user's filter
        for (var timeOfDay in timeOfDayList) {
          if (operatingHours.containsKey(timeOfDay)) {
            var timeSlot = operatingHours[timeOfDay];
            // Check if the restaurant is open for the selected time (i.e., 'isClosed' is false or null)
            var isClosed = timeSlot['isClosed'];

            // If 'isClosed' is false or null, add the restaurant to the filtered list
            if (isClosed == null || !isClosed) {
              filteredRestaurants.add(
                  restaurant); // Add restaurant if the selected time is open
              break; // Stop checking other times once a valid time is found for the restaurant
            }
          }
        }
      }
    }
    return filteredRestaurants;
  }
}



//........OLD CODE------------------.............





// List<RestaurantModel> filterByAllCriteria(List<RestaurantModel> restaurants) {

//     print("⚙️ Step 1: Total Restaurants = ${restaurants.length}");
//   final filters = aggregatedFilters.map((e) => e.toLowerCase()).toList();
//   List<RestaurantModel> result = restaurants;

//   if (selectedCity.isNotEmpty) {
//     result = result.where((r) => filters.contains(r.city.toLowerCase())).toList();
//   }
//   if (selectedAtmosphere.isNotEmpty) {
//     result = result.where((r) => r.atmosphereList.any((a) => filters.contains(a.toLowerCase()))).toList();
//   }
//   if (selectedFacilities.isNotEmpty) {
//     result = result.where((r) => r.facilityList.any((f) => filters.contains(f.toLowerCase()))).toList();
//   }
//   if (selectedFilters.isNotEmpty) {
//     result = result.where((r) => r.menuList.any((m) => filters.contains(m.cuisineType.toLowerCase()))).toList();
//   }
//   if (selectedEntertainment.isNotEmpty) {
//     result = result.where((r) => r.entertainmentScheduleList.any((e) => filters.contains(e.eventName.toLowerCase()))).toList();
//   }
//   if (selectedDietary.isNotEmpty) {
//     result = result.where((r) => r.dietaryList.any((d) => filters.contains(d.toLowerCase()))).toList();
//   }
//   if (selectedPriceRange.isNotEmpty) {
//     result = result.where((r) => filters.contains(r.priceRange.toLowerCase())).toList();
//   }

//   print("🔎 Step 2: After Criteria Filter = ${result.length}");
//   return result;

// }