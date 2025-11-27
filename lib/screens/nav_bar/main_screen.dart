import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/ask_kai/savrly_ai_view.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/home_screen_new.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/discover_page.dart';

import 'package:kaistable_website/screens/nav_bar/profile.dart';
import 'package:kaistable_website/screens/nav_bar/controller/home_controller.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/discover_controller.dart';
import 'package:kaistable_website/screens/nav_bar/controller/search_controller.dart';

import '../../main.dart';
import '../../streams/views/streams_view.dart';

class MainScreen extends StatefulWidget {
  final int? initialTabIndex; // 0 for Home, 1 for Ask Kai
  
  MainScreen({super.key, this.initialTabIndex});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // List of screens for the bottom navigation bar
  List<Widget> _buildScreens() {
    return [
      const HomeScreenNew(),
      SavrlyAIView(),
      DiscoverListsPage(fromHome: false),
      // RestaurantsPage(fromHome: false),
      VideosListView(fromHome: false),
      // SavedRestaurantsPage(),
      ProfileScreen(),
    ];
  }

  // List of screens when splash is active (only HomeScreenNew)
  List<Widget> _buildSplashScreen() {
    return [
      const HomeScreenNew(),
      SavrlyAIView(),
      DiscoverListsPage(fromHome: false),
      // RestaurantsPage(fromHome: false),
      VideosListView(fromHome: false),
      // SavedRestaurantsPage(),
      ProfileScreen(),
    ];
  }

  // Bottom navigation bar items
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/images/icons8-home (2).png',
            width: 24, height: 24),
        title: "Home",
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: AppColors.blackColor,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/images/chat_selected.png',
            color: AppColors.primaryColor, width: 24, height: 24),
        inactiveIcon: Image.asset('assets/images/chat_unselected.png',
            color: AppColors.blackColor, width: 24, height: 24),
        title: "Ask Kai",
        activeColorPrimary: AppColors.primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/images/icons8-car (2) (2).png',
            width: 34, height: 34),
        title: "Discover",
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: AppColors.blackColor,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          'assets/images/streams_navbar.png',
          width: 36,
          height: 36,
          color: Colors.grey[300],
        ),
        title: "Streams",
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: AppColors.blackColor,
      ),
      // PersistentBottomNavBarItem(
      //   icon: Image.asset('assets/images/oui_app-saved-objects.png', width: 34, height: 34),
      //   title: "Saved",
      //   activeColorPrimary: AppColors.primaryColor,
      //   inactiveColorPrimary: AppColors.blackColor,
      // ),
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/images/icons8-account (1).png',
            width: 34, height: 34),
        title: "Profile",
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: AppColors.blackColor,
      ),
    ];
  }

  // Bottom navigation bar items for splash (only Home)
  List<PersistentBottomNavBarItem> _splashNavBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/images/icons8-home (2).png',
            width: 24, height: 24),
        title: "Home",
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: AppColors.blackColor,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/images/chat_selected.png',
            color: AppColors.primaryColor, width: 24, height: 24),
        inactiveIcon: Image.asset('assets/images/chat_unselect.png',
            color: AppColors.blackColor, width: 24, height: 24),
        title: "Ask Kai",
        activeColorPrimary: AppColors.primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/images/icons8-car (2) (2).png',
            width: 34, height: 34),
        title: "Discover",
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: AppColors.blackColor,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/images/streams_navbar.png',
            width: 34, height: 34),
        title: "Streams",
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: AppColors.blackColor,
      ),
      // PersistentBottomNavBarItem(
      //   icon: Image.asset('assets/images/oui_app-saved-objects.png', width: 34, height: 34),
      //   title: "Saved",
      //   activeColorPrimary: AppColors.primaryColor,
      //   inactiveColorPrimary: AppColors.blackColor,
      // ),
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/images/icons8-account (1).png',
            width: 34, height: 34),
        title: "Profile",
        activeColorPrimary: AppColors.primaryColor,
        inactiveColorPrimary: AppColors.blackColor,
      ),
    ];
  }

  @override
  void initState() {
    navbarController = PersistentTabController(
      initialIndex: widget.initialTabIndex ?? 0,
    );

    super.initState();
    // Initialize controllers
    Get.put(HomeController());
    Get.put(FilterController());
    Get.put(HomeLocationController());
    Get.put(RestaurantController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return PersistentTabView(
            context,
            controller: navbarController,
            screens: controller.isSpotlightFinish.value
                ? _buildScreens()
                : _buildSplashScreen(),
            items: controller.isSpotlightFinish.value
                ? _navBarsItems()
                : _splashNavBarItems(),
            handleAndroidBackButtonPress: true,
            hideNavigationBarWhenKeyboardAppears: true,
            popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
            backgroundColor: AppColors.whiteColor,
            decoration: const NavBarDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              colorBehindNavBar: AppColors.whiteColor,
            ),
            navBarHeight: 60,
            padding: EdgeInsets.zero,
            navBarStyle: NavBarStyle.style3,
            onItemSelected: (index) {
              // Unfocus any active text field when switching tabs to prevent keyboard from auto-opening
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {}); // Update UI if needed
            },
          );
        },
      ),
    );
  }
}
