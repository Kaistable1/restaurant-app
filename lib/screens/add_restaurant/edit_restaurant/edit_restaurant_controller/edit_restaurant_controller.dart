import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_web_app/main.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/restaurant_detail_screen.dart';
import 'package:restaurant_web_app/widgets/global_functions.dart';

import '../../../../universal_models/discount_model.dart';

class EditRestaurantController extends GetxController {
  String? selected_menuType;
  String? selected_cuisne;

  final TextEditingController fromTimeHourController = TextEditingController();
  final TextEditingController fromTimeMintController = TextEditingController();
  final TextEditingController toTimeMintController = TextEditingController();
  final TextEditingController toTimeHourController = TextEditingController();
  RxList<Uint8List> memoryImages = RxList<Uint8List>();
  var items = <ItemModel>[].obs;
  var categoryItems = <CategoryModel>[].obs;
  void addItem(String description, int menuIndex, String docID,
      DiscountModel discountModel) async {
    if (selected_menuType.toString().isEmpty ||
        description.isEmpty ||
        offerController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (memoryImages.isEmpty) {
      Get.snackbar(
        "Error",
        "Please add at least one image.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final newItem = ItemModel(
      cuisineMenu: selected_menuType.toString(),
      cuisineName: description, //
      offer: offerController.text,
      itemImages: RxList<RxString>(), // Initially empty, will update later
      itemMemoryImages:
          RxList<Uint8List>.from(memoryImages), // Show local images first
    );
    if (menuIndex == 9) {
      items.add(newItem); // Add to UI immediately
    } else {
      // 🔹 Step 1: Add item immediately with a placeholder image

      print(discountModel.menu.length + 1);
      discountModel.menu[menuIndex].items.add(newItem); // Add to UI immediately
    }

    // 🔹 Step 2: Start uploading images in the background
    uploadImagesToFirebase(List.from(memoryImages)).then((uploadedUrls) {
      newItem.itemImages.addAll(uploadedUrls); // Update images after upload
      items.refresh(); // 🔄 Refresh UI when upload completes
    });
    // 🔹 Step 3: Clear fields immediately (without blocking UI)
    selected_menuType = '';

    offerController.clear();
    memoryImages.clear();
  }

  /// Function to add category and subcategory
  void addCategoryAndSubcategory(
      DiscountModel discountModel, String category, String subcategory,
      {String? fromDate,
      String? toDate,
      String? percentageValue,
      String? FromTime,
      String? ToTime,
      String? discountType,
      fromTimeType,
      String? toTimeType,
      required bool lifeTime,
      required bool isAllDay}) {
    if (items.isNotEmpty) {
      discountModel.menu.add(CategoryModel(
        fromDate: fromDate ?? '',
        toDate: toDate ?? '',
        lifeTime: lifeTime,
        isAllDay: isAllDay,
        percentageValue: percentageValue ?? '',
        fromTime: FromTime ?? '',
        toTime: ToTime ?? '',
        discountType: discountType ?? '',
        toTimeType: toTimeType ?? '',
        items: items.toList(),
      ));
      items.clear();
      fromTimeHourController.clear();
      fromTimeMintController.clear();
      toTimeMintController.clear();
      toTimeHourController.clear();
    }
    else{print('no data');}
  }

  /// Function to upload images to Firebase and return their URLs
  Future<List<RxString>> uploadImagesToFirebase(List<Uint8List> images) async {
    List<RxString> imageUrls = [];
    List<Uint8List> imagesCopy = List.from(images); // 🔥 Fix: Create a copy

    for (var image in imagesCopy) {
      try {
        String imageUrl = await uploadImageToFirebase("items", image);
        imageUrls.add(imageUrl.obs); // Convert String to RxString
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    return imageUrls;
  }

  Future<void> updateDiscount(discountModel, docID) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Convert model to a Firestore map
      Map<String, dynamic> discountData = discountModel.toMap();

      // Update the document in Firestore
      await firestore
          .collection("restaurants")
          .doc(auth.currentUser!.uid) // Replace with actual restaurant ID
          .collection("MealMenu")
          .doc(docID)
          .update(discountData).then((value) {
        Get.to(() => RestaurantDetailScreen(
          isFromButtonClick: true,
        ));
          },);

      print("Data updated successfully!");
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  /////////frontend
  final TextEditingController offerController = TextEditingController();
  final List<LocationListModel> circleItems3 = [
    LocationListModel(
      timeText: '15:00 to 15:00',
      persentText: '5% off',
    ),
    LocationListModel(
      timeText: '16:00 to 16:00',
      persentText: '15% off',
    ),
    LocationListModel(
      timeText: '14:00 to 14:00',
      persentText: '20% off',
    ),
  ];
}

class LocationListModel {
  final String timeText;
  final String persentText;
  LocationListModel({
    required this.timeText,
    required this.persentText,
  });
}

class ItemController extends GetxController {
  var items = <Map<String, dynamic>>[].obs;
  var images = <XFile>[].obs;
  final offerController = TextEditingController();

  void addItem(String name, String description, String price) {
    if (name.isNotEmpty && description.isNotEmpty && price.isNotEmpty) {
      items.add({
        'name': name,
        'description': description,
        'price': price,
        'images': images.toList(), // Add images list
      });
      images.clear(); // Clear images after adding item
    } else {
      print('Please fill all fields');
    }
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      images.addAll(pickedFiles);
    }
  }
}
