// import 'dart:html' as html;
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:savrly/main.dart';
import 'package:savrly/models/resaturant_model.dart';
import 'dart:typed_data';

import 'package:savrly/widgets/global_functions.dart';

import '../constants/app_colors.dart';

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
  bool? isNewRegistery;
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
  // Removed hardcoded states; they will be loaded in _loadLocationData.
  RxList<String> stateList = <String>[].obs;
  // Added RxMap for cities by state.
  RxMap<String, List<String>> citiesByState = RxMap<String, List<String>>();

  final List<String> tabs = [
    'Basic Info',
    'Amenities',
    'Events',
    'Operating Hours',
    'Menu',
  ];

  // Helper method to generate password
  String _generatePassword(String restaurantName) {
    // Create a more secure password using restaurant name and some randomization
    String cleanName = restaurantName
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(' ', '');

    // Take first 3 letters of name + random numbers + special char
    String namePart =
        cleanName.length > 3 ? cleanName.substring(0, 3) : cleanName;
    String numberPart =
        (DateTime.now().millisecondsSinceEpoch % 10000).toString();
    String specialChars =
        ['!', '@', '#', '\$', '%', '&', '*'][DateTime.now().second % 7];

    return '${namePart}${numberPart.substring(0, 4)}$specialChars';
  }

  // Method to generate only email
  void generateEmailOnly() {
    String restaurantName = restaurantNameController.text.trim();

    if (restaurantName.isEmpty) {
      Get.snackbar('Error', 'Please enter restaurant name first',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    String cleanName = restaurantName
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(' ', '')
        .substring(0, 15);

    String generatedEmail = '$cleanName@savrly.com';
    emailController.text = generatedEmail;

    Get.snackbar(
      'Email Generated',
      'Email: $generatedEmail',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // Method to generate only password
  void generatePasswordOnly() {
    String restaurantName = restaurantNameController.text.trim();

    if (restaurantName.isEmpty) {
      Get.snackbar('Error', 'Please enter restaurant name first',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    String generatedPassword = _generatePassword(restaurantName);
    assignPasswordController.text = generatedPassword;

    Get.snackbar(
      'Password Generated',
      'Password: $generatedPassword',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onInit() {
    super.onInit();
    _loadLocationData();
    // Sync selectedCity with cityController for manual typing
    cityController.addListener(() {
      selectedCity.value = cityController.text.trim();
    });
  }

  // Add a loading state
  var isLocationDataLoading = true.obs; // Tracks if data is still loading

  // In AddRestaurantTabController.dart

  Future<void> _loadLocationData() async {
    try {
      isLocationDataLoading.value = true;
      print('Loading location data from country_picker_plus...');

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
        tempStates.sort(); // Sort states alphabetically

        Map<String, List<String>> tempCityMap = {};
        for (var state in stateData) {
          List<dynamic> citiesData = state['cities'] ?? [];
          // START CHANGE: Extract 'name' from city maps
          List<String> cities =
              citiesData.map((c) => c['name'] as String).toList();
          // END CHANGE
          cities.sort(); // Sort cities alphabetically
          tempCityMap[state['name']] = cities;
          print(
              'Cities for ${state['name']}: ${cities.length} cities loaded'); // Debug
        }

        print(
            'Loaded ${tempStates.length} states and ${tempCityMap.length} state-city mappings');
        stateList.assignAll(tempStates);
        citiesByState.assignAll(tempCityMap);
      } else {
        print('No US data found, using fallback states');
        // ========== COMPLETE FALLBACK STATES LIST - REPLACE EXISTING ==========
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
        citiesByState.assignAll({}); // Empty cities as fallback
        // ========== END COMPLETE FALLBACK STATES LIST ==========
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

  // ========== DROPDOWN_SEARCH INTEGRATION METHODS - ADD THIS BLOCK ==========

  /// Get filtered states for dropdown_search (handles real-time search)
  List<String> getFilteredStates(String? filter) {
    if (filter == null || filter.isEmpty) {
      return List<String>.from(stateList);
    }

    // Return filtered states based on search query
    return stateList
        .where((state) => state.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  /// Get filtered cities for dropdown_search (handles real-time search)
  List<String> getFilteredCities(String? filter) {
    // If no state selected or no cities for that state, return empty list
    if (selectedState.value.isEmpty ||
        citiesByState[selectedState.value] == null ||
        citiesByState[selectedState.value]!.isEmpty) {
      return [];
    }

    List<String> allCities = citiesByState[selectedState.value]!;

    if (filter == null || filter.isEmpty) {
      return List<String>.from(allCities);
    }

    // Return filtered cities based on search query
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
      selectedCity.value = ''; // Reset city when state changes
    }

    update(); // Trigger UI update
  }

  void showCityPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select a City'),
          content: SizedBox(
            width: 300, // Adjustable width for the dialog
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
                itemBuilder: (context, item, isSelected, _) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor.withOpacity(0.1) : null,
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        color: isSelected ? primaryColor : Colors.black87,
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
                  cityController.text = value;
                  selectedCity.value = value;
                  await Future.delayed(Duration(milliseconds: 500));
                  Navigator.of(dialogContext)
                      .pop(); // Close dialog after selection
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

  // ========== ZIP CODE AUTO-POPULATION METHODS - ADD THIS BLOCK ==========

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
      // Show loading indicator
      isLocationDataLoading.value = true;

      // ========== WEB DEBUG LOG - ADD THIS ==========
      if (kIsWeb) {
        print('Running on web - using CORS proxy for ZIP lookup');
      }
      // ========== END WEB DEBUG LOG ==========

      // Make API call to ZIP code lookup service
      final locationData = await _fetchLocationFromZipCode(zipCode);

      if (locationData != null) {
        // Auto-populate state and city
        await _autoPopulateLocation(locationData);

        // Show success message
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
      // ========== ENHANCED ERROR LOG - REPLACE CATCH ==========
      print('ZIP lookup error details: $e');
      if (e.toString().contains('XMLHttpRequest')) {
        print('Web CORS issue detected - ensure proxy is working');
      } else if (e.toString().contains('SocketException')) {
        print('Network connectivity issue');
      }
      Get.snackbar(
        'Lookup Error',
        'Failed to fetch location: ${e.toString().split(':')[0]}', // Shorten error message
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      // ========== END ENHANCED ERROR LOG ==========
    } finally {
      isLocationDataLoading.value = false;
    }
  }

  /// Fetch location data from ZIP code using external API
  Future<Map<String, String>?> _fetchLocationFromZipCode(String zipCode) async {
    try {
      // Use CORS proxy for Flutter web (handles browser CORS restrictions)
      final String proxyUrl = 'https://corsproxy.io/?';
      final String targetUrl = 'http://api.zippopotam.us/us/$zipCode';

      final response = await http.get(
        Uri.parse(proxyUrl + Uri.encodeFull(targetUrl)),
        headers: {
          'Content-Type': 'application/json',
          // Optional: Add user-agent to mimic browser if needed
          'User-Agent': 'Mozilla/5.0 (compatible; Flutter)',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract state and city from response (handles multiple places, takes first)
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

      // Fallback to local database on API failure
      print('API request failed with status: ${response.statusCode}');
      return _lookupFromLocalDatabase(zipCode);
    } catch (e) {
      print('API error: $e');
      // Fallback to local database on any error
      return _lookupFromLocalDatabase(zipCode);
    }
  }

  /// Fallback local ZIP code lookup (basic sample - expand as needed)
  Map<String, String>? _lookupFromLocalDatabase(String zipCode) {
    // Expanded sample database - add more as needed or load from assets
    const Map<String, Map<String, String>> sampleZipCodes = {
      // Original samples
      '10001': {'state': 'New York', 'city': 'New York'},
      '90210': {'state': 'California', 'city': 'Beverly Hills'},
      '60601': {'state': 'Illinois', 'city': 'Chicago'},
      '77002': {'state': 'Texas', 'city': 'Houston'},
      '33101': {'state': 'Florida', 'city': 'Miami'},
      '94102': {'state': 'California', 'city': 'San Francisco'},
      '19103': {'state': 'Pennsylvania', 'city': 'Philadelphia'},
      '20001': {'state': 'District of Columbia', 'city': 'Washington'},
      '30303': {'state': 'Georgia', 'city': 'Atlanta'},
      // New: ZIP 35004 example
      '35004': {'state': 'Alabama', 'city': 'Moody'},
      // Add more common ZIPs
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

    // Update ZIP code field
    zipCodeController.text = zipCode;

    // Check if state exists in our list
    if (stateList.contains(state)) {
      // Select the state
      selectedState.value = state;

      // Wait a bit for the UI to update
      await Future.delayed(const Duration(milliseconds: 100));

      // Always set city (allow manual even if not in list)
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
      // If state doesn't exist in our list, show error
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

    update(); // Trigger UI update
  }

// ========== END ZIP CODE AUTO-POPULATION METHODS ==========

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

  // ========== UPDATED VALIDATION METHOD - REPLACE EXISTING METHOD ==========
  bool areBasicInfoFieldsFilled() {
    bool basicFields = restaurantNameController.text.trim().isNotEmpty &&
        // emailController.text.trim().isNotEmpty &&
        // assignPasswordController.text.trim().isNotEmpty &&
        areaController.text.trim().isNotEmpty &&
        phoneNoController.text.trim().isNotEmpty &&
        websiteUrlController.text.isNotEmpty;

    bool locationFields = selectedState.value.trim().isNotEmpty &&
        selectedCity.value.trim().isNotEmpty;

    // ========== DROPDOWN_SEARCH VALIDATION - ADD THIS BLOCK ==========
    // Ensure location data is loaded before validating
    bool locationDataReady =
        !isLocationDataLoading.value && stateList.isNotEmpty;

    return basicFields && locationFields && locationDataReady;
    // ========== END DROPDOWN_SEARCH VALIDATION ==========
  }
  // ========== END UPDATED VALIDATION METHOD ==========

  // ========== UPDATED CLEARFIELDS METHOD - REPLACE EXISTING METHOD ==========
  void clearFields() {
    // Clear all text controllers
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

    // Clear images
    uploadedImage.clear();

    // Clear all selection states
    selectedState.value = '';
    selectedCity.value = '';
    selectedSpokenLanguage.value = '';
    isPasswordVisible.value = false;

    // Clear location coordinates
    latitude.value = 0.0;
    longitude.value = 0.0;

    // Clear restaurant model and ID
    restaurantModel = null;
    currentRestaurantID = '';
    isNewRegistery = null;

    // Reset tab index to first tab
    selectedIndex.value = 0;

    update(); // Ensure UI updates with cleared selections
  }
  // ========== END UPDATED CLEARFIELDS METHOD ==========

  // Backend code

  addRestaurant() async {
    try {
      // Show loading dialog
      loadingDialog();

      // Upload all images to Firebase Storage and get their URLs
      List<Uint8List> imageBytesList = uploadedImage
          .where((img) => img.bytes != null)
          .map((img) => img.bytes!)
          .toList();

      List<String> imagesList = await uploadImagesToFirebase(imageBytesList);

      String docID = '';
      if (emailController.text.isNotEmpty &&
          assignPasswordController.text.isNotEmpty) {
        docID = await assignedCredencialsLogin(
            email: emailController.text.trim(),
            userPassword: assignPasswordController.text);
      }
      if (docID == 'error') {
        Get.back();
        Get.snackbar('Savrly', 'Restaurant not registered!',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      // Prepare the restaurant data
      final restaurantData = {
        'phoneNo': phoneNoController.text.trim(),
        'websiteUrl': websiteUrlController.text.trim(),
        'about': 'Coming Soon!! Stay tuned for something exciting!',
        'address': areaController.text.trim(),
        'atmopshereList': [],
        'vibesList': [], // Empty array as per your data
        'experiencesList': [],
        'entertainmentList': [],
        'averageRating': 0,
        'reviewCount': 0,
        'city': selectedCity.value.trim(),
        'state': selectedState.value.trim(),
        'country': 'United States',
        'createdAt': Timestamp.now(),
        'dietaryList': [], // Empty array as per your data
        'docID': docID, // Will be set after adding the document
        'entertainmentScheduleList': [], // Empty array as per your data
        'facilityList': [], // Empty array as per your data
        'imagesList': imagesList,
        'latitude':
            latitude.value, // Hardcoded for now; you can add a map picker later
        'logoImage': imagesList.isEmpty
            ? 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg'
            : imagesList.first,
        'longitude': longitude
            .value, // Hardcoded for now; you can add a map picker later
        'menuList': [], // Empty array as per your data
        'password': assignPasswordController.text,
        'priceRange': '', // Hardcoded for now; you can add a field for this
        'resEmail': emailController.text.trim(),
        'resName': restaurantNameController.text.trim(),
        'socialLink': instagramController.text.trim(),
        'socialMedia': tiktokLinkController.text.trim(),
        'specialConditions': 'Coming Soon!! Stay tuned for something exciting!',
        'spokenLanguage': selectedSpokenLanguage.value.trim(),
        'zipCode': zipCodeController.text.trim(),
      };

      if (docID == '') {
        await FirebaseFirestore.instance
            .collection('restaurants')
            .add(restaurantData)
            .then((val) async {
          await val.update({'docID': val.id});
          restaurantData['docID'] = val.id;
          docID = val.id;
        });
      } else {
        // Add the restaurant to Firestore
        await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(docID)
            .set(restaurantData);
        restaurantData['docID'] = docID;
      }

      // Create restaurant owner if email/password were provided
      if (emailController.text.isNotEmpty &&
          assignPasswordController.text.isNotEmpty &&
          docID.isNotEmpty &&
          docID != 'error') {
        try {
          // Prepare owner data
          final ownerData = {
            'docID': docID,
            'contact': '', // Empty contact field as requested
            'createdAt': DateTime.now(),
            'email': emailController.text.trim(),
            'img': imagesList.isEmpty
                ? 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg'
                : imagesList.first,
            'password': assignPasswordController.text,
            'restaurantData': restaurantData,
          };

          // Create restaurant owner document
          await FirebaseFirestore.instance
              .collection('restaurantOwner')
              .doc(docID)
              .set(ownerData);

          print('✅ Restaurant owner created with docID: $docID');
        } catch (e) {
          print('❌ Error creating restaurant owner: $e');
          // Note: Restaurant is already created, so we just log the error
          Get.snackbar(
            'Warning',
            'Restaurant created but owner profile failed: $e',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        }
      }

      // Always set restaurantModel after successful creation
      restaurantModel = RestaurantModel.fromMap(restaurantData);
      currentRestaurantID = docID;
      update();

      // Dismiss the loading dialog
      Get.back();
      // Move to next tab
      selectedIndex.value++;
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to add restaurant: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Error $e');
    }
  }

  updateBasicInfo() async {
    try {
      // Show loading dialog
      loadingDialog();

      // Check if we're adding email/password to a restaurant that didn't have them
      bool addingCredentials = (restaurantModel!.resEmail.isEmpty ||
              restaurantModel!.resEmail == '') &&
          emailController.text.trim().isNotEmpty &&
          assignPasswordController.text.isNotEmpty;

      // Check if we're updating existing credentials
      bool updatingCredentials = restaurantModel!.resEmail.isNotEmpty &&
          restaurantModel!.resEmail != emailController.text.trim() &&
          emailController.text.trim().isNotEmpty;

      String? newUid;

      if (addingCredentials) {
        // Case 1: Adding credentials to restaurant that didn't have them
        print('📝 Adding new credentials to existing restaurant');
        newUid = await assignedCredencialsLogin(
            email: emailController.text.trim(),
            userPassword: assignPasswordController.text);

        if (newUid == 'error') {
          Get.back();
          Get.snackbar('Error', 'Failed to create authentication credentials',
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }
      } else if (updatingCredentials) {
        // Case 2: Updating existing credentials
        print('🔄 Updating existing credentials');
        String uid = await updateCredentials(
            currentEmail: restaurantModel!.resEmail,
            currentPassword: restaurantModel!.password,
            newEmail: emailController.text.trim(),
            newPassword: assignPasswordController.text);

        if (uid == 'error') {
          Get.back();
          return;
        }
        newUid = uid;
      }

      List<String> imagesList =
          await imagesUrl(uploadedImageModels: uploadedImage);

      // Prepare the restaurant data to update
      final restaurantData = {
        'address': areaController.text.trim(),
        'city': selectedCity.value.trim(),
        'state': selectedState.value.trim(),
        'country': 'United States',
        'imagesList': imagesList,
        'latitude': latitude.value,
        'logoImage': imagesList.isEmpty
            ? 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg'
            : imagesList.first,
        'longitude': longitude.value,
        'resName': restaurantNameController.text.trim(),
        'socialLink': instagramController.text.trim(),
        'socialMedia': tiktokLinkController.text.trim(),
        'spokenLanguage': selectedSpokenLanguage.value.trim(),
        'phoneNo': phoneNoController.text.trim(),
        'websiteUrl': websiteUrlController.text.trim(),
        'zipCode': zipCodeController.text.trim(),
      };

      // Add email and password to update data if they're provided
      if (emailController.text.trim().isNotEmpty) {
        restaurantData['resEmail'] = emailController.text.trim();
        restaurantData['password'] = assignPasswordController.text;
      }

      // Update the restaurant document
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantModel?.docID)
          .update(restaurantData);

      // Handle restaurant owner creation/update
      if (addingCredentials || updatingCredentials) {
        await handleRestaurantOwnerOnUpdate(imagesList, restaurantData);
      }

      // Dismiss the loading dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Success',
        'Restaurant updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Move to next tab
      selectedIndex.value++;
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to updated restaurant: $e');
      print('Error $e');
    }
  }

  // Handle restaurant owner creation or update when updating restaurant
  Future<void> handleRestaurantOwnerOnUpdate(
      List<String> imagesList, Map<String, dynamic> restaurantData) async {
    try {
      // Check if email and password are now provided
      bool hasEmailPassword = emailController.text.trim().isNotEmpty &&
          assignPasswordController.text.isNotEmpty;

      // Check if restaurant previously had no email (was created without owner)
      bool previouslyNoEmail = restaurantModel?.resEmail == null ||
          restaurantModel!.resEmail.isEmpty;

      if (hasEmailPassword && restaurantModel?.docID != null) {
        // Check if owner document exists
        final ownerDoc = await FirebaseFirestore.instance
            .collection('restaurantOwner')
            .doc(restaurantModel!.docID)
            .get();

        if (!ownerDoc.exists && previouslyNoEmail) {
          // Case: Email/password added during update, create new owner
          print(
              '📝 Creating new restaurant owner (email/password added during update)');

          // Note: Auth account creation is already handled by updateCredentials above
          // We just need to create the restaurantOwner document

          // Get the complete restaurant data including the new email/password
          final completeRestaurantData = {
            ...restaurantData,
            'docID': restaurantModel!.docID,
            'resEmail': emailController.text.trim(),
            'password': assignPasswordController.text,
          };

          // Create owner data
          final ownerData = {
            'docID': restaurantModel!.docID,
            'contact': '', // Empty contact field as requested
            'createdAt': DateTime.now(),
            'email': emailController.text.trim(),
            'img': imagesList.isEmpty
                ? 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg'
                : imagesList.first,
            'password': assignPasswordController.text,
            'restaurantData': completeRestaurantData,
          };

          // Create restaurant owner document
          await FirebaseFirestore.instance
              .collection('restaurantOwner')
              .doc(restaurantModel!.docID)
              .set(ownerData);

          print('✅ Restaurant owner created successfully during update');
        } else if (ownerDoc.exists) {
          // Case: Owner exists, update it
          print('🔄 Updating existing restaurant owner');

          final updatedOwnerData = {
            'email': emailController.text.trim(),
            'img': imagesList.isEmpty
                ? 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg'
                : imagesList.first,
            'restaurantData': {
              ...restaurantData,
              'docID': restaurantModel!.docID,
              'resEmail': emailController.text.trim(),
              'password': assignPasswordController.text,
            },
          };

          // Update password only if it changed
          if (restaurantModel!.password != assignPasswordController.text) {
            updatedOwnerData['password'] = assignPasswordController.text;
          }

          await FirebaseFirestore.instance
              .collection('restaurantOwner')
              .doc(restaurantModel!.docID)
              .update(updatedOwnerData);

          print('✅ Restaurant owner updated successfully');
        }
      }
    } catch (e) {
      print('❌ Error handling restaurant owner: $e');
      // Don't throw error, just log it since restaurant update already succeeded
      Get.snackbar(
        'Warning',
        'Restaurant updated but owner profile operation failed: $e',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  imagesUrl({required List<UploadedImageModel> uploadedImageModels}) async {
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

  Future<String> assignedCredencialsLogin(
      {required String email, required String userPassword}) async {
    String? adminEmail;
    String? adminPassword;

    try {
      // Get admin credentials from SharedPreferences
      adminEmail = preferences?.getString('adminEmail');
      adminPassword = preferences?.getString('adminPassword');

      if (adminEmail == null || adminPassword == null) {
        Get.snackbar('Error', 'Admin credentials not found',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print('Admin credentials not found in SharedPreferences');
        return 'error';
      }

      // Sign out temporarily
      await FirebaseAuth.instance.signOut();
      print('admin logout successfully');

      // Create restaurant user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: assignPasswordController.text,
      );
      print(
          'restaurant user registered successfully with id ${userCredential.user?.uid}');
      User? newUser = userCredential.user;

      if (newUser != null) {
        // Sign out restaurant
        await FirebaseAuth.instance.signOut();
        print('logout restaurant');
        // Sign admin back in
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
        print('login admin again');
        return newUser.uid;
      } else {
        // Sign admin back in even if restaurant creation failed
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
        print('Admin logged back in after restaurant creation failure');

        Get.snackbar('Error', 'Failed to create restaurant',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print('failed to create restaurant');
        return 'error';
      }
    } catch (e) {
      print('create restaurant issue $e');

      // Ensure admin is signed back in even on error
      try {
        if (adminEmail != null && adminPassword != null) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: adminEmail,
            password: adminPassword,
          );
          print('Admin logged back in after error');
        }
      } catch (signInError) {
        print('Failed to sign admin back in: $signInError');
      }

      return 'error';
    }
  }

  Future<String> updateCredentials({
    required String currentEmail,
    required String currentPassword,
    required String newEmail,
    required String newPassword,
  }) async {
    try {
      print('Current email: $currentEmail');
      print('Current password: $currentPassword');
      print('New email: $newEmail');
      print('New password: $newPassword');

      String? adminEmail = preferences?.getString('adminEmail');
      String? adminPassword = preferences?.getString('adminPassword');

      if (adminEmail == null || adminPassword == null) {
        Get.snackbar('Error', 'Admin credentials not found',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print('Admin credentials not found');
        return 'error';
      }

      bool isValidEmail(String email) {
        return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
      }

      if (newEmail.isNotEmpty && !isValidEmail(newEmail)) {
        Get.snackbar('Error', 'Invalid email format',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print('Invalid email format: $newEmail');
        return 'error';
      }

      if (newPassword.isNotEmpty && newPassword.length < 6) {
        Get.snackbar('Error', 'Password must be at least 6 characters',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print('Invalid password: too short');
        return 'error';
      }

      // Logout admin to sign in restaurant user
      await FirebaseAuth.instance.signOut();
      print('Admin logged out successfully');

      // Sign in restaurant user
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: currentEmail,
        password: currentPassword,
      );
      print('Restaurant user logged in with ID ${userCredential.user?.uid}');
      User? restaurantUser = userCredential.user;

      if (restaurantUser == null) {
        Get.snackbar('Error', 'Failed to authenticate restaurant user',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print('Failed to authenticate restaurant user');
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
        print('Admin logged back in');
        return 'error';
      }

      // Update Email if needed
      if (newEmail.isNotEmpty && newEmail != currentEmail) {
        try {
          if (restaurantUser.uid.isEmpty) {
            throw Exception('User UID is empty');
          }
          if (newEmail.isEmpty) {
            throw Exception('New email is empty');
          }
          final payload = {
            'uid': restaurantUser.uid,
            'newEmail': newEmail.trim().toLowerCase(),
          };
          print('Sending payload to Cloud Function: $payload');

          final callable = FirebaseFunctions.instanceFor(region: 'us-central1')
              .httpsCallable('updateUserEmail');
          final response = await callable.call(payload);
          print('Cloud Function response: ${response.data}');

          if (response.data['success'] == true) {
            print(
                'Restaurant user email updated to $newEmail via Cloud Function');

            // *** FIX: Re-sign in with new email to refresh token ***
            UserCredential newCredential =
                await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: newEmail,
              password: currentPassword,
            );
            restaurantUser = newCredential.user;
            print(
                'Restaurant user re-logged in with updated email: ${restaurantUser?.uid}');
          } else {
            String errorMessage = response.data['error'] ?? 'Unknown error';
            String userFriendlyMessage;
            switch (errorMessage) {
              case 'Email already in use':
                userFriendlyMessage = 'Email is already in use';
                break;
              case 'Invalid email format':
                userFriendlyMessage = 'Invalid email format';
                break;
              case 'User not found':
                userFriendlyMessage = 'User not found';
                break;
              default:
                userFriendlyMessage = 'Failed to update email: $errorMessage';
            }
            Get.snackbar('Error', userFriendlyMessage,
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white);
            print('Email update failed: $errorMessage');
            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: adminEmail,
              password: adminPassword,
            );
            print('Admin logged back in');
            return 'error';
          }
        } catch (e) {
          Get.snackbar('Error', 'Failed to update email: $e',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          print('Email update failed: $e');
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: adminEmail,
            password: adminPassword,
          );
          print('Admin logged back in');
          return 'error';
        }
      }

      // Update Password if needed
      if (newPassword.isNotEmpty && restaurantModel!.password != newPassword) {
        try {
          await restaurantUser?.updatePassword(newPassword);
          print('Restaurant user password updated');
        } catch (e) {
          if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
            try {
              AuthCredential credential = EmailAuthProvider.credential(
                email: currentEmail,
                password: currentPassword,
              );
              await restaurantUser?.reauthenticateWithCredential(credential);
              print('Re-authentication successful');
              await restaurantUser?.updatePassword(newPassword);
              print('Restaurant user password updated after re-auth');
            } catch (reAuthError) {
              Get.snackbar('Error', 'Failed to update password: $reAuthError',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white);
              print(
                  'Re-authentication or password update failed: $reAuthError');
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: adminEmail,
                password: adminPassword,
              );
              print('Admin logged back in');
              return 'error';
            }
          } else {
            throw e;
          }
        }
      }

      await FirebaseAuth.instance.signOut();
      print('Restaurant user logged out');

      // Sign admin back in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: adminEmail,
        password: adminPassword,
      );
      print('Admin logged back in');

      return restaurantUser!.uid;
    } catch (e) {
      print('Error updating credentials: $e');
      try {
        String? adminEmail = preferences?.getString('adminEmail');
        String? adminPassword = preferences?.getString('adminPassword');
        if (adminEmail != null && adminPassword != null) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: adminEmail,
            password: adminPassword,
          );
          print('Admin logged back in after error');
        }
      } catch (signInError) {
        print('Error signing admin back in: $signInError');
      }
      Get.snackbar('Error', 'Failed to update credentials: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return 'error';
    }
  }

//
}

class UploadedImageModel {
  final Uint8List? bytes;
  final String? url;

  UploadedImageModel({this.bytes, this.url});
}
