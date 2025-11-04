import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/models/restaurant_owner_model.dart';
import 'package:restaurant_web_app/models/resaturant_model.dart';
import 'package:restaurant_web_app/widgets/global_functions.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/loading_dialog.dart';

class SignUpController extends GetxController {
  final ownerNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final ownerNameError = ''.obs;
  final emailError = ''.obs;
  final phoneError = ''.obs;
  final passwordError = ''.obs;
  final imageError = ''.obs;

  final isPasswordHidden = true.obs;
  final selectedImage = Rx<Uint8List?>(null);

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> pickImage() async {
    try {
      imageError.value = '';
      Uint8List? imageBytes = await getImage();
      if (imageBytes != null) {
        selectedImage.value = imageBytes;
      }
    } catch (e) {
      imageError.value = 'Failed to pick image';
      print('Error picking image: $e');
    }
  }

  bool validateFields() {
    bool isValid = true;

    // Clear previous errors
    ownerNameError.value = '';
    emailError.value = '';
    phoneError.value = '';
    passwordError.value = '';
    imageError.value = '';

    // Validate owner name
    if (ownerNameController.text.trim().isEmpty) {
      ownerNameError.value = 'Owner name is required';
      isValid = false;
    }

    // Validate email
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    // Validate phone number
    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Phone number is required';
      isValid = false;
    } else if (phoneController.text.trim().length < 10) {
      phoneError.value = 'Please enter a valid phone number';
      isValid = false;
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }

    // Validate image (optional but recommended)
    if (selectedImage.value == null) {
      imageError.value = 'Please select a profile image';
      isValid = false;
    }

    return isValid;
  }

  Future<void> signUp() async {
    loadingDialog();

    try {
      // Create Firebase Auth user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      String userId = userCredential.user!.uid;

      // Upload image if selected
      String imageUrl = '';
      if (selectedImage.value != null) {
        try {
          imageUrl = await uploadImageToFirebase(
              'restaurantOwner', selectedImage.value!);
        } catch (e) {
          print('Error uploading image: $e');
          // Continue without image if upload fails
        }
      }

      // Create restaurant data with defaults
      RestaurantModel restaurantData = RestaurantModel.initialize();
      restaurantData.docID = userId;
      restaurantData.resEmail = emailController.text.trim();
      restaurantData.phoneNo = phoneController.text.trim();
      restaurantData.password = passwordController.text;

      // Create restaurant owner document
      RestaurantOwnerModel ownerModel = RestaurantOwnerModel(
        docID: userId,
        contact: phoneController.text.trim(),
        email: emailController.text.trim(),
        img: imageUrl,
        password: passwordController.text,
        restaurantData: restaurantData,
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('restaurantOwner')
          .doc(userId)
          .set(await ownerModel.toMap());

      Get.back(); // Close loading dialog
      Get.back(); // Go back to login screen

      Get.snackbar(
        'Success',
        'Account created successfully! Please login.',
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );

      // Clear form
      ownerNameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      selectedImage.value = null;
    } on FirebaseAuthException catch (e) {
      Get.back(); // Close loading dialog

      String errorMessage = 'Failed to create account';
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered';
          emailError.value = errorMessage;
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          emailError.value = errorMessage;
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak';
          passwordError.value = errorMessage;
          break;
        default:
          errorMessage = 'Failed to create account: ${e.message}';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to create account: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      print('Error signing up: $e');
    }
  }

  @override
  void onClose() {
    ownerNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

