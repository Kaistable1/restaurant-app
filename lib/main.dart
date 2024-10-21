import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kaistable_website/screens/home_screen/home_screen.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_screen.dart';
import 'package:kaistable_website/widgets/top_bar_widget.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return   GetMaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.touch,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.unknown,
      }),
      debugShowCheckedModeBanner: false,
      title: 'Kaistable Website',

      home: TopBarWidget(),
      // home: OnboardingScreen(),
    );
  }
}