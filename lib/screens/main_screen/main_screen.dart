import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/main.dart';
import 'package:restaurant_web_app/screens/home_screen/home_screen.dart';
import 'package:restaurant_web_app/screens/main_screen/mainscreen_controller/main_controller.dart';
import 'package:restaurant_web_app/widgets/global_functions.dart';

import '../../widgets/account_settings_popup_widget.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    controller.fetchRestaurantData();
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
                  child: Obx(() {
                    final resModel = currentUserDataModel.value;
                    if (resModel == null || resModel.zipCode.text.isEmpty) {
                      return AccountNoAuthPopupWidget();
                    }
                    return AccountSettingsPopupWidget();
                  }),
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
