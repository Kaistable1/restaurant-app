// import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/firebase_options.dart';
import 'package:savrly/models/resaturant_model.dart';
import 'dart:typed_data';

import 'package:savrly/widgets/global_functions.dart';

class AddRestaurantTabController extends GetxController {
  final basicInfoFormKey = GlobalKey<FormState>();
  final restaurantNameController = TextEditingController();
  final emailController = TextEditingController();
  final assignPasswordController = TextEditingController();
  final areaController = TextEditingController();
  final tiktokLinkController = TextEditingController();
  final instagramController = TextEditingController();
  RestaurantModel? restaurantModel;
  String currentRestaurantID = '';
  var isPasswordVisible = false.obs;
  RxInt selectedIndex = 0.obs;
  RxString selectedState = ''.obs;
  RxString selectedCity = ''.obs;
  RxString selectedSpokenLanguage = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  RxList<String> spokenLanguageList = <String>[
    "English",
    "French",
    "Spanish",
  ].obs;

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

  RxList<String> stateList = <String>["New York", "Los Angeles"].obs;
  final List<String> tabs = [
    'Basic Info',
    'Amenities',
    'Experiences',
    'Operating Hours',
    'Menu',
  ];

  // Store uploaded images
  var uploadedImages = <Uint8List>[].obs;

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
          uploadedImages.add(file.bytes!);
        }
      }
    } else {
      print("No file selected");
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < uploadedImages.length) {
      uploadedImages.removeAt(index);
    }
  }

  bool areBasicInfoFieldsFilled() {
    return restaurantNameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        assignPasswordController.text.trim().isNotEmpty &&
        areaController.text.trim().isNotEmpty &&
        instagramController.text.trim().isNotEmpty &&
        tiktokLinkController.text.trim().isNotEmpty &&
        selectedState.value.isNotEmpty &&
        selectedCity.value.isNotEmpty &&
        selectedSpokenLanguage.value.isNotEmpty;
  }

  void clearFields() {
    restaurantNameController.clear();
    emailController.clear();
    assignPasswordController.clear();
    areaController.clear();
    instagramController.clear();
    tiktokLinkController.clear();
    uploadedImages.clear();
    selectedState.value = '';
    selectedCity.value = '';
    selectedSpokenLanguage.value = '';
    isPasswordVisible.value = false; // Reset visibility
  }

  // Backend code

  addRestaurant() async {
    try {
      // Show loading dialog
      loadingDialog();

      // Upload all images to Firebase Storage and get their URLs
      List<String> imagesList = await uploadImagesToFirebase(uploadedImages);

      // Prepare the restaurant data
      final restaurantData = {
        'about': 'Coming Soon!! Stay tuned for something exciting!',
        'address': areaController.text.trim(),
        'atmopshereList': [], // Empty array as per your data
        'averageRating': 0,
        'city': selectedCity.value.trim(),
        'country': selectedState.value.trim(),
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'dietaryList': [], // Empty array as per your data
        'docID': '', // Will be set after adding the document
        'entertainmentScheduleList': [], // Empty array as per your data
        'facilityList': [], // Empty array as per your data
        'imagesList': imagesList,
        'latitude':
            40.72761, // Hardcoded for now; you can add a map picker later
        'logoImage': imagesList.isEmpty
            ? 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg'
            : imagesList.first,
        'longitude':
            -73.98373, // Hardcoded for now; you can add a map picker later
        'menuList': [], // Empty array as per your data
        'password': assignPasswordController.text.trim(),
        'priceRange': '', // Hardcoded for now; you can add a field for this
        'resEmail': emailController.text.trim(),
        'resName': restaurantNameController.text.trim(),
        'InstagramLink': instagramController.text.trim(),
        'TiktokLink': tiktokLinkController.text.trim(),
        'specialConditions': 'Coming Soon!! Stay tuned for something exciting!',
        'spokenLanguage': selectedSpokenLanguage.value.trim(),
      };
      await assignedCredencialsLogin(
          email: emailController.text.trim(),
          userPassword: assignPasswordController.text.trim());
      // Add the restaurant to Firestore
      final docRef = await FirebaseFirestore.instance
          .collection('restaurants')
          .add(restaurantData);

      // Update the docID field with the generated document ID
      await docRef.update({'docID': docRef.id});
      currentRestaurantID = docRef.id;
      update();
      // Dismiss the loading dialog
      Get.back();
      // Show success message
      Get.snackbar('Success', 'Restaurant added successfully');
      selectedIndex.value++;
      clearFields();
      uploadedImages.clear();
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to add restaurant: $e');
      print('Error $e');
    }
  }

  updateBasicInfo() async {
    try {
      // Show loading dialog
      loadingDialog();
      // Upload all images to Firebase Storage and get their URLs
      // List<String> imagesList = imagesUrl(uploadedImages: uploadedImages)
      // Prepare the restaurant data
      final restaurantData = {
        'address': areaController.text.trim(),
        'city': selectedCity.value.trim(),
        'country': selectedState.value.trim(),
        // 'imagesList': imagesList,
        'latitude':
            40.72761, // Hardcoded for now; you can add a map picker later
        // 'logoImage': imagesList.isEmpty
        //     ? 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg'
        //     : imagesList.first,
        'longitude':
            -73.98373, // Hardcoded for now; you can add a map picker later
        'password': assignPasswordController.text.trim(),
        'resEmail': emailController.text.trim(),
        'resName': restaurantNameController.text.trim(),
        'InstagramLink': instagramController.text.trim(),
        'TiktokLink': tiktokLinkController.text.trim(),
        'spokenLanguage': selectedSpokenLanguage.value.trim(),
      };

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantModel?.docID)
          .update(restaurantData);

      // Dismiss the loading dialog
      Get.back();
      // Show success message
      Get.snackbar('Success', 'Basic info updated successfully');
      selectedIndex.value++;
      clearFields();
      uploadedImages.clear();
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to updated restaurant: $e');
      print('Error $e');
    }
  }

  Future<List<String>> imagesUrl({
    required RxList<dynamic> uploadedImages,

  }) async {
    List<String> imagesList = [];
    // Separate existing URLs and new images (Uint8List)
    List<String> existingImageUrls = [];
    List<Uint8List> newImagesToUpload = [];

    for (var image in uploadedImages) {
      if (image is String) {
        // If the item is a URL (string), add it to existingImageUrls
        existingImageUrls.add(image);
      } else if (image is Uint8List) {
        // If the item is raw image data (Uint8List), add it to newImagesToUpload
        newImagesToUpload.add(image);
      }
    }

    // Upload new images to Firebase Storage if there are any
    if (newImagesToUpload.isNotEmpty) {
      final uploadedImageUrls = await uploadImagesToFirebase(newImagesToUpload);
      imagesList = [
        ...existingImageUrls, // Keep existing URLs
        ...uploadedImageUrls, // Add newly uploaded image URLs
      ];
    } else {
      // If no new images to upload, use existing URLs or fallback to restaurantModel's imagesList
      imagesList = existingImageUrls.isNotEmpty
          ? existingImageUrls
          : restaurantModel?.imagesList ?? [];
    }

    return imagesList;
  }

  assignedCredencialsLogin(
      {required String email, required String userPassword}) async {
    try {
      // 🔁 Avoid duplicate secondary app
      if (Firebase.apps.any((app) => app.name == 'SecondaryApp')) {
        await Firebase.app('SecondaryApp').delete();
      }

      // ✅ Initialize Secondary Firebase App
      FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: DefaultFirebaseOptions.web,
      );

      FirebaseAuth secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);

      try {
        // ✅ Check if user exists before creating
        List<String> methods =
            await secondaryAuth.fetchSignInMethodsForEmail(email);
        if (methods.isEmpty) {
          // 👤 User doesn't exist, create new one
          await secondaryAuth.createUserWithEmailAndPassword(
            email: email,
            password: userPassword,
          );
          print('✅ User created successfully');
        } else {
          // 👤 User already exists, try signing in
          await secondaryAuth.signInWithEmailAndPassword(
            email: email,
            password: userPassword,
          );
          print('✅ Signed in existing user');
        }
      } on FirebaseAuthException catch (e) {
        print('❌ FirebaseAuthException: ${e.code} — ${e.message}');
      }

      await secondaryAuth.signOut();
      await secondaryApp.delete();
    } catch (e) {
      print('❌ General error: $e');
    }
  }
}
