import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:savrly_data_entry_app/constants/app_colors.dart';
import 'package:savrly_data_entry_app/screens/history/history_screen.dart';
import 'package:savrly_data_entry_app/screens/profile/profile_screen.dart';
import 'package:savrly_data_entry_app/screens/restaurants/restaurant_list_screen.dart';

import 'home/home_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final int initialIndex =
      Get.arguments ?? 0; // Get the argument (default to 0)
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: Get.arguments ?? 0);

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      RestaurantListScreen(
        cityName: 'new york',
      ),
      HistoryScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home, color: blackColor, size: 25),
        inactiveIcon: Icon(Icons.home_outlined, color: blackColor, size: 20),
        title: 'Home',
        activeColorPrimary: blackColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.restaurant, color: blackColor, size: 25),
        inactiveIcon:
            Icon(Icons.restaurant_outlined, color: blackColor, size: 20),
        title: 'Restaurants',
        activeColorPrimary: blackColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.list, color: blackColor, size: 25),
        inactiveIcon:
            Icon(Icons.list_alt_outlined, color: blackColor, size: 20),
        title: 'History',
        activeColorPrimary: blackColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person, color: blackColor, size: 25),
        inactiveIcon: Icon(Icons.person_outline, color: blackColor, size: 20),
        title: 'Log Out',
        activeColorPrimary: blackColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      decoration: NavBarDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Light shadow
            blurRadius: 10, // Soft blur effect
            spreadRadius: 2, // Spread the shadow
            offset: Offset(0, 4), // Moves shadow downward
          ),
        ],
      ),
      controller: _controller, // Now controlled by Get.arguments
      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(8),
      isVisible: true,
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.style6,
    );
  }
}
