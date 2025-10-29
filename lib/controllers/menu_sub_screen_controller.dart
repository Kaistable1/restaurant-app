// import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';

import 'package:restaurant_web_app/controllers/add_restaurants_controller.dart';
import 'package:restaurant_web_app/controllers/drawer_controller.dart';
import 'package:restaurant_web_app/widgets/loading_dialog.dart';

class MenuSubScreenController extends GetxController {
  final specialConditionsController = TextEditingController();
  RxList<String> cuisineList = <String>[
    'Chinese',
    'Italian',
    'Fast Food',
    'Mexican',
    'Thai',
    'Japanese',
    'Mediterranean',
    'American',
    'Soul food',
    'Southern food',
    'Cajun & Creole',
    'Barbecue',
    'Diner / Comfort Food',
    'Jamaican',
    'Fusion',
  ].obs;
  RxString selectedCuisine = ''.obs;

  // Store uploaded images
  var uploadedImages = <UploadedImageModel>[].obs;
  // Checkbox states
  var isFoodMenuSelected = false.obs;
  var isDrinkMenuSelected = false.obs;

  // Store uploaded images
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
          uploadedImages.add(UploadedImageModel(bytes: file.bytes!));
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

  // Toggle Food Menu checkbox
  void toggleFoodMenu() {
    if (!isFoodMenuSelected.value) {
      isFoodMenuSelected.value = true;
      isDrinkMenuSelected.value = false; // Deselect Drink Menu
    }
  }

  // Toggle Drink Menu checkbox
  void toggleDrinkMenu() {
    if (!isDrinkMenuSelected.value) {
      isDrinkMenuSelected.value = true;
      isFoodMenuSelected.value = false; // Deselect Food Menu
    }
  }

  // Validate MenuSubScreen fields
  bool areMenuFieldsFilled() {
    return uploadedImages.isNotEmpty &&
        (isFoodMenuSelected.value || isDrinkMenuSelected.value);
  }

  // Clear all fields
  void clearFields() {
    specialConditionsController.clear();
    uploadedImages.clear();
    isFoodMenuSelected.value = false;
    isDrinkMenuSelected.value = false;
  }

  // Get special conditions text
  String getSpecialConditions() {
    return specialConditionsController.text.trim();
  }

  // Get selected menu types
  List<String> getSelectedMenuTypes() {
    List<String> menuTypes = [];
    if (isFoodMenuSelected.value) menuTypes.add('Food Menu');
    if (isDrinkMenuSelected.value) menuTypes.add('Drink Menu');
    return menuTypes;
  }

  // backend

  addMeneRestaurants() async {
    try {
      loadingDialog(loading: true, message: 'Adding menu...');

      final addRestaurantTabController = Get.find<AddRestaurantTabController>();
      final restaurantID = addRestaurantTabController.currentRestaurantID;
      // Upload all images to Firebase Storage and get their URLs
      List<String> imagesList = uploadedImages.isNotEmpty
          ? await imagesUrl(uploadedImageModels: uploadedImages)
          : [];
      // 👇 Step 2: Prepare the data map
      final restaurantData = {
        'specialConditions': specialConditionsController.text.trim(),
        'menuList': [
          {
            'cuisineType': selectedCuisine.value,
            'menuType': isFoodMenuSelected.value == true ? 'food' : 'drink',
            'foodImages': imagesList,
          }
        ],
      };

      // 👇 Step 3: Update Firestore
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantID)
          .update(restaurantData);

      // 👇 Step 4: UI updates
      Get.back();
      final drawerController = Get.put(DrawerControllerX());
      drawerController.selectedScreen.value = 5;
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to add amenities: $e');
      print('❌ Error adding amenities: $e');
    }
  }

  imagesUrl({
    required List<UploadedImageModel> uploadedImageModels,
  }) async {
    final controller = Get.find<AddRestaurantTabController>();
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
          : controller.restaurantModel?.imagesList ?? [];
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
