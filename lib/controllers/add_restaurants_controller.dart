// import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/main.dart';
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

  List<String> losAngelesCities = [
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
    uploadedImage.clear();
    selectedState.value = '';
    selectedCity.value = '';
    selectedSpokenLanguage.value = '';
    isPasswordVisible.value = false; // Reset visibility
    update();
  }

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

      String docID = await assignedCredencialsLogin(
          email: emailController.text.trim(),
          userPassword: assignPasswordController.text.trim());
      if (docID == 'error') {
        Get.snackbar('Savrly', 'Restaurant not registered!');
        Get.back();
        return;
      }
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
        'docID': docID, // Will be set after adding the document
        'entertainmentScheduleList': [], // Empty array as per your data
        'facilityList': [], // Empty array as per your data
        'resImages': imagesList,
        'latitude':
            latitude.value, // Hardcoded for now; you can add a map picker later
        'logoImage': imagesList.isEmpty
            ? 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg'
            : imagesList.first,
        'longitude': longitude
            .value, // Hardcoded for now; you can add a map picker later
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

      // Add the restaurant to Firestore
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(docID)
          .set(restaurantData);
      if (isNewRegistery == true) {
        restaurantModel = RestaurantModel.fromMap(restaurantData);
        update();
      }
      update();
      // Dismiss the loading dialog
      Get.back();
      // Show success message
      selectedIndex.value++;
      clearFields();
      uploadedImage.clear();
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

      if (isNewRegistery == true) {
        await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(restaurantModel!.docID)
            .delete();
        await addRestaurant();
        Get.back();
        return;
      }

      List<String> imagesList =
          await imagesUrl(uploadedImageModels: uploadedImage);
      // Prepare the restaurant data
      final restaurantData = {
        'address': areaController.text.trim(),
        'city': selectedCity.value.trim(),
        'country': selectedState.value.trim(),
        'resImages': imagesList,
        'latitude':
            latitude.value, // Hardcoded for now; you can add a map picker later
        'logoImage': imagesList.isEmpty
            ? 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg'
            : imagesList.first,
        'longitude': longitude
            .value, // Hardcoded for now; you can add a map picker later
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

  Future<String> assignedCredencialsLogin(
      {required String email, required String userPassword}) async {
    try {
      // Get admin credentials from SharedPreferences
      String? adminEmail = preferences?.getString('adminEmail');
      String? adminPassword = preferences?.getString('adminPassword');

      // Sign out temporarily
      await FirebaseAuth.instance.signOut();
      print('admin logout successfully');
      // Create restaurant user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: assignPasswordController.text.trim(),
      );
      print(
          'restaurant user regiester successfully with id ${userCredential.user?.uid}');
      User? newUser = userCredential.user;

      if (newUser != null) {
        // Sign out restaurant
        await FirebaseAuth.instance.signOut();
        print('logout restaurant');
        // Sign admin back in
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmail!,
          password: adminPassword!,
        );
        print('login admin again');
      } else {
        Get.snackbar('Error', 'Failed to create restaurant',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print('failf to create restaurant');
      }
      return newUser!.uid;
    } catch (e) {
      print('create reaturant issue $e');
      return 'error';
    }
  }
}

class UploadedImageModel {
  final Uint8List? bytes;
  final String? url;

  UploadedImageModel({this.bytes, this.url});
}
