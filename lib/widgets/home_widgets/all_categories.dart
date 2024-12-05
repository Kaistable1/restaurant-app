import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/circle_container_widget.dart';
import '../../../widgets/rectangle_widget.dart';
import '../../screens/detail_screens/restaurant_detail_screen.dart';
import '../../screens/home_screen/cuisiness_viewall/cuisines_view_all.dart';
import '../../screens/home_screen/home_controller/home_cusiness_controller.dart';
import '../../screens/home_screen/home_controller/home_filter_controller.dart';
import '../../screens/home_screen/home_controller/home_location_controller.dart';
import '../../screens/home_screen/home_controller/home_new_controller.dart';
import '../../screens/home_screen/home_controller/home_recently_viewed_controller.dart';
import '../../screens/home_screen/home_controller/home_theme_controller.dart';
import '../../screens/home_screen/home_controller/home_trending_controller.dart';
import '../../screens/home_screen/location_pages/location_screen.dart';
import '../../screens/home_screen/new_view_all/new_viewall.dart';
import '../../screens/home_screen/recently_viewed/recently_viewed.dart';
import '../../screens/home_screen/theme/theme_view_all.dart';
import '../../screens/home_screen/trendind_all/trending_view_all.dart';

class AllCategories extends StatelessWidget {
  final HomeLocationController controller = Get.put(HomeLocationController());
  final HomeThemeController themeController = Get.put(HomeThemeController());
  final HomeRecentlyViewedController recentlyViewedController = Get.put(HomeRecentlyViewedController());
  final HomeCusinessController cusinessController = Get.put(HomeCusinessController());
  final HomeTrendingController trendingController = Get.put(HomeTrendingController());
  final HomeNewController newController = Get.put(HomeNewController());
  final HomeFilterController filterController = Get.put(HomeFilterController());
  final scrollController = ScrollController();
   AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        SizedBox(height: Responsive.isMobile(context) ? 10 : 50),
        // Padding(
        //   padding: EdgeInsets.only(
        //     left: Responsive.isMobile(context) ? 14 : 48.0,
        //     right: Responsive.isMobile(context) ? 18 : 48.0,
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(
        //         'Theme',
        //         style: TextStyle(
        //           color: AppColors.botomSheetColor,
        //           fontFamily: 'aftika-regular',
        //           fontSize: Responsive.isMobile(context) ? 18 : 40,
        //           fontWeight: FontWeight.w400,
        //         ),
        //       ),
        //       InkWell(
        //           onTap: () {
        //             Get.to(ThemeViewAll( ));
        //           },
        //           child: Text(
        //
        //             "view all",
        //             style: TextStyle(
        //
        //                 decoration: TextDecoration.underline,
        //
        //                 decorationColor: AppColors.primaryColor,
        //                 fontFamily: 'Nunito-Regular',
        //                 fontSize: Responsive.isMobile(context) ? 12 : 20,
        //                 fontWeight: FontWeight.w500,
        //                 color: AppColors.primaryColor),
        //           ))
        //     ],
        //   ),
        // ),
        // SizedBox(height: Responsive.isMobile(context) ? 10 : 50),
        // Padding(
        //   padding: EdgeInsets.only(
        //       left: Responsive.isMobile(context) ? 8 : 42, right: 6),
        //   child: SizedBox(
        //     height: 180,
        //     child: ListView.builder(
        //       controller: themeController.scrothemellController,
        //       scrollDirection: Axis.horizontal,
        //       itemCount:
        //       themeController.circleItems.length, // Number of items
        //       itemBuilder: (context, index) {
        //         final item = themeController
        //             .circleItems[index]; // Get item from model list
        //         return Padding(
        //           padding: EdgeInsets.symmetric(
        //               horizontal: 6,
        //               vertical: Responsive.isMobile(context) ? 6 : 6),
        //           child: CircleContainerWidget(
        //             ontap: (){
        //               Get.to(RestaurantDetailScreen());
        //             },
        //             isLocation: false,
        //             imgPath: item.imgPath,
        //             titleText: item.titleText,
        //             descriptionText: item.descriptionText,
        //             isFavourite: false.obs,
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // ),
        // SizedBox(height: Responsive.isMobile(context) ? 10 : 50),
        Padding(
          padding: EdgeInsets.only(
            left: Responsive.isMobile(context) ? 14 : 48.0,
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

              left:14,
              right:14,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 220,
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
                return RectangleWidget(
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
            left: Responsive.isMobile(context) ? 14 : 48.0,

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
              left: 14,
              right:14,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 220,
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
                return RectangleWidget(
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
            left: Responsive.isMobile(context) ? 14 : 48.0,
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
              left: 14,
              right: 14,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 220,
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
                return RectangleWidget(
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
            left: Responsive.isMobile(context) ? 14 : 48.0,
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
              left: 14,
              right: 14,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 220,
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
                return RectangleWidget(
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
        SizedBox(height: Responsive.isMobile(context) ? 10 : 50),
      ],
    );
  }
}
