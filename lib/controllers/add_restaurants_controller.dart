// import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/models/resaturant_model.dart';
import 'package:restaurant_web_app/widgets/loading_dialog.dart';

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
        'socialLink': instagramController.text.trim(),
        'socialMedia': tiktokLinkController.text.trim(),
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
