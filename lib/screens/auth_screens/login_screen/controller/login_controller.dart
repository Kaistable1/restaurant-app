import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/screens/main_screen/main_screen.dart';

import '../../../../constants/colors.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailError = ''.obs;
  final passwordError = ''.obs;

  // Observable for password visibility
  final isPasswordHidden = true.obs;

  // Observable for Remember Me checkbox
  final isRememberMeChecked = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  bool _validateFields() {
    emailError.value = '';
    passwordError.value = '';

    bool isValid = true;

    // Email validation
    if (emailController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      emailError.value = "Please enter a valid email.";
      isValid = false;
    }

    // Password validation
    String password = passwordController.text;
    if (password.isEmpty) {
      passwordError.value = "Password cannot be empty.";
      isValid = false;
    } else if (password.length < 8) {
      passwordError.value = "Password must be at least 8 characters long.";
      isValid = false;
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      passwordError.value =
          "Password must contain at least one uppercase letter.";
      isValid = false;
    } else if (!RegExp(r'[a-z]').hasMatch(password)) {
      passwordError.value =
          "Password must contain at least one lowercase letter.";
      isValid = false;
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      passwordError.value = "Password must contain at least one number.";
      isValid = false;
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      passwordError.value =
          "Password must contain at least one special character.";
      isValid = false;
    }

    return isValid;
  }

  void login() {
    if (_validateFields()) {
      Get.snackbar("Login", "Logged in successfully",
          maxWidth: 400, backgroundColor: AppColors.primaryColor);
      Get.offAll(() => MainScreen());
    }
  }
}
