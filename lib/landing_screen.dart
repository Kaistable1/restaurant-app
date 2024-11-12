// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kaistable_website/screens/about_app/about_app.dart';
// import 'package:kaistable_website/screens/contact_us/contact_us.dart';
// import 'package:kaistable_website/screens/favorite_screen/favorite_screen.dart';
// import 'package:kaistable_website/screens/home_screen/home_controller/home_cusiness_controller.dart';
// import 'package:kaistable_website/screens/home_screen/home_controller/home_filter_controller.dart';
// import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
// import 'package:kaistable_website/screens/home_screen/home_controller/home_new_controller.dart';
// import 'package:kaistable_website/screens/home_screen/home_controller/home_recently_viewed_controller.dart';
// import 'package:kaistable_website/screens/home_screen/home_controller/home_theme_controller.dart';
// import 'package:kaistable_website/screens/home_screen/home_controller/home_trending_controller.dart';
// import 'package:kaistable_website/screens/home_screen/home_screen.dart';
// import 'package:kaistable_website/screens/home_screen/my_home_screen.dart';
// import 'package:kaistable_website/screens/home_screen/recently_viewed/recently_viewed.dart';
//
// import '../../constants/app_colors.dart';
//
//
// class LandingScreen extends StatefulWidget {
//   @override
//   _MyHomeScreenState createState() => _MyHomeScreenState();
// }
//
// class _MyHomeScreenState extends State<LandingScreen> {
//   final HomeLocationController controller = Get.put(HomeLocationController());
//   final HomeThemeController themeController = Get.put(HomeThemeController());
//   final HomeRecentlyViewedController recentlyViewedController = Get.put(HomeRecentlyViewedController());
//   final HomeCusinessController cusinessController = Get.put(HomeCusinessController());
//   final HomeTrendingController trendingController = Get.put(HomeTrendingController());
//   final HomeNewController newController = Get.put(HomeNewController());
//   final HomeFilterController filterController = Get.put(HomeFilterController());
//   final scrollController = ScrollController();
//
//   int _selectedIndex = 0;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   List<Widget> _screens = [
//     MyHomeScreen(),
//     FavoriteScreen(),
//     RecentlyViewed(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     bool isLargeScreen = screenWidth > 1400;
//
//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//
//       body: _screens[_selectedIndex], // Show selected screen here
//       bottomNavigationBar: ClipRRect(
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20.0),
//           topRight: Radius.circular(20.0),
//         ),
//         child: Container(
//           height: 77,
//           decoration: BoxDecoration(
//             // You can set color or add shadow here if necessary
//           ),
//           child: Stack(
//             children: [
//               BottomNavigationBar(
//                 backgroundColor: Colors.white,
//                 currentIndex: _selectedIndex,
//                 onTap: _onItemTapped,
//                 selectedItemColor: AppColors.primaryColor,
//                 unselectedItemColor: AppColors.darkGrey,
//                 type: BottomNavigationBarType.fixed,
//                 items: [
//                   BottomNavigationBarItem(
//                     icon: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Image.asset(
//                           _selectedIndex == 0
//                               ? 'assets/images/home_selected.png'
//                               : 'assets/images/home_unselected.png',
//                           height: 24,
//                           width: 24,
//                         ),
//                         SizedBox(height: 6),
//                       ],
//                     ),
//                     label: 'Home',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Image.asset(
//                           _selectedIndex == 1
//                               ? 'assets/images/favorite_selected.png'
//                               : 'assets/images/favorite_unselected.png',
//                           height: 24,
//                           width: 24,
//                         ),
//                         SizedBox(height: 6),
//                       ],
//                     ),
//                     label: 'Favorites',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Image.asset(
//                           _selectedIndex == 2
//                               ? 'assets/images/profile_selected.png'
//                               : 'assets/images/profile_unselected.png',
//                           height: 24,
//                           width: 24,
//                         ),
//                         SizedBox(height: 6),
//                       ],
//                     ),
//                     label: 'Profile',
//                   ),
//                 ],
//               ),
//               // Positioned line that appears only for the Home item
//               if (_selectedIndex == 0)
//                 Positioned(
//                   left: 0,
//                   right: 0,
//                   top: 0,  // Position the line above the BottomNavigationBarItem
//                   child: Container(
//                     height: 2,
//                     width:56 ,// Line height
//                     color: AppColors.primaryColor, // Line color
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//
//
//
//     );
//   }
//
//   Widget _buildDrawerItem(String title, int index) {
//     bool isSelected = _selectedIndex == index;
//     return Column(
//       children: [
//         ListTile(
//           title: Text(
//             title,
//             style: TextStyle(
//               decoration: _selectedIndex == index
//                   ? TextDecoration.underline
//                   : TextDecoration.none,
//               decorationThickness: 1.5,
//               decorationColor: AppColors.primaryColor,
//               fontSize: 14,
//               fontFamily: 'Nunito-Bold',
//               color: isSelected ? AppColors.primaryColor : AppColors.textColor,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           onTap: () => _onItemTapped(index),
//         ),
//       ],
//     );
//   }
// }
//
// // Separate widget to avoid recursion in MyHomeScreen
//
