import 'package:get/get.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/filter_selection_controller.dart';

class FilterController extends GetxController {
  final filterSelectionController = Get.put(FilterSelectionController());

  @override
  void onInit() {
    super.onInit();
    filterSelectionController.selectedCity.value = '';
    filterSelectionController.selectedCountry.value = '';
    filterSelectionController.selectedLanguage.value = '';
    selectedDistance.value = '5 km'; // Default distance
    updateAvailableCitiesForState('');
  }

  var selectedCountry = "".obs;
  var selectedCity = "".obs;
  var selectedLanguage = "".obs;
  var selectedDistance = "".obs;

  List<String> countries = ["USA", "France"];
  List<String> cities = ["New York", "Los Angeles"];
  List<String> languages = ["English", "French", "Spanish"];

  var availableCities = <String>[].obs;

  void updateAvailableCitiesForState(String state) {
    print("Updating cities for state: $state");
    if (state == "New York") {
      availableCities.value = newYorkCitiesList;
    } else if (state == "Los Angeles") {
      availableCities.value = losAngelusCities;
    } else {
      availableCities.value = [];
    }
    if(availableCities.isNotEmpty) { //
      filterOptions['City'] = availableCities.toList(); // Sync with filterOptions
    } //
    print("Available cities: ${availableCities.length}");
    update();
  }

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

  var selectedFilters = <String, RxList<String>>{}.obs;
  // var filterOptions = <String, List<String>>{
  //   "Time": ['Breakfast', 'Brunch', 'Lunch', 'Dinner', 'Late Night'],
  //   "Cuisines": [
  //     "American", "Mexican", "Italian", "French", "Chinese", "Japanese",
  //     "Thai", "Indian", "Korean", "Vietnamese", "Mediterranean", "Caribbean",
  //     "African", "Middle Eastern", "Spanish", "Filipino", "Brazilian",
  //     "Peruvian", "Russian", "German",
  //   ],
  //   "Dietary": [
  //     "Vegan", "Vegetarian", "Plant Based", "Pescatarian",
  //   ],
  //   "Vibes": [
  //     "Lively", "High-Energy", "LaidBack", "Intimate",
  //     "Loud", "Lowkey", "UpBeat"
  //   ],
  //   "Experience": [
  //     "Live Music", "Dj Night", "Ladies Night",
  //     "Hookah", "Karaoke",
  //   ],
  // }.obs;

  var filterOptions = <String, List<String>>{
    "Vibes": [
      "Lively", "High-Energy", "LaidBack", "Intimate",
      "Loud", "Lowkey", "UpBeat"
    ],
    "Experience": [
      "Brunch", "Outdoor", "Happy Hour", "Rooftop", "Water/Beachside",
      "Late Night", "Show"
    ],
    "Entertainment": [
      "Live Music", "Dj Nights", "Comedy", "Karaoke"
    ],
    // "Time": ['Breakfast', 'Brunch', 'Lunch', 'Dinner', 'Late Night'],
    "Cuisines": [
      "American", "Mexican", "Italian", "French", "Chinese", "Japanese",
      "Thai", "Indian", "Korean", "Vietnamese", "Mediterranean", "Caribbean",
      "African", "Middle Eastern", "Spanish", "Filipino", "Brazilian",
      "Peruvian", "Russian", "German",
    ],
    "Dietary": [
      "Vegan", "Vegetarian", "Plant Based", "Pescatarian",
    ],

  }.obs;

  List<String> losAngelusCities = [
    "Beverly Hills", "Santa Monica", "West Hollywood", "Downtown LA", "Hollywood",
    "Pasadena", "Long Beach", "Malibu", "Glendale", "Burbank", "Culver City",
    "Torrance", "Manhattan Beach", "Redondo Beach", "Hermosa Beach", "Inglewood",
    "Compton", "Carson", "Downey", "Norwalk", "Whittier", "Arcadia",
    "Monterey Park", "Alhambra", "San Gabriel", "Rosemead", "El Monte",
    "West Covina", "Pomona", "Diamond Bar", "Walnut", "La Puente",
    "Baldwin Park", "Industry", "Duarte", "Monrovia", "Sierra Madre",
    "San Marino", "South Pasadena", "La Canada Flintridge", "Altadena",
    "North Hollywood", "Studio City", "Sherman Oaks", "Encino", "Tarzana",
    "Woodland Hills", "Calabasas", "Agoura Hills", "Westlake Village",
    "Thousand Oaks", "Simi Valley", "Chatsworth", "Granada Hills", "Porter Ranch",
    "Northridge", "Reseda", "Van Nuys", "Panorama City", "Mission Hills",
    "Sylmar", "San Fernando", "Sun Valley", "Sunland", "Tujunga", "La Crescenta",
    "Montrose", "Eagle Rock", "Highland Park", "Glassell Park", "Atwater Village",
    "Los Feliz", "Silver Lake", "Echo Park", "Koreatown", "Mid-City",
    "West Adams", "Leimert Park", "Crenshaw",
  ];

  List<String> newYorkCitiesList = [
    "Manhattan", "Brooklyn", "Queens", "The Bronx", "Staten Island",
    "Long Island City", "Astoria", "Flushing", "Forest Hills", "Jackson Heights",
    "Sunnyside", "Woodside", "Bayside", "Whitestone", "College Point", "Jamaica",
    "Richmond Hill", "Ozone Park", "Howard Beach", "Rockaway Beach",
    "Far Rockaway", "Coney Island", "Brighton Beach", "Sheepshead Bay",
    "Bay Ridge", "Park Slope", "Williamsburg", "Greenpoint", "Bushwick",
    "Bedford-Stuyvesant", "Crown Heights", "Flatbush", "East Flatbush",
    "Brownsville", "East New York", "Sunset Park", "Bensonhurst", "Dyker Heights",
    "Midwood", "Gravesend", "Borough Park", "Flatlands", "Canarsie",
    "Mill Basin", "Marine Park", "Bergen Beach", "Downtown Brooklyn",
    "Brooklyn Heights", "DUMBO", "Carroll Gardens", "Cobble Hill", "Red Hook",
    "Gowanus", "Prospect Heights", "Fort Greene", "Clinton Hill", "Boerum Hill",
    "Windsor Terrace", "Kensington", "Ditmas Park", "Prospect Lefferts Gardens",
    "New Lots", "Spring Creek", "City Island", "Riverdale", "Kingsbridge",
    "Fordham", "University Heights", "Morris Heights", "Mount Eden",
    "Highbridge", "Concourse", "Mott Haven", "Melrose", "Hunts Point",
    "Longwood", "Morrisania", "Crotona Park East", "East Tremont",
  ];

  FilterController() {
    // Initialize selectedFilters for all categories in filterOptions
    for (var category in filterOptions.keys) {
      selectedFilters[category] = <String>[].obs;
    }
  }

  void toggleFilter(String category, String option) {
    final selectedList = selectedFilters[category] ?? <String>[].obs;
    if (selectedList.contains(option)) {
      selectedList.remove(option);
    } else {
      selectedList.add(option);
    }
    selectedFilters[category] = selectedList;
    selectedFilters.refresh();

    switch (category) {
      case 'Cuisines':
        filterSelectionController.selectedFilters.value = selectedFilters[category]?.toList() ?? [];
        break;
      case 'Vibes':
        filterSelectionController.selectedAtmosphere.value = selectedFilters[category]?.toList() ?? [];
        break;
      case 'Experience':
        filterSelectionController.selectedExperience.value = selectedFilters[category]?.toList() ?? [];
        break;
      case 'Entertainment':
        filterSelectionController.selectedEntertainment.value = selectedFilters[category]?.toList() ?? [];
        break;
      case 'Dietary':
        filterSelectionController.selectedDietary.value = selectedFilters[category]?.toList() ?? [];
        break;
    }

    syncFiltersWithSelectionController();
    update();
  }

  int getSelectedCount(String category) => selectedFilters[category]?.length ?? 0;

  int getTotalSelected() {
    return selectedFilters.values.fold(0, (sum, list) => sum + (list?.length ?? 0));
  }

  void clearAll() {
    filterSelectionController.aggregatedFilters.clear();
    filterSelectionController.selectedCity.value = '';
    filterSelectionController.selectedCountry.value = '';
    selectedFilters.forEach((key, value) => value.clear());
    updateAvailableCitiesForState('');
    update();
    Get.back();
  }

  void syncFiltersWithSelectionController() {
    filterSelectionController.selectedFilters.value = selectedFilters['Cuisines']?.toList() ?? [];
    filterSelectionController.selectedAtmosphere.value = selectedFilters['Vibes']?.toList() ?? [];
    filterSelectionController.selectedExperience.value = selectedFilters['Experience']?.toList() ?? [];
    filterSelectionController.selectedEntertainment.value = selectedFilters['Entertainment']?.toList() ?? [];
    filterSelectionController.selectedDietary.value = selectedFilters['Dietary']?.toList() ?? [];
    // filterSelectionController.selectedCity.value = selectedFilters['City']?.isNotEmpty ?? false
    //     ? (selectedFilters['City']?.first ?? '')
    //     : '';
    // filterSelectionController.selectedCountry.value = selectedCountry.value;
    // filterSelectionController.aggregateSelectedFilters();
    filterSelectionController.update();
    update();
  }
}