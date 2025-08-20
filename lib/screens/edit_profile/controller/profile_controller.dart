import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/usermodel.dart';
import 'package:kaistable_website/utils/loading.dart';
import 'package:kaistable_website/widgets/global_functions.dart';

// Controller for handling user profile-related functionality
class ProfileController extends GetxController {
  // Text controllers for profile information
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observables to manage the visibility of password fields
  var isPasswordHidden =
      true.obs; // Toggles for current password field visibility
  var isNewPasswordHidden =
      true.obs; // Toggles for new password field visibility
  var isConfirmPasswordHidden =
      true.obs; // Toggles for confirm password field visibility

  @override
  void onInit() {
    // Called when the controller is initialized, fetches user data
    getData();
    super.onInit();
  }

  /// Image Picker
  var imagePath = ''.obs; // Observable for storing the image path
  Uint8List? imageBytes; // Stores the byte data of the picked image

  // Function to pick an image from the given image source (camera or gallery)
  pickImage(RxString imagePath, ImageSource imageSource) async {
    Get.back(); // Close any open dialogs or menus
    final ImagePicker imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: imageSource);

    if (image == null) {
      // If no image is selected, clear the image path
      imagePath.value = "";
    } else {
      // If an image is selected, store its path and read its bytes
      imagePath.value = image.path;
      imageBytes = await image.readAsBytes();
      update(); // Notify listeners to update the UI
    }
  }

  // Function to fetch and populate user data into the text controllers
  getData() async {
    try {
      UserModel? user =
          currentUserDataModel?.value; // Fetch the current user data
      if (user != null) {
        // Populate text controllers with user data
        userNameController.text = user.username.text;
        emailController.text = user.userEmail.text;
      }
    } catch (e) {
      // Log any errors that occur
      print('Error $e');
    }
  }

  // Function to update the user's profile
  updateProfile() async {
    try {
      // Show a loading dialog while updating the profile
      loadingDialog(message: 'Please wait!', height: 150, loading: true);
      String imgUrl = '';
      if (imagePath.value != '') {
// Upload the selected image to Firebase and get its URL
        imgUrl = await uploadImageToFirebase('profile', imageBytes!);
      }

      if (imagePath.value != '') {
// Update the user document in the Firestore database with the new data
        await FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser?.uid)
            .update({
          'userImage': imgUrl, // Update the profile image URL
          'username': userNameController.text, // Update the username
        });
      } else {
        // Update the user document in the Firestore database with the new data
        await FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser?.uid)
            .update({
          'username': userNameController.text, // Update the username
        });
      }

      // Fetch the updated user data to reflect changes
      getCurrentUserData();

      // Close the loading dialog
      Get.back();

      // Show a success message to the user
      Get.snackbar('SAVRLY', 'Profile updated successfully!');
    } catch (e) {
      // Handle any errors and close the loading dialog
      Get.back();
      print('Error update profile $e');
    }
  }
}
