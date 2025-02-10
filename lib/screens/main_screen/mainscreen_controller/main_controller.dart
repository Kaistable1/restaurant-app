import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/main.dart';
import 'package:restaurant_web_app/screens/auth_screens/login_screen/login_screen.dart';
import 'package:restaurant_web_app/universal_models/restaurant_model.dart';
import 'package:restaurant_web_app/utils/responsive.dart';
import 'package:restaurant_web_app/widgets/round_button.dart';

import '../../change_password/change_password.dart';
import '../../home_screen/home_screen.dart';
import '../../restaurant_detail_screen/restaurant_detail_screen.dart';

class MainController extends GetxController {
  ///backend

  Rx<RestaurantModel> restaurantModel = RestaurantModel.initialize().obs;
  Future<void> fetchRestaurantData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('restaurants')
          .doc(auth.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        restaurantModel.value = RestaurantModel.fromDocumentSnapshot(snapshot);
      }
    } catch (e) {
      print("Error fetching restaurant data: $e");
    }
  }

  ///frontend
  String? selectedMenuItem = 'Home'; // Default selection set to Home
  bool isAddingRestaurant = false;

  // Map to hold widgets for each menu option
  final Map<String, Widget> menuPages = {
    'Home': HomeScreen(),
    'View Restaurant Details': RestaurantDetailScreen(),
    'Change Password': ChangePasswordScreen(),
    'Logout': Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logout.png', width: 100),
          const SizedBox(height: 16),
          const Text('Logout Page'),
        ],
      ),
    ),
  };
  showLogoutDialog(BuildContext context) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async =>
            false, // Prevent dialog from being dismissed on back press
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Center(
            child: Container(
              width: Get.width * 0.6, // Increased width for larger screens
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Confirm Logout',
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context)
                          ? 14
                          : 18, // Adjusted font size
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context)
                          ? 12
                          : 16, // Adjusted font size
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Spread buttons evenly across the screen
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: CustomButton(
                          title: "Cancel",
                          textStyle: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: Responsive.isMobile(context) ? 12 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                          backgroundColor: AppColors.primaryColor,
                          borderRadius: 8,
                          width: Responsive.isMobile(context)
                              ? 80
                              : 100, // Responsive button width
                          height:
                              40, // Adjusted button height for better clickability
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: CustomButton(
                          title: "Logout",
                          textStyle: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: Responsive.isMobile(context) ? 12 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                          backgroundColor: AppColors.primaryColor,
                          borderRadius: 8,
                          width: Responsive.isMobile(context)
                              ? 80
                              : 100, // Responsive button width
                          height:
                              40, // Adjusted button height for better clickability
                          onPressed: () {
                            auth.signOut().then((value) {
                              Get.offAll(() =>
                                  const LoginScreen()); // Close the dialog
                            });

                            // Add logout logic here (e.g., navigate to login screen)
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
