import 'package:get/get.dart';

import '../../home_screen/home_controller/filter_selection_controller.dart'
    show FilterSelectionController;

class FilterController extends GetxController {
  final filterSelectionController = Get.put(FilterSelectionController());

  @override
  void onInit() {
    super.onInit();
    filterSelectionController.selectedCity.value = '';
    filterSelectionController.selectedCountry.value = '';
    filterSelectionController.selectedLanguage.value = '';
  }

  // Single Selection Variables
  var selectedCountry = "".obs;
  var selectedCity = "".obs;
  var selectedLanguage = "".obs;

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
      "American",
      "Mexican",
      "Italian",
      "French",
      "Chinese",
      "Japanese",
      "Thai",
      "Indian",
      "Korean",
      "Vietnamese",
      "Mediterranean",
      "Caribbean",
      "African",
      "Middle Eastern",
      "Spanish",
      "Filipino",
      "Brazilian",
      "Peruvian",
      "Russian",
      "German",
    ],
    "Dietary Preferences": [
      "Vegan & Plant-Based",
      "Vegetarian",
      "Gluten-Free",
      "Pescatarian",
      "Flexitarian",
      "Raw Food",
      "Keto",
      "Paleo",
    ],
    "Experience": [
      "Live Music",
      "Dj Night",
      "Silent Party",
      "Karaoke",
      "Trivia Nights",
      "Sports screenings",
      "Hookah",
      "Sip & Paint",
      "Ladies Night",
      " RnB Night"
    ],
    "Vibes": [
      "Brunch Party",
      "Bottomless Brunch",
      "Day Party",
      "Pool Party",
      "Happy Hours",
      "Open Bar",
      "Rooftop Vibes"
    ],
    "Atmospheres": [
      "Casual Dining",
      "Fine Dining",
      "Fast Food",
      "Date Night",
      "Candlelit",
      "Outdoor",
      "Rooftop",
      "Ocean View"
    ],
    "Facilities": [
      'Free wi-fi',
      'Private dinning',
      'Parking',
      'Takeout',
      'Drive-thru',
      'Outdoor seating',
      'Kid-Friendly',
      'Pet-Friendly',
      'Rest room',
      'Wheelchair accessibility',
      'High chairs',
    ],
    "Time of Day": [
      'Breakfast',
      'Brunch',
      'Lunch',
      'Dinner',
      'Late Night',
    ],
    "Price Range": [
      '\$(Budget-Friendly)',
      '\$\$(Moderate)',
      '\$\$\$(Premium)',
      '\$\$\$\$(Luxury)',
    ],
  }.obs;

  List<String> losAngelusCities = [
    "Beverly Hills",
    "Santa Monica",
    "West Hollywood",
    "Downtown LA",
    "Hollywood",
    "Pasadena",
    "Long Beach",
    "Malibu",
    "Glendale",
    "Burbank",
    "Culver City",
    "Torrance",
    "Manhattan Beach",
    "Redondo Beach",
    "Hermosa Beach",
    "Inglewood",
    "Compton",
    "Carson",
    "Downey",
    "Norwalk",
    "Whittier",
    "Arcadia",
    "Monterey Park",
    "Alhambra",
    "San Gabriel",
    "Rosemead",
    "El Monte",
    "West Covina",
    "Pomona",
    "Diamond Bar",
    "Walnut",
    "La Puente",
    "Baldwin Park",
    "Industry",
    "Duarte",
    "Monrovia",
    "Sierra Madre",
    "San Marino",
    "South Pasadena",
    "La Canada Flintridge",
    "Altadena",
    "North Hollywood",
    "Studio City",
    "Sherman Oaks",
    "Encino",
    "Tarzana",
    "Woodland Hills",
    "Calabasas",
    "Agoura Hills",
    "Westlake Village",
    "Thousand Oaks",
    "Simi Valley",
    "Chatsworth",
    "Granada Hills",
    "Porter Ranch",
    "Northridge",
    "Reseda",
    "Van Nuys",
    "Panorama City",
    "Mission Hills",
    "Sylmar",
    "San Fernando",
    "Sun Valley",
    "Sunland",
    "Tujunga",
    "La Crescenta",
    "Montrose",
    "Eagle Rock",
    "Highland Park",
    "Glassell Park",
    "Atwater Village",
    "Los Feliz",
    "Silver Lake",
    "Echo Park",
    "Koreatown",
    "Mid-City",
    "West Adams",
    "Leimert Park",
    "Crenshaw",
  ];

  List<String> newYorkCitiesList = [
    "Manhattan",
    "Brooklyn",
    "Queens",
    "The Bronx",
    "Staten Island",
    "Long Island City",
    "Astoria",
    "Flushing",
    "Forest Hills",
    "Jackson Heights",
    "Sunnyside",
    "Woodside",
    "Bayside",
    "Whitestone",
    "College Point",
    "Jamaica",
    "Richmond Hill",
    "Ozone Park",
    "Howard Beach",
    "Rockaway Beach",
    "Far Rockaway",
    "Coney Island",
    "Brighton Beach",
    "Sheepshead Bay",
    "Bay Ridge",
    "Park Slope",
    "Williamsburg",
    "Greenpoint",
    "Bushwick",
    "Bedford-Stuyvesant",
    "Crown Heights",
    "Flatbush",
    "East Flatbush",
    "Brownsville",
    "East New York",
    "Sunset Park",
    "Bensonhurst",
    "Dyker Heights",
    "Midwood",
    "Gravesend",
    "Borough Park",
    "Flatlands",
    "Canarsie",
    "Mill Basin",
    "Marine Park",
    "Bergen Beach",
    "Downtown Brooklyn",
    "Brooklyn Heights",
    "DUMBO",
    "Carroll Gardens",
    "Cobble Hill",
    "Red Hook",
    "Gowanus",
    "Prospect Heights",
    "Fort Greene",
    "Clinton Hill",
    "Boerum Hill",
    "Windsor Terrace",
    "Kensington",
    "Ditmas Park",
    "Prospect Lefferts Gardens",
    "New Lots",
    "Spring Creek",
    "City Island",
    "Riverdale",
    "Kingsbridge",
    "Fordham",
    "University Heights",
    "Morris Heights",
    "Mount Eden",
    "Highbridge",
    "Concourse",
    "Mott Haven",
    "Melrose",
    "Hunts Point",
    "Longwood",
    "Morrisania",
    "Crotona Park East",
    "East Tremont",
  ];
  // Initialize selected filters
  FilterController() {
    for (var key in filterOptions.keys) {
      selectedFilters[key] = <String>[].obs;
    }
  }

  void toggleFilter(String category, String option) {
    if (selectedFilters[category]!.contains(option)) {
      selectedFilters[category]!.remove(option);
      if (category == 'States') {
        filterSelectionController.selectedCountry.value = '';
      } else if (category == 'City') {
        filterSelectionController.selectedCity.value = '';
      }
    } else {
      if (category == 'States') {
        selectedFilters[category]!.clear();

        filterSelectionController.selectedCountry.value = option;
      } else if (category == 'City') {
        selectedFilters[category]!.clear();

        filterSelectionController.selectedCity.value = option;
      }
      selectedFilters[category]!.add(option);
    }

    // Update only the specific category filter in the controller
    switch (category) {
      case 'Cuisines':
        filterSelectionController.selectedFilters.value =
            selectedFilters[category]!.toList();
        break;
      case 'Discount Type':
        filterSelectionController.selectedDiscounts.value =
            selectedFilters[category]!.toList();
        break;
      case 'Time of Day':
        filterSelectionController.selectedTimeOfDay.value =
            selectedFilters[category]!.toList();
        break;
      case 'Atmospheres':
        filterSelectionController.selectedAtmosphere.value =
            selectedFilters[category]!.toList();
        break;
      case 'Facilities':
        filterSelectionController.selectedFacilities.value =
            selectedFilters[category]!.toList();
        break;
      case 'Dietary Preferences':
        filterSelectionController.selectedDietary.value =
            selectedFilters[category]!.toList();
        break;
      case 'Entertainment':
        filterSelectionController.selectedEntertainment.value =
            selectedFilters[category]!.toList();
        break;
      case 'Price Range':
        filterSelectionController.selectedPriceRange.value =
            selectedFilters[category]!.toList();
        break;
    }

    filterSelectionController.update();
    update(); // UI Refresh
  }

  int getSelectedCount(String category) =>
      selectedFilters[category]?.length ?? 0;
  int getTotalSelected() {
    return selectedFilters.values.fold(0, (sum, list) => sum + list.length);
  }

  // void clearAll() {
  //   filterSelectionController.aggregatedFilters.clear();
  //   filterSelectionController.selectedCity.value = '';
  //   filterSelectionController.selectedCountry.value = '';
  //   selectedFilters.forEach((key, value) => value.clear());
  //   update();
  //   Get.back();
  // }

  void clearAll() {
    // 1. Clear all category-wise filters
    selectedFilters.forEach((key, value) => value.clear());

    // 2. Reset country, city, and language
    filterSelectionController.selectedCountry.value = '';
    filterSelectionController.selectedCity.value = '';
    filterSelectionController.selectedLanguage.value = '';

    // 3. Clear FilterSelectionController filters
    filterSelectionController.selectedFilters.clear();
    filterSelectionController.selectedDiscounts.clear();
    filterSelectionController.selectedAtmosphere.clear();
    filterSelectionController.selectedFacilities.clear();
    filterSelectionController.selectedEntertainment.clear();
    filterSelectionController.selectedDietary.clear();
    filterSelectionController.selectedPriceRange.clear();
    filterSelectionController.selectedTimeOfDay.clear();
    filterSelectionController.selectedTrending.clear();

    // 4. Clear aggregated filter list
    filterSelectionController.aggregatedFilters.clear();

    // 5. Optional: Reset filtered result list
    filterSelectionController.filteredRestaurantsFuture.value =
        Future.value([]);

    // 6. Notify UI
    filterSelectionController.update();
    update(); // Update this controller too

    // 7. Close BottomSheet
    Get.back();

    print("✅ All filters have been cleared.");
  }
}

//.........OLD CODE ...........-------------


 //   "States": [
    //     "New York",
    //     "Los Angeles",
    //   ],
    //   "City": [],
    //   "Cuisines": [
    //     "American",
    //     "Mexican",
    //     "Italian",
    //     "French",
    //     "Chinese",
    //     "Japanese",
    //     "Thai",
    //     "Indian",
    //     "Korean",
    //     "Vietnamese",
    //     "Mediterranean",
    //     "Caribbean",
    //     "African",
    //     "Middle Eastern",
    //     "Spanish",
    //     "Filipino",
    //     "Brazilian",
    //     "Peruvian",
    //     "Russian",
    //     "German",
    //   ],
    //   "Vibes": [
    //     "Brunch Party",
    //     "Bottomless Brunch",
    //     "Day Party",
    //     "Pool Party",
    //     "Happy Hours",
    //     "Open Bar",
    //     "Rooftop Vibes"
    //   ],
    //   "Time of Day": [
    //     'Breakfast',
    //     'Brunch',
    //     'Lunch',
    //     'Dinner',
    //     'Late Night',
    //   ],
    //   "Atmospheres": [
    //     "Casual Dining",
    //     "Fine Dining",
    //     "Fast Food",
    //     "Date Night",
    //     "Candlelit",
    //     "Outdoor",
    //   ],
    //   "Facilities": [
    //     'Free wi-fi',
    //     'Private dinning',
    //     'Parking',
    //     'Takeout',
    //     'Drive-thru',
    //     'Outdoor seating',
    //     'Kid-Friendly',
    //     'Pet-Friendly',
    //     'Rest room',
    //     'Wheelchair accessibility',
    //     'High chairs',
    //   ],
    //   "Dietary Preferences": [
    //     "Vegan & Plant-Based",
    //     "Vegetarian",
    //     "Gluten-Free",
    //     "Pescatarian",
    //     "Flexitarian",
    //     "Raw Food",
    //     "Keto",
    //     "Paleo",
    //   ],
    //   "Experience": [
    //     "Live Music",
    //     "Dj Night",
    //     "Silent Party",
    //     "Karaoke",
    //     "Trivia Nights",
    //     "Sports screenings",
    //     "Hookah",
    //     "Sip & Paint",
    //     "Ladies Night"," RnB Night"
    //   ],
    //   "Price Range": [
    //     '\$(Budget-Friendly)',
    //     '\$\$(Moderate)',
    //     '\$\$\$(Premium)',
    //     '\$\$\$\$(Luxury)',
    //   ],
    // }.obs;

    // List<String> losAngelusCities = [
    //   "Beverly Hills",
    //   "Santa Monica",
    //   "West Hollywood",
    //   "Downtown LA",
    //   "Hollywood",
    //   "Pasadena",
    //   "Long Beach",
    //   "Malibu",
    //   "Glendale",
    //   "Burbank",
    //   "Culver City",
    //   "Torrance",
    //   "Manhattan Beach",
    //   "Redondo Beach",
    //   "Hermosa Beach",
    //   "Inglewood",
    //   "Compton",
    //   "Carson",
    //   "Downey",
    //   "Norwalk",
    //   "Whittier",
    //   "Arcadia",
    //   "Monterey Park",
    //   "Alhambra",
    //   "San Gabriel",
    //   "Rosemead",
    //   "El Monte",
    //   "West Covina",
    //   "Pomona",
    //   "Diamond Bar",
    //   "Walnut",
    //   "La Puente",
    //   "Baldwin Park",
    //   "Industry",
    //   "Duarte",
    //   "Monrovia",
    //   "Sierra Madre",
    //   "San Marino",
    //   "South Pasadena",
    //   "La Canada Flintridge",
    //   "Altadena",
    //   "North Hollywood",
    //   "Studio City",
    //   "Sherman Oaks",
    //   "Encino",
    //   "Tarzana",
    //   "Woodland Hills",
    //   "Calabasas",
    //   "Agoura Hills",
    //   "Westlake Village",
    //   "Thousand Oaks",
    //   "Simi Valley",
    //   "Chatsworth",
    //   "Granada Hills",
    //   "Porter Ranch",
    //   "Northridge",
    //   "Reseda",
    //   "Van Nuys",
    //   "Panorama City",
    //   "Mission Hills",
    //   "Sylmar",
    //   "San Fernando",
    //   "Sun Valley",
    //   "Sunland",
    //   "Tujunga",
    //   "La Crescenta",
    //   "Montrose",
    //   "Eagle Rock",
    //   "Highland Park",
    //   "Glassell Park",
    //   "Atwater Village",
    //   "Los Feliz",
    //   "Silver Lake",
    //   "Echo Park",
    //   "Koreatown",
    //   "Mid-City",
    //   "West Adams",
    //   "Leimert Park",
    //   "Crenshaw",
    // ];

    // List<String> newYorkCitiesList = [
    //   "Manhattan",
    //   "Brooklyn",
    //   "Queens",
    //   "The Bronx",
    //   "Staten Island",
    //   "Long Island City",
    //   "Astoria",
    //   "Flushing",
    //   "Forest Hills",
    //   "Jackson Heights",
    //   "Sunnyside",
    //   "Woodside",
    //   "Bayside",
    //   "Whitestone",
    //   "College Point",
    //   "Jamaica",
    //   "Richmond Hill",
    //   "Ozone Park",
    //   "Howard Beach",
    //   "Rockaway Beach",
    //   "Far Rockaway",
    //   "Coney Island",
    //   "Brighton Beach",
    //   "Sheepshead Bay",
    //   "Bay Ridge",
    //   "Park Slope",
    //   "Williamsburg",
    //   "Greenpoint",
    //   "Bushwick",
    //   "Bedford-Stuyvesant",
    //   "Crown Heights",
    //   "Flatbush",
    //   "East Flatbush",
    //   "Brownsville",
    //   "East New York",
    //   "Sunset Park",
    //   "Bensonhurst",
    //   "Dyker Heights",
    //   "Midwood",
    //   "Gravesend",
    //   "Borough Park",
    //   "Flatlands",
    //   "Canarsie",
    //   "Mill Basin",
    //   "Marine Park",
    //   "Bergen Beach",
    //   "Downtown Brooklyn",
    //   "Brooklyn Heights",
    //   "DUMBO",
    //   "Carroll Gardens",
    //   "Cobble Hill",
    //   "Red Hook",
    //   "Gowanus",
    //   "Prospect Heights",
    //   "Fort Greene",
    //   "Clinton Hill",
    //   "Boerum Hill",
    //   "Windsor Terrace",
    //   "Kensington",
    //   "Ditmas Park",
    //   "Prospect Lefferts Gardens",
    //   "New Lots",
    //   "Spring Creek",
    //   "City Island",
    //   "Riverdale",
    //   "Kingsbridge",
    //   "Fordham",
    //   "University Heights",
    //   "Morris Heights",
    //   "Mount Eden",
    //   "Highbridge",
    //   "Concourse",
    //   "Mott Haven",
    //   "Melrose",
    //   "Hunts Point",
    //   "Longwood",
    //   "Morrisania",
    //   "Crotona Park East",
    //   "East Tremont",
    // ];
