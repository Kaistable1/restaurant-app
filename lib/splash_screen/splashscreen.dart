import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/auth_screens/signup/signup_screen.dart';
import 'package:kaistable_website/screens/nav_bar/main_screen.dart';

import '../main.dart';
import '../screens/highlights/highlights_screen.dart';

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

    // Start the timer to navigate based on user state
    Timer(Duration(seconds: 3), () async {
      if (auth.currentUser != null) {
        // User is logged in, go to main screen
        Get.offAll(() => MainScreen());
      } else {
        // User is not logged in
        // Check if it's the first time using the app
        // If hasSeenHighlights is null or false, it's the first time
        bool hasSeenHighlights =
            preferences?.getBool('hasSeenHighlights') ?? false;

        if (!hasSeenHighlights) {
          // First time user - show highlights screen
          Get.offAll(() => HighlightsScreen());
        } else {
          // Returning user - go directly to signup screen
          Get.offAll(() => SignupScreen(
                fromScreen: 'splash',
              ));
        }
      }
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
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Padding(
            padding: const EdgeInsets.all(55.0),
            child: Image.asset('assets/icons/logo.png'),
          ),
        ),
      ),
    );
  }
}
