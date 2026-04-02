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
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart'
    as gmCluster;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kaistable_website/screens/app_info/about_app/about_app.dart';
import 'package:kaistable_website/screens/app_info/contact_us/contact_us.dart';
import 'package:kaistable_website/screens/app_info/privacy_policy/privacy_policy.dart';
import 'package:kaistable_website/screens/app_info/terms_and_condition/terms_and_condition.dart';
import 'package:kaistable_website/screens/change_pass/changePassword_dialoge.dart';
import 'package:kaistable_website/screens/events/all_events_screen.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/custom_button.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/saved_Resturant.dart';
import 'package:kaistable_website/streams/views/streams_view.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';

import '../../../constants/app_colors.dart';
import '../../../models/restaurant_model.dart';
import '../../../streams/model/streams_model.dart';
import '../../general_preferences/screens_general/preference_1.dart';
import '../../home_screen/home_controller/home_location_controller.dart';
import '../controller/search_controller.dart';
import '../full_screen_video/full_screen_video_screen.dart';
import '../restaurant_detail_screens/restaurant_detail_screen.dart';
import '../see_all_restaurants/see_all_restaurants_screen.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // GlobalKeys for filter buttons to get their positions
  final Map<String, GlobalKey> filterButtonKeys = {};

  // Cache for the restaurant list to prevent reloading
  final RxList<RestaurantModel> cachedRestaurants = <RestaurantModel>[].obs;

  late gmCluster.ClusterManager _manager; // Cluster manager
  Set<Marker> _markers = {};

  GoogleMapController? _mapController;

  // Debounce timer for search
  Timer? _searchDebounce;

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  // StreamSubscription to manage the listener for filtered restaurants
  StreamSubscription<List<RestaurantModel>>? _filteredSub;

  // FocusNode for search TextField to prevent keyboard from auto-opening
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

    _manager = _initClusterManager();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeLocationCtrl.fetchUserPosition(context);
      showFilterDropdowns.refresh();
      Future.delayed(const Duration(seconds: 1), () {
        isLoading.value = false;
      });

      homeLocationCtrl.applySearchAndFilters();

      ever(homeLocationCtrl.filteredRestaurantsStream,
          (Stream<List<RestaurantModel>> newStream) {
        _filteredSub?.cancel();
        _filteredSub = newStream.listen((list) {
          final items = list
              .where((r) => r.latitude != 0.0 && r.longitude != 0.0)
              .toList();
          _manager.setItems(items);
          cachedRestaurants.assignAll(items);
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
          homeLocationCtrl.applySearchAndFilters();
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapController?.dispose();
    _filteredSub?.cancel();
    _customInfoWindowController.dispose();
    _searchDebounce?.cancel();
    _searchFocusNode.dispose();
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
        if (enabled && homeLocationCtrl.userPosition.value == null) {
          homeLocationCtrl.fetchUserPosition(context);
        }
      });
    }
  }

  // Initialize cluster manager
  gmCluster.ClusterManager _initClusterManager() {
    return gmCluster.ClusterManager<RestaurantModel>(
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
    final gmCluster.Cluster<RestaurantModel> typedCluster =
        cluster as gmCluster.Cluster<RestaurantModel>;
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
        _navigateTo(() => RestaurantDetailScreen(restaurantModel: restaurant));
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
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
    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  Widget _buildShimmer() {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.5) - 18;
    return SizedBox(
      height: 220,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          children: List.generate(
            3,
            (_) => Container(
              width: cardWidth,
              margin: EdgeInsets.only(right: 10),
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
    final cardWidth = (screenWidth * 0.5) - 18; // .clamp(120.0, 160.0);
    final imageHeight = (cardWidth * (117 / 160)); // .clamp(66.0, 88.0);
    return GestureDetector(
      onTap: () {
        _navigateTo(() => RestaurantDetailScreen(restaurantModel: restaurant));
      },
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5.56),
                topRight: Radius.circular(5.56),
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
                        fontSize: 14 * (5 / 4),
                        // (cardWidth * 0.1).clamp(13.0, 15.0),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.5) - 20;
    final videoHeight = (cardWidth * (196 / 175));

    if (homeLocationCtrl.thumbnailPaths[index] == null &&
        video.url != null &&
        video.url!.isNotEmpty) {
      homeLocationCtrl.generateThumbnail(index, video.url!);
    }

    return GestureDetector(
      onTap: () {
        _dismissKeyboard();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullVideoScreen(video: video),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        height: 277,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: cardWidth,
                    height: videoHeight,
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
                      fontSize: 13 * (5 / 4),
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
            _navigateTo(
                () => RestaurantDetailScreen(restaurantModel: restaurant));
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
                                              '$distance',
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

  Widget _buildEndDrawer() {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      width: MediaQuery.of(context).size.width * 0.71,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 16.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.cancel,
                        color: Colors.grey.shade400, size: 28),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade300, height: 1),
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                spacing: 20,
                children: [
                  _buildDrawerItem(
                      'assets/images/oui_app-saved-objects.png', 'Saved', () {
                    endDrawerOnTap(0);
                  }),
                  _buildDrawerItem(
                      'assets/images/change_pass.png', 'Change Password', () {
                    endDrawerOnTap(1);
                  }),
                  _buildDrawerItem('assets/images/terms_condition-icon.png',
                      'Change Preferences', () {
                    endDrawerOnTap(2);
                  }),
                  _buildDrawerItem('assets/images/terms_condition-icon.png',
                      'Terms and conditions', () {
                    endDrawerOnTap(3);
                  }),
                  _buildDrawerItem(
                      'assets/images/privacy_img.png', 'Privacy policy', () {
                    endDrawerOnTap(4);
                  }),
                  _buildDrawerItem('assets/images/about_img.png', 'About app',
                      () {
                    endDrawerOnTap(5);
                  }),
                  _buildDrawerItem(
                      'assets/images/contact_us_img.png', 'Contact us', () {
                    endDrawerOnTap(6);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Image.asset(
                  icon,
                  height: 25,
                  width: 23,
                  color: Colors.black,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 0),
            child: Divider(color: Colors.grey.shade500, height: 0),
          ),
        ],
      ),
    );
  }

  ///drawer items on tap
  endDrawerOnTap(int index) {
    switch (index) {
      case 0:
        Get.to(() => SavedRestaurantsPage());
        break;
      case 1:
        changePasswordDialogBox();
        break;
      case 2:
        Get.to(Preference1(
          isComeFromSetting: true,
        ));
        break;
      case 3:
        Get.to(TermsAndCondition());
        break;
      case 4:
        Get.to(const PrivacyPolicy());
        break;
      case 5:
        Get.to(AboutApp());
        break;
      case 6:
        Get.to(ContactUs());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildEndDrawer(),
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
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                      child: Obx(
                        () {
                          if (homeLocationCtrl.isFetchingInitialData.value) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: _buildShimmer(),
                            );
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
                              // Filters section
                              Obx(
                                () {
                                  if (filterCtrl.filterOptions.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  for (var category
                                      in filterCtrl.filterOptions.keys) {
                                    filterButtonKeys.putIfAbsent(
                                        category, () => GlobalKey());
                                  }

                                  return SizedBox(
                                    height: 56,
                                    // Fixed height - dropdown will overlay
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      clipBehavior: Clip.none,
                                      // Allow dropdowns to overflow
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 8,
                                          top: 4,
                                          bottom: 8),
                                      children: filterCtrl.filterOptions.keys
                                          .map((category) {
                                        return GestureDetector(
                                          key: filterButtonKeys[category],
                                          onTap: () {
                                            showFilterDropdowns[category] =
                                                !showFilterDropdowns[category]!;
                                            showFilterDropdowns
                                                .forEach((key, value) {
                                              if (key != category) {
                                                showFilterDropdowns[key] =
                                                    false;
                                              }
                                            });
                                            showFilterDropdowns.refresh();
                                          },
                                          child: Obx(
                                            () => Container(
                                              height: 44,
                                              margin: const EdgeInsets.only(
                                                  right: 8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              decoration: BoxDecoration(
                                                // No border - blends with background
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: filterCtrl
                                                            .selectedFilters[
                                                                category]
                                                            ?.isNotEmpty ??
                                                        false
                                                    ? AppColors.primaryColor
                                                    : Colors.transparent,
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
                                                  Icon(Icons.arrow_drop_down,
                                                      size: 20,
                                                      color: filterCtrl
                                                                  .selectedFilters[
                                                                      category]
                                                                  ?.isNotEmpty ??
                                                              false
                                                          ? Colors.white
                                                          : Colors.black),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Restaurants in the area',
                                  style: TextStyle(
                                    fontSize: 18 * (5 / 4),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: GoogleFonts.plusJakartaSans()
                                        .fontFamily,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 11),
                              Obx(() {
                                if (isLoading.value) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 225,
                                        child: _buildShimmer(),
                                      ),
                                      if (cachedRestaurants.isNotEmpty) ...[
                                        const SizedBox(height: 24),
                                        Align(
                                          alignment: Alignment.center,
                                          child: CustomButton(
                                            width: 84,
                                            height: 36,
                                            radius: BorderRadius.circular(99),
                                            laBelText: 'See All',
                                            textColor: Colors.white,
                                            fontSize: 14 * (5 / 4),
                                            fontWeight: FontWeight.w500,
                                            fontFamily:
                                                GoogleFonts.plusJakartaSans()
                                                    .fontFamily,
                                            ontapp:
                                                () {}, // Disabled when loading
                                          ),
                                        ),
                                      ]
                                    ],
                                  );
                                }

                                if (cachedRestaurants.isEmpty) {
                                  return Container(
                                    height: 225,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.search_off_rounded,
                                          size: 48,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No dining spots nearby',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey.shade800,
                                            fontFamily:
                                                GoogleFonts.plusJakartaSans()
                                                    .fontFamily,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Try adjusting your filters\nor exploring a different area.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade600,
                                            height: 1.4,
                                            fontFamily:
                                                GoogleFonts.plusJakartaSans()
                                                    .fontFamily,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 225,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 4),
                                        children: cachedRestaurants
                                            .take(4)
                                            .map((restaurant) =>
                                                buildRestaurantCard(restaurant))
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Align(
                                      alignment: Alignment.center,
                                      child: CustomButton(
                                        width: 84,
                                        height: 36,
                                        radius: BorderRadius.circular(99),
                                        laBelText: 'See All',
                                        textColor: Colors.white,
                                        fontSize: 14 * (5 / 4),
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            GoogleFonts.plusJakartaSans()
                                                .fontFamily,
                                        // isPrefixIcon: true,
                                        // iconWidget: Icon(Icons.restaurant,
                                        //     color: Colors.white, size: 20),
                                        ontapp: () {
                                          _navigateTo(() =>
                                              SeeAllRestaurantsScreen(
                                                  fromHome: true));
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Streams',
                                  style: TextStyle(
                                    fontSize: 18 * (5 / 4),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: GoogleFonts.plusJakartaSans()
                                        .fontFamily,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Obx(() {
                                return SizedBox(
                                  height: 277,
                                  child: homeLocationCtrl.filteredVideos.isEmpty
                                      ? const Center(
                                          child: Text('No videos available'))
                                      : ListView(
                                          scrollDirection: Axis.horizontal,
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 4),
                                          children: homeLocationCtrl
                                              .filteredVideos
                                              .asMap()
                                              .entries
                                              .take(4)
                                              .map((entry) {
                                            final index = entry.key;
                                            final video = entry.value;
                                            return buildStreamCard(
                                                video, index);
                                          }).toList(),
                                        ),
                                );
                              }),
                              const SizedBox(height: 24),
                              Align(
                                alignment: Alignment.center,
                                child: CustomButton(
                                  width: 84,
                                  height: 36,
                                  radius: BorderRadius.circular(99),
                                  laBelText: 'See All',
                                  textColor: Colors.white,
                                  fontSize: 14 * (5 / 4),
                                  fontWeight: FontWeight.w500,
                                  fontFamily:
                                      GoogleFonts.plusJakartaSans().fontFamily,
                                  // isPrefixIcon: true,
                                  // iconWidget: Icon(Icons.restaurant,
                                  //     color: Colors.white, size: 20),
                                  ontapp: () {
                                    _navigateTo(
                                        () => VideosListView(fromHome: true));
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Curated for you',
                                  style: TextStyle(
                                    fontSize: 18 * (5 / 4),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: GoogleFonts.plusJakartaSans()
                                        .fontFamily,
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
                                        child:
                                            Text('Error loading restaurants'));
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child:
                                            Text('No restaurants available'));
                                  }
                                  final restaurants =
                                      snapshot.data!.take(4).toList();
                                  Future.wait(restaurants.map((restaurant) =>
                                      homeLocationCtrl.getOperatingHours(
                                          restaurant.docID,
                                          triggerFilterUpdate: false)));
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: CustomButton(
                                  laBelText: 'Events',
                                  textColor: Colors.white,
                                  fontSize: 20,
                                  ontapp: () {
                                    _navigateTo(() => AllEventsScreen());
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    // Dropdown overlays - positioned using GlobalKeys to appear above all content
                    Builder(
                      builder: (stackContext) {
                        return Obx(() {
                          if (filterCtrl.filterOptions.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Stack(
                            clipBehavior: Clip.none,
                            children:
                                filterCtrl.filterOptions.keys.map((category) {
                              return Obx(() {
                                if (showFilterDropdowns[category] ?? false) {
                                  final key = filterButtonKeys[category];
                                  if (key?.currentContext == null) {
                                    return const SizedBox.shrink();
                                  }

                                  final RenderBox? renderBox =
                                      key?.currentContext?.findRenderObject()
                                          as RenderBox?;
                                  if (renderBox == null) {
                                    return const SizedBox.shrink();
                                  }

                                  final position =
                                      renderBox.localToGlobal(Offset.zero);
                                  final size = renderBox.size;

                                  final optionCount = filterCtrl
                                          .filterOptions[category]?.length ??
                                      0;
                                  final dropdownHeight = optionCount * 40.0;

                                  // Get the position relative to the Stack
                                  final stackRenderBox = stackContext
                                      .findRenderObject() as RenderBox?;
                                  if (stackRenderBox == null) {
                                    return const SizedBox.shrink();
                                  }

                                  final stackPosition =
                                      stackRenderBox.localToGlobal(Offset.zero);
                                  final relativeLeft =
                                      position.dx - stackPosition.dx;
                                  final relativeTop =
                                      position.dy - stackPosition.dy;

                                  return Positioned(
                                    top: relativeTop + size.height + 8,
                                    // Below the filter button
                                    left: relativeLeft,
                                    // Aligned with left edge of button
                                    child: Material(
                                      elevation: 8,
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
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.1),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            ),
                                          ],
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
                              });
                            }).toList(),
                          );
                        });
                      },
                    ),
                  ],
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
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
                                    controller:
                                        homeLocationCtrl.searchController,
                                    focusNode: _searchFocusNode,
                                    decoration: InputDecoration(
                                      hintText: 'Find places by vibes...',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey[600]),
                                    ),
                                    onChanged: (value) {
                                      // Cancel previous timer
                                      _searchDebounce?.cancel();
                                      // Start new timer for debounce
                                      _searchDebounce = Timer(
                                          const Duration(milliseconds: 500),
                                          () {
                                        homeLocationCtrl.searchQuery.value =
                                            value;
                                        homeLocationCtrl
                                            .applySearchAndFilters();
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
                                            if (firstRestaurant.latitude !=
                                                    0.0 &&
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
                                          } else if (value.trim().isEmpty &&
                                              homeLocationCtrl
                                                      .userPosition.value !=
                                                  null) {
                                            // Move map back to user's current position when search is cleared
                                            _mapController?.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                  target: LatLng(
                                                    homeLocationCtrl
                                                        .userPosition
                                                        .value!
                                                        .latitude,
                                                    homeLocationCtrl
                                                        .userPosition
                                                        .value!
                                                        .longitude,
                                                  ),
                                                  zoom: 14,
                                                ),
                                              ),
                                            );
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
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
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
                      SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                        child: Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Icon(
                            Icons.menu,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // Filters below search bar - commented out (filters are now in bottom sheet)
                // const SizedBox(height: 8),
                // Obx(
                //   () => SizedBox(
                //     height:
                //         showFilterDropdowns.values.contains(true) ? 262 : 56,
                //     child: Obx(() {
                //       if (filterCtrl.filterOptions.isEmpty) {
                //         return const SizedBox.shrink();
                //       }
                //       return ListView(
                //         scrollDirection: Axis.horizontal,
                //         padding: const EdgeInsets.only(
                //             left: 16, right: 8, top: 4, bottom: 8),
                //         children: filterCtrl.filterOptions.keys.map((category) {
                //           return Stack(
                //             clipBehavior: Clip.none,
                //             children: [
                //               GestureDetector(
                //                 onTap: () {
                //                   showFilterDropdowns[category] =
                //                       !showFilterDropdowns[category]!;
                //                   showFilterDropdowns.forEach((key, value) {
                //                     if (key != category) {
                //                       showFilterDropdowns[key] = false;
                //                     }
                //                   });
                //                   showFilterDropdowns.refresh();
                //                 },
                //                 child: Obx(
                //                   () => Container(
                //                     height: 44,
                //                     margin: const EdgeInsets.only(right: 8),
                //                     padding: const EdgeInsets.symmetric(
                //                         horizontal: 16),
                //                     decoration: BoxDecoration(
                //                       boxShadow: [
                //                         BoxShadow(
                //                           color: Colors.black.withOpacity(0.2),
                //                           blurRadius: 4,
                //                           spreadRadius: 0,
                //                           offset: Offset(0, 4),
                //                         ),
                //                       ],
                //                       border: Border.all(
                //                           color: Colors.grey.shade300),
                //                       color: filterCtrl
                //                                   .selectedFilters[category]
                //                                   ?.isNotEmpty ??
                //                               false
                //                           ? AppColors.primaryColor
                //                           : Colors.white,
                //                     ),
                //                     child: Row(
                //                       mainAxisSize: MainAxisSize.min,
                //                       children: [
                //                         Text(
                //                           category +
                //                               (filterCtrl
                //                                           .selectedFilters[
                //                                               category]
                //                                           ?.isNotEmpty ??
                //                                       false
                //                                   ? ' (${filterCtrl.selectedFilters[category]?.length ?? 0})'
                //                                   : ''),
                //                           style: TextStyle(
                //                             color: filterCtrl
                //                                         .selectedFilters[
                //                                             category]
                //                                         ?.isNotEmpty ??
                //                                     false
                //                                 ? Colors.white
                //                                 : Colors.black,
                //                             fontSize: 19,
                //                           ),
                //                         ),
                //                         const SizedBox(width: 4),
                //                         const Icon(Icons.arrow_drop_down,
                //                             size: 20, color: Colors.black),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               Obx(() {
                //                 if (showFilterDropdowns[category] ?? false) {
                //                   final optionCount = filterCtrl
                //                           .filterOptions[category]?.length ??
                //                       0;
                //                   final dropdownHeight = optionCount * 40.0;
                //                   return Positioned(
                //                     top: 58,
                //                     left: 0,
                //                     child: Material(
                //                       elevation: 5,
                //                       borderRadius: BorderRadius.circular(12),
                //                       child: Container(
                //                         width: 150,
                //                         height: dropdownHeight < 190
                //                             ? dropdownHeight
                //                             : 190,
                //                         padding: const EdgeInsets.fromLTRB(
                //                             8, 8, 8, 16),
                //                         decoration: BoxDecoration(
                //                           color: Colors.white,
                //                           borderRadius:
                //                               BorderRadius.circular(12),
                //                         ),
                //                         child: SingleChildScrollView(
                //                           child: Column(
                //                             crossAxisAlignment:
                //                                 CrossAxisAlignment.start,
                //                             children: (filterCtrl.filterOptions[
                //                                         category] ??
                //                                     [])
                //                                 .map((option) => InkWell(
                //                                       onTap: () {
                //                                         final selectedList =
                //                                             filterCtrl.selectedFilters[
                //                                                     category] ??
                //                                                 <String>[].obs;
                //                                         if (selectedList
                //                                             .contains(option)) {
                //                                           selectedList
                //                                               .remove(option);
                //                                         } else {
                //                                           selectedList
                //                                               .add(option);
                //                                         }
                //                                         filterCtrl.selectedFilters[
                //                                                 category] =
                //                                             selectedList;
                //                                         filterCtrl
                //                                             .selectedFilters
                //                                             .refresh();
                //                                         showFilterDropdowns[
                //                                             category] = false;
                //                                         showFilterDropdowns
                //                                             .refresh();
                //                                         isLoading.value = true;
                //                                         Future.delayed(
                //                                             const Duration(
                //                                                 milliseconds:
                //                                                     500), () {
                //                                           homeLocationCtrl
                //                                               .applySearchAndFilters();
                //                                           isLoading.value =
                //                                               false;
                //                                         });
                //                                       },
                //                                       child: Padding(
                //                                         padding:
                //                                             const EdgeInsets
                //                                                 .symmetric(
                //                                                 vertical: 8),
                //                                         child: Row(
                //                                           mainAxisAlignment:
                //                                               MainAxisAlignment
                //                                                   .spaceBetween,
                //                                           children: [
                //                                             Row(
                //                                               children: [
                //                                                 Text(
                //                                                   emojiMap[
                //                                                           option] ??
                //                                                       '',
                //                                                   style: const TextStyle(
                //                                                       fontSize:
                //                                                           17),
                //                                                 ),
                //                                                 const SizedBox(
                //                                                     width: 4),
                //                                                 Text(
                //                                                   option,
                //                                                   style: const TextStyle(
                //                                                       fontSize:
                //                                                           17),
                //                                                 ),
                //                                               ],
                //                                             ),
                //                                             if (filterCtrl
                //                                                     .selectedFilters[
                //                                                         category]
                //                                                     ?.contains(
                //                                                         option) ??
                //                                                 false)
                //                                               const Icon(
                //                                                   Icons.check,
                //                                                   color: Colors
                //                                                       .green,
                //                                                   size: 16),
                //                                           ],
                //                                         ),
                //                                       ),
                //                                     ))
                //                                 .toList(),
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                   );
                //                 }
                //                 return const SizedBox.shrink();
                //               }),
                //             ],
                //           );
                //         }).toList(),
                //       );
                //     }),
                //   ),
                // ),
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
