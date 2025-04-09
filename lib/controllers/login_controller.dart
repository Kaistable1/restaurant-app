import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subAdminEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController subAdminPasswordController = TextEditingController();
  final TextEditingController forgotEmailController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isSubAdminPasswordVisible = false.obs;


  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  void toggleSubAdminPasswordVisibility() {
    isSubAdminPasswordVisible.value = !isSubAdminPasswordVisible.value;
  }
}
