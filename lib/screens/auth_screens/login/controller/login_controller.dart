import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/screens/home_screen/my_home_screen.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_controller/onboarding_controller.dart';
import 'package:kaistable_website/utils/loading.dart';
import 'package:kaistable_website/widgets/global_functions.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var rememberMe = false.obs;
  var isPasswordHidden = true.obs;
  bool isRemember = false;

  void resetTextFields() {
    emailController.clear();
    passwordController.clear();
  }

  checkRememberMe() {
    if (remember_me_pref!.getBool('is_remember_me') == true) {
      emailController.text =
          remember_me_pref!.getString('remember_me_email') ?? '';
      passwordController.text =
          remember_me_pref!.getString('remember_me') ?? '';
    }
    rememberMe.value =
        remember_me_pref?.getBool('is_remember_me') == true ? true : false;
  }

  Future login() async {
    loadingDialog(message: 'Please wait !!', loading: true, height: 150);

    try {
      await auth
          .signInWithEmailAndPassword(
        email: emailController.value.text,
        password: passwordController.value.text,
      )
          .then((value) async {
        await getCurrentUserData();
        Get.back();

        if (currentUserDataModel != null) {
          final onboradingContorller = Get.put(OnboardingController());
          Get.offAll(() => MyHomeScreen(
                countryName: onboradingContorller.selectedCountry.value,
              ));
          emailController.clear();
          passwordController.clear();
          await auth.currentUser!.reload();
          resetTextFields();
        } else {
          Get.back();
          loadingDialog(
              message:
                  "Your account was deleted, contact the provider or create new account");
        }
      });
    } on FirebaseAuthException catch (error) {
      Get.back();
      print(error.toString());
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
      }
    }
  }
}
