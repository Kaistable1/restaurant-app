import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:savrly/auth/login/login_screen.dart';
import 'package:savrly/constants/app_colors.dart';
import 'package:savrly/controllers/login_controller.dart';
import 'package:savrly/firebase_options.dart';
import 'package:savrly/screens/dashboard/notification_screen/notifications_screen/notification_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? preferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  preferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return GetMaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.touch,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.unknown,
      }),
      title: 'Savrly',
      debugShowCheckedModeBanner: false,
      home:
          Obx(() => controller.isLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : LoginScreen()),
    );
  }
}
