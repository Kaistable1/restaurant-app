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
  final selectedFilters = <String>[].obs;

  void toggleFilter(String name) {
    if (selectedFilters.contains(name)) {
      selectedFilters.remove(name);
    } else {
      selectedFilters.add(name);
    }
  }

  final discountType = [
    'percentage off',
    'buy one get one (bogo)',
    'limited-time offers',
    'happy hour specials',
  ];
  final selectedDiscounts = <String>[].obs;

  void toggleDiscounts(String name) {
    if (selectedDiscounts.contains(name)) {
      selectedDiscounts.remove(name);
    } else {
      selectedDiscounts.add(name);
    }
  }

  final timeOfDay = [
    'breakfast',
    'brunch',
    'lunch',
    'dinner',
    'late night',
  ];
  final selectedTimeOfDay = <String>[].obs;

  void toggleTimeOfDay(String name) {
    if (selectedTimeOfDay.contains(name)) {
      selectedTimeOfDay.remove(name);
    } else {
      selectedTimeOfDay.add(name);
    }
  }

  final atmosphere = [
    'casual dinning',
    'fine dinning',
    'fast casual',
    'pop',
  ];
  final selectedAtmosphere = <String>[].obs;

  void toggleAtmosphere(String name) {
    if (selectedAtmosphere.contains(name)) {
      selectedAtmosphere.remove(name);
    } else {
      selectedAtmosphere.add(name);
    }
  }

  final facilities = [
    'free  wi-fi',
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
  final selectedFacilities = <String>[].obs;

  void toggleFacilities(String name) {
    if (selectedFacilities.contains(name)) {
      selectedFacilities.remove(name);
    } else {
      selectedFacilities.add(name);
    }
  }

  var aggregatedFilters = <String>[].obs;

  void aggregateSelectedFilters() {
    aggregatedFilters.clear();
    if (selectedCountry.value.isNotEmpty) {
      aggregatedFilters.add(selectedCountry.value);
    }
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
  }

  var isFilterListVisible = false.obs;

  void toggleFilterListVisibility() {
    isFilterListVisible.value = !isFilterListVisible.value;
  }

  RxString selectedCountry = ''.obs;
  RxString selectedCity = ''.obs;
  RxString selectedLanguage = ''.obs;
}
