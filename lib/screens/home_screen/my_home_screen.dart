import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/about_app/about_app.dart';
import 'package:kaistable_website/screens/contact_us/contact_us.dart';
import 'package:kaistable_website/screens/favorite_screen/favorite_screen.dart';
import 'package:kaistable_website/screens/home_screen/cuisiness_viewall/cuisines_view_all.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_cusiness_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_filter_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_new_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_recently_viewed_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_theme_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_trending_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_screen.dart';
import 'package:kaistable_website/screens/home_screen/location_pages/location_screen.dart';
import 'package:kaistable_website/screens/home_screen/new_view_all/new_viewall.dart';
import 'package:kaistable_website/screens/home_screen/recently_viewed/recently_viewed.dart';
import 'package:kaistable_website/screens/home_screen/trendind_all/trending_view_all.dart';
import 'package:kaistable_website/screens/privacy_policy/privacy_policy.dart';
import 'package:kaistable_website/screens/terms_and_condition/terms_and_condition.dart';
import 'package:kaistable_website/utils/responsive.dart';
import 'package:kaistable_website/widgets/circle_container_widget.dart';
import 'package:kaistable_website/widgets/fav_rectangle_widget.dart';

import '../../constants/app_colors.dart';
import '../detail_screens/restaurant_detail_screen.dart';

class MyHomeScreen extends StatefulWidget {


  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {

  final HomeLocationController controller = Get.put(HomeLocationController());
  final HomeThemeController themeController = Get.put(HomeThemeController());
  final HomeRecentlyViewedController recentlyViewedController = Get.put(HomeRecentlyViewedController());
  final HomeCusinessController cusinessController = Get.put(HomeCusinessController());
  final HomeTrendingController trendingController = Get.put(HomeTrendingController());
  final HomeNewController newController = Get.put(HomeNewController());
  final HomeFilterController filterController = Get.put(HomeFilterController());
  final scrollController = ScrollController();
  int _selectedIndex = 0; // Track the selected index
  Color decorationLineColor = Colors.transparent; // Default color for decoration line

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
      decorationLineColor = Theme.of(context).primaryColor; // Set decoration line color to primary
    });

    // Navigate to the corresponding screen based on the index
    switch (index) {
      case 0:
        Get.to(MyHomeScreen());
        break;
      case 1:
        Get.to(FavoriteScreen(scrollcontroller: scrollController,));
        break;
      case 2:
        Get.to(TermsAndCondition());
        break;
      case 3:
        Get.to(PrivacyPolicy());
        break;
      case 4:
        Get.to(AboutApp());
        break;
      case 5:
        Get.to(ContactUs(scrollcontroller: scrollController));
        break;

    }
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.primaryColor, // Set your desired color for the drawer icon
        ),
        centerTitle: true,
          title: Text('Home',
        style: const TextStyle(
          fontSize: 20,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w700,
          fontFamily: 'Nunito-Bold',
        ),),
        actions: [
          const SizedBox(width: 20),
          _selectedIndex == 0 // Only show on the home screen
              ? Row(
            children: [
              InkWell(
                onTap: () {
                  Get.to(LocationScreen());
                },
                child: const Image(
                  image: AssetImage('assets/images/location_icon.png'),
                  height: 12,
                  width: 12,
                ),
              ),
              const SizedBox(width: 1),
              InkWell(
                onTap: () {
                  Get.to(LocationScreen());
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
                        ?9
                        : Responsive.isTablet(context)
                        ? 14
                        : 16,
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          )
              : const SizedBox.shrink(), // Show nothing if not on home screen
        ],),
      drawer: Drawer(
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
            _buildDrawerItem('Terms and conditions', 2),
            _buildDrawerItem('Privacy policy', 3),
            _buildDrawerItem('About app', 4),
            _buildDrawerItem('Contact us', 5),
          ],
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        int itemsPerRow = Responsive.isMobile(context)
            ? 2
            : Responsive.isTablet(context)
            ? 3
            : 4;
        double itemWidth = (constraints.maxWidth / itemsPerRow) - 12;
        double itemHeight =
        Responsive.isMobile(context) ? 290 : (isLargeScreen ? 400 : 400);
        // int filterItemperRow = Responsive.isMobile(context)
        //     ? 2
        //     : Responsive.isTablet(context)
        //         ? 2
        //         : 3;
        // double filterItemWidth = (constraints.maxWidth / filterItemperRow) - 8;
        // double filterItemHeight =
        //     Responsive.isMobile(context) ? 320 : (isLargeScreen ? 400 : 200);
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: Responsive.isMobile(context) ? 280 : 576,
                width: Get.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/home_background_img.png'),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lorem ipsum dolor sit ame',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: Responsive.isMobile(context) ? 16 : 48,
                          color: AppColors.whiteColor,
                          fontFamily: 'Lemonado',
                        ),
                      ),
                      SizedBox(
                        height: Responsive.isMobile(context) ? 12 : 16,
                      ),
                      SizedBox(
                        width: Responsive.isMobile(context) ? 320 : 639,
                        child: Text(
                          'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore',
                          style: TextStyle(
                            fontSize: Responsive.isMobile(context) ? 12 : 24,
                            fontWeight: FontWeight.w400,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                      SizedBox(height: Responsive.isMobile(context) ? 22 : 33),
                      Container(
                        height: Responsive.isMobile(context) ? 44 : 55,
                        width: Responsive.isMobile(context) ? 320 : 639,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            Responsive.isMobile(context) ? 4 : 10,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 12,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                maxLines: 1,
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontFamily: "Lora-Regular",
                                  fontSize: Responsive.isMobile(context) ? 12 : 16,
                                ),
                                cursorColor: AppColors.textColor,
                                decoration: InputDecoration(
                                  hintText: 'Try searching for restaurant name',
                                  hintStyle: TextStyle(
                                    color: const Color(0xFF4F5762),
                                    fontFamily: "Lora-Regular",
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                    Responsive.isMobile(context) ? 11 : 16,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                    top: Responsive.isMobile(context) ? 10 : 18,
                                    // bottom: Responsive.isMobile(context) ? 20 : 12,
                                    //left: Responsive.isMobile(context) ? 9 : 20,
                                  ),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(
                                        Responsive.isMobile(context) ? 13 : 14),
                                    child: Image.asset(
                                      'assets/images/search_icon.png',
                                      fit: BoxFit.contain,
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // if (onNavigate != null) {
                                //   onNavigate!(
                                //       ); scrollcontroller.jumpTo(0);// Call the callback to navigate to the 7th screen
                                // }
                              },
                              child: Container(
                                height: 55,
                                width: Responsive.isMobile(context) ? 66 : 106,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                        Responsive.isMobile(context) ? 4 : 10),
                                    bottomRight: Radius.circular(
                                        Responsive.isMobile(context) ? 4 : 10),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Search',
                                    style: TextStyle(
                                      color: AppColors.botomSheetColor,
                                      fontFamily: "Lora-Regular",
                                      fontSize:
                                      Responsive.isMobile(context) ? 11 : 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 25 : 50),
              Padding(
                padding:
                EdgeInsets.only(left: Responsive.isMobile(context) ? 18 : 48.0),
                child: Text(
                  'Location',
                  style: TextStyle(
                    color: AppColors.botomSheetColor,
                    fontFamily: 'aftika-regular',
                    fontSize: Responsive.isMobile(context) ? 18 : 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: Responsive.isMobile(context) ? 28 : 42, right: 12),
                    child: SizedBox(
                      height: Responsive.isMobile(context)
                          ? 180
                          : isLargeScreen
                          ? 364
                          : 270,
                      child: ListView.builder(
                        controller: controller.scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.circleItems.length, // Number of items
                        itemBuilder: (context, index) {
                          final item = controller
                              .circleItems[index]; // Get item from model list
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 6),
                            child: CircleContainerWidget(
                              ontap: () {
                                Get.to(LocationScreen());
                              },
                              isFavourite: false.obs,
                              isLocation: true,
                              imgPath: item.imgPath,
                              titleText: item.titleText,
                              descriptionText: item.descriptionText,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          //Left Arrow button with padding for spacing
                  Positioned(
                    left: 10, // Adjust the value to add space from the list
                    top: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () => controller.scrollLeft(),
                      child: Image.asset(
                        'assets/images/arrow_back.png',
                        height: Responsive.isMobile(context) ? 32 : 52,
                        width: Responsive.isMobile(context) ? 32 : 52,
                      ),
                    ),
                  ),
          // // Right Arrow button with padding for spacing
                  Positioned(
                    right: 10, // Adjust the value to add space from the list
                    top: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () => controller.scrollRight(),
                      child: Image.asset(
                        'assets/images/arrow_forward.png',
                        height: Responsive.isMobile(context) ? 32 : 52,
                        width: Responsive.isMobile(context) ? 32 : 52,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.isMobile(context) ? 25 : 50),
              Padding(
                padding:
                EdgeInsets.only(left: Responsive.isMobile(context) ? 18 : 48.0),
                child: Text(
                  'Theme',
                  style: TextStyle(
                    color: AppColors.botomSheetColor,
                    fontFamily: 'aftika-regular',
                    fontSize: Responsive.isMobile(context) ? 18 : 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 15 : 50),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: Responsive.isMobile(context) ? 28 : 42, right: 12),
                    child: SizedBox(
                      height: Responsive.isMobile(context)
                          ? 180
                          : isLargeScreen
                          ? 364
                          : 270,
                      child: ListView.builder(
                        controller: themeController.scrothemellController,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                        themeController.circleItems.length, // Number of items
                        itemBuilder: (context, index) {
                          final item = themeController
                              .circleItems[index]; // Get item from model list
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Responsive.isMobile(context)
                                    ? 24
                                    : isLargeScreen
                                    ? 19
                                    : 20.30,
                                vertical: Responsive.isMobile(context) ? 6 : 6),
                            child: CircleContainerWidget(
                              ontap: (){
                                Get.to(RestaurantDetailScreen());
                              },
                              isLocation: false,
                              imgPath: item.imgPath,
                              titleText: item.titleText,
                              descriptionText: item.descriptionText,
                              isFavourite: false.obs,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          // Left Arrow button with padding for spacing
                  Positioned(
                    left: 10, // Adjust the value to add space from the list
                    top: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () => themeController.scrollLeft(),
                      child: Image.asset(
                        'assets/images/arrow_back.png',
                        height: Responsive.isMobile(context) ? 32 : 52,
                        width: Responsive.isMobile(context) ? 32 : 52,
                      ),
                    ),
                  ),
          // Right Arrow button with padding for spacing
                  Positioned(
                    right: 10, // Adjust the value to add space from the list
                    top: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () => themeController.scrollRight(),
                      child: Image.asset(
                          'assets/images/arrow_forward.png',
                        height: Responsive.isMobile(context) ? 32 : 52,
                        width: Responsive.isMobile(context) ? 32 : 52,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.isMobile(context) ? 45 : 50),
              Padding(
                padding: EdgeInsets.only(
                  left: Responsive.isMobile(context) ? 18 : 48.0,
                  right: Responsive.isMobile(context) ? 18 : 48.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cuisines',
                      style: TextStyle(
                        color: AppColors.botomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: Responsive.isMobile(context) ? 18 : 40,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Get.to(CuisinesViewAll());
                        },
                        child: Text(
                          "view all",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryColor,
                              fontFamily: 'Nunito-Regular',
                              fontSize: Responsive.isMobile(context) ? 12 : 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor),
                        ))
                  ],
                ),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 2 : 50),
              Obx(() {
                // Determine item count based on screen type
                int itemCount;
                if (Responsive.isMobile(context)) {
                  itemCount = cusinessController.cusinessItem.length > 2
                      ? 2
                      : cusinessController.cusinessItem.length;
                } else if (Responsive.isTablet(context)) {
                  itemCount = cusinessController.cusinessItem.length > 3
                      ? 3
                      : cusinessController.cusinessItem.length;
                } else {
                  itemCount = cusinessController.cusinessItem.length > 4
                      ? 4
                      : cusinessController.cusinessItem.length;
                }
          
                return Padding(
                  padding: EdgeInsets.only(
          
                    left: Responsive.isMobile(context)
                        ? 14
                        : (isLargeScreen ? 48 : 46.0),
                    right: Responsive.isMobile(context)
                        ? 14
                        : (isLargeScreen ? 48 : 42.0),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: Responsive.isMobile(context)
                          ? 293
                          : (isLargeScreen ? 450 : 350),
                      crossAxisCount: Responsive.isMobile(context)
                          ? 2
                          : (Responsive.isTablet(context) ? 3 : 4),
                      crossAxisSpacing: Responsive.isMobile(context)
                          ? 10
                          : (Responsive.isTablet(context) ? 8 : 10),
                      mainAxisSpacing: Responsive.isMobile(context)
                          ? 0
                          : (Responsive.isTablet(context) ? 2 : 20),
                      childAspectRatio: itemWidth / itemHeight,
                    ),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final item = cusinessController.cusinessItem[index];
                      return CustomRectangleWidget(
                        //onNavigate: onNavigate,
                        title: item.title,
                        description: item.description,
                        imagePath: item.imagePath,
                        timetext: item.timetext,
                        percentText: item.percentText,
                        isFavorite: false.obs,

                      );
                    },
                  ),
                );
              }),
              SizedBox(height: Responsive.isMobile(context) ? 2 : 50),
              Padding(
                padding: EdgeInsets.only(
                  left: Responsive.isMobile(context) ? 18 : 48.0,
          
                  right: Responsive.isMobile(context) ? 18 : 48.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trending',
                      style: TextStyle(
                        color: AppColors.botomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: Responsive.isMobile(context) ? 18 : 40,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Get.to(TrendingViewAll());
                        },
                        child: Text("view all",
          
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryColor,
                              fontFamily: 'Nunito-Regular',
                              fontSize:  Responsive.isMobile(context) ? 12 : 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor
                          ),
          
                        ))
                  ],
                ),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 0 : 50),
              Obx(() {
                // Determine item count based on screen type
                int itemCount;
                if (Responsive.isMobile(context)) {
                  itemCount = trendingController.trendingItem.length > 2
                      ? 2
                      : trendingController.trendingItem.length;
                } else if (Responsive.isTablet(context)) {
                  itemCount = trendingController.trendingItem.length > 3
                      ? 3
                      : trendingController.trendingItem.length;
                } else {
                  itemCount = trendingController.trendingItem.length > 4
                      ? 4
                      : trendingController.trendingItem.length;
                }
          
                return Padding(
                  padding: EdgeInsets.only(
                    left: Responsive.isMobile(context)
                        ? 14
                        : (isLargeScreen ? 48 : 46.0),
                    right: Responsive.isMobile(context)
                        ? 14
                        : (isLargeScreen ? 48 : 42.0),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: Responsive.isMobile(context)
                          ? 293
                          : (isLargeScreen ? 450 : 350),
                      crossAxisCount: Responsive.isMobile(context)
                          ? 2
                          : (Responsive.isTablet(context) ? 3 : 4),
                      crossAxisSpacing: Responsive.isMobile(context)
                          ? 10
                          : (Responsive.isTablet(context) ? 8 : 10),
                      mainAxisSpacing: Responsive.isMobile(context)
                          ? 0
                          : (Responsive.isTablet(context) ? 2 : 20),
                      childAspectRatio: itemWidth / itemHeight,
                    ),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final item = trendingController.trendingItem[index];
                      return CustomRectangleWidget(
                        //onNavigate: onNavigate,
                        title: item.title,
                        description: item.description,
                        imagePath: item.imagePath,
                        timetext: item.timetext,
                        percentText: item.percentText,
                        isFavorite: false.obs,

                      );
                    },
                  ),
                );
              }),
              SizedBox(height: Responsive.isMobile(context) ? 2 : 50),
              Padding(
                padding: EdgeInsets.only(
                  left: Responsive.isMobile(context) ? 18 : 48.0,
                  right: Responsive.isMobile(context) ? 18 : 48.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New',
                      style: TextStyle(
                        color: AppColors.botomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: Responsive.isMobile(context) ? 18 : 40,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                        Get.to(NewViewall());
                        },
                        child: Text("view all",
          
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryColor,
                              fontFamily: 'Nunito-Regular',
                              fontSize:  Responsive.isMobile(context) ? 12 : 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor
                          ),
          
                        ))
                  ],
                ),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 0 : 50),
              Obx(() {
                // Determine item count based on screen type
                int itemCount;
                if (Responsive.isMobile(context)) {
                  itemCount = newController.newItem.length > 2
                      ? 2
                      : newController.newItem.length;
                } else if (Responsive.isTablet(context)) {
                  itemCount = newController.newItem.length > 3
                      ? 3
                      : newController.newItem.length;
                } else {
                  itemCount = newController.newItem.length > 4
                      ? 4
                      : newController.newItem.length;
                }
          
                return Padding(
                  padding: EdgeInsets.only(
                    left: Responsive.isMobile(context)
                        ? 14
                        : (isLargeScreen ? 48 : 46.0),
                    right: Responsive.isMobile(context)
                        ? 14
                        : (isLargeScreen ? 48 : 42.0),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: Responsive.isMobile(context)
                          ? 293
                          : (isLargeScreen ? 450 : 350),
                      crossAxisCount: Responsive.isMobile(context)
                          ? 2
                          : (Responsive.isTablet(context) ? 3 : 4),
                      crossAxisSpacing: Responsive.isMobile(context)
                          ? 10
                          : (Responsive.isTablet(context) ? 8 : 10),
                      mainAxisSpacing: Responsive.isMobile(context)
                          ? 0
                          : (Responsive.isTablet(context) ? 2 : 20),
                      childAspectRatio: itemWidth / itemHeight,
                    ),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final item = newController.newItem[index];
                      return CustomRectangleWidget(
                        //onNavigate: onNavigate,
                        title: item.title,
                        description: item.description,
                        imagePath: item.imagePath,
                        timetext: item.timetext,
                        percentText: item.percentText,
                        isFavorite: false.obs,
                      );
                    },
                  ),
                );
              }),
              SizedBox(height: Responsive.isMobile(context) ? 2 : 50),
              Padding(
                padding: EdgeInsets.only(
                  left: Responsive.isMobile(context) ? 18 : 48.0,
                  right: Responsive.isMobile(context) ? 18 : 48.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recently Viewed',
                      style: TextStyle(
                        color: AppColors.botomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: Responsive.isMobile(context) ? 18 : 40,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                    Get.to(RecentlyViewed());
                        },
                        child: Text(
                          "view all",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryColor,
                              fontFamily: 'Nunito-Regular',
                              fontSize: Responsive.isMobile(context) ? 12 : 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor),
                        ))
                  ],
                ),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 2 : 50),
              Obx(() {
                // Determine item count based on screen type
                int itemCount;
                if (Responsive.isMobile(context)) {
                  itemCount = recentlyViewedController.recentlyViewedItem.length > 2
                      ? 2
                      : recentlyViewedController.recentlyViewedItem.length;
                } else if (Responsive.isTablet(context)) {
                  itemCount = recentlyViewedController.recentlyViewedItem.length > 3
                      ? 3
                      : recentlyViewedController.recentlyViewedItem.length;
                } else {
                  itemCount = recentlyViewedController.recentlyViewedItem.length > 4
                      ? 4
                      : recentlyViewedController.recentlyViewedItem.length;
                }
          
                return Padding(
                  padding: EdgeInsets.only(
                    left: Responsive.isMobile(context)
                        ? 14
                        : (isLargeScreen ? 48 : 46.0),
                    right: Responsive.isMobile(context)
                        ? 14
                        : (isLargeScreen ? 48 : 42.0),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: Responsive.isMobile(context)
                          ? 293
                          : (isLargeScreen ? 450 : 350),
                      crossAxisCount: Responsive.isMobile(context)
                          ? 2
                          : (Responsive.isTablet(context) ? 3 : 4),
                      crossAxisSpacing: Responsive.isMobile(context)
                          ? 10
                          : (Responsive.isTablet(context) ? 8 : 10),
                      mainAxisSpacing: Responsive.isMobile(context)
                          ? 10
                          : (Responsive.isTablet(context) ? 2 : 20),
                      childAspectRatio: itemWidth / itemHeight,
                    ),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final item =
                      recentlyViewedController.recentlyViewedItem[index];
                      return CustomRectangleWidget(
                     //   onNavigate: onNavigate,
                        title: item.title,
                        description: item.description,
                        imagePath: item.imagePath,
                        timetext: item.timetext,
                        percentText: item.percentText,
                        isFavorite: false.obs,
                      );
                    },
                  ),
                );
              }),
              SizedBox(height: Responsive.isMobile(context) ? 2 : 50),
          
              // Padding(
              //   padding: EdgeInsets.only(
              //     left: Responsive.isMobile(context) ? 18 : 48.0,
              //     right: Responsive.isMobile(context) ? 18 : 48.0,
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'Filter A z',
              //         style: TextStyle(
              //           color: AppColors.botomSheetColor,
              //           fontFamily: 'aftika-regular',
              //           fontSize: Responsive.isMobile(context) ? 18 : 40,
              //           fontWeight: FontWeight.w400,
              //         ),
              //       ),
              //       InkWell(
              //           onTap: () {
              //             if (onNavigate != null) {
              //               onNavigate!(
              //                   12);
              //               scrollcontroller.jumpTo(0);// Call the callback to navigate to the 7th screen
              //             }
              //           },
              //           child: Text(
              //             "view all 587 results",
              //             style: TextStyle(
              //                 decoration: TextDecoration.underline,
              //                 decorationColor: AppColors.primaryColor,
              //                 fontFamily: ',',
              //                 fontSize: Responsive.isMobile(context) ? 12 : 20,
              //                 fontWeight: FontWeight.w500,
              //                 color: AppColors.primaryColor),
              //           ))
              //     ],
              //   ),
              // ),
              // SizedBox(height: Responsive.isMobile(context) ? 8 : 20),
              // Padding(
              //   padding: EdgeInsets.only(
              //     left: Responsive.isMobile(context) ? 18 : 48.0,
              //     right: Responsive.isMobile(context) ? 18 : 48.0,
              //   ),
              //   child: Text(
              //     '# A B C D E F G H I J K L M N O',
              //     style: TextStyle(
              //       color: AppColors.textColor,
              //       fontFamily: 'Nunito-Regular',
              //       fontSize: Responsive.isMobile(context) ? 10 : 20,
              //       fontWeight: FontWeight.w400,
              //     ),
              //   ),
              // ),
              // SizedBox(height: Responsive.isMobile(context) ? 8 : 20),
              // Obx(() {
              //   //Determine item count based on screen type
              //   int itemCount;
              //   if (Responsive.isMobile(context)) {
              //     itemCount = filterController.filterItem.length > 2
              //         ? 4
              //         : filterController.filterItem.length;
              //   } else if (Responsive.isTablet(context)) {
              //     itemCount = filterController.filterItem.length > 3
              //         ? 6
              //         : filterController.filterItem.length;
              //   } else {
              //     itemCount = filterController.filterItem.length > 4
              //         ? filterController.filterItem.length
              //         : filterController.filterItem.length;
              //   }
              //
              //   return Padding(
              //     padding: EdgeInsets.only(
              //       left: Responsive.isMobile(context)
              //           ? 18
              //           : (isLargeScreen ? 48 : 46.0),
              //       right: Responsive.isMobile(context)
              //           ? 18
              //           : (isLargeScreen ? 48 : 42.0),
              //     ),
              //     child: GridView.builder(
              //       shrinkWrap: true,
              //       physics: const NeverScrollableScrollPhysics(),
              //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //         mainAxisExtent: Responsive.isMobile(context)
              //             ? 50
              //             : (isLargeScreen ? 120 : 100),
              //         crossAxisCount: Responsive.isMobile(context)
              //             ? 2
              //             : (Responsive.isTablet(context) ? 2 : 3),
              //         crossAxisSpacing: Responsive.isMobile(context)
              //             ? 10
              //             : (Responsive.isTablet(context) ? 8 : 10),
              //         mainAxisSpacing: Responsive.isMobile(context)
              //             ? 12
              //             : (Responsive.isTablet(context) ? 2 : 30),
              //         childAspectRatio: filterItemWidth / filterItemHeight,
              //       ),
              //       itemCount: itemCount,
              //       itemBuilder: (context, index) {
              //         final item = filterController.filterItem[index];
              //         return InkWell(
              //           onTap: ()
              //         {
              //         if (onNavigate != null) {
              //         onNavigate!(8);
              //         scrollcontroller.jumpTo(0);
              //         //scrollcontroller.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);// Call the callback to navigate to the 7th screen
              //         }
              //         },
              //           child: CustomFilterWidget(
              //             title: item.title,
              //             description: item.description,
              //             imgPath: item.imagePath,
              //           ),
              //         );
              //       },
              //     ),
              //   );
              // }),
              // SizedBox(height: Responsive.isMobile(context) ? 4 : 2),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDrawerItem(String title, int index) {
    bool isSelected = _selectedIndex == index;
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              decoration: _selectedIndex == index
                  ? TextDecoration.underline
                  : TextDecoration.none,
              decorationThickness: 1.5,
              decorationColor: AppColors.primaryColor,
              fontSize: 14,
              fontFamily: 'Nunito-Bold',
              color: _selectedIndex == index ? AppColors.primaryColor : AppColors.textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          onTap: () => _onItemTapped(index),

        ),

      ],
    );
  }
}
