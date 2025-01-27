import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/screens/auth_screens/login_screen/login_screen.dart';
import 'package:restaurant_web_app/screens/main_screen/main_screen.dart';
import 'package:restaurant_web_app/widgets/loading_dialog.dart';

class ChangePasswordController extends GetxController {
  var currentPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;

  // Reactive variables for obscure text state for each field
  var currentPasswordObscure = true.obs;
  var newPasswordObscure = true.obs;
  var confirmPasswordObscure = true.obs;

  // Toggle visibility methods for each password field
  void toggleVisibilityForCurrentPassword() {
    currentPasswordObscure.value = !currentPasswordObscure.value;
  }

  void toggleVisibilityForNewPassword() {
    newPasswordObscure.value = !newPasswordObscure.value;
  }

  void toggleVisibilityForConfirmPassword() {
    confirmPasswordObscure.value = !confirmPasswordObscure.value;
  }

  // Add your validation and save methods here
  String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your current password';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != newPassword.value) {
      return 'Passwords do not match';
    }
    return null;
  }

  void savePassword(GlobalKey<FormState> formKey) {
    if (formKey.currentState?.validate() ?? false) {
      Get.to(() => MainScreen());
    }
  }

  //
  //
  // changePassword({required email}) async {
  //   loadingDialog(message: 'Please wait....', loading: true);
  //   print(currentPassword);
  //   print(email);
  //   var cred = EmailAuthProvider.credential(
  //       email: email, password: currentPasswordController.text);
  //   await auth.currentUser!.reauthenticateWithCredential(cred).then((value) {
  //     print('======');
  //     auth.currentUser!
  //         .updatePassword(confirmPasswordController.text)
  //         .then((value) async {
  //       Get.back();
  //       loadingDialog(
  //           message: 'Password Changed Successfully.',
  //           button: true,
  //           isFromForgotPassword: true);
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(auth.currentUser!.uid)
  //           .update({'password': confirmPasswordController.text}).then((value) {
  //         print('password updated');
  //       });
  //       clearChangePasswordController();
  //     });
  //   }).onError((error, stackTrace) {
  //     Get.back();
  //     if (error.toString() ==
  //         "[firebase_auth/INVALID_LOGIN_CREDENTIALS] An internal error has occurred. [ INVALID_LOGIN_CREDENTIALS ]") {
  //       loadingDialog(
  //           message: 'Your current password is incorrect. Please, try again.',
  //           button: true);
  //     } else if (error.toString() ==
  //         "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") {
  //       loadingDialog(
  //           message: 'Your current password is incorrect. Please, try again.',
  //           button: true);
  //     } else {
  //       print(error.toString());
  //       loadingDialog(
  //         message: 'Something Went Wrong, Please, try again.',
  //       );
  //     }
  //     print('222222222222');
  //     // Utils().toastMessage(error.toString());
  //     print(error.toString());
  //   });
  // }
}
