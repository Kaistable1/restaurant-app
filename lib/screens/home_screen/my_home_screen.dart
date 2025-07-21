import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/app_info/about_app/about_app.dart';
import 'package:kaistable_website/screens/app_info/contact_us/contact_us.dart';
import 'package:kaistable_website/screens/app_info/privacy_policy/privacy_policy.dart';
import 'package:kaistable_website/screens/app_info/terms_and_condition/terms_and_condition.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/screens/favorite_screen/favorite_screen.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_cusiness_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_new_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_recently_viewed_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_theme_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_trending_controller.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/home_screen_controller.dart'
    show HomeFilterController, HomeFilterSearchController;
import 'package:kaistable_website/screens/onboarding_screen/onboarding_controller/onboarding_controller.dart';

import 'package:kaistable_website/widgets/global_functions.dart';

import '../../constants/app_colors.dart';
import '../../widgets/home_widgets/all_categories.dart';
import '../../widgets/home_widgets/filter_widget.dart';
import '../../widgets/rectangle_widget.dart';
import '../change_pass/changePassword_dialoge.dart';
import '../edit_profile/edit_profile_page.dart';
import 'home_controller/filter_selection_controller.dart';

class MyHomeScreen extends StatefulWidget {
  final String? countryName;

  const MyHomeScreen({super.key, this.countryName});

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final RxBool isTapped = false.obs;

  final RxBool showFilterOptions = false.obs;
  final List<String> imagePaths = [
    "assets/images/banner.png",
    "assets/images/banner.png",
    "assets/images/banner.png",
  ];

  List<String> countries = [
    "New York",
    "Los Angeles",
  ];

  // Selected country

  final HomeLocationController controller = Get.put(HomeLocationController());
  final HomeThemeController themeController = Get.put(HomeThemeController());
  final FilterSelectionController filterSelectionController =
      Get.put(FilterSelectionController());
  final HomeRecentlyViewedController recentlyViewedController =
      Get.put(HomeRecentlyViewedController());
  final HomeCusinessController cusinessController =
      Get.put(HomeCusinessController());
  final HomeTrendingController trendingController =
      Get.put(HomeTrendingController());
  final HomeNewController newController = Get.put(HomeNewController());
  final HomeFilterSearchController filterController = Get.put(HomeFilterSearchController());
  final onboradingController = Get.put(OnboardingController());
  final scrollController = ScrollController();
  int _selectedIndex = 0; // Track the selected index
  Color decorationLineColor =
      Colors.transparent; // Default color for decoration line

  void _onItemTapped(int index, {isHome}) {
    setState(() {
      _selectedIndex = index; // Update selected index
      decorationLineColor = Theme.of(context).primaryColor;
      if (isHome) Get.back(); // Set decoration line color to primary
    });

    // Navigate to the corresponding screen based on the index
    switch (index) {
      case 0:
        Get.to(const MyHomeScreen());
        break;
      case 1:
        Get.to(FavoriteScreen());
        break;
      case 2:
        Get.to(EditProfilePage());
        break;
      case 3:
        changePasswordDialogBox();
        break;
      case 4:
        Get.to(const TermsAndCondition());
        break;
      case 5:
        Get.to(const PrivacyPolicy());
        break;
      case 6:
        Get.to(const AboutApp());
        break;
      case 7:
        Get.to(ContactUs());
        break;
    }
  }

  String selectedCountry = '';
  @override
  void initState() {
    super.initState();
    getCurrentUserData();
    selectedCountry = widget.countryName ?? 'USA';
  }

  bool isSearching = false;

  List<RestaurantModel> filterRestaurants(
      List<RestaurantModel> restaurants, String query) {
    print('---------calling filter');
    query = query
        .toLowerCase(); // Convert query to lowercase for case-insensitive search
    final int? queryNumber =
        int.tryParse(query); // Try to parse query as a number

    return restaurants.where((restaurant) {
      // Check if the query is numeric
      if (queryNumber != null) {
        // If numeric, match with zipCode
        return restaurant.zipCode == query;
      }
      print(
          'cuisines ------- ${restaurant.menuList.map((item) => item.cuisineType.contains(query)).any((element) => element)}');
      // If not numeric, check all fields for matches
      return restaurant.resName.toLowerCase().contains(query.toLowerCase()) ||
          restaurant.city.toLowerCase().contains(query.toLowerCase()) ||
          restaurant.address.toLowerCase().contains(query.toLowerCase()) ||
          restaurant.zipCode.toLowerCase().contains(query) ||
          restaurant.menuList
              .map((item) => item.cuisineType.contains(query))
              .any((element) => element) ||
          restaurant.country.toLowerCase().contains(query.toLowerCase()) ||
          restaurant.about.toLowerCase().contains(query.toLowerCase()) ||
          restaurant.socialLink.toLowerCase().contains(query) ||
          restaurant.priceRange.toLowerCase().contains(query) ||
          restaurant.specialConditions.toLowerCase().contains(query) ||
          restaurant.spokenLanguage
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          // filter by events
          restaurant.entertainmentScheduleList.any((item) =>
              item.eventName.toLowerCase().contains(query) ||
              item.eventBy.toLowerCase().contains(query)) ||
          restaurant.facilityList.any((facility) => facility
              .toLowerCase()
              .contains(query)) || // Check in facilityList
          restaurant.dietaryList.any((dietary) =>
              dietary.toLowerCase().contains(query)) || // Check in dietaryList
          restaurant.atmosphereList.any((atmosphere) => atmosphere
              .toLowerCase()
              .contains(query)); // Check in atmopshereList
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUserData();
    String previousText = '';

    controller.searchController.addListener(() {
      final text = controller.searchController.text.trim();
      isSearching = text.isNotEmpty;
      setState(() {});
    });
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          iconTheme: const IconThemeData(
            color: AppColors.primaryColor,
          ),
          centerTitle: true,
          title: const Text(
            'Search',
            style: TextStyle(
              fontSize: 17,
              color: AppColors.bottomSheetColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito-Bold',
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterWidget(),
              SizedBox(height: 20,),

              // 🔄 UPDATED: Filter logic to always apply on fresh snapshot.data

              isSearching
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore Restaurants',
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: 'aftika-regular',
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          StreamBuilder(
                            stream: controller.getAllRestaurants(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                  height: Get.height * 0.5,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.hasError) {
                                return Text('Error: \${snapshot.error}');
                              }

                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Text('No restaurants found');
                              }

                              List<RestaurantModel> restaurants =
                                  snapshot.data!;
                              List<RestaurantModel> result = filterRestaurants(
                                  restaurants,
                                  controller.searchController.text);

                              if (result.isEmpty) {
                                return _buildEmptyState('No restaurants found');
                              }

                              return _buildRestaurantGrid(result);
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    )
                  : Obx(() {
                      if (filterSelectionController.aggregatedFilters.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 1),
                            AllCategories(),
                          ],
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Explore Restaurants',
                              style: TextStyle(
                                color: AppColors.bottomSheetColor,
                                fontFamily: 'aftika-regular',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 16),
                            StreamBuilder(
                              stream: controller.getAllRestaurants(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return buildShimmerEffect();
                                }

                                if (snapshot.hasError) {
                                  return Text('Error: \${snapshot.error}');
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Text('No restaurants found');
                                }

                                List<RestaurantModel> restaurants =
                                    snapshot.data!;
                                filterSelectionController
                                    .updateFilteredRestaurants(restaurants);

                                return Obx(() {
                                  return FutureBuilder<List<RestaurantModel>>(
                                    future: filterSelectionController
                                        .filteredRestaurantsFuture.value,
                                    builder: (context, futureSnapshot) {
                                      List<RestaurantModel> finalList =
                                          futureSnapshot.data ?? [];

                                      final searchText = controller
                                          .searchController.text
                                          .trim()
                                          .toLowerCase();
                                      if (searchText.isNotEmpty) {
                                        finalList = finalList
                                            .where((item) => item.resName
                                                .toLowerCase()
                                                .contains(searchText))
                                            .toList();
                                      }

                                      if (finalList.isEmpty) {
                                        return _buildEmptyState(
                                            'No restaurants found');
                                      }

                                      return _buildRestaurantGrid(finalList);
                                    },
                                  );
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      );
                    })

              //-----------------------------------------------
            ],
          ),
        ));
  }

// Helper functions for UI components
  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: Get.height * 0.5,
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return SizedBox(
      height: Get.height * 0.5,
      child: Center(
        child: Text(message),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return SizedBox(
      height: Get.height * 0.5,
      child: Center(
        child: Text(message),
      ),
    );
  }

  Widget _buildRestaurantGrid(List<RestaurantModel> restaurants) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //   mainAxisExtent: Get.height * 0.17,
      //   crossAxisCount: 2,
      //   crossAxisSpacing: 10,
      //   mainAxisSpacing: 20,
      // ),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final item = restaurants[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: InkWell(
            onTap: () {
              Get.to(RestaurantDetailScreen(restaurantModel: item));
            },
            child: RectangleWidget(
              title: item.resName,
              description: item.address,
              resturant_id: item.docID,
              imagePath: item.logoImage,
              timetext: '10 AM',
              percentText: '25%',
              endTimeText: '9 PM',
            
               height: 250,
            ),
          ),
        );
      },
    );
  }
}



// list of all restaurants
// filtered list
// getFilteredList(filters, originalList)
// {
//   if(filters.lenght===0)
//   {
//     filterList = originalList;
//   }
//   elseclass{
// filtered list originalList.filter(filters)
//   }
  
// }



//old code


            //  isSearching
//                   ? Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Explore Restaurants',
//                             style: TextStyle(
//                               color: AppColors.bottomSheetColor,
//                               fontFamily: 'aftika-regular',
//                               fontSize: 15,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 16,
//                           ),
//                           StreamBuilder(
//                             stream: controller.getAllRestaurants(),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return SizedBox(
//                                   height: Get.height * 0.5,
//                                   child: Center(
//                                       child: CircularProgressIndicator(
//                                     color: AppColors.primaryColor,
//                                   )),
//                                 );
//                               }

//                               if (snapshot.hasError) {
//                                 return Text('Error: ${snapshot.error}');
//                               }

//                               if (snapshot.data == null ||
//                                   snapshot.data!.isEmpty) {
//                                 return Text('No restaurants found');
//                               }
//                               // Get the list of restaurants
//                               List<RestaurantModel> restaurants =
//                                   snapshot.data!;

//                               controller.filteredRestaurants = restaurants;
//                               controller.update();

//                               // Add a listener to update filtering whenever the search query changes
//                               controller.searchController.addListener(() {
//                                 final text = controller.searchController.text;
//                                 controller.filteredRestaurants =
//                                     filterRestaurants(restaurants, text);
//                               });
//                               // Build the restaurant grid
//                               return GetBuilder<HomeLocationController>(
//                                 builder: (controller) {
//                                   return _buildRestaurantGrid(
//                                       controller.filteredRestaurants);
//                                 },
//                               );
//                             },
//                           ),
//                           SizedBox(
//                             height: 16,
//                           ),
//                         ],
//                       ),
//                     )
//                   : Obx(
//                       () => filterSelectionController
//                               .aggregatedFilters.isNotEmpty
//                           ? Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 16),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Explore Restaurants',
//                                     style: TextStyle(
//                                       color: AppColors.bottomSheetColor,
//                                       fontFamily: 'aftika-regular',
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 16,
//                                   ),
//                                   StreamBuilder(
//                                     stream: controller.getAllRestaurants(),
//                                     builder: (context, snapshot) {
//                                       if (snapshot.connectionState ==
//                                           ConnectionState.waiting) {
//                                         return buildShimmerEffect();
//                                       }

//                                       if (snapshot.hasError) {
//                                         return Text('Error: ${snapshot.error}');
//                                       }

//                                       if (snapshot.data == null ||
//                                           snapshot.data!.isEmpty) {
//                                         return Text('No restaurants found');
//                                       }

//                                       // Apply filtering logic here -----------

//                                       List<RestaurantModel> restaurants =
//                                           snapshot.data!;
//                                       print(
//                                           'aggretive ------- ${filterSelectionController.aggregatedFilters}');

//                                       // filter by cuisines
//                                       if (filterSelectionController
//                                           .selectedFilters.isNotEmpty) {
//                                         print('flag 1');
//                                         restaurants =
//                                             restaurants.where((restaurant) {
//                                           // Convert both lists to lowercase
//                                           List<String>
//                                               selectedFiltersLowercase =
//                                               filterSelectionController
//                                                   .aggregatedFilters
//                                                   .map((filter) =>
//                                                       filter.toLowerCase())
//                                                   .toList();
//                                           List<String>
//                                               restaurantCuisinesLowercase =
//                                               restaurant.menuList
//                                                   .map((menu) => menu
//                                                       .cuisineType
//                                                       .toLowerCase())
//                                                   .toList();

//                                           // Check if any selected filter is contained in any restaurant cuisines
//                                           bool isMatch =
//                                               selectedFiltersLowercase
//                                                   .any((selectedFilter) {
//                                             return restaurantCuisinesLowercase
//                                                 .any((restaurantFacility) {
//                                               return restaurantFacility
//                                                   .contains(selectedFilter);
//                                             });
//                                           });
//                                           return isMatch;
//                                         }).toList();
//                                       }

//                                       // Filter by City
//                                       if (filterSelectionController
//                                           .selectedCity.isNotEmpty) {
//                                         print('flag 2 ');
//                                         restaurants =
//                                             restaurants.where((restaurant) {
//                                           bool isCityMatched =
//                                               filterSelectionController
//                                                   .aggregatedFilters
//                                                   .map((e) => e.toLowerCase())
//                                                   .any((filter) => restaurant
//                                                       .city
//                                                       .toLowerCase()
//                                                       .contains(filter));
//                                           return isCityMatched;
//                                         }).toList();
//                                       }

//                                       // Filter by Atmosphere
//                                       if (filterSelectionController
//                                           .selectedAtmosphere.isNotEmpty) {
//                                         print('flag 5');
//                                         restaurants =
//                                             restaurants.where((restaurant) {
//                                           // Convert both lists to lowercase
//                                           List<String>
//                                               selectedFiltersLowercase =
//                                               filterSelectionController
//                                                   .aggregatedFilters
//                                                   .map((filter) =>
//                                                       filter.toLowerCase())
//                                                   .toList();
//                                           List<String>
//                                               restaurantAtmosphereLowercase =
//                                               restaurant.atmosphereList
//                                                   .map((atmosphere) =>
//                                                       atmosphere.toLowerCase())
//                                                   .toList();
//                                           // Check if any selected filter is contained in any restaurant atmosphere
//                                           bool isMatch =
//                                               selectedFiltersLowercase
//                                                   .any((selectedFilter) {
//                                             return restaurantAtmosphereLowercase
//                                                 .any((restaurantAtmosphere) {
//                                               return restaurantAtmosphere
//                                                   .contains(selectedFilter);
//                                             });
//                                           });
//                                           return isMatch;
//                                         }).toList();
//                                       }

//                                       // Filter by Facilities
//                                       if (filterSelectionController
//                                           .selectedFacilities.isNotEmpty) {
//                                         print('flag 6');
//                                         restaurants =
//                                             restaurants.where((restaurant) {
//                                           // Convert both lists to lowercase
//                                           List<String>
//                                               selectedFiltersLowercase =
//                                               filterSelectionController
//                                                   .aggregatedFilters
//                                                   .map((filter) =>
//                                                       filter.toLowerCase())
//                                                   .toList();
//                                           List<String>
//                                               restaurantFacilitiesLowercase =
//                                               restaurant.facilityList
//                                                   .map((facility) =>
//                                                       facility.toLowerCase())
//                                                   .toList();
//                                           // Check if any selected filter is contained in any restaurant facility
//                                           bool isMatch =
//                                               selectedFiltersLowercase
//                                                   .any((selectedFilter) {
//                                             return restaurantFacilitiesLowercase
//                                                 .any((restaurantFacility) {
//                                               return restaurantFacility
//                                                   .contains(selectedFilter);
//                                             });
//                                           });
//                                           return isMatch;
//                                         }).toList();
//                                       }

//                                       // Filter by Entertainment
//                                       if (filterSelectionController
//                                           .selectedEntertainment.isNotEmpty) {
//                                         print('flag 7');
//                                         restaurants =
//                                             restaurants.where((restaurant) {
//                                           // Check if any item in the restaurant's entertainmentScheduleList matches the selected filters
//                                           return restaurant
//                                               .entertainmentScheduleList
//                                               .any((schedule) {
//                                             return filterSelectionController
//                                                 .aggregatedFilters
//                                                 .any((filter) {
//                                               // Compare the relevant fields (e.g., eventName, eventBy, date, etc.)
//                                               return schedule.eventName
//                                                       .toLowerCase() ==
//                                                   filter.toLowerCase();
//                                             });
//                                           });
//                                         }).toList();
//                                       }

//                                       // Filter by Dietary
//                                       if (filterSelectionController
//                                           .selectedDietary.isNotEmpty) {
//                                         print('flag 8');
//                                         restaurants =
//                                             restaurants.where((restaurant) {
//                                           // Convert both lists to lowercase
//                                           List<String>
//                                               selectedFiltersLowercase =
//                                               filterSelectionController
//                                                   .aggregatedFilters
//                                                   .map((filter) =>
//                                                       filter.toLowerCase())
//                                                   .toList();
//                                           List<String>
//                                               restaurantDietaryLowercase =
//                                               restaurant.dietaryList
//                                                   .map((dietary) =>
//                                                       dietary.toLowerCase())
//                                                   .toList();
//                                           // Check if any selected filter is contained in any restaurant dietary option
//                                           bool isMatch =
//                                               selectedFiltersLowercase
//                                                   .any((selectedFilter) {
//                                             return restaurantDietaryLowercase
//                                                 .any((restaurantDietary) {
//                                               return restaurantDietary
//                                                   .contains(selectedFilter);
//                                             });
//                                           });
//                                           return isMatch;
//                                         }).toList();
//                                       }

//                                       // Filter by Price Range
//                                       if (filterSelectionController
//                                           .selectedPriceRange.isNotEmpty) {
//                                         print('flag 9');
//                                         restaurants =
//                                             restaurants.where((restaurant) {
//                                           return filterSelectionController
//                                               .aggregatedFilters
//                                               .map((e) => e.toLowerCase())
//                                               .contains(restaurant.priceRange
//                                                   .toLowerCase());
//                                         }).toList();
//                                       }

//                                       // Initialize filtered restaurants
//                                       // WidgetsBinding.instance
//                                       //     .addPostFrameCallback((_) {
//                                       //   controller
//                                       //       .initializeSelectors(restaurants);
//                                       // });

//                                       controller.filteredRestaurants =
//                                           restaurants;
//                                       controller.update(); // ✅ force rebuild

//                                       return FutureBuilder<
//                                           List<RestaurantModel>>(
//                                         future: filterSelectionController
//                                                 .aggregatedFilters
//                                                 .any((filter) =>
//                                                     filterSelectionController
//                                                         .selectedTimeOfDay
//                                                         .contains(filter))
//                                             ? _getFilteredRestaurants(
//                                                 restaurants)
//                                             : null,
//                                         builder: (context, futureSnapshot) {
//                                           // Handle the first FutureBuilder for filtered restaurants
//                                           // List<RestaurantModel>
//                                           //     timeOfDayRestaurants =
//                                           //     futureSnapshot.data ?? [];

//                                           List<RestaurantModel>
//                                               timeOfDayRestaurants =
//                                               futureSnapshot.data ??
//                                                   restaurants;

//                                           if (filterSelectionController
//                                               .aggregatedFilters
//                                               .map((e) => e.toLowerCase())
//                                               .any((filter) =>
//                                                   filterSelectionController
//                                                       .selectedTimeOfDay
//                                                       .map((e) =>
//                                                           e.toLowerCase())
//                                                       .contains(filter))) {
//                                             if (filterSelectionController
//                                                 .aggregatedFilters
//                                                 .map((e) => e.toLowerCase())
//                                                 .any((filter) =>
//                                                     filterSelectionController
//                                                         .selectedTimeOfDay
//                                                         .map((e) =>
//                                                             e.toLowerCase())
//                                                         .contains(filter))) {
//                                               // Use fresh list from StreamBuilder, not stale controller.filteredRestaurants
//                                               // Final assignment: always apply filters to snapshot.data (fresh list)
//                                               List<RestaurantModel>
//                                                   finalFilteredList =
//                                                   snapshot.data!;

// // Apply TimeOfDay filtering if needed
//                                               if (filterSelectionController
//                                                   .selectedTimeOfDay
//                                                   .isNotEmpty) {
//                                                 finalFilteredList =
//                                                     timeOfDayRestaurants;
//                                               }

// // Apply search filtering
//                                               final searchText = controller
//                                                   .searchController.text
//                                                   .trim()
//                                                   .toLowerCase();
//                                               if (searchText.isNotEmpty) {
//                                                 finalFilteredList =
//                                                     finalFilteredList
//                                                         .where((item) {
//                                                   return item.resName
//                                                       .toLowerCase()
//                                                       .contains(searchText);
//                                                 }).toList();
//                                               }

// // Assign to controller
//                                               controller.filteredRestaurants =
//                                                   finalFilteredList;
//                                               controller.update();
//                                             } else {
//                                               controller.filteredRestaurants =
//                                                   restaurants; // fallback
//                                             }
//                                             controller
//                                                 .update(); // force UI to rebuild
//                                           }

//                                           // Listen for search changes and filter restaurants accordingly
//                                           controller.searchController
//                                               .addListener(() {
//                                             controller.filteredRestaurants =
//                                                 restaurants
//                                                     .where((item) => item
//                                                         .resName
//                                                         .toLowerCase()
//                                                         .contains(controller
//                                                             .searchController
//                                                             .text
//                                                             .toLowerCase()))
//                                                     .toList();
//                                             controller.update();
//                                           });
//                                           if (controller
//                                               .filteredRestaurants.isEmpty) {
//                                             return _buildEmptyState(
//                                                 'No restaurants found');
//                                           }
//                                           return GetBuilder<
//                                               HomeLocationController>(
//                                             builder: (controller) {
//                                               return _buildRestaurantGrid(
//                                                   controller
//                                                       .filteredRestaurants);
//                                             },
//                                           );
//                                         },
//                                       );
//                                     },
//                                   ),
//                                   SizedBox(
//                                     height: 16,
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(height: 1),
//                                 AllCategories(),
//                               ],
//                             ),
//                     ),