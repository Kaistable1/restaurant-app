import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController =  TextEditingController();
  final passwordController =  TextEditingController();
  var rememberMe = false.obs;
  var isPasswordHidden = true.obs;
}
