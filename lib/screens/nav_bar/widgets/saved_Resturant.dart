import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:geolocator/geolocator.dart';

import '../../home_screen/home_controller/home_location_controller.dart';
import '../controller/search_controller.dart';
import 'discover_controller.dart';

class SavedRestaurantsPage extends StatelessWidget {
  final HomeLocationController controller = Get.find<HomeLocationController>();
  final RestaurantController restaurantCtrl = Get.find<RestaurantController>();

  SavedRestaurantsPage({Key? key}) : super(key: key);

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
      appBar: AppBar(
        title: const Center(child: Text('Saved Restaurants')),
        leading: const BackButton(),
      ),
      body: Obx(() {
        final favoriteIds = restaurantCtrl.bookmarkedIds.toSet();
        if (favoriteIds.isEmpty) {
          return const Center(child: Text('No saved restaurants yet.'));
        }
        return StreamBuilder<List<RestaurantModel>>(
          stream: controller.getAllRestaurants(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmer();
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading restaurants'));
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text('No restaurants available'));
            }

            final savedRestaurants = snapshot.data!
                .where((restaurant) => favoriteIds.contains(restaurant.docID))
                .toList();

            if (savedRestaurants.isEmpty) {
              return const Center(child: Text('No saved restaurants yet.'));
            }

            return ListView.builder(
              itemCount: savedRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = savedRestaurants[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: Container(
                    height: 83,
                    width: 362,
                    child: Row(
                      children: [
                        ClipRRect(
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
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
                                          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        restaurantCtrl.removeBookmark(restaurant.docID);
                                      },
                                      child: const Icon(Icons.bookmark_remove, color: Colors.red),
                                    ),
                                  ],
                                ),
                                FutureBuilder<Map<String, dynamic>?>(
                                  future: HomeLocationController.getOperatingHours(restaurant.docID),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text(
                                        'Loading...',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                          color: Colors.black,
                                        ),
                                      );
                                    }
                                    final timeOfDay = Get.find<FilterController>()
                                        .selectedFilters['Time']
                                        ?.isNotEmpty ??
                                        false
                                        ? Get.find<FilterController>().selectedFilters['Time']!.first
                                        : 'Dinner';
                                    final operatingHours = snapshot.data;
                                    final isClosed = operatingHours?[timeOfDay]?['isClosed'] ?? true;
                                    return Text(
                                      isClosed ? 'Closed' : operatingHours?[timeOfDay]?['hours'] ?? '6PM-9PM',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                        color: Colors.black,
                                      ),
                                    );
                                  },
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/Icon (1).png',
                                      width: 15,
                                      height: 13,
                                    ),
                                    FutureBuilder<double>(
                                      future: controller.getCurrentLocation(context).then((position) =>
                                      Geolocator.distanceBetween(
                                        position.latitude,
                                        position.longitude,
                                        restaurant.latitude,
                                        restaurant.longitude,
                                      ) /
                                          1000),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Text(
                                            'Calculating...',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                              color: const Color.fromRGBO(142, 142, 147, 1),
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
                                            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                            color: const Color.fromRGBO(142, 142, 147, 1),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 85),
                                    Image.asset(
                                      'assets/images/Group (5).png',
                                      width: 15,
                                      height: 15,
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
        );
      }),
    );
  }
}