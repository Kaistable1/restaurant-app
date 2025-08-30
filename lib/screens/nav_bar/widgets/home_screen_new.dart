import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kaistable_website/streams/views/streams_view.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';

import '../../../constants/app_colors.dart';
import '../../../models/resaturant_model.dart';
import '../../../streams/model/streams_model.dart';
import '../../home_screen/home_controller/home_location_controller.dart';
import '../controller/search_controller.dart';
import '../full_screen_video/full_screen_video_screen.dart';
import '../restaurant_detail_screens/restaurant_detail_screen.dart';
import 'discover_page.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});
  @override
  _HomeScreenNewState createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> with WidgetsBindingObserver {
  final FilterController filterCtrl = Get.put(FilterController());
  // final VideoController videoCtrl = Get.put(VideoController());
  final HomeLocationController homeLocationCtrl = Get.put(HomeLocationController());
  final RxBool showDistanceOptions = false.obs;
  final RxMap<String, bool> showFilterDropdowns = <String, bool>{}.obs;
  final RxBool isLoading = true.obs;

  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    for (var category in filterCtrl.filterOptions.keys) {
      showFilterDropdowns[category] = false;
      if (!filterCtrl.selectedFilters.containsKey(category)) {
        filterCtrl.selectedFilters[category] = <String>[].obs;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeLocationCtrl.fetchUserPosition(context);  // ADD THIS: Fallback call with context to prompt dialog if needed
      showFilterDropdowns.refresh();
      Future.delayed(const Duration(seconds: 1), () {
        isLoading.value = false;
      });
      // Initialize search and filter application
      homeLocationCtrl.applySearchAndFilters();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // CHANGE: Add this method
    if (state == AppLifecycleState.resumed) {
      Geolocator.isLocationServiceEnabled().then((enabled) {
        if (enabled && homeLocationCtrl.userPosition.value == null) {
          homeLocationCtrl.fetchUserPosition(context);
        }
      });
    }
  }

  Widget _buildShimmer() {
    return SizedBox(
      height: 220,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
            3, (_) => Container(
            width: 200,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          ),
        ),
      ),
    );
  }

  Widget buildRestaurantCard(RestaurantModel restaurant) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.3).clamp(120.0, 160.0);
    final imageHeight = (cardWidth * 0.55).clamp(66.0, 88.0);
    // final textContainerHeight = (cardWidth * 0.35).clamp(50.0, 70.0);

    return GestureDetector(
      onTap: () {
        Get.to(() => RestaurantDetailScreen(restaurantModel: restaurant));
      },
      child: Container(
        width: cardWidth,
        // height: cardWidth * 1.5,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              child: CachedNetworkImage(
                imageUrl: restaurant.logoImage.isNotEmpty ? restaurant.logoImage : 'assets/images/event_img8.png',
                height: imageHeight,
                width: cardWidth,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: imageHeight,
                    width: cardWidth,
                    color: Colors.grey[300],
                  ),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/event_img8.png',
                  height: imageHeight,
                  width: cardWidth,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // height: textContainerHeight,
                width: cardWidth - 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      restaurant.resName.isNotEmpty ? restaurant.resName : 'Unknown Restaurant',
                      style: TextStyle(
                        fontSize: (cardWidth * 0.1).clamp(12.0, 14.0),
                        fontWeight: FontWeight.w700,
                        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    const SizedBox(height: 2),
                    Obx(() {
                      final operatingHours = homeLocationCtrl.operatingHoursCache[restaurant.docID];
                      final isFetching = homeLocationCtrl.fetchingOperatingHours.contains(restaurant.docID);
                      final currentDay = DateFormat('EEEE').format(DateTime.now());
                      final timeFilter = filterCtrl.selectedFilters['Time'];

                      if (operatingHours == null) {
                        if (!isFetching) {
                          homeLocationCtrl.getOperatingHours(restaurant.docID, triggerFilterUpdate: true);
                        }
                        return Text(
                          isFetching ? 'Loading...' : 'Unavailable',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color.fromRGBO(142, 142, 147, 1),
                            fontWeight: FontWeight.w500,
                            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                          ),
                        );
                      }

                      if (operatingHours.isEmpty || operatingHours[currentDay] == null) {
                        return Text(
                          'Unavailable',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color.fromRGBO(142, 142, 147, 1),
                            fontWeight: FontWeight.w500,
                            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                          ),
                        );
                      }

                      final dayHours = operatingHours[currentDay]!;
                      // Check if no time filter is selected
                      if (timeFilter == null || timeFilter.isEmpty) {
                        return Text(
                          homeLocationCtrl.getFullDayHours(dayHours),
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color.fromRGBO(142, 142, 147, 1),
                            fontWeight: FontWeight.w500,
                            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                          ),
                        );
                      }

                      // Use selected time slot
                      final timeOfDay = timeFilter.first;
                      final isClosed = dayHours[timeOfDay]?['isClosed'] ?? true;
                      final startTime = dayHours[timeOfDay]?['startTime'] ?? '6:00 PM';
                      final endTime = dayHours[timeOfDay]?['endTime'] ?? '9:00 PM';
                      return Text(
                        isClosed ? 'Closed' : '$startTime–$endTime',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color.fromRGBO(142, 142, 147, 1),
                          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Icon (1).png',
                          width: (cardWidth * 0.12).clamp(14.0, 16.0),
                          height: (cardWidth * 0.1).clamp(12.0, 14.0),
                        ),
                        const SizedBox(width: 4),
                        Obx(() {
                          if (homeLocationCtrl.isFetchingInitialData.value && homeLocationCtrl.userPosition.value == null) {
                            // REMOVE: homeLocationCtrl.fetchUserPosition(context);  // Removed to prevent multiple calls; handled by init and resume.
                            return Expanded(
                              child: Text(
                                'Fetching location...',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                  color: const Color.fromRGBO(142, 142, 147, 1),
                                ),
                              ),
                            );
                          }

                          if (!homeLocationCtrl.isFetchingInitialData.value && homeLocationCtrl.userPosition.value == null) {
                            return Expanded(
                              child: Text(
                                'Location disabled',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                  color: const Color.fromRGBO(142, 142, 147, 1),
                                ),
                              ),
                            );
                          }

                          double distance = Geolocator.distanceBetween(
                            // CHANGE: homeLocationCtrl.userPosition!.latitude -> homeLocationCtrl.userPosition.value!.latitude
                            homeLocationCtrl.userPosition.value!.latitude,
                            homeLocationCtrl.userPosition.value!.longitude,
                            restaurant.latitude,
                            restaurant.longitude,
                          ) / 1000;
                          return Expanded(
                            child: Text(
                              '${distance.toStringAsFixed(2)} km away',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                color: const Color.fromRGBO(142, 142, 147, 1),
                              ),
                            ),
                          );
                        }),
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
  }

  Widget buildStreamCard(VideoModel video, int index) {
    if (homeLocationCtrl.thumbnailPaths[index] == null && video.url != null && video.url!.isNotEmpty) {
      homeLocationCtrl.generateThumbnail(index, video.url!);
    }

    final restaurant = homeLocationCtrl.findRestaurantForVideo(video);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullVideoScreen(video: video),
          ),
        );
      },
      child: Container(
        width: 173,
        height: 295,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     const CircleAvatar(
            //       radius: 17,
            //       backgroundImage: AssetImage('assets/images/Ellipse 19.png'),
            //     ),
            //     const SizedBox(width: 8),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Emmanuel Sanchez",
            //           style: TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w400,
            //             fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
            //           ),
            //         ),
            //         Text(
            //           'Tourist',
            //           style: TextStyle(
            //             fontSize: 12,
            //             color: const Color.fromRGBO(142, 142, 147, 1),
            //             fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 8),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 191,
                    width: 163,
                    color: Colors.black,
                    child: homeLocationCtrl.thumbnailPaths[index] != null
                        ? Image.file(
                      File(homeLocationCtrl.thumbnailPaths[index]!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.network(
                        'https://via.placeholder.com/163x191',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      ),
                    )
                        : Image.network(
                      'https://via.placeholder.com/163x191',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                    top: 4,
                    left: 4,
                    child: const CircleAvatar(
                            radius: 17,
                            backgroundImage: AssetImage('assets/images/show_logo.png'),
                          ),),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: 163,
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.restaurantName ?? 'Kaistable at Drews',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // FutureBuilder<RestaurantModel?>(
                      //   future: homeLocationCtrl.findRestaurantForVideo(video),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return Text(
                      //         'Loading...',
                      //         style: TextStyle(
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.w500,
                      //           fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                      //           color: const Color.fromRGBO(142, 142, 147, 1),
                      //         ),
                      //       );
                      //     }
                      //     final restaurant = snapshot.data;
                      //     return Text(
                      //       restaurant != null && restaurant.averageRating > 0
                      //           ? '${restaurant.averageRating.toStringAsFixed(1)} stars'
                      //           : '0 stars',
                      //       style: TextStyle(
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.w500,
                      //         fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                      //         color: const Color.fromRGBO(142, 142, 147, 1),
                      //       ),
                      //     );
                      //   },
                      // ),
                      // const SizedBox(width: 8),
                      Image.asset(
                        'assets/images/Icon (1).png',
                        width: 15,
                        height: 13,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child:
                          homeLocationCtrl.userPosition == null ?
                            Text(
                              'Location disabled',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                color: const Color.fromRGBO(142, 142, 147, 1),
                              ),
                            ) :

                          Obx(() =>  // ADD: Wrap in Obx to react to userPosition changes
                          homeLocationCtrl.userPosition.value == null ?
                          Text(
                            'Location disabled',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                              color: const Color.fromRGBO(142, 142, 147, 1),
                            ),
                          ) :

                          FutureBuilder<RestaurantModel?>(
                            future: homeLocationCtrl.findRestaurantForVideo(video),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text(
                                  'Calculating...',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                    color: const Color.fromRGBO(142, 142, 147, 1),
                                  ),
                                );
                              }
                              final restaurant = snapshot.data;
                              if (restaurant == null || (restaurant.latitude == 0.0 && restaurant.longitude == 0.0)) {
                                return Text(
                                  'Unknown distance',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                    color: const Color.fromRGBO(142, 142, 147, 1),
                                  ),
                                );
                              }
                              double distance = Geolocator.distanceBetween(
                                // CHANGE: homeLocationCtrl.userPosition!.latitude -> homeLocationCtrl.userPosition.value!.latitude
                                homeLocationCtrl.userPosition.value!.latitude,
                                homeLocationCtrl.userPosition.value!.longitude,
                                restaurant.latitude,
                                restaurant.longitude,
                              ) / 1000;
                              return Text(
                                '${distance.toStringAsFixed(1)} km away',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                  color: const Color.fromRGBO(142, 142, 147, 1),
                                ),
                              );
                            },
                          ),
                          ),

                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'assets/images/Group (5).png',
                        width: 15,
                        height: 13,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExperienceVibeCard(RestaurantModel restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        //     CircleAvatar(
        //       radius: 20,
        //       backgroundImage: AssetImage('assets/images/Ellipse 19.png'),
        //     ),
        //     // const SizedBox(width: 8),
        //     // Expanded(
        //     //   child: Row(
        //     //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     //     children: [
        //     //       Column(
        //     //         crossAxisAlignment: CrossAxisAlignment.start,
        //     //         children: [
        //     //           Text(
        //     //             "Emmanuel Sanchez",
        //     //             style: TextStyle(
        //     //               fontSize: 14,
        //     //               fontWeight: FontWeight.w400,
        //     //               fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        //     //             ),
        //     //           ),
        //     //           Text(
        //     //             'Tourist',
        //     //             style: TextStyle(
        //     //               fontSize: 12,
        //     //               color: const Color.fromRGBO(142, 142, 147, 1),
        //     //               fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        //     //             ),
        //     //           ),
        //     //         ],
        //     //       ),
        //     //       Text(
        //     //         'Follow',
        //     //         style: TextStyle(
        //     //           color: Colors.green,
        //     //           fontSize: 12,
        //     //           fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        //     //         ),
        //     //       ),
        //     //     ],
        //     //   ),
        //     // ),
        //   ],
        // ),
        // const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Get.to(() => RestaurantDetailScreen(restaurantModel: restaurant));
          },
          child: Stack(
            children: [
              Container(
                width: Get.width - 32,
                height: 300,
                margin: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: homeLocationCtrl.buildImage(
                          restaurant.imagesList.isNotEmpty
                              ? restaurant.imagesList.first
                              : restaurant.logoImage.isNotEmpty
                              ? restaurant.logoImage
                              : 'assets/images/event_img3.png',
                          width: Get.width - 32,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  restaurant.resName.isNotEmpty ? restaurant.resName : 'Unknown Restaurant',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Text(
                                    //   '${restaurant.averageRating.toStringAsFixed(1)} stars',
                                    //   style: TextStyle(
                                    //     fontSize: 12,
                                    //     color: const Color.fromRGBO(142, 142, 147, 1),
                                    //     fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                                    // const SizedBox(width: 15),
                                    Obx(() {
                                      final operatingHours = homeLocationCtrl.operatingHoursCache[restaurant.docID];
                                      final isFetching = homeLocationCtrl.fetchingOperatingHours.contains(restaurant.docID);
                                      final currentDay = DateFormat('EEEE').format(DateTime.now());
                                      final timeFilter = filterCtrl.selectedFilters['Time'];

                                      if (operatingHours == null) {
                                        if (!isFetching) {
                                          homeLocationCtrl.getOperatingHours(restaurant.docID, triggerFilterUpdate: true);
                                        }
                                        return Text(
                                          isFetching ? 'Loading...' : 'Unavailable',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: const Color.fromRGBO(142, 142, 147, 1),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                          ),
                                        );
                                      }

                                      if (operatingHours.isEmpty || operatingHours[currentDay] == null) {
                                        return Text(
                                          'Unavailable',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: const Color.fromRGBO(142, 142, 147, 1),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                          ),
                                        );
                                      }

                                      final dayHours = operatingHours[currentDay]!;
                                      // Check if no time filter is selected
                                      if (timeFilter == null || timeFilter.isEmpty) {
                                        return Text(
                                          homeLocationCtrl.getFullDayHours(dayHours),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: const Color.fromRGBO(142, 142, 147, 1),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                          ),
                                        );
                                      }

                                      // Use selected time slot
                                      final timeOfDay = timeFilter.first;
                                      final isClosed = dayHours[timeOfDay]?['isClosed'] ?? true;
                                      final startTime = dayHours[timeOfDay]?['startTime'] ?? '6:00 PM';
                                      final endTime = dayHours[timeOfDay]?['endTime'] ?? '9:00 PM';
                                      return Text(
                                        isClosed ? 'Closed' : '$startTime–$endTime',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: const Color.fromRGBO(142, 142, 147, 1),
                                          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }),
                                    const SizedBox(width: 15),
                                    Image.asset(
                                      'assets/images/Icon (1).png',
                                      width: 15,
                                      height: 13,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${restaurant.address}, ${restaurant.city}, ${restaurant.country}${restaurant.zipCode == '' ? '' : ', ${restaurant.zipCode}' }',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: const Color.fromRGBO(142, 142, 147, 1),
                                                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Obx(() {
                                            if (homeLocationCtrl.isFetchingInitialData.value && homeLocationCtrl.userPosition.value == null) {
                                              // REMOVE: homeLocationCtrl.fetchUserPosition(context);  // Removed
                                              return Text(
                                                'Fetching ...',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: const Color.fromRGBO(142, 142, 147, 1),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                                ),
                                              );
                                            }

                                            if (!homeLocationCtrl.isFetchingInitialData.value && homeLocationCtrl.userPosition.value == null) {
                                              return Text(
                                                'Location disabled',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: const Color.fromRGBO(142, 142, 147, 1),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                                ),
                                              );
                                            }

                                            if (restaurant.latitude == 0.0 && restaurant.longitude == 0.0) {
                                              return Text(
                                                'Unknown distance',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: const Color.fromRGBO(142, 142, 147, 1),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                                ),
                                              );
                                            }
                                            double distance = Geolocator.distanceBetween(
                                              // CHANGE: homeLocationCtrl.userPosition!.latitude -> homeLocationCtrl.userPosition.value!.latitude
                                              homeLocationCtrl.userPosition.value!.latitude,
                                              homeLocationCtrl.userPosition.value!.longitude,
                                              restaurant.latitude,
                                              restaurant.longitude,
                                            ) / 1000;
                                            return Text(
                                              '', // '${distance.toStringAsFixed(1)} km away',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: const Color.fromRGBO(142, 142, 147, 1),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Image.asset(
                          //   'assets/images/Group (5).png',
                          //   width: 20,
                          //   height: 20,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 4,
                left: 4,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/show_logo.png'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(40.7128, -74.0060),
              zoom: 14,
            ),
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            gestureRecognizers: {
              Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
            },
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: (Get.height - (Platform.isAndroid ? 60 : 70) - 48 - 12 - 36 - 16 - 12) / Get.height, // 0.79,
            snap: true,
            builder: (context, scrollCtrl) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
                ),
                child: Obx(
                      () {
                    if (homeLocationCtrl.isFetchingInitialData.value) {
                      return _buildShimmer();
                    }
                    return ListView(
                      controller: scrollCtrl,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      children: [
                        Center(
                          child: Container(
                            width: 65,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Restaurants in the area',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                            ),
                          ),
                        ),
                        const SizedBox(height: 11),
                        Obx(() {
                          return SizedBox(
                            height: 156,
                            child: isLoading.value
                                ? _buildShimmer()
                                : StreamBuilder<List<RestaurantModel>>(
                              stream: homeLocationCtrl.filteredRestaurantsStream.value,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return _buildShimmer();
                                }
                                if (snapshot.hasError) {
                                  return const Center(child: Text('Error loading restaurants'));
                                }
                                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Center(child: Text('No restaurants match your criteria'));
                                }
                                final restaurants = snapshot.data!.take(4).toList();
                                Future.wait(restaurants.map((restaurant) => homeLocationCtrl.getOperatingHours(restaurant.docID, triggerFilterUpdate: false)));
                                return ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  children: restaurants.map((restaurant) => buildRestaurantCard(restaurant)).toList(),
                                );
                              },
                            ),
                          );
                        }),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => RestaurantsPage(fromHome: true));
                            },
                            child: Text(
                              'See all',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Streams',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() {
                          return SizedBox(
                            height: 252,
                            child: homeLocationCtrl.filteredVideos.isEmpty
                                ? const Center(child: Text('No videos available'))
                                : ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              children: homeLocationCtrl.filteredVideos.asMap().entries.take(4).map((entry) {
                                final index = entry.key;
                                final video = entry.value;
                                return buildStreamCard(video, index);
                              }).toList(),
                            ),
                          );
                        }),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              Get.to(VideosListView(fromHome: true));
                            },
                            child: Text(
                              'See all',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Curated for you',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        StreamBuilder<List<RestaurantModel>>(
                          stream: filterCtrl.selectedFilters.values.any((list) => list.isNotEmpty)
                              ? homeLocationCtrl.getFilteredRestaurants()
                              : homeLocationCtrl.getAllRestaurants(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting || isLoading.value) {
                              return _buildShimmer();
                            }
                            if (snapshot.hasError) {
                              return const Center(child: Text('Error loading restaurants'));
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('No restaurants available'));
                            }
                            final restaurants = snapshot.data!.take(4).toList();
                            Future.wait(restaurants.map((restaurant) => homeLocationCtrl.getOperatingHours(restaurant.docID, triggerFilterUpdate: false)));
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: restaurants
                                    .map((restaurant) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: buildExperienceVibeCard(restaurant),
                                ))
                                    .toList(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              );
            },
          ),

          Positioned(
            top: Platform.isAndroid ? 60 : 70,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, size: 24),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: homeLocationCtrl.searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search for restaurants, events, live music...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                  ),
                                  // onChanged: (value) {
                                  //   homeLocationCtrl.searchQuery.value = value;
                                  //   isLoading.value = true;
                                  //   Future.delayed(const Duration(milliseconds: 500), () {
                                  //     homeLocationCtrl.applySearchAndFilters();
                                  //     isLoading.value = false;
                                  //   });
                                  // },
                                  onSubmitted: (value) {
                                    homeLocationCtrl.searchQuery.value = value;
                                    homeLocationCtrl.applySearchAndFilters();
                                    isLoading.value = true;
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
                                    value: homeLocationCtrl.selectedDistance.value == 0
                                        ? 'All'
                                        : homeLocationCtrl.selectedDistance.value.toString() + ' mi',
                                    items: homeLocationCtrl.distanceOptions
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
                                      if (val == 'All') {
                                        homeLocationCtrl.selectedDistance.value = 0;
                                      } else {
                                        homeLocationCtrl.selectedDistance.value =
                                            int.parse(val!.replaceAll(' mi', ''));
                                      }
                                      isLoading.value = true;
                                      Future.delayed(const Duration(milliseconds: 500), () {
                                        homeLocationCtrl.applySearchAndFilters();
                                        isLoading.value = false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Obx(
                      () => SizedBox(
                    height: showFilterDropdowns.values.contains(true) ? 250 : 36,
                    child: Obx(() {
                      if (filterCtrl.filterOptions.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: filterCtrl.filterOptions.keys.map((category) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showFilterDropdowns[category] = !showFilterDropdowns[category]!;
                                  showFilterDropdowns.forEach((key, value) {
                                    if (key != category) {
                                      showFilterDropdowns[key] = false;
                                    }
                                  });
                                  showFilterDropdowns.refresh();
                                },
                                child: Container(
                                  height: 36,
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Obx(() => Text(
                                        category +
                                            (filterCtrl.selectedFilters[category]?.isNotEmpty ?? false
                                                ? ' (${filterCtrl.selectedFilters[category]?.length ?? 0})'
                                                : ''),
                                        style: const TextStyle(color: Colors.black, fontSize: 18),
                                      )),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.arrow_drop_down, size: 20, color: Colors.black),
                                    ],
                                  ),
                                ),
                              ),
                              Obx(() {
                                if (showFilterDropdowns[category] ?? false) {
                                  final optionCount = filterCtrl.filterOptions[category]?.length ?? 0;
                                  final dropdownHeight = optionCount * 40.0;
                                  return Positioned(
                                    top: 50,
                                    left: 0,
                                    child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: 150,
                                        height: dropdownHeight < 190 ? dropdownHeight : 190,
                                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: (filterCtrl.filterOptions[category] ?? []).map((option) => InkWell(
                                              onTap: () {
                                                final selectedList = filterCtrl.selectedFilters[category] ?? <String>[].obs;
                                                if (selectedList.contains(option)) {
                                                  selectedList.remove(option);
                                                } else {
                                                  selectedList.add(option);
                                                }
                                                filterCtrl.selectedFilters[category] = selectedList;
                                                filterCtrl.selectedFilters.refresh();
                                                showFilterDropdowns[category] = false;
                                                showFilterDropdowns.refresh();
                                                isLoading.value = true;
                                                Future.delayed(const Duration(milliseconds: 500), () {
                                                  homeLocationCtrl.applySearchAndFilters();
                                                  isLoading.value = false;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      option,
                                                      style: const TextStyle(fontSize: 16),
                                                    ),
                                                    if (filterCtrl.selectedFilters[category]?.contains(option) ?? false)
                                                      const Icon(Icons.check, color: Colors.green, size: 16),
                                                  ],
                                                ),
                                              ),
                                            )).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                            ],
                          );
                        }).toList(),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterOptionsSheet extends StatelessWidget {
  final String category;
  const FilterOptionsSheet({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<FilterController>();
    final homeScreenState = Get.find<_HomeScreenNewState>();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() => Column(
              children: (ctrl.filterOptions[category] ?? []).map((option) {
                final isSelected = ctrl.selectedFilters[category]?.contains(option) ?? false;
                return InkWell(
                  onTap: () {
                    final selectedList = ctrl.selectedFilters[category] ?? <String>[].obs;
                    if (isSelected) {
                      selectedList.remove(option);
                    } else {
                      selectedList.add(option);
                    }
                    ctrl.selectedFilters[category] = selectedList;
                    ctrl.selectedFilters.refresh();
                    Navigator.pop(context);
                    homeScreenState.isLoading.value = true;
                    Future.delayed(const Duration(milliseconds: 1500), () {
                      homeScreenState.isLoading.value = false;
                      homeScreenState.setState(() {});
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          option,
                          style: const TextStyle(fontSize: 16),
                        ),
                        if (isSelected) const Icon(Icons.check, color: Colors.green, size: 16),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )),
          ],
        ),
      ),
    );
  }
}