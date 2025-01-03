import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/screens/auth_screens/login_screen/login_screen.dart';
import 'package:restaurant_web_app/screens/main_screen/main_screen.dart';

class ChangePasswordController extends GetxController {
  var currentPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;

  // Reactive variables for obscure text state for each field
  var currentPasswordObscure = true.obs;
  var newPasswordObscure = true.obs;
  var confirmPasswordObscure = true.obs;

  // Toggle visibility methods for each password field
  void toggleVisibilityForCurrentPassword() {
    currentPasswordObscure.value = !currentPasswordObscure.value;
  }

  void toggleVisibilityForNewPassword() {
    newPasswordObscure.value = !newPasswordObscure.value;
  }

  void toggleVisibilityForConfirmPassword() {
    confirmPasswordObscure.value = !confirmPasswordObscure.value;
  }

  // Add your validation and save methods here
  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your current password';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != newPassword.value) {
      return 'Passwords do not match';
    }
    return null;
  }

  void savePassword(GlobalKey<FormState> formKey) {
    if (formKey.currentState?.validate() ?? false) {
      Get.to(() => MainScreen());
    }
  }
}
