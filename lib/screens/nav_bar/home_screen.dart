import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/screens/home_screen/cuisiness_viewall/cuisines_view_all.dart';
import 'package:kaistable_website/screens/home_screen/entertainment/entertainments.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import 'package:kaistable_website/screens/home_screen/location_pages/location_screen.dart';
import 'package:kaistable_website/screens/home_screen/new_view_all/new_viewall.dart';
import 'package:kaistable_website/screens/home_screen/trending_all/trending_view_all.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_controller/onboarding_controller.dart';
import 'controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 190,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    controller.currentIndex.value = index;
                  },
                ),
                items: controller.carouselImages.map((image) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(image,
                        fit: BoxFit.contain, width: double.infinity),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 10,
              ),
              _buildCategories(),
              _buildTrendingSection(),
              Container(
                width: Get.width,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/ad1.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _buildTopSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Obx(() => SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              var category = controller.categories[index];
              return GestureDetector(
                onTap: () {
                  if (category['name'] == 'Cuisines') {
                    Get.to(CuisinesViewAll());
                  } else if (category['name'] == 'New') {
                    Get.to(NewViewall());
                  } else if (category['name'] == 'Trending') {
                    Get.to(TrendingViewAll());
                  } else if (category['name'] == 'Entertainment') {
                    Get.to(EntertainmentsScreen());
                  }
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(category["image"] as String),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      category["name"] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.bottomSheetColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Nunito-Sans',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  Widget _buildTrendingSection() {
    final HomeLocationController controller = Get.put(HomeLocationController());

    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: StreamBuilder(
          stream: controller.getTrendingRestaurants(),
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
                            'Trending',
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: 'aftika-regular',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
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
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor),
                          ))
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height:
                      Get.height * 0.22, // Fixed height for the horizontal list
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final item = restaurants[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(RestaurantDetailScreen(
                            restaurantModel: item,
                          ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Container(
                                width: 172,
                                height: 124,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(item.logoImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              item.resName,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.headingTextColor,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Nunito-Sans',
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.3,
                              child: Text(
                                "${item.about}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Nunito-Sans',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          }),
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
                SizedBox(height: 20),
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
                            "Nearby restaurants ",
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: 'aftika-regular',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            Get.to(LocationScreen());
                          },
                          child: Text(
                            "view all",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primaryColor,
                                fontFamily: 'Nunito-Regular',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor),
                          ))
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height:
                      Get.height * 0.22, // Fixed height for the horizontal list
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final item = restaurants[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(RestaurantDetailScreen(
                            restaurantModel: item,
                          ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Container(
                                width: 172,
                                height: 124,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(item.logoImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              item.resName,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.headingTextColor,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Nunito-Sans',
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.3,
                              child: Text(
                                "${item.about}",
                                style: TextStyle(
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Nunito-Sans',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          }),
    );
  }
}
