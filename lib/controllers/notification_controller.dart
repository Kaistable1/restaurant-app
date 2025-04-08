import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Rx<File?> selectedImage = Rx<File?>(null);
  Rx<Uint8List?> selectedWebImage = Rx<Uint8List?>(null);

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false, // single image only
      withData: true,
    );

    if (result != null) {
      if (kIsWeb) {
        selectedWebImage.value = result.files.first.bytes!;
      } else {
        selectedImage.value = File(result.files.single.path!);
      }
    }
  }

  void removeImage() {
    selectedImage.value = null;
    selectedWebImage.value = null;
  }
  RxString facilitiesFilter = ''.obs;
  RxString atmosphereFilter = ''.obs;
  RxString dietaryPreferencesFilter = ''.obs;
  RxString stateFilter = ''.obs;



  RxList<String> facilities =
      <String>['Free WiFi', 'Parking', 'High chairs', 'Drive-thru', 'Takeout'].obs;
  RxList<String> atmosphere =
      <String>['Cozy', 'Casual dinning', 'Private dining rooms', 'Outdoor seating', 'Bar/lounge area'].obs;
  RxList<String> dietaryPreferences =
      <String>['Vegetarian', 'Vegan', 'Gluten-Free', 'Dairy-Free', 'Keto-Friendly'].obs;
  RxList<String> state =
      <String>['New York', 'Loss Angeles',].obs;



  final RxList<Map<String, String>> users = [
    {'name': 'Darlene Robertson', 'image': 'assets/images/darlene.png'},
    {'name': 'Liam Smith', 'image': 'assets/images/liam.png'},
    {'name': 'Ava Johnson', 'image': 'assets/images/ava.png'},
  ].obs;

  // Track the selected user index
  var selectedUserIndex = (-1).obs; // -1 means no selection initially

  // Method to select a user
  void selectUser(int index) {
    selectedUserIndex.value = index;
  }



  var selectedUsers = <int>[].obs; // List to store indices of selected users

  // Method to toggle user selection
  void toggleUserSelection(int index) {
    if (selectedUsers.contains(index)) {
      selectedUsers.remove(index); // Deselect if already selected
    } else {
      selectedUsers.add(index); // Select if not already selected
    }
  }

  // Check if a user is selected
  bool isUserSelected(int index) {
    return selectedUsers.contains(index);
  }






}
