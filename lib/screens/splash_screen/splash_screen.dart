import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../main.dart';
import 'onboarding_screen/onboarding_screen.dart';

void main() {
  runApp(MyApp());
}

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Get.off(() => OnboardingScreen(),
          transition: Transition.fade, duration: Duration(milliseconds: 500));
    });

    return Scaffold(
      backgroundColor: white, // Full black background
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // Your splash image
          width: MediaQuery.of(context).size.width * 0.9, // Adjust size
        ),
      ),
    );
  }
}
