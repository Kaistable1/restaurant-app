import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/usermodel.dart';
import 'package:kaistable_website/splash_screen/splashscreen.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool myFlag = false;
final auth = FirebaseAuth.instance;
SharedPreferences? preferences;
SharedPreferences? remember_me_pref;
Rx<UserModel>? currentUserDataModel;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    await getCurrentUserData();
    await requestLocationPermission();
  } on FirebaseAuthException catch (e) {
    print('Error: ${e.code} - ${e.message}');
  } catch (e) {
    print('Unhandled error: $e');
  }
  preferences = await SharedPreferences.getInstance();
  remember_me_pref = await SharedPreferences.getInstance();
  // preferences?.clear();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

RxBool showcaseInProgress = false.obs;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(
              min(MediaQuery.of(context).textScaleFactor, 1.0))),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kaistable',
        home: SplashScreen(),
      ),
    );
  }
}
//
