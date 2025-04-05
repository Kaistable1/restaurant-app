import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/app_colors.dart';

class ProfileController extends GetxController {

  Rx<Uint8List?> webImageBytes = Rx<Uint8List?>(null);
  Rx<io.File?> pickedImage = Rx<io.File?>(null);

  Future<void> pickImageFromPC() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true, // crucial for web
    );

    if (result != null) {
      if (kIsWeb) {
        webImageBytes.value = result.files.first.bytes;
      } else {
        pickedImage.value = io.File(result.files.single.path!);
      }
    }
  }
  RxInt editProfileView = 0.obs;
  var selectedTab = 0.obs;

  void switchTab(int index) {
    selectedTab.value = index;
  }

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isCurrentPasswordVisible = false.obs; // Password visibility state
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }


  var isNewPasswordVisible = false.obs; // Password visibility state
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  var isConfirmPasswordVisible = false.obs; // Password visibility state
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }


  bool validatePasswordsMatch() {
    String current = currentPasswordController.text.trim();
    String newPass = newPasswordController.text.trim();
    String confirm = confirmPasswordController.text.trim();

    if (newPass == current) {
      Get.snackbar("Error", "New password must not be the same as current password",
          backgroundColor: primaryColor, colorText: Colors.white, maxWidth: 400);
      return false;
    }

    if (confirm != newPass) {
      Get.snackbar("Error", "New and confirm password must match",
          backgroundColor: primaryColor, colorText: Colors.white, maxWidth: 400);
      return false;
    }

    return true;
  }

}
