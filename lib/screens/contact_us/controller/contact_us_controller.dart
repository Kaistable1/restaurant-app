import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactUsController extends GetxController{
  final contactingUs = Rx<String?>("Tell us why you're contacting us");
  final hasError = RxBool(false);
  TextEditingController emailController = TextEditingController();
  TextEditingController messagreController = TextEditingController();
}