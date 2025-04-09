// import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';

class AddRestaurantTabController extends GetxController {
  final basicInfoFormKey = GlobalKey<FormState>();
  final restaurantNameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final assignPasswordController = TextEditingController();
  final areaController = TextEditingController();
  final tiktokLinkController = TextEditingController();
  final instagramController = TextEditingController();
  var isPasswordVisible = false.obs;
  RxInt selectedIndex = 0.obs;
  RxString selectedState = ''.obs;
  RxString selectedCity = ''.obs;
  RxString selectedSpokenLanguage = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  RxList<String> spokenLanguageList =
      <String>['Urdu', 'Punjabi', 'Spanish',].obs;

  RxList<String> cityList =
      <String>['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Peshawar'].obs;

  RxList<String> stateList =
      <String>['Pakistani', 'Chinese', 'Italian', 'Fast Food', 'Indian'].obs;
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
        contactController.text.trim().isNotEmpty &&
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
    contactController.clear();
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

}
