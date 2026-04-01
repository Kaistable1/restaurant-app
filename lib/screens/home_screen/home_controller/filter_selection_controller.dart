import 'package:get/get.dart';
import 'package:kaistable_website/models/restaurant_model.dart';

class FilterSelectionController extends GetxController {
  final filterNames = [
    'italian',
    'mexican',
    'asian',
    'vegetarian',
    'vegan',
    'american',
    'Soul food',
    'Southern food',
    'Cajun & Creole',
    'Barbecue',
    'Diner / Comfort Food',
    'Jamaican',
    'Fusion',
  ];
  RxString selectedCountry = ''.obs;
  RxString selectedCity = ''.obs;
  RxString selectedLanguage = ''.obs;
  var selectedDistance = ''.obs;
  var allRestaurants = <RestaurantModel>[].obs;
  var filteredRestaurants = <RestaurantModel>[].obs;

  final selectedFilters = <String>[].obs;
  final selectedDiscounts = <String>[].obs;
  final selectedAtmosphere = <String>[].obs;
  final selectedFacilities = <String>[].obs;
  final selectedEntertainment = <String>[].obs;
  final selectedExperience = <String>[].obs;
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
    selectedExperience.clear();
    selectedDietary.clear();
    selectedPriceRange.clear();
    selectedTrending.clear();
    aggregatedFilters.clear();
    update();
  }

  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
    aggregateSelectedFilters();
    update();
  }

  double getDistanceValue(String label) {
    switch (label) {
      case '1 km':
        return 1.0;
      case '3 km':
        return 3.0;
      case '5 km':
        return 5.0;
      case '10 km':
        return 10.0;
      default:
        return double.infinity;
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
    aggregateSelectedFilters();
    update();
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
    aggregateSelectedFilters();
    update();
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
    aggregateSelectedFilters();
    update();
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
    aggregateSelectedFilters();
    update();
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
    aggregateSelectedFilters();
    update();
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
    aggregateSelectedFilters();
    update();
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
    aggregateSelectedFilters();
    update();
  }

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
    aggregatedFilters.addAll(selectedEntertainment);
    aggregatedFilters.addAll(selectedDietary);
    aggregatedFilters.addAll(selectedPriceRange);
    update();
  }

  var isFilterListVisible = false.obs;

  void toggleFilterListVisibility() {
    isFilterListVisible.value = !isFilterListVisible.value;
    update();
  }
}
