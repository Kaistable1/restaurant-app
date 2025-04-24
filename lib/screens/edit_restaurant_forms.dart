import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/controllers/filldata_restaurant_controller.dart';
import 'package:restaurant_web_app/screens/app_info/about_app/about_app.dart';
import 'package:restaurant_web_app/screens/app_info/contact_us/contact_us.dart';
import 'package:restaurant_web_app/screens/app_info/privacy_policy/privacy_policy.dart';
import 'package:restaurant_web_app/screens/app_info/terms_and_condition/terms_and_condition.dart';
import 'package:restaurant_web_app/screens/change_password/change_password.dart';
import 'package:restaurant_web_app/screens/drawer/drawer_screen.dart';
import 'package:restaurant_web_app/screens/restaurant_management/add_retaurants/add_restaurants_screen.dart';
import 'package:restaurant_web_app/screens/restaurant_management/view_restaurant_details/view_restaurant_details.dart';
import '../../constants/app_colors.dart';
import '../../controllers/drawer_controller.dart';

class AdminPanel extends StatelessWidget {
  final DrawerControllerX controller = Get.put(DrawerControllerX());
  final contorller = Get.put(FillDataRestaurantController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: MediaQuery.of(context).size.width < 800
          ? AppBar(
              backgroundColor: bgColor,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: primaryColor),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            )
          : null,
      drawer: MediaQuery.of(context).size.width < 800 ? CustomDrawer() : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width >= 800) CustomDrawer(),
          Expanded(child: Obx(() => _getScreen(controller))),
        ],
      ),
    );
  }

  Widget _getScreen(DrawerControllerX controller) {
    Widget screen;
    if (controller.selectedScreen.value == 0) {
      screen = ViewRestaurantDetails();
    } else if (controller.selectedScreen.value == 1) {
      screen = PrivacyPolicy();
    } else if (controller.selectedScreen.value == 2) {
      screen = AboutApp();
    } else if (controller.selectedScreen.value == 3) {
      screen = TermsAndCondition();
    } else if (controller.selectedScreen.value == 4) {
      screen = ChangePasswordScreen();
    } else if (controller.selectedScreen.value == 5) {
      screen = AddRestaurantsScreen();
    } else {
      screen = ViewRestaurantDetails();
    }
    return screen;
  }
}
