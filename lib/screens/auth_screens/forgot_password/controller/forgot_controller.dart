import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/widgets/no_internet_dialog.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/loading_dialog.dart';
import '../../../../widgets/round_button.dart';
import '../../login_screen/login_screen.dart';

class ForgotController extends GetxController {
  // Controller for the email field
  final emailController = TextEditingController();

  // Observable for email validation error
  final emailError = ''.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  /// Method to handle password reset
  void reset() {
    if (_validateFields()) {
      forgotPass
        ();
      // _showResetDialog();
    }
  }

  /// Method to validate form fields
  bool _validateFields() {
    emailError.value = ''; // Clear previous errors
    if (emailController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      emailError.value = "Please enter a valid email.";
      return false;
    }
    return true;
  }
  ///forgot password function
  forgotPass() async {
    loadingDialog(message: 'Please wait!!', loading: true);
    final connecitivityResult = await (Connectivity().checkConnectivity());

    if (connecitivityResult == ConnectivityResult.none) {
      Get.back();
      showNoInternetDialog();
    } else {
      await FirebaseFirestore.instance
          .collection("restaurants")
          .where('resEmail', isEqualTo: emailController.text)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          Get.back();
          print(value);
          loadingDialog(message: "The Email doesn't Exists.", button: true);
        } else {
          FirebaseAuth.instance
              .sendPasswordResetEmail(email: emailController.text,)
              .then((value) {
                Get.back();
            _showResetDialog();
            // dialogueBox(
            //     text:
            //     'A reset link has been emailed to you.Please also check your spam.',
            //     color: primaryColor,
            //     onPressed: () {
            //       forgotEmailController.clear();
            //       Get.off(() => LogIn());
            //     });
            emailController.clear();
            print('sent successfully');
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        }
      });
    }
  }
  /// Method to show the reset confirmation dialog
  void _showResetDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Center(
            child: Container(
              width: Get.width * 0.4,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/send_icon.png',
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'A reset link has been emailed to you.\nPlease also check your spam.',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Material(
                    color: Colors.transparent,
                    child: CustomButton(
                      title: "Ok",
                      textStyle: const TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: AppColors.primaryColor,
                      borderRadius: 8,
                      width: 240,
                      onPressed: () => Get.offAll(() => LoginScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
