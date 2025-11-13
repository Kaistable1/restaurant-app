import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/utils/loading.dart';

// Controller for handling the change password functionality
class ChangePasswordController extends GetxController {
  // Text controllers for user input fields
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable variables to manage the visibility of password fields
  RxBool iscurrentPasswordVisible =
      false.obs; // For current password visibility toggle
  RxBool isNewPasswordVisible = false.obs; // For new password visibility toggle
  RxBool isConfirmPasswordVisible =
      false.obs; // For confirm password visibility toggle

  // Function to clear all input fields after the operation is complete
  void resetTextFields() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  // Function to change the password
  // Takes an email as a parameter to reauthenticate the user
  changePassword({required email}) async {
    try {
      // Show a loading dialog while the process is running
      loadingDialog(message: 'Please wait....', loading: true, height: 150);

      // Create a credential object using the current email and password
      var cred = EmailAuthProvider.credential(
          email: email, password: currentPasswordController.text);

      // Reauthenticate the user with the provided credentials
      await auth.currentUser!.reauthenticateWithCredential(cred).then((value) {
        // If reauthentication is successful, update the user's password
        auth.currentUser!
            .updatePassword(confirmPasswordController.text)
            .then((value) async {
          // Close the loading dialogs
          Get.back();
          Get.back();

          // Show a success dialog to the user
          loadingDialog(
              message: 'Password Changed Successfully.',
              button: true,
              isFromForgotPassword: true);

          // Update the password in the Firestore database
          await FirebaseFirestore.instance
              .collection('users')
              .doc(auth.currentUser!.uid)
              .update({'password': newPasswordController.text}).then((value) {
            print('password updated');
          });

          // Reset the input fields after the process is complete
          resetTextFields();
        });
      }).onError((error, stackTrace) {
        // Close the loading dialog in case of an error
        Get.back();

        // Handle specific error cases and show appropriate messages to the user
        if (error.toString() ==
            "[firebase_auth/INVALID_LOGIN_CREDENTIALS] An internal error has occurred. [ INVALID_LOGIN_CREDENTIALS ]") {
          loadingDialog(
            message: 'Your current password is incorrect. Please, try again.',
            button: true,
          );
        } else if (error.toString() ==
            "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") {
          loadingDialog(
            message: 'Your current password is incorrect. Please, try again.',
            button: true,
          );
        } else {
          // Handle any other errors
          print('Error -------m ${error.toString()}');
          loadingDialog(
            message: 'Something Went Wrong, Please, try again.',
            button: true,
          );
        }

        // Log the error for debugging
        print(error.toString());
        loadingDialog(
          message: 'Something Went Wrong, Please, try again.',
          button: true,
        );
      });
    } catch (e) {
      // Log any unexpected errors
      print('Error ---------------- $e');
    }
  }
}
