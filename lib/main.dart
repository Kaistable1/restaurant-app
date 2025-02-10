import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:restaurant_web_app/screens/add_restaurant/edit_restaurant/edit_resturant.dart';
import 'package:restaurant_web_app/screens/auth_screens/login_screen/login_screen.dart';
import 'package:restaurant_web_app/screens/main_screen/main_screen.dart';
import 'package:restaurant_web_app/screens/main_screen/mainscreen_controller/main_controller.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/restaurant_detail_screen.dart';
import 'package:restaurant_web_app/testing.dart';
import 'package:restaurant_web_app/universal_models/restaurant_model.dart';
import 'package:restaurant_web_app/widgets/global_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyD-aHLAypbdgpbqlSNDl_5ofc257kKQPTI",
        authDomain: "restaurantwebsite-4bdd8.firebaseapp.com",
        projectId: "restaurantwebsite-4bdd8",
        storageBucket: "restaurantwebsite-4bdd8.firebasestorage.app",
        messagingSenderId: "404399548475",
        appId: "1:404399548475:web:782d48d2dfe1e4604dd41e",
        measurementId: "G-4ETNQB0PV4"),
  );

  await getCurrentUserData();
  runApp(MyApp());


}
//auth main
FirebaseAuth auth = FirebaseAuth.instance;
var currentUserDataModel = Rxn<RestaurantModel>(); // Use Rxn for nullable objects

DocumentSnapshot<Map<String, dynamic>>? currentRestaurant;
class MyApp extends StatelessWidget {
  // basda
  @override
  Widget build(BuildContext context) {


    return GetMaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.touch,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.unknown,
      }),
      title: 'Restaurant Web App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // home: ItemListScreen(),
      // home: EditRestaurantScreen(),
      home:auth.currentUser != null? MainScreen():LoginScreen(),
      // home:auth.currentUser != null? EditRestaurantScreen():LoginScreen(),
      debugShowCheckedModeBanner: false, // Make sure the screen is here.
    );
  }
}
//
