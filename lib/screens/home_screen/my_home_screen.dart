import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/about_app/about_app.dart';
import 'package:kaistable_website/screens/auth_screens/login/login_screen.dart';
import 'package:kaistable_website/screens/contact_us/contact_us.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/screens/favorite_screen/favorite_screen.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_cusiness_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_filter_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_new_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_recently_viewed_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_theme_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_trending_controller.dart';
import 'package:kaistable_website/screens/home_screen/location_pages/location_screen.dart';
import 'package:kaistable_website/screens/home_screen/location_pages/location_view_all/location_view_all.dart';
import 'package:kaistable_website/screens/privacy_policy/privacy_policy.dart';
import 'package:kaistable_website/screens/terms_and_condition/terms_and_condition.dart';
import 'package:kaistable_website/widgets/custom_button.dart';
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
  final HomeFilterController filterController = Get.put(HomeFilterController());
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
        Get.to(ContactUs(scrollcontroller: scrollController));
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

  Future<Map<String, dynamic>?> getOperatingHours(String restaurantId) async {
    try {
      String currentDay = DateFormat('EEEE').format(DateTime.now());
      // Reference to the operatinghour subcollection of the restaurant
      var operatingHoursDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .collection('operatingHours')
          .doc(currentDay) // Assuming weekdays document
          .get();

      if (operatingHoursDoc.exists) {
        return operatingHoursDoc.data();
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching operating hours: $e');
      return null;
    }
  }

  Future<List<RestaurantModel>> _getFilteredRestaurants(
      List<RestaurantModel> restaurants) async {
    List<RestaurantModel> filteredRestaurants = [];
    List<String> timeOfDayList = filterSelectionController.aggregatedFilters;

    for (var restaurant in restaurants) {
      // Fetch operating hours for the restaurant
      var operatingHours = await getOperatingHours(restaurant.docID);

      if (operatingHours != null) {
        // Loop through the selected timeOfDay values from the user's filter
        for (var timeOfDay in timeOfDayList) {
          if (operatingHours.containsKey(timeOfDay)) {
            var timeSlot = operatingHours[timeOfDay];
            print('timeSlot $timeSlot');
            // Check if the restaurant is open for the selected time (i.e., 'isClosed' is false or null)
            var isClosed = timeSlot['isClosed'];

            // If 'isClosed' is false or null, add the restaurant to the filtered list
            if (isClosed == null || !isClosed) {
              filteredRestaurants.add(
                  restaurant); // Add restaurant if the selected time is open
              break; // Stop checking other times once a valid time is found for the restaurant
            }
          }
        }
      }
    }
    return filteredRestaurants;
  }

  bool isSearching = false;
  List<RestaurantModel> filterRestaurants(
      List<RestaurantModel> restaurants, String query) {
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

      // If not numeric, check all fields for matches
      return restaurant.resName.toLowerCase().contains(query) ||
          restaurant.city.toLowerCase().contains(query) ||
          restaurant.address.toLowerCase().contains(query) ||
          restaurant.zipCode.toLowerCase().contains(query) ||
          restaurant.country.toLowerCase().contains(query) ||
          restaurant.about.toLowerCase().contains(query) ||
          restaurant.socialLink.toLowerCase().contains(query) ||
          restaurant.priceRange.toLowerCase().contains(query) ||
          restaurant.specialConditions.toLowerCase().contains(query) ||
          restaurant.spokenLanguage.toLowerCase().contains(query) ||
          //filter by events
          restaurant.entertainmentScheduleList.any((item) =>
              item.eventName.toLowerCase().contains(query) ||
              item.eventBy.toLowerCase().contains(query)) ||
          restaurant.facilityList.any((facility) => facility
              .toLowerCase()
              .contains(query)) || // Check in facilityList
          restaurant.dietaryList.any((dietary) =>
              dietary.toLowerCase().contains(query)) || // Check in dietaryList
          restaurant.atmopshereList.any((atmosphere) => atmosphere
              .toLowerCase()
              .contains(query)); // Check in atmopshereList
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    controller.searchController.addListener(() {
      final text = controller.searchController.text;

      if (text.isNotEmpty) {
        isSearching = true;
      } else {
        isSearching = false;
      }
      setState(() {});
    });

    return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.bgColor,
          iconTheme: const IconThemeData(
            color: AppColors.primaryColor,
          ),
          centerTitle: true,
          title: const Text(
            'Home',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.bottomSheetColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito-Bold',
            ),
          ),
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
                          Get.to(LocationScreen(
                            city: currentUserDataModel?.value.city,
                            country: currentUserDataModel?.value.country,
                          ));
                        },
                        child: Text(
                          '${currentUserDataModel?.value.country}.${currentUserDataModel?.value.city}',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Nunito-Regular',
                            fontSize: 9,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
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
              _buildDrawerItem('Edit profile', 2),
              _buildDrawerItem('Change Password', 3),
              _buildDrawerItem('Terms and conditions', 4),
              _buildDrawerItem('Privacy policy', 5),
              _buildDrawerItem('About app', 6),
              _buildDrawerItem('Contact us', 7),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 75),
                child: CustomButton(
                  laBelText: 'Logout',
                  fontSize: 20,
                  textColor: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 43,
                  width: 200,
                  ontapp: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.offAll(() => LoginScreen());
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterWidget(),
              isSearching
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          SizedBox(
                            height: 16,
                          ),
                          StreamBuilder(
                            stream: controller.getRestaurants(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                  height: Get.height * 0.5,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  )),
                                );
                              }

                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              if (snapshot.data == null ||
                                  snapshot.data!.isEmpty) {
                                return Text('No restaurants found');
                              }
                              // Get the list of restaurants
                              List<RestaurantModel> restaurants =
                                  snapshot.data!;

                              // Add a listener to update filtering whenever the search query changes
                              controller.searchController.addListener(() {
                                final text = controller.searchController.text;
                                controller.filteredRestaurants =
                                    filterRestaurants(restaurants, text);
                              });
                              // Build the restaurant grid
                              return GetBuilder<HomeLocationController>(
                                builder: (controller) {
                                  return _buildRestaurantGrid(
                                      controller.filteredRestaurants);
                                },
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    )
                  : Obx(
                      () => filterSelectionController
                                  .isFilterListVisible.value &&
                              filterSelectionController
                                  .aggregatedFilters.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  SizedBox(
                                    height: 16,
                                  ),
                                  StreamBuilder(
                                    stream: controller.getRestaurants(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox(
                                          height: Get.height * 0.5,
                                          child: Center(
                                              child: CircularProgressIndicator(
                                            color: AppColors.primaryColor,
                                          )),
                                        );
                                      }

                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }

                                      if (snapshot.data == null ||
                                          snapshot.data!.isEmpty) {
                                        return Text('No restaurants found');
                                      }

                                      // Apply filtering logic here
                                      List<RestaurantModel> restaurants =
                                          snapshot.data!;

                                      // Filter by Country
                                      if (filterSelectionController
                                          .selectedCountry.isNotEmpty) {
                                        print(filterSelectionController
                                            .aggregatedFilters);
                                        print('flag 1');
                                        restaurants =
                                            restaurants.where((restaurant) {
                                          print(
                                              'restaurant.country ${restaurant.country}');
                                          return filterSelectionController
                                              .aggregatedFilters
                                              .contains(restaurant.country);
                                        }).toList();
                                      }

                                      // Filter by City
                                      if (filterSelectionController
                                          .selectedCity.isNotEmpty) {
                                        print('flag 2');
                                        restaurants =
                                            restaurants.where((restaurant) {
                                          return filterSelectionController
                                              .aggregatedFilters
                                              .contains(restaurant.city);
                                        }).toList();
                                      }

                                      // Filter by Language
                                      if (filterSelectionController
                                          .selectedLanguage.isNotEmpty) {
                                        print('flag 3');
                                        restaurants =
                                            restaurants.where((restaurant) {
                                          return restaurant.spokenLanguage ==
                                              filterSelectionController
                                                  .selectedLanguage.value;
                                        }).toList();
                                      }

                                      // Filter by Discounts
                                      if (filterSelectionController
                                          .selectedDiscounts.isNotEmpty) {
                                        print('flag 4');
                                        restaurants =
                                            restaurants.where((restaurant) {
                                          return (filterSelectionController
                                                      .aggregatedFilters
                                                      .contains(
                                                          'percentage off') &&
                                                  restaurant
                                                      .menuList
                                                      .percentageOff
                                                      .isNotEmpty) ||
                                              filterSelectionController
                                                      .aggregatedFilters
                                                      .contains(
                                                          'happy hour specials') &&
                                                  restaurant
                                                      .menuList
                                                      .happyHourSpecials
                                                      .isNotEmpty;
                                        }).toList();
                                      }

                                      // Filter by Atmosphere
                                      if (filterSelectionController
                                          .selectedAtmosphere.isNotEmpty) {
                                        print('flag 5');
                                        restaurants =
                                            restaurants.where((restaurant) {
                                          // Convert both lists to lowercase
                                          List<String>
                                              selectedFiltersLowercase =
                                              filterSelectionController
                                                  .aggregatedFilters
                                                  .map((filter) =>
                                                      filter.toLowerCase())
                                                  .toList();
                                          List<String>
                                              restaurantAtmosphereLowercase =
                                              restaurant.atmopshereList
                                                  .map((atmosphere) =>
                                                      atmosphere.toLowerCase())
                                                  .toList();
                                          // Check if any selected filter is contained in any restaurant atmosphere
                                          bool isMatch =
                                              selectedFiltersLowercase
                                                  .any((selectedFilter) {
                                            return restaurantAtmosphereLowercase
                                                .any((restaurantAtmosphere) {
                                              return restaurantAtmosphere
                                                  .contains(selectedFilter);
                                            });
                                          });
                                          return isMatch;
                                        }).toList();
                                      }

                                      // Filter by Facilities
                                      if (filterSelectionController
                                          .selectedFacilities.isNotEmpty) {
                                        print('flag 6');
                                        restaurants =
                                            restaurants.where((restaurant) {
                                          // Convert both lists to lowercase
                                          List<String>
                                              selectedFiltersLowercase =
                                              filterSelectionController
                                                  .aggregatedFilters
                                                  .map((filter) =>
                                                      filter.toLowerCase())
                                                  .toList();
                                          List<String>
                                              restaurantFacilitiesLowercase =
                                              restaurant.facilityList
                                                  .map((facility) =>
                                                      facility.toLowerCase())
                                                  .toList();
                                          // Check if any selected filter is contained in any restaurant facility
                                          bool isMatch =
                                              selectedFiltersLowercase
                                                  .any((selectedFilter) {
                                            return restaurantFacilitiesLowercase
                                                .any((restaurantFacility) {
                                              return restaurantFacility
                                                  .contains(selectedFilter);
                                            });
                                          });
                                          return isMatch;
                                        }).toList();
                                      }

                                      // Filter by Entertainment
                                      if (filterSelectionController
                                          .selectedEntertainment.isNotEmpty) {
                                        print('flag 7');
                                        restaurants =
                                            restaurants.where((restaurant) {
                                          // Check if any item in the restaurant's entertainmentScheduleList matches the selected filters
                                          return restaurant
                                              .entertainmentScheduleList
                                              .any((schedule) {
                                            return filterSelectionController
                                                .aggregatedFilters
                                                .any((filter) {
                                              // Compare the relevant fields (e.g., eventName, eventBy, date, etc.)
                                              return schedule.eventName
                                                      .toLowerCase() ==
                                                  filter.toLowerCase();
                                            });
                                          });
                                        }).toList();
                                      }

                                      // Filter by Dietary
                                      if (filterSelectionController
                                          .selectedDietary.isNotEmpty) {
                                        print('flag 8');
                                        restaurants =
                                            restaurants.where((restaurant) {
                                          // Convert both lists to lowercase
                                          List<String>
                                              selectedFiltersLowercase =
                                              filterSelectionController
                                                  .aggregatedFilters
                                                  .map((filter) =>
                                                      filter.toLowerCase())
                                                  .toList();
                                          List<String>
                                              restaurantDietaryLowercase =
                                              restaurant.dietaryList
                                                  .map((dietary) =>
                                                      dietary.toLowerCase())
                                                  .toList();
                                          // Check if any selected filter is contained in any restaurant dietary option
                                          bool isMatch =
                                              selectedFiltersLowercase
                                                  .any((selectedFilter) {
                                            return restaurantDietaryLowercase
                                                .any((restaurantDietary) {
                                              return restaurantDietary
                                                  .contains(selectedFilter);
                                            });
                                          });
                                          return isMatch;
                                        }).toList();
                                      }

                                      // Filter by Price Range
                                      if (filterSelectionController
                                          .selectedPriceRange.isNotEmpty) {
                                        print('flag 9');
                                        restaurants =
                                            restaurants.where((restaurant) {
                                          print(
                                              'restaurant.priceRange ${restaurant.priceRange}');
                                          print(
                                              'filterSelectionController.aggregatedFilters ${filterSelectionController.aggregatedFilters}');

                                          return filterSelectionController
                                              .aggregatedFilters
                                              .contains(restaurant.priceRange);
                                        }).toList();
                                      }

                                      // Initialize filtered restaurants
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        controller
                                            .initializeSelectors(restaurants);
                                      });

                                      return FutureBuilder<
                                          List<RestaurantModel>>(
                                        future: _getFilteredRestaurants(
                                            restaurants),
                                        builder: (context, futureSnapshot) {
                                          // Handle the first FutureBuilder for filtered restaurants
                                          List<RestaurantModel>
                                              timeOfDayRestaurants =
                                              futureSnapshot.data ?? [];

                                          if (filterSelectionController
                                              .aggregatedFilters
                                              .any((filter) =>
                                                  filterSelectionController
                                                      .selectedTimeOfDay
                                                      .contains(filter))) {
                                            controller.filteredRestaurants =
                                                timeOfDayRestaurants;
                                          }

                                          // Handle the second FutureBuilder for cuisines
                                          return StreamBuilder<
                                              Map<String, List<String>>>(
                                            stream: filterSelectionController
                                                    .aggregatedFilters
                                                    .any((filter) =>
                                                        filterSelectionController
                                                            .selectedFilters
                                                            .contains(filter))
                                                ? filterController
                                                    .getRestaurantsGroupedByCuisine()
                                                : Stream.value(
                                                    {}), // Provides a default empty map if no filters are selected
                                            builder: (context,
                                                streamCuisineSnapshot) {
                                              if (streamCuisineSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return _buildLoadingIndicator();
                                              }

                                              if (streamCuisineSnapshot
                                                  .hasError) {
                                                return _buildErrorWidget(
                                                    'Failed to load cuisines!');
                                              }

                                              final cuisineMap =
                                                  streamCuisineSnapshot.data ??
                                                      {};

                                              // Filter cuisines based on selected filters
                                              final selectedCuisines =
                                                  filterSelectionController
                                                      .aggregatedFilters;

                                              if (selectedCuisines.any(
                                                  (filter) =>
                                                      filterSelectionController
                                                          .selectedFilters
                                                          .contains(filter))) {
                                                final filteredRestaurantIds =
                                                    cuisineMap
                                                        .entries
                                                        .where((entry) =>
                                                            selectedCuisines
                                                                .contains(entry
                                                                    .key
                                                                    .toLowerCase()))
                                                        .expand((entry) =>
                                                            entry.value)
                                                        .toSet()
                                                        .toList();

                                                if (filteredRestaurantIds
                                                    .isNotEmpty) {
                                                  controller
                                                          .filteredRestaurants =
                                                      controller
                                                          .filteredRestaurants
                                                          .where((restaurant) =>
                                                              filteredRestaurantIds
                                                                  .contains(
                                                                      restaurant
                                                                          .docID))
                                                          .toList();
                                                } else {
                                                  controller
                                                      .filteredRestaurants = [];
                                                  return _buildEmptyState(
                                                      'No restaurants found!');
                                                }
                                              }

                                              // Listen for search changes and filter restaurants accordingly
                                              controller.searchController
                                                  .addListener(() {
                                                controller.filteredRestaurants =
                                                    restaurants
                                                        .where((item) => item
                                                            .resName
                                                            .toLowerCase()
                                                            .contains(controller
                                                                .searchController
                                                                .text
                                                                .toLowerCase()))
                                                        .toList();
                                                controller.update();
                                              });

                                              return GetBuilder<
                                                  HomeLocationController>(
                                                builder: (controller) {
                                                  return _buildRestaurantGrid(
                                                      controller
                                                          .filteredRestaurants);
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        '${currentUserDataModel?.value.city}',
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
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor:
                                                    AppColors.primaryColor,
                                                fontFamily: 'Nunito-Regular',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primaryColor),
                                          ))
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                                AllCategories(),
                              ],
                            ),
                    ),
            ],
          ),
        ));
  }

  Widget _buildDrawerItem(String title, int index) {
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
              color: _selectedIndex == index
                  ? AppColors.primaryColor
                  : AppColors.textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          onTap: () =>
              _onItemTapped(index, isHome: title == 'Home' ? true : false),
        ),
      ],
    );
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 220,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final item = restaurants[index];
        return InkWell(
          onTap: () {
            Get.to(RestaurantDetailScreen(restaurantModel: item));
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
    );
  }
}
