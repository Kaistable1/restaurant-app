import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/change_pass/changePassword_dialoge.dart';
import 'package:kaistable_website/screens/favorite_screen/favorite_screen.dart';
import 'package:kaistable_website/screens/home_screen/my_home_screen.dart';
import 'package:kaistable_website/screens/nav_bar/controller/home_controller.dart';
import 'package:kaistable_website/screens/nav_bar/profile.dart';
import 'package:kaistable_website/screens/trending_screen/trending_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../home_screen/notification_screen/notification_screen.dart';
import 'home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // ← ADDED FOR WEB SAFETY

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  int _currentIndex = 0;

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      MyHomeScreen(),
      TrendingScreen(),
      FavoriteScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/images/home_selected.png',
            width: 24, height: 24),
        inactiveIcon: Image.asset('assets/images/home_unselected.png',
            color: AppColors.blackColor, width: 24, height: 24),
        title: "Home",
        activeColorPrimary: AppColors.primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/images/search_selected.png',
            width: 34, height: 34),
        inactiveIcon: Image.asset('assets/images/search_unselected.png',
            color: AppColors.blackColor, width: 25, height: 25),
        title: "Search",
        activeColorPrimary: AppColors.primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.explore, size: 28),
        inactiveIcon:
            Icon(Icons.explore_outlined, size: 25, color: AppColors.blackColor),
        title: "Explore",
        activeColorPrimary: AppColors.primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/images/like_selected.png',
            width: 34, height: 34),
        inactiveIcon: Image.asset('assets/images/like_unselected.png',
            color: AppColors.blackColor, width: 25, height: 25),
        title: "Favorite",
        activeColorPrimary: AppColors.primaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/images/account_selected.png',
            width: 34, height: 34),
        inactiveIcon: Image.asset('assets/images/account_unselected.png',
            color: AppColors.blackColor, width: 25, height: 25),
        title: "Profile",
        activeColorPrimary: AppColors.primaryColor,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();

    // Run native-only init (e.g. FFI, platform channels) only on mobile/desktop
    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // PLACE ANY NATIVE-ONLY CODE HERE
        // Example:
        // final lib = DynamicLibrary.open('native_lib.so');
        // lib.lookup<NativeFunction<...>>('...');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());

    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.whiteColor,
              elevation: 0,
              centerTitle: true,
              title: Image.asset(
                'assets/images/logo.png',
                height: 40,
              ),
              actions: [
                GestureDetector(
                  onTap: () => Get.to(NotificationScreen()),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.2),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.email,
                      color: AppColors.primaryColor,
                      size: 22,
                    ),
                  ),
                ),
                SizedBox(width: 12),
              ],
            )
          : null,
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return homeController.isSpotlightFinish.value == false
              ? HomeScreen()
              : PersistentTabView(
                  context,
                  controller: _controller,
                  screens: _buildScreens(),
                  items: _navBarsItems(),
                  handleAndroidBackButtonPress: true,
                  hideNavigationBarWhenKeyboardAppears: true,
                  popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
                  backgroundColor: AppColors.whiteColor,
                  decoration: NavBarDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    colorBehindNavBar: AppColors.whiteColor.withOpacity(.3),
                  ),
                  isVisible: true,
                  navBarHeight: 60,
                  padding: EdgeInsets.zero,
                  navBarStyle: NavBarStyle.style3,
                  onItemSelected: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                );
        },
      ),
    );
  }
}