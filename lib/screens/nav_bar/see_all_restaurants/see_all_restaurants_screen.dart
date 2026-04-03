import 'dart:developer';

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
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> filterButtonKeys = {};
  final RxMap<String, bool> showFilterDropdowns = <String, bool>{}.obs;

  final Map<String, String> emojiMap = {
    'Date Night': '💕',
    'Hidden Gems': '😶‍🌫️',
    'Trendy & Social': '💃',
    'High Vibe': '🔥',
    'Chill & Cozy': '😌',
    'Live Music': '🎶',
    'Dj Nights': '🎧',
    'Comedy': '🎤',
    'Karaoke': '🎙️',
    'Brunch': '🍳',
    'Outdoor': '🌿',
    'Happy Hour': '🍸',
    'Rooftop': '🌆',
    'Water/Beachside': '🌊',
    'Late Night': '🌃',
    'Show': '🎭',
  };

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

    for (var category in filterCtrl.filterOptions.keys) {
      filterButtonKeys[category] = GlobalKey();
      showFilterDropdowns[category] = false;
    }

    if (controller.userPosition.value == null) {
      controller.fetchUserPosition(context);
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !controller.isFetchingNextBatch.value &&
          !controller.allFetched.value) {
        controller.fetchFilteredRestaurants(isLoadMore: true, targetCount: 10);
      }
    });

    if (auth.currentUser != null) {
      final userId = auth.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorite')
          .snapshots()
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
        },
      );
    } else {
      _fetchFavoriteIds();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fromHome) {
        // Initial fetch handled by controller.applySearchAndFilters() triggered from Home
      } else {
        controller.fetchFilteredRestaurants(isLoadMore: false, targetCount: 15);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dismissKeyboard();
    _searchFocusNode.dispose();
    searchController.dispose();
    _scrollController.dispose();
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

  Widget _buildFilterBar() {
    return Container(
      height: 56,
      color: Colors.white,
      child: Obx(
        () {
          if (filterCtrl.filterOptions.isEmpty) {
            return const SizedBox.shrink();
          }
          return ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            children: filterCtrl.filterOptions.keys.map((category) {
              return GestureDetector(
                key: filterButtonKeys[category],
                onTap: () {
                  showFilterDropdowns[category] =
                      !showFilterDropdowns[category]!;
                  showFilterDropdowns.forEach((key, value) {
                    if (key != category) showFilterDropdowns[key] = false;
                  });
                  showFilterDropdowns.refresh();
                },
                child: Obx(
                  () => Container(
                    height: 40,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: filterCtrl.selectedFilters[category]?.isNotEmpty ??
                              false
                          ? AppColors.primaryColor
                          : Colors.grey.shade100,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category +
                              (filterCtrl.selectedFilters[category]
                                          ?.isNotEmpty ??
                                      false
                                  ? ' (${filterCtrl.selectedFilters[category]?.length})'
                                  : ''),
                          style: TextStyle(
                            color: filterCtrl.selectedFilters[category]
                                        ?.isNotEmpty ??
                                    false
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_drop_down,
                            size: 20,
                            color: filterCtrl.selectedFilters[category]
                                        ?.isNotEmpty ??
                                    false
                                ? Colors.white
                                : Colors.black54),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildDropdownOverlays(BuildContext stackContext) {
    return Obx(() {
      if (filterCtrl.filterOptions.isEmpty) return const SizedBox.shrink();
      return Stack(
        clipBehavior: Clip.none,
        children: filterCtrl.filterOptions.keys.map((category) {
          return Obx(() {
            if (!(showFilterDropdowns[category] ?? false))
              return const SizedBox.shrink();
            final key = filterButtonKeys[category];
            if (key?.currentContext == null) return const SizedBox.shrink();

            final RenderBox? renderBox =
                key?.currentContext?.findRenderObject() as RenderBox?;
            if (renderBox == null) return const SizedBox.shrink();

            final position = renderBox.localToGlobal(Offset.zero);
            final size = renderBox.size;

            final stackRenderBox =
                stackContext.findRenderObject() as RenderBox?;
            if (stackRenderBox == null) return const SizedBox.shrink();

            final stackPosition = stackRenderBox.localToGlobal(Offset.zero);
            final relativeLeft = position.dx - stackPosition.dx;
            final relativeTop = position.dy - stackPosition.dy;

            final optionCount = filterCtrl.filterOptions[category]?.length ?? 0;
            final dropdownHeight = optionCount * 40.0;

            return Positioned(
              top: relativeTop + size.height + 8,
              left: relativeLeft,
              child: InkWell(
                onTap: () {
                  log("tapped the filter dropdown");
                },
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 160,
                    height: dropdownHeight < 190 ? dropdownHeight : 190,
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: (filterCtrl.filterOptions[category] ?? [])
                            .map((option) {
                          return InkWell(
                            onTap: () {
                              filterCtrl.toggleFilter(category, option);
                              showFilterDropdowns[category] = false;
                              showFilterDropdowns.refresh();
                              isLoading.value = true;
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                controller.applySearchAndFilters();
                                isLoading.value = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(emojiMap[option] ?? '',
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(option,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (filterCtrl.selectedFilters[category]
                                          ?.contains(option) ??
                                      false)
                                    const Icon(Icons.check,
                                        color: Colors.green, size: 16),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        }).toList(),
      );
    });
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: searchController,
              focusNode: _searchFocusNode,
              onChanged: (val) {
                controller.searchQuery.value = val;
                controller.applySearchAndFilters();
              },
              decoration: const InputDecoration(
                hintText: 'Search for restaurants',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
          DropdownButtonHideUnderline(
            child: Obx(
              () => DropdownButton2<String>(
                buttonStyleData: const ButtonStyleData(width: 60),
                dropdownStyleData: DropdownStyleData(
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                hint: const Text('miles', style: TextStyle(fontSize: 12)),
                value: controller.selectedDistance.value == 0
                    ? 'All'
                    : '${controller.selectedDistance.value} mi',
                items: controller.distanceOptions
                    .map((ele) => DropdownMenuItem(
                          value: ele,
                          child:
                              Text(ele, style: const TextStyle(fontSize: 12)),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val == 'All') {
                    controller.selectedDistance.value = 0;
                  } else {
                    controller.selectedDistance.value =
                        int.parse(val!.replaceAll(' mi', ''));
                  }
                  controller.applySearchAndFilters();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MODIFIED: Updated build method to use Obx on displayedRestaurants instead of direct StreamBuilder
  // The StreamBuilder is removed; now we rely on the listener in initState for real-time updates from categories
  // Local filters are applied reactively via applyLocalFilters
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Builder(builder: (stackContext) {
            return Stack(
              children: [
                Column(
                  children: [
                    _buildAppBar(),
                    _buildSearchBar(),
                    _buildFilterBar(),
                    Expanded(
                      child: Obx(() {
                        final restaurants = controller.filteredRestaurants;
                        final isInitialLoading =
                            controller.isFetchingNextBatch.value &&
                                restaurants.isEmpty;

                        if (isInitialLoading) {
                          return _buildShimmerGrid();
                        }

                        if (restaurants.isNotEmpty) {
                          return ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: restaurants.length +
                                (controller.allFetched.value ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index < restaurants.length) {
                                return _buildRestaurantCard(restaurants[index]);
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                    strokeWidth: 2,
                                  ),
                                );
                              }
                            },
                          );
                        } else {
                          return _buildNoResults();
                        }
                      }),
                    ),
                  ],
                ),
                Positioned.fill(child: _buildDropdownOverlays(stackContext)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _dismissKeyboard();
              widget.fromHome ? Get.back() : navbarController.jumpToTab(0);
            },
          ),
          Text(
            'All Restaurants',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No restaurants found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(RestaurantModel restaurant) {
    final isBookmarked =
        restaurantCtrl.favoriteIds.contains(restaurant.docID).obs;
    return InkWell(
      onTap: () => _navigateTo(
          () => RestaurantDetailScreen(restaurantModel: restaurant)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
          ),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              restaurant.resName.isNotEmpty
                                  ? restaurant.resName
                                  : 'Unknown Restaurant',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily:
                                    GoogleFonts.plusJakartaSans().fontFamily,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _dismissKeyboard();
                              toggleFavoriteRestaurant(
                                  restaurant.docID, isBookmarked.value);
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
                            controller.operatingHoursCache[restaurant.docID];
                        final isFetching = controller.fetchingOperatingHours
                            .contains(restaurant.docID);
                        final currentDay =
                            DateFormat('EEEE').format(DateTime.now());
                        final timeFilter = filterCtrl.selectedFilters['Time'];

                        if (operatingHours == null ||
                            operatingHours[currentDay] == null) {
                          if (!isFetching) {
                            controller.getOperatingHours(restaurant.docID,
                                triggerFilterUpdate: false);
                          }
                          return Text(
                            isFetching ? 'Loading...' : 'Unavailable',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily:
                                  GoogleFonts.plusJakartaSans().fontFamily,
                              color: const Color.fromRGBO(142, 142, 147, 1),
                            ),
                          );
                        }

                        if (operatingHours.isEmpty) {
                          return Text(
                            'Unavailable',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily:
                                  GoogleFonts.plusJakartaSans().fontFamily,
                              color: const Color.fromRGBO(142, 142, 147, 1),
                            ),
                          );
                        }

                        final dayHours = operatingHours[currentDay]!;
                        // Check if no time filter is selected
                        if (timeFilter == null || timeFilter.isEmpty) {
                          // Use the new method to get current operating hours
                          final hoursText =
                              controller.getDisplayHours(dayHours);
                          final isOpen = controller.isRestaurantOpen(dayHours);
                          return Text(
                            hoursText,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily:
                                  GoogleFonts.plusJakartaSans().fontFamily,
                              color: isOpen
                                  ? Colors.green
                                  : const Color.fromRGBO(142, 142, 147, 1),
                            ),
                          );
                        }

                        // Use selected time slot
                        final timeOfDay = timeFilter.first;
                        final isClosed =
                            dayHours[timeOfDay]?['isClosed'] ?? true;
                        final startTime =
                            dayHours[timeOfDay]?['startTime'] ?? '6:00 PM';
                        final endTime =
                            dayHours[timeOfDay]?['endTime'] ?? '9:00 PM';
                        return Text(
                          isClosed ? 'Closed' : '$startTime–$endTime',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily:
                                GoogleFonts.plusJakartaSans().fontFamily,
                            color: const Color.fromRGBO(142, 142, 147, 1),
                          ),
                        );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                final pos = controller.userPosition.value;
                                if (pos == null) {
                                  return Text(
                                    controller.isFetchingInitialData.value
                                        ? 'Fetching...'
                                        : 'Location disabled',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: GoogleFonts.plusJakartaSans()
                                          .fontFamily,
                                      color: const Color.fromRGBO(
                                          142, 142, 147, 1),
                                    ),
                                  );
                                } else {
                                  double distance = Geolocator.distanceBetween(
                                        pos.latitude,
                                        pos.longitude,
                                        restaurant.latitude,
                                        restaurant.longitude,
                                      ) /
                                      1000;
                                  return Text(
                                    '${distance.toStringAsFixed(1)} km away',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: GoogleFonts.plusJakartaSans()
                                          .fontFamily,
                                      color: const Color.fromRGBO(
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
  }
}
