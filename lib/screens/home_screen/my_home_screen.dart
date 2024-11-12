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
import 'package:kaistable_website/screens/home_screen/location_pages/location_view_all/location_view_all.dart';
import 'package:kaistable_website/screens/home_screen/new_view_all/new_viewall.dart';
import 'package:kaistable_website/screens/home_screen/recently_viewed/recently_viewed.dart';
import 'package:kaistable_website/screens/home_screen/theme/theme_view_all.dart';
import 'package:kaistable_website/screens/home_screen/trendind_all/trending_view_all.dart';
import 'package:kaistable_website/screens/privacy_policy/privacy_policy.dart';
import 'package:kaistable_website/screens/terms_and_condition/terms_and_condition.dart';
import 'package:kaistable_website/utils/responsive.dart';
import 'package:kaistable_website/widgets/circle_container_widget.dart';
import 'package:kaistable_website/widgets/fav_rectangle_widget.dart';

import '../../constants/app_colors.dart';
import '../detail_screens/restaurant_detail_screen.dart';
import 'filter_screen/filter_screen.dart';

class MyHomeScreen extends StatefulWidget {


  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final List<String> letters = ['#', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  final RxBool isTapped = false.obs;

  final RxBool showFilterOptions = false.obs;

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

  void _onItemTapped(int index,{isHome}) {
    setState(() {
      _selectedIndex = index; // Update selected index
      decorationLineColor = Theme.of(context).primaryColor;
     if(isHome) Get.back();// Set decoration line color to primary
    });

    // Navigate to the corresponding screen based on the index
    switch (index) {
      case 0:
        Get.to(MyHomeScreen());
        break;
      case 1:
        Get.to(FavoriteScreen());
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
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        iconTheme: IconThemeData(
          color: AppColors.primaryColor, // Set your desired color for the drawer icon
        ),
        centerTitle: true,
          title: Text('Home',
        style: const TextStyle(
          fontSize: 20,
          color: AppColors.botomSheetColor,
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
      body:  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 16,top: 8,right: 14),
                child: Row(
                  children: [
                    Container(
                      height: Responsive.isMobile(context) ? 44 : 55,
                      width: Responsive.isMobile(context) ? 285 : 639,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          Responsive.isMobile(context) ? 10 : 10,
                        ),
                        boxShadow: [

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
                                  fontFamily: "Nunito-Regular",
                                  fontWeight: FontWeight.w400,
                                  fontSize:
                                  Responsive.isMobile(context) ? 10 : 16,
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

                            Container(
                              height: 55,
                              width: Responsive.isMobile(context) ? 66 : 106,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                      Responsive.isMobile(context) ? 10 : 10),
                                  bottomRight: Radius.circular(
                                      Responsive.isMobile(context) ? 10 : 10),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Search',
                                  style: TextStyle(
                                    color: AppColors.botomSheetColor,
                                    fontFamily: "Nunito-Bold",
                                    fontSize:
                                    Responsive.isMobile(context) ? 12 : 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),

                        ],
                      ),
                    ),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: () {
                        isTapped.value = !isTapped.value;
                        showFilterOptions.value = !showFilterOptions.value; // Toggle visibility of filter options
                      },
                      child: Obx(
                            () => Container(
                          height: 44,
                          width: 38,
                          decoration: BoxDecoration(
                            color: isTapped.value ? AppColors.primaryColor : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/images/filter_white.png",
                              height: 24,
                              width: 24,
                              color: isTapped.value ? AppColors.whiteColor : AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 10),
              Obx(
                    () => showFilterOptions.value
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 109,
                    width: 358,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),

                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Filter restaurants A to Z",
                        style: TextStyle(
                          fontFamily: "Nunito-Bold",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.botomSheetColor
                        ),),
                    SizedBox(height: 10,),

                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 12,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: letters.length,  // Assume letters is a list of alphabets like ['A', 'B', 'C', ...]
                        itemBuilder: (context, index) {
                          String letter = letters[index];

                          return GestureDetector(
                            onTap: () {
                              controller.selectedLetter.value = letter;
                              Get.to(FilterScreen(),arguments: letter); // Update selected letter
                              print('Filter by $letter');
                            },
                            child: Obx(() {
                              // Listen to the changes in selectedLetter
                              return Text(
                                letter,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: controller.selectedLetter.value == letter
                                      ? AppColors.primaryColor
                                      : AppColors.textColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Nunito-Regular",
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    )


                      ],
                    ),
                  ),
                )
                    : SizedBox.shrink(),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 15 : 50),
              Padding(
                padding: EdgeInsets.only(
                  left: Responsive.isMobile(context) ? 16 : 48.0,
                  right: Responsive.isMobile(context) ? 18 : 48.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Location',
                      style: TextStyle(
                        color: AppColors.botomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: Responsive.isMobile(context) ? 18 : 40,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Get.to(LocationViewAll( ));
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
              SizedBox(height: 20),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: Responsive.isMobile(context) ? 8 : 42, right: 6),
                    child: SizedBox(
                      height: 180,
                      child: ListView.builder(
                        controller: controller.scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.circleItems.length, // Number of items
                        itemBuilder: (context, index) {
                          final item = controller
                              .circleItems[index]; // Get item from model list
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6,
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
          //         Positioned(
          //           left: 10, // Adjust the value to add space from the list
          //           top: 0,
          //           bottom: 0,
          //           child: InkWell(
          //             onTap: () => controller.scrollLeft(),
          //             child: Image.asset(
          //               'assets/images/arrow_back.png',
          //               height: Responsive.isMobile(context) ? 32 : 52,
          //               width: Responsive.isMobile(context) ? 32 : 52,
          //             ),
          //           ),
          //         ),
          // // // Right Arrow button with padding for spacing
          //         Positioned(
          //           right: 10, // Adjust the value to add space from the list
          //           top: 0,
          //           bottom: 0,
          //           child: InkWell(
          //             onTap: () => controller.scrollRight(),
          //             child: Image.asset(
          //               'assets/images/arrow_forward.png',
          //               height: Responsive.isMobile(context) ? 32 : 52,
          //               width: Responsive.isMobile(context) ? 32 : 52,
          //             ),
          //           ),
          //         ),
                ],
              ),
              SizedBox(height: Responsive.isMobile(context) ? 25 : 50),
              Padding(
                padding: EdgeInsets.only(
                  left: Responsive.isMobile(context) ? 14 : 48.0,
                  right: Responsive.isMobile(context) ? 18 : 48.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Theme',
                      style: TextStyle(
                        color: AppColors.botomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: Responsive.isMobile(context) ? 18 : 40,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Get.to(ThemeViewAll( ));
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
              SizedBox(height: Responsive.isMobile(context) ? 15 : 50),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: Responsive.isMobile(context) ? 8 : 42, right: 6),
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
                                    ? 6
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
          //         Positioned(
          //           left: 10, // Adjust the value to add space from the list
          //           top: 0,
          //           bottom: 0,
          //           child: InkWell(
          //             onTap: () => themeController.scrollLeft(),
          //             child: Image.asset(
          //               'assets/images/arrow_back.png',
          //               height: Responsive.isMobile(context) ? 32 : 52,
          //               width: Responsive.isMobile(context) ? 32 : 52,
          //             ),
          //           ),
          //         ),
          // // Right Arrow button with padding for spacing
          //         Positioned(
          //           right: 10, // Adjust the value to add space from the list
          //           top: 0,
          //           bottom: 0,
          //           child: InkWell(
          //             onTap: () => themeController.scrollRight(),
          //             child: Image.asset(
          //                 'assets/images/arrow_forward.png',
          //               height: Responsive.isMobile(context) ? 32 : 52,
          //               width: Responsive.isMobile(context) ? 32 : 52,
          //             ),
          //           ),
          //         ),
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
                          ? 223
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
                          ? 223
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
                          ? 223
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
                          ? 223
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
        )

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
          onTap: () => _onItemTapped(index,isHome: title =='Home' ? true: false),

        ),

      ],
    );
  }
}
