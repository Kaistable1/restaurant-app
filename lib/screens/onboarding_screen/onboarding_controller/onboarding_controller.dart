import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final selectedCountry = Rx<String?>('Country');
  final selectedCity = Rx<String?>('City');
  final hasError = RxBool(false);
}
