import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/controllers/filldata_restaurant_controller.dart';
import 'package:restaurant_web_app/main.dart';
import 'package:restaurant_web_app/models/restaurant_owner_model.dart';
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
        print('Checking restaurant owner authentication...');

        // Query restaurantOwner collection by email (not UID)
        final userEmail = value.user!.email;
        if (userEmail == null) {
          Get.back();
          await auth.signOut();
          customAlertDialog2(
            "Error",
            "Unable to retrieve email address. Please try again.",
          );
          return;
        }

        final querySnapshot = await FirebaseFirestore.instance
            .collection('restaurantOwner')
            .where('email', isEqualTo: userEmail)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Restaurant owner found - convert to RestaurantOwnerModel and store globally
          final doc = querySnapshot.docs.first;
          final ownerModel = RestaurantOwnerModel.fromFirestore(doc);
          currentRestaurantOwner.value = ownerModel;

          print('✅ Restaurant owner data loaded: ${ownerModel.email}');
          print('✅ Restaurant: ${ownerModel.restaurantData.resName}');
          print('✅ Document ID: ${doc.id}');

          final fillcontroller = Get.put(FillDataRestaurantController());
          fillcontroller.fetchRestaurantData();
          Get.back();
          Get.offAll(() => AdminPanel());
          passwordController.clear();
          emailController.clear();
          Get.snackbar("Login", "Logged in successfully",
              maxWidth: 400, backgroundColor: AppColors.primaryColor);
          await auth.currentUser!.reload();

          print(
              '✅ Restaurant owner logged in successfully: ${ownerModel.email}');
        } else {
          // Not a restaurant owner
          Get.back();
          await auth.signOut(); // Sign out the user
          customAlertDialog2(
            "We Couldn't Find Your Account",
            "This email address is not associated with a restaurant owner account. If you believe you should have access, please contact the Support Team.",
          );
          print(
              '❌ No restaurant owner account found for email: $userEmail');
        }
      });
    } on FirebaseAuthException catch (error) {
      print('❌ Firebase Auth Error: ${error.code} - ${error.message}');
      Get.back();
      switch (error.code) {
        case "invalid-credential":
          customAlertDialog2(
            'INVALID LOGIN CREDENTIALS',
            "The username or password you entered is incorrect. Please check your login information and try again.",
          );
          break;
        case "user-not-found":
          customAlertDialog2(
            'USER NOT FOUND',
            "No account exists with this email address. Please check your email or contact support.",
          );
          break;
        case "wrong-password":
          customAlertDialog2(
            'INCORRECT PASSWORD',
            "The password you entered is incorrect. Please try again.",
          );
          break;
        case "user-disabled":
          customAlertDialog2(
            'ACCOUNT DISABLED',
            "This account has been disabled. Please contact support for assistance.",
          );
          break;
        case "too-many-requests":
          customAlertDialog2(
            'TOO MANY ATTEMPTS',
            "Too many failed login attempts. Please try again later or reset your password.",
          );
          break;
        case "unknown":
          customAlertDialog2(
            'INVALID LOGIN CREDENTIALS',
            "The username or password you entered is incorrect. Please check your login information and try again.",
          );
          break;
        default:
          customAlertDialog2(
            'LOGIN ERROR',
            "An error occurred during login: ${error.message ?? 'Unknown error'}. Please try again.",
          );
      }
    } catch (e) {
      print('❌ Unexpected error during login: $e');
      Get.back();
      customAlertDialog2(
        'UNEXPECTED ERROR',
        "An unexpected error occurred. Please try again later.",
      );
    }
  }
}
