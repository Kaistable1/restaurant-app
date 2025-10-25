import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart'
    as gmcluster;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kaistable_website/screens/events/all_events_screen.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/custom_button.dart';
import 'package:kaistable_website/streams/views/streams_view.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';

import '../../../constants/app_colors.dart';
import '../../../models/restaurant_model.dart';
import '../../../streams/model/streams_model.dart';
import '../../home_screen/home_controller/home_location_controller.dart';
import '../controller/search_controller.dart';
import '../full_screen_video/full_screen_video_screen.dart';
import '../restaurant_detail_screens/restaurant_detail_screen.dart';
import '../see_all_restaurants/see_all_restaurants_screen.dart';
import 'discover_page.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});
  @override
  _HomeScreenNewState createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew>
    with WidgetsBindingObserver {
  final FilterController filterCtrl = Get.put(FilterController());
  final HomeLocationController homeLocationCtrl =
      Get.put(HomeLocationController());
  final RxBool showDistanceOptions = false.obs;
  final RxMap<String, bool> showFilterDropdowns = <String, bool>{}.obs;
  final RxBool isLoading = true.obs;

  // Cache for the restaurant list to prevent reloading
  final RxList<RestaurantModel> cachedRestaurants = <RestaurantModel>[].obs;

  late gmcluster.ClusterManager _manager; // Cluster manager
  Set<Marker> _markers = {};

  GoogleMapController? _mapController;

  // Debounce timer for search
  Timer? _searchDebounce;

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  // StreamSubscription to manage the listener for filtered restaurants
  StreamSubscription<List<RestaurantModel>>? _filteredSub;

  // Emoji mappings for filter options
  final Map<String, String> emojiMap = {
    // Vibes
    'Date Night': '💕',
    'Hidden Gems': '😶‍🌫️',
    'Trendy & Social': '💃',
    'High Vibe': '🔥',
    'Chill & Cozy': '😌',
    // Entertainment
    'Live Music': '🎶',
    'Dj Nights': '🎧',
    'Comedy': '🎤',
    'Karaoke': '🎙️',
    // Experiences
    'Brunch': '🍳',
    'Outdoor': '🌿',
    'Happy Hour': '🍸',
    'Rooftop': '🌆',
    'Water/Beachside': '🌊',
    'Late Night': '🌃',
    'Show': '🎭',
  };

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

    _manager = _initClusterManager(); // Initialize cluster manager

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeLocationCtrl.fetchUserPosition(
          context); // ADD THIS: Fallback call with context to prompt dialog if needed
      showFilterDropdowns.refresh();
      Future.delayed(const Duration(seconds: 1), () {
        isLoading.value = false;
      });
      // Initialize search and filter application
      homeLocationCtrl.applySearchAndFilters();

      // Use GetX 'ever' to reactively listen for changes to the filteredRestaurantsStream Rx variable.
      ever(homeLocationCtrl.filteredRestaurantsStream,
          (Stream<List<RestaurantModel>> newStream) {
        _filteredSub?.cancel();
        _filteredSub = newStream.listen((list) {
          final items = list
              .where((r) => r.latitude != 0.0 && r.longitude != 0.0)
              .toList();
          _manager.setItems(items);
          // Update cachedRestaurants only when new data is received
          cachedRestaurants.assignAll(items);

          // Prefetch operating hours for the first 4 visible restaurants
          Future.wait(items.take(4).map((restaurant) =>
              homeLocationCtrl.getOperatingHours(restaurant.docID,
                  triggerFilterUpdate: false)));
        });
      });

      // listener to userPosition to update map camera and re-sort
      homeLocationCtrl.userPosition.listen((position) {
        if (position != null && _mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 14,
              ),
            ),
          );
          homeLocationCtrl
              .applySearchAndFilters(); // Re-apply filters to re-sort by new distance
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapController?.dispose();
    _filteredSub?.cancel(); // Cancel the subscription to prevent memory leaks
    _customInfoWindowController.dispose();
    _searchDebounce?.cancel(); // Cancel the debounce timer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Geolocator.isLocationServiceEnabled().then((enabled) {
        if (enabled && homeLocationCtrl.userPosition.value == null) {
          homeLocationCtrl.fetchUserPosition(context);
        }
      });
    }
  }

  // Initialize cluster manager
  gmcluster.ClusterManager _initClusterManager() {
    return gmcluster.ClusterManager<RestaurantModel>(
      const [], // Initial empty list
      _updateMarkers,
      markerBuilder: _markerBuilder,
      levels: const [1, 4.25, 6.75, 8.25, 11.0, 12.0, 13.0, 14.0],
      extraPercent: 0.2,
      stopClusteringZoom: 15.0,
    );
  }

  // Update markers from cluster manager
  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      _markers = markers;
    });
  }

  // Custom marker builder for clusters/individuals
  Future<Marker> _markerBuilder(dynamic cluster) async {
    final gmcluster.Cluster<RestaurantModel> typedCluster =
        cluster as gmcluster.Cluster<RestaurantModel>;
    return Marker(
      markerId: MarkerId(typedCluster.getId()),
      position: typedCluster.location,
      icon: typedCluster.isMultiple
          ? await _getMarkerBitmap(125, text: typedCluster.count.toString())
          : BitmapDescriptor.defaultMarker,
      onTap: typedCluster.isMultiple
          ? null
          : () {
              _customInfoWindowController.addInfoWindow!(
                _buildCustomInfoWindow(typedCluster.items.first),
                typedCluster.location,
              );
            },
    );
  }

  // Method to build the custom info window widget
  Widget _buildCustomInfoWindow(RestaurantModel restaurant) {
    // Combine all relevant filter lists and get corresponding emojis
    final allFilters = [
      ...restaurant.vibesList,
      ...restaurant.entertainmentList,
      ...restaurant.experiencesList,
    ];
    final emojiList = allFilters
        .where((filter) => emojiMap.containsKey(filter))
        .map((filter) => emojiMap[filter]!)
        .toList();

    return GestureDetector(
      onTap: () {
        Get.to(() => RestaurantDetailScreen(restaurantModel: restaurant));
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              restaurant.resName.isNotEmpty
                  ? restaurant.resName
                  : 'Unknown Restaurant',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (emojiList.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: emojiList
                    .map((emoji) => Text(
                          emoji,
                          style: const TextStyle(fontSize: 17),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              'Tap for details',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Generate bitmap for markers/clusters
  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3 + 1,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset((size / 2) - painter.width / 2, (size / 2) - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
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
            3,
            (_) => Container(
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

    return GestureDetector(
      onTap: () {
        Get.to(() => RestaurantDetailScreen(restaurantModel: restaurant));
      },
      child: Container(
        width: cardWidth,
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
                imageUrl: restaurant.logoImage.isNotEmpty
                    ? restaurant.logoImage
                    : 'assets/images/event_img8.png',
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
                width: cardWidth - 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      restaurant.resName.isNotEmpty
                          ? restaurant.resName
                          : 'Unknown Restaurant',
                      style: TextStyle(
                        fontSize: (cardWidth * 0.1).clamp(13.0, 15.0),
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
                      final operatingHours = homeLocationCtrl
                          .operatingHoursCache[restaurant.docID];
                      final isFetching = homeLocationCtrl.fetchingOperatingHours
                          .contains(restaurant.docID);
                      final currentDay =
                          DateFormat('EEEE').format(DateTime.now());
                      final timeFilter = filterCtrl.selectedFilters['Time'];

                      if (operatingHours == null) {
                        return Text(
                          isFetching ? 'Loading...' : 'Unavailable',
                          style: TextStyle(
                            fontSize: 13,
                            color: const Color.fromRGBO(142, 142, 147, 1),
                            fontWeight: FontWeight.w500,
                            fontFamily:
                                GoogleFonts.plusJakartaSans().fontFamily,
                          ),
                        );
                      }

                      if (operatingHours.isEmpty ||
                          operatingHours[currentDay] == null) {
                        return Text(
                          'Unavailable',
                          style: TextStyle(
                            fontSize: 13,
                            color: const Color.fromRGBO(142, 142, 147, 1),
                            fontWeight: FontWeight.w500,
                            fontFamily:
                                GoogleFonts.plusJakartaSans().fontFamily,
                          ),
                        );
                      }

                      final dayHours = operatingHours[currentDay]!;
                      if (timeFilter == null || timeFilter.isEmpty) {
                        // Use the new method to get current operating hours
                        final hoursText =
                            homeLocationCtrl.getDisplayHours(dayHours);
                        final isOpen =
                            homeLocationCtrl.isRestaurantOpen(dayHours);
                        return Text(
                          hoursText,
                          style: TextStyle(
                            fontSize: 13,
                            color: isOpen
                                ? Colors.green
                                : const Color.fromRGBO(142, 142, 147, 1),
                            fontWeight: FontWeight.w500,
                            fontFamily:
                                GoogleFonts.plusJakartaSans().fontFamily,
                          ),
                        );
                      }

                      final timeOfDay = timeFilter.first;
                      final isClosed = dayHours[timeOfDay]?['isClosed'] ?? true;
                      final startTime =
                          dayHours[timeOfDay]?['startTime'] ?? '6:00 PM';
                      final endTime =
                          dayHours[timeOfDay]?['endTime'] ?? '9:00 PM';
                      return Text(
                        isClosed ? 'Closed' : '$startTime–$endTime',
                        style: TextStyle(
                          fontSize: 13,
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
                          if (homeLocationCtrl.isFetchingInitialData.value &&
                              homeLocationCtrl.userPosition.value == null) {
                            return Expanded(
                              child: Text(
                                'Fetching location...',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily:
                                      GoogleFonts.plusJakartaSans().fontFamily,
                                  color: const Color.fromRGBO(142, 142, 147, 1),
                                ),
                              ),
                            );
                          }

                          if (!homeLocationCtrl.isFetchingInitialData.value &&
                              homeLocationCtrl.userPosition.value == null) {
                            return Expanded(
                              child: Text(
                                'Location disabled',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily:
                                      GoogleFonts.plusJakartaSans().fontFamily,
                                  color: const Color.fromRGBO(142, 142, 147, 1),
                                ),
                              ),
                            );
                          }

                          double distance = Geolocator.distanceBetween(
                                homeLocationCtrl.userPosition.value!.latitude,
                                homeLocationCtrl.userPosition.value!.longitude,
                                restaurant.latitude,
                                restaurant.longitude,
                              ) /
                              1000;
                          return Expanded(
                            child: Text(
                              '${distance.toStringAsFixed(2)} km away',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily:
                                    GoogleFonts.plusJakartaSans().fontFamily,
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
    if (homeLocationCtrl.thumbnailPaths[index] == null &&
        video.url != null &&
        video.url!.isNotEmpty) {
      homeLocationCtrl.generateThumbnail(index, video.url!);
    }

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
        width: 163,
        height: 295,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                            errorBuilder: (context, error, stackTrace) =>
                                Image.network(
                              'https://via.placeholder.com/163x191',
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image,
                                    size: 50, color: Colors.grey),
                              ),
                            ),
                          )
                        : Image.network(
                            'https://via.placeholder.com/163x191',
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image,
                                  size: 50, color: Colors.grey),
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
                  ),
                ),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/Icon (1).png',
                        width: 15,
                        height: 13,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: homeLocationCtrl.userPosition == null
                            ? Text(
                                'Location disabled',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily:
                                      GoogleFonts.plusJakartaSans().fontFamily,
                                  color: const Color.fromRGBO(142, 142, 147, 1),
                                ),
                              )
                            : Obx(
                                () => homeLocationCtrl.userPosition.value ==
                                        null
                                    ? Text(
                                        'Location disabled',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          fontFamily:
                                              GoogleFonts.plusJakartaSans()
                                                  .fontFamily,
                                          color: const Color.fromRGBO(
                                              142, 142, 147, 1),
                                        ),
                                      )
                                    : FutureBuilder<RestaurantModel?>(
                                        future: homeLocationCtrl
                                            .findRestaurantForVideo(video),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Text(
                                              'Calculating...',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: GoogleFonts
                                                        .plusJakartaSans()
                                                    .fontFamily,
                                                color: const Color.fromRGBO(
                                                    142, 142, 147, 1),
                                              ),
                                            );
                                          }
                                          final restaurant = snapshot.data;
                                          if (restaurant == null ||
                                              (restaurant.latitude == 0.0 &&
                                                  restaurant.longitude ==
                                                      0.0)) {
                                            return Text(
                                              'Unknown distance',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: GoogleFonts
                                                        .plusJakartaSans()
                                                    .fontFamily,
                                                color: const Color.fromRGBO(
                                                    142, 142, 147, 1),
                                              ),
                                            );
                                          }
                                          double distance =
                                              Geolocator.distanceBetween(
                                                    homeLocationCtrl
                                                        .userPosition
                                                        .value!
                                                        .latitude,
                                                    homeLocationCtrl
                                                        .userPosition
                                                        .value!
                                                        .longitude,
                                                    restaurant.latitude,
                                                    restaurant.longitude,
                                                  ) /
                                                  1000;
                                          return Text(
                                            '${distance.toStringAsFixed(1)} km away',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
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
                                  restaurant.resName.isNotEmpty
                                      ? restaurant.resName
                                      : 'Unknown Restaurant',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() {
                                      final operatingHours =
                                          homeLocationCtrl.operatingHoursCache[
                                              restaurant.docID];
                                      final isFetching = homeLocationCtrl
                                          .fetchingOperatingHours
                                          .contains(restaurant.docID);
                                      final currentDay = DateFormat('EEEE')
                                          .format(DateTime.now());
                                      final timeFilter =
                                          filterCtrl.selectedFilters['Time'];

                                      if (operatingHours == null) {
                                        return Text(
                                          isFetching
                                              ? 'Loading...'
                                              : 'Unavailable',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: const Color.fromRGBO(
                                                142, 142, 147, 1),
                                            fontWeight: FontWeight.w500,
                                            fontFamily:
                                                GoogleFonts.plusJakartaSans()
                                                    .fontFamily,
                                          ),
                                        );
                                      }

                                      if (operatingHours.isEmpty ||
                                          operatingHours[currentDay] == null) {
                                        return Text(
                                          'Unavailable',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: const Color.fromRGBO(
                                                142, 142, 147, 1),
                                            fontWeight: FontWeight.w500,
                                            fontFamily:
                                                GoogleFonts.plusJakartaSans()
                                                    .fontFamily,
                                          ),
                                        );
                                      }

                                      final dayHours =
                                          operatingHours[currentDay]!;
                                      if (timeFilter == null ||
                                          timeFilter.isEmpty) {
                                        // Use the new method to get current operating hours
                                        final hoursText = homeLocationCtrl
                                            .getDisplayHours(dayHours);
                                        final isOpen = homeLocationCtrl
                                            .isRestaurantOpen(dayHours);
                                        return Text(
                                          hoursText,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isOpen
                                                ? Colors.green
                                                : const Color.fromRGBO(
                                                    142, 142, 147, 1),
                                            fontWeight: FontWeight.w500,
                                            fontFamily:
                                                GoogleFonts.plusJakartaSans()
                                                    .fontFamily,
                                          ),
                                        );
                                      }

                                      final timeOfDay = timeFilter.first;
                                      final isClosed = dayHours[timeOfDay]
                                              ?['isClosed'] ??
                                          true;
                                      final startTime = dayHours[timeOfDay]
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
                                          fontSize: 13,
                                          color: const Color.fromRGBO(
                                              142, 142, 147, 1),
                                          fontFamily:
                                              GoogleFonts.plusJakartaSans()
                                                  .fontFamily,
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
                                              '${restaurant.address}, ${restaurant.city}, ${restaurant.state}, ${restaurant.country}${restaurant.zipCode == '' ? '' : ', ${restaurant.zipCode}'}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: const Color.fromRGBO(
                                                    142, 142, 147, 1),
                                                fontFamily: GoogleFonts
                                                        .plusJakartaSans()
                                                    .fontFamily,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Obx(() {
                                            if (homeLocationCtrl
                                                    .isFetchingInitialData
                                                    .value &&
                                                homeLocationCtrl
                                                        .userPosition.value ==
                                                    null) {
                                              return Text(
                                                'Fetching ...',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: const Color.fromRGBO(
                                                      142, 142, 147, 1),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: GoogleFonts
                                                          .plusJakartaSans()
                                                      .fontFamily,
                                                ),
                                              );
                                            }

                                            if (!homeLocationCtrl
                                                    .isFetchingInitialData
                                                    .value &&
                                                homeLocationCtrl
                                                        .userPosition.value ==
                                                    null) {
                                              return Text(
                                                'Location disabled',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: const Color.fromRGBO(
                                                      142, 142, 147, 1),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: GoogleFonts
                                                          .plusJakartaSans()
                                                      .fontFamily,
                                                ),
                                              );
                                            }

                                            if (restaurant.latitude == 0.0 &&
                                                restaurant.longitude == 0.0) {
                                              return Text(
                                                'Unknown distance',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: const Color.fromRGBO(
                                                      142, 142, 147, 1),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: GoogleFonts
                                                          .plusJakartaSans()
                                                      .fontFamily,
                                                ),
                                              );
                                            }
                                            double distance =
                                                Geolocator.distanceBetween(
                                                      homeLocationCtrl
                                                          .userPosition
                                                          .value!
                                                          .latitude,
                                                      homeLocationCtrl
                                                          .userPosition
                                                          .value!
                                                          .longitude,
                                                      restaurant.latitude,
                                                      restaurant.longitude,
                                                    ) /
                                                    1000;
                                            return Text(
                                              '',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: const Color.fromRGBO(
                                                    142, 142, 147, 1),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: GoogleFonts
                                                        .plusJakartaSans()
                                                    .fontFamily,
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
          Obx(() {
            LatLng initialPosition;
            if (homeLocationCtrl.userPosition.value != null) {
              initialPosition = LatLng(
                homeLocationCtrl.userPosition.value!.latitude,
                homeLocationCtrl.userPosition.value!.longitude,
              );
            } else {
              String selectedCity = filterCtrl.selectedCity.value;
              String selectedCountry = filterCtrl.selectedCountry.value;
              if (selectedCity.isNotEmpty && selectedCountry == 'USA') {
                if (filterCtrl.newYorkCitiesList.contains(selectedCity)) {
                  initialPosition = LatLng(40.7128, -74.0060); // New York City
                } else if (filterCtrl.losAngelusCities.contains(selectedCity)) {
                  initialPosition = LatLng(34.0522, -118.2437); // Los Angeles
                } else {
                  initialPosition = LatLng(37.7749, -122.4194); // San Francisco
                }
              } else if (selectedCountry == 'France') {
                initialPosition = LatLng(48.8566, 2.3522); // Paris
              } else {
                initialPosition = LatLng(37.7749, -122.4194); // San Francisco
              }
            }

            return GoogleMap(
              padding: EdgeInsets.only(
                  top: (Platform.isAndroid ? 60 : 70) + 48 + 12 + 36 + 16 + 12),
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 14,
              ),
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer()),
              },
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _manager.setMapId(controller.mapId);
                _customInfoWindowController.googleMapController = controller;
                if (homeLocationCtrl.userPosition.value != null) {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(
                          homeLocationCtrl.userPosition.value!.latitude,
                          homeLocationCtrl.userPosition.value!.longitude,
                        ),
                        zoom: 14,
                      ),
                    ),
                  );
                }
              },
              onCameraMove: (position) {
                print('camera position zoom ${position.zoom}');
                _manager.onCameraMove(position);
                _customInfoWindowController.onCameraMove!();
              },
              onTap: (position) =>
                  _customInfoWindowController.hideInfoWindow!(),
              onCameraIdle: _manager.updateMap,
              markers: _markers,
            );
          }),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 100,
            width: 200,
            offset: 50,
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: (Get.height -
                    (Platform.isAndroid ? 60 : 70) -
                    56 -
                    8 -
                    56 -
                    10 -
                    20) /
                Get.height,
            snap: true,
            builder: (context, scrollCtrl) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
                ),
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                fontFamily:
                                    GoogleFonts.plusJakartaSans().fontFamily,
                              ),
                            ),
                          ),
                          const SizedBox(height: 11),
                          Obx(() {
                            return SizedBox(
                              height: 156,
                              child: isLoading.value ||
                                      cachedRestaurants.isEmpty
                                  ? _buildShimmer()
                                  : ListView(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 4),
                                      children: cachedRestaurants
                                          .take(4)
                                          .map((restaurant) =>
                                              buildRestaurantCard(restaurant))
                                          .toList(),
                                    ),
                            );
                          }),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.center,
                            child: CustomButton(
                              width: Get.width / 2,
                              height: 36,
                              laBelText: 'See All',
                              textColor: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              fontFamily:
                                  GoogleFonts.plusJakartaSans().fontFamily,
                              isPrefixIcon: true,
                              iconWidget: Icon(Icons.restaurant,
                                  color: Colors.white, size: 20),
                              ontapp: () {
                                Get.to(() =>
                                    SeeAllRestaurantsScreen(fromHome: true));
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Streams',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                fontFamily:
                                    GoogleFonts.plusJakartaSans().fontFamily,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            return SizedBox(
                              height: 252,
                              child: homeLocationCtrl.filteredVideos.isEmpty
                                  ? const Center(
                                      child: Text('No videos available'))
                                  : ListView(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 4),
                                      children: homeLocationCtrl.filteredVideos
                                          .asMap()
                                          .entries
                                          .take(4)
                                          .map((entry) {
                                        final index = entry.key;
                                        final video = entry.value;
                                        return buildStreamCard(video, index);
                                      }).toList(),
                                    ),
                            );
                          }),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.center,
                            child: CustomButton(
                              width: Get.width / 2,
                              height: 36,
                              laBelText: 'See All',
                              textColor: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              fontFamily:
                                  GoogleFonts.plusJakartaSans().fontFamily,
                              isPrefixIcon: true,
                              iconWidget: Icon(Icons.restaurant,
                                  color: Colors.white, size: 20),
                              ontapp: () {
                                Get.to(VideosListView(fromHome: true));
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Curated for you',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                fontFamily:
                                    GoogleFonts.plusJakartaSans().fontFamily,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          StreamBuilder<List<RestaurantModel>>(
                            stream: filterCtrl.selectedFilters.values
                                    .any((list) => list.isNotEmpty)
                                ? homeLocationCtrl.getFilteredRestaurants()
                                : homeLocationCtrl.getAllRestaurants(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  isLoading.value) {
                                return _buildShimmer();
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Error loading restaurants'));
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No restaurants available'));
                              }
                              final restaurants =
                                  snapshot.data!.take(4).toList();
                              Future.wait(restaurants.map((restaurant) =>
                                  homeLocationCtrl.getOperatingHours(
                                      restaurant.docID,
                                      triggerFilterUpdate: false)));
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: restaurants
                                      .map((restaurant) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: buildExperienceVibeCard(
                                                restaurant),
                                          ))
                                      .toList(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: CustomButton(
                              laBelText: 'Events',
                              textColor: Colors.white,
                              fontSize: 20,
                              ontapp: () {
                                Get.to(() => AllEventsScreen());
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
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
                          height: 56,
                          padding: const EdgeInsets.only(left: 16, right: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.search,
                                    size: 24,
                                    color: Colors.white,
                                  )),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: homeLocationCtrl.searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Find places by vibes...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontSize: 17, color: Colors.grey[600]),
                                  ),
                                  onChanged: (value) {
                                    // Cancel previous timer
                                    _searchDebounce?.cancel();
                                    // Start new timer for debounce
                                    _searchDebounce = Timer(
                                        const Duration(milliseconds: 500), () {
                                      homeLocationCtrl.searchQuery.value =
                                          value;
                                      homeLocationCtrl.applySearchAndFilters();
                                      isLoading.value = true;
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        isLoading.value = false;
                                        // Move map to first restaurant if search has results
                                        if (value.trim().isNotEmpty &&
                                            cachedRestaurants.isNotEmpty) {
                                          final firstRestaurant =
                                              cachedRestaurants.first;
                                          if (firstRestaurant.latitude != 0.0 &&
                                              firstRestaurant.longitude !=
                                                  0.0) {
                                            _mapController?.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                  target: LatLng(
                                                    firstRestaurant.latitude,
                                                    firstRestaurant.longitude,
                                                  ),
                                                  zoom: 15,
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      });
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
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
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    value: homeLocationCtrl
                                                .selectedDistance.value ==
                                            0
                                        ? 'All'
                                        : homeLocationCtrl
                                                .selectedDistance.value
                                                .toString() +
                                            ' mi',
                                    items: homeLocationCtrl.distanceOptions
                                        .map((ele) => DropdownMenuItem(
                                              value: ele,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Text(
                                                  ele,
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val == 'All') {
                                        homeLocationCtrl
                                            .selectedDistance.value = 0;
                                      } else {
                                        homeLocationCtrl
                                                .selectedDistance.value =
                                            int.parse(
                                                val!.replaceAll(' mi', ''));
                                      }
                                      isLoading.value = true;
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        homeLocationCtrl
                                            .applySearchAndFilters();
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
                const SizedBox(height: 8),
                Obx(
                  () => SizedBox(
                    height:
                        showFilterDropdowns.values.contains(true) ? 262 : 56,
                    child: Obx(() {
                      if (filterCtrl.filterOptions.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(
                            left: 16, right: 8, top: 4, bottom: 8),
                        children: filterCtrl.filterOptions.keys.map((category) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showFilterDropdowns[category] =
                                      !showFilterDropdowns[category]!;
                                  showFilterDropdowns.forEach((key, value) {
                                    if (key != category) {
                                      showFilterDropdowns[key] = false;
                                    }
                                  });
                                  showFilterDropdowns.refresh();
                                },
                                child: Obx(
                                  () => Container(
                                    height: 44,
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      color: filterCtrl
                                                  .selectedFilters[category]
                                                  ?.isNotEmpty ??
                                              false
                                          ? AppColors.primaryColor
                                          : Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          category +
                                              (filterCtrl
                                                          .selectedFilters[
                                                              category]
                                                          ?.isNotEmpty ??
                                                      false
                                                  ? ' (${filterCtrl.selectedFilters[category]?.length ?? 0})'
                                                  : ''),
                                          style: TextStyle(
                                            color: filterCtrl
                                                        .selectedFilters[
                                                            category]
                                                        ?.isNotEmpty ??
                                                    false
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 19,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.arrow_drop_down,
                                            size: 20, color: Colors.black),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Obx(() {
                                if (showFilterDropdowns[category] ?? false) {
                                  final optionCount = filterCtrl
                                          .filterOptions[category]?.length ??
                                      0;
                                  final dropdownHeight = optionCount * 40.0;
                                  return Positioned(
                                    top: 58,
                                    left: 0,
                                    child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: 150,
                                        height: dropdownHeight < 190
                                            ? dropdownHeight
                                            : 190,
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: (filterCtrl.filterOptions[
                                                        category] ??
                                                    [])
                                                .map((option) => InkWell(
                                                      onTap: () {
                                                        final selectedList =
                                                            filterCtrl.selectedFilters[
                                                                    category] ??
                                                                <String>[].obs;
                                                        if (selectedList
                                                            .contains(option)) {
                                                          selectedList
                                                              .remove(option);
                                                        } else {
                                                          selectedList
                                                              .add(option);
                                                        }
                                                        filterCtrl.selectedFilters[
                                                                category] =
                                                            selectedList;
                                                        filterCtrl
                                                            .selectedFilters
                                                            .refresh();
                                                        showFilterDropdowns[
                                                            category] = false;
                                                        showFilterDropdowns
                                                            .refresh();
                                                        isLoading.value = true;
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    500), () {
                                                          homeLocationCtrl
                                                              .applySearchAndFilters();
                                                          isLoading.value =
                                                              false;
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  emojiMap[
                                                                          option] ??
                                                                      '',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          17),
                                                                ),
                                                                const SizedBox(
                                                                    width: 4),
                                                                Text(
                                                                  option,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          17),
                                                                ),
                                                              ],
                                                            ),
                                                            if (filterCtrl
                                                                    .selectedFilters[
                                                                        category]
                                                                    ?.contains(
                                                                        option) ??
                                                                false)
                                                              const Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .green,
                                                                  size: 16),
                                                          ],
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
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

  // Emoji mappings for filter options
  static const Map<String, String> emojiMap = {
    // Vibes
    'Date Night': '💕',
    'Hidden Gems': '😶‍🌫️',
    'Trendy & Social': '💃',
    'High Vibe': '🔥',
    'Chill & Cozy': '😌',
    // Entertainment
    'Live Music': '🎶',
    'Dj Nights': '🎧',
    'Comedy': '🎤',
    'Karaoke': '🎙️',
    // Experiences
    'Brunch': '🍳',
    'Outdoor': '🌿',
    'Happy Hour': '🍸',
    'Rooftop': '🌆',
    'Water/Beachside': '🌊',
    'Late Night': '🌃',
    'Show': '🎭',
  };

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
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() => Column(
                  children: (ctrl.filterOptions[category] ?? []).map((option) {
                    final isSelected =
                        ctrl.selectedFilters[category]?.contains(option) ??
                            false;
                    return InkWell(
                      onTap: () {
                        final selectedList =
                            ctrl.selectedFilters[category] ?? <String>[].obs;
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
                            Row(
                              children: [
                                Text(
                                  emojiMap[option] ?? '',
                                  style: const TextStyle(fontSize: 17),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  option,
                                  style: const TextStyle(fontSize: 17),
                                ),
                              ],
                            ),
                            if (isSelected)
                              const Icon(Icons.check,
                                  color: Colors.green, size: 16),
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
