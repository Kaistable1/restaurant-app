import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/app_colors.dart';
import '../../../main.dart';
import '../../../models/discover_list_model.dart';
import '../../home_screen/home_controller/home_location_controller.dart';
import '../restaurant_detail_screens/restaurant_detail_screen.dart';
import '../widgets/discover_controller.dart';
import 'controller/discover_list_details_controller.dart';

class DiscoverListDetailScreen extends StatefulWidget {
  final DiscoverListModel discoverListModel;

  DiscoverListDetailScreen({Key? key, required this.discoverListModel})
      : super(key: key);

  @override
  State<DiscoverListDetailScreen> createState() =>
      _DiscoverListDetailScreenState();
}

class _DiscoverListDetailScreenState extends State<DiscoverListDetailScreen>
    with WidgetsBindingObserver {
  final DiscoverListDetailsController listDetailsController =
      Get.put(DiscoverListDetailsController());
  final HomeLocationController controller = Get.find<HomeLocationController>();
  final RestaurantController restaurantCtrl = Get.find<RestaurantController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    if (controller.userPosition.value == null) {
      controller.fetchUserPosition(context);
    }

    listDetailsController
        .loadSelectedRestaurants(widget.discoverListModel.restaurantIdsList);

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
  }

  // Fetches favorite IDs from SharedPreferences for unauthenticated users.
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

  // Adds or removes a restaurant from favorites, updating favoriteIds reactively.
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          "Discover What's New",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.discoverListModel.image.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  widget.discoverListModel.image,
                  height: 146,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 146,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported,
                        color: Colors.grey),
                  ),
                ),
              )
            else
              Container(
                height: 146,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported,
                    color: Colors.grey, size: 50),
              ),
            const SizedBox(height: 16),
            Text(widget.discoverListModel.name,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily)),
            const SizedBox(height: 16),
            Text('By ${widget.discoverListModel.by}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily)),
            const SizedBox(height: 16),
            Text(widget.discoverListModel.description,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily)),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => listDetailsController.gettingRestaurants.value
                    ? Center(
                        child: SizedBox(
                          height: 32,
                          width: 32,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount:
                            listDetailsController.selectedRestaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant =
                              listDetailsController.selectedRestaurants[index];

                          return Obx(
                            () {
                              final isBookmarked = restaurantCtrl.favoriteIds
                                  .contains(restaurant.docID)
                                  .obs;
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => RestaurantDetailScreen(
                                      restaurantModel: restaurant));
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                    ),
                                    border: Border.all(
                                        color: AppColors.borderColor),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 16,
                                          spreadRadius: 0,
                                          offset: Offset(0, 4))
                                    ],
                                  ),
                                  child: SizedBox(
                                    height: 94,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 124,
                                          height: 94,
                                          child: ClipRRect(
                                            clipBehavior: Clip.hardEdge,
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: controller.buildImage(
                                              restaurant.logoImage.isNotEmpty
                                                  ? restaurant.logoImage
                                                  : 'assets/images/event_img5.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        restaurant.resName
                                                                .isNotEmpty
                                                            ? restaurant.resName
                                                            : 'Unknown Restaurant',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily: GoogleFonts
                                                                  .plusJakartaSans()
                                                              .fontFamily,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        toggleFavoriteRestaurant(
                                                            restaurant.docID,
                                                            isBookmarked.value);
                                                        isBookmarked.toggle();
                                                      },
                                                      child: Obx(
                                                        () => Icon(
                                                          isBookmarked.value
                                                              ? Icons.bookmark
                                                              : Icons
                                                                  .bookmark_border,
                                                          color:
                                                              isBookmarked.value
                                                                  ? Colors.green
                                                                  : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Obx(() {
                                                  final operatingHours = controller
                                                          .operatingHoursCache[
                                                      restaurant.docID];
                                                  final isFetching = controller
                                                      .fetchingOperatingHours
                                                      .contains(
                                                          restaurant.docID);
                                                  final currentDay =
                                                      DateFormat('EEEE').format(
                                                          DateTime.now());
                                                  // final timeFilter = filterCtrl.selectedFilters['Time'];

                                                  if (operatingHours == null ||
                                                      operatingHours[
                                                              currentDay] ==
                                                          null) {
                                                    if (!isFetching) {
                                                      controller
                                                          .getOperatingHours(
                                                              restaurant.docID,
                                                              triggerFilterUpdate:
                                                                  false);
                                                    }
                                                    return Text(
                                                      isFetching
                                                          ? 'Loading...'
                                                          : 'Unavailable',
                                                      style: TextStyle(
                                                        fontSize: 14,
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

                                                  if (operatingHours.isEmpty) {
                                                    return Text(
                                                      'Unavailable',
                                                      style: TextStyle(
                                                        fontSize: 14,
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

                                                  final dayHours =
                                                      operatingHours[
                                                          currentDay]!;
                                                  // Use the new method to get current operating hours
                                                  final hoursText = controller
                                                      .getDisplayHours(
                                                          dayHours);
                                                  final isOpen = controller
                                                      .isRestaurantOpen(
                                                          dayHours);
                                                  return Text(
                                                    hoursText,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: GoogleFonts
                                                              .plusJakartaSans()
                                                          .fontFamily,
                                                      color: isOpen
                                                          ? Colors.green
                                                          : const Color
                                                              .fromRGBO(
                                                              142, 142, 147, 1),
                                                    ),
                                                  );

                                                  // // Use selected time slot
                                                  // final timeOfDay = timeFilter.first;
                                                  // final isClosed = dayHours[timeOfDay]?['isClosed'] ?? true;
                                                  // final startTime = dayHours[timeOfDay]?['startTime'] ?? '6:00 PM';
                                                  // final endTime = dayHours[timeOfDay]?['endTime'] ?? '9:00 PM';
                                                  // return Text(
                                                  //   isClosed ? 'Closed' : '$startTime–$endTime',
                                                  //   style: TextStyle(
                                                  //     fontSize: 12,
                                                  //     fontWeight: FontWeight.w500,
                                                  //     fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                                  //     color: const Color.fromRGBO(142, 142, 147, 1),
                                                  //   ),
                                                  // );
                                                }),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/Icon (1).png',
                                                          width: 17,
                                                          height: 15,
                                                        ),
                                                        // Replace the per-restaurant getCurrentLocation call with a shared positionFuture. This calculates distance only if position is available, showing 'Unknown' if location is disabled or error occurred, preventing multiple dialogs.
                                                        Obx(() {
                                                          final pos = controller
                                                              .userPosition
                                                              .value;
                                                          if (pos == null) {
                                                            return Text(
                                                              controller
                                                                      .isFetchingInitialData
                                                                      .value
                                                                  ? 'Fetching...'
                                                                  : 'Location disabled',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily: GoogleFonts
                                                                        .plusJakartaSans()
                                                                    .fontFamily,
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    142,
                                                                    142,
                                                                    147,
                                                                    1),
                                                              ),
                                                            );
                                                          } else {
                                                            double distance =
                                                                Geolocator
                                                                        .distanceBetween(
                                                                      pos.latitude,
                                                                      pos.longitude,
                                                                      restaurant
                                                                          .latitude,
                                                                      restaurant
                                                                          .longitude,
                                                                    ) /
                                                                    1000;
                                                            return Text(
                                                              '${distance.toStringAsFixed(1)} km away',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily: GoogleFonts
                                                                        .plusJakartaSans()
                                                                    .fontFamily,
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    142,
                                                                    142,
                                                                    147,
                                                                    1),
                                                              ),
                                                            );
                                                          }
                                                        }),
                                                        const SizedBox(
                                                            width: 24),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/Group (5).png',
                                                          width: 15,
                                                          height: 15,
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
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
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
