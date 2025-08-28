import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/recent_view.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/models/review_model.dart';
import 'package:kaistable_website/utils/loading.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' hide Rx;
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../streams/model/streams_model.dart';
import '../../nav_bar/controller/search_controller.dart';

class HomeLocationController extends GetxController {
  Position? userPosition = null;
  final RxBool isFetchingInitialData = true.obs;
  final RxInt selectedDistance = 0.obs;
  final List<String> distanceOptions = ['All', '1 mi', '5 mi', '10 mi', '25 mi'];
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  final RxMap<String, Map<String, Map<String, Map<String, dynamic>>>> operatingHoursCache = <String, Map<String, Map<String, Map<String, dynamic>>>>{}.obs;
  final RxSet<String> fetchingOperatingHours = <String>{}.obs;
  final Rx<Stream<List<RestaurantModel>>> filteredRestaurantsStream = Rx<Stream<List<RestaurantModel>>>(Stream.value([]));


  DocumentSnapshot? lastDocument;
  RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  final _searchSubject = BehaviorSubject<String>.seeded('');
  List<RestaurantModel> allRestaurants = [];
  List<RestaurantModel> filteredRestaurants = [];
  RxString selectedTop = ''.obs;
  RxList selectedPersentage = [].obs;
  RxList selectedHappyhour = [].obs;
  Map<String, List<String>> cusinesMapFilter = {};
  final FilterController filterCtrl = Get.put(FilterController());
  List top = ['Most Reviewed', 'Discount', 'Dining'];

  //// video variables
  final RxList<VideoModel> filteredVideos = <VideoModel>[].obs;
  var videos = <VideoModel>[].obs;
  var thumbnailPaths = <int, String>{}.obs;
  bool _isGeneratingThumbnail = false;
  ////

  void onInit() {
    super.onInit();
    fetchUserPosition(Get.context!);
    fetchVideos();
    applySearchAndFilters();
  }

  //// video functions
  Future<void> fetchVideos() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('videos')
          .orderBy('timestamp', descending: true)
          .get();

      videos.value = snapshot.docs
          .map((doc) => VideoModel.fromMap(doc.data()))
          .toList();

      filteredVideos.value = videos.toList(); // Initialize filteredVideos with all videos
      applySearchAndFilters(); // Apply initial filtering if filters are set
    } catch (e) {
      print("Error fetching videos: $e");
      Get.snackbar('Error', 'Failed to load videos: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> generateThumbnail(int index, String videoUrl) async {
    if (_isGeneratingThumbnail || thumbnailPaths[index] != null) return;
    _isGeneratingThumbnail = true;

    try {
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoUrl,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 200, // Reduced for performance
        quality: 50,    // Reduced for performance
      );
      if (thumbnailPath != null) {
        thumbnailPaths[index] = thumbnailPath;
      }
    } catch (e) {
      print("Error generating thumbnail for $videoUrl: $e");
    } finally {
      _isGeneratingThumbnail = false;
    }
  }
  ////

  void fetchUserPosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userPosition = position;
    isFetchingInitialData.value = false;
  }

  Widget buildImage(String url, {required double width, BoxFit fit = BoxFit.cover, double height = 0}) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      fit: fit,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/event_img3.png',
        width: width,
        fit: fit,
      ),
    );
  }

  // void getOperatingHours(String restaurantId) async {
  //   // Mock implementation for operating hours
  //   operatingHoursCache[restaurantId] = {
  //     'Breakfast': {'hours': '7AM–11AM', 'isClosed': false},
  //     'Lunch': {'hours': '12PM–3PM', 'isClosed': false},
  //     'Dinner': {'hours': '6PM–9PM', 'isClosed': false},
  //   };
  // }

  RestaurantModel? findRestaurantForVideo(VideoModel video) {
    // Mock implementation for finding restaurant
    return null;
  }

  Stream<List<RestaurantModel>> getAllRestaurants() {
    return FirebaseFirestore.instance
        .collection('restaurants')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => RestaurantModel.fromDocumentSnapshot(doc))
        .toList());
  }

  Stream<List<RestaurantModel>> getFilteredRestaurants() {
    final filterCtrl = Get.find<FilterController>();
    return FirebaseFirestore.instance
        .collection('restaurants')
        .snapshots()
        .map((snapshot) {
      var restaurants = snapshot.docs
          .map((doc) => RestaurantModel.fromDocumentSnapshot(doc))
          .toList();

      // Apply AND logic across categories
      for (var category in filterCtrl.selectedFilters.keys) {
        final selectedOptions = filterCtrl.selectedFilters[category];
        if (selectedOptions != null && selectedOptions.isNotEmpty) {
          restaurants = restaurants.where((restaurant) {
            if (category == 'Dietary') {
              return selectedOptions.any((option) => restaurant.dietaryList.contains(option));
            } else if (category == 'Vibes') {
              return selectedOptions.any((option) => restaurant.vibesList.contains(option));
            } else if (category == 'Time') {
              final hours = operatingHoursCache[restaurant.docID];
              if (hours == null || hours.isEmpty) {
                getOperatingHours(restaurant.docID);
                return false; // Exclude until hours are fetched
              }
              return hours.values.any((dayHours) =>
                  selectedOptions.every((timeOfDay) => !(dayHours[timeOfDay]?['isClosed'] ?? true))
              );
            } else if (category == 'Cuisines') {
              final menuList = restaurant.menuList;
              if (menuList.isEmpty) {
                return false; // Exclude if no menu items
              }
              return selectedOptions.every((cuisine) =>
                  menuList.any((menu) => menu.cuisineType == cuisine)
              );
            } else if (category == 'Experience') {
              final entertainmentList = restaurant.entertainmentScheduleList;
              if (entertainmentList.isEmpty) {
                return false; // Exclude if no entertainment schedule
              }
              return selectedOptions.every((experience) =>
                  entertainmentList.any((event) => event.eventName == experience)
              );
            }
            return true;
          }).toList();
        }
      }

      return restaurants;
    });
  }

  void applySearchAndFilters() {
    filteredRestaurantsStream.value = FirebaseFirestore.instance
        .collection('restaurants')
        .snapshots()
        .map((snapshot) {
      var restaurants = snapshot.docs
          .map((doc) => RestaurantModel.fromDocumentSnapshot(doc))
          .toList();

      // Apply search query (unchanged for restaurants)
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        restaurants = restaurants.where((restaurant) {
          return restaurant.resName.toLowerCase().contains(query) ||
              restaurant.address.toLowerCase().contains(query); // ||
              // restaurant.dietaryList.any((diet) => diet.toLowerCase().contains(query)) ||
              // restaurant.vibesList.any((vibe) => vibe.toLowerCase().contains(query)) ||
              // restaurant.menuList.any((menu) => menu.cuisineType.toLowerCase().contains(query));
        }).toList();
      }

      // Apply AND logic across category filters (unchanged for restaurants)
      final filterCtrl = Get.find<FilterController>();
      for (var category in filterCtrl.selectedFilters.keys) {
        final selectedOptions = filterCtrl.selectedFilters[category];
        if (selectedOptions != null && selectedOptions.isNotEmpty) {
          restaurants = restaurants.where((restaurant) {
            if (category == 'Dietary') {
              return selectedOptions.any((option) => restaurant.dietaryList.contains(option));
            } else if (category == 'Vibes') {
              return selectedOptions.any((option) => restaurant.vibesList.contains(option));
            } else if (category == 'Time') {
              final hours = operatingHoursCache[restaurant.docID];
              if (hours == null || hours.isEmpty) {
                getOperatingHours(restaurant.docID);
                return false; // Exclude until hours are fetched
              }
              return hours.values.any((dayHours) =>
                  selectedOptions.every((timeOfDay) => !(dayHours[timeOfDay]?['isClosed'] ?? true))
              );
            } else if (category == 'Cuisines') {
              final menuList = restaurant.menuList;
              if (menuList.isEmpty) {
                return false; // Exclude if no menu items
              }
              return selectedOptions.every((cuisine) =>
                  menuList.any((menu) => menu.cuisineType == cuisine)
              );
            } else if (category == 'Experience') {
              final entertainmentList = restaurant.entertainmentScheduleList;
              if (entertainmentList.isEmpty) {
                return false; // Exclude if no entertainment schedule
              }
              return selectedOptions.every((experience) =>
                  entertainmentList.any((event) => event.eventName == experience)
              );
            }
            return true;
          }).toList();
        }
      }

      // Apply distance filter (unchanged for restaurants)
      if (selectedDistance.value > 0 && userPosition != null) {
        final maxDistanceKm = selectedDistance.value * 1.60934; // Convert miles to kilometers
        restaurants = restaurants.where((restaurant) {
          if (restaurant.latitude == 0.0 && restaurant.longitude == 0.0) {
            return false;
          }
          final distance = Geolocator.distanceBetween(
            userPosition!.latitude,
            userPosition!.longitude,
            restaurant.latitude,
            restaurant.longitude,
          ) / 1000; // Distance in kilometers
          return distance <= maxDistanceKm;
        }).toList();
      }

      return restaurants;
    });

    // NEW: Filter videos directly using cuisines, vibes, experience fields
    if (videos.isNotEmpty) {
      final filterCtrl = Get.find<FilterController>();
      final query = searchQuery.value.toLowerCase();
      final selectedCuisines = filterCtrl.selectedFilters['Cuisines'] ?? <String>[].obs;
      final selectedExperiences = filterCtrl.selectedFilters['Experience'] ?? <String>[].obs;
      final selectedVibes = filterCtrl.selectedFilters['Vibes'] ?? <String>[].obs;

      filteredVideos.value = videos.where((video) {
        // Search: matches if restaurantName or city contains query
        final matchesSearch = query.isEmpty ||
            (video.restaurantName?.toLowerCase().contains(query) ?? false); // || (video.city?.toLowerCase().contains(query) ?? false);

        // Cuisines: OR - any selected cuisine matches video.cuisines (assuming it's a comma-separated string or single value)
        final videoCuisines = video.causines?.split(',').map((c) => c.trim()).toList() ?? [];
        final matchesCuisines = selectedCuisines.isEmpty ||
            selectedCuisines.any((cuisine) => videoCuisines.contains(cuisine));

        // Experiences: OR - any selected experience matches video.experience
        final videoExperiences = video.experience?.split(',').map((e) => e.trim()).toList() ?? [];
        final matchesExperiences = selectedExperiences.isEmpty ||
            selectedExperiences.any((experience) => videoExperiences.contains(experience));

        // Vibes: OR - any selected vibe matches video.vibes
        final videoVibes = video.vibes?.split(',').map((v) => v.trim()).toList() ?? [];
        final matchesVibes = selectedVibes.isEmpty ||
            selectedVibes.any((vibe) => videoVibes.contains(vibe));

        // AND between different filters
        return matchesSearch && matchesCuisines && matchesExperiences && matchesVibes;
      }).toList();
    }
  }

  Stream<List<RestaurantModel>> getRestaurants() {
    return FirebaseFirestore.instance
        .collection('restaurants')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last;
      }

      List<RestaurantModel> restaurantsList = await Future.wait(
        snapshot.docs.map((doc) async {
          final restaurant = RestaurantModel.fromDocumentSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
          return restaurant;
        }),
      );

      restaurants.assignAll(restaurantsList.where((item) => item.resName
          .toLowerCase()
          .contains(_searchSubject.value.toLowerCase())));
      update();
      return restaurantsList;
    });
  }

  // Future<void> getOperatingHours(String restaurantId) async {
  //   if (operatingHoursCache.containsKey(restaurantId)) {
  //     return;
  //   }
  //
  //   try {
  //     var querySnapshot = await FirebaseFirestore.instance
  //         .collection('restaurants')
  //         .doc(restaurantId)
  //         .collection('operatingHours')
  //         .get();
  //
  //     Map<String, Map<String, Map<String, dynamic>>> daysHours = {};
  //
  //     for (var doc in querySnapshot.docs) {
  //       String day = doc.id;
  //       daysHours[day] = (doc.data()).map((key, value) => MapEntry(key, value as Map<String, dynamic>));
  //     }
  //
  //     operatingHoursCache[restaurantId] = daysHours;
  //     operatingHoursCache.refresh();
  //     applySearchAndFilters(); // Trigger re-filter after fetch
  //   } catch (e) {
  //     print('Error fetching operating hours for $restaurantId: $e');
  //     operatingHoursCache[restaurantId] = {};
  //     operatingHoursCache.refresh();
  //     applySearchAndFilters();
  //   }
  // }

  Future<Map<String, Map<String, Map<String, dynamic>>>?> getOperatingHours(
      String restaurantId, {bool triggerFilterUpdate = false}) async {
    if (operatingHoursCache.containsKey(restaurantId)) {
      print('Returning cached operating hours for $restaurantId');
      return operatingHoursCache[restaurantId];
    }

    // Set fetching state
    fetchingOperatingHours.add(restaurantId);
    fetchingOperatingHours.refresh();

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .collection('operatingHours')
          .get();

      Map<String, Map<String, Map<String, dynamic>>> daysHours = {};

      for (var doc in querySnapshot.docs) {
        String day = doc.id;
        daysHours[day] = (doc.data()).map((key, value) => MapEntry(key, value as Map<String, dynamic>));
      }

      operatingHoursCache[restaurantId] = daysHours;
      operatingHoursCache.refresh();
      print('Fetched operating hours for $restaurantId: ${daysHours.toString()}');
      if (triggerFilterUpdate) {
        applySearchAndFilters();
      }
      return daysHours;
    } catch (e) {
      print('Error fetching operating hours for $restaurantId: $e');
      operatingHoursCache[restaurantId] = {};
      operatingHoursCache.refresh();
      if (triggerFilterUpdate) {
        applySearchAndFilters();
      }
      return {};
    } finally {
      fetchingOperatingHours.remove(restaurantId);
      fetchingOperatingHours.refresh();
    }
  }

  String getFullDayHours(Map<String, Map<String, dynamic>>? dayHours) {
    if (dayHours == null || dayHours.isEmpty) {
      return 'Unavailable';
    }

    // Parse times to find earliest start and latest end
    DateFormat timeFormat = DateFormat('h:mm a');
    DateTime? earliestStart;
    DateTime? latestEnd;
    bool allClosed = true;

    for (var slot in dayHours.values) {
      bool isClosed = slot['isClosed'] ?? true;
      if (!isClosed) {
        allClosed = false;
        String startTimeStr = slot['startTime'] ?? '12:00 AM';
        String endTimeStr = slot['endTime'] ?? '11:59 PM';

        try {
          DateTime startTime = timeFormat.parse(startTimeStr);
          DateTime endTime = timeFormat.parse(endTimeStr);

          // Adjust for times crossing midnight
          if (endTime.isBefore(startTime)) {
            endTime = endTime.add(Duration(days: 1));
          }

          if (earliestStart == null || startTime.isBefore(earliestStart)) {
            earliestStart = startTime;
          }
          if (latestEnd == null || endTime.isAfter(latestEnd)) {
            latestEnd = endTime;
          }
        } catch (e) {
          print('Error parsing time for slot: $e');
          continue;
        }
      }
    }

    if (allClosed) {
      return 'Closed';
    }

    if (earliestStart == null || latestEnd == null) {
      return 'Unavailable';
    }

    // Format the combined range
    String startFormatted = timeFormat.format(earliestStart);
    String endFormatted = timeFormat.format(latestEnd);
    return '$startFormatted–$endFormatted';
  }

  Future<Map<String, dynamic>?> getOperatingHours1(String restaurantId) async {
    if (operatingHoursCache.containsKey(restaurantId)) {
      print('Returning cached operating hours for $restaurantId');
      return operatingHoursCache[restaurantId];
    }
    try {
      String currentDay = DateFormat('EEEE').format(DateTime.now());
      var operatingHoursDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .collection('operatingHours')
          .doc(currentDay)
          .get();
      Map<String, dynamic> data = operatingHoursDoc.exists ? (operatingHoursDoc.data() ?? {}) : {};
      operatingHoursCache[restaurantId] = data as Map<String, Map<String, Map<String, dynamic>>>;
      operatingHoursCache.refresh();
      print('Fetched operating hours for $restaurantId: $data');
      return data;
    } catch (e) {
      print('Error fetching operating hours for $restaurantId: $e');
      operatingHoursCache[restaurantId] = {};
      operatingHoursCache.refresh();
      return {};
    }
  }

  Future<Map<String, Map<String, Map<String, dynamic>>>?> getOperatingHours2(String restaurantId) async {
    if (operatingHoursCache.containsKey(restaurantId)) {
      print('Returning cached operating hours for $restaurantId');
      return operatingHoursCache[restaurantId];
    }
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .collection('operatingHours')
          .get();

      Map<String, Map<String, Map<String, dynamic>>> daysHours = {};

      for (var doc in querySnapshot.docs) {
        String day = doc.id;
        daysHours[day] = (doc.data()).map((key, value) => MapEntry(key, value as Map<String, dynamic>));
      }

      operatingHoursCache[restaurantId] = daysHours;
      operatingHoursCache.refresh();
      print('Fetched operating hours for $restaurantId: ${daysHours.toString()}');
      return daysHours;
    } catch (e) {
      print('Error fetching operating hours for $restaurantId: $e');
      operatingHoursCache[restaurantId] = {};
      operatingHoursCache.refresh();
      return {};
    }
  }

  Future<Position> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    while (!serviceEnabled) {
      bool? enableLocation = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location Services Disabled'),
            content: const Text('Please enable location services to continue.'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Open Settings'),
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (enableLocation == false) {
        return Future.error('Location services are disabled.');
      }

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied.');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void filterRestaurants(String query) {
    if (query.isEmpty) {
      filteredRestaurants = allRestaurants;
    } else {
      filteredRestaurants = allRestaurants
          .where((restaurant) => restaurant.resName
              .toLowerCase()
              .contains(query.toLowerCase().trim()))
          .toList();
    }
    update();
  }

  void initailizedSelectors({required List<RestaurantModel> resaturantsList}) {
    selectedPersentage.clear();
    selectedHappyhour.clear();
    if (selectedHappyhour.isNotEmpty) {
      selectedHappyhour[0] = true;
    }
    if (selectedPersentage.isNotEmpty) {
      selectedPersentage[0] = true;
    }
  }

  Stream<List<RestaurantModel>> getEntertainmentRestaurants() {
    return FirebaseFirestore.instance
        .collection('restaurants')
        .where('entertainmentScheduleList', isGreaterThan: [])
        .snapshots()
        .asyncMap((snapshot) async {
          final restaurants = await Future.wait(
            snapshot.docs.map((doc) async {
              final restaurant = RestaurantModel.fromDocumentSnapshot(
                  doc as DocumentSnapshot<Map<String, dynamic>>);
              return restaurant;
            }),
          );
          return restaurants;
        });
  }

  void initializeSelectors(List<RestaurantModel> screenRestaurants) {
    allRestaurants = screenRestaurants;
    filteredRestaurants = screenRestaurants;
    update();
  }

  Stream<List<ReviewModel>> getReviews(String restaurantID) {
    return FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restaurantID)
        .collection('reviews')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ReviewModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  void initializeCuisinesSelectors(Map<String, List<String>> cuisines) {
    cusinesMapFilter = cuisines;
    update();
  }

  Stream<List<RecentViewModel>> getRecentViews() {
    var recentViewCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('recentView');

    return recentViewCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return RecentViewModel.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<RestaurantModel>> getTrendingRestaurants() {
    return FirebaseFirestore.instance
        .collection('restaurants')
        .where('averageRating', isGreaterThan: 0)
        .orderBy('averageRating', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RestaurantModel.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    });
  }

  Stream<Map<String, dynamic>?> getFeaturedRestaurantID() {
    return FirebaseFirestore.instance
        .collection('featured')
        .doc('mainFeatured')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    });
  }

  Stream<RestaurantModel?> getFeaturedRestaurants({required String restID}) {
    return FirebaseFirestore.instance
        .collection('restaurants')
        .where('docID', isEqualTo: restID)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        lastDocument = snapshot.docs.last;
        return RestaurantModel.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      } else {
        return null;
      }
    });
  }

  Future<List<RestaurantModel>> getNearbyRestaurants(
      List<RestaurantModel> restaurants,
      double radiusKm,
      BuildContext context) async {
    Position userLocation = await getCurrentLocation(context);
    List<String> selectedFilters =
        filterCtrl.selectedFilters.values.expand((list) => list).toList();
    selectedFilters.addAll([
      filterCtrl.selectedCity.value,
      filterCtrl.selectedCountry.value
    ].where((e) => e.isNotEmpty));

    List<RestaurantModel> timeFilteredRestaurants =
        (filterCtrl.selectedFilters['Time']?.isNotEmpty ?? false)
            ? await getFilteredByTimeOfDay(restaurants)
            : restaurants;

    return timeFilteredRestaurants.where((restaurant) {
      bool withinRadius = isWithinRadius(
        userLocation,
        restaurant.latitude,
        restaurant.longitude,
        radiusKm,
      );

      bool filterMatch = true;
      if (selectedFilters.isNotEmpty) {
        filterMatch = selectedFilters.any((filter) {
          filter = filter.toLowerCase();
          return restaurant.menuList.any(
                  (menu) => menu.cuisineType.toLowerCase().contains(filter)) ||
              restaurant.city.toLowerCase().contains(filter) ||
              restaurant.country.toLowerCase().contains(filter) ||
              restaurant.atmosphereList.any(
                  (atmosphere) => atmosphere.toLowerCase().contains(filter)) ||
              restaurant.entertainmentScheduleList.any((schedule) =>
                  schedule.eventName.toLowerCase().contains(filter)) ||
              restaurant.dietaryList
                  .any((dietary) => dietary.toLowerCase().contains(filter)) ||
              restaurant.priceRange.toLowerCase().contains(filter);
        });
      }

      return withinRadius && filterMatch;
    }).toList();
  }

  Future<List<RestaurantModel>> getFilteredByTimeOfDay(
      List<RestaurantModel> restaurants) async {
    List<RestaurantModel> filteredRestaurants = [];
    List<String> timeOfDayList =
        filterCtrl.selectedFilters['Time']?.toList() ?? [];

    for (var restaurant in restaurants) {
      var operatingHours = await getOperatingHours1(restaurant.docID);
      if (operatingHours != null) {
        for (var timeOfDay in timeOfDayList) {
          if (operatingHours.containsKey(timeOfDay)) {
            var timeSlot = operatingHours[timeOfDay];
            var isClosed = timeSlot['isClosed'] ?? false;
            if (!isClosed) {
              filteredRestaurants.add(restaurant);
              break;
            }
          }
        }
      }
    }
    return filteredRestaurants;
  }

  bool isWithinRadius(
      Position userLocation, double restLat, double restLng, double radiusKm) {
    double distance = Geolocator.distanceBetween(
        userLocation.latitude, userLocation.longitude, restLat, restLng);
    return distance <= radiusKm * 1000;
  }

  Widget favoriteHeart({resturant_id}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser?.uid)
          .collection('favorite')
          .where('resturantID', isEqualTo: resturant_id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Icon(
            Icons.favorite_border_outlined,
            size: 22,
            color: AppColors.primaryColor,
          );
        }

        if (snapshot.hasError) {
          return Icon(
            Icons.favorite_border_outlined,
            size: 22,
            color: AppColors.primaryColor,
          );
        }

        bool isFavorite = snapshot.data?.docs.isNotEmpty ?? false;

        return InkWell(
          onTap: () async {
            if (isFavorite) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('favorite')
                  .where('resturantID', isEqualTo: resturant_id)
                  .get()
                  .then((snapshot) {
                for (var doc in snapshot.docs) {
                  doc.reference.delete();
                }
              });
              await updateAverageRating(
                  isRate: true, resturant_id: resturant_id);
            } else {
              String favId = FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('favorite')
                  .doc()
                  .id;

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .collection('favorite')
                  .doc(favId)
                  .set({
                'resturantID': resturant_id,
                'favID': favId,
              });
              await updateAverageRating(
                  isRate: false, resturant_id: resturant_id);
            }
          },
          child: isFavorite
              ? Image.asset(
                  'assets/images/heart_icon.png',
                  color: AppColors.primaryColor,
                  height: 22,
                  width: 22,
                )
              : Icon(
                  Icons.favorite_border_outlined,
                  size: 22,
                  color: AppColors.primaryColor,
                ),
        );
      },
    );
  }

  Future<void> updateAverageRating({required bool isRate, resturant_id}) async {
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('restaurants').doc(resturant_id);

    try {
      await docRef.update({
        'averageRating': FieldValue.increment(!isRate ? 1 : -1),
      });
      print('Rating updated successfully');
    } catch (e) {
      print('Failed to update rating: $e');
    }
  }

  Future<void> addRestaurantReview({
    required String restaurantID,
    required List<File> images,
    required double starRating,
    required String description,
  }) async {
    try {
      loadingDialog(message: 'Please wait!', loading: true, height: 150);
      List<String> imagesLinks = [];
      for (var v in images) {
        imagesLinks
            .add(await uploadImageToFirebase('reviews', v.readAsBytesSync()));
      }
      var reviewCollection = FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantID)
          .collection('reviews');

      String reviewId = reviewCollection.doc().id;
      await reviewCollection.doc(reviewId).set({
        'reviewID': reviewId,
        'restaurantID': restaurantID,
        'userName': currentUserDataModel?.value.username.text,
        'userID': auth.currentUser?.uid,
        'images': imagesLinks,
        'starRating': starRating,
        'description': description,
        'dateTime': FieldValue.serverTimestamp(),
      });
      print('Review added successfully!');
      Get.back();
    } catch (e) {
      Get.back();
      print('Error adding review: $e');
    }
  }

}

// class HomeLocationController extends GetxController {
//   RxList selectedPersentage = [].obs;
//   RxList selectedHappyhour = [].obs;
//   Rx<latlng.LatLng> location = latlng.LatLng(37.5665, 126.9780).obs;
//
//   Position? userPosition = null;
//   RxMap<String, Map<String, dynamic>> operatingHoursCache = <String, Map<String, dynamic>>{}.obs;
//   RxBool isFetchingInitialData = true.obs;
//
//   final distanceOptions = ['1 mi', '3 mi', '5 mi', '10 mi', '25 mi', 'All'];
//   RxInt selectedDistance = 0.obs;
//
//   final FilterController filterCtrl = Get.put(FilterController());
//   final FilterSelectionController filterSelectionCtrl =
//       Get.find<FilterSelectionController>();
//   final TextEditingController searchController = TextEditingController();
//   RxBool searchToggle = true.obs;
//   final _searchSubject = BehaviorSubject<String>.seeded('');
//   ScrollController scrollController = ScrollController();
//   var selectedLetter = ''.obs;
//   List top = ['Most Reviewed', 'Discount', 'Dining'];
//   RxString selectedTop = ''.obs;
//   var selectedDiscount = '10%'.obs;
//   RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
//   List<RestaurantModel> allRestaurants = [];
//   List<RestaurantModel> filteredRestaurants = [];
//   Map<String, List<String>> cusinesMapFilter = {};
//   DocumentSnapshot? lastDocument;
//   bool isLoading = false;
//   int limit = 10;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   final Rx<Stream<List<RestaurantModel>>> filteredRestaurantsStream = Rx<Stream<List<RestaurantModel>>>(Stream.value([]));
//
//   // @override
//   // void onInit() {
//   //   super.onInit();
//   //   _searchSubject.add('');
//   //   searchController.addListener(() {
//   //     _searchSubject.add(searchController.text);
//   //   });
//   //   _searchSubject
//   //       .debounceTime(const Duration(milliseconds: 300))
//   //       .listen((query) {
//   //     update();
//   //   });
//   //
//   //   fetchInitialData();
//   // }
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchUserPosition(Get.context!);
//     applySearchAndFilters();
//   }
//
//   @override
//   void onClose() {
//     scrollController.dispose();
//     _searchSubject.close();
//     searchController.dispose();
//     super.onClose();
//   }
//
//   Future<void> fetchInitialData() async {
//     isFetchingInitialData.value = true;
//     print('Fetching initial data: user position and operating hours');
//     // Fetch user position
//     try {
//       Position position = await getCurrentLocation(Get.context!);
//       userPosition = position;
//       print('User position fetched: ${position.latitude}, ${position.longitude}');
//     } catch (e) {
//       print('Error fetching user position: $e');
//       userPosition = null;
//     }
//     // Fetch initial restaurants and pre-fetch operating hours
//     var restaurantsStream = await getAllRestaurantsFiltered().first;
//     for (var restaurant in restaurantsStream) {
//       await getOperatingHours(restaurant.docID); // Pre-fetch to populate cache
//     }
//     isFetchingInitialData.value = false;
//   }
//
//   Future<void> fetchUserPosition(BuildContext context) async {
//     if (userPosition != null) return;
//     try {
//       userPosition = await getCurrentLocation(context);
//     } catch (e) {
//       print('Error fetching user position: $e');
//       // Optionally handle error, e.g., show a snackbar
//     }
//   }
//
//   void initailizedSelectors({required List<RestaurantModel> resaturantsList}) {
//     selectedPersentage.clear();
//     selectedHappyhour.clear();
//     if (selectedHappyhour.isNotEmpty) {
//       selectedHappyhour[0] = true;
//     }
//     if (selectedPersentage.isNotEmpty) {
//       selectedPersentage[0] = true;
//     }
//   }
//
//   void scrollLeft() {
//     scrollController.animateTo(
//       scrollController.offset - 300,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   void scrollRight() {
//     scrollController.animateTo(
//       scrollController.offset + 300,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   List<RestaurantModel> resaturant_list = [];
//
//   void addFavoriteResturants({required String restaurantID}) async {
//     try {
//       var favCollection = FirebaseFirestore.instance
//           .collection('users')
//           .doc(auth.currentUser!.uid)
//           .collection('favorite');
//
//       var existingFav = await favCollection
//           .where('resturantID', isEqualTo: restaurantID)
//           .get();
//
//       if (existingFav.docs.isEmpty) {
//         String favId = favCollection.doc().id;
//         await favCollection.doc(favId).set({
//           'resturantID': restaurantID,
//           'favID': favId,
//         });
//       } else {
//         for (var doc in existingFav.docs) {
//           await doc.reference.delete();
//         }
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   Future<void> addRestaurantReview({
//     required String restaurantID,
//     required List<File> images,
//     required double starRating,
//     required String description,
//   }) async {
//     try {
//       loadingDialog(message: 'Please wait!', loading: true, height: 150);
//       List<String> imagesLinks = [];
//       for (var v in images) {
//         imagesLinks
//             .add(await uploadImageToFirebase('reviews', v.readAsBytesSync()));
//       }
//       var reviewCollection = FirebaseFirestore.instance
//           .collection('restaurants')
//           .doc(restaurantID)
//           .collection('reviews');
//
//       String reviewId = reviewCollection.doc().id;
//       await reviewCollection.doc(reviewId).set({
//         'reviewID': reviewId,
//         'restaurantID': restaurantID,
//         'userName': currentUserDataModel?.value.username.text,
//         'userID': auth.currentUser?.uid,
//         'images': imagesLinks,
//         'starRating': starRating,
//         'description': description,
//         'dateTime': FieldValue.serverTimestamp(),
//       });
//       print('Review added successfully!');
//       Get.back();
//     } catch (e) {
//       Get.back();
//       print('Error adding review: $e');
//     }
//   }
//
//   Stream<List<ReviewModel>> getReviews(String restaurantID) {
//     return FirebaseFirestore.instance
//         .collection('restaurants')
//         .doc(restaurantID)
//         .collection('reviews')
//         .orderBy('dateTime', descending: true)
//         .snapshots()
//         .map((querySnapshot) {
//       return querySnapshot.docs.map((doc) {
//         return ReviewModel.fromFirestore(doc.data() as Map<String, dynamic>);
//       }).toList();
//     });
//   }
//
//   Stream<List<RestaurantModel>> getTrendingRestaurants() {
//     return FirebaseFirestore.instance
//         .collection('restaurants')
//         .where('averageRating', isGreaterThan: 0)
//         .orderBy('averageRating', descending: true)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return RestaurantModel.fromDocumentSnapshot(
//             doc as DocumentSnapshot<Map<String, dynamic>>);
//       }).toList();
//     });
//   }
//
//   void addRecentView({required String restaurantID, resName}) async {
//     List<String> localStoreResturatnstID =
//         preferences?.getStringList('recentView') ?? [];
//
//     if (!localStoreResturatnstID.contains(resName)) {
//       localStoreResturatnstID.add(resName);
//       await preferences?.setStringList('recentView', localStoreResturatnstID);
//     }
//
//     try {
//       var reviewCollection = FirebaseFirestore.instance
//           .collection('users')
//           .doc(auth.currentUser?.uid)
//           .collection('recentView');
//
//       var existingView = await reviewCollection
//           .where('userID', isEqualTo: auth.currentUser?.uid)
//           .where('restaurantID', isEqualTo: restaurantID)
//           .limit(1)
//           .get();
//
//       if (existingView.docs.isNotEmpty) {
//         String existingViewId = existingView.docs.first.id;
//         await reviewCollection.doc(existingViewId).update({
//           'dateTime': FieldValue.serverTimestamp(),
//         });
//         print('Recent view updated successfully!');
//       } else {
//         String recentViewId = reviewCollection.doc().id;
//         await reviewCollection.doc(recentViewId).set({
//           'recentViewID': recentViewId,
//           'restaurantID': restaurantID,
//           'userName': currentUserDataModel?.value.username.text,
//           'userID': auth.currentUser?.uid,
//           'dateTime': FieldValue.serverTimestamp(),
//         });
//         print('Recent view added successfully!');
//       }
//     } catch (e) {
//       Get.back();
//       print('Error adding or updating recent view: $e');
//     }
//   }
//
//   Stream<List<RecentViewModel>> getRecentViews() {
//     var recentViewCollection = FirebaseFirestore.instance
//         .collection('users')
//         .doc(auth.currentUser?.uid)
//         .collection('recentView');
//
//     return recentViewCollection.snapshots().map((querySnapshot) {
//       return querySnapshot.docs.map((doc) {
//         return RecentViewModel.fromMap(doc.data());
//       }).toList();
//     });
//   }
//
//   Stream<List<RestaurantModel>> getRestaurants() {
//     return _firestore
//         .collection('restaurants')
//         .orderBy('createdAt', descending: true)
//         .limit(limit)
//         .snapshots()
//         .asyncMap((snapshot) async {
//       if (snapshot.docs.isNotEmpty) {
//         lastDocument = snapshot.docs.last;
//       }
//
//       List<RestaurantModel> restaurantsList = await Future.wait(
//         snapshot.docs.map((doc) async {
//           final restaurant = RestaurantModel.fromDocumentSnapshot(
//               doc as DocumentSnapshot<Map<String, dynamic>>);
//           return restaurant;
//         }),
//       );
//
//       restaurants.assignAll(restaurantsList.where((item) => item.resName
//           .toLowerCase()
//           .contains(_searchSubject.value.toLowerCase())));
//       update();
//       return restaurantsList;
//     });
//   }
//
//   Future<void> loadMoreRestaurants() async {
//     try {
//       if (isLoading || lastDocument == null) return;
//
//       isLoading = true;
//       update();
//
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('restaurants')
//           .orderBy('createdAt', descending: true)
//           .startAfterDocument(lastDocument!)
//           .limit(limit)
//           .get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         lastDocument = querySnapshot.docs.last;
//
//         final newRestaurants = await Future.wait(
//           querySnapshot.docs.map((doc) async {
//             final restaurant = RestaurantModel.fromDocumentSnapshot(
//                 doc as DocumentSnapshot<Map<String, dynamic>>);
//             return restaurant;
//           }),
//         );
//
//         restaurants.addAll(newRestaurants);
//         update();
//         print('restaurants updated: ${restaurants.length}');
//       }
//
//       isLoading = false;
//       update();
//     } catch(e){
//       isLoading = false;
//       update();
//       print('eror: ${e.toString()}');
//     }
//   }
//
//   Stream<List<RestaurantModel>> getAllRestaurants() {
//     return _firestore
//         .collection('restaurants')
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .asyncMap((snapshot) async {
//       if (snapshot.docs.isNotEmpty) {
//         lastDocument = snapshot.docs.last;
//       }
//
//       List<RestaurantModel> restaurantsList = await Future.wait(
//         snapshot.docs.map((doc) async {
//           final restaurant = RestaurantModel.fromDocumentSnapshot(
//               doc as DocumentSnapshot<Map<String, dynamic>>);
//           return restaurant;
//         }),
//       );
//
//       restaurants.assignAll(restaurantsList);
//       update();
//       return restaurantsList;
//     });
//   }
//
//   Stream<List<RestaurantModel>> getFilteredRestaurants() {
//     final filterCtrl = Get.find<FilterController>();
//     return FirebaseFirestore.instance
//         .collection('restaurants')
//         .snapshots()
//         .map((snapshot) {
//       var restaurants = snapshot.docs
//           .map((doc) => RestaurantModel.fromDocumentSnapshot(doc))
//           .toList();
//
//       // Apply category filters
//       for (var category in filterCtrl.selectedFilters.keys) {
//         final selectedOptions = filterCtrl.selectedFilters[category];
//         if (selectedOptions != null && selectedOptions.isNotEmpty) {
//           restaurants = restaurants.where((restaurant) {
//             if (category == 'Dietary') {
//               return selectedOptions.any((option) => restaurant.dietaryList.contains(option));
//             } else if (category == 'Atmosphere') {
//               return selectedOptions.any((option) => restaurant.atmosphereList.contains(option));
//             } else if (category == 'Vibes') {
//               return selectedOptions.any((option) => restaurant.vibesList.contains(option));
//             } else if (category == 'Price') {
//               return selectedOptions.any((option) => restaurant.priceRange == option);
//             } else if (category == 'Time') {
//               return true; // Handled in UI via operatingHoursCache
//             }
//             return true;
//           }).toList();
//         }
//       }
//
//       return restaurants;
//     });
//   }
//
//   Stream<List<RestaurantModel>> getEntertainmentRestaurants() {
//     return FirebaseFirestore.instance
//         .collection('restaurants')
//         .where('entertainmentScheduleList', isGreaterThan: [])
//         .snapshots()
//         .asyncMap((snapshot) async {
//           final restaurants = await Future.wait(
//             snapshot.docs.map((doc) async {
//               final restaurant = RestaurantModel.fromDocumentSnapshot(
//                   doc as DocumentSnapshot<Map<String, dynamic>>);
//               return restaurant;
//             }),
//           );
//           return restaurants;
//         });
//   }
//
//   bool isOfferValidForCurrentDate(String fromDate, String toDate) {
//     try {
//       DateTime currentDate = DateTime.now().toLocal();
//       DateTime now =
//           DateTime(currentDate.year, currentDate.month, currentDate.day);
//
//       DateTime fromDateTime = DateFormat("dd/MM/yy").parse(fromDate);
//       DateTime toDateTime = DateFormat("dd/MM/yy").parse(toDate);
//
//       return (now.isAfter(fromDateTime) ||
//               now.isAtSameMomentAs(fromDateTime)) &&
//           (now.isBefore(toDateTime) || now.isAtSameMomentAs(toDateTime));
//     } catch (e) {
//       print("Error parsing dates: $e");
//       return false;
//     }
//   }
//
//   void initializeSelectors(List<RestaurantModel> screenRestaurants) {
//     allRestaurants = screenRestaurants;
//     filteredRestaurants = screenRestaurants;
//     update();
//   }
//
//   void initializeCuisinesSelectors(Map<String, List<String>> cuisines) {
//     cusinesMapFilter = cuisines;
//     update();
//   }
//
//   void filterRestaurants(String query) {
//     if (query.isEmpty) {
//       filteredRestaurants = allRestaurants;
//     } else {
//       filteredRestaurants = allRestaurants
//           .where((restaurant) => restaurant.resName
//               .toLowerCase()
//               .contains(query.toLowerCase().trim()))
//           .toList();
//     }
//     update();
//   }
//
//   Future<Position> getCurrentLocation(BuildContext context) async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//
//     while (!serviceEnabled) {
//       bool? enableLocation = await showDialog<bool>(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Location Services Disabled'),
//             content: const Text('Please enable location services to continue.'),
//             actions: [
//               TextButton(
//                 child: const Text('Cancel'),
//                 onPressed: () {
//                   Navigator.of(context).pop(false);
//                 },
//               ),
//               TextButton(
//                 child: const Text('Open Settings'),
//                 onPressed: () async {
//                   await Geolocator.openLocationSettings();
//                   Navigator.of(context).pop(true);
//                 },
//               ),
//             ],
//           );
//         },
//       );
//
//       if (enableLocation == false) {
//         return Future.error('Location services are disabled.');
//       }
//
//       serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.deniedForever) {
//         return Future.error('Location permissions are permanently denied.');
//       }
//     }
//
//     return await Geolocator.getCurrentPosition();
//   }
//
//   bool isWithinRadius(
//       Position userLocation, double restLat, double restLng, double radiusKm) {
//     double distance = Geolocator.distanceBetween(
//         userLocation.latitude, userLocation.longitude, restLat, restLng);
//     return distance <= radiusKm * 1000;
//   }
//
//   Widget favoriteHeart({resturant_id}) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(auth.currentUser?.uid)
//           .collection('favorite')
//           .where('resturantID', isEqualTo: resturant_id)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Icon(
//             Icons.favorite_border_outlined,
//             size: 22,
//             color: AppColors.primaryColor,
//           );
//         }
//
//         if (snapshot.hasError) {
//           return Icon(
//             Icons.favorite_border_outlined,
//             size: 22,
//             color: AppColors.primaryColor,
//           );
//         }
//
//         bool isFavorite = snapshot.data?.docs.isNotEmpty ?? false;
//
//         return InkWell(
//           onTap: () async {
//             if (isFavorite) {
//               await FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(auth.currentUser!.uid)
//                   .collection('favorite')
//                   .where('resturantID', isEqualTo: resturant_id)
//                   .get()
//                   .then((snapshot) {
//                 for (var doc in snapshot.docs) {
//                   doc.reference.delete();
//                 }
//               });
//               await updateAverageRating(
//                   isRate: true, resturant_id: resturant_id);
//             } else {
//               String favId = FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(auth.currentUser!.uid)
//                   .collection('favorite')
//                   .doc()
//                   .id;
//
//               await FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(auth.currentUser!.uid)
//                   .collection('favorite')
//                   .doc(favId)
//                   .set({
//                 'resturantID': resturant_id,
//                 'favID': favId,
//               });
//               await updateAverageRating(
//                   isRate: false, resturant_id: resturant_id);
//             }
//           },
//           child: isFavorite
//               ? Image.asset(
//                   'assets/images/heart_icon.png',
//                   color: AppColors.primaryColor,
//                   height: 22,
//                   width: 22,
//                 )
//               : Icon(
//                   Icons.favorite_border_outlined,
//                   size: 22,
//                   color: AppColors.primaryColor,
//                 ),
//         );
//       },
//     );
//   }
//
//   Future<void> updateAverageRating({required bool isRate, resturant_id}) async {
//     final DocumentReference docRef =
//         FirebaseFirestore.instance.collection('restaurants').doc(resturant_id);
//
//     try {
//       await docRef.update({
//         'averageRating': FieldValue.increment(!isRate ? 1 : -1),
//       });
//       print('Rating updated successfully');
//     } catch (e) {
//       print('Failed to update rating: $e');
//     }
//   }
//
//   Stream<Map<String, dynamic>?> getFeaturedRestaurantID() {
//     return FirebaseFirestore.instance
//         .collection('featured')
//         .doc('mainFeatured')
//         .snapshots()
//         .map((snapshot) {
//       if (snapshot.exists) {
//         return snapshot.data();
//       }
//       return null;
//     });
//   }
//
//   Stream<RestaurantModel?> getFeaturedRestaurants({required String restID}) {
//     return _firestore
//         .collection('restaurants')
//         .where('docID', isEqualTo: restID)
//         .snapshots()
//         .map((snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         final doc = snapshot.docs.first;
//         lastDocument = snapshot.docs.last;
//         return RestaurantModel.fromDocumentSnapshot(
//             doc as DocumentSnapshot<Map<String, dynamic>>);
//       } else {
//         return null;
//       }
//     });
//   }
//
//   Future<Map<String, dynamic>?> getOperatingHours(String restaurantId) async {
//     if (operatingHoursCache.containsKey(restaurantId)) {
//       print('Returning cached operating hours for $restaurantId');
//       return operatingHoursCache[restaurantId];
//     }
//     try {
//       String currentDay = DateFormat('EEEE').format(DateTime.now());
//       var operatingHoursDoc = await FirebaseFirestore.instance
//           .collection('restaurants')
//           .doc(restaurantId)
//           .collection('operatingHours')
//           .doc(currentDay)
//           .get();
//       Map<String, dynamic> data = operatingHoursDoc.exists ? (operatingHoursDoc.data() ?? {}) : {};
//       operatingHoursCache[restaurantId] = data;
//       operatingHoursCache.refresh();
//       print('Fetched operating hours for $restaurantId: $data');
//       return data;
//     } catch (e) {
//       print('Error fetching operating hours for $restaurantId: $e');
//       operatingHoursCache[restaurantId] = {};
//       operatingHoursCache.refresh();
//       return {};
//     }
//   }
//
//   Future<List<RestaurantModel>> getFilteredByTimeOfDay(
//       List<RestaurantModel> restaurants) async {
//     List<RestaurantModel> filteredRestaurants = [];
//     List<String> timeOfDayList =
//         filterCtrl.selectedFilters['Time']?.toList() ?? [];
//
//     for (var restaurant in restaurants) {
//       var operatingHours = await getOperatingHours(restaurant.docID);
//       if (operatingHours != null) {
//         for (var timeOfDay in timeOfDayList) {
//           if (operatingHours.containsKey(timeOfDay)) {
//             var timeSlot = operatingHours[timeOfDay];
//             var isClosed = timeSlot['isClosed'] ?? false;
//             if (!isClosed) {
//               filteredRestaurants.add(restaurant);
//               break;
//             }
//           }
//         }
//       }
//     }
//     return filteredRestaurants;
//   }
//
//   List<RestaurantModel> filterRestaurantsWithFilters(
//       List<RestaurantModel> restaurants, String query) {
//     query = query.toLowerCase();
//     final int? queryNumber = int.tryParse(query);
//     List<String> selectedFilters =
//         filterCtrl.selectedFilters.values.expand((list) => list).toList();
//     selectedFilters.addAll([
//       filterCtrl.selectedCity.value,
//       filterCtrl.selectedCountry.value
//     ].where((e) => e.isNotEmpty));
//
//     return restaurants.where((restaurant) {
//       bool filterMatch = true;
//       if (selectedFilters.isNotEmpty) {
//         filterMatch = selectedFilters.any((filter) {
//           filter = filter.toLowerCase();
//           return restaurant.menuList.any(
//                   (menu) => menu.cuisineType.toLowerCase().contains(filter)) ||
//               restaurant.city.toLowerCase().contains(filter) ||
//               restaurant.country.toLowerCase().contains(filter) ||
//               restaurant.atmosphereList.any(
//                   (atmosphere) => atmosphere.toLowerCase().contains(filter)) ||
//               restaurant.entertainmentScheduleList.any((schedule) =>
//                   schedule.eventName.toLowerCase().contains(filter)) ||
//               restaurant.dietaryList
//                   .any((dietary) => dietary.toLowerCase().contains(filter)) ||
//               restaurant.priceRange.toLowerCase().contains(filter);
//         });
//       }
//
//       if (query.isEmpty) {
//         return filterMatch;
//       }
//
//       return filterMatch &&
//           (queryNumber != null
//               ? restaurant.zipCode == query
//               : restaurant.resName.toLowerCase().contains(query) ||
//                   restaurant.city.toLowerCase().contains(query) ||
//                   restaurant.address.toLowerCase().contains(query) ||
//                   restaurant.zipCode.toLowerCase().contains(query) ||
//                   restaurant.menuList.any((item) =>
//                       item.cuisineType.toLowerCase().contains(query)) ||
//                   restaurant.country.toLowerCase().contains(query) ||
//                   restaurant.about.toLowerCase().contains(query) ||
//                   restaurant.socialLink.toLowerCase().contains(query) ||
//                   restaurant.priceRange.toLowerCase().contains(query) ||
//                   restaurant.specialConditions.toLowerCase().contains(query) ||
//                   restaurant.spokenLanguage.toLowerCase().contains(query) ||
//                   restaurant.entertainmentScheduleList.any((item) =>
//                       item.eventName.toLowerCase().contains(query) ||
//                       item.eventBy.toLowerCase().contains(query)) ||
//                   restaurant.facilityList.any(
//                       (facility) => facility.toLowerCase().contains(query)) ||
//                   restaurant.dietaryList.any(
//                       (dietary) => dietary.toLowerCase().contains(query)) ||
//                   restaurant.atmosphereList.any((atmosphere) =>
//                       atmosphere.toLowerCase().contains(query)));
//     }).toList();
//   }
//
//   Future<List<RestaurantModel>> getNearbyRestaurants(
//       List<RestaurantModel> restaurants,
//       double radiusKm,
//       BuildContext context) async {
//     Position userLocation = await getCurrentLocation(context);
//     List<String> selectedFilters =
//         filterCtrl.selectedFilters.values.expand((list) => list).toList();
//     selectedFilters.addAll([
//       filterCtrl.selectedCity.value,
//       filterCtrl.selectedCountry.value
//     ].where((e) => e.isNotEmpty));
//
//     List<RestaurantModel> timeFilteredRestaurants =
//         (filterCtrl.selectedFilters['Time']?.isNotEmpty ?? false)
//             ? await getFilteredByTimeOfDay(restaurants)
//             : restaurants;
//
//     return timeFilteredRestaurants.where((restaurant) {
//       bool withinRadius = isWithinRadius(
//         userLocation,
//         restaurant.latitude,
//         restaurant.longitude,
//         radiusKm,
//       );
//
//       bool filterMatch = true;
//       if (selectedFilters.isNotEmpty) {
//         filterMatch = selectedFilters.any((filter) {
//           filter = filter.toLowerCase();
//           return restaurant.menuList.any(
//                   (menu) => menu.cuisineType.toLowerCase().contains(filter)) ||
//               restaurant.city.toLowerCase().contains(filter) ||
//               restaurant.country.toLowerCase().contains(filter) ||
//               restaurant.atmosphereList.any(
//                   (atmosphere) => atmosphere.toLowerCase().contains(filter)) ||
//               restaurant.entertainmentScheduleList.any((schedule) =>
//                   schedule.eventName.toLowerCase().contains(filter)) ||
//               restaurant.dietaryList
//                   .any((dietary) => dietary.toLowerCase().contains(filter)) ||
//               restaurant.priceRange.toLowerCase().contains(filter);
//         });
//       }
//
//       return withinRadius && filterMatch;
//     }).toList();
//   }
//   Stream<List<String>> getFavoriteRestaurantIds() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return Stream.value([]);
//     }
//     return FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('favorite')
//         .snapshots()
//         .map((snapshot) =>
//         snapshot.docs.map((doc) => doc.id).toList());
//   }
//
//   Stream<List<RestaurantModel>> getExperienceVibesRestaurants() {
//     return FirebaseFirestore.instance
//         .collection('restaurants')
//         .snapshots()
//         .asyncMap((snapshot) async {
//       List<RestaurantModel> restaurantsList = await Future.wait(
//         snapshot.docs.map((doc) async {
//           final restaurant = RestaurantModel.fromDocumentSnapshot(
//               doc as DocumentSnapshot<Map<String, dynamic>>);
//           return restaurant;
//         }),
//       );
//
//       List<String> selectedFilters =
//           filterCtrl.selectedFilters['Vibes']?.toList() ?? [];
//       selectedFilters
//           .addAll(filterCtrl.selectedFilters['Experience']?.toList() ?? []);
//       if (selectedFilters.isEmpty) {
//         return restaurantsList
//             .where((r) =>
//                 r.atmosphereList.isNotEmpty ||
//                 r.entertainmentScheduleList.isNotEmpty)
//             .toList();
//       }
//
//       return restaurantsList.where((restaurant) {
//         return selectedFilters.any((filter) {
//           filter = filter.toLowerCase();
//           return restaurant.atmosphereList.any(
//                   (atmosphere) => atmosphere.toLowerCase().contains(filter)) ||
//               restaurant.entertainmentScheduleList.any((schedule) =>
//                   schedule.eventName.toLowerCase().contains(filter));
//         });
//       }).toList();
//     });
//   }
//
//   Stream<List<RestaurantModel>> getAllRestaurantsFiltered() {
//     return _firestore
//         .collection('restaurants')
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .asyncMap((snapshot) async {
//       if (snapshot.docs.isNotEmpty) {
//         lastDocument = snapshot.docs.last;
//       } else {
//         lastDocument = null;
//       }
//
//       List<RestaurantModel> restaurantsList = await Future.wait(
//         snapshot.docs.map((doc) async {
//           final restaurant = RestaurantModel.fromDocumentSnapshot(
//               doc as DocumentSnapshot<Map<String, dynamic>>);
//           // Pre-fetch operating hours for each restaurant
//           if (!operatingHoursCache.containsKey(restaurant.docID)) {
//             await getOperatingHours(restaurant.docID);
//           }
//           return restaurant;
//         }),
//       );
//
//       restaurantsList = await compute(filterRestaurantsWithNewFiltersStatic, {
//         'restaurants': restaurantsList,
//         'query': _searchSubject.value,
//         'selectedFilters': filterCtrl.selectedFilters.values.expand((list) => list).toList(),
//         'selectedTimeOfDay': filterCtrl.selectedFilters['Time']?.toList() ?? [],
//         'selectedAtmosphere': filterCtrl.selectedFilters['Vibes']?.toList() ?? [],
//         'selectedEntertainment': filterCtrl.selectedFilters['Experience']?.toList() ?? [],
//         'selectedDietary': filterCtrl.selectedFilters['Dietary']?.toList() ?? [],
//         'selectedCity': filterCtrl.selectedCity.value,
//         'selectedCountry': filterCtrl.selectedCountry.value,
//         'operatingHoursCache': operatingHoursCache,
//       });
//
//       restaurants.assignAll(restaurantsList);
//       print('Filtered restaurants fetched: ${restaurantsList.length}');
//       return restaurantsList;
//     }).handleError((error) {
//       print('Firestore error: $error');
//       return [];
//     });
//   }
//
//   Stream<List<RestaurantModel>> getExperienceVibesRestaurantsFiltered() {
//     return _firestore
//         .collection('restaurants')
//         .snapshots()
//         .asyncMap((snapshot) async {
//       if (snapshot.docs.isNotEmpty) {
//         lastDocument = snapshot.docs.last;
//       } else {
//         lastDocument = null;
//       }
//
//       List<RestaurantModel> restaurantsList = await Future.wait(
//         snapshot.docs.map((doc) async {
//           return RestaurantModel.fromDocumentSnapshot(
//               doc as DocumentSnapshot<Map<String, dynamic>>);
//         }),
//       );
//
//       List<String> selectedFilters =
//           filterCtrl.selectedFilters['Vibes']?.toList() ?? [];
//       selectedFilters
//           .addAll(filterCtrl.selectedFilters['Experience']?.toList() ?? []);
//
//       if (selectedFilters.isEmpty) {
//         restaurantsList = restaurantsList
//             .where((r) =>
//                 r.atmosphereList.isNotEmpty ||
//                 r.entertainmentScheduleList.isNotEmpty)
//             .toList();
//       } else {
//         restaurantsList = restaurantsList.where((restaurant) {
//           return selectedFilters.any((filter) {
//             filter = filter.toLowerCase();
//             return restaurant.atmosphereList
//                     .any((atmosphere) => atmosphere.toLowerCase() == filter) ||
//                 restaurant.entertainmentScheduleList.any(
//                     (schedule) => schedule.eventName.toLowerCase() == filter);
//           });
//         }).toList();
//       }
//
//       Map<String, Map<String, dynamic>?> operatingHoursCache = {};
//       for (var restaurant in restaurantsList) {
//         operatingHoursCache[restaurant.docID] =
//             await getOperatingHours(restaurant.docID);
//       }
//
//       restaurantsList = await compute(filterRestaurantsWithNewFiltersStatic, {
//         'restaurants': restaurantsList,
//         'query': _searchSubject.value,
//         'selectedFilters':
//             filterCtrl.selectedFilters.values.expand((list) => list).toList(),
//         'selectedTimeOfDay': filterCtrl.selectedFilters['Time']?.toList() ?? [],
//         'selectedAtmosphere':
//             filterCtrl.selectedFilters['Vibes']?.toList() ?? [],
//         'selectedEntertainment':
//             filterCtrl.selectedFilters['Experience']?.toList() ?? [],
//         'selectedDietary':
//             filterCtrl.selectedFilters['Dietary']?.toList() ?? [],
//         'selectedCity': filterCtrl.selectedCity.value,
//         'selectedCountry': filterCtrl.selectedCountry.value,
//         'operatingHoursCache': operatingHoursCache,
//       });
//
//       print(
//           'Filtered Experience & Vibes restaurants: ${restaurantsList.length}');
//       return restaurantsList;
//     }).handleError((error) {
//       print('Firestore error: $error');
//       return [];
//     });
//   }
//
//   Future<List<RestaurantModel>> filterRestaurantsWithNewFilters(
//       Map<String, dynamic> params) async {
//     List<RestaurantModel> restaurants =
//         params['restaurants'] as List<RestaurantModel>;
//     String query = params['query'] as String;
//     List<String> selectedFilters = params['selectedFilters'] as List<String>;
//     List<String> selectedTimeOfDay =
//         params['selectedTimeOfDay'] as List<String>;
//     List<String> selectedAtmosphere =
//         params['selectedAtmosphere'] as List<String>;
//     List<String> selectedEntertainment =
//         params['selectedEntertainment'] as List<String>;
//     List<String> selectedDietary = params['selectedDietary'] as List<String>;
//     String selectedCity = params['selectedCity'] as String;
//     String selectedCountry = params['selectedCountry'] as String;
//
//     query = query.toLowerCase();
//     final int? queryNumber = int.tryParse(query);
//
//     List<RestaurantModel> filtered = [];
//     for (var restaurant in restaurants) {
//       bool filterMatch = true;
//
//       if (selectedFilters.isNotEmpty) {
//         filterMatch &= selectedFilters.any((filter) => restaurant.menuList.any(
//             (menu) => menu.cuisineType.toLowerCase() == filter.toLowerCase()));
//       }
//
//       if (selectedTimeOfDay.isNotEmpty) {
//         var operatingHours = await getOperatingHours(restaurant.docID);
//         filterMatch &= operatingHours != null &&
//             selectedTimeOfDay.any((time) =>
//                 operatingHours.containsKey(time) &&
//                 !(operatingHours[time]['isClosed'] ?? true));
//       }
//
//       if (selectedAtmosphere.isNotEmpty) {
//         filterMatch &= selectedAtmosphere.any((atmosphere) => restaurant
//             .atmosphereList
//             .any((a) => a.toLowerCase() == atmosphere.toLowerCase()));
//       }
//
//       if (selectedEntertainment.isNotEmpty) {
//         filterMatch &= selectedEntertainment.any((event) => restaurant
//             .entertainmentScheduleList
//             .any((e) => e.eventName.toLowerCase() == event.toLowerCase()));
//       }
//
//       if (selectedDietary.isNotEmpty) {
//         filterMatch &= selectedDietary.any((diet) => restaurant.dietaryList
//             .any((d) => d.toLowerCase() == diet.toLowerCase()));
//       }
//
//       if (selectedCity.isNotEmpty) {
//         filterMatch &=
//             restaurant.city.toLowerCase() == selectedCity.toLowerCase();
//       }
//
//       if (selectedCountry.isNotEmpty) {
//         filterMatch &=
//             restaurant.country.toLowerCase() == selectedCountry.toLowerCase();
//       }
//
//       if (query.isNotEmpty) {
//         filterMatch &= (queryNumber != null
//             ? restaurant.zipCode == query
//             : restaurant.resName.toLowerCase().contains(query) ||
//                 restaurant.city.toLowerCase().contains(query) ||
//                 restaurant.address.toLowerCase().contains(query) ||
//                 restaurant.zipCode.toLowerCase().contains(query) ||
//                 restaurant.menuList.any(
//                     (item) => item.cuisineType.toLowerCase().contains(query)) ||
//                 restaurant.country.toLowerCase().contains(query) ||
//                 restaurant.about.toLowerCase().contains(query) ||
//                 restaurant.socialLink.toLowerCase().contains(query) ||
//                 restaurant.priceRange.toLowerCase().contains(query) ||
//                 restaurant.specialConditions.toLowerCase().contains(query) ||
//                 restaurant.spokenLanguage.toLowerCase().contains(query) ||
//                 restaurant.entertainmentScheduleList.any((item) =>
//                     item.eventName.toLowerCase().contains(query) ||
//                     item.eventBy.toLowerCase().contains(query)) ||
//                 restaurant.facilityList.any(
//                     (facility) => facility.toLowerCase().contains(query)) ||
//                 restaurant.dietaryList
//                     .any((dietary) => dietary.toLowerCase().contains(query)) ||
//                 restaurant.atmosphereList.any(
//                     (atmosphere) => atmosphere.toLowerCase().contains(query)));
//       }
//
//       if (filterMatch) {
//         filtered.add(restaurant);
//       }
//     }
//
//     print('Filtered restaurants: ${filtered.length}');
//     return filtered;
//   }
//
//   static Future<List<RestaurantModel>> filterRestaurantsWithNewFiltersStatic(
//       Map<String, dynamic> params) async {
//     List<RestaurantModel> restaurants =
//         params['restaurants'] as List<RestaurantModel>;
//     String query = params['query'] as String;
//     List<String> selectedFilters = params['selectedFilters'] as List<String>;
//     List<String> selectedTimeOfDay =
//         params['selectedTimeOfDay'] as List<String>;
//     List<String> selectedAtmosphere =
//         params['selectedAtmosphere'] as List<String>;
//     List<String> selectedEntertainment =
//         params['selectedEntertainment'] as List<String>;
//     List<String> selectedDietary = params['selectedDietary'] as List<String>;
//     String selectedCity = params['selectedCity'] as String;
//     String selectedCountry = params['selectedCountry'] as String;
//     Map<String, Map<String, dynamic>?> operatingHoursCache =
//         params['operatingHoursCache'] as Map<String, Map<String, dynamic>?>;
//
//     query = query.toLowerCase();
//     final int? queryNumber = int.tryParse(query);
//
//     List<RestaurantModel> filtered = [];
//     for (var restaurant in restaurants) {
//       bool filterMatch = true;
//
//       if (selectedFilters.isNotEmpty) {
//         filterMatch &= selectedFilters.any((filter) => restaurant.menuList.any(
//             (menu) => menu.cuisineType.toLowerCase() == filter.toLowerCase()));
//       }
//
//       if (selectedTimeOfDay.isNotEmpty) {
//         var operatingHours = operatingHoursCache[restaurant.docID];
//         filterMatch &= operatingHours != null &&
//             selectedTimeOfDay.any((time) =>
//                 operatingHours.containsKey(time) &&
//                 !(operatingHours[time]['isClosed'] ?? true));
//       }
//
//       if (selectedAtmosphere.isNotEmpty) {
//         filterMatch &= selectedAtmosphere.any((atmosphere) => restaurant
//             .atmosphereList
//             .any((a) => a.toLowerCase() == atmosphere.toLowerCase()));
//       }
//
//       if (selectedEntertainment.isNotEmpty) {
//         filterMatch &= selectedEntertainment.any((event) => restaurant
//             .entertainmentScheduleList
//             .any((e) => e.eventName.toLowerCase() == event.toLowerCase()));
//       }
//
//       if (selectedDietary.isNotEmpty) {
//         filterMatch &= selectedDietary.any((diet) => restaurant.dietaryList
//             .any((d) => d.toLowerCase() == diet.toLowerCase()));
//       }
//
//       if (selectedCity.isNotEmpty) {
//         filterMatch &=
//             restaurant.city.toLowerCase() == selectedCity.toLowerCase();
//       }
//
//       if (selectedCountry.isNotEmpty) {
//         filterMatch &=
//             restaurant.country.toLowerCase() == selectedCountry.toLowerCase();
//       }
//
//       if (query.isNotEmpty) {
//         filterMatch &= (queryNumber != null
//             ? restaurant.zipCode == query
//             : restaurant.resName.toLowerCase().contains(query) ||
//                 restaurant.city.toLowerCase().contains(query) ||
//                 restaurant.address.toLowerCase().contains(query) ||
//                 restaurant.zipCode.toLowerCase().contains(query) ||
//                 restaurant.menuList.any(
//                     (item) => item.cuisineType.toLowerCase().contains(query)) ||
//                 restaurant.country.toLowerCase().contains(query) ||
//                 restaurant.about.toLowerCase().contains(query) ||
//                 restaurant.socialLink.toLowerCase().contains(query) ||
//                 restaurant.priceRange.toLowerCase().contains(query) ||
//                 restaurant.specialConditions.toLowerCase().contains(query) ||
//                 restaurant.spokenLanguage.toLowerCase().contains(query) ||
//                 restaurant.entertainmentScheduleList.any((item) =>
//                     item.eventName.toLowerCase().contains(query) ||
//                     item.eventBy.toLowerCase().contains(query)) ||
//                 restaurant.facilityList.any(
//                     (facility) => facility.toLowerCase().contains(query)) ||
//                 restaurant.dietaryList
//                     .any((dietary) => dietary.toLowerCase().contains(query)) ||
//                 restaurant.atmosphereList.any(
//                     (atmosphere) => atmosphere.toLowerCase().contains(query)));
//       }
//
//       if (filterMatch) {
//         filtered.add(restaurant);
//       }
//     }
//
//     print('Filtered restaurants (static): ${filtered.length}');
//     return filtered;
//   }
//
//   Future<List<RestaurantModel>> getNearbyRestaurantsFiltered(
//       List<RestaurantModel> restaurants,
//       double radiusKm,
//       BuildContext context) async {
//     try {
//       Position userLocation = await getCurrentLocation(context);
//       List<RestaurantModel> timeFilteredRestaurants =
//           (filterCtrl.selectedFilters['Time']?.isNotEmpty ?? false)
//               ? await getFilteredByTimeOfDay(restaurants)
//               : restaurants;
//
//       List<RestaurantModel> nearbyRestaurants =
//           timeFilteredRestaurants.where((restaurant) {
//         if (restaurant.latitude == 0.0 || restaurant.longitude == 0.0) {
//           print('Missing lat/lng for ${restaurant.resName}');
//           return true;
//         }
//         bool withinRadius = isWithinRadius(
//           userLocation,
//           restaurant.latitude,
//           restaurant.longitude,
//           radiusKm,
//         );
//         return withinRadius;
//       }).toList();
//
//       print('Nearby filtered restaurants: ${nearbyRestaurants.length}');
//       return nearbyRestaurants;
//     } catch (e) {
//       print('Error getting nearby restaurants: $e');
//       return restaurants;
//     }
//   }
//
//   RestaurantModel? findRestaurantForVideo(VideoModel video) {
//     try {
//       return restaurants.firstWhereOrNull(
//             (restaurant) =>
//         restaurant.resName == video.restaurantName &&
//             restaurant.zipCode == video.zipCode,
//         // Return null if not found
//       );
//     } catch (e) {
//       print('Error finding restaurant for video: $e');
//       return null;
//     }
//   }
//
//   Widget buildImage(String imagePath,
//       {BoxFit fit = BoxFit.cover, double? width, double? height}) {
//     if (imagePath.startsWith('http')) {
//       return CachedNetworkImage(
//         imageUrl: imagePath,
//         fit: fit,
//         width: width,
//         height: height,
//         placeholder: (context, url) =>
//             const Center(child: CircularProgressIndicator()),
//         errorWidget: (context, url, error) => Image.asset(
//           'assets/images/placeholder.jpg', // Add a placeholder image in assets
//           fit: fit,
//           width: width,
//           height: height,
//         ),
//       );
//     } else {
//       return Image.asset(
//         imagePath,
//         fit: fit,
//         width: width,
//         height: height,
//         errorBuilder: (context, error, stackTrace) => Image.asset(
//           'assets/images/placeholder.jpg',
//           fit: fit,
//           width: width,
//           height: height,
//         ),
//       );
//     }
//   }
//
//   void applySearchAndFilters() {
//     filteredRestaurantsStream.value = FirebaseFirestore.instance
//         .collection('restaurants')
//         .snapshots()
//         .map((snapshot) {
//       var restaurants = snapshot.docs
//           .map((doc) => RestaurantModel.fromDocumentSnapshot(doc))
//           .toList();
//
//       // Apply search query
//       if (searchController.text.isNotEmpty) {
//         final query = searchController.text.toLowerCase();
//         restaurants = restaurants.where((restaurant) {
//           return restaurant.resName.toLowerCase().contains(query) ||
//               restaurant.address.toLowerCase().contains(query) ||
//               restaurant.city.toLowerCase().contains(query) ||
//               restaurant.dietaryList.any((diet) => diet.toLowerCase().contains(query)) ||
//               restaurant.atmosphereList.any((atm) => atm.toLowerCase().contains(query)) ||
//               restaurant.vibesList.any((vibe) => vibe.toLowerCase().contains(query));
//         }).toList();
//       }
//
//       // Apply category filters
//       final filterCtrl = Get.find<FilterController>();
//       for (var category in filterCtrl.selectedFilters.keys) {
//         final selectedOptions = filterCtrl.selectedFilters[category];
//         if (selectedOptions != null && selectedOptions.isNotEmpty) {
//           restaurants = restaurants.where((restaurant) {
//             if (category == 'Dietary') {
//               return selectedOptions.any((option) => restaurant.dietaryList.contains(option));
//             } else if (category == 'Atmosphere') {
//               return selectedOptions.any((option) => restaurant.atmosphereList.contains(option));
//             } else if (category == 'Vibes') {
//               return selectedOptions.any((option) => restaurant.vibesList.contains(option));
//             } else if (category == 'Price') {
//               return selectedOptions.any((option) => restaurant.priceRange == option);
//             } else if (category == 'Time') {
//               return true; // Handled in UI via operatingHoursCache
//             }
//             return true;
//           }).toList();
//         }
//       }
//
//       // Apply distance filter
//       if (selectedDistance.value > 0 && userPosition != null) {
//         final maxDistanceKm = selectedDistance.value * 1.60934; // Convert miles to kilometers
//         restaurants = restaurants.where((restaurant) {
//           if (restaurant.latitude == 0.0 && restaurant.longitude == 0.0) {
//             return false;
//           }
//           final distance = Geolocator.distanceBetween(
//             userPosition!.latitude,
//             userPosition!.longitude,
//             restaurant.latitude,
//             restaurant.longitude,
//           ) / 1000; // Distance in kilometers
//           return distance <= maxDistanceKm;
//         }).toList();
//       }
//
//       return restaurants;
//     });
//   }
// }
