import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/dialoges/reset_dialog.dart';
import 'package:kaistable_website/screens/auth_screens/login/login_screen.dart';
import 'package:kaistable_website/utils/loading.dart';

// Controller to handle the "Forgot Password" functionality
class ForgotPassController extends GetxController {
  // Controller for the email input field
  final emailController = TextEditingController();

  // Method to send a password reset email
  Future<void> sendForgetEmail() async {
    try {
      // Show a loading dialog while the email is being processed
      loadingDialog(message: 'Please wait!', loading: true, height: 150);

      // Check if the provided email exists in the "users" collection in Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .where('userEmail', isEqualTo: emailController.text)
          .get()
          .then((value) async {
        // If no documents are found, show an error dialog
        if (value.docs.isEmpty) {
          Get.back(); // Close the loading dialog
          print(value);
          loadingDialog(
              message: "The Email doesn't Exist.",
              button: true,
              height: 150,
              padding: 0);
        } else {
          // If the email exists, send a password reset email using Firebase Auth
          FirebaseAuth.instance
              .sendPasswordResetEmail(email: emailController.text)
              .then((value) {
            // Clear the email field and close the loading dialog
            emailController.clear();
            Get.back();
            print('Reset email sent successfully');

            // Show a dialog box indicating that the reset email was sent
            dialogueBox(
              text:
                  'A reset link has been emailed to you. Please also check your spam.',
              onPressed: () async {
                // Navigate to the Login Screen after the dialog is dismissed
                Get.offAll(() => LoginScreen());
              },
              color: AppColors.primaryColor,
            );
          }).onError((error, stackTrace) {
            // Log any errors encountered while sending the reset email
            print(error.toString());
          });
        }
      });
    } catch (e) {
      // Catch and log any unexpected errors during the process
      print('Error $e');
    }
  }
}
