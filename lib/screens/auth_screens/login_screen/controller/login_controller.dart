import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/controllers/filldata_restaurant_controller.dart';
import 'package:restaurant_web_app/main.dart';
import 'package:restaurant_web_app/screens/edit_restaurant_forms.dart';
import 'package:restaurant_web_app/screens/main_screen/main_screen.dart';
import 'package:restaurant_web_app/screens/main_screen/mainscreen_controller/main_controller.dart';
import 'package:restaurant_web_app/widgets/global_functions.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/loading_dialog.dart';

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

  bool validateFields() {
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

  Future<void> logIn() async {
    loadingDialog(message: 'Please wait !!!!', loading: true);

    try {
      await auth
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) async {
        print('restaurants');

        await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(value.user!.uid)
            .get()
            .then((doc) async {
          if (doc.exists) {
           final fillcontroller=Get.put(FillDataRestaurantController());
            fillcontroller.fetchRestaurantData();
            Get.back();
            Get.offAll(() => AdminPanel());
            passwordController.clear();
            emailController.clear();
            Get.snackbar("Login", "Logged in successfully",
                maxWidth: 400, backgroundColor: AppColors.primaryColor);
            await auth.currentUser!.reload();
          } else {
            customAlertDialog2(
              "We Couldn't Find Your Account",
              "This email address is not associated with a Admin account. If you believe you should have access, please contact Support Team.",
            );
          }
        });
      });
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      Get.back();
      switch (error.code) {
        case "invalid-credential":
          customAlertDialog2(
            'INVALID LOGIN CREDENTIALS',
            "The username or password you entered is incorrect. Please check your login information and try again.",
          );
          break;
        case "unknown":
          customAlertDialog2(
            'INVALID LOGIN CREDENTIALS',
            "The username or password you entered is incorrect. Please check your login information and try again.",
          );
          break;
      }
    }
  }
}
