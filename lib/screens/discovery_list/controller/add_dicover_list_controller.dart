// Modified add_dicover_list_controller.dart (note: fixed typo in file name if needed)

import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/models/resaturant_model.dart';

import '../../../constants/app_colors.dart';
import '../../../models/discover_list_model.dart';
import '../../../widgets/global_functions.dart';

class AddDiscoverListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DiscoverListModel? selectedDiscoverListModel;
  RxBool isEdit = false.obs;

  String fileName = '';
  Rx<Uint8List> imageBytes = (Uint8List.fromList([])).obs;
  RxString imageUrl = ''.obs;

  final discoverListNameController = TextEditingController();
  final discoverListByController = TextEditingController();
  final discoverListDescController = TextEditingController();

  RxString selectedState = ''.obs;
  RxString selectedCity = ''.obs;

  final cityController = TextEditingController();

  var isLocationDataLoading =
      true.obs; // Tracks if location data is still loading
  var isRestaurantDataLoading = false.obs;

  RxList<String> stateList = <String>[].obs;
  RxMap<String, List<String>> citiesByState = RxMap<String, List<String>>();

  RxList<RestaurantModel> selectedRestaurants = <RestaurantModel>[].obs;

  final Map<String, List<String>> filterOptions = {
    "Vibes": [
      "Date Night",
      "Hidden Gems",
      "Trendy & Social",
      "High Vibe",
      "Chill & Cozy",
    ],
    "Entertainment": ["Live Music", "Dj Nights", "Comedy", "Karaoke"],
    "Experience": [
      "Brunch",
      "Outdoor",
      "Happy Hour",
      "Rooftop",
      "Water/Beachside",
      "Late Night",
      "Show"
    ],
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
      "Soul food",
      "Southern food",
      "Cajun & Creole",
      "Barbecue",
      "Diner / Comfort Food",
      "Jamaican",
      "Fusion",
    ],
    "Dietary": [
      "Vegan",
      "Vegetarian",
      "Plant Based",
      "Pescatarian",
    ],
  };

  RxList<String> selectedVibes = <String>[].obs;
  RxList<String> selectedExperiences = <String>[].obs;
  RxList<String> selectedEntertainment = <String>[].obs;
  RxList<String> selectedCuisines = <String>[].obs;
  RxList<String> selectedDietary = <String>[].obs;

  // Pick images for web
  void pickImageWeb() async {
    print("Upload tapped");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      print("Picked ${result.files.length} files");
      for (var file in result.files) {
        if (file.bytes != null) {
          imageBytes.value = file.bytes!;
          fileName = file.name;
        }
      }
    } else {
      print("No file selected");
    }
  }

  // Remove image from the list
  void removeImage() {
    if (imageBytes.value.isNotEmpty) {
      fileName = '';
      imageBytes.value = Uint8List.fromList([]);
    } else if (imageUrl.value != '') {
      imageUrl.value = '';
    }
  }

  Future<List<RestaurantModel>> getFilteredRestaurants(String filter) async {
    print('Fetching restaurants with filter: $filter');
    print('  State: ${selectedState.value}, City: ${selectedCity.value}');
    print(
        '  Vibes: ${selectedVibes.value}, Experiences: ${selectedExperiences.value}');
    print(
        '  Entertainment: ${selectedEntertainment.value}, Cuisines: ${selectedCuisines.value}');
    print('  Dietary: ${selectedDietary.value}');
    try {
      isRestaurantDataLoading.value = true;

      // Start with base query
      Query query = _firestore.collection('restaurants');

      // Apply state filter only if selected
      if (selectedState.value.isNotEmpty) {
        query = query.where('state', isEqualTo: selectedState.value);
      }

      // Apply city filter only if selected
      if (selectedCity.value.isNotEmpty) {
        query = query.where('city', isEqualTo: selectedCity.value);
      }

      if (selectedVibes.isNotEmpty) {
        query = query.where('vibesList', arrayContainsAny: selectedVibes);
      }
      if (selectedExperiences.isNotEmpty) {
        query = query.where('experiencesList',
            arrayContainsAny: selectedExperiences);
      }
      if (selectedEntertainment.isNotEmpty) {
        query = query.where('entertainmentList',
            arrayContainsAny: selectedEntertainment);
      }
      if (selectedDietary.isNotEmpty) {
        query = query.where('dietaryList', arrayContainsAny: selectedDietary);
      }
      if (filter.isNotEmpty) {
        query = query
            .where('resName', isGreaterThanOrEqualTo: filter)
            .where('resName', isLessThan: '$filter\uf8ff');
      }

      query = query.limit(50);

      final snaps = await query.get() as QuerySnapshot<Map<String, dynamic>>;
      List<RestaurantModel> restaurants = snaps.docs
          .map((doc) => RestaurantModel.fromDocumentSnapshot(doc))
          .toList();

      // Apply cuisine filter client-side
      if (selectedCuisines.isNotEmpty) {
        restaurants = restaurants.where((restaurant) {
          return restaurant.menuList
              .any((menu) => selectedCuisines.contains(menu.cuisineType));
        }).toList();
      }

      print('Fetched ${restaurants.length} restaurants after cuisine filter');
      isRestaurantDataLoading.value = false;
      return restaurants;
    } catch (e) {
      print('Error fetching restaurants: $e');
      isRestaurantDataLoading.value = false;
      return [];
    }
  }

  Future<void> loadSelectedRestaurants(List<dynamic> ids) async {
    selectedRestaurants.clear();
    for (var id in ids) {
      try {
        final doc = await _firestore.collection('restaurants').doc(id).get();
        if (doc.exists) {
          selectedRestaurants.add(RestaurantModel.fromDocumentSnapshot(doc));
        }
      } catch (e) {
        print('Error loading restaurant $id: $e');
      }
    }
  }

  // Add discover list to Firestore
  addDiscoverList() async {
    try {
      loadingDialog();

      DiscoverListModel dlm = DiscoverListModel(
        docId: '',
        name: discoverListNameController.text,
        by: discoverListByController.text,
        description: discoverListDescController.text,
        image: '',
        restaurantIdsList: selectedRestaurants.map((r) => r.docID).toList(),
      );

      DocumentReference docRef =
          await _firestore.collection('discoverLists').add(dlm.toMap());

      String imgUrl = '';
      if (imageBytes.value.isNotEmpty) {
        imgUrl = await FirebaseStorage.instance
            .ref('discoverList/${docRef.id}.${fileName.split('.').last}')
            .putData(imageBytes.value)
            .then((val) => val.ref.getDownloadURL());
      }

      await docRef.update({'docId': docRef.id, 'image': imgUrl});

      clearForm();
      Get.back();
      Get.snackbar(
        'Success',
        'Discover list added successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add Discover list: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return null;
    }
  }

  updateDiscoverList({docID}) async {
    try {
      loadingDialog();

      String imgUrl = '';
      if (imageBytes.value.isNotEmpty) {
        imgUrl = await FirebaseStorage.instance
            .ref('discoverList/$docID.${fileName.split('.').last}')
            .putData(imageBytes.value)
            .then((val) => val.ref.getDownloadURL());
      } else if (imageUrl.value.isEmpty &&
          selectedDiscoverListModel!.image.isNotEmpty) {
        await FirebaseStorage.instance
            .refFromURL(selectedDiscoverListModel!.image)
            .delete();
      } else {
        imgUrl = imageUrl.value;
      }

      DiscoverListModel dlm = DiscoverListModel(
        docId: docID,
        name: discoverListNameController.text,
        by: discoverListByController.text,
        description: discoverListDescController.text,
        image: imgUrl,
        restaurantIdsList: selectedRestaurants.map((r) => r.docID).toList(),
      );

      await _firestore
          .collection('discoverLists')
          .doc(docID)
          .update(dlm.toMap());

      clearForm();
      Get.back();
      Get.snackbar(
        'Success',
        'Discover list updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update Discover list: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return null;
    }
  }

  void clearForm() {
    discoverListNameController.clear();
    discoverListByController.clear();
    discoverListDescController.clear();
    imageBytes.value = Uint8List.fromList([]);
    imageUrl = ''.obs;
    selectedRestaurants.clear();
    selectedVibes.clear();
    selectedExperiences.clear();
    selectedEntertainment.clear();
    selectedCuisines.clear();
    selectedDietary.clear();
    selectedState.value = '';
    selectedCity.value = '';
    cityController.clear();
  }

  // ========== DROPDOWN_SEARCH INTEGRATION METHODS - ADD THIS BLOCK ==========

  Future<void> _loadLocationData() async {
    try {
      isLocationDataLoading.value = true;
      print('Loading location data from country_picker_plus...');

      final stringData = await DefaultAssetBundle.of(Get.context!)
          .loadString('assets/countries.json');
      print('JSON data loaded: ${stringData.substring(0, 100)}...');

      final List<dynamic> countries = json.decode(stringData);
      final usData = countries.firstWhere(
        (c) => c['name'] == 'United States',
        orElse: () {
          print('US data not found in JSON');
          return null;
        },
      );

      if (usData != null) {
        final List<dynamic> stateData =
            usData['states'].where((s) => s['type'] == 'state').toList() ?? [];
        List<String> tempStates =
            stateData.map((s) => s['name'] as String).toList();
        tempStates.sort();

        Map<String, List<String>> tempCityMap = {};
        for (var state in stateData) {
          List<dynamic> citiesData = state['cities'] ?? [];
          List<String> cities =
              citiesData.map((c) => c['name'] as String).toList();
          cities.sort();
          tempCityMap[state['name']] = cities;
          print('Cities for ${state['name']}: ${cities.length} cities loaded');
        }

        print(
            'Loaded ${tempStates.length} states and ${tempCityMap.length} state-city mappings');
        stateList.assignAll(tempStates);
        citiesByState.assignAll(tempCityMap);
      } else {
        print('No US data found, using fallback states');
        List<String> fallbackStates = [
          'Alabama',
          'Alaska',
          'Arizona',
          'Arkansas',
          'California',
          'Colorado',
          'Connecticut',
          'Delaware',
          'Florida',
          'Georgia',
          'Hawaii',
          'Idaho',
          'Illinois',
          'Indiana',
          'Iowa',
          'Kansas',
          'Kentucky',
          'Louisiana',
          'Maine',
          'Maryland',
          'Massachusetts',
          'Michigan',
          'Minnesota',
          'Mississippi',
          'Missouri',
          'Montana',
          'Nebraska',
          'Nevada',
          'New Hampshire',
          'New Jersey',
          'New Mexico',
          'New York',
          'North Carolina',
          'North Dakota',
          'Ohio',
          'Oklahoma',
          'Oregon',
          'Pennsylvania',
          'Rhode Island',
          'South Carolina',
          'South Dakota',
          'Tennessee',
          'Texas',
          'Utah',
          'Vermont',
          'Virginia',
          'Washington',
          'West Virginia',
          'Wisconsin',
          'Wyoming'
        ];

        stateList.assignAll(fallbackStates);
        citiesByState.assignAll({});
      }
    } catch (e, stackTrace) {
      print('Error loading location data: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar('Error', 'Failed to load location data: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      stateList.assignAll([]);
      citiesByState.assignAll({});
    } finally {
      isLocationDataLoading.value = false;
    }
  }

  List<String> getFilteredStates(String? filter) {
    print('Filtering states with query: $filter');
    if (filter == null || filter.isEmpty) {
      return List<String>.from(stateList);
    }
    return stateList
        .where((state) => state.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<String> getFilteredCities(String? filter) {
    print(
        'Filtering cities with query: $filter, State: ${selectedState.value}');
    if (selectedState.value.isEmpty ||
        citiesByState[selectedState.value] == null ||
        citiesByState[selectedState.value]!.isEmpty) {
      return [];
    }

    List<String> allCities = citiesByState[selectedState.value]!;
    if (filter == null || filter.isEmpty) {
      return List<String>.from(allCities);
    }

    return allCities
        .where((city) => city.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  /// Handle state selection (updated for dropdown_search)
  void onStateSelected(String? value) {
    print('State selected: $value');
    String? previousState = selectedState.value;
    selectedState.value = value ?? '';
    if (previousState != selectedState.value) {
      selectedCity.value = '';
      cityController.text = '';
      print(
          'Reset city: selectedCity=${selectedCity.value}, cityController=${cityController.text}');
    }
    update();
  }

  void showCityPicker(BuildContext context) {
    print('Showing city picker for state: ${selectedState.value}');
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select a City'),
          content: SizedBox(
            width: 300,
            child: DropdownSearch<String>(
              items: (String? filter, _) => getFilteredCities(filter),
              itemAsString: (String? item) => item ?? '',
              popupProps: PopupProps.menu(
                menuProps: MenuProps(
                  borderRadius: BorderRadius.circular(10),
                ),
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Type to search cities...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: lightColor),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                showSelectedItems: true,
                fit: FlexFit.loose,
                constraints: const BoxConstraints(maxHeight: 300),
                itemBuilder: (context, item, isSelected, isDisabled) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor.withOpacity(0.1) : null,
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        color: isDisabled
                            ? Colors.grey
                            : isSelected
                                ? primaryColor
                                : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: 'Select or search city',
                  hintStyle: TextStyle(color: lightColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: lightColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: lightColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: lightColor),
                  ),
                  suffixIcon:
                      const Icon(Icons.arrow_drop_down, color: primaryColor),
                ),
              ),
              onChanged: (String? value) async {
                if (value != null && value.isNotEmpty) {
                  print('City selected: $value');
                  cityController.text = value;
                  selectedCity.value = value;
                  await Future.delayed(Duration(milliseconds: 500));
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

// ========== END DROPDOWN_SEARCH INTEGRATION METHODS ==========

  @override
  void onInit() {
    super.onInit();
    _loadLocationData();
    cityController.addListener(() {
      print('City controller updated: ${cityController.text}');
      selectedCity.value = cityController.text.trim();
    });
  }
}
