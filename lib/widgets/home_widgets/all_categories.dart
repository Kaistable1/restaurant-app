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
  final HomeRecentlyViewedController recentlyViewedController =
      Get.put(HomeRecentlyViewedController());
  final HomeCusinessController cusinessController =
      Get.put(HomeCusinessController());
  final HomeTrendingController trendingController =
      Get.put(HomeTrendingController());
  final HomeNewController newController = Get.put(HomeNewController());
  final HomeFilterController filterController = Get.put(HomeFilterController());
  final scrollController = ScrollController();

  AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8, right: 6),
          child: SizedBox(
            height: 180,
            child: ListView.builder(
              controller: controller.scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: controller.circleItems.length, // Number of items
              itemBuilder: (context, index) {
                final item =
                    controller.circleItems[index]; // Get item from model list
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.only(
            left: 14,
            right: 18,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cuisines',
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontFamily: 'aftika-regular',
                  fontSize: 18,
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
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor),
                  ))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8, right: 6),
          child: SizedBox(
            height: 180,
            child: ListView.builder(
              controller: controller.scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: cusinessController.cusinessItem.take(6).length,
              itemBuilder: (context, index) {
                final item = cusinessController.cusinessItem[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: CircleContainerWidget(
                    ontap: () {
                      Get.to(CuisinesViewAll());
                    },
                    isFavourite: false.obs,
                    isLocation: false,
                    imgPath: item.imagePath,
                    titleText: item.title,
                    descriptionText: item.description,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(
            left: 14,
            right: 18,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending',
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontFamily: 'aftika-regular',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              InkWell(
                  onTap: () {
                    Get.to(TrendingViewAll());
                  },
                  child: Text(
                    "view all",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primaryColor,
                        fontFamily: 'Nunito-Regular',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor),
                  ))
            ],
          ),
        ),
        SizedBox(height: 12),
        Obx(() {
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
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: trendingController.trendingItem.take(2).length,
              itemBuilder: (context, index) {
                final item = trendingController.trendingItem[index];
                return RectangleWidget(
                  //onNavigate: onNavigate,
                  title: item.title,
                  description: item.description,
                  imagePath: item.imagePath,
                  timetext: item.timetext,
                  percentText: item.percentText,
                  endTimeText: item.endTimeText,
                  isFavorite: false.obs,
                );
              },
            ),
          );
        }),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.only(
            left: 14,
            right: 18,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New',
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontFamily: 'aftika-regular',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              InkWell(
                  onTap: () {
                    Get.to(NewViewall());
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
        SizedBox(height: 12),
        Obx(() {
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
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: newController.newItem.take(2).length,
              itemBuilder: (context, index) {
                final item = newController.newItem[index];
                return RectangleWidget(
                  //onNavigate: onNavigate,
                  title: item.title,
                  description: item.description,
                  imagePath: item.imagePath,
                  timetext: item.timetext,
                  percentText: item.percentText,
                  endTimeText: item.endTimeText,
                  isFavorite: false.obs,
                );
              },
            ),
          );
        }),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.only(
            left: 14,
            right: 18,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently Viewed',
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontFamily: 'aftika-regular',
                  fontSize: 18,
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
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor),
                  ))
            ],
          ),
        ),
        SizedBox(height: 12),
        Obx(() {
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
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount:
                  recentlyViewedController.recentlyViewedItem.take(2).length,
              itemBuilder: (context, index) {
                final item = recentlyViewedController.recentlyViewedItem[index];
                return RectangleWidget(
                  //   onNavigate: onNavigate,
                  title: item.title,
                  description: item.description,
                  imagePath: item.imagePath,
                  timetext: item.timeText,
                  percentText: item.percentText,
                  endTimeText: item.endTimeText,
                  isFavorite: false.obs,
                );
              },
            ),
          );
        }),
        SizedBox(height: 16),
      ],
    );
  }
}
