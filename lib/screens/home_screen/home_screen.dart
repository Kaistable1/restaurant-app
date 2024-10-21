import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/circle_container_widget.dart';
import '../../widgets/custom_filter_widget.dart';
import '../../widgets/fav_rectangle_widget.dart';
import 'home_controller/home_cusiness_controller.dart';
import 'home_controller/home_filter_controller.dart';
import 'home_controller/home_location_controller.dart';
import 'home_controller/home_new_controller.dart';
import 'home_controller/home_recently_viewed_controller.dart';
import 'home_controller/home_theme_controller.dart';
import 'home_controller/home_trending_controller.dart';
class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  const HomeScreen({super.key, this.onNavigate});
  @override
  Widget build(BuildContext context) {

    final HomeLocationController controller = Get.put(HomeLocationController());
    final HomeThemeController themeController = Get.put(HomeThemeController());
    final HomeRecentlyViewedController recentlyViewedController = Get.put(HomeRecentlyViewedController());
    final HomeCusinessController cusinessController = Get.put(HomeCusinessController());
    final HomeTrendingController trendingController = Get.put(HomeTrendingController());
    final HomeNewController newController = Get.put(HomeNewController());
    final HomeFilterController filterController = Get.put(HomeFilterController());


    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return  LayoutBuilder(
        builder: (context, constraints) {
      int itemsPerRow = Responsive.isMobile(context) ? 2 :Responsive.isTablet(context) ?3:4;
      double itemWidth = (constraints.maxWidth / itemsPerRow) - 16;
      double itemHeight = Responsive.isMobile(context)
          ? 320:(isLargeScreen ?400:400);
      int filterItemperRow =Responsive.isMobile(context) ? 2 :Responsive.isTablet(context) ?2:3;
      double filterItemWidth = (constraints.maxWidth / filterItemperRow) - 8;
      double filterItemHeight = Responsive.isMobile(context)
          ? 320:(isLargeScreen ?400:200);
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //////////////////////////////////to remove////////////////
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
                    ? 18
                    : (isLargeScreen ? 48 : 30.0),
                right: Responsive.isMobile(context)
                    ? 18
                    : (isLargeScreen ? 48 : 30.0),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: Responsive.isMobile(context)
                      ? 263
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
                    onNavigate: onNavigate,
                    title: item.title,
                    description: item.description,
                    imagePath: item.imagePath,
                    timetext: item.timetext,
                    percentText: item.percentText, isFavorite:false.obs ,
                  );
                },
              ),
            );
          }),
          Container (
            height: Responsive.isMobile(context) ? 312 : 576,
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
                      fontSize: Responsive.isMobile(context) ? 20 : 48,
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
                        fontSize: Responsive.isMobile(context) ? 14 : 24,
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
                                fontSize: Responsive.isMobile(context) ? 10 : 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                top: Responsive.isMobile(context) ? 14 : 18,
                                bottom: Responsive.isMobile(context) ? 20 : 12,
                                left: Responsive.isMobile(context) ? 9 : 20,
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(
                                    Responsive.isMobile(context) ? 12 : 14),
                                child: Image.asset(
                                  'assets/images/search_icon.png',
                                  fit: BoxFit.contain,
                                  height: 24,
                                  width: 24,
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
                                fontSize: Responsive.isMobile(context) ? 10 : 16,
                                fontWeight: FontWeight.w400,
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
            padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 18 : 48.0),
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
                padding:  EdgeInsets.only(left: Responsive.isMobile(context)
                    ?40:32,right: 10),
                child: SizedBox(
                  height: Responsive.isMobile(context) ? 180 : isLargeScreen?  364: 270,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.circleItems.length, // Number of items
                    itemBuilder: (context, index) {
                      final item = controller.circleItems[index]; // Get item from model list
                      return Padding(
                        padding:  EdgeInsets.symmetric(horizontal: Responsive.isMobile(context)
                            ?29: isLargeScreen?  48:22.0, vertical: Responsive.isMobile(context)
                            ?6:6),
                        child: CircleContainerWidget(
                          ontap:  (){
                            if (onNavigate != null) {
                              onNavigate!(7); // Call the callback to navigate to the 7th screen
                            }
                          },isFavourite: false.obs,
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
// Left Arrow button with padding for spacing
              Positioned(
                left: 10, // Adjust the value to add space from the list
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => controller.scrollLeft(),
                  child: Image.asset(
                    'assets/images/arrow_back.png',
                    height: Responsive.isMobile(context)
                        ?32:52,
                    width: Responsive.isMobile(context)
                        ?32:52,
                  ),
                ),
              ),
// Right Arrow button with padding for spacing
              Positioned(
                right: 10, // Adjust the value to add space from the list
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => controller.scrollRight(),
                  child: Image.asset(
                    'assets/images/arrow_forward.png',
                    height: Responsive.isMobile(context)
                        ?32:52,
                    width: Responsive.isMobile(context)
                        ?32:52,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.isMobile(context) ? 25 : 50),
          Padding(
            padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 18 : 48.0),
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
          SizedBox(height: Responsive.isMobile(context) ? 25 : 50),
          Stack(
            children: [
              Padding(
                padding:  EdgeInsets.only(left: Responsive.isMobile(context)
                    ?40:32,right: 10),
                child: SizedBox(
                  height: Responsive.isMobile(context) ? 180 : isLargeScreen?  364: 270,
                  child: ListView.builder(
                    controller: themeController.scrothemellController,
                    scrollDirection: Axis.horizontal,
                    itemCount: themeController.circleItems.length, // Number of items
                    itemBuilder: (context, index) {
                      final item = themeController.circleItems[index]; // Get item from model list
                      return Padding(
                        padding:  EdgeInsets.symmetric(horizontal: Responsive.isMobile(context)
                            ?29: isLargeScreen?  48:22.0, vertical: Responsive.isMobile(context)
                            ?6:6),
                        child: CircleContainerWidget(
                          isLocation: false,
                          imgPath: item.imgPath,
                          titleText: item.titleText,
                          descriptionText: item.descriptionText, isFavourite: false.obs,
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
                child: GestureDetector(
                  onTap: () => themeController.scrollLeft(),
                  child: Image.asset(
                    'assets/images/arrow_back.png',
                    height: Responsive.isMobile(context)
                        ?32:52,
                    width: Responsive.isMobile(context)
                        ?32:52,
                  ),
                ),
              ),
// Right Arrow button with padding for spacing
              Positioned(
                right: 10, // Adjust the value to add space from the list
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => themeController.scrollRight(),
                  child: Image.asset(
                    'assets/images/arrow_forward.png',
                    height: Responsive.isMobile(context)
                        ?32:52,
                    width: Responsive.isMobile(context)
                        ?32:52,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.isMobile(context) ? 25 : 50),
          Padding(
            padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 18 : 48.0,right: Responsive.isMobile(context) ? 18 : 48.0, ),
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
                // GestureDetector(
                //     onTap: () {
                //       if (onNavigate != null) {
                //         // onNavigate!(6); // Call the callback to navigate to the 7th screen
                //       }
                //     },
                //     child: Text("",
                //
                //       style: TextStyle(
                //           decoration: TextDecoration.underline,
                //           decorationColor: AppColors.primaryColor,
                //           fontFamily: ',',
                //           fontSize:  Responsive.isMobile(context) ? 12 : 20,
                //           fontWeight: FontWeight.w500,
                //           color: AppColors.primaryColor
                //       ),
                //
                //     ))
              ],
            ),
          ),
          SizedBox(height: Responsive.isMobile(context) ? 25 : 50),
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
                    ? 18
                    : (isLargeScreen ? 48 : 30.0),
                right: Responsive.isMobile(context)
                    ? 18
                    : (isLargeScreen ? 48 : 30.0),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: Responsive.isMobile(context)
                      ? 263
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
                    onNavigate: onNavigate,
                    title: item.title,
                    description: item.description,
                    imagePath: item.imagePath,
                    timetext: item.timetext,
                    percentText: item.percentText, isFavorite:false.obs,
                  );
                },
              ),
            );
          }),

          SizedBox(height: Responsive.isMobile(context) ? 25 : 50),
          Padding(
            padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 18 : 48.0,right: Responsive.isMobile(context) ? 18 : 48.0, ),
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
                // GestureDetector(
                //     onTap: () {
                //       if (onNavigate != null) {
                //         // onNavigate!(6); // Call the callback to navigate to the 7th screen
                //       }
                //     },
                //     child: Text("",
                //
                //       style: TextStyle(
                //           decoration: TextDecoration.underline,
                //           decorationColor: AppColors.primaryColor,
                //           fontFamily: ',',
                //           fontSize:  Responsive.isMobile(context) ? 12 : 20,
                //           fontWeight: FontWeight.w500,
                //           color: AppColors.primaryColor
                //       ),
                //
                //     ))
              ],
            ),
          ),
          SizedBox(height: Responsive.isMobile(context) ? 25 : 50),
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
                    ? 18
                    : (isLargeScreen ? 48 : 30.0),
                right: Responsive.isMobile(context)
                    ? 18
                    : (isLargeScreen ? 48 : 30.0),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: Responsive.isMobile(context)
                      ? 263
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
                    title: item.title,
                    description: item.description,
                    imagePath: item.imagePath,
                    timetext: item.timetext,
                    percentText: item.percentText, isFavorite: false.obs,
                  );
                },
              ),
            );
          }),
          SizedBox(height: Responsive.isMobile(context) ? 25 : 50),
          Padding(
            padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 18 : 48.0,right: Responsive.isMobile(context) ? 18 : 48.0, ),
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
                // GestureDetector(
                //     onTap: () {
                //       if (onNavigate != null) {
                //         // onNavigate!(6); // Call the callback to navigate to the 7th screen
                //       }
                //     },
                //     child: Text("",
                //
                //       style: TextStyle(
                //           decoration: TextDecoration.underline,
                //           decorationColor: AppColors.primaryColor,
                //           fontFamily: ',',
                //           fontSize:  Responsive.isMobile(context) ? 12 : 20,
                //           fontWeight: FontWeight.w500,
                //           color: AppColors.primaryColor
                //       ),
                //
                //     ))
              ],
            ),
          ),
          SizedBox(height: Responsive.isMobile(context) ? 25 : 50),
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
                    ? 18
                    : (isLargeScreen ? 48 : 30.0),
                right: Responsive.isMobile(context)
                    ? 18
                    : (isLargeScreen ? 48 : 30.0),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: Responsive.isMobile(context)
                      ? 263
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
                    title: item.title,
                    description: item.description,
                    imagePath: item.imagePath,
                    timetext: item.timetext,
                    percentText: item.percentText, isFavorite: false.obs,
                  );
                },
              ),
            );
          }),
          SizedBox(height: Responsive.isMobile(context) ? 25 : 50),
          Padding(
            padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 18 : 48.0,right: Responsive.isMobile(context) ? 18 : 48.0, ),
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
                GestureDetector(
                    onTap: () {
                      if (onNavigate != null) {
                        onNavigate!(6); // Call the callback to navigate to the 7th screen
                      }
                    },
                    child: Text("view all",

                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryColor,
                          fontFamily: ',',
                          fontSize:  Responsive.isMobile(context) ? 12 : 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor
                      ),

                    ))
              ],
            ),
          ),
          SizedBox(height: Responsive.isMobile(context) ? 4 : 50),
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
                    ? 18
                    : (isLargeScreen ? 48 : 30.0),
                right: Responsive.isMobile(context)
                    ? 18
                    : (isLargeScreen ? 48 : 30.0),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: Responsive.isMobile(context)
                      ? 263
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
                  final item = recentlyViewedController.recentlyViewedItem[index];
                  return CustomRectangleWidget(
                    title: item.title,
                    description: item.description,
                    imagePath: item.imagePath,
                    timetext: item.timetext,
                    percentText: item.percentText, isFavorite: false.obs,
                  );
                },
              ),
            );
          }),
          SizedBox(height: Responsive.isMobile(context) ? 25 : 50),
          SizedBox(height: Responsive.isMobile(context) ? 25 : 50),
          Padding(
            padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 18 : 48.0,right: Responsive.isMobile(context) ? 18 : 48.0, ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter A z',
                  style: TextStyle(
                    color: AppColors.botomSheetColor,
                    fontFamily: 'aftika-regular',
                    fontSize: Responsive.isMobile(context) ? 18 : 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      if (onNavigate != null) {
                        onNavigate!(6); // Call the callback to navigate to the 7th screen
                      }
                    },
                    child: Text("view all 587 results",

                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryColor,
                          fontFamily: ',',
                          fontSize:  Responsive.isMobile(context) ? 12 : 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor
                      ),

                    ))
              ],
            ),
          ),
          SizedBox(height: Responsive.isMobile(context) ? 8 : 20),
          Padding(
            padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 18 : 48.0,right: Responsive.isMobile(context) ? 18 : 48.0, ),
            child: Text(
              '# A B C D E F G H I J K L M N O',
              style: TextStyle(
                color: AppColors.textColor,
                fontFamily: 'Nunito-Regular',
                fontSize: Responsive.isMobile(context) ? 10 : 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: Responsive.isMobile(context) ? 8 :20),
          Obx(() {
            //Determine item count based on screen type
            int itemCount;
            if (Responsive.isMobile(context)) {
              itemCount = filterController.filterItem.length
                  > 2
                  ? 4
                  : filterController.filterItem.length;
            } else if (Responsive.isTablet(context)) {
              itemCount = filterController.filterItem.length
                  > 3
                  ? 6
                  : filterController.filterItem.length;
            } else {
              itemCount = filterController.filterItem.length > 4
                  ? filterController.filterItem.length
                  : filterController.filterItem.length;
            }

            return Padding(
              padding: EdgeInsets.only(
                left: Responsive.isMobile(context)
                    ? 18
                    : (isLargeScreen ? 48 : 30.0),
                right: Responsive.isMobile(context)
                    ? 18
                    : (isLargeScreen ? 48 : 30.0),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: Responsive.isMobile(context)
                      ? 50
                      : (isLargeScreen ? 120 : 100),
                  crossAxisCount: Responsive.isMobile(context)
                      ? 2
                      : (Responsive.isTablet(context) ? 2 : 3),
                  crossAxisSpacing: Responsive.isMobile(context)
                      ? 10
                      : (Responsive.isTablet(context) ? 8 : 10),
                  mainAxisSpacing: Responsive.isMobile(context)
                      ? 12
                      : (Responsive.isTablet(context) ? 2 : 30),
                  childAspectRatio: filterItemWidth / filterItemHeight,
                ),
                itemCount:itemCount,
                itemBuilder: (context, index) {
                  final item = filterController.filterItem[index];
                  return CustomFilterWidget(
                    title: item.title,
                    description: item.description,
                    imgPath: item.imagePath,

                  );
                },
              ),
            );
          }),


          
          SizedBox(height: Responsive.isMobile(context) ? 4 : 50),



        ],
      );
    });

  }
}
