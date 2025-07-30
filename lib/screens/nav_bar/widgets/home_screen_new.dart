import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import 'package:kaistable_website/widgets/global_functions.dart';
import 'package:kaistable_website/widgets/rectangle_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/showcase_container.dart';
import '../../home_screen/events_screen/common_widget/days_tile.dart';
import '../../home_screen/events_screen/controller/events_controller.dart';
import '../../home_screen/events_screen/event_screen.dart';
import '../../home_screen/events_screen/events_details_screen/event_details_screen.dart';
import '../../home_screen/home_controller/filter_selection_controller.dart';
import '../controller/home_controller.dart';
import '../controller/search_controller.dart';

class HomeScreenNew extends StatefulWidget {
  @override
  State<HomeScreenNew> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenNew> {
  HomeController controller = Get.put(HomeController());
  final EventsController eventController = Get.put(EventsController());
  final HomeLocationController homeController = Get.put(HomeLocationController());
  final FilterSelectionController filterSelectionController =
  Get.put(FilterSelectionController());
  final GlobalKey _categoryKey = GlobalKey();
  final GlobalKey _trendingKey = GlobalKey();
  final GlobalKey _featuredCategoryKey = GlobalKey();
  final GlobalKey _nearBySectionKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _eventsKey = GlobalKey();
  bool hasStartedShowcase = false;
  final ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  bool _showMap = false;
  GoogleMapController? _mapController;
  final DraggableScrollableController _sheetController =
  DraggableScrollableController();
  String _selectedDistance = '5 km';
  final Rx<Set<Marker>> _markers = Rx<Set<Marker>>(<Marker>{});
  bool _showFilterResults = false;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _sheetController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _updateMapMarkers() {
    final filterSelectionController = Get.find<FilterSelectionController>();
    final selectedFilters = filterSelectionController.aggregatedFilters;
    final distance = int.parse(_selectedDistance.replaceAll(' km', ''));

    _markers.value = <Marker>{}; // Clear existing markers

    homeController.getAllRestaurants().listen((snapshot) {
      if (snapshot != null && snapshot.isNotEmpty) {
        // Simulate distance filtering (replace with actual geolocation logic if available)
        final userLat = 34.0522; // Default to Los Angeles latitude
        final userLng = -118.2437; // Default to Los Angeles longitude
        final filteredRestaurants = snapshot.where((restaurant) {
          bool matchesFilters = true;
          if (selectedFilters.isNotEmpty) {
            final selectedFiltersLowercase = selectedFilters.map((f) => f.toLowerCase()).toList();
            matchesFilters = selectedFiltersLowercase.any((filter) {
              return restaurant.dietaryList.map((e) => e.toLowerCase()).contains(filter) ||
                  restaurant.menuList.map((e) => e.cuisineType.toLowerCase()).contains(filter) ||
                  restaurant.priceRange.toLowerCase().contains(filter) ||
                  restaurant.atmosphereList.map((e) => e.toLowerCase()).contains(filter) ||
                  restaurant.entertainmentScheduleList.any((schedule) => schedule.eventName.toLowerCase().contains(filter));
            });
          }
          // Simple distance approximation (Haversine formula simplified)
          final double latDiff = (restaurant.latitude - userLat).abs();
          final double lngDiff = (restaurant.longitude - userLng).abs();
          final double approxDistance = (latDiff + lngDiff) * 111; // km per degree
          return approxDistance <= distance && matchesFilters;
        }).toList().toSet().toList(); // Remove duplicates

        Set<Marker> newMarkers = {};
        for (var restaurant in filteredRestaurants) {
          newMarkers.add(Marker(
            markerId: MarkerId(restaurant.docID), // Ensure docID is unique
            position: LatLng(restaurant.latitude, restaurant.longitude),
            infoWindow: InfoWindow(title: restaurant.resName),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ));
        }
        if (_mapController != null && filteredRestaurants.isNotEmpty) {
          final firstRestaurant = filteredRestaurants.first;
          _mapController!.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(firstRestaurant.latitude, firstRestaurant.longitude), 10.0));
        }
        _markers.value = newMarkers; // Update markers atomically
        print('Number of markers: ${newMarkers.length}'); // Debug output
      }
    });
  }
  void _showFilterBottomSheet(String filterType) {
    final FilterController controller = Get.put(FilterController());

    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.red, fontSize: 16)),
                  ),
                  GestureDetector(
                    onTap: controller.clearAll,
                    child: const Text("Clear all",
                        style: TextStyle(color: Colors.red, fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Filter by $filterType',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.headingTextColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito-Sans',
                ),
              ),
              const SizedBox(height: 10),
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.filterOptions.containsKey(filterType))
                    ...controller.filterOptions[filterType]!.map((option) {
                      return CheckboxListTile(
                        title: Text(option),
                        value:
                        controller.selectedFilters[filterType]!.contains(option),
                        onChanged: (bool? value) {
                          if (value != null) {
                            controller.toggleFilter(filterType, option);
                          }
                        },
                      );
                    }).toList(),
                ],
              )),
              const SizedBox(height: 20),
              Obx(
                    () => CustomButton(
                  laBelText: "Apply (${controller.getTotalSelected()})",
                  ontapp: () {
                    filterSelectionController.aggregateSelectedFilters();
                    Get.back();
                    setState(() {
                      _showFilterResults = true;
                      _updateMapMarkers();
                    });
                  },
                  height: 48,
                  containerColor: AppColors.primaryColor,
                  textColor: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  radius: BorderRadius.circular(8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showFilteredRestaurantsBottomSheet(List<RestaurantModel> restaurants) {
    Get.bottomSheet(
        Container(
          height: Get.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Filtered Results',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.headingTextColor,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Restaurants Near Me
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Restaurants Near Me',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.headingTextColor,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final item = restaurants[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: InkWell(
                              onTap: () => Get.to(RestaurantDetailScreen(restaurantModel: item)),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                                      child: Image.network(
                                        item.logoImage,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item.resName,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              item.address,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Experience
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Experience',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.headingTextColor,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final item = restaurants[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: InkWell(
                              onTap: () => Get.to(RestaurantDetailScreen(restaurantModel: item)),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                                      child: Image.network(
                                        item.logoImage,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item.resName,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              item.address,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Vibes
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Vibes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.headingTextColor,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final item = restaurants[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: InkWell(
                              onTap: () => Get.to(RestaurantDetailScreen(restaurantModel: item)),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                                      child: Image.network(
                                        item.logoImage,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item.resName,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              item.address,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

        )
        );
    }
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
          appBar: null,
          body: Stack(
            children: [
              if (_showMap)
                Obx(() => GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(34.0522, -118.2437),
                    zoom: 10.0,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _updateMapMarkers();
                  },
                  markers: _markers.value,
                )),
              SafeArea(
                child: Container(
                  color: Colors.white.withOpacity(_showMap ? 0.9 : 1.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _searchController,
                        onTap: () {
                          setState(() {
                            _showMap = true;
                          });
                        },
                        decoration: InputDecoration(
                          hintText:
                          'Search for restaurants, events, live music...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          prefixIcon:
                          Icon(Icons.search, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.arrow_drop_down,
                                size: 20, color: Colors.grey),
                            onPressed: () {
                              showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(0, 50, 0, 0),
                                items: ['5 km', '10 km', '20 km', '50 km']
                                    .map((String value) {
                                  return PopupMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                    onTap: () {
                                      setState(() {
                                        _selectedDistance = value;
                                      });
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          children: [
                            _buildFilterBox('Diet',
                                    () => _showFilterBottomSheet('Dietary Preferences')),
                            _buildFilterBox('Cuisine',
                                    () => _showFilterBottomSheet('Cuisines')),
                            _buildFilterBox('Time',
                                    () => _showFilterBottomSheet('Time of Day')),
                            _buildFilterBox('Vibes',
                                    () => _showFilterBottomSheet('Atmospheres')),
                            _buildFilterBox('Experience',
                                    () => _showFilterBottomSheet('Entertainment')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showMap)
                DraggableScrollableSheet(
                  controller: _sheetController,
                  initialChildSize: 0.2,
                  minChildSize: 0.2,
                  maxChildSize: 0.8,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 10)
                        ],
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: SizedBox.shrink(),
                      ),
                    );
                  },
                ),
              if (_showFilterResults)
                FutureBuilder<List<RestaurantModel>>(
                  future: homeController.getAllRestaurants().first,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No restaurants found'));
                    }
                    List<RestaurantModel> restaurants = snapshot.data!;
                    if (filterSelectionController
                        .aggregatedFilters.isNotEmpty) {
                      restaurants = restaurants.where((restaurant) {
                        final selectedFiltersLowercase =
                        filterSelectionController
                            .aggregatedFilters
                            .map((filter) => filter.toLowerCase())
                            .toList();
                        return selectedFiltersLowercase.any((filter) {
                          return restaurant.dietaryList
                              .map((e) => e.toLowerCase())
                              .contains(filter) ||
                              restaurant.menuList
                                  .map((e) =>
                                  e.cuisineType.toLowerCase())
                                  .contains(filter) ||
                              restaurant.priceRange
                                  .toLowerCase()
                                  .contains(filter) ||
                              restaurant.atmosphereList
                                  .map((e) => e.toLowerCase())
                                  .contains(filter) ||
                              restaurant
                                  .entertainmentScheduleList
                                  .any((schedule) =>
                                  schedule.eventName
                                      .toLowerCase()
                                      .contains(filter));
                        });
                      }).toList();
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showFilteredRestaurantsBottomSheet(restaurants);
                      setState(() {
                        _showFilterResults = false;
                      });
                    });
                    return SizedBox();
                  },
                ),
              if (!_showMap)
                Container(
                  margin: EdgeInsets.only(top: 120.0),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Showcase.withWidget(
                          height: 200,
                          width: Get.width - 24,
                          key: _categoryKey,
                          container: ShowCaseContainer(
                            width: Get.width - 32,
                            text:
                            "Browse different categories to find what you love!",
                            showcaseContext: context,
                            last: false,
                          ),
                          child: Center(child: _buildCategories()),
                        ),
                        hasStartedShowcase &&
                            !controller.isSpotlightFinish.value
                            ? Showcase.withWidget(
                          height: 200,
                          width: Get.width - 24,
                          key: _trendingKey,
                          container: ShowCaseContainer(
                            width: Get.width - 32,
                            text:
                            "Discover the most popular items right now!",
                            showcaseContext: context,
                            last: false,
                          ),
                          child: trendingSection(),
                        )
                            : _buildTrendingSection(),
                        Showcase.withWidget(
                          height: 200,
                          width: Get.width - 24,
                          key: _featuredCategoryKey,
                          container: ShowCaseContainer(
                            width: Get.width - 32,
                            text:
                            "Featured categories with exclusive offers!",
                            showcaseContext: context,
                            last: false,
                          ),
                          child: _featuredCategory(),
                        ),
                        SizedBox(height: 10),
                        hasStartedShowcase &&
                            !controller.isSpotlightFinish.value
                            ? Showcase.withWidget(
                          height: 200,
                          width: Get.width - 24,
                          key: _nearBySectionKey,
                          container: ShowCaseContainer(
                            width: Get.width - 32,
                            text: "Find amazing places near you!",
                            showcaseContext: context,
                            last: false,
                          ),
                          child: nearBySection(),
                        )
                            : _buildNearBySection(),
                        SizedBox(height: 10),
                        Showcase.withWidget(
                          height: 200,
                          width: Get.width - 24,
                          key: _experienceKey,
                          container: ShowCaseContainer(
                            width: Get.width - 32,
                            text:
                            "Check out unique experiences waiting for you!",
                            showcaseContext: context,
                            last: false,
                          ),
                          child: experienceWidget(),
                        ),
                        Showcase.withWidget(
                          height: 200,
                          width: Get.width - 24,
                          key: _eventsKey,
                          onTargetClick: () {
                            controller.isSpotlightFinish.value = true;
                            controller.update();
                          },
                          container: ShowCaseContainer(
                            width: Get.width - 32,
                            text:
                            "Stay updated with the latest events happening around!",
                            showcaseContext: context,
                            last: true,
                          ),
                          child: eventsWidget(),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterBox(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey),
          ],
        ),
      ),
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
                  fontFamily: 'aftika-regular',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              InkWell(
                onTap: () => Get.to(EventScreen()),
                child: Text(
                  "view all",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
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
        Obx(
              () => eventController.events.isEmpty
              ? SizedBox(
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
                  )))
              : ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: eventController.events.length > 3
                ? 3
                : eventController.events.length,
            itemBuilder: (context, index) {
              final event = eventController.events[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: DaysTile(
                      onTap: () => Get.to(EventDetailsScreen(
                        event: event,
                      )),
                      image: event.imageUrls.first,
                      title: event.eventName,
                      location: event.location,
                      type: event.eventType,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Column experienceWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14, right: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Experience',
                    style: TextStyle(
                      color: AppColors.bottomSheetColor,
                      fontFamily: 'aftika-regular',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Your Vibe Awaits You",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: AppColors.bottomSheetColor,
                      fontFamily: 'aftika-regular',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => Get.to(EntertainmentsScreen()),
                child: Text(
                  "view all",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: StreamBuilder(
            stream: homeController.getEntertainmentRestaurants(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return buildShimmerEffect();
              }
              if (snapshot.hasError) {
                print('Error during stream call ${snapshot.error}');
                return Text('');
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Text('No restaurants found');
              }
              List<RestaurantModel> restaurants = snapshot.data!;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                homeController.initializeSelectors(restaurants);
              });
              return GetBuilder<HomeLocationController>(
                builder: (controller) {
                  return SizedBox(
                    height: 270,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.filteredRestaurants.length,
                      itemBuilder: (context, index) {
                        final item = controller.filteredRestaurants[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                            onTap: () => Get.to(
                                RestaurantDetailScreen(restaurantModel: item)),
                            child: RectangleWidget(
                              boxColor: AppColors.whiteColor,
                              imgHeight: 203,
                              height: 304,
                              width: 230,
                              title: item.resName,
                              description: item.address,
                              resturant_id: item.docID,
                              imagePath: item.logoImage,
                              timetext: '10 AM',
                              percentText: '25%',
                              endTimeText: '9 PM',
                              isFavorite: false.obs,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _featuredCategory() {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: homeController.getFeaturedRestaurantID(),
      builder: (context, featuredIDSnapshot) {
        if (!featuredIDSnapshot.hasData ||
            featuredIDSnapshot.data == null ||
            featuredIDSnapshot.data!.isEmpty) {
          return const SizedBox();
        }
        Map<String, dynamic> data =
        featuredIDSnapshot.data as Map<String, dynamic>;

        return StreamBuilder<RestaurantModel?>(
          stream: homeController
              .getFeaturedRestaurants(restID: data['restaurantID']),
          builder: (context, restaurantSnapshot) {
            if (!restaurantSnapshot.hasData ||
                restaurantSnapshot.data == null) {
              return const SizedBox();
            }

            final restaurant = restaurantSnapshot.data!;

            return Container(
              height: Get.height * 0.45,
              width: Get.width,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 223, 230, 227),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Featured',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      data['description'] ?? '',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'Nunito-Regular',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () {
                        Get.to(RestaurantDetailScreen(
                          restaurantModel: restaurant,
                        ));
                      },
                      child: Container(
                        height: Get.height * 0.3,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Image.network(
                                  restaurant.logoImage,
                                  height: Get.height * 0.175,
                                  width: Get.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 1),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant.resName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.headingTextColor,
                                      fontFamily: 'Nunito-Regular',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 5, right: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      restaurant.specialConditions,
                                      textAlign: TextAlign.justify,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.headingTextColor,
                                        fontFamily: 'Nunito-Regular',
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
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategories() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
            'Explore By Category',
            style: TextStyle(
              color: AppColors.bottomSheetColor,
              fontFamily: 'aftika-regular',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
            'Find food that fits you',
            style: TextStyle(
              color: AppColors.bottomSheetColor,
              fontFamily: 'aftika-regular',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 14),
        SizedBox(
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
                  } else if (category['name'] == 'Experience') {
                    Get.to(EntertainmentsScreen());
                  } else if (category['name'] == 'Events') {
                    Get.to(EventScreen());
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
                        fontSize: 12,
                        color: AppColors.bottomSheetColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'aftika-regular',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ));
  }

  Widget _buildTrendingSection() {
    final HomeLocationController controller =
    Get.put(HomeLocationController());
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: StreamBuilder(
        stream: controller.getTrendingRestaurants(),
        builder:
            (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SizedBox();
          if (snapshot.hasError) {
            print('Error during stream call ${snapshot.error}');
            return Text('');
          }
          if (snapshot.data == null || snapshot.data!.isEmpty)
            return Text('');
          List<RestaurantModel> restaurants = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.initailizedSelectors(
                resaturantsList: restaurants);
          });

          return Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(right: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trending',
                          style: TextStyle(
                            color: AppColors.bottomSheetColor,
                            fontFamily: 'aftika-regular',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Buzzing dishes right now',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: AppColors.bottomSheetColor,
                            fontFamily: 'aftika-regular',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: Get.height * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final item = restaurants[index];
                    return GestureDetector(
                      onTap: () => Get.to(
                          RestaurantDetailScreen(restaurantModel: item)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Container(
                              width: 274,
                              height: 181,
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
                          SizedBox(height: 6),
                          Text(
                            item.resName,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.headingTextColor,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Nunito-Sans',
                            ),
                          ),
                          SizedBox(height: 6),
                          SizedBox(
                            width: Get.width * 0.3,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/location_icon2.png',
                                  height: 16,
                                  width: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "${item.address}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Nunito-Sans',
                                  ),
                                ),
                              ],
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
        },
      ),
    );
  }

  Widget _buildNearBySection() {
    final HomeLocationController controller =
    Get.put(HomeLocationController());
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: StreamBuilder(
        stream: controller.getAllRestaurants(),
        builder:
            (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          if (snapshot.hasError) {
            print('Error during stream call ${snapshot.error}');
            return const Text('');
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Text('');
          }
          List<RestaurantModel> all_restaurants = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.initailizedSelectors(
                resaturantsList: all_restaurants);
          });
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You might like",
                        style: TextStyle(
                          color: AppColors.bottomSheetColor,
                          fontFamily: 'aftika-regular',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Curated picks just for you",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: AppColors.bottomSheetColor,
                          fontFamily: 'aftika-regular',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => Get.to(NearByAll()),
                    child: Text(
                      "view all",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primaryColor,
                        fontFamily: 'Nunito-Regular',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                future: controller.getNearbyRestaurants(
                    all_restaurants, 50, context),
                builder: (context,
                    AsyncSnapshot<List<RestaurantModel>> futureSnapshot) {
                  if (futureSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }
                  if (futureSnapshot.hasError) {
                    return const Text('');
                  }
                  if (!futureSnapshot.hasData ||
                      futureSnapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Restaurants not available in your region',
                        style: TextStyle(
                          fontFamily: 'aftika-regular',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  List<RestaurantModel> restaurants =
                      futureSnapshot.data ?? [];
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: restaurants.length > 2
                        ? 2
                        : restaurants.length,
                    itemBuilder: (context, index) {
                      final item = restaurants[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () => Get.to(RestaurantDetailScreen(
                              restaurantModel: item)),
                          child: RectangleWidget(
                            imgHeight: 169,
                            title: item.resName,
                            description: item.address,
                            resturant_id: item.docID,
                            imagePath: item.logoImage,
                            timetext: '10 AM',
                            percentText: '25%',
                            endTimeText: '9 PM',
                            isFavorite: false.obs,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget nearBySection() {
    List<String> img = [
      'assets/images/event_img5.png',
      'assets/images/event_ing2.png'
    ];
    List<String> nameOfRestaurant = ['ABSteak by Chef', 'Tsuri'];
    List<String> address = ['8500 Beverkt', ' 200 Manathan'];

    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You might like",
                    style: TextStyle(
                      color: AppColors.bottomSheetColor,
                      fontFamily: 'aftika-regular',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "For your best delicious food",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: AppColors.bottomSheetColor,
                      fontFamily: 'aftika-regular',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  "view all",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: Container(
                  width: Get.width,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 82,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.transparent,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(img[index]))),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 140,
                                  child: Text(
                                    nameOfRestaurant[index],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: 'Nunito-Regular',
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 6,
                                )
                              ],
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/location_icon2.png',
                                  height: 16,
                                  width: 16,
                                ),
                                SizedBox(
                                  child: Text(
                                    address[index],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      fontFamily: 'Nunito-Regular',
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget trendingSection() {
    List<String> img = [
      'assets/images/aaa.jpg',
      'assets/images/event_ing2.png'
    ];
    List<String> nameOfRestaurant = ['Cactus Cantina', 'Tsuri'];
    List<String> address = ['Scottside', 'Manathan'];

    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trending',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Places that are popular',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: Get.height * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: img.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Container(
                        width: 274,
                        height: 181,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(img[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      nameOfRestaurant[index],
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.headingTextColor,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Nunito-Sans',
                      ),
                    ),
                    SizedBox(height: 6),
                    SizedBox(
                      width: Get.width * 0.3,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/location_icon2.png',
                            height: 16,
                            width: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            address[index],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Nunito-Sans',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}