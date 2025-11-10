import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../main.dart';
import '../../home_screen/home_controller/home_location_controller.dart';
import '../controller/search_controller.dart';
import '../restaurant_detail_screens/restaurant_detail_screen.dart';
import '../../../constants/app_colors.dart';
import '../../../models/restaurant_model.dart';
import '../widgets/discover_controller.dart';

class SeeAllRestaurantsScreen extends StatefulWidget {
  final bool fromHome;
  const SeeAllRestaurantsScreen({Key? key, required this.fromHome})
      : super(key: key);

  @override
  State<SeeAllRestaurantsScreen> createState() =>
      _SeeAllRestaurantsScreenState();
}

class _SeeAllRestaurantsScreenState extends State<SeeAllRestaurantsScreen>
    with WidgetsBindingObserver {
  final TextEditingController searchController = TextEditingController();
  final HomeLocationController controller = Get.find<HomeLocationController>();
  final RestaurantController restaurantCtrl = Get.find<RestaurantController>();
  final FilterController filterCtrl = Get.find<
      FilterController>(); // NEW: Find the shared FilterController instance to access category filters
  final RxBool isLoading = false.obs;

  final RxList<RestaurantModel> categoryFilteredRestaurants = <RestaurantModel>[]
      .obs; // NEW: RxList to hold the category-filtered restaurants from the stream
  final RxList<RestaurantModel> displayedRestaurants = <RestaurantModel>[]
      .obs; // NEW: RxList to hold the final list after applying local search and distance

  final FocusNode _searchFocusNode = FocusNode();

  void _dismissKeyboard() {
    if (_searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<T?>? _navigateTo<T>(Widget Function() pageBuilder) {
    _dismissKeyboard();
    return Get.to<T>(pageBuilder);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (controller.userPosition.value == null) {
      controller.fetchUserPosition(context);
    }

    // This stream provides restaurants filtered only by categories (Time, Cuisines, Dietary, Vibes, Experience)
    controller.getFilteredRestaurants().listen((list) {
      categoryFilteredRestaurants.value = list;
      applyLocalFilters(); // Apply local search and distance immediately
    });

    // Explanation: For authenticated users, listen to Firestore stream; for unauthenticated, fetch from SharedPreferences.
    if (auth.currentUser != null) {
      final userId = auth.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorite')
          .snapshots()
          // .distinct() // Avoid redundant updates
          .listen(
        (snapshot) async {
          restaurantCtrl.favoriteIds.value =
              snapshot.docs.map((doc) => doc.id).toList();
          final prefs = await SharedPreferences.getInstance();
          prefs.setStringList(
              'favorite_restaurants', restaurantCtrl.favoriteIds);
        },
        onError: (e) {
          print('Error streaming favorite IDs: $e');
          Get.snackbar('Error', 'Failed to load favorites: $e',
              snackPosition: SnackPosition.BOTTOM);
        },
      );
    } else {
      _fetchFavoriteIds();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = true;
      Future.delayed(const Duration(seconds: 1), () {
        applyLocalFilters();
        isLoading.value = false;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dismissKeyboard();
    _searchFocusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _dismissKeyboard();
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Geolocator.isLocationServiceEnabled().then((enabled) {
        if (enabled && controller.userPosition.value == null) {
          controller.fetchUserPosition(context);
        }
      });
    }
  }

  // Explanation: Fetches favorite IDs from SharedPreferences for unauthenticated users.
  Future<void> _fetchFavoriteIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      restaurantCtrl.favoriteIds.value =
          prefs.getStringList('favorite_restaurants') ?? [];
    } catch (e) {
      print('Error fetching favorite IDs: $e');
      Get.snackbar('Error', 'Failed to load favorites: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Explanation: Adds or removes a restaurant from favorites, updating favoriteIds reactively.
  Future<void> toggleFavoriteRestaurant(
      String restaurantId, bool isFavorited) async {
    try {
      if (isFavorited) {
        // Remove from favorites
        if (auth.currentUser != null) {
          final userId = auth.currentUser!.uid;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('favorite')
              .doc(restaurantId)
              .delete();
          print('Removed restaurant $restaurantId from Firestore favorites');
        }
        final prefs = await SharedPreferences.getInstance();
        final favoriteIdsList =
            prefs.getStringList('favorite_restaurants') ?? [];
        favoriteIdsList.remove(restaurantId);
        await prefs.setStringList('favorite_restaurants', favoriteIdsList);
        print('Removed restaurant $restaurantId from SharedPreferences');
        restaurantCtrl.favoriteIds
            .remove(restaurantId); // Update RxList for unauthenticated users
      } else {
        // Add to favorites
        if (auth.currentUser != null) {
          final userId = auth.currentUser!.uid;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('favorite')
              .doc(restaurantId)
              .set({'restaurantID': restaurantId});
          print('Added restaurant $restaurantId to Firestore favorites');
        }
        final prefs = await SharedPreferences.getInstance();
        final favoriteIdsList =
            prefs.getStringList('favorite_restaurants') ?? [];
        if (!favoriteIdsList.contains(restaurantId)) {
          favoriteIdsList.add(restaurantId);
          await prefs.setStringList('favorite_restaurants', favoriteIdsList);
          print('Added restaurant $restaurantId to SharedPreferences');
          restaurantCtrl.favoriteIds
              .add(restaurantId); // Update RxList for unauthenticated users
        }
      }
    } catch (e) {
      print('Error toggling favorite restaurant: $e');
      Get.snackbar('Error', 'Failed to update favorite: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Method to apply local filters (search by name and distance) to the category-filtered list
  // This is called whenever the category stream emits, or when local search/distance changes
  void applyLocalFilters() async {
    var filtered = categoryFilteredRestaurants.toList();

    // Apply search query
    if (searchController.text.isNotEmpty) {
      final query = searchController.text.toLowerCase();
      filtered = filtered
          .where(
              (restaurant) => restaurant.resName.toLowerCase().contains(query))
          .toList();
    }

    // Apply distance filter
    if (controller.selectedDistance.value > 0 &&
        controller.userPosition.value != null) {
      final maxDistanceKm = controller.selectedDistance.value * 1.60934;
      filtered = filtered.where((restaurant) {
        if (restaurant.latitude == 0.0 && restaurant.longitude == 0.0) {
          return false;
        }
        final distance = Geolocator.distanceBetween(
              controller.userPosition.value!.latitude,
              controller.userPosition.value!.longitude,
              restaurant.latitude,
              restaurant.longitude,
            ) /
            1000;
        return distance <= maxDistanceKm;
      }).toList();
    }

    // Sort by distance if user position is available
    if (controller.userPosition.value != null) {
      filtered.sort((a, b) {
        if (a.latitude == 0.0 && a.longitude == 0.0) return 1;
        if (b.latitude == 0.0 && b.longitude == 0.0) return -1;
        final distanceA = Geolocator.distanceBetween(
          controller.userPosition.value!.latitude,
          controller.userPosition.value!.longitude,
          a.latitude,
          a.longitude,
        );
        final distanceB = Geolocator.distanceBetween(
          controller.userPosition.value!.latitude,
          controller.userPosition.value!.longitude,
          b.latitude,
          b.longitude,
        );
        return distanceA.compareTo(distanceB);
      });
    }

    // Pre-fetch operating hours for all filtered restaurants
    await Future.wait(filtered.map((restaurant) {
      if (!controller.operatingHoursCache.containsKey(restaurant.docID)) {
        return controller.getOperatingHours(restaurant.docID,
            triggerFilterUpdate: false);
      }
      return Future.value();
    }));

    displayedRestaurants.value = filtered;
  }

  // MODIFIED: Updated _buildSearchBar to trigger applyLocalFilters on submit
  Widget _buildSearchBar() {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              spreadRadius: 0,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search for restaurants',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
                onSubmitted: (value) {
                  _dismissKeyboard();
                  isLoading.value = true; // Show loading during "processing"
                  applyLocalFilters();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    isLoading.value = false;
                  });
                },
              ),
            ),
            DropdownButtonHideUnderline(
              child: Obx(
                () => DropdownButton2<String>(
                  buttonStyleData: ButtonStyleData(
                    width: 55,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    width: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  hint: Text(
                    'miles',
                    style: const TextStyle(fontSize: 14),
                  ),
                  value: controller.selectedDistance.value == 0
                      ? 'All'
                      : controller.selectedDistance.value.toString() + ' mi',
                  items: controller.distanceOptions
                      .map((ele) => DropdownMenuItem(
                            value: ele,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                ele,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (val) {
                    _dismissKeyboard();
                    if (val == 'All') {
                      controller.selectedDistance.value = 0;
                    } else {
                      controller.selectedDistance.value =
                          int.parse(val!.replaceAll(' mi', ''));
                    }
                    isLoading.value = true; // Show loading during "processing"
                    applyLocalFilters();
                    Future.delayed(const Duration(milliseconds: 500), () {
                      isLoading.value = false;
                    });
                    controller.applySearchAndFilters();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 83,
          width: 362,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9.0),
            border: Border.all(color: Colors.grey[300]!),
          ),
        ),
      ),
    );
  }

  // MODIFIED: Updated build method to use Obx on displayedRestaurants instead of direct StreamBuilder
  // The StreamBuilder is removed; now we rely on the listener in initState for real-time updates from categories
  // Local filters are applied reactively via applyLocalFilters
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          'Restaurants in the area',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            _dismissKeyboard();
            widget.fromHome ? Get.back() : navbarController.jumpToTab(0);
          },
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _dismissKeyboard,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildSearchBar(),
            ),
            const SizedBox(height: 18.0),
            Expanded(
              child: Obx(() {
              if (isLoading.value) {
                return _buildShimmer();
              }
              if (displayedRestaurants.isEmpty) {
                return const Center(child: Text('No restaurants available'));
              }

              final restaurants = displayedRestaurants;
              return Obx(() {
                return ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];

                    return Obx(
                      () {
                        final isBookmarked = restaurantCtrl.favoriteIds
                            .contains(restaurant.docID)
                            .obs;
                        return GestureDetector(
                          onTap: () {
                            _navigateTo(() => RestaurantDetailScreen(
                                restaurantModel: restaurant));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                              ),
                              border: Border.all(color: AppColors.borderColor),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 16,
                                    spreadRadius: 0,
                                    offset: Offset(0, 4))
                              ],
                            ),
                            child: SizedBox(
                              height: 84,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    clipBehavior: Clip.hardEdge,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: controller.buildImage(
                                      restaurant.logoImage.isNotEmpty
                                          ? restaurant.logoImage
                                          : 'assets/images/event_img5.png',
                                      width: 124,
                                      height: 84,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  restaurant.resName.isNotEmpty
                                                      ? restaurant.resName
                                                      : 'Unknown Restaurant',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: GoogleFonts
                                                            .plusJakartaSans()
                                                        .fontFamily,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _dismissKeyboard();
                                                  toggleFavoriteRestaurant(
                                                      restaurant.docID,
                                                      isBookmarked.value);
                                                  isBookmarked.toggle();
                                                },
                                                child: Obx(
                                                  () => Icon(
                                                    isBookmarked.value
                                                        ? Icons.bookmark
                                                        : Icons.bookmark_border,
                                                    color: isBookmarked.value
                                                        ? Colors.green
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Obx(() {
                                            final operatingHours =
                                                controller.operatingHoursCache[
                                                    restaurant.docID];
                                            final isFetching = controller
                                                .fetchingOperatingHours
                                                .contains(restaurant.docID);
                                            final currentDay =
                                                DateFormat('EEEE')
                                                    .format(DateTime.now());
                                            final timeFilter = filterCtrl
                                                .selectedFilters['Time'];

                                            if (operatingHours == null ||
                                                operatingHours[currentDay] ==
                                                    null) {
                                              if (!isFetching) {
                                                controller.getOperatingHours(
                                                    restaurant.docID,
                                                    triggerFilterUpdate: false);
                                              }
                                              return Text(
                                                isFetching
                                                    ? 'Loading...'
                                                    : 'Unavailable',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: GoogleFonts
                                                          .plusJakartaSans()
                                                      .fontFamily,
                                                  color: const Color.fromRGBO(
                                                      142, 142, 147, 1),
                                                ),
                                              );
                                            }

                                            if (operatingHours.isEmpty) {
                                              return Text(
                                                'Unavailable',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: GoogleFonts
                                                          .plusJakartaSans()
                                                      .fontFamily,
                                                  color: const Color.fromRGBO(
                                                      142, 142, 147, 1),
                                                ),
                                              );
                                            }

                                            final dayHours =
                                                operatingHours[currentDay]!;
                                            // Check if no time filter is selected
                                            if (timeFilter == null ||
                                                timeFilter.isEmpty) {
                                              // Use the new method to get current operating hours
                                              final hoursText = controller
                                                  .getDisplayHours(dayHours);
                                              final isOpen = controller
                                                  .isRestaurantOpen(dayHours);
                                              return Text(
                                                hoursText,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: GoogleFonts
                                                          .plusJakartaSans()
                                                      .fontFamily,
                                                  color: isOpen
                                                      ? Colors.green
                                                      : const Color.fromRGBO(
                                                          142, 142, 147, 1),
                                                ),
                                              );
                                            }

                                            // Use selected time slot
                                            final timeOfDay = timeFilter.first;
                                            final isClosed = dayHours[timeOfDay]
                                                    ?['isClosed'] ??
                                                true;
                                            final startTime =
                                                dayHours[timeOfDay]
                                                        ?['startTime'] ??
                                                    '6:00 PM';
                                            final endTime = dayHours[timeOfDay]
                                                    ?['endTime'] ??
                                                '9:00 PM';
                                            return Text(
                                              isClosed
                                                  ? 'Closed'
                                                  : '$startTime–$endTime',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: GoogleFonts
                                                        .plusJakartaSans()
                                                    .fontFamily,
                                                color: const Color.fromRGBO(
                                                    142, 142, 147, 1),
                                              ),
                                            );
                                          }),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/Icon (1).png',
                                                    width: 15,
                                                    height: 13,
                                                  ),
                                                  // Replace the per-restaurant getCurrentLocation call with a shared positionFuture. This calculates distance only if position is available, showing 'Unknown' if location is disabled or error occurred, preventing multiple dialogs.
                                                  Obx(() {
                                                    final pos = controller
                                                        .userPosition.value;
                                                    if (pos == null) {
                                                      return Text(
                                                        controller
                                                                .isFetchingInitialData
                                                                .value
                                                            ? 'Fetching...'
                                                            : 'Location disabled',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: GoogleFonts
                                                                  .plusJakartaSans()
                                                              .fontFamily,
                                                          color: const Color
                                                              .fromRGBO(
                                                              142, 142, 147, 1),
                                                        ),
                                                      );
                                                    } else {
                                                      double distance = Geolocator
                                                              .distanceBetween(
                                                            pos.latitude,
                                                            pos.longitude,
                                                            restaurant.latitude,
                                                            restaurant
                                                                .longitude,
                                                          ) /
                                                          1000;
                                                      return Text(
                                                        '${distance.toStringAsFixed(1)} km away',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: GoogleFonts
                                                                  .plusJakartaSans()
                                                              .fontFamily,
                                                          color: const Color
                                                              .fromRGBO(
                                                              142, 142, 147, 1),
                                                        ),
                                                      );
                                                    }
                                                  }),
                                                  const SizedBox(width: 24),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/Group (5).png',
                                                    width: 15,
                                                    height: 15,
                                                  ),
                                                  const SizedBox(width: 4),
                                                ],
                                              ),
                                            ],
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
                    );
                  },
                );
              });
            }),
          ),
        ],
      ),
    ),
  );
  }
}
