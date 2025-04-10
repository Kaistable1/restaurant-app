import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:savrly/screens/admin/admin_panel.dart';
import 'package:savrly/screens/sub_admin_dashboard/sub_admin_dashboard_screen.dart';
import 'package:savrly/screens/sub_admin_panel/sub_admin_panel.dart';

import 'auth/login/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Savrly',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
