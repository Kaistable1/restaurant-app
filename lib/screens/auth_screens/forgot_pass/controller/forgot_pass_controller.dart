import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/dialoges/reset_dialog.dart';
import 'package:kaistable_website/screens/auth_screens/login/login_screen.dart';
import 'package:kaistable_website/utils/loading.dart';

class ForgotPassController extends GetxController {
  final emailController = TextEditingController();

  sendForgetEmail() async {
    try {
      loadingDialog(message: 'Please wait!', loading: true, height: 150);
      await FirebaseFirestore.instance
          .collection("users")
          .where('userEmail', isEqualTo: emailController.text)
          .get()
          .then(
        (value) async {
          if (value.docs.isEmpty) {
            Get.back();
            print(value);
            loadingDialog(
                message: "The Email doesn't Exists.",
                button: true,
                height: 150,
                padding: 0);
          } else {
            FirebaseAuth.instance
                .sendPasswordResetEmail(email: emailController.text)
                .then((value) {
              emailController.clear();
              Get.back();
              print('sent successfully');
              dialogueBox(
                text:
                    'A reset link has been emailed to you.Please also check your spam.',
                onPressed: () async {
                  Get.offAll(() => LoginScreen());
                },
                color: AppColors.primaryColor,
              );
            }).onError((error, stackTrace) {
              print(error.toString());
            });
          }
        },
      );
    } catch (e) {
      print('Error $e');
    }
  }
}
