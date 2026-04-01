import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/screens/entry_mode/entry_mode_screen.dart';
import 'package:kaistable_website/screens/home_screen/my_home_screen.dart';
import 'package:kaistable_website/screens/nav_bar/main_screen.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_controller/onboarding_controller.dart';
import 'package:kaistable_website/utils/loading.dart';
import 'package:kaistable_website/widgets/global_functions.dart';

// Controller to manage login functionality, state, and interactions
class LoginController extends GetxController {
  // Text editing controllers for email and password fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observables for managing UI state
  var rememberMe = false.obs; // Observable for "Remember Me" checkbox
  var isPasswordHidden = true.obs; // Observable to toggle password visibility
  bool isRemember = false; // Local variable to track "Remember Me" state

  // Clears the text fields for email and password
  void resetTextFields() {
    emailController.clear();
    passwordController.clear();
  }

  // Checks if "Remember Me" is enabled and retrieves stored email/password
  void checkRememberMe() {
    if (remember_me_pref!.getBool('is_remember_me') == true) {
      emailController.text =
          remember_me_pref!.getString('remember_me_email') ?? '';
      passwordController.text =
          remember_me_pref!.getString('remember_me') ?? '';
    }
    rememberMe.value =
        remember_me_pref?.getBool('is_remember_me') == true ? true : false;
  }

  // Handles user login
  Future<void> login() async {
    // Show a loading dialog while attempting login
    loadingDialog(message: 'Please wait !!', loading: true, height: 150);

    try {
      // Sign in using Firebase Authentication
      await auth
          .signInWithEmailAndPassword(
        email: emailController.value.text,
        password: passwordController.value.text,
      )
          .then((value) async {
        // Update user location data
        await updateUserCityCountry();
        // Fetch current user data
        await getCurrentUserData();

        // update user fcm token by "Modassir"
        FirebaseMessaging.instance.getToken().then((fcmToken) =>
        FirebaseFirestore.instance.collection("users").doc(value.user!.uid /*auth.currentUser!.uid*/).update({"fcmToken": fcmToken}));

        // Close the loading dialog
        Get.back();

        if (currentUserDataModel != null) {
          Get.offAll(()=>EntryModeScreen());
          // Get.offAll(() =>MainScreen());
          // Clear the email and password fields
          emailController.clear();
          passwordController.clear();

          // Reload the current user to ensure updated data is reflected
          await auth.currentUser!.reload();

          // Reset text fields
          resetTextFields();
        } else {
          // If user data is null, show an error dialog
          Get.back();
          loadingDialog(
              message:
                  "Your account was deleted, contact the provider or create new account");
        }
      });
    } on FirebaseAuthException catch (error) {
      // Close the loading dialog
      Get.back();

      // Handle Firebase-specific authentication errors
      switch (error.code) {
        case "invalid-credential":
          loadingDialog(
              isWrongPassword: true,
              padding: 0,
              message:
                  "The username or password you entered is incorrect. Please check your login information and try again.",
              button: true);
          break;
        case "too-many-requests":
          loadingDialog(
              isWrongPassword: true,
              message:
                  "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.",
              button: true);
          break;
        case "network-request-failed":
          loadingDialog(
              isWrongPassword: true,
              message: "Please check internet connection and try again.",
              button: true);
          break;
        default:
          // Handle unexpected errors gracefully
          print("Unhandled error: ${error.code}");
      }
    }
  }

  // Updates the user's city and country in Firestore
  Future<void> updateUserCityCountry() async {
    try {
      OnboardingController onboardingController = Get.find();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid.toString())
          .update({
        'country': onboardingController.selectedCountry.value,
        'city': onboardingController.selectedCity.value,
      });
    } catch (e) {
      // Log any errors that occur during the update
      print('Error $e');
    }
  }
}
