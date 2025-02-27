import 'package:get/get.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/filter_selection_controller.dart';

class FilterController extends GetxController {
  final filterSelectionController = Get.put(FilterSelectionController());

  @override
  void onInit() {
    super.onInit();
    filterSelectionController.selectedCity.value = 'New York';
    filterSelectionController.selectedCountry.value = 'USA';
    filterSelectionController.selectedLanguage.value = 'English';
  }

  // Single Selection Variables
  var selectedCountry = "USA".obs;
  var selectedCity = "New York".obs;
  var selectedLanguage = "English".obs;

  List<String> countries = ["USA", "France"];
  List<String> cities = [
    "New York",
    "Los Angeles",
    "Paris",
  ];
  List<String> languages = [
    "English",
    "French",
    "Spanish",
  ];

  void selectCountry(String country) {
    filterSelectionController.selectedCountry.value = country;
    selectedCountry.value = country;
  }

  void selectCity(String city) {
    filterSelectionController.selectedCity.value = city;
    selectedCity.value = city;
  }

  void selectLanguage(String language) {
    filterSelectionController.selectedLanguage.value = language;
    selectedLanguage.value = language;
  }

  // Multi-Selection Lists with Checkboxes
  var selectedFilters = <String, RxList<String>>{}.obs;
  var filterOptions = <String, List<String>>{
    "Cuisines": [
      'italian',
      'mexican',
      'asian',
      'vegetarian',
      'vegan',
      'american',
    ],
    "Discount Type": [
      'percentage off',
      'happy hour specials',
    ],
    "Time of Day": [
      'Breakfast',
      'Brunch',
      'Lunch',
      'Dinner',
      'Late Night',
    ],
    "Atmospheres": [
      'casual dining',
      'fine dining',
      'fast casual',
      'pop',
    ],
    "Facilities": [
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
    ],
    "Dietary Preferences": [
      'vegetarian',
      'vegan',
      'gluten-free',
      'dairy-free',
      'keto-friendly',
    ],
    "Entertainment": [
      'live music',
      'dj nights',
      'karaoke',
      'trivia nights',
      'sports screenings',
      'hookah',
    ],
    "Price Range": [
      '\$(Budget-Friendly)',
      '\$\$(Moderate)',
      '\$\$\$(Premium)',
      '\$\$\$\$(Luxury)',
    ],
  }.obs;

  // Initialize selected filters
  FilterController() {
    for (var key in filterOptions.keys) {
      selectedFilters[key] = <String>[].obs;
    }
  }

  void toggleFilter(String category, String option) {
    if (selectedFilters[category]!.contains(option)) {
      selectedFilters[category]!.remove(option);
    } else {
      selectedFilters[category]!.add(option);
    }
    if (category == 'Cuisines') {
      filterSelectionController.selectedFilters.value =
          selectedFilters.values.expand((rxList) => rxList.toList()).toList();
    } else if (category == 'Discount Type') {
      filterSelectionController.selectedDiscounts.value =
          selectedFilters.values.expand((rxList) => rxList.toList()).toList();
    } else if (category == 'Time of Day') {
      filterSelectionController.selectedTimeOfDay.value =
          selectedFilters.values.expand((rxList) => rxList.toList()).toList();
    } else if (category == 'Atmospheres') {
      filterSelectionController.selectedAtmosphere.value =
          selectedFilters.values.expand((rxList) => rxList.toList()).toList();
    } else if (category == 'Facilities') {
      filterSelectionController.selectedFacilities.value =
          selectedFilters.values.expand((rxList) => rxList.toList()).toList();
    } else if (category == 'Dietary Preferences') {
      filterSelectionController.selectedDietary.value =
          selectedFilters.values.expand((rxList) => rxList.toList()).toList();
    } else if (category == 'Entertainment') {
      filterSelectionController.selectedEntertainment.value =
          selectedFilters.values.expand((rxList) => rxList.toList()).toList();
    } else if (category == 'Price Range') {
      filterSelectionController.selectedPriceRange.value =
          selectedFilters.values.expand((rxList) => rxList.toList()).toList();
    }
    filterSelectionController.update();
    update(); // Ensure UI rebuilds
  }

  int getSelectedCount(String category) =>
      selectedFilters[category]?.length ?? 0;
  int getTotalSelected() {
    return selectedFilters.values.fold(0, (sum, list) => sum + list.length);
  }

  void clearAll() {
    filterSelectionController.aggregatedFilters.clear();
    selectedFilters.forEach((key, value) => value.clear());
    update();
    Get.back();
  }
}
