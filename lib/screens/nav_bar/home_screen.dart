import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/screens/home_screen/cuisiness_viewall/cuisines_view_all.dart';
import 'package:kaistable_website/screens/home_screen/entertainment/entertainments.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import 'package:kaistable_website/screens/home_screen/new_view_all/new_viewall.dart';
import 'package:kaistable_website/screens/home_screen/trending_all/trending_view_all.dart';
import 'package:kaistable_website/screens/nav_bar/near_by_all.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/all_restaurant_screen.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/experience_vibes.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/home_screen_controller.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/location_search_widget.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/trending_restaurant.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/showcase_container.dart';
import '../home_screen/events_screen/common_widget/days_tile.dart';
import '../home_screen/events_screen/controller/events_controller.dart';
import '../home_screen/events_screen/event_screen.dart';
import '../home_screen/events_screen/events_details_screen/event_details_screen.dart';
import 'controller/home_controller.dart';
import 'widgets/homeScreenWidget/horizontal_card_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController controller = Get.put(HomeController());

  final EventsController eventController = Get.put(EventsController());

  final HomeLocationController homeController =
      Get.put(HomeLocationController());

  final GlobalKey _carouselKey = GlobalKey();

  final GlobalKey _categoryKey = GlobalKey();

  final GlobalKey _trendingKey = GlobalKey();

  final GlobalKey _featuredCategoryKey = GlobalKey();

  final GlobalKey _nearBySectionKey = GlobalKey();

  final GlobalKey _experienceKey = GlobalKey();

  final GlobalKey _eventsKey = GlobalKey();

  bool hasStartedShowcase = false;

  final ScrollController _scrollController = ScrollController();
  final filterController = Get.put(HomeFilterSearchController());

  @override
  Widget build(BuildContext context) {
    requestLocationPermission();
    eventController.onInit();
    return ShowCaseWidget(
      enableAutoScroll: true,
      builder: (context) {
        if (!hasStartedShowcase) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            bool isSpotlightFinish =
                await preferences?.getBool('isSpotLightViewd') ?? false;
            if (isSpotlightFinish == false) {
              hasStartedShowcase = !hasStartedShowcase;
              ShowCaseWidget.of(context).startShowCase([
                _carouselKey,
                _categoryKey,
                _trendingKey,
                _featuredCategoryKey,
                _nearBySectionKey,
                _experienceKey,
                _eventsKey,
              ]);
            } else {
              controller.isSpotlightFinish.value = true;
              controller.update();
              hasStartedShowcase = !hasStartedShowcase;
            }
          });
        }
        return Scaffold(
          backgroundColor: AppColors.bgColor,
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: AppColors.bgColor, // Green background color
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 16),
                          LocationSearchWidget(),
                          const SizedBox(height: 16),

                          Row(
                            //                          spacing: 10, // Like SizedBox(width: 10)
                            // runSpacing: 10,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // SizedBox(
                              //   width: 5,
                              // ),

                              FilterChipWidget(
                                label: "Vibes",
                                menuOptions: [
                                  "Brunch Party",
                                  "Day Party",
                                  "Pool Party",
                                  "Happy Hours",
                                  "Open Bar",
                                ],
                                selectedOptions: filterController.selectedVibes,
                                onApply: (selected) =>
                                    filterController.setSelectedVibes(selected),
                              ),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              FilterChipWidget(
                                label: "Experiences",
                                menuOptions: [
                                  "Live Music",
                                  "Dj Night",
                                  "Silent Party",
                                  "Ladies Night",
                                  "RnB Night",
                                ],
                                selectedOptions:
                                    filterController.selectedExperiences,
                                onApply: (selected) => filterController
                                    .setSelectedExperiences(selected),
                              ),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              FilterChipWidget(
                                label: "Cuisines",
                                menuOptions: [
                                  "American",
                                  "Mexican",
                                  "Italian",
                                  "French",
                                  "Chinese",                        
                                  "Thai",
                                
                                ],
                                selectedOptions:
                                    filterController.selectedCuisines,
                                onApply: (selected) =>
                                    filterController.selectedCuisines(selected),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),

                  _buildCategories(),
                  // Showcase.withWidget(
                  //   height: 200,
                  //   width: Get.width - 24,
                  //   key: _categoryKey,
                  //   container: ShowCaseContainer(
                  //     width: Get.width - 32,
                  //     text:
                  //         "Browse different categories to find what you love!",
                  //     showcaseContext: context,
                  //     last: false,
                  //   ),
                  //   child: Center(child: _buildCategories()),
                  // ),

                  SizedBox(
                    height: 5,
                  ),
                  _buildTrendingSection(),

                  // hasStartedShowcase && !controller.isSpotlightFinish.value
                  //     ? Showcase.withWidget(
                  //         height: 200,
                  //         width: Get.width - 24,
                  //         key: _trendingKey,
                  //         container: ShowCaseContainer(
                  //           width: Get.width - 32,
                  //           text: "Discover the most popular items right now!",
                  //           showcaseContext: context,
                  //           last: false,
                  //         ),
                  //         child: _buildTrendingSection(),
                  //       )
                  //     : _buildTrendingSection(),
                  //SizedBox(height: 10),
                  //   _featuredCategory(),

                  Showcase.withWidget(
                    height: 200,
                    width: Get.width - 24,
                    key: _featuredCategoryKey,
                    container: ShowCaseContainer(
                      width: Get.width - 32,
                      text: "Featured categories with exclusive offers!",
                      showcaseContext: context,
                      last: false,
                    ),
                    child: _featuredCategory(),
                  ),

                  // SizedBox(height: 10),
                  StreamBuilder<List<RestaurantModel>>(
                    stream: homeController.getAllRestaurants(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No restaurants found."));
                      }

                      List<RestaurantModel> rest = snapshot.data!;
                      return ExperienceVibesGrid(allRestaurants: rest);
                      // return Showcase.withWidget(
                      //   height: 200,
                      //   width: Get.width - 24,
                      //   key: _experienceKey,
                      //   container: ShowCaseContainer(
                      //     width: Get.width - 32,
                      //     text: "Check out unique experiences waiting for you!",
                      //     showcaseContext: context,
                      //     last: false,
                      //   ),
                      //   child: ExperienceVibesGrid(allRestaurants: rest),
                      // );
                    },
                  ),
                  SizedBox(height: 10),
                  _buildNearBySection(),
                  // hasStartedShowcase && !controller.isSpotlightFinish.value
                  //     ? Showcase.withWidget(
                  //         height: 200,
                  //         width: Get.width - 24,
                  //         key: _nearBySectionKey,
                  //         container: ShowCaseContainer(
                  //           width: Get.width - 32,
                  //           text: "Find amazing places near you!",
                  //           showcaseContext: context,
                  //           last: false,
                  //         ),
                  //         child: _buildNearBySection(),
                  //       )
                  //     : _buildNearBySection(),
                  SizedBox(height: 10),
                  eventsWidget(),
                  // Showcase.withWidget(
                  //   height: 200,
                  //   width: Get.width - 24,
                  //   key: _eventsKey,
                  //   onTargetClick: () {
                  //     controller.isSpotlightFinish.value = true;
                  //     controller.update();
                  //   },
                  //   container: ShowCaseContainer(
                  //     width: Get.width - 32,
                  //     text:
                  //         "Stay updated with the latest events happening around!",
                  //     showcaseContext: context,
                  //     last: true,
                  //   ),
                  //   child: eventsWidget(),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Column eventsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14, right: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Events',
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontFamily: 'NunitoSans-Bold',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                ),
              ),
              InkWell(
                onTap: () => Get.to(EventScreen()),
                child: Text(
                  'See more',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: 'NunitoSans-Regular',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'Food fests and pop-ups',
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: AppColors.bottomSheetColor,
              fontFamily: 'aftika-regular',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 10),

        // 🔁 Obx to react to both `events` and `userPosition`
        Obx(() {
          final userPos = eventController.userPosition.value;

          if (eventController.events.isEmpty) {
            return SizedBox(
              width: double.infinity,
              height: 100,
              child: Center(
                child: Text(
                  'No events found in your region.',
                  style: TextStyle(
                    color: AppColors.bottomSheetColor,
                    fontFamily: 'aftika-regular',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: eventController.events.length > 3
                ? 3
                : eventController.events.length,
            itemBuilder: (context, index) {
              final event = eventController.events[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: DaysTile(
                  onTap: () => Get.to(EventDetailsScreen(event: event)),
                  image: event.imageUrls.first,
                  title: event.eventName,
                  location: event.location,
                  type: event.eventType,
                  eventLat: event.latitude,
                  eventLng: event.longitude,
                  userLat: userPos?.latitude,
                  userLng: userPos?.longitude,
                ),
              );
            },
          );
        }),
      ],
    );
  }

// correct code .................

  Widget _featuredCategory() {
    return FutureBuilder<Position>(
      future: Geolocator.getCurrentPosition(),
      builder: (context, locationSnapshot) {
        if (!locationSnapshot.hasData) {
          return const SizedBox();
        }

        final userPosition = locationSnapshot.data!;

        return StreamBuilder<Map<String, dynamic>?>(
          stream: homeController.getFeaturedRestaurantID(),
          builder: (context, featuredIDSnapshot) {
            if (!featuredIDSnapshot.hasData ||
                featuredIDSnapshot.data == null ||
                featuredIDSnapshot.data!.isEmpty) {
              return const SizedBox();
            }

            return StreamBuilder<List<RestaurantModel>>(
              stream: homeController.getAllRestaurants(),
              builder: (context, allRestaurantsSnapshot) {
                if (!allRestaurantsSnapshot.hasData ||
                    allRestaurantsSnapshot.data == null ||
                    allRestaurantsSnapshot.data!.isEmpty) {
                  return const SizedBox();
                }

                final allRestaurants = allRestaurantsSnapshot.data!;
                final data = featuredIDSnapshot.data as Map<String, dynamic>;

                final random = Random();
                RestaurantModel randomRestaurant;

                // Exclude featured restaurant from random selection
                do {
                  randomRestaurant =
                      allRestaurants[random.nextInt(allRestaurants.length)];
                } while (randomRestaurant.docID == data['restaurantID']);

                // Calculate distance
                String distanceText = "Location unavailable";
                if (randomRestaurant.latitude != null &&
                    randomRestaurant.longitude != null) {
                  final distanceInMeters = Geolocator.distanceBetween(
                    userPosition.latitude,
                    userPosition.longitude,
                    randomRestaurant.latitude!,
                    randomRestaurant.longitude!,
                  );

                  // Convert meters to miles
                  final distanceInMiles = distanceInMeters / 1609.34;

                  distanceText =
                      "${distanceInMiles.toStringAsFixed(1)} mi"; // 1 decimal place
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Top Rated',
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: 'NunitoSans-Bold',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => AllRestaurantsPage(
                                  restaurants: allRestaurants));
                            },
                            child: Text(
                              'See more',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontFamily: 'NunitoSans-Regular',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data['description'] ??
                            'Experience the art of Cuisine at our top rated restaurants',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: AppColors.bottomSheetColor,
                          fontFamily: 'NunitoSans-Regular',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Get.to(RestaurantDetailScreen(
                              restaurantModel: randomRestaurant));
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                randomRestaurant.logoImage,
                                height: 290,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            // Bottom Blur Info
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          AppColors.primaryColor
                                              .withOpacity(0.5),
                                          AppColors.primaryColor
                                              .withOpacity(0.5),
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          randomRestaurant.resName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontFamily: 'NunitoSans-Bold',
                                          ),
                                        ),
                                        Text(
                                          randomRestaurant.address,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontFamily: 'NunitoSans-Regular',
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 20,
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              distanceText,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontFamily: 'NunitoSans-Bold',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // ⭐ New: Bottom-Right Buttons (Filter & Direction)
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: Column(
                                children: [
                                  // Filter Button
                                  GestureDetector(
                                      onTap: () {
                                        final allFilters = controller
                                            .getAllFilters(randomRestaurant);

                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (context) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16, 16, 16, 0),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.8,
                                              child: Column(
                                                children: [
                                                  // Header with title and buttons
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Filters',
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .primaryColor,
                                                          fontFamily:
                                                              'NunitoSans-Bold',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontFamily:
                                                                'NunitoSans-Bold',
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),

                                                  // Main dynamic filters list
                                                  Expanded(
                                                    child: ListView.builder(
                                                      itemCount:
                                                          allFilters.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          children: [
                                                            ListTile(
                                                              title: Text(
                                                                allFilters[
                                                                    index],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'NunitoSans-regular',
                                                                    color: AppColors
                                                                        .bottomSheetColor),
                                                              ),
                                                            ),
                                                            const Divider(
                                                                height: 1,
                                                                color: AppColors
                                                                    .primaryColor),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/filter.png"),
                                        width: 20,
                                        height: 20,
                                      )),
                                  const SizedBox(height: 8),

                                  // Direction Button
                                  GestureDetector(
                                      onTap: () async {
                                        final lat = randomRestaurant
                                            .latitude; // Your restaurant's latitude
                                        final lng = randomRestaurant
                                            .longitude; // Your restaurant's longitude
                                        final restaurantName =
                                            Uri.encodeComponent(
                                                randomRestaurant.resName);

                                        // Create Google Maps URL with directions
                                        final googleMapsUrl =
                                            'https://www.google.com/maps/dir/?api=1'
                                            '&destination=$lat,$lng'
                                            '&destination_place_name=$restaurantName';

                                        try {
                                          if (await canLaunch(googleMapsUrl)) {
                                            await launch(googleMapsUrl);
                                          } else {
                                            // Fallback to web version if app isn't installed
                                            final webUrl =
                                                'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                                            await launch(webUrl);
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Could not launch maps: ${e.toString()}')),
                                          );
                                        }
                                      },
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/direction.png"),
                                        width: 20,
                                        height: 20,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }







//.................................
  Widget _buildCategories() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Explore By Category',
                    style: TextStyle(
                      color: AppColors.bottomSheetColor,
                      fontFamily: 'NunitoSans-Bold',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            SizedBox(
              height: 150, // Increased height for taller images
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
                      } else if (category['name'] == 'Experience') {
                        Get.to(EntertainmentsScreen());
                      } else if (category['name'] == 'Events') {
                        Get.to(EventScreen());
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: index == 0 ? 14 : 10, right: 10),
                      width: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 92,
                            height: 116,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(category["image"] as String),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            category["name"] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: 'NunitoSans-Regular',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  // Widget _buildTrendingSection() {
  //   final HomeLocationController controller = Get.put(HomeLocationController());
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 12),
  //     child: StreamBuilder(
  //       stream: controller.getTrendingRestaurants(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting)
  //           return SizedBox();
  //         if (snapshot.hasError) {
  //           print('Error during stream call ${snapshot.error}');
  //           return Text('');
  //         }
  //         if (snapshot.data == null || snapshot.data!.isEmpty) return Text('');
  //         List<RestaurantModel> restaurants = snapshot.data!;
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           controller.initailizedSelectors(resaturantsList: restaurants);
  //         });

  //         return Column(
  //           children: [
  //             SizedBox(height: 10),
  //             Padding(
  //               padding: EdgeInsets.only(right: 18),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'Trending',
  //                         style: TextStyle(
  //                           color: AppColors.bottomSheetColor,
  //                           fontFamily: 'aftika-regular',
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w700,
  //                           decoration: TextDecoration.underline,
  //                         ),
  //                       ),
  //                       SizedBox(height: 5),
  //                       Text(
  //                         'Buzzing dishes right now',
  //                         textAlign: TextAlign.justify,
  //                         style: TextStyle(
  //                           color: AppColors.bottomSheetColor,
  //                           fontFamily: 'aftika-regular',
  //                           fontSize: 12,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(height: 10),
  //             SizedBox(
  //               height: Get.height * 0.25,
  //               child: ListView.builder(
  //                 shrinkWrap: true,
  //                 scrollDirection: Axis.horizontal,
  //                 itemCount: restaurants.length,
  //                 itemBuilder: (context, index) {
  //                   final item = restaurants[index];
  //                   return Padding(
  //                     padding: const EdgeInsets.only(right: 12.0),
  //                     child: GestureDetector(
  //                         onTap: () => Get.to(
  //                             RestaurantDetailScreen(restaurantModel: item)),
  //                         child: Container(
  //                           width: 200,
  //                           //height:  200,
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(12),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 color: Colors.black12,
  //                                 blurRadius: 5,
  //                                 offset: Offset(0, 2),
  //                               )
  //                             ],
  //                           ),
  //                           child: Stack(
  //                             children: [
  //                               /// Main Image
  //                               ClipRRect(
  //                                 borderRadius: BorderRadius.circular(12),
  //                                 child: Image.network(
  //                                   item.logoImage,
  //                                   height: 200,
  //                                   width: double.infinity,
  //                                   fit: BoxFit.cover,
  //                                 ),
  //                               ),

  //                               /// Blur Gradient Info at Bottom
  //                               Positioned(
  //                                 bottom: 0,
  //                                 left: 0,
  //                                 right: 0,
  //                                 child: ClipRRect(
  //                                   borderRadius: const BorderRadius.only(
  //                                     bottomLeft: Radius.circular(12),
  //                                     bottomRight: Radius.circular(12),
  //                                   ),
  //                                   child: BackdropFilter(
  //                                     filter: ImageFilter.blur(
  //                                         sigmaX: 10, sigmaY: 10),
  //                                     child: Container(
  //                                       // height: 80,
  //                                       padding: const EdgeInsets.all(16),
  //                                       decoration: BoxDecoration(
  //                                         borderRadius: const BorderRadius.only(
  //                                           bottomLeft: Radius.circular(12),
  //                                           bottomRight: Radius.circular(12),
  //                                         ),
  //                                         gradient: LinearGradient(
  //                                           begin: Alignment.bottomCenter,
  //                                           end: Alignment.topCenter,
  //                                           colors: [
  //                                             AppColors.primaryColor
  //                                                 .withOpacity(0.5),
  //                                             AppColors.primaryColor
  //                                                 .withOpacity(0.5),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                       child: Column(
  //                                         crossAxisAlignment:
  //                                             CrossAxisAlignment.start,
  //                                         children: [
  //                                           /// Restaurant Name
  //                                           Text(
  //                                             item.resName,
  //                                             style: const TextStyle(
  //                                               fontSize: 14,
  //                                               fontWeight: FontWeight.w800,
  //                                               color: Colors.white,
  //                                               fontFamily: 'Nunito-regular',
  //                                             ),
  //                                           ),

  //                                           /// Location Text
  //                                           Row(
  //                                             children: [
  //                                               Icon(
  //                                                 Icons.location_on_outlined,
  //                                                 size: 14,
  //                                                 color: Colors.white
  //                                                     .withOpacity(0.9),
  //                                               ),
  //                                               const SizedBox(width: 6),
  //                                               Expanded(
  //                                                 child: Text(
  //                                                   item.address,
  //                                                   style: const TextStyle(
  //                                                     fontSize: 14,
  //                                                     fontWeight:
  //                                                         FontWeight.w600,
  //                                                     color: Colors.white,
  //                                                     fontFamily: 'Nunito-Sans',
  //                                                   ),
  //                                                   overflow:
  //                                                       TextOverflow.ellipsis,
  //                                                 ),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         )),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget _buildTrendingSection() {
  //   final HomeLocationController controller = Get.put(HomeLocationController());

  //   return Padding(
  //     padding: const EdgeInsets.only(left: 12),
  //     child: GetBuilder<HomeLocationController>(
  //       builder: (_) {
  //         return StreamBuilder<List<RestaurantModel>>(
  //           stream: controller.getTrendingRestaurants(),
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return SizedBox();
  //             }
  //             if (snapshot.hasError) {
  //               print('Stream error: ${snapshot.error}');
  //               return Text('Error loading restaurants');
  //             }
  //             if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //               return Text('No restaurants found');
  //             }

  //             List<RestaurantModel> restaurants = snapshot.data!;

  //             return Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 SizedBox(height: 10),
  //                 Padding(
  //                   padding: const EdgeInsets.only(right: 18),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             'Trending',
  //                             style: TextStyle(
  //                               color: AppColors.bottomSheetColor,
  //                               fontFamily: 'aftika-regular',
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w700,
  //                               decoration: TextDecoration.underline,
  //                             ),
  //                           ),
  //                           SizedBox(height: 5),
  //                           Text(
  //                             'Buzzing dishes right now',
  //                             textAlign: TextAlign.justify,
  //                             style: TextStyle(
  //                               color: AppColors.bottomSheetColor,
  //                               fontFamily: 'aftika-regular',
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(height: 10),
  //                 SizedBox(
  //                   height: Get.height * 0.25,
  //                   child: ListView.builder(
  //                     scrollDirection: Axis.horizontal,
  //                     itemCount: restaurants.length,
  //                     itemBuilder: (context, index) {
  //                       final item = restaurants[index];
  //                       return Padding(
  //                         padding: const EdgeInsets.only(right: 12.0),
  //                         child: GestureDetector(
  //                           onTap: () => Get.to(
  //                               RestaurantDetailScreen(restaurantModel: item)),
  //                           child: Container(
  //                             width: 200,
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(12),
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Colors.black12,
  //                                   blurRadius: 5,
  //                                   offset: Offset(0, 2),
  //                                 )
  //                               ],
  //                             ),
  //                             child: Stack(
  //                               children: [
  //                                 ClipRRect(
  //                                   borderRadius: BorderRadius.circular(12),
  //                                   child: Image.network(
  //                                     item.logoImage,
  //                                     height: 200,
  //                                     width: double.infinity,
  //                                     fit: BoxFit.cover,
  //                                   ),
  //                                 ),
  //                                 Positioned(
  //                                   bottom: 0,
  //                                   left: 0,
  //                                   right: 0,
  //                                   child: ClipRRect(
  //                                     borderRadius: const BorderRadius.only(
  //                                       bottomLeft: Radius.circular(12),
  //                                       bottomRight: Radius.circular(12),
  //                                     ),
  //                                     child: BackdropFilter(
  //                                       filter: ImageFilter.blur(
  //                                           sigmaX: 10, sigmaY: 10),
  //                                       child: Container(
  //                                         padding: const EdgeInsets.all(16),
  //                                         decoration: BoxDecoration(
  //                                           borderRadius:
  //                                               const BorderRadius.only(
  //                                             bottomLeft: Radius.circular(12),
  //                                             bottomRight: Radius.circular(12),
  //                                           ),
  //                                           gradient: LinearGradient(
  //                                             begin: Alignment.bottomCenter,
  //                                             end: Alignment.topCenter,
  //                                             colors: [
  //                                               AppColors.primaryColor
  //                                                   .withOpacity(0.5),
  //                                               AppColors.primaryColor
  //                                                   .withOpacity(0.5),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         child: Column(
  //                                           crossAxisAlignment:
  //                                               CrossAxisAlignment.start,
  //                                           children: [
  //                                             Text(
  //                                               item.resName,
  //                                               style: const TextStyle(
  //                                                 fontSize: 14,
  //                                                 fontWeight: FontWeight.w800,
  //                                                 color: Colors.white,
  //                                                 fontFamily: 'Nunito-regular',
  //                                               ),
  //                                             ),
  //                                             Row(
  //                                               children: [
  //                                                 Icon(
  //                                                     Icons
  //                                                         .location_on_outlined,
  //                                                     size: 14,
  //                                                     color: Colors.white
  //                                                         .withOpacity(0.9)),
  //                                                 const SizedBox(width: 6),
  //                                                 Expanded(
  //                                                   child: Text(
  //                                                     item.address,
  //                                                     style: const TextStyle(
  //                                                       fontSize: 14,
  //                                                       fontWeight:
  //                                                           FontWeight.w600,
  //                                                       color: Colors.white,
  //                                                       fontFamily:
  //                                                           'Nunito-Sans',
  //                                                     ),
  //                                                     overflow:
  //                                                         TextOverflow.ellipsis,
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

// Widget _buildTrendingSection() {
//   final HomeLocationController controller = Get.put(HomeLocationController());
//      final filterController = Get.find<FilterController>();
//   return Padding(
//     padding: const EdgeInsets.only(left: 12),
//     child: StreamBuilder(
//       stream: controller.getTrendingRestaurants(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting)
//           return SizedBox();
//         if (snapshot.hasError) {
//           print('Error during stream call ${snapshot.error}');
//           return Text('');
//         }
//         if (snapshot.data == null || snapshot.data!.isEmpty) return Text('');
//         List<RestaurantModel> restaurants = snapshot.data!;
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           controller.initailizedSelectors(resaturantsList: restaurants);
//         });

//         // Take only the first restaurant for the main view
//         final featuredRestaurant = restaurants.first;
// // Subtracting left and right padding
//         return Column(
//           children: [
//             SizedBox(height: 10),
//             Padding(
//               padding: EdgeInsets.only(right: 18),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Trending',
//                     style: TextStyle(
//                       color: AppColors.bottomSheetColor,
//                       fontFamily: 'aftika-regular',
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       // Navigate to a new page showing all trending restaurants
//                       Get.to(TrendingRestaurantsPage(restaurants: restaurants));
//                     },
//                     child: Text(
//                       'See more',
//                       style: TextStyle(
//                         color: AppColors.primaryColor,
//                         fontFamily: 'aftika-regular',
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             GestureDetector(
//               onTap: () {
//                 Get.to(RestaurantDetailScreen(
//                     restaurantModel: featuredRestaurant));
//               },
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.network(
//                       featuredRestaurant.logoImage,
//                       height: 290,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(12),
//                         bottomRight: Radius.circular(12),
//                       ),
//                       child: BackdropFilter(
//                         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                         child: Container(
//                           //height: 80,
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             borderRadius: const BorderRadius.only(
//                               bottomLeft: Radius.circular(12),
//                               bottomRight: Radius.circular(12),
//                             ),
//                             gradient: LinearGradient(
//                               begin: Alignment.bottomCenter,
//                               end: Alignment.topCenter,
//                               colors: [
//                                 AppColors.primaryColor.withOpacity(0.5),
//                                 AppColors.primaryColor.withOpacity(0.5),
//                               ],
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 featuredRestaurant.resName,
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w800,
//                                   color: Colors.white,
//                                   fontFamily: 'Nunito-Sans',
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on_outlined,
//                                     size: 18,
//                                     color: Colors.white.withOpacity(0.9),
//                                   ),
//                                   const SizedBox(width: 6),
//                                   Text(
//                                     featuredRestaurant.address,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.white,
//                                       fontFamily: 'Nunito-Sans',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//           ],
//         );
//       },
//     ),
//   );
// }

//-------------new code filter-----------------------

// Widget _buildTrendingSection() {
//   final HomeLocationController controller = Get.put(HomeLocationController());
//   final filterController = Get.find<FilterController>();

//   return Padding(
//     padding: const EdgeInsets.only(left: 12),
//     child: Obx(() {
//       // Get updated values from filters
//       final vibes = filterController.selectedVibes.toList();
//       final experiences = filterController.selectedExperiences.toList();
//       final cuisines = filterController.selectedCuisines.toList();

//       return StreamBuilder(
//         stream: controller.getTrendingRestaurants(
//           vibes: vibes,
//           experiences: experiences,
//           cuisines: cuisines,
//         ),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return SizedBox();
//           }
//           if (snapshot.hasError) {
//             print('Error during stream call ${snapshot.error}');
//             return Text('');
//           }
//           if (snapshot.data == null || snapshot.data!.isEmpty) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(right: 18),
//                   child: Text(
//                     'Trending',
//                     style: TextStyle(
//                       color: AppColors.bottomSheetColor,
//                       fontFamily: 'aftika-regular',
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Center(
//                   child: Text(
//                     'No matching restaurants found',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }

//           List<RestaurantModel> restaurants = snapshot.data!;
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             controller.initailizedSelectors(resaturantsList: restaurants);
//           });

//           // Take only the first restaurant for the main view
//           final featuredRestaurant = restaurants.first;

//           return Column(
//             children: [
//               SizedBox(height: 10),
//               Padding(
//                 padding: EdgeInsets.only(right: 18),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Trending',
//                       style: TextStyle(
//                         color: AppColors.bottomSheetColor,
//                         fontFamily: 'aftika-regular',
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         // Pass filtered restaurants to the "See more" page
//                         Get.to(TrendingRestaurantsPage(
//                           restaurants: restaurants,

//                         ));
//                       },
//                       child: Text(
//                         'See more',
//                         style: TextStyle(
//                           color: AppColors.primaryColor,
//                           fontFamily: 'aftika-regular',
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               GestureDetector(
//                 onTap: () {
//                   Get.to(RestaurantDetailScreen(
//                       restaurantModel: featuredRestaurant));
//                 },
//                 child: Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(
//                         featuredRestaurant.logoImage,
//                         height: 290,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                       child: ClipRRect(
//                         borderRadius: const BorderRadius.only(
//                           bottomLeft: Radius.circular(12),
//                           bottomRight: Radius.circular(12),
//                         ),
//                         child: BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               borderRadius: const BorderRadius.only(
//                                 bottomLeft: Radius.circular(12),
//                                 bottomRight: Radius.circular(12),
//                               ),
//                               gradient: LinearGradient(
//                                 begin: Alignment.bottomCenter,
//                                 end: Alignment.topCenter,
//                                 colors: [
//                                   AppColors.primaryColor.withOpacity(0.5),
//                                   AppColors.primaryColor.withOpacity(0.5),
//                                 ],
//                               ),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   featuredRestaurant.resName,
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w800,
//                                     color: Colors.white,
//                                     fontFamily: 'Nunito-Sans',
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.location_on_outlined,
//                                       size: 18,
//                                       color: Colors.white.withOpacity(0.9),
//                                     ),
//                                     const SizedBox(width: 6),
//                                     Text(
//                                       featuredRestaurant.address,
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white,
//                                         fontFamily: 'Nunito-Sans',
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//             ],
//           );
//         },
//       );
//     }),
//   );
// }

  Future<double> getDistanceToRestaurant(double resLat, double resLng) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return homeController.calculateDistanceInMiles(
        position.latitude,
        position.longitude,
        resLat,
        resLng,
      );
    } catch (e) {
      print("Error getting location: $e");
      return 0.0; // fallback
    }
  }

  Widget _buildTrendingSection() {
    final HomeLocationController homeLocationController =
        Get.put(HomeLocationController());
    final filterController = Get.find<HomeFilterSearchController>();

    return Obx(() {
      // Get updated values from filters
      final vibes = filterController.selectedVibes.toList();
      final experiences = filterController.selectedExperiences.toList();
      final cuisines = filterController.selectedCuisines.toList();

      return StreamBuilder(
        stream: homeLocationController.getTrendingRestaurants(
          vibes: vibes,
          experiences: experiences,
          cuisines: cuisines,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox();
          }
          if (snapshot.hasError) {
            print('Error during stream call ${snapshot.error}');
            return Text('');
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trending',
                    style: TextStyle(
                      color: AppColors.bottomSheetColor,
                      fontFamily: 'NunitoSans-Bold',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'No matching restaurants found',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'NunitoSans-Regular',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          List<RestaurantModel> filteredRestaurants = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            homeLocationController.initailizedSelectors(
                resaturantsList: filteredRestaurants);
          });

          // Take only the first restaurant for the main view
          final featuredRestaurant = filteredRestaurants.first;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trending',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'NunitoSans-Bold',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Pass ONLY the filtered restaurants and active filters
                        Get.to(TrendingRestaurantsPage(
                          filteredRestaurants: filteredRestaurants,
                          activeVibes: vibes,
                          activeExperiences: experiences,
                          activeCuisines: cuisines,
                        ));
                      },
                      child: Text(
                        'See more',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'NunitoSans-Regular',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Get.to(RestaurantDetailScreen(
                        restaurantModel: featuredRestaurant));
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          featuredRestaurant.logoImage,
                          height: 290,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      FutureBuilder<double>(
                        future: getDistanceToRestaurant(
                            featuredRestaurant.latitude,
                            featuredRestaurant.longitude),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox(); // or loader
                          }

                          double distanceInMiles = snapshot.data ?? 0.0;

                          return Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        AppColors.primaryColor.withOpacity(0.5),
                                        AppColors.primaryColor.withOpacity(0.5),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Name
                                      Text(
                                        featuredRestaurant.resName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontFamily: 'NunitoSans-Bold',
                                        ),
                                      ),

                                      // Address
                                      Text(
                                        featuredRestaurant.address,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontFamily: 'NunitoSans-Regular',
                                        ),
                                      ),

                                      // Distance
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 20,
                                            color:
                                                Colors.white.withOpacity(0.9),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${distanceInMiles.toStringAsFixed(1)} mi',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              fontFamily: 'NunitoSans-Regular',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Column(
                          children: [
                            // Filter Button
                            GestureDetector(
                                onTap: () {
                                  final allFilters = controller
                                      .getAllFilters(featuredRestaurant);

                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (context) {
                                      return Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 0),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                        child: Column(
                                          children: [
                                            // Header with title and buttons
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Filters',
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontFamily:
                                                        'NunitoSans-Bold',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Cancel',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontFamily:
                                                            'NunitoSans-Bold',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),

                                            // Main dynamic filters list
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: allFilters.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text(
                                                          allFilters[index],
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Nunito-regular',
                                                              color: AppColors
                                                                  .bottomSheetColor),
                                                        ),
                                                      ),
                                                      const Divider(
                                                          height: 1,
                                                          color: AppColors
                                                              .primaryColor),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Image(
                                  image: AssetImage("assets/images/filter.png"),
                                  width: 20,
                                  height: 20,
                                )),
                            const SizedBox(height: 8),

                            // Direction Button
                            GestureDetector(
                                onTap: () async {
                                  final lat = featuredRestaurant
                                      .latitude; // Your restaurant's latitude
                                  final lng = featuredRestaurant
                                      .longitude; // Your restaurant's longitude
                                  final restaurantName = Uri.encodeComponent(
                                      featuredRestaurant.resName);

                                  // Create Google Maps URL with directions
                                  final googleMapsUrl =
                                      'https://www.google.com/maps/dir/?api=1'
                                      '&destination=$lat,$lng'
                                      '&destination_place_name=$restaurantName';

                                  try {
                                    if (await canLaunch(googleMapsUrl)) {
                                      await launch(googleMapsUrl);
                                    } else {
                                      // Fallback to web version if app isn't installed
                                      final webUrl =
                                          'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                                      await launch(webUrl);
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Could not launch maps: ${e.toString()}')),
                                    );
                                  }
                                },
                                child: Image(
                                  image:
                                      AssetImage("assets/images/direction.png"),
                                  width: 20,
                                  height: 20,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    });
  }

// Widget _buildTrendingSection() {
//   final HomeLocationController homeLocationController = Get.put(HomeLocationController());
//   final filterController = Get.find<HomeFilterController>();

//   return Obx(() {
//     final vibes = filterController.selectedVibes.toList();
//     final experiences = filterController.selectedExperiences.toList();
//     final cuisines = filterController.selectedCuisines.toList();

//     return StreamBuilder(
//       stream: homeLocationController.getTrendingRestaurants(
//         vibes: vibes,
//         experiences: experiences,
//         cuisines: cuisines,
//       ),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return SizedBox();
//         }
//         if (snapshot.hasError) {
//           print('Error during stream call ${snapshot.error}');
//           return Text('');
//         }
//         if (snapshot.data == null || snapshot.data!.isEmpty) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Trending',
//                   style: TextStyle(
//                     color: AppColors.bottomSheetColor,
//                     fontFamily: 'NunitoSans-Bold',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Center(
//                   child: Text(
//                     'No matching restaurants found',
//                     style: TextStyle(
//                       color: AppColors.bottomSheetColor,
//                       fontFamily: 'NunitoSans-Regular',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }

//         List<RestaurantModel> filteredRestaurants = snapshot.data!;
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           homeLocationController.initailizedSelectors(resaturantsList: filteredRestaurants);
//         });

//         final featuredRestaurant = filteredRestaurants.first;

//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Trending',
//                     style: TextStyle(
//                       color: AppColors.bottomSheetColor,
//                       fontFamily: 'NunitoSans-Bold',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Get.to(TrendingRestaurantsPage(
//                         filteredRestaurants: filteredRestaurants,
//                         activeVibes: vibes,
//                         activeExperiences: experiences,
//                         activeCuisines: cuisines,
//                       ));
//                     },
//                     child: Text(
//                       'See more',
//                       style: TextStyle(
//                         color: AppColors.primaryColor,
//                         fontFamily: 'NunitoSans-Regular',
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               GestureDetector(
//                 onTap: () {
//                   Get.to(RestaurantDetailScreen(restaurantModel: featuredRestaurant));
//                 },
//                 child: Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(
//                         featuredRestaurant.logoImage,
//                         height: 290,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     FutureBuilder<double>(
//                       future: getDistanceToRestaurant(
//                           featuredRestaurant.latitude, featuredRestaurant.longitude),
//                       builder: (context, snapshot) {
//                         if (!snapshot.hasData) {
//                           return SizedBox();
//                         }

//                         double distanceInMiles = snapshot.data ?? 0.0;

//                         return Stack(
//                           children: [
//                             Positioned(
//                               bottom: 0,
//                               left: 0,
//                               right: 0,
//                               child: ClipRRect(
//                                 borderRadius: const BorderRadius.only(
//                                   bottomLeft: Radius.circular(12),
//                                   bottomRight: Radius.circular(12),
//                                 ),
//                                 child: BackdropFilter(
//                                   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                                   child: Container(
//                                     padding: const EdgeInsets.all(16),
//                                     decoration: BoxDecoration(
//                                       borderRadius: const BorderRadius.only(
//                                         bottomLeft: Radius.circular(12),
//                                         bottomRight: Radius.circular(12),
//                                       ),
//                                       gradient: LinearGradient(
//                                         begin: Alignment.bottomCenter,
//                                         end: Alignment.topCenter,
//                                         colors: [
//                                           AppColors.primaryColor.withOpacity(0.5),
//                                           AppColors.primaryColor.withOpacity(0.5),
//                                         ],
//                                       ),
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           featuredRestaurant.resName,
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.white,
//                                             fontFamily: 'NunitoSans-Bold',
//                                           ),
//                                         ),
//                                         Text(
//                                           featuredRestaurant.address,
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.white,
//                                             fontFamily: 'NunitoSans-Regular',
//                                           ),
//                                         ),
//                                         Row(
//                                           children: [
//                                             Icon(
//                                               Icons.location_on_outlined,
//                                               size: 20,
//                                               color: Colors.white.withOpacity(0.9),
//                                             ),
//                                             SizedBox(width: 6),
//                                             Text(
//                                               '${distanceInMiles.toStringAsFixed(1)} mi',
//                                               style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.white,
//                                                 fontFamily: 'NunitoSans-Regular',
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 16,
//                               right: 16,
//                               child: Column(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                         final allFilters = controller.getAllFilters(featuredRestaurant);
//                                       showModalBottomSheet(
//                                         context: context,
//                                         isScrollControlled: true,
//                                         shape: const RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.vertical(
//                                             top: Radius.circular(20),
//                                           ),
//                                         ),
//                                         builder: (context) {
//                                           return Container(
//                                             padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//                                             height: MediaQuery.of(context).size.height * 0.8,
//                                             child: Column(
//                                               children: [
//                                                 Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                   children: [
//                                                     const Text(
//                                                       'Filters',
//                                                       style: TextStyle(
//                                                         color: AppColors.primaryColor,
//                                                         fontSize: 18,
//                                                         fontFamily: "aftika-regular",
//                                                       ),
//                                                     ),
//                                                     TextButton(
//                                                       onPressed: () => Navigator.pop(context),
//                                                       child: const Text(
//                                                         'Cancel',
//                                                         style: TextStyle(
//                                                           fontSize: 18,
//                                                           color: Colors.red,
//                                                           fontFamily: "aftika-regular",
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 16),
//                                                 Expanded(
//                                                   child: ListView.builder(
//                                                     itemCount: allFilters.length,
//                                                     itemBuilder: (context, index) {
//                                                       return Column(
//                                                         children: [
//                                                           ListTile(
//                                                             title: Text(
//                                                               allFilters[index],
//                                                               style: const TextStyle(
//                                                                 fontSize: 16,
//                                                                 fontFamily: 'Nunito-regular',
//                                                                 color: AppColors.bottomSheetColor,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           const Divider(
//                                                             height: 1,
//                                                             color: AppColors.primaryColor,
//                                                           ),
//                                                         ],
//                                                       );
//                                                     },
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     },
//                                     child: Image(
//                                       image: AssetImage("assets/images/filter.png"),
//                                       width: 20,
//                                       height: 20,
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   GestureDetector(
//                                     onTap: () async {
//                                       final lat = featuredRestaurant.latitude;
//                                       final lng = featuredRestaurant.longitude;
//                                       final restaurantName = Uri.encodeComponent(featuredRestaurant.resName);

//                                       final googleMapsUrl =
//                                           'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_name=$restaurantName';

//                                       try {
//                                         if (await canLaunch(googleMapsUrl)) {
//                                           await launch(googleMapsUrl);
//                                         } else {
//                                           final fallbackUrl =
//                                               'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
//                                           await launch(fallbackUrl);
//                                         }
//                                       } catch (e) {
//                                         ScaffoldMessenger.of(context).showSnackBar(
//                                           SnackBar(content: Text('Could not launch maps: ${e.toString()}')),
//                                         );
//                                       }
//                                     },
//                                     child: Image(
//                                       image: AssetImage("assets/images/direction.png"),
//                                       width: 20,
//                                       height: 20,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   });
// }

//correct code  filter resturant

  // Widget _buildTrendingSection() {
  //   final controller = Get.find<HomeLocationController>();
  //   final filterController = Get.find<FilterController>();

  //   return Padding(
  //     padding: const EdgeInsets.only(left: 12),
  //     child: Obx(() {
  //       // Get updated values from filters
  //       final vibes = filterController.selectedVibes.toList();
  //       final experiences = filterController.selectedExperiences.toList();
  //       final cuisines = filterController.selectedCuisines.toList();

  //       return StreamBuilder<List<RestaurantModel>>(
  //         stream: controller.getTrendingRestaurants(
  //           vibes: vibes,
  //           experiences: experiences,
  //           cuisines: cuisines,
  //         ),
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return SizedBox(); // Show loader if you like
  //           }

  //           if (snapshot.hasError) {
  //             return Text('Error loading restaurants');
  //           }

  //           final restaurants = snapshot.data ?? [];

  //           return Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // const SizedBox(height: 10),
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 18),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'Trending',
  //                           style: TextStyle(
  //                             color: AppColors.bottomSheetColor,
  //                             fontFamily: 'NunitoSans-Bold',
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.w700,
  //                             decoration: TextDecoration.underline,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 5),
  //                         Text(
  //                           'Buzzing dishes right now',
  //                           textAlign: TextAlign.justify,
  //                           style: TextStyle(
  //                             color: AppColors.bottomSheetColor,
  //                             fontFamily: 'aftika-regular',
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               if (restaurants.isEmpty)
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 30),
  //                   child: Center(
  //                     child: Text(
  //                       'No related restaurants found.',
  //                       style: TextStyle(
  //                         fontSize: 14,
  //                         color: Colors.grey[600],
  //                         fontFamily: 'aftika-regular',
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //               else
  //                 SizedBox(
  //                   height: Get.height * 0.25,
  //                   child: ListView.builder(
  //                     scrollDirection: Axis.horizontal,
  //                     itemCount: restaurants.length,
  //                     itemBuilder: (context, index) {
  //                       final item = restaurants[index];
  //                       return Padding(
  //                         padding: const EdgeInsets.only(right: 12.0),
  //                         child: GestureDetector(
  //                           onTap: () => Get.to(
  //                               RestaurantDetailScreen(restaurantModel: item)),
  //                           child: Container(
  //                             width: 200,
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(12),
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Colors.black12,
  //                                   blurRadius: 5,
  //                                   offset: const Offset(0, 2),
  //                                 )
  //                               ],
  //                             ),
  //                             child: Stack(
  //                               children: [
  //                                 ClipRRect(
  //                                   borderRadius: BorderRadius.circular(12),
  //                                   child: Image.network(
  //                                     item.logoImage,
  //                                     height: 200,
  //                                     width: double.infinity,
  //                                     fit: BoxFit.cover,
  //                                   ),
  //                                 ),
  //                                 Positioned(
  //                                   bottom: 0,
  //                                   left: 0,
  //                                   right: 0,
  //                                   child: ClipRRect(
  //                                     borderRadius: const BorderRadius.only(
  //                                       bottomLeft: Radius.circular(12),
  //                                       bottomRight: Radius.circular(12),
  //                                     ),
  //                                     child: BackdropFilter(
  //                                       filter: ImageFilter.blur(
  //                                           sigmaX: 10, sigmaY: 10),
  //                                       child: Container(
  //                                         padding: const EdgeInsets.all(16),
  //                                         decoration: BoxDecoration(
  //                                           borderRadius:
  //                                               const BorderRadius.only(
  //                                             bottomLeft: Radius.circular(12),
  //                                             bottomRight: Radius.circular(12),
  //                                           ),
  //                                           gradient: LinearGradient(
  //                                             begin: Alignment.bottomCenter,
  //                                             end: Alignment.topCenter,
  //                                             colors: [
  //                                               AppColors.primaryColor
  //                                                   .withOpacity(0.5),
  //                                               AppColors.primaryColor
  //                                                   .withOpacity(0.5),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         child: Column(
  //                                           crossAxisAlignment:
  //                                               CrossAxisAlignment.start,
  //                                           children: [
  //                                             Text(
  //                                               item.resName,
  //                                               style: const TextStyle(
  //                                                 fontSize: 14,
  //                                                 fontWeight: FontWeight.w800,
  //                                                 color: Colors.white,
  //                                                 fontFamily: 'Nunito-regular',
  //                                               ),
  //                                             ),
  //                                             Row(
  //                                               children: [
  //                                                 Icon(
  //                                                   Icons.location_on_outlined,
  //                                                   size: 14,
  //                                                   color: Colors.white
  //                                                       .withOpacity(0.9),
  //                                                 ),
  //                                                 const SizedBox(width: 6),
  //                                                 Expanded(
  //                                                   child: Text(
  //                                                     item.address,
  //                                                     style: const TextStyle(
  //                                                       fontSize: 14,
  //                                                       fontWeight:
  //                                                           FontWeight.w600,
  //                                                       color: Colors.white,
  //                                                       fontFamily:
  //                                                           'Nunito-Sans',
  //                                                     ),
  //                                                     overflow:
  //                                                         TextOverflow.ellipsis,
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //             ],
  //           );
  //         },
  //       );
  //     }),
  //   );
  // }

  //-------------------

//   Widget _buildNearBySection() {
//     final HomeLocationController controller = Get.put(HomeLocationController());
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14),
//       child: StreamBuilder(
//         stream: controller.getAllRestaurants(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting)
//             return SizedBox();
//           if (snapshot.hasError ||
//               snapshot.data == null ||
//               snapshot.data!.isEmpty) return SizedBox();

//           List<RestaurantModel> allRestaurants = snapshot.data!;
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             controller.initailizedSelectors(resaturantsList: allRestaurants);
//           });

//           return FutureBuilder(
//           future: controller.getNearbyRestaurants(
//   allRestaurants,
//   50000, // 50 km
//   vibes: filterController.selectedVibes.toList(),
//   experiences: filterController.selectedExperiences.toList(),
//   cuisines: filterController.selectedCuisines.toList(),
// ),
//             builder: (context, futureSnapshot) {
//               if (futureSnapshot.connectionState == ConnectionState.waiting)
//                 return SizedBox();
//               if (futureSnapshot.hasError ||
//                   futureSnapshot.data == null ||
//                   futureSnapshot.data!.isEmpty) return SizedBox();

//               List<RestaurantModel> restaurants = futureSnapshot.data!;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Recommended for You",
//                         style: TextStyle(
//                           color: AppColors.bottomSheetColor,
//                           fontFamily: 'aftika-regular',
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () => Get.to(NearByAll()),
//                         child: Text(
//                           'See more',
//                           style: TextStyle(
//                             color: AppColors.primaryColor,
//                             fontFamily: 'aftika-regular',
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "We’ve matched your vibe! Explore hot spots tailored to your style.",
//                     textAlign: TextAlign.justify,
//                     style: TextStyle(
//                       color: AppColors.bottomSheetColor,
//                       fontFamily: 'aftika-regular',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   SizedBox(
//                     // Or any height matching your HorizontalCardWidget height
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.only(bottom: 16),
//                       child: Row(
//                         children: List.generate(restaurants.length, (index) {
//                           final item = restaurants[index];
//                           return HorizontalCardWidget(
//                             title: item.resName,
//                             imagePath: item.logoImage,
//                             description: item.address,
//                             isFavorite: false.obs,
//                             onTap: () => Get.to(
//                               RestaurantDetailScreen(restaurantModel: item),
//                             ),
//                           );
//                         }),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

  Widget _buildNearBySection() {
    final HomeLocationController controller = Get.put(HomeLocationController());
    final HomeFilterSearchController filterController =
        Get.put(HomeFilterSearchController());

    return StreamBuilder<List<RestaurantModel>>(
      stream: controller.getAllRestaurants(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox();
        }
        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return SizedBox();
        }

        List<RestaurantModel> allRestaurants = snapshot.data!;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.initailizedSelectors(resaturantsList: allRestaurants);
        });

        // Use Obx to watch reactive filter lists
        return Obx(() {
          final selectedVibes = filterController.selectedVibes.toList();
          final selectedExperiences =
              filterController.selectedExperiences.toList();
          final selectedCuisines = filterController.selectedCuisines.toList();

          final bool filtersApplied = selectedVibes.isNotEmpty ||
              selectedExperiences.isNotEmpty ||
              selectedCuisines.isNotEmpty;

          final future = controller.getNearbyRestaurants(
            allRestaurants,
            20000000, // 50 km
            vibes: selectedVibes,
            experiences: selectedExperiences,
            cuisines: selectedCuisines,
          );

          return FutureBuilder<List<RestaurantModel>>(
            future: future,
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return SizedBox();
              }
              if (futureSnapshot.hasError) {
                return Text("Something went wrong");
              }

              List<RestaurantModel> restaurants = futureSnapshot.data ?? [];

              if (restaurants.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Recommended for You",
                        style: TextStyle(
                          color: AppColors.bottomSheetColor,
                          fontFamily: 'NunitoSans-Bold',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        filtersApplied
                            ? "No restaurants matched your filters. Try clearing them."
                            : "No nearby restaurants found.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.bottomSheetColor,
                          fontFamily: 'NunitoSans-Regular',
                        ),
                      ),
                    ),
                  ],
                );
              }

              // Display horizontal list of restaurants
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recommended for You",
                          style: TextStyle(
                            color: AppColors.bottomSheetColor,
                            fontFamily: 'NunitoSans-Bold',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        InkWell(
                          onTap: () => Get.to(
                              NearByAll(filteredRestaurants: restaurants)),
                          child: Text(
                            'See more',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontFamily: 'NunitoSans-Regular',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "We’ve matched your vibe! Explore hot spots tailored to your style.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'NunitoSans-Regular',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: List.generate(restaurants.length, (index) {
                        final item = restaurants[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0
                                ? 16
                                : 8, // 👈 Fix: Give first card some space from left
                            right: index == restaurants.length - 1
                                ? 16
                                : 0, // Optionally also right space for last
                          ),
                          child: HorizontalCardWidget(
                            imageHeight: 106,
                            containerHeight: 190,
                            title: item.resName,
                            imagePath: item.logoImage,
                            description: item.address,
                            isFavorite: false.obs,
                            onTap: () => Get.to(
                              RestaurantDetailScreen(restaurantModel: item),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              );
            },
          );
        });
      },
    );
  }

//   Widget nearBySection() {
//     List<String> img = [
//       'assets/images/event_img5.png',
//       'assets/images/event_ing2.png'
//     ];
//     List<String> nameOfRestaurant = ['ABSteak by Chef', 'Tsuri'];
//     List<String> address = ['8500 Beverkt', ' 200 Manathan'];

//     return Padding(
//       padding: const EdgeInsets.only(left: 14, right: 14),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "You might like",
//                     style: TextStyle(
//                       color: AppColors.bottomSheetColor,
//                       fontFamily: 'aftika-regular',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     "For your best delicious food",
//                     textAlign: TextAlign.justify,
//                     style: TextStyle(
//                       color: AppColors.bottomSheetColor,
//                       fontFamily: 'aftika-regular',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//               InkWell(
//                 onTap: () {},
//                 child: Text(
//                   'See more',
//                   style: TextStyle(
//                     color: AppColors.primaryColor,
//                     fontFamily: 'aftika-regular',
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: 2,
//             itemBuilder: (context, index) {
//               return InkWell(
//                 onTap: () {},
//                 child: Container(
//                   width: Get.width,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.transparent,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Container(
//                         height: 82,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: Colors.transparent,
//                             image: DecorationImage(
//                                 fit: BoxFit.cover,
//                                 image: AssetImage(img[index]))),
//                       ),
//                       SizedBox(height: 8),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         child: Column(
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   width: 140,
//                                   child: Text(
//                                     nameOfRestaurant[index],
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 1,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 14,
//                                       fontFamily: 'Nunito-Regular',
//                                       color: AppColors.textColor,
//                                     ),
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 SizedBox(
//                                   width: 6,
//                                 )
//                               ],
//                             ),
//                             SizedBox(height: 2),
//                             Row(
//                               children: [
//                                 Image.asset(
//                                   'assets/images/location_icon2.png',
//                                   height: 16,
//                                   width: 16,
//                                 ),
//                                 SizedBox(
//                                   child: Text(
//                                     address[index],
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: 12,
//                                       fontFamily: 'Nunito-Regular',
//                                       color: AppColors.textColor,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 6,
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const ExpandableText({
    Key? key,
    required this.text,
    required this.style,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: widget.style);
        final tp = TextPainter(
          text: span,
          maxLines: 2,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflow = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: widget.style,
              textAlign: TextAlign.justify,
              maxLines: _expanded ? null : 2,
              overflow: TextOverflow.fade,
            ),
            if (isOverflow)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _expanded ? 'See less' : 'See more',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontFamily: 'Nunito-Regular',
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// 10-6-2025

// class FilterChipWidget extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final List<String> menuOptions;
//   final Function(String)? onOptionSelected;

//   const FilterChipWidget({
//     required this.label,
//     required this.icon,
//     required this.menuOptions,
//     this.onOptionSelected,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey key = GlobalKey();

//     return GestureDetector(
//       key: key,
//       onTap: () async {
//         final RenderBox renderBox =
//             key.currentContext!.findRenderObject() as RenderBox;
//         final Offset offset = renderBox.localToGlobal(Offset.zero);
//         final Size size = renderBox.size;

//         final selected = await showMenu<String>(
//           context: context,
//           position: RelativeRect.fromLTRB(
//             offset.dx,
//             offset.dy + size.height, // 👈 Menu shows below the chip
//             offset.dx + size.width,
//             offset.dy,
//           ),
//           items: menuOptions.map((option) {
//             return PopupMenuItem<String>(
//               value: option,
//               child: Text(option),
//             );
//           }).toList(),
//         );

//         if (selected != null && onOptionSelected != null) {
//           onOptionSelected!(selected);
//         }
//       },
//       child: Chip(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         backgroundColor: Colors.white,
//         label: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 18, color: Colors.black54),
//             const SizedBox(width: 4),
//             Text(label, style: const TextStyle(color: Colors.black87)),
//             const SizedBox(width: 4),
//             const Icon(Icons.keyboard_arrow_down,
//                 size: 18, color: Colors.black54),
//           ],
//         ),
//       ),
//     );
//   }
// }

//correct code

// class FilterChipWidget extends StatefulWidget {
//   final String label;
//   final String image;
//   final List<String> menuOptions;
//   final List<String> selectedOptions;
//   final Function(List<String>) onApply;

//   const FilterChipWidget({
//     required this.label,
//     required this.image,
//     required this.menuOptions,
//     required this.selectedOptions,
//     required this.onApply,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<FilterChipWidget> createState() => _FilterChipWidgetState();
// }

// class _FilterChipWidgetState extends State<FilterChipWidget> {
//   final GlobalKey _chipKey = GlobalKey();
//   late List<String> _tempSelected;

//   @override
//   void initState() {
//     super.initState();
//     _tempSelected = List.from(widget.selectedOptions);
//   }

//   void _showMultiSelectMenu() async {
//     _tempSelected = List.from(widget.selectedOptions);
//     final RenderBox renderBox =
//         _chipKey.currentContext!.findRenderObject() as RenderBox;
//     final Offset offset = renderBox.localToGlobal(Offset.zero);
//     final Size size = renderBox.size;

//     final overlay =
//         Overlay.of(context)?.context.findRenderObject() as RenderBox;
//     final RelativeRect position = RelativeRect.fromRect(
//       Rect.fromLTWH(offset.dx, offset.dy + size.height, size.width, 300),
//       Offset.zero & overlay.size,
//     );

//     await showMenu(
//       context: context,
//       position: position,
//       constraints: const BoxConstraints(maxWidth: 250),
//       elevation: 0, // No shadow
//       items: [
//         PopupMenuItem(
//           height: 0, // Remove default padding
//           padding: EdgeInsets.zero,
//           child: StatefulBuilder(
//             builder: (context, setStatePopup) {
//               return Material(
//                 color: Colors.white, // Pure white background
//                 borderRadius: BorderRadius.circular(12),
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Heading
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Text(
//                           widget.label,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                       // Checkbox list
//                       Column(
//                         children: widget.menuOptions.map((option) {
//                           final isChecked = _tempSelected.contains(option);
//                           return Material(
//                             color: Colors.white, // White background for items
//                             child: InkWell(
//                               splashColor:
//                                   Colors.transparent, // No ripple effect
//                               highlightColor: Colors.transparent,
//                               onTap: () {
//                                 setStatePopup(() {
//                                   if (isChecked) {
//                                     _tempSelected.remove(option);
//                                   } else {
//                                     _tempSelected.add(option);
//                                   }
//                                 });
//                               },
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 8),
//                                 child: Row(
//                                   children: [
//                                     Checkbox(
//                                       value: isChecked,
//                                       onChanged: (value) {
//                                         setStatePopup(() {
//                                           if (value == true) {
//                                             _tempSelected.add(option);
//                                           } else {
//                                             _tempSelected.remove(option);
//                                           }
//                                         });
//                                       },
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(4),
//                                       ),
//                                       activeColor: AppColors.primaryColor,
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       option,
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                       const SizedBox(height: 8),
//                       // Divider and buttons
//                       const Divider(height: 1, color: Colors.grey),
//                       const SizedBox(height: 12),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           TextButton(
//                             onPressed: () {
//                               _tempSelected.clear();
//                               widget.onApply([]);
//                               Navigator.pop(context);
//                               setState(() {});
//                             },
//                             child: const Text(
//                               "Clear",
//                               style: TextStyle(
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               widget.onApply(_tempSelected);
//                               Navigator.pop(context);
//                               setState(() {});
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.primaryColor,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 8),
//                             ),
//                             child: const Text(
//                               "Apply",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       key: _chipKey,
//       onTap: _showMultiSelectMenu,
//       child: Container(
//         width: 120, // 🔁 Set exact width from Figma
//         height: 32, // 🔁 Set exact height from Figma

//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.white),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               widget.image,
//               width: 18,
//               height: 18,
//             ),
//             const SizedBox(width: 4),
//             Text(
//               widget.label,
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontSize: 10, // 🔁 Adjust as per Figma
//               ),
//             ),
//             const SizedBox(width: 5),
//             const Icon(
//               Icons.keyboard_arrow_down,
//               size: 18,
//               color: Colors.black54,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FilterChipWidget extends StatefulWidget {
//   final String label;
//   final String image;
//   final List<String> menuOptions;
//   final List<String> selectedOptions;
//   final Function(List<String>) onApply;

//   const FilterChipWidget({
//     required this.label,
//     required this.image,
//     required this.menuOptions,
//     required this.selectedOptions,
//     required this.onApply,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<FilterChipWidget> createState() => _FilterChipWidgetState();
// }

// class _FilterChipWidgetState extends State<FilterChipWidget> {
//   final GlobalKey _chipKey = GlobalKey();
//   late List<String> _tempSelected;

//   @override
//   void initState() {
//     super.initState();
//     _tempSelected = List.from(widget.selectedOptions);
//   }

//   void _showMultiSelectMenu() async {
//     _tempSelected = List.from(widget.selectedOptions);
//     final RenderBox renderBox =
//         _chipKey.currentContext!.findRenderObject() as RenderBox;
//     final Offset offset = renderBox.localToGlobal(Offset.zero);
//     final Size size = renderBox.size;

//     final overlay =
//         Overlay.of(context)?.context.findRenderObject() as RenderBox;
//     final RelativeRect position = RelativeRect.fromRect(
//       Rect.fromLTWH(offset.dx, offset.dy + size.height, size.width, 300),
//       Offset.zero & overlay.size,
//     );

//     await showMenu(
//       context: context,
//       position: position,
//       constraints: const BoxConstraints(maxWidth: 250),
//       elevation: 0,
//       items: [
//         PopupMenuItem(
//           height: 0,
//           padding: EdgeInsets.zero,
//           child: StatefulBuilder(
//             builder: (context, setStatePopup) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   // boxShadow: [
//                   //   BoxShadow(
//                   //     color: Colors.black.withOpacity(0.1),
//                   //     blurRadius: 10,
//                   //     spreadRadius: 2,
//                   //   ),
//                   // ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Header
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         // border: Border(
//                         //   bottom: BorderSide(
//                         //     color: Colors.grey.shade200,
//                         //     width: 1,
//                         //   ),
//                         // ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             widget.label,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           if (_tempSelected.isNotEmpty)
//                             GestureDetector(
//                               onTap: () {
//                                 setStatePopup(() {
//                                   _tempSelected.clear();
//                                 });
//                               },
//                               child: Text(
//                                 'Clear',
//                                 style: TextStyle(
//                                   color: AppColors.primaryColor,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     // Options list
//                     Container(
//                       constraints: BoxConstraints(maxHeight: 200),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: widget.menuOptions.map((option) {
//                             final isChecked = _tempSelected.contains(option);
//                             return InkWell(
//                               onTap: () {
//                                 setStatePopup(() {
//                                   if (isChecked) {
//                                     _tempSelected.remove(option);
//                                   } else {
//                                     _tempSelected.add(option);
//                                   }
//                                 });
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 12),
//                                 decoration: BoxDecoration(
//                                   border: Border(
//                                     bottom: BorderSide(
//                                       color: Colors.grey.shade100,
//                                       width: 1,
//                                     ),
//                                   ),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 20,
//                                       height: 20,
//                                       decoration: BoxDecoration(
//                                         borderRadius:
//                                             BorderRadius.circular(4),
//                                         border: Border.all(
//                                           color: isChecked
//                                               ? AppColors.primaryColor
//                                               : Colors.grey.shade400,
//                                         ),
//                                         color: isChecked
//                                             ? AppColors.primaryColor
//                                             : Colors.transparent,
//                                       ),
//                                       child: isChecked
//                                           ? Icon(
//                                               Icons.check,
//                                               size: 14,
//                                               color: Colors.white,
//                                             )
//                                           : null,
//                                     ),
//                                     SizedBox(width: 12),
//                                     Text(
//                                       option,
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                     // Apply button
//                     Container(
//                       padding: EdgeInsets.all(16),
//                       child: SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             widget.onApply(_tempSelected);
//                             Navigator.pop(context);
//                             setState(() {});
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primaryColor,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             padding: EdgeInsets.symmetric(vertical: 12),
//                           ),
//                           child: Text(
//                             'Apply',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       key: _chipKey,
//       onTap: _showMultiSelectMenu,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: Colors.grey.shade300,
//             width: 1,
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(
//               widget.image,
//               width: 16,
//               height: 16,
//             ),
//             SizedBox(width: 4),
//             Text(
//               widget.label,
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(width: 4),
//             Icon(
//               Icons.keyboard_arrow_down,
//               size: 16,
//               color: Colors.grey.shade600,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class FilterChipWidget extends StatefulWidget {
  final String label;

  final List<String> menuOptions;
  final List<String> selectedOptions;
  final Function(List<String>) onApply;

  const FilterChipWidget({
    required this.label,
    required this.menuOptions,
    required this.selectedOptions,
    required this.onApply,
    Key? key,
  }) : super(key: key);

  @override
  State<FilterChipWidget> createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  final GlobalKey _chipKey = GlobalKey();
  late List<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedOptions);
  }

  void _showMultiSelectMenu() async {
    _tempSelected = List.from(widget.selectedOptions);
    final RenderBox renderBox =
        _chipKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final overlay =
        Overlay.of(context)?.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(offset.dx, offset.dy + size.height, size.width, 300),
      Offset.zero & overlay.size,
    );

    await showMenu(
      context: context,
      position: position,
      constraints: const BoxConstraints(maxWidth: 250),
      elevation: 0,
      color: Colors.transparent,
      items: [
        PopupMenuItem(
          height: 0,
          padding: EdgeInsets.zero,
          child: StatefulBuilder(
            builder: (context, setStatePopup) {
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with Clear option
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.label,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: "NunitoSans-Regular"),
                          ),
                          if (_tempSelected.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setStatePopup(() {
                                  _tempSelected.clear();
                                });
                              },
                              child: Text(
                                'Clear',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Options list
                    Container(
                      constraints: BoxConstraints(maxHeight: 200),
                      child: SingleChildScrollView(
                        child: Column(
                          children: widget.menuOptions.map((option) {
                            final isChecked = _tempSelected.contains(option);
                            return Material(
                              color: Colors.white,
                              child: InkWell(
                                onTap: () {
                                  setStatePopup(() {
                                    if (isChecked) {
                                      _tempSelected.remove(option);
                                    } else {
                                      _tempSelected.add(option);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                            color: isChecked
                                                ? AppColors.primaryColor
                                                : Colors.grey.shade400,
                                          ),
                                          color: isChecked
                                              ? AppColors.primaryColor
                                              : Colors.transparent,
                                        ),
                                        child: isChecked
                                            ? Icon(
                                                Icons.check,
                                                size: 14,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      SizedBox(width: 12),
                                      Text(option),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    // Apply button
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onApply(_tempSelected);
                            Navigator.pop(context);
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Apply'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _chipKey,
      onTap: _showMultiSelectMenu,
      child: Container(
        width: 110,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.blackColor,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //SizedBox(width: 4),
            Text(
              widget.label,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: "NunitoSans-Regular"),
            ),
         //   SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}
//-----------------------    old code ..............---------

// Widget experienceWidget() {
//   return Column(
//     children: [
//       Padding(
//         padding: const EdgeInsets.only(left: 14, right: 14),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Experience',
//               style: TextStyle(
//                 color: AppColors.bottomSheetColor,
//                 fontFamily: 'aftika-regular',
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             InkWell(
//               onTap: () => Get.to(EntertainmentsScreen()),
//               child: Text(
//                 "view all",
//                 style: TextStyle(
//                   decoration: TextDecoration.underline,
//                   decorationColor: AppColors.primaryColor,
//                   fontFamily: 'Nunito-Regular',
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: AppColors.primaryColor,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       SizedBox(height: 10),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//         child: StreamBuilder(
//           stream: homeController.getEntertainmentRestaurants(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return buildShimmerEffect();
//             }
//             if (snapshot.hasError) {
//               print('Error during stream call ${snapshot.error}');
//               return Text('');
//             }
//             if (snapshot.data == null || snapshot.data!.isEmpty) {
//               return Text('No restaurants found');
//             }
//             List<RestaurantModel> restaurants = snapshot.data!;
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               homeController.initializeSelectors(restaurants);
//             });
//             return GetBuilder<HomeLocationController>(
//               builder: (controller) {
//                 return SizedBox(
//                   height: 270,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: controller.filteredRestaurants.length,
//                     itemBuilder: (context, index) {
//                       final item = controller.filteredRestaurants[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: InkWell(
//                           onTap: () => Get.to(
//                               RestaurantDetailScreen(restaurantModel: item)),
//                           child: RectangleWidget(
//                             boxColor: AppColors.whiteColor,
//                             imgHeight: 203,
//                             height: 304,
//                             width: 230,
//                             title: item.resName,
//                             description: item.address,
//                             resturant_id: item.docID,
//                             imagePath: item.logoImage,
//                             timetext: '10 AM',
//                             percentText: '25%',
//                             endTimeText: '9 PM',
//                             // percentageOff:
//                             //     item.menuList.percentageOff,
//                             // happyhour:
//                             //     item.menuList.happyHourSpecials,
//                             isFavorite: false.obs,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       SizedBox(height: 10),
//     ],
//   );
// }

//................Haseeb

// Widget experienceWidget() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Padding(
//         padding: const EdgeInsets.only(left: 14, right: 14),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Experience',
//               style: TextStyle(
//                 color: AppColors.bottomSheetColor,
//                 fontFamily: 'aftika-regular',
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//             InkWell(
//               onTap: () => Get.to(EntertainmentsScreen()),
//               child: Text(
//                 'See more',
//                 style: TextStyle(
//                   color: AppColors.primaryColor,
//                   fontFamily: 'aftika-regular',
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       SizedBox(height: 10),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: StreamBuilder(
//           stream: homeController.getEntertainmentRestaurants(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return buildShimmerEffect();
//             }
//             if (snapshot.hasError) {
//               print('Error during stream call ${snapshot.error}');
//               return Text('');
//             }
//             if (snapshot.data == null || snapshot.data!.isEmpty) {
//               return Text('No restaurants found');
//             }
//             List<RestaurantModel> restaurants = snapshot.data!;
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               homeController.initializeSelectors(restaurants);
//             });
//             return GetBuilder<HomeLocationController>(
//               builder: (controller) {
//                 return GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     childAspectRatio: 0.7, // Adjust as per your design
//                   ),
//                   itemCount: controller.filteredRestaurants.length,
//                   itemBuilder: (context, index) {
//                     final item = controller.filteredRestaurants[index];
//                     return InkWell(
//                       onTap: () => Get.to(
//                           RestaurantDetailScreen(restaurantModel: item)),
//                       child: RectangleWidget(
//                         boxColor: AppColors.whiteColor,
//                         imgHeight: 120, // Adjust height for grid tile
//                         height: 220, // Adjust as needed
//                         width: MediaQuery.of(context).size.width / 2 - 20,
//                         title: item.resName,
//                         description: item.address,
//                         resturant_id: item.docID,
//                         imagePath: item.logoImage,
//                         timetext: '10 AM',
//                         percentText: '25%',
//                         endTimeText: '9 PM',
//                         isFavorite: false
//                             .obs, // YOUR ORIGINAL FUNCTIONALITY PRESERVED
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       SizedBox(height: 10),
//     ],
//   );
// }

// Widget experienceWidget() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Padding(
//         padding: const EdgeInsets.only(left: 14, right: 14),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Experience',
//                style: TextStyle(
//                               color: AppColors.bottomSheetColor,
//                               fontFamily: 'aftika-regular',
//                               fontSize: 20,
//                               fontWeight: FontWeight.w700,
//                               decoration: TextDecoration.underline,
//                             ),
//             ),
//             InkWell(
//               onTap: () => Get.to(EntertainmentsScreen()),
//               child: Text(
//                 "See more",
//                 style: TextStyle(
//                   decoration: TextDecoration.underline,
//                   decorationColor: AppColors.primaryColor,
//                   fontFamily: 'Nunito-Regular',
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: AppColors.primaryColor,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       SizedBox(height: 10),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: StreamBuilder(
//           stream: homeController.getEntertainmentRestaurants(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return buildShimmerEffect();
//             }
//             if (snapshot.hasError) {
//               print('Error during stream call ${snapshot.error}');
//               return Text('Error loading data');
//             }
//             if (snapshot.data == null || snapshot.data!.isEmpty) {
//               return Text('No restaurants found');
//             }
//             List<RestaurantModel> restaurants = snapshot.data!;
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               homeController.initializeSelectors(restaurants);
//             });
//             return GetBuilder<HomeLocationController>(
//               builder: (controller) {
//                 return GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2, // 2 columns as per screenshot
//                     mainAxisSpacing: 10,
//                     crossAxisSpacing: 10,
//                     childAspectRatio: 0.8, // adjust as per design
//                   ),
//                   itemCount: controller.filteredRestaurants.length,
//                   itemBuilder: (context, index) {
//                     final item = controller.filteredRestaurants[index];
//                     return InkWell(
//                       onTap: () => Get.to(RestaurantDetailScreen(restaurantModel: item)),
//                       child: Stack(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               image: DecorationImage(
//                                 image: NetworkImage(item.logoImage),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             top: 8,
//                             right: 8,
//                             child: Icon(Icons.favorite_border, color: Colors.white),
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             left: 0,
//                             right: 0,
//                             child: Container(
//                               padding: EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: Colors.black.withOpacity(0.5),
//                                 borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(15),
//                                   bottomRight: Radius.circular(15),
//                                 ),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     item.resName ?? 'Kaistable',
//                                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                   ),
//                                   SizedBox(height: 4),
//                                   Row(
//                                     children: [
//                                       Icon(Icons.location_on, color: Colors.white, size: 14),
//                                       SizedBox(width: 4),
//                                       Expanded(
//                                         child: Text(
//                                           '${item.address ?? 'Unknown'}',
//                                           style: TextStyle(color: Colors.white, fontSize: 12),
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       SizedBox(height: 10),
//     ],
//   );
// }

//--------------------------------------

// Widget _featuredCategory() {
//   return StreamBuilder<Map<String, dynamic>?>(
//     stream: homeController.getFeaturedRestaurantID(),
//     builder: (context, featuredIDSnapshot) {
//       if (!featuredIDSnapshot.hasData ||
//           featuredIDSnapshot.data == null ||
//           featuredIDSnapshot.data!.isEmpty) {
//         return const SizedBox(); // hide entire section if no featured ID
//       }
//       Map<String, dynamic> data =
//           featuredIDSnapshot.data as Map<String, dynamic>;

//       return StreamBuilder<RestaurantModel?>(
//         stream: homeController.getFeaturedRestaurants(
//             restID: data['restaurantID']),
//         builder: (context, restaurantSnapshot) {
//           if (!restaurantSnapshot.hasData ||
//               restaurantSnapshot.data == null) {
//             return const SizedBox(); // hide entire section if no data
//           }

//           final restaurant = restaurantSnapshot.data!;

//           return Container(
//             // height: Get.height * 0.45,
//             width: Get.width,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 143, 164, 157),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 10),
//                   Text(
//                     'Featured',
//                     style: TextStyle(
//                       color: AppColors.bottomSheetColor,
//                       fontFamily: 'aftika-regular',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     data['description'] ?? '',
//                     textAlign: TextAlign.justify,
//                     style: TextStyle(
//                       color: AppColors.bottomSheetColor,
//                       fontFamily: 'Nunito-Regular',
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 18),
//                   GestureDetector(
//                     onTap: () {
//                       Get.to(RestaurantDetailScreen(
//                         restaurantModel: restaurant,
//                       ));
//                     },
//                     child: Container(
//                       // height: Get.height * 0.29,
//                       width: Get.width,
//                       decoration: BoxDecoration(
//                         color: AppColors.whiteColor,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(10),
//                                 topRight: Radius.circular(10),
//                               ),
//                               child: Image.network(
//                                 restaurant.logoImage,
//                                 height: 169,
//                                 width: Get.width,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   restaurant.resName,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w800,
//                                     color: AppColors.headingTextColor,
//                                     fontFamily: 'Nunito-Regular',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 10, top: 5, right: 10),
//                             child: ExpandableText(
//                               text: restaurant.specialConditions,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w500,
//                                 color: AppColors.headingTextColor,
//                                 fontFamily: 'Nunito-Regular',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 18),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }

// Widget _featuredCategory() {
//   return StreamBuilder<Map<String, dynamic>?>(
//     stream: homeController.getFeaturedRestaurantID(),
//     builder: (context, featuredIDSnapshot) {
//       if (!featuredIDSnapshot.hasData ||
//           featuredIDSnapshot.data == null ||
//           featuredIDSnapshot.data!.isEmpty) {
//         return const SizedBox(); // hide entire section if no featured ID
//       }
//       Map<String, dynamic> data =
//           featuredIDSnapshot.data as Map<String, dynamic>;

//       return StreamBuilder<RestaurantModel?>(
//         stream: homeController.getFeaturedRestaurants(
//             restID: data['restaurantID']),
//         builder: (context, restaurantSnapshot) {
//           if (!restaurantSnapshot.hasData ||
//               restaurantSnapshot.data == null) {
//             return const SizedBox(); // hide entire section if no data
//           }

//           final restaurant = restaurantSnapshot.data!;

//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Top Rated',
//                       style: TextStyle(
//                         color: AppColors.bottomSheetColor,
//                         fontFamily: 'aftika-regular',
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         // Add navigation for "See more" if needed
//                       },
//                       child: Text(
//                         'See more',
//                         style: TextStyle(
//                           color: AppColors.primaryColor,
//                           fontFamily: 'aftika-regular',
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   data['description'] ?? 'Experience the art of Cuisine at ${restaurant.resName}. Now open with a special launch menu and elegant ambiance.',
//                   style: TextStyle(
//                     color: AppColors.bottomSheetColor,
//                     fontFamily: 'Nunito-Regular',
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 GestureDetector(
//                   onTap: () {
//                     Get.to(RestaurantDetailScreen(
//                       restaurantModel: restaurant,
//                     ));
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: AppColors.whiteColor,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.vertical(
//                             top: Radius.circular(10),
//                           ),
//                           child: Image.network(
//                             restaurant.logoImage,
//                             height: 200,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 restaurant.resName,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w800,
//                                   color: AppColors.headingTextColor,
//                                   fontFamily: 'Nunito-Regular',
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 '${restaurant.address}',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.textColor,
//                                   fontFamily: 'Nunito-Regular',
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     size: 16,
//                                     color: AppColors.textColor,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     '${restaurant.address} km', // Make sure distance is available in your model
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w500,
//                                       color: AppColors.textColor,
//                                       fontFamily: 'Nunito-Regular',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }

//   Widget _buildNearBySection() {
//   final HomeLocationController controller = Get.put(HomeLocationController());
//   return Padding(
//     padding: const EdgeInsets.only(left: 14, right: 14),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Header section with proper spacing
//         Padding(
//           padding: const EdgeInsets.only(bottom: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "You might like",
//                     style: TextStyle(
//                       color: AppColors.bottomSheetColor,
//                       fontFamily: 'aftika-regular',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     "Curated picks just for you",
//                     style: TextStyle(
//                       color: AppColors.bottomSheetColor,
//                       fontFamily: 'aftika-regular',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//               InkWell(
//                 onTap: () => Get.to(NearByAll()),
//                 child: Text(
//                   "view all",
//                   style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     decorationColor: AppColors.primaryColor,
//                     fontFamily: 'Nunito-Regular',
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.primaryColor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Restaurants list
//         StreamBuilder(
//           stream: controller.getAllRestaurants(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
//             }
//             if (snapshot.hasError) {
//               return Text('Error loading restaurants');
//             }
//             if (snapshot.data == null || snapshot.data!.isEmpty) {
//               return Text('No nearby restaurants found');
//             }

//             List<RestaurantModel> all_restaurants = snapshot.data!;
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               controller.initailizedSelectors(resaturantsList: all_restaurants);
//             });

//             return FutureBuilder(
//               future: controller.getNearbyRestaurants(all_restaurants, 50000),
//               builder: (context, futureSnapshot) {
//                 if (futureSnapshot.connectionState == ConnectionState.waiting) {
//                   return SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
//                 }
//                 if (futureSnapshot.hasError) {
//                   return Text('Error loading nearby restaurants');
//                 }
//                 if (!futureSnapshot.hasData || futureSnapshot.data!.isEmpty) {
//                   return Text('No restaurants in your area');
//                 }

//                 List<RestaurantModel> restaurants = futureSnapshot.data ?? [];
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: restaurants.length > 2 ? 2 : restaurants.length,
//                   itemBuilder: (context, index) {
//                     final item = restaurants[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 16),
//                       child: InkWell(
//                         onTap: () => Get.to(RestaurantDetailScreen(restaurantModel: item)),
//                         child: RectangleWidget(
//                           imgHeight: 169,
//                           title: item.resName,
//                           description: item.address,
//                           resturant_id: item.docID,
//                           imagePath: item.logoImage,
//                           timetext: '10 AM',
//                           percentText: '25%',
//                           endTimeText: '9 PM',
//                           isFavorite: false.obs,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         ),
//       ],
//     ),
//   );
// }

//   Widget trendingSection() {
//     List<String> img = [
//       'assets/images/aaa.jpg',
//       'assets/images/event_ing2.png'
//     ];
//     List<String> nameOfRestaurant = ['Cactus Cantina', 'Tsuri'];
//     List<String> address = ['Scottside', 'Manathan'];

//     return Padding(
//       padding: const EdgeInsets.only(left: 12),
//       child: Column(
//         children: [
//           SizedBox(height: 10),
//           Padding(
//             padding: EdgeInsets.only(right: 18),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Trending',
//                       style: TextStyle(
//                         color: AppColors.bottomSheetColor,
//                         fontFamily: 'aftika-regular',
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       'Places that are popular',
//                       textAlign: TextAlign.justify,
//                       style: TextStyle(
//                         color: AppColors.bottomSheetColor,
//                         fontFamily: 'aftika-regular',
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 10),
//           SizedBox(
//             height: Get.height * 0.3,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: img.length,
//               itemBuilder: (context, index) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(right: 16.0),
//                       child: Container(
//                         width: 274,
//                         height: 181,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.rectangle,
//                           borderRadius: BorderRadius.circular(10),
//                           image: DecorationImage(
//                             image: AssetImage(img[index]),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 6),
//                     Text(
//                       nameOfRestaurant[index],
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: AppColors.headingTextColor,
//                         fontWeight: FontWeight.w700,
//                         fontFamily: 'Nunito-Sans',
//                       ),
//                     ),
//                     SizedBox(height: 6),
//                     SizedBox(
//                       width: Get.width * 0.3,
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             'assets/images/location_icon2.png',
//                             height: 16,
//                             width: 16,
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             address[index],
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: AppColors.textColor,
//                               fontWeight: FontWeight.w600,
//                               fontFamily: 'Nunito-Sans',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

// Widget _buildNearBySection() {
//   final HomeLocationController controller = Get.put(HomeLocationController());
//   return Padding(
//     padding: const EdgeInsets.only(left: 14, right: 14),
//     child: StreamBuilder(
//       stream: controller.getAllRestaurants(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting)
//           return SizedBox();
//         if (snapshot.hasError) {
//           print('Error during stream call ${snapshot.error}');
//           return Text('');
//         }
//         if (snapshot.data == null || snapshot.data!.isEmpty) return Text('');
//         List<RestaurantModel> all_restaurants = snapshot.data!;
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           controller.initailizedSelectors(resaturantsList: all_restaurants);
//         });
//         return FutureBuilder(
//           future: controller.getNearbyRestaurants(all_restaurants, 50000),
//           builder: (context, futureSnapshot) {
//             if (futureSnapshot.connectionState == ConnectionState.waiting)
//               return SizedBox();
//             if (futureSnapshot.hasError) return Text('');
//             if (!futureSnapshot.hasData || futureSnapshot.data!.isEmpty)
//               return Text('');
//             List<RestaurantModel> restaurants = futureSnapshot.data ?? [];
//             if (restaurants.isEmpty) return SizedBox();
//             return Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "You might like",
//                           style: TextStyle(
//                             color: AppColors.bottomSheetColor,
//                             fontFamily: 'aftika-regular',
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           "Curated picks just for you",
//                           textAlign: TextAlign.justify,
//                           style: TextStyle(
//                             color: AppColors.bottomSheetColor,
//                             fontFamily: 'aftika-regular',
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                     InkWell(
//                       onTap: () => Get.to(NearByAll()),
//                       child: Text(
//                         "view all",
//                         style: TextStyle(
//                           decoration: TextDecoration.underline,
//                           decorationColor: AppColors.primaryColor,
//                           fontFamily: 'Nunito-Regular',
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.primaryColor,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: restaurants.length > 2 ? 2 : restaurants.length,
//                   itemBuilder: (context, index) {
//                     final item = restaurants[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 10),
//                       child: InkWell(
//                         onTap: () => Get.to(
//                             RestaurantDetailScreen(restaurantModel: item)),
//                         child: RectangleWidget(
//                           imgHeight: 169,
//                           title: item.resName,
//                           description: item.address,
//                           resturant_id: item.docID,
//                           imagePath: item.logoImage,
//                           timetext: '10 AM',
//                           percentText: '25%',
//                           endTimeText: '9 PM',
//                           isFavorite: false.obs,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     ),
//   );
// }





  // Helper function to get user position

  // Widget _buildCategories() {
  //   return Obx(() => Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(left: 14),
  //             child: Text(
  //               'Explore By Category',
  //               style: TextStyle(
  //                 color: AppColors.bottomSheetColor,
  //                 fontFamily: 'aftika-regular',
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 5),
  //           Padding(
  //             padding: const EdgeInsets.only(left: 14),
  //             child: Text(
  //               'Find food that fits you',
  //               style: TextStyle(
  //                 color: AppColors.bottomSheetColor,
  //                 fontFamily: 'aftika-regular',
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 14),
  //           SizedBox(
  //             height: 100,
  //             child: ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               itemCount: controller.categories.length,
  //               itemBuilder: (context, index) {
  //                 var category = controller.categories[index];
  //                 return GestureDetector(
  //                   onTap: () {
  //                     if (category['name'] == 'Cuisines') {
  //                       Get.to(CuisinesViewAll());
  //                     } else if (category['name'] == 'New') {
  //                       Get.to(NewViewall());
  //                     } else if (category['name'] == 'Trending') {
  //                       Get.to(TrendingViewAll());
  //                     } else if (category['name'] == 'Experience') {
  //                       Get.to(EntertainmentsScreen());
  //                     } else if (category['name'] == 'Events') {
  //                       Get.to(EventScreen());
  //                     }
  //                   },
  //                   child: Column(
  //                     children: [
  //                       Container(
  //                         margin: EdgeInsets.symmetric(horizontal: 15),
  //                         width: 70,
  //                         height: 70,
  //                         decoration: BoxDecoration(
  //                           shape: BoxShape.rectangle,
  //                           borderRadius: BorderRadius.circular(10),
  //                           image: DecorationImage(
  //                             image: AssetImage(category["image"] as String),
  //                             fit: BoxFit.cover,
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(height: 5),
  //                       Text(
  //                         category["name"] as String,
  //                         style: TextStyle(
  //                           fontSize: 12,
  //                           color: AppColors.bottomSheetColor,
  //                           fontWeight: FontWeight.w500,
  //                           fontFamily: 'aftika-regular',
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       ));
  // }
