// import 'dart:html' as html;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_web_app/models/resaturant_model.dart';
import 'package:restaurant_web_app/widgets/loading_dialog.dart';

class AddRestaurantTabController extends GetxController {
  final basicInfoFormKey = GlobalKey<FormState>();
  final restaurantNameController = TextEditingController();
  final emailController = TextEditingController();
  final assignPasswordController = TextEditingController();
  final areaController = TextEditingController();
  final zipCodeController = TextEditingController();
  final phoneNoController = TextEditingController();
  final websiteUrlController = TextEditingController();
  final cityController = TextEditingController();
  final tiktokLinkController = TextEditingController();
  final instagramController = TextEditingController();
  RestaurantModel? restaurantModel;
  String currentRestaurantID = '';
  var isPasswordVisible = false.obs;
  RxInt selectedIndex = 0.obs;
  RxString selectedState = ''.obs;
  RxString selectedCity = ''.obs;
  RxString selectedSpokenLanguage = ''.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  RxList<String> spokenLanguageList = <String>[
    "English",
    "French",
    "Spanish",
  ].obs;

  // Changed stateList to be loaded dynamically from the package.
  RxList<String> stateList = <String>[].obs;
  // Added RxMap for cities by state.
  RxMap<String, List<String>> citiesByState = RxMap<String, List<String>>();

  // Add a loading state
  var isLocationDataLoading = true.obs;

  final List<String> tabs = [
    'Basic Info',
    'Amenities',
    'Experiences',
    'Operating Hours',
    'Menu',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadLocationData();
    // Sync selectedCity with cityController for manual typing
    cityController.addListener(() {
      selectedCity.value = cityController.text.trim();
    });
  }

  // Load location data from countries.json
  Future<void> _loadLocationData() async {
    try {
      isLocationDataLoading.value = true;
      print('Loading location data from countries.json...');

      // Load the JSON file
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

  /// Get filtered states for dropdown_search (handles real-time search)
  List<String> getFilteredStates(String? filter) {
    if (filter == null || filter.isEmpty) {
      return List<String>.from(stateList);
    }
    return stateList
        .where((state) => state.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  /// Get filtered cities for dropdown_search (handles real-time search)
  List<String> getFilteredCities(String? filter) {
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
    String? previousState = selectedState.value;
    selectedState.value = value ?? '';

    // Only reset city if actually changing state
    if (previousState != selectedState.value &&
        selectedState.value.isNotEmpty) {
      selectedCity.value = '';
      cityController.clear();
    }

    update();
  }

  /// Handle city selection (updated for dropdown_search)
  void onCitySelected(String? value) {
    selectedCity.value = value ?? '';
    cityController.text = value ?? '';
    update();
  }

  void showCityPicker(BuildContext context) {
    List<String> cities = citiesByState[selectedState.value] ?? [];
    if (cities.isEmpty) {
      Get.snackbar('No Cities', 'Please select a state first');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select a City'),
          content: SizedBox(
            width: 300,
            child: DropdownSearch<String>(
              items: cities,
              popupProps: PopupPropsMultiSelection.menu(
                showSearchBox: true,
                searchDelay: const Duration(milliseconds: 300),
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Type to search cities...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                menuProps: MenuProps(
                  borderRadius: BorderRadius.circular(10),
                ),
                itemBuilder: (context, item, isSelected) {
                  return ListTile(
                    title: Text(item),
                    selected: isSelected,
                    selectedTileColor: Colors.blue.withOpacity(0.1),
                  );
                },
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: 'Select or search city',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  suffixIcon:
                      const Icon(Icons.arrow_drop_down, color: Colors.blue),
                ),
              ),
              onChanged: (String? value) async {
                if (value != null && value.isNotEmpty) {
                  cityController.text = value;
                  selectedCity.value = value;
                  await Future.delayed(const Duration(milliseconds: 300));
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

  /// Perform ZIP code lookup and auto-populate state and city
  Future<void> lookupZipCode(String zipCode) async {
    if (zipCode.length != 5 || !RegExp(r'^\d{5}$').hasMatch(zipCode)) {
      Get.snackbar(
        'Invalid ZIP Code',
        'Please enter a valid 5-digit ZIP code',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      isLocationDataLoading.value = true;

      if (kIsWeb) {
        print('Running on web - using CORS proxy for ZIP lookup');
      }

      final locationData = await _fetchLocationFromZipCode(zipCode);

      if (locationData != null) {
        await _autoPopulateLocation(locationData);

        Get.snackbar(
          'Location Found!',
          'State: ${locationData['state']} | City: ${locationData['city']}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Location Not Found',
          'No location data available for ZIP code $zipCode',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('ZIP lookup error details: $e');
      if (e.toString().contains('XMLHttpRequest')) {
        print('Web CORS issue detected - ensure proxy is working');
      } else if (e.toString().contains('SocketException')) {
        print('Network connectivity issue');
      }
      Get.snackbar(
        'Lookup Error',
        'Failed to fetch location: ${e.toString().split(':')[0]}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLocationDataLoading.value = false;
    }
  }

  /// Fetch location data from ZIP code using external API
  Future<Map<String, String>?> _fetchLocationFromZipCode(String zipCode) async {
    try {
      final String proxyUrl = 'https://corsproxy.io/?';
      final String targetUrl = 'http://api.zippopotam.us/us/$zipCode';

      final response = await http.get(
        Uri.parse(proxyUrl + Uri.encodeFull(targetUrl)),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Mozilla/5.0 (compatible; Flutter)',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['places'] != null && data['places'].isNotEmpty) {
          String state = data['places'][0]['state'] ?? '';
          String city = data['places'][0]['place name'] ?? '';

          if (state.isNotEmpty && city.isNotEmpty) {
            return {
              'state': state,
              'city': city,
              'zipCode': zipCode,
            };
          }
        }
      }

      print('API request failed with status: ${response.statusCode}');
      return _lookupFromLocalDatabase(zipCode);
    } catch (e) {
      print('API error: $e');
      return _lookupFromLocalDatabase(zipCode);
    }
  }

  /// Fallback local ZIP code lookup
  Map<String, String>? _lookupFromLocalDatabase(String zipCode) {
    const Map<String, Map<String, String>> sampleZipCodes = {
      '10001': {'state': 'New York', 'city': 'New York'},
      '90210': {'state': 'California', 'city': 'Beverly Hills'},
      '60601': {'state': 'Illinois', 'city': 'Chicago'},
      '77002': {'state': 'Texas', 'city': 'Houston'},
      '33101': {'state': 'Florida', 'city': 'Miami'},
      '94102': {'state': 'California', 'city': 'San Francisco'},
      '19103': {'state': 'Pennsylvania', 'city': 'Philadelphia'},
      '20001': {'state': 'District of Columbia', 'city': 'Washington'},
      '30303': {'state': 'Georgia', 'city': 'Atlanta'},
      '35004': {'state': 'Alabama', 'city': 'Moody'},
      '21201': {'state': 'Maryland', 'city': 'Baltimore'},
      '37201': {'state': 'Tennessee', 'city': 'Nashville'},
      '68101': {'state': 'Nebraska', 'city': 'Omaha'},
    };

    final result = sampleZipCodes[zipCode];
    if (result != null) {
      print(
          'Using local fallback for ZIP $zipCode: ${result['state']}, ${result['city']}');
    } else {
      print('No local data for ZIP $zipCode');
    }

    return result;
  }

  /// Auto-populate state and city dropdowns with fetched data
  Future<void> _autoPopulateLocation(Map<String, String> locationData) async {
    String state = locationData['state'] ?? '';
    String city = locationData['city'] ?? '';
    String zipCode = locationData['zipCode'] ?? '';

    zipCodeController.text = zipCode;

    if (stateList.contains(state)) {
      selectedState.value = state;

      await Future.delayed(const Duration(milliseconds: 100));

      cityController.text = city;
      selectedCity.value = city;

      if (citiesByState[state]?.contains(city) != true) {
        Get.snackbar(
          'City Not in List',
          'City "$city" not in predefined list, but manually entered.',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } else {
      Get.snackbar(
        'State Not Found',
        'State "$state" not available in our database. Please select manually.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      selectedState.value = '';
      cityController.text = '';
      selectedCity.value = '';
    }

    update();
  }

  // Store uploaded images
  var uploadedImage = <UploadedImageModel>[].obs;
  void pickImageWeb() async {
    print("Upload tapped");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      print("Picked ${result.files.length} files");
      for (var file in result.files) {
        if (file.bytes != null) {
          uploadedImage.add(UploadedImageModel(bytes: file.bytes!));
        }
      }
    } else {
      print("No file selected");
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < uploadedImage.length) {
      uploadedImage.removeAt(index);
    }
  }

  bool areBasicInfoFieldsFilled() {
    bool basicFields = restaurantNameController.text.trim().isNotEmpty &&
        areaController.text.trim().isNotEmpty &&
        phoneNoController.text.trim().isNotEmpty &&
        websiteUrlController.text.isNotEmpty;

    bool locationFields = selectedState.value.trim().isNotEmpty &&
        selectedCity.value.trim().isNotEmpty;

    // Ensure location data is loaded before validating
    bool locationDataReady =
        !isLocationDataLoading.value && stateList.isNotEmpty;

    return basicFields && locationFields && locationDataReady;
  }

  void clearFields() {
    restaurantNameController.clear();
    emailController.clear();
    assignPasswordController.clear();
    areaController.clear();
    instagramController.clear();
    tiktokLinkController.clear();
    phoneNoController.clear();
    websiteUrlController.clear();
    cityController.clear();
    zipCodeController.clear();
    uploadedImage.clear();
    selectedState.value = '';
    selectedCity.value = '';
    selectedSpokenLanguage.value = '';
    isPasswordVisible.value = false;
    update();
  }

  // Backend code

  updateBasicInfo() async {
    try {
      // Show loading dialog
      loadingDialog(loading: true, message: 'Updating restaurant...');
      List<String> imagesList =
          await imagesUrl(uploadedImageModels: uploadedImage);
      // Prepare the restaurant data
      final restaurantData = {
        'address': areaController.text.trim(),
        'city': selectedCity.value.trim(),
        'state': selectedState.value.trim(),
        'country': 'United States',
        'resImages': imagesList,
        'latitude': latitude.value,
        'logoImage': imagesList.isEmpty
            ? 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg'
            : imagesList.first,
        'longitude': longitude.value,
        'password': assignPasswordController.text,
        'resEmail': emailController.text.trim(),
        'resName': restaurantNameController.text.trim(),
        'socialLink': instagramController.text.trim(),
        'socialMedia': tiktokLinkController.text.trim(),
        'spokenLanguage': selectedSpokenLanguage.value.trim(),
        'phoneNo': phoneNoController.text.trim(),
        'websiteUrl': websiteUrlController.text.trim(),
        'zipCode': zipCodeController.text.trim(),
      };

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantModel?.docID)
          .update(restaurantData);

      // Dismiss the loading dialog
      Get.back();
      // Show success message
      selectedIndex.value++;
      clearFields();
      uploadedImage.clear();
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to updated restaurant: $e');
      print('Error $e');
    }
  }

  imagesUrl({
    required List<UploadedImageModel> uploadedImageModels,
  }) async {
    List<String> imagesList = [];
    List<String> existingImageUrls = [];
    List<Uint8List> newImagesToUpload = [];

    for (var image in uploadedImageModels) {
      if (image.url != null) {
        existingImageUrls.add(image.url!);
      } else if (image.bytes != null) {
        newImagesToUpload.add(image.bytes!);
      }
    }

    // Upload new images to Firebase
    if (newImagesToUpload.isNotEmpty) {
      final uploadedImageUrls = await uploadImagesToFirebase(newImagesToUpload);
      imagesList = [
        ...existingImageUrls,
        ...uploadedImageUrls,
      ];
    } else {
      imagesList = existingImageUrls.isNotEmpty
          ? existingImageUrls
          : restaurantModel?.imagesList ?? [];
    }

    return imagesList;
  }

  Future<List<String>> uploadImagesToFirebase(List<Uint8List> images) async {
    List<String> imageUrls = [];
    List<Uint8List> imagesCopy = List.from(images); // 🔥 Fix: Create a copy

    for (var image in imagesCopy) {
      try {
        String imageUrl = await uploadSingleImageToFirebase("items", image);
        imageUrls.add(imageUrl); // Convert String to RxString
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    return imageUrls;
  }

  ///upload image to firebaseStorage
  Future<String> uploadSingleImageToFirebase(
      String refPath, Uint8List imagePath) async {
    var auth = FirebaseAuth.instance;

    String url = '';

    String id = auth.currentUser != null
        ? "${DateTime.now().millisecondsSinceEpoch}${auth.currentUser!.uid.toString()}"
        : '${DateTime.now().millisecondsSinceEpoch}';
    print('id +$id');
//reference for storage
    final ref = FirebaseStorage.instance.ref(refPath).child(id);
//put file
    final uploadTask = await ref.putData(imagePath);
    url = await uploadTask.ref.getDownloadURL();
    print(url);
    return url;
  }
}

class UploadedImageModel {
  final Uint8List? bytes;
  final String? url;

  UploadedImageModel({this.bytes, this.url});
}
