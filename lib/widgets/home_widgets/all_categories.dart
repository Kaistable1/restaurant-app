import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/home_screen/explore_restaurants/explore_restaurant.dart';
import 'package:kaistable_website/screens/home_screen/location_pages/location_screen.dart';
import 'package:kaistable_website/screens/home_screen/location_pages/location_view_all/location_view_all.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_controller/onboarding_controller.dart';

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
import '../../screens/home_screen/new_view_all/new_viewall.dart';
import '../../screens/home_screen/trending_all/trending_view_all.dart';

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
  final onboradingController = Get.put(OnboardingController());
  AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
    bool isOnboarding = onboradingController.selectedCountry.value != 'Country';
    return Column(
      children: [
        _buildTopSection(),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTopSection() {
    final HomeLocationController controller = Get.put(HomeLocationController());
    final onboradingController = Get.put(OnboardingController());

    bool isOnboarding = onboradingController.selectedCountry.value != 'Country';

    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: StreamBuilder(
          stream: controller.getRestaurants(
            city: isOnboarding
                ? onboradingController.selectedCity.value ?? ''
                : currentUserDataModel?.value.city ?? "",
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(); // Show loading indicator
            }

            if (snapshot.hasError) {
              print('Error during stream call ${snapshot.error}');
              return Text(''); // Show error message if any
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Text(''); // Handle the case where data is null or empty
            }
            List<RestaurantModel> restaurants = snapshot.data!;
            // Initialize state after the widget build phase
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.initailizedSelectors(resaturantsList: restaurants);
            });

            return Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(
                    left: 0,
                    right: 18,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You May Like",
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: 'aftika-regular',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: Get.height * 0.27,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final item = restaurants[index];
                    return InkWell(
                      onTap: () {
                        Get.to(RestaurantDetailScreen(
                          restaurantModel: item,
                        ));
                      },
                      child: RectangleWidget(
                        title: item.resName,
                        description: item.about,
                        resturant_id: item.docID,
                        imagePath: item.logoImage,
                        timetext: '10 AM',
                        percentText: '25%',
                        endTimeText: '9 PM',
                        percentageOff: item.menuList.percentageOff,
                        happyhour: item.menuList.happyHourSpecials,
                        isFavorite: false.obs,
                      ),
                    );
                  },
                ),
              ],
            );
          }),
    );
  }
}
