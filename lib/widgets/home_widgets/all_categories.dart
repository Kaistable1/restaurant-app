import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/recent_view.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/home_screen/explore_restaurants/explore_restaurant.dart';
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
import '../../screens/home_screen/recently_viewed/recently_viewed.dart';
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
        FutureBuilder(
            future: filterController.getRestaurantsGroupedByAddress(
              city: isOnboarding
                  ? onboradingController.selectedCity.value
                  : currentUserDataModel?.value.city,
            ),
            builder: (context, snapshot) {
              // 1. Check if the Future is still loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOnboarding
                            ? '${onboradingController.selectedCity.value}'
                            : '${currentUserDataModel?.value.city}',
                        style: TextStyle(
                          color: AppColors.bottomSheetColor,
                          fontFamily: 'aftika-regular',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 0; i < 3; i++)
                            Container(
                              width: 113,
                              height: 144,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 0,
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(150),
                                  topRight: Radius.circular(150),
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              // 2. Check if the Future is completed but has an error
              if (snapshot.hasError) {
                return SizedBox();
              }

              // 3. Check if the Future completed successfully but returned null
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              final addressMap = snapshot.data as Map<String, List<String>>;
              if (addressMap.isEmpty) {
                return Center(
                  child: Text(
                    '',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 18,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          isOnboarding
                              ? '${onboradingController.selectedCity.value}'
                              : '${currentUserDataModel?.value.city}',
                          style: TextStyle(
                            color: AppColors.bottomSheetColor,
                            fontFamily: 'aftika-regular',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              Get.to(LocationViewAll());
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
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 6),
                    child: SizedBox(
                      height: Get.height * 0.25,
                      child: ListView.builder(
                        controller: controller.scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: addressMap.keys.length,
                        itemBuilder: (context, index) {
                          final address = addressMap.keys.elementAt(index);
                          final restaurants =
                              addressMap[address]!.toSet().toList()..sort();
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            child: CircleContainerWidget(
                              ontap: () {
                                Get.to(() => ExploreRestaurant(
                                      restaurantIDs: restaurants,
                                      cuisneName: address,
                                    ));
                              },
                              isFavourite: false.obs,
                              isLocation: false,
                              imgPath: 'assets/images/aaa.jpg',
                              titleText: address,
                              descriptionText:
                                  '${restaurants.length.toString()} restaurants',
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
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
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor),
                  ))
            ],
          ),
        ),
        StreamBuilder<Map<String, List<String>>>(
          stream: filterController
              .getRestaurantsGroupedByCuisine(), // Stream to listen for changes
          builder: (context, streamSnapshot) {
            // 1. Check if the Stream is still loading
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 3; i++)
                    Container(
                      width: 113,
                      height: 144,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(150),
                          topRight: Radius.circular(150),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                ],
              );
            }

            // 2. Check if the Stream has an error
            if (streamSnapshot.hasError) {
              return SizedBox();
            }

            // 3. Check if the Stream completed successfully but returned null or empty data
            final cuisineMap = streamSnapshot.data ?? {};
            if (cuisineMap.isEmpty) {
              return Center(
                child: Text(
                  'No cuisines available',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            // 4. Return the GridView after data is loaded successfully
            return Padding(
              padding: EdgeInsets.only(left: 8, right: 6),
              child: SizedBox(
                height: Get.height * 0.25,
                child: ListView.builder(
                  controller: controller.scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: cuisineMap.keys.length,
                  itemBuilder: (context, index) {
                    final cuisineName = cuisineMap.keys.elementAt(index);
                    final restaurants =
                        cuisineMap[cuisineName]!.toSet().toList()..sort();

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
                      child: CircleContainerWidget(
                        ontap: () {
                          Get.to(() => ExploreRestaurant(
                                cuisneName: cuisineName,
                                restaurantIDs: restaurants,
                              ));
                        },
                        isFavourite: false.obs,
                        isLocation: false,
                        imgPath: 'assets/images/aaa.jpg',
                        titleText: cuisineName,
                        descriptionText:
                            '${restaurants.length.toString()} restaurants',
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),

        //showing trending restaurants
        Padding(
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
                  return Text(
                      ''); // Handle the case where data is null or empty
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
                                  fontSize: 18,
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
                      height: Get.height *
                          0.285, // Fixed height for the horizontal list
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final item = restaurants[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: 10), // Space between items
                            child: InkWell(
                              onTap: () {
                                Get.to(RestaurantDetailScreen(
                                  restaurantModel: item,
                                ));
                              },
                              child: SizedBox(
                                width: Get.width * 0.45,
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
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
        ),

        StreamBuilder(
            stream: controller.getRestaurants(),
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
                                  fontSize:
                                      Responsive.isMobile(context) ? 14 : 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    child: SizedBox(
                      height: Get.height *
                          0.26, // Fixed height for the horizontal list
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          // Sort the list by datetime before displaying
                          restaurants.sort((a, b) {
                            DateTime dateA = a.createdAt;
                            DateTime dateB = b.createdAt;
                            return dateB.compareTo(dateA); // Descending order
                          });
                          final item = restaurants[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: 10), // Space between items
                            child: InkWell(
                              onTap: () {
                                Get.to(RestaurantDetailScreen(
                                  restaurantModel: item,
                                ));
                              },
                              child: SizedBox(
                                width: Get.width * 0.45,
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
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),

        SizedBox(height: 16),
        StreamBuilder(
          stream: controller.getRestaurants(),
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
            return SizedBox(
              child: StreamBuilder<List<RecentViewModel>>(
                stream: controller.getRecentViews(),
                builder: (context, snapshot) {
                  List<RecentViewModel> restaurantIDs = snapshot.data ?? [];

                  // Sort the `restaurantIDs` list by `dateTime` in descending order
                  restaurantIDs.sort((a, b) =>
                      b.dateTime.compareTo(a.dateTime)); // Descending order

                  // Map restaurant IDs from the sorted `restaurantIDs` list
                  List<String> sortedRestaurantIds = restaurantIDs
                      .map((recentView) => recentView.restaurantID)
                      .toList();

                  List filteredRestaurants = [];

                  // Filter the restaurant list based on the sorted IDs and maintain the same order
                  if (restaurants.isNotEmpty) {
                    filteredRestaurants = sortedRestaurantIds
                        .map((id) {
                          // Find the restaurant with the matching docID using where
                          return restaurants
                              .where((restaurant) => restaurant.docID == id)
                              .toList();
                        })
                        .expand(
                            (element) => element) // Flatten the nested lists
                        .toList();
                  }

                  if (filteredRestaurants.isNotEmpty) {
                    return Column(
                      children: [
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primaryColor),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          child: SizedBox(
                            height: Get.height *
                                0.3, // Fixed height for the horizontal list
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredRestaurants
                                  .length, // Use filtered list length
                              itemBuilder: (context, index) {
                                final item = filteredRestaurants[index];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10), // Space between items
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(RestaurantDetailScreen(
                                        restaurantModel: item,
                                      ));
                                    },
                                    child: SizedBox(
                                      width: Get.width * 0.45,
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
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return SizedBox();
                },
              ),
            );
          },
        ),

        SizedBox(height: 16),
      ],
    );
  }
}
