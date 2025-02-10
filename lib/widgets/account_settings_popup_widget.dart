import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/screens/change_password/change_password.dart';
import 'package:restaurant_web_app/screens/home_screen/home_screen.dart';
import 'package:restaurant_web_app/screens/main_screen/main_screen.dart';
import 'package:restaurant_web_app/screens/main_screen/mainscreen_controller/main_controller.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/restaurant_detail_screen.dart';

class AccountSettingsPopupWidget extends StatelessWidget {
  AccountSettingsPopupWidget({super.key});
  final controller = Get.put(MainController());
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        const Text('Account Settings'),
        const Spacer(),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.keyboard_arrow_down_sharp,
            color: AppColors.primaryColor,
          ),
          onSelected: (value) {
            if (value == 'Logout') {
              controller.showLogoutDialog(context); // Show logout dialog
            } else if (value == 'View Restaurant Details') {
              Get.to(
                () => RestaurantDetailScreen(isFromButtonClick: true,),
              );
            } else if (value == 'Change Password') {
              Get.to(
                () => ChangePasswordScreen(),
              );
            } else if (value == 'Home') {
              Get.to(
                () => MainScreen(),
              );
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
                  const SizedBox(width: 16),
                  const Text('Home'),
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
                  const SizedBox(width: 16),
                  const Text('View Restaurant Details'),
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
                  const SizedBox(width: 16),
                  const Text('Change Password'),
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
                  const SizedBox(width: 16),
                  const Text('Logout'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AccountNoAuthPopupWidget extends StatelessWidget {
  AccountNoAuthPopupWidget({super.key});
  final controller = Get.put(MainController());
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        const Text('Account Settings'),
        const Spacer(),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.keyboard_arrow_down_sharp,
            color: AppColors.primaryColor,
          ),
          onSelected: (value) {
            if (value == 'Logout') {
              controller.showLogoutDialog(context); // Show logout dialog
            } else if (value == 'Change Password') {
              Get.to(
                () => ChangePasswordScreen(),
              );
            } else if (value == 'Home') {
              Get.to(
                () => MainScreen(),
              );
            } else {
              controller.selectedMenuItem = value;
              controller.isAddingRestaurant = true;
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
                  const SizedBox(width: 16),
                  const Text('Home'),
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
                  const SizedBox(width: 16),
                  const Text('Change Password'),
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
                  const SizedBox(width: 16),
                  const Text('Logout'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
