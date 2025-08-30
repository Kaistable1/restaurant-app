import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/auth_screens/login/login_screen.dart';
import 'package:kaistable_website/screens/nav_bar/main_screen.dart';

import '../main.dart';
import '../screens/home_screen/my_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    // Create a Tween for scaling the image
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Start the animation
    _controller.forward();

    // Start the timer to navigate to the OnboardingScreen
    Timer(Duration(seconds: 3), () {
      // if(auth.currentUser == null){
      //   Get.offAll(() => LoginScreen());
      // }else {
        Get.offAll(() => MainScreen());
      // }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Padding(
            padding: const EdgeInsets.all(55.0),
            child: Image.asset('assets/images/botomsheet_logo.png'),
          ),
        ),
      ),
    );
  }
}
