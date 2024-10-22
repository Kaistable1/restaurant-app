import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/about_app/about_app.dart';
import 'package:kaistable_website/screens/contact_us/contact_us.dart';
import 'package:kaistable_website/screens/home_screen/home_screen.dart';
import 'package:kaistable_website/screens/privacy_policy/privacy_policy.dart';
import 'package:kaistable_website/screens/terms_and_condition/terms_and_condition.dart';

import '../screens/detail_screens/restaurant_detail_screen.dart';
import '../screens/favorite_screen/favorite_screen.dart';
import '../screens/home_screen/cuisiness_viewall/cuisines_view_all.dart';
import '../screens/home_screen/location_pages/location_screen.dart';
import '../screens/home_screen/new_view_all/new_viewall.dart';
import '../screens/home_screen/recently_viewed/recently_viewed.dart';
import '../screens/home_screen/resturants_filter/resturants_viewall.dart';
import '../screens/home_screen/trendind_all/trending_view_all.dart';
import '../utils/responsive.dart';
import 'bottom_container.dart';

class TopBarWidget extends StatefulWidget {
  const TopBarWidget({super.key});

  @override
  _TopBarWidgetState createState() => _TopBarWidgetState();
}

class _TopBarWidgetState extends State<TopBarWidget> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [];
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HomeScreen(onNavigate: _onItemTapped, scrollcontroller: scrollController,), // Pass the callback here
      FavoriteScreen(scrollcontroller: scrollController,onNavigate: _onItemTapped),
      const TermsAndCondition(),
      const PrivacyPolicy(),
      const AboutApp(),
      ContactUs(),
      RecentlyViewed(onNavigate: _onItemTapped, scrollcontroller: scrollController,),
      LocationScreen(onNavigate: _onItemTapped, scrollcontroller: scrollController,),
      RestaurantDetailScreen(onNavigate: _onItemTapped),
      CuisinesViewAll(onNavigate: _onItemTapped, scrollcontroller: scrollController,),
      TrendingViewAll(onNavigate: _onItemTapped, scrollcontroller: scrollController,),
      NewViewall(onNavigate: _onItemTapped, scrollcontroller: scrollController,),
      ResturantsViewall(onNavigate: _onItemTapped)
    ]);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      // Add a drawer for mobile views
      appBar: Responsive.isMobile(context)
          ? AppBar(
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        title: GestureDetector(
          onTap: (){
            _onItemTapped(0);


          },
          child: Image.asset(
            'assets/images/topbar_logo.png',
            height: 35,
          ),
        ),
        actions: [
          Row(
            children: [
              const Image(
                  image: AssetImage('assets/images/location_icon.png'),
                  height: 12,
                  width:12
              ),
              const SizedBox(width: 3),
              GestureDetector(
                onTap: (){
                  _onItemTapped(7);


                },
                child: Text(
                  'USA.Los Vegas',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontWeight: Responsive.isMobile(context)
                        ? FontWeight.w800
                        : Responsive.isTablet(context)
                        ? FontWeight.w600
                        : FontWeight.w600,
                    fontFamily: 'Nunito-Regular',
                    fontSize: Responsive.isMobile(context)
                        ? 8
                        : Responsive.isTablet(context)
                        ? 14
                        : 16,
                  ),
                ),
              ),
              const SizedBox(width: 20,),
            ],
          ),
        ],
      )
          : null,
      drawer: Responsive.isMobile(context) ? _buildDrawer() : null,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!Responsive.isMobile(context)) _buildTopBar(context),
            _screens[_selectedIndex],
            SizedBox(
                height: Responsive.isMobile(context)
                    ? 60
                    : Responsive.isTablet(context)
                        ? 100
                        : 120),
            BottomContainer(onNavigate: _onItemTapped, scrollcontroller:scrollController ,),
          ],
        ),
      )
    );
  }

  Widget _buildTopBar(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(
        //     width: Responsive.isMobile(context)
        //         ? 8
        //         : Responsive.isTablet(context)
        //         ? 10
        //         : 10),
        Container(
          height: Responsive.isMobile(context)
              ? 50
              : Responsive.isTablet(context)
                  ? 70
                  : 90,
          // padding: EdgeInsets.all(Responsive.isMobile(context)
          //     ? 4
          //     : Responsive.isTablet(context)
          //         ? 6
          //         : 9),
          color: AppColors.bgColor,
          child: Row(
            mainAxisAlignment: Responsive.isMobile(context)
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceEvenly,
            children: [
              // SizedBox(
              //     width: Responsive.isMobile(context)
              //         ? 50
              //         : Responsive.isTablet(context)
              //             ? 15
              //             : 20),
              GestureDetector(
                onTap: () {
                  _onItemTapped(0);
                },
                child: Image(
                  image: const AssetImage('assets/images/topbar_logo.png'),
                  height: Responsive.isMobile(context)
                      ? 22
                      : Responsive.isTablet(context)
                          ? 35
                          : isLargeScreen
                              ? 100
                              : 43,
                  width: Responsive.isMobile(context)
                      ? 50
                      : Responsive.isTablet(context)
                          ? 90
                          : isLargeScreen
                              ? 180
                              : 120,
                ),
              ),
              SizedBox(
                  width: Responsive.isMobile(context)
                      ? 8
                      : Responsive.isTablet(context)
                          ? 20
                          : 70),
              _buildNavItem('Home', 0),
              _buildNavItem('Favorites', 1),
              _buildNavItem('Terms and Condition', 2),
              _buildNavItem('Privacy Policy', 3),
              _buildNavItem('About App', 4),
              _buildNavItem('Contact Us', 5),
              SizedBox(
                  width: Responsive.isMobile(context)
                      ? 8
                      : Responsive.isTablet(context)
                          ? 10
                          : 50),
              Row(
                children: [
                  Image(
                    image: const AssetImage('assets/images/location_icon.png'),
                    height: Responsive.isMobile(context)
                        ? 12
                        : Responsive.isTablet(context)
                            ? 16
                            : 22,
                    width: Responsive.isMobile(context)
                        ? 12
                        : Responsive.isTablet(context)
                            ? 16
                            : 22,
                  ),
                  const SizedBox(width: 3),
                  GestureDetector(
                    onTap: () {
                      _onItemTapped(7);


                    },
                    child: Text(
                      'USA.Los Vegas',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: Responsive.isMobile(context)
                            ? FontWeight.w800
                            : Responsive.isTablet(context)
                                ? FontWeight.w600
                                : FontWeight.w600,
                        fontFamily: 'Nunito-Regular',
                        fontSize:  Responsive.isMobile(context)
                            ? 8
                            : Responsive.isTablet(context)
                            ? 12
                            : 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Center(
              child: Image.asset(
                'assets/images/topbar_logo.png',
                height: 200,
                width: 200,
              ),
            ),
          ),
          _buildDrawerItem('Home', 0),
          _buildDrawerItem('Favorites', 1),
          _buildDrawerItem('Terms and Condition', 2),
          _buildDrawerItem('Privacy Policy', 3),
          _buildDrawerItem('About App', 4),
          _buildDrawerItem('Contact Us', 5),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, int index) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          decoration: _selectedIndex == index ||
                  (_selectedIndex == 6 && index == 0) ||
                  (_selectedIndex == 7 && index == 0) ||
                  (_selectedIndex == 8 && index == 0)||
              (_selectedIndex == 9 && index == 0)||
              (_selectedIndex == 10 && index == 0)||
              (_selectedIndex == 11 && index == 0)||
              (_selectedIndex == 12 && index == 0)
              ? TextDecoration.underline
              : TextDecoration.none,
          decorationThickness: 1.5,
          decorationColor: AppColors.primaryColor,
          fontSize: 14,
          fontFamily: 'Nunito-Bold',
          color: _selectedIndex == index ||
                  (_selectedIndex == 6 && index == 0) ||
                  (_selectedIndex == 7 && index == 0) ||
                  (_selectedIndex == 8 && index == 0)||
              (_selectedIndex == 9 && index == 0)||
              (_selectedIndex == 10 && index == 0)||
              (_selectedIndex == 11 && index == 0)||
              (_selectedIndex == 12 && index == 0)
              ? AppColors.primaryColor
              : AppColors.textColor,
          fontWeight: _selectedIndex == index ||
                  (_selectedIndex == 6 && index == 0) ||
                  (_selectedIndex == 8 && index == 0)||
              (_selectedIndex == 9 && index == 0)||
              (_selectedIndex == 10 && index == 0)||
              (_selectedIndex == 11 && index == 0)||
              (_selectedIndex == 12 && index == 0)
              ? FontWeight.w700
              : FontWeight.w700,
        ),
      ),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pop(context); // Close the drawer after selection
      },
    );
  }


  Widget _buildNavItem(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Update the selected index
        });
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.isMobile(context)
                  ? 8
                  : Responsive.isTablet(context)
                  ? 12
                  : 16,
              fontFamily: 'Nunito-Regular',
              color: (_selectedIndex == index ||
                  (_selectedIndex == 6 && index == 0) ||
                  (_selectedIndex == 7 && index == 0) ||
                  (_selectedIndex == 8 && index == 0)||
                  (_selectedIndex == 9 && index == 0)||
                  (_selectedIndex == 10 && index == 0)||
                  (_selectedIndex == 11 && index == 0)||
                  (_selectedIndex == 12 && index == 0)


              )
                  ? AppColors.primaryColor
                  : AppColors.textColor,
              fontWeight: (_selectedIndex == index ||
                  (_selectedIndex == 6 && index == 0) ||
                  (_selectedIndex == 7 && index == 0) ||
                  (_selectedIndex == 8 && index == 0)||
                  (_selectedIndex == 9 && index == 0)||
                  (_selectedIndex == 10 && index == 0)||
                  (_selectedIndex == 11 && index == 0)||
                  (_selectedIndex == 12 && index == 0))
                  ? FontWeight.w600
                  : FontWeight.w600,
            ),
          ),
          if (_selectedIndex == index ||
              (_selectedIndex == 6 && index == 0) ||
              (_selectedIndex == 7 && index == 0) ||
              (_selectedIndex == 8 && index == 0)||
              (_selectedIndex == 9 && index == 0)||
              (_selectedIndex == 10 && index == 0)||
              (_selectedIndex == 11 && index == 0)||
              (_selectedIndex == 12 && index == 0))
            Positioned(

              bottom: 3, // Adjust this value to increase or decrease the space
              child: Container(
                height: 1, // Thickness of the underline
                width: title.length * (Responsive.isMobile(context) ? 8 : Responsive.isTablet(context) ? 12 : 16), // Adjust width based on font size
                color: AppColors.primaryColor, // Underline color
              ),
            ),
        ],
      ),
    );
  }




}
