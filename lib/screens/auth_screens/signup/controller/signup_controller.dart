import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var rememberMe = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
}
