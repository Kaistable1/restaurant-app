import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:get/get.dart';
import 'package:savrly/models/event.dart';
import 'package:savrly/widgets/global_functions.dart';

class AddEventController extends GetxController {
  var uploadedImages = <Uint8List>[].obs;

  final eventNameController = TextEditingController();
  final locationController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final urlController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();
  RxString selectEvent = 'Concert'.obs;
  RxList<String> events = <String>['Concert', 'Festival'].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Pick images for web
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

  // Remove image from the list
  void removeImage(int index) {
    if (index >= 0 && index < uploadedImages.length) {
      uploadedImages.removeAt(index);
    }
  }

  // Add event to Firestore
  addEvent() async {
    try {
      loadingDialog();
      // Step 1: Upload images to Firebase Storage
      List<String> imageUrls = await uploadImagesToFirebase(uploadedImages);

      // Step 2: Create Event object
      Event event = Event(
        docId: '',
        eventName: eventNameController.text,
        eventType: selectEvent.value,
        location: locationController.text,
        date: dateController.text,
        time: timeController.text,
        phoneNumber: phoneNumberController.text,
        url: urlController.text,
        description: descriptionController.text,
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
        city: cityController.text.trim(),
        country: countryController.text.trim(),
      );

      // Step 3: Save event to Firestore
      DocumentReference docRef =
          await _firestore.collection('events').add(event.toMap());

      // Step 4: Update the event with docId
      await docRef.update({'docId': docRef.id});

      // Step 5: Clear form after successful submission
      clearForm();
      Get.back();
      Get.snackbar(
        'Success',
        'Event added successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add event: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return null;
    }
  }

  // Clear form fields and reset state
  void clearForm() {
    eventNameController.clear();
    locationController.clear();
    phoneNumberController.clear();
    urlController.clear();
    dateController.clear();
    timeController.clear();
    descriptionController.clear();
    selectEvent.value = 'Concert';
    uploadedImages.clear();
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    eventNameController.dispose();
    locationController.dispose();
    phoneNumberController.dispose();
    urlController.dispose();
    dateController.dispose();
    timeController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
