import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kaistable_website/models/restaurant_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../../home_screen/home_controller/home_location_controller.dart';
import '../controller/search_controller.dart';
import 'discover_controller.dart';

class SavedRestaurantsPage extends StatelessWidget {
  SavedRestaurantsPage({Key? key}) : super(key: key);

  final HomeLocationController controller = Get.find<HomeLocationController>();
  final RestaurantController restaurantCtrl = Get.find<RestaurantController>();

  RxBool refreshToggle = true.obs;

  Future<List<RestaurantModel>> _fetchSavedRestaurants() async {
    List<String> favoriteIds = [];

    if (auth.currentUser != null) {
      // Authenticated user: Fetch from Firestore
      final userId = auth.currentUser!.uid;
      final favoritesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorite')
          .get();

      favoriteIds = favoritesSnapshot.docs.map((doc) => doc.id).toList();
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('favorite_restaurants', favoriteIds);
      restaurantCtrl.favoriteIds.value = favoriteIds;
    } else {
      // Unauthenticated user: Fetch from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      favoriteIds = prefs.getStringList('favorite_restaurants') ?? [];
      restaurantCtrl.favoriteIds.value = favoriteIds;
    }

    if (favoriteIds.isEmpty) {
      return [];
    }

    // Fetch only the saved restaurants from 'restaurants' collection
    final futures = favoriteIds.map((id) =>
        FirebaseFirestore.instance.collection('restaurants').doc(id).get());

    final docs = await Future.wait(futures);
    return docs
        .where((doc) => doc.exists)
        .map((doc) => RestaurantModel.fromDocumentSnapshot(doc))
        .toList();
  }

  Future<void> removeFavoriteRestaurant(String restaurantId) async {
    try {
      if (auth.currentUser != null) {
        // Authenticated user: Delete from Firestore
        final userId = auth.currentUser!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('favorite')
            .doc(restaurantId)
            .delete();
        print('Removed restaurant $restaurantId from Firestore favorites');
      }
      // Unauthenticated user: Update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorite_restaurants') ?? [];
      favoriteIds.remove(restaurantId);
      await prefs.setStringList('favorite_restaurants', favoriteIds);
      print('Removed restaurant $restaurantId from SharedPreferences');
      restaurantCtrl.favoriteIds.value = favoriteIds;

      refreshToggle.toggle();
    } catch (e) {
      print('Error removing favorite restaurant: $e');
      Get.snackbar('Error', 'Failed to remove restaurant: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Center(child: Text('Saved Restaurants')),
        leading: const BackButton(),
      ),
      body: Obx(
        () => FutureBuilder<List<RestaurantModel>>(
          future: refreshToggle.value
              ? _fetchSavedRestaurants()
              : _fetchSavedRestaurants(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmer();
            }
            if (snapshot.hasError) {
              return const Center(
                  child: Text('Error loading saved restaurants'));
            }
            final savedRestaurants = snapshot.data ?? [];

            if (savedRestaurants.isEmpty) {
              return const Center(child: Text('No saved restaurants yet.'));
            }

            return ListView.builder(
              itemCount: savedRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = savedRestaurants[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: Container(
                    height: 84,
                    width: 362,
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 84,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                            ),
                            child: controller.buildImage(
                              restaurant.logoImage.isNotEmpty
                                  ? restaurant.logoImage
                                  : 'assets/images/event_img5.png',
                              width: 120,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
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
                                          fontFamily:
                                              GoogleFonts.plusJakartaSans()
                                                  .fontFamily,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        removeFavoriteRestaurant(
                                            restaurant.docID);
                                      },
                                      child: const Icon(Icons.bookmark_remove,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                                Obx(() {
                                  final operatingHours = controller
                                      .operatingHoursCache[restaurant.docID];
                                  final isFetching = controller
                                      .fetchingOperatingHours
                                      .contains(restaurant.docID);
                                  final currentDay =
                                      DateFormat('EEEE').format(DateTime.now());

                                  if (operatingHours == null ||
                                      operatingHours[currentDay] == null) {
                                    if (!isFetching) {
                                      controller.getOperatingHours(
                                          restaurant.docID,
                                          triggerFilterUpdate: false);
                                    }
                                    return Text(
                                      isFetching ? 'Loading...' : 'Unavailable',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            GoogleFonts.plusJakartaSans()
                                                .fontFamily,
                                        color: Colors.black,
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
                                            GoogleFonts.plusJakartaSans()
                                                .fontFamily,
                                        color: Colors.black,
                                      ),
                                    );
                                  }

                                  final dayHours = operatingHours[currentDay]!;
                                  // Use the new method to get current operating hours
                                  final hoursText =
                                      controller.getDisplayHours(dayHours);
                                  final isOpen =
                                      controller.isRestaurantOpen(dayHours);
                                  return Text(
                                    hoursText,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: GoogleFonts.plusJakartaSans()
                                          .fontFamily,
                                      color:
                                          isOpen ? Colors.green : Colors.black,
                                    ),
                                  );
                                }),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/Icon (1).png',
                                      width: 15,
                                      height: 13,
                                    ),
                                    // Replace the per-restaurant getCurrentLocation call with a shared positionFuture. This calculates distance only if position is available, showing 'Unknown' if location is disabled or error occurred, preventing multiple dialogs.
                                    FutureBuilder<double>(
                                      future: controller.positionFuture
                                          .then((position) {
                                        if (position == null) {
                                          return -1.0; // Sentinel value for disabled/unknown
                                        }
                                        return Geolocator.distanceBetween(
                                              position.latitude,
                                              position.longitude,
                                              restaurant.latitude,
                                              restaurant.longitude,
                                            ) /
                                            1000;
                                      }),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text(
                                            'Calculating...',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  GoogleFonts.plusJakartaSans()
                                                      .fontFamily,
                                              color: const Color.fromRGBO(
                                                  142, 142, 147, 1),
                                            ),
                                          );
                                        }
                                        if (snapshot.hasData &&
                                            snapshot.data == -1.0) {
                                          return Text(
                                            'Unknown',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  GoogleFonts.plusJakartaSans()
                                                      .fontFamily,
                                              color: const Color.fromRGBO(
                                                  142, 142, 147, 1),
                                            ),
                                          );
                                        }
                                        return Text(
                                          snapshot.hasData
                                              ? '${snapshot.data!.toStringAsFixed(1)} km away'
                                              : 'Unknown',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily:
                                                GoogleFonts.plusJakartaSans()
                                                    .fontFamily,
                                            color: const Color.fromRGBO(
                                                142, 142, 147, 1),
                                          ),
                                        );
                                      },
                                    ),
                                    const Spacer(),
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}
