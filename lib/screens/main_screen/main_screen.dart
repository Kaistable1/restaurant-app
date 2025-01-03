import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/screens/home_screen/home_screen.dart';
import 'package:restaurant_web_app/screens/main_screen/mainscreen_controller/main_controller.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(builder: (controller) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          toolbarHeight: 110,
          elevation: 1,
          title: Image.asset(
            'assets/images/appbar_logo.png',
            width: 200,
            height: 70,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 230,
                height: 59,
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Text('Account Settings'),
                      Spacer(),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: AppColors.primaryColor,
                        ),
                        onSelected: (value) {
                          if (value == 'Logout') {
                            controller.showLogoutDialog(
                                context); // Show logout dialog
                          } else {
                            controller.selectedMenuItem = value;
                            controller.isAddingRestaurant = false;
                            controller.update();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'Home',
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/home.png',
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 16),
                                Text('Home'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'View Restaurant Details',
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/resturant_detail.png',
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 16),
                                Text('View Restaurant Details'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Change Password',
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/change_password.png',
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 16),
                                Text('Change Password'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Logout',
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/logout.png',
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 16),
                                Text('Logout'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: controller.menuPages[controller.selectedMenuItem] ??
            HomeScreen(), // Display HomeScreen by default
      );
    });
  }
}
