import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/widgets/rectangle_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../custom_widget/separate_text_field.dart';
import '../../../utils/responsive.dart';
import '../home_controller/home_location_controller.dart';
import '../home_controller/home_trending_controller.dart';

class TrendingViewAll extends StatefulWidget {
  final Function(int)? onNavigate;
  final HomeLocationController homeController =
      Get.put(HomeLocationController());
  TrendingViewAll({
    super.key,
    this.onNavigate,
  }) {
    homeController.selectedTop.value = '';
  }

  @override
  State<TrendingViewAll> createState() => _TrendingViewAllState();
}

class _TrendingViewAllState extends State<TrendingViewAll> {
  final HomeTrendingController trendingController =
      Get.put(HomeTrendingController());

  final HomeLocationController homeController =
      Get.put(HomeLocationController());

  List<RestaurantModel> filteredRestaurants = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          int itemsPerRow = Responsive.isMobile(context)
              ? 2
              : Responsive.isTablet(context)
                  ? 3
                  : 4;
          double itemWidth = (constraints.maxWidth / itemsPerRow) - 16;
          double itemHeight = Responsive.isMobile(context)
              ? 320
              : (isLargeScreen ? 500 : 500); // Set a fixed height for items

          return Scaffold(
            backgroundColor: AppColors.bgColor,
            appBar: AppBar(
              backgroundColor: AppColors.bgColor,
              iconTheme: IconThemeData(
                color: AppColors
                    .primaryColor, // Set your desired color for the drawer icon
              ),
              centerTitle: true,
              automaticallyImplyLeading: true,
              leading: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.back(); // Navigate back to the home screen
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 18,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              title: Text(
                'Trending',
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.bottomSheetColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito-Bold',
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 38,
                      child: CustomSeparateTextField(
                        controller: homeController.searchController,
                        hintText: 'Try searching for restaurant name',
                        onChanged: (v) {
                          if (v.trim().isNotEmpty)
                            homeController.filterRestaurants(v);
                        },
                        hintStyle: TextStyle(
                          color: AppColors.hintText,
                          fontFamily: "Nunito-Regular",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                        isPrefixIcon: true,
                        isShadow: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                              left: 4, top: 8, bottom: 8, right: 0),
                          child: Image.asset(
                            'assets/images/search_icon.png',
                            fit: BoxFit.contain,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        isSuffixIcon: true,
                        suffixIcon: Container(
                          height: 38,
                          width: 66,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: AppColors.bottomSheetColor,
                                fontFamily: "Nunito-Bold",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Explore Restaurants',
                          style: TextStyle(
                            color: AppColors.bottomSheetColor,
                            fontFamily: 'aftika-regular',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    StreamBuilder(
                        stream: homeController.getTrendingRestaurants(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              height: Get.height * 0.5,
                              child: Center(child: CircularProgressIndicator()),
                            ); // Show loading indicator
                          }

                          if (snapshot.hasError) {
                            print('Error during stream call ${snapshot.error}');
                            return Text(''); // Show error message if any
                          }

                          if (snapshot.data == null || snapshot.data!.isEmpty) {
                            return Text(
                                'No restaurants found'); // Handle the case where data is null or empty
                          }

                          List<RestaurantModel> restaurants = snapshot.data!;
                          // Initialize filtered restaurants
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            homeController.initializeSelectors(restaurants);
                          });

                          return GetBuilder<HomeLocationController>(
                            builder: (controller) {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: Get.height * 0.27,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 20,
                                ),
                                itemCount:
                                    controller.filteredRestaurants.length,
                                itemBuilder: (context, index) {
                                  final item =
                                      controller.filteredRestaurants[index];
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
                                      percentageOff:
                                          item.menuList.percentageOff,
                                      happyhour:
                                          item.menuList.happyHourSpecials,
                                      isFavorite: false.obs,
                                    ),
                                  );
                                },
                              );
                           
                            },
                          );
                        }),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
