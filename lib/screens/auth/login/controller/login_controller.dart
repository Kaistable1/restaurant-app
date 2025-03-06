import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main_screen.dart';

class LoginController extends GetxController {
  late TextEditingController emailController, passwordController;

  var isPasswordVisible = false.obs;
  var isCheck = false.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  RxInt selectedContainerIndex =
      (-1).obs; // -1 means no container is selected initially

  // Method to toggle the state of selected container by index
  void toggleContainerSelection(int index) {
    selectedContainerIndex.value =
        selectedContainerIndex.value == index ? -1 : index;
  }

  @override
  void onInit() {
    super.onInit();

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void submitForm() {
    _validateForm();
  }

  void _validateForm() {
    emailError.value = '';
    passwordError.value = '';

    emailError.value = emailController.text.isEmpty
        ? 'Please enter your email'
        : !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                .hasMatch(emailController.text)
            ? 'Please enter a valid email'
            : '';

    passwordError.value = passwordController.text.isEmpty
        ? 'Please enter your password'
        : passwordController.text.length < 8 ||
                !RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%\^&\*])[A-Za-z\d!@#\$%\^&\*]{8,}$')
                    .hasMatch(passwordController.text)
            ? 'Password must be at least 8 characters and include uppercase, lowercase, digit, and special character'
            : '';

    // If there are no errors, proceed with form submission (e.g., API call, etc.)
    if (emailError.isEmpty && passwordError.isEmpty) {
      loginUser();
    }
  }

  //make a functiuon for login user
  loginUser() async {
    try {
      Get.dialog(Center(child: CircularProgressIndicator()));
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Get.back();
      Get.offAll(() => MainScreen());
      Get.snackbar(
        'Loged In',
        'Congratulations! You have successfully logged',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    }
  }
}
