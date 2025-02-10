import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditRestaurantController extends GetxController {
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
