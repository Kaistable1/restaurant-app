import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/utils/loading.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  RxBool iscurrentPasswordVisible = false.obs;
  RxBool isNewPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  void resetTextFields() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  changePassword({required email}) async {
    try {
      loadingDialog(message: 'Please wait....', loading: true, height: 150);
      var cred = EmailAuthProvider.credential(
          email: email, password: currentPasswordController.text);
      await auth.currentUser!.reauthenticateWithCredential(cred).then((value) {
        auth.currentUser!
            .updatePassword(confirmPasswordController.text)
            .then((value) async {
          Get.back();
          Get.back();
          loadingDialog(
              message: 'Password Changed Successfully.',
              button: true,
              isFromForgotPassword: true);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(auth.currentUser!.uid)
              .update({'password': newPasswordController.text}).then((value) {
            print('password updated');
          });
          resetTextFields();
        });
      }).onError((error, stackTrace) {
        Get.back();
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
          print('Error -------m ${error.toString()}');
          loadingDialog(
            message: 'Something Went Wrong, Please, try again.',
            button: true,
          );
        }
        print(error.toString());
        loadingDialog(
          message: 'Something Went Wrong, Please, try again.',
          button: true,
        );
      });
    } catch (e) {
      print('Error ---------------- $e');
    }
  }
}
