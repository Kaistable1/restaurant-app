
// import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';

class MenuSubScreenController extends GetxController{
  final specialConditionsController = TextEditingController();
  // Store uploaded images
  var uploadedImages = <Uint8List>[].obs;
  // Checkbox states
  var isFoodMenuSelected = false.obs;
  var isDrinkMenuSelected = false.obs;

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



  // Get uploaded images
  List<Uint8List> getUploadedImages() {
    return uploadedImages.toList();
  }
}