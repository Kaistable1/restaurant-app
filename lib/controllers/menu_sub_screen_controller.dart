// import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/controllers/add_restaurants_controller.dart';
import 'dart:typed_data';

import 'package:savrly/widgets/global_functions.dart';

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
    // ✅ Also clear the selected cuisine
    selectedCuisine.value = '';
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
      loadingDialog();

      final addRestaurantTabController = Get.find<AddRestaurantTabController>();
      final restaurantID = addRestaurantTabController.restaurantModel!.docID;
      ;
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
      clearFields();
      addRestaurantTabController.selectedIndex.value++;
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
          : controller.restaurantModel!.menuList.isNotEmpty
              ? controller.restaurantModel!.menuList[0].foodImages
              : [];
    }

    return imagesList;
  }
}
