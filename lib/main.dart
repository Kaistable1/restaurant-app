import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kaistable_website/screens/home_screen/home_screen.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_screen.dart';
import 'package:kaistable_website/splash_screen/splashscreen.dart';
import 'package:kaistable_website/widgets/top_bar_widget.dart';

import 'firebase_options.dart';
import 'screens/home_screen/my_home_screen.dart';
bool myFlag = false;
Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
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
      // scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
      //   PointerDeviceKind.invertedStylus,
      //   PointerDeviceKind.mouse,
      //   PointerDeviceKind.stylus,
      //   PointerDeviceKind.touch,
      //   PointerDeviceKind.trackpad,
      //   PointerDeviceKind.unknown,
      // }),
      debugShowCheckedModeBanner: false,
      title: 'Kaistable',


        //home: SplashScreen(),
        //home:MyHomeScreen(),
      home:SplashScreen()
    );
  }
}
