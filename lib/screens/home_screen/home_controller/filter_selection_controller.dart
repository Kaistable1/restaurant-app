import 'package:get/get.dart';

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
    selectedCountry.value = ''; // Clear selected country
    selectedCity.value = ''; // Clear selected city
    selectedLanguage.value = ''; // Clear selected language

    selectedFilters.clear(); // Clear selected filters
    selectedDiscounts.clear(); // Clear selected discounts
    selectedAtmosphere.clear(); // Clear selected atmosphere
    selectedFacilities.clear(); // Clear selected facilities
    selectedEntertainment.clear(); // Clear selected entertainment
    selectedDietary.clear(); // Clear selected dietary preferences
    selectedPriceRange.clear(); // Clear selected price range
    selectedTimeOfDay.clear(); // Clear selected time of day
  }

  void toggleFilter(String name) {
    if (selectedFilters.contains(name)) {
      selectedFilters.remove(name);
    } else {
      selectedFilters.add(name);
    }
  }

  final discountType = ['percentage off', 'happy hour specials'];

  void toggleDiscounts(String name) {
    if (selectedDiscounts.contains(name)) {
      selectedDiscounts.remove(name);
    } else {
      selectedDiscounts.add(name);
    }
  }

  final timeOfDay = ['Breakfast', 'Brunch', 'Lunch', 'Dinner', 'Late Night'];

  void toggleTimeOfDay(String name) {
    if (selectedTimeOfDay.contains(name)) {
      selectedTimeOfDay.remove(name);
    } else {
      selectedTimeOfDay.add(name);
    }
  }

  final atmosphere = ['casual dining', 'fine dining', 'fast casual', 'pop'];

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
  }

  var isFilterListVisible = false.obs;

  void toggleFilterListVisibility() {
    isFilterListVisible.value = !isFilterListVisible.value;
  }
}
