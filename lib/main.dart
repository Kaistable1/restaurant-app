import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kaistable_website/screens/auth_screens/login/login_screen.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_1.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_10.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_12.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_14.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_3.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_4.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_5.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_6.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_7.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_8.dart';
import 'package:kaistable_website/screens/general_preferences/screens_general/preference_9.dart';

import 'package:kaistable_website/screens/onboarding_screen/onboarding_screen.dart';
import 'package:kaistable_website/screens/profile_screens/profile_screen.dart';
import 'package:kaistable_website/splash_screen/splashscreen.dart';
import 'package:kaistable_website/widgets/top_bar_widget.dart';

import 'firebase_options.dart';
import 'landing_screen.dart';
import 'screens/home_screen/my_home_screen.dart';

bool myFlag = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // scrollBehavior:const MaterialScrollBehavior().copyWith(dragDevices:{
      //   PointerDeviceKind.invertedStylus,
      //   PointerDeviceKind.mouse,
      //   PointerDeviceKind.stylus,
      //   PointerDeviceKind.touch,
      //   PointerDeviceKind.trackpad,
      //   PointerDeviceKind.unknown,
      // }),
      debugShowCheckedModeBanner: false,
      title: 'Kaistable',
      home: SplashScreen(),
      // home:  OnboardingScreen (),
      // home:MyHomeScreen(countryName: 'New York',)
    );
  }
}
 //