// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:kaistable_website/constants/app_colors.dart';
// import 'package:kaistable_website/screens/about_app/about_app.dart';
// import 'package:kaistable_website/screens/contact_us/contact_us.dart';
// import 'package:kaistable_website/screens/home_screen/home_screen.dart';
// import 'package:kaistable_website/screens/privacy_policy/privacy_policy.dart';
// import 'package:kaistable_website/screens/terms_and_condition/terms_and_condition.dart';
//
// import '../screens/restaurant_detail_screens/restaurant_detail_screen.dart';
// import '../screens/favorite_screen/favorite_screen.dart';
// import '../screens/home_screen/cuisiness_viewall/cuisines_view_all.dart';
// import '../screens/home_screen/location_pages/location_screen.dart';
// import '../screens/home_screen/new_view_all/new_viewall.dart';
// import '../screens/home_screen/recently_viewed/recently_viewed.dart';
// import '../screens/home_screen/resturants_filter/resturants_viewall.dart';
// import '../screens/home_screen/trendind_all/trending_view_all.dart';
// import '../utils/responsive.dart';
// import 'bottom_container.dart';
//
// class TopBarWidget extends StatefulWidget {
//   const TopBarWidget({super.key});
//
//   @override
//   _TopBarWidgetState createState() => _TopBarWidgetState();
// }
//
// class _TopBarWidgetState extends State<TopBarWidget> {
//   int _selectedIndex = 0;
//   final List<Widget> _screens = [];
//   final List<String> _titles = [
//     'Home',
//     'Favorites',
//     'Terms and conditions',
//     'Privacy policy',
//     'About app',
//     'Contact us',
//     'Recently viewed',
//     'Location',
//     'Restaurant details',
//     'Cuisines',
//     'Trending',
//     'New',
//     'Restaurants'
//   ];
//
//   final scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _screens.addAll([
//       HomeScreen(onNavigate: _onItemTapped, scrollcontroller: scrollController), // Pass the callback here
//       FavoriteScreen( onNavigate: _onItemTapped, scrollcontroller: scrollController,),
//        TermsAndCondition(onNavigate: _onItemTapped,),
//        PrivacyPolicy(onNavigate: _onItemTapped),
//        AboutApp(onNavigate: _onItemTapped),
//       ContactUs(onNavigate: _onItemTapped, scrollcontroller: scrollController),
//       RecentlyViewed(onNavigate: _onItemTapped, ),
//       LocationScreen(onNavigate: _onItemTapped,),
//       RestaurantDetailScreen(),
//       CuisinesViewAll(onNavigate: _onItemTapped,  ),
//       TrendingViewAll(onNavigate: _onItemTapped,),
//       NewViewall(onNavigate: _onItemTapped,),
//       ResturantsViewall(onNavigate: _onItemTapped),
//     ]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       appBar: Responsive.isMobile(context)
//           ? AppBar(
//         centerTitle: true,
//         backgroundColor: AppColors.bgColor,
//         iconTheme: const IconThemeData(color: AppColors.primaryColor),
//         // Show the back button if we're on certain screens
//         leading: (_selectedIndex != 0)
//             ? Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Container(
//             height: 16,
//             width: 16,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 3,
//                   offset: const Offset(0, 1),
//                 ),
//               ],
//             ),
//             child: GestureDetector(
//               onTap: () {
//                 _onItemTapped(0); // Navigate back to the home screen
//               },
//               child: Icon(Icons.arrow_back, size: 18),
//             ),
//           ),
//         )
//             : null, // Default leading icon (drawer icon) if on Home Screen
//         title: Text(
//           _titles[_selectedIndex], // Display the title of the selected screen
//           style: const TextStyle(
//             fontSize: 17,
//             color: AppColors.primaryColor,
//             fontWeight: FontWeight.w700,
//             fontFamily: 'Nunito-Bold',
//           ),
//         ),
//         actions: [
//           const SizedBox(width: 20),
//           _selectedIndex == 0 // Only show on the home screen
//               ? Row(
//             children: [
//               InkWell(
//                 onTap: () {
//                   _onItemTapped(7);
//                 },
//                 child: const Image(
//                   image: AssetImage('assets/images/location_icon.png'),
//                   height: 12,
//                   width: 12,
//                 ),
//               ),
//               const SizedBox(width: 1),
//               InkWell(
//                 onTap: () {
//                   _onItemTapped(7);
//                 },
//                 child: Text(
//                   'USA.Los Vegas',
//                   style: TextStyle(
//                     color: AppColors.textColor,
//                     fontWeight: Responsive.isMobile(context)
//                         ? FontWeight.w800
//                         : Responsive.isTablet(context)
//                         ? FontWeight.w600
//                         : FontWeight.w600,
//                     fontFamily: 'Nunito-Regular',
//                     fontSize: Responsive.isMobile(context)
//                         ?9
//                         : Responsive.isTablet(context)
//                         ? 14
//                         : 16,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 20),
//             ],
//           )
//               : const SizedBox.shrink(), // Show nothing if not on home screen
//         ],
//
//       )
//           : null,
//       drawer: _selectedIndex == 8 ? null : _buildDrawer(), // Disable drawer in RestaurantDetailScreen
//       body: SingleChildScrollView(
//         controller: scrollController,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _screens[_selectedIndex],
//             SizedBox(
//               height: Responsive.isMobile(context)
//                   ? 60
//                   : Responsive.isTablet(context)
//                   ? 100
//                   : 50,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   Widget _buildDrawer() {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             decoration: const BoxDecoration(
//               color: AppColors.primaryColor,
//             ),
//             child: Center(
//               child: Image.asset(
//                 'assets/images/topbar_logo.png',
//                 height: 200,
//                 width: 200,
//               ),
//             ),
//           ),
//           _buildDrawerItem('Home', 0),
//           _buildDrawerItem('Favorites', 1),
//           _buildDrawerItem('Terms and conditions', 2),
//           _buildDrawerItem('Privacy policy', 3),
//           _buildDrawerItem('About app', 4),
//           _buildDrawerItem('Contact us', 5),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDrawerItem(String title, int index) {
//     return ListTile(
//       title: Text(
//         title,
//         style: TextStyle(
//           decoration: _selectedIndex == index
//               ? TextDecoration.underline
//               : TextDecoration.none,
//           decorationThickness: 1.5,
//           decorationColor: AppColors.primaryColor,
//           fontSize: 14,
//           fontFamily: 'Nunito-Bold',
//           color: _selectedIndex == index ? AppColors.primaryColor : AppColors.textColor,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       onTap: () {
//         setState(() {
//           _selectedIndex = index;
//         });
//         Navigator.pop(context); // Close the drawer after selection
//       },
//     );
//   }
// }
//
