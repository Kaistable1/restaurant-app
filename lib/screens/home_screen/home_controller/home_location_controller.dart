import 'dart:developer';
import 'dart:io';
import 'dart:math';
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
import 'package:kaistable_website/screens/favorite_screen/controller/favorite_controller.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/filter_selection_controller.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/home_screen_controller.dart';
import 'package:kaistable_website/utils/loading.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import '../model/home-model.dart';
// Import your model

class HomeLocationController extends GetxController {
  RxList selectedPersentage = [].obs;
  RxList selectedHappyhour = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserLocation();
    // ... other init logic
  }

  initailizedSelectors({required List<RestaurantModel> resaturantsList}) {
    // Ensure the list is cleared before adding false values
    selectedPersentage.clear();
    selectedHappyhour.clear();

    // // Use forEach to add 'false' for each item in restaurant_list
    // resaturantsList.forEach((v) {
    //   for (var x in v.menuList.percentageOff) {
    //     if (x.discountType.toString().trim() == 'Happy Hour Special') {
    //       selectedHappyhour.add(false);
    //     } else if (x.discountType.toString().trim() == 'Percentage Off') {
    //       selectedPersentage.add(false);
    //     }
    //   }
    //   for (var x in v.menuList.happyHourSpecials) {
    //     if (x.discountType.toString().trim() == 'Happy Hour Special') {
    //       selectedHappyhour.add(false);
    //     } else if (x.discountType.toString().trim() == 'Percentage Off') {
    //       selectedPersentage.add(false);
    //     }
    //   }
    // });
    if (selectedHappyhour.isNotEmpty) {
      selectedHappyhour[0] = true;
    }
    if (selectedPersentage.isNotEmpty) {
      selectedPersentage[0] = true;
    }
  }

  final searchController = TextEditingController();
  // ScrollController to control the ListView scroll position
  ScrollController scrollController = ScrollController();
  var selectedLetter = ''.obs; // Observable variable to store selected index
  List top = [
    'Most Reviewed',
    'Discount',
    'Dining',
  ];
  RxString selectedTop = ''.obs;
  var selectedDiscount = '10%'.obs;
  RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  List<RestaurantModel> allRestaurants = [];
  List<RestaurantModel> filteredRestaurants = [];
  Map<String, List<String>> cusinesMapFilter = {};
  DocumentSnapshot? lastDocument;
  bool isLoading = false;
  int limit = 10;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List of CircleContainerModel objects
  final List<CircleContainerModel> circleItems = [
    CircleContainerModel(
      imgPath: 'assets/images/location_img1.png',
      titleText: 'Time Square',
      descriptionText: '14 restaurants',
    ),
    CircleContainerModel(
      imgPath: 'assets/images/location_img2.png',
      titleText: 'Midtown, Manhattan',
      descriptionText: '20 restaurants',
    ),
    CircleContainerModel(
      imgPath: 'assets/images/location_img3.png',
      titleText: 'Columbus Circle',
      descriptionText: '20 restaurants',
    ),
    CircleContainerModel(
      imgPath: 'assets/images/location_img1.png',
      titleText: 'Time Square',
      descriptionText: '14 restaurants',
    ),
  ];

  Rxn<Position> currentPosition = Rxn<Position>();

  Future<void> fetchUserLocation() async {
    try {
      currentPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  // Function to scroll left
  void scrollLeft() {
    scrollController.animateTo(
      scrollController.offset - 300, // Scroll left by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Function to scroll right
  void scrollRight() {
    scrollController.animateTo(
      scrollController.offset + 300, // Scroll right by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    scrollController.dispose(); // Dispose the controller when not in use
    super.onClose();
  }

  List<RestaurantModel> resaturant_list = [];

  addFavoriteResturants({required String restaurantID}) async {
    try {
      // Reference to the current user's favorite collection
      var favCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('favorite');

      // Check if the restaurant already exists in the favorite collection
      var existingFav = await favCollection
          .where('resturantID', isEqualTo: restaurantID)
          .get();

      if (existingFav.docs.isEmpty) {
        // If the restaurant doesn't exist, add it
        String favId = favCollection.doc().id;
        await favCollection.doc(favId).set({
          'resturantID': restaurantID,
          'favID': favId,
        });
      } else {
        // If the restaurant exists, remove it
        for (var doc in existingFav.docs) {
          await doc.reference.delete();
        }
      }
    } catch (e) {
      // Handle errors here
      print('Error: $e');
    }
  }

  addRestaurantReview({
    required String restaurantID,
    required List<File> images, // List of image URLs
    required double starRating, // Total star rating (1-5)
    required String description, // Description note
  }) async {
    try {
      loadingDialog(message: 'Please wait!', loading: true, height: 150);
      List<String> imagesLinks = [];
      for (var v in images) {
        imagesLinks
            .add(await uploadImageToFirebase('reviews', v.readAsBytesSync()));
      }
      print('restaurantID ------- $restaurantID');
      var reviewCollection = FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantID)
          .collection('reviews');

      // Create a new review ID
      String reviewId = reviewCollection.doc().id;

      // Add the review
      await reviewCollection.doc(reviewId).set({
        'reviewID': reviewId,
        'restaurantID': restaurantID,
        'userName': currentUserDataModel?.value.username.text,
        'userID': auth.currentUser?.uid,
        'images': imagesLinks, // List of image URLs
        'starRating': starRating, // Star rating
        'description': description, // Description note
        'dateTime':
            FieldValue.serverTimestamp(), // Timestamp of review creation
      });

      print('Review added successfully!');
      Get.back();
    } catch (e) {
      Get.back();
      print('Error adding review: $e');
    }
  }

  Stream<List<ReviewModel>> getReviews(String restaurantID) {
    return FirebaseFirestore.instance
        .collection('restaurants')
        .doc(restaurantID)
        .collection('reviews')
        .orderBy('dateTime',
            descending: true) // Sort by dateTime (most recent first)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ReviewModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  double calculateDistanceInMiles(
      double startLat, double startLng, double endLat, double endLng) {
    const double earthRadius = 6371; // in kilometers
    double dLat = _degreesToRadians(endLat - startLat);
    double dLon = _degreesToRadians(endLng - startLng);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(startLat)) *
            cos(_degreesToRadians(endLat)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distanceKm = earthRadius * c;

    return distanceKm * 0.621371; // Convert to miles
  }

  double _degreesToRadians(double degree) {
    return degree * (pi / 180);
  }

  //get trensing resturants base on totoal reviews and rating

  // Stream<List<RestaurantModel>> getTrendingRestaurants() {
  //   return FirebaseFirestore.instance
  //       .collection('restaurants')
  //       .snapshots()
  //       .asyncMap((snapshot) async {
  //     // Fetch all restaurants and their menus
  //     final restaurants = await Future.wait(
  //       snapshot.docs.map((doc) async {
  //         final reviewsSnapshot =
  //             await doc.reference.collection('reviews').get();

  //         int totalReviews = reviewsSnapshot.size;
  //         double totalRating = reviewsSnapshot.docs
  //             .map((e) => double.parse(e['starRating'].toString()))
  //             .fold(0.0, (prev, rating) => prev + rating);
  //         double averageRating =
  //             totalReviews > 0 ? totalRating / totalReviews : 0.0;

  //         // Filter out restaurants without reviews
  //         if (totalReviews > 0) {
  //           // Fetch menu list from subcollection
  //           final restaurant = RestaurantModel.fromDocumentSnapshot(doc);
  //           // Set average rating
  //           restaurant.averageRating = averageRating;

  //           return restaurant;
  //         }
  //         return null;
  //       }).toList(),
  //     );

  //     // Filter out null restaurants (those without reviews)
  //     final trendingRestaurants =
  //         restaurants.whereType<RestaurantModel>().toList();

  //     // Sort by average rating in descending order
  //     trendingRestaurants
  //         .sort((a, b) => b.averageRating.compareTo(a.averageRating));

  //     return trendingRestaurants; // Return List<RestaurantModel>
  //   });
  // }

  //...............        filpering problem solve ---------------------

  RxBool hasInitialized = false.obs;

  // Store filtered data once
  RxList<RestaurantModel> trendingRestaurants = <RestaurantModel>[].obs;

  Future<void> loadTrendingRestaurants({
    required List<String> vibes,
    required List<String> experiences,
    required List<String> cuisines,
  }) async {
    try {
      hasInitialized.value = false;

      final result = await getTrendingRestaurants(
        vibes: vibes,
        experiences: experiences,
        cuisines: cuisines,
      )
          .timeout(const Duration(seconds: 15)) // prevent infinite hang
          .first;

      trendingRestaurants.assignAll(result);
      print("✅ Loaded ${result.length} trending restaurants");
    } catch (e) {
      print("❌ Failed to load trending restaurants: $e");
      trendingRestaurants.clear(); // to ensure UI shows 'No restaurants'
    } finally {
      hasInitialized.value = true;
    }
  }

  void resetTrendingFlag() {
    hasInitialized.value = false;
  }

//...............................

  final RxList<String> selectedVibes = <String>[].obs;
  final RxList<String> selectedExperiences = <String>[].obs;
  final RxList<String> selectedCuisines = <String>[].obs;

  final filterController = Get.find<HomeFilterSearchController>();

  Stream<List<RestaurantModel>> getTrendingRestaurants({
    List<String> vibes = const [],
    List<String> experiences = const [],
    List<String> cuisines = const [],
  }) {
    return FirebaseFirestore.instance
        .collection('restaurants')
        .snapshots()
        .asyncMap((snapshot) async {
      Position? userPosition;
      try {
        userPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } catch (e) {
        print("❌ Error getting location: $e");
        userPosition = null; // fallback to prevent crash
      }

      // ✅ Convert RxList to plain list inside the stream function
      final vibes = filterController.selectedVibes.toList();
      final experiences = filterController.selectedExperiences.toList();
      final cuisines = filterController.selectedCuisines.toList();

      final restaurants = await Future.wait(snapshot.docs.map((doc) async {
        final reviewsSnapshot = await doc.reference.collection('reviews').get();

        int totalReviews = reviewsSnapshot.size;
        double totalRating = reviewsSnapshot.docs
            .map((e) => double.tryParse(e['starRating'].toString()) ?? 0.0)
            .fold(0.0, (prev, rating) => prev + rating);
        double averageRating =
            totalReviews > 0 ? totalRating / totalReviews : 0.0;

        final restaurant = RestaurantModel.fromDocumentSnapshot(doc);
        restaurant.averageRating = averageRating;

        // ✅ Calculate distance here
        if (restaurant.latitude != null && restaurant.longitude != null) {
          final distance = Geolocator.distanceBetween(
            userPosition!.latitude,
            userPosition.longitude,
            restaurant.latitude!,
            restaurant.longitude!,
          );
          restaurant.distanceInMiles = distance / 1609.34;
        }

        final atmosphereLower =
            restaurant.atmosphereList.map((e) => e.toLowerCase()).toList();
        final facilityLower =
            restaurant.facilityList.map((e) => e.toLowerCase()).toList();
        final cuisineLower = restaurant.menuList
            .map((e) => e.cuisineType.toLowerCase())
            .toList();

        bool matchesVibes = vibes.isEmpty ||
            vibes.any((v) =>
                atmosphereLower.contains(v.toLowerCase()) ||
                facilityLower.contains(v.toLowerCase()));

        bool matchesExperiences = experiences.isEmpty ||
            experiences.any((e) =>
                facilityLower.contains(e.toLowerCase()) ||
                atmosphereLower.contains(e.toLowerCase()));

        bool matchesCuisines = cuisines.isEmpty ||
            cuisines
                .any((cuisine) => cuisineLower.contains(cuisine.toLowerCase()));

        if (totalReviews > 0 &&
            matchesVibes &&
            matchesExperiences &&
            matchesCuisines) {
          return restaurant;
        }
        return null;
      }).toList());

      final trendingRestaurants =
          restaurants.whereType<RestaurantModel>().toList();
      trendingRestaurants
          .sort((a, b) => b.averageRating.compareTo(a.averageRating));
      return trendingRestaurants;
    });
  }

  addRecentView({required String restaurantID, resName}) async {
    List<String> localStoreResturatnstID =
        preferences?.getStringList('recentView') ?? [];

    if (!localStoreResturatnstID.contains(resName)) {
      localStoreResturatnstID.add(resName);
      await preferences?.setStringList('recentView', localStoreResturatnstID);
    }

    print(
        'recent view list -------------------------- ${localStoreResturatnstID.toString()}');

    try {
      var reviewCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser?.uid)
          .collection('recentView');

      // Check if a recent view already exists for the current user and the restaurant
      var existingView = await reviewCollection
          .where('userID', isEqualTo: auth.currentUser?.uid)
          .where('restaurantID', isEqualTo: restaurantID)
          .limit(1) // Limit to 1 to ensure we only get one document
          .get();

      if (existingView.docs.isNotEmpty) {
        // If the recent view exists, update the dateTime field
        String existingViewId = existingView.docs.first.id;

        await reviewCollection.doc(existingViewId).update({
          'dateTime': FieldValue.serverTimestamp(),
        });

        print('Recent view updated successfully!');
      } else {
        // If no recent view exists, create a new one
        String recentViewId = reviewCollection.doc().id;

        await reviewCollection.doc(recentViewId).set({
          'recentViewID': recentViewId,
          'restaurantID': restaurantID,
          'userName': currentUserDataModel?.value.username.text,
          'userID': auth.currentUser?.uid,
          'dateTime': FieldValue.serverTimestamp(),
        });

        print('Recent view added successfully!');
      }
    } catch (e) {
      Get.back();
      print('Error adding or updating recent view: $e');
    }
  }

  Stream<List<RecentViewModel>> getRecentViews() {
    // Access the Firestore collection where recent views are stored for the current user
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

  /// Fetches initial restaurants with pagination support
  Stream<List<RestaurantModel>> getRestaurants() {
    return _firestore
        .collection('restaurants')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last; // Track last document for pagination
      }

      List<RestaurantModel> restaurantsList = await Future.wait(
        snapshot.docs.map((doc) async {
          final restaurant = RestaurantModel.fromDocumentSnapshot(doc);

          return restaurant;
        }),
      );

      restaurants.assignAll(restaurantsList.where((item) => item.resName
          .toLowerCase()
          .contains(searchController.text
              .toLowerCase()))); // Use `.assignAll` for observable list
      update(); // Ensure UI updates
      return restaurantsList;
    });
  }

  /// Loads more restaurants for pagination
  Future<void> loadMoreRestaurants() async {
    if (isLoading || lastDocument == null) return;

    isLoading = true;
    update(); // Ensure loading indicator updates

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .orderBy('createdAt',
            descending: true) // Ensure order is same as initial fetch
        .startAfterDocument(lastDocument!)
        .limit(limit)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs.last; // Update last document

      final newRestaurants = await Future.wait(
        querySnapshot.docs.map((doc) async {
          final restaurant = RestaurantModel.fromDocumentSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);

          return restaurant;
        }),
      );

      restaurants.addAll(newRestaurants); // Append new data to observable list
      update();
      print('restaurants updated: ${restaurants.length}');
    }

    isLoading = false;
    update(); // Ensure UI updates
  }

  /// Fetches initial restaurants with pagination support
  Stream<List<RestaurantModel>> getAllRestaurants() {
    return _firestore
        .collection('restaurants')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last; // Track last document for pagination
      }

      List<RestaurantModel> restaurantsList = await Future.wait(
        snapshot.docs.map((doc) async {
          final restaurant = RestaurantModel.fromDocumentSnapshot(doc);
          return restaurant;
        }),
      );

      restaurants
          .assignAll(restaurantsList); // Use `.assignAll` for observable list
      update(); // Ensure UI updates
      return restaurantsList;
    });
  }

  /// Fetches initial restaurants with pagination support
  Stream<List<RestaurantModel>> getFilteredRestaurants() {
    return _firestore
        .collection('restaurants')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last; // Track last document for pagination
      }

      List<RestaurantModel> restaurantsList = await Future.wait(
        snapshot.docs.map((doc) async {
          final restaurant = RestaurantModel.fromDocumentSnapshot(doc);

          return restaurant;
        }),
      );

      restaurants
          .assignAll(restaurantsList); // Use `.assignAll` for observable list
      update(); // Ensure UI updates
      return restaurantsList;
    });
  }

  Stream<List<RestaurantModel>> getEntertainmentRestaurants() {
    return FirebaseFirestore.instance
        .collection('restaurants')
        .where('entertainmentScheduleList',
            isGreaterThan: []) // Ensures non-empty lists
        .snapshots()
        .asyncMap((snapshot) async {
          final restaurants = await Future.wait(
            snapshot.docs.map((doc) async {
              final restaurant = RestaurantModel.fromDocumentSnapshot(doc);

              return restaurant;
            }),
          );
          return restaurants;
        });
  }

  bool isOfferValidForCurrentDate(String fromDate, String toDate) {
    try {
      DateTime currentDate = DateTime.now().toLocal();
      DateTime now =
          DateTime(currentDate.year, currentDate.month, currentDate.day);

      // Parse the dates in the format dd/MM/yy
      DateTime fromDateTime = DateFormat("dd/MM/yy").parse(fromDate);
      DateTime toDateTime = DateFormat("dd/MM/yy").parse(toDate);

      // Check if the offer is valid for the current date
      return (now.isAfter(fromDateTime) ||
              now.isAtSameMomentAs(fromDateTime)) &&
          (now.isBefore(toDateTime) || now.isAtSameMomentAs(toDateTime));
    } catch (e) {
      print("Error parsing dates: $e");
      return false;
    }
  }

  // Future<MenuModel> _getMenuFromSubcollection(String restaurantId) async {
  //   try {
  //     // Fetch the documents from Firestore
  //     var snapshot = await FirebaseFirestore.instance
  //         .collection('restaurants')
  //         .doc(restaurantId)
  //         .collection('MealMenu')
  //         .get();

  //     // Process each document
  //     for (var doc in snapshot.docs) {
  //       Map<String, dynamic> dataMap = doc.data();

  //       // Parse fromDate and toDate
  //       String fromDate = dataMap['fromDate']!;
  //       String toDate = dataMap['toDate']!;

  //       // Use the new function to check date validity
  //       if (isOfferValidForCurrentDate(fromDate, toDate)) {
  //         List<OfferModel> percentageOff = [];
  //         List<OfferModel> happyHour = [];

  //         for (var offer in dataMap['menu']) {
  //           MealModel food = MealModel(imagesList: [], offerName: '');
  //           MealModel drink = MealModel(imagesList: [], offerName: '');
  //           String cuisine = '';

  //           if (offer['items'] != []) {
  //             cuisine = offer['items'][0]['cuisineName'];
  //             // Categorize food and drinks
  //             if (offer['items'][0]['cuisineMenu'] == 'Drinks Menu') {
  //               drink = MealModel(
  //                 imagesList: offer['items'][0]['itemImages'] is List
  //                     ? List<String>.from(offer['items'][0]['itemImages'])
  //                     : [],
  //                 offerName: offer['items'][0]['offer'],
  //               );
  //             } else {
  //               food = MealModel(
  //                 imagesList: offer['items'][0]['itemImages'] is List
  //                     ? List<String>.from(offer['items'][0]['itemImages'])
  //                     : [],
  //                 offerName: offer['items'][0]['offer'],
  //               );
  //             }
  //           }

  //           // Categorize offers
  //           if (offer['discountType'].toString().trim() ==
  //               'Happy Hour Special') {
  //             happyHour.add(OfferModel(
  //               startTime: offer['fromTime'],
  //               endTime: offer['toTime'],
  //               percentage: offer['percentageValue'],
  //               food: food,
  //               drink: drink,
  //               cuisine: cuisine,
  //               discountType: offer['discountType'],
  //             ));
  //           } else if (offer['discountType'].toString().trim() ==
  //               'Percentage Off') {
  //             percentageOff.add(OfferModel(
  //               startTime: offer['fromTime'],
  //               endTime: offer['toTime'],
  //               percentage: offer['percentageValue'],
  //               food: food,
  //               drink: drink,
  //               cuisine: cuisine,
  //               discountType: offer['discountType'],
  //             ));
  //           }
  //         }

  //         // Merge the valid offers into the main list
  //         mergedPercentageOff.addAll(percentageOff);
  //         mergedHappyHour.addAll(happyHour);
  //       }
  //     }

  //     // Create a single MenuModel with the merged offers
  //     MenuModel mergedMenu = MenuModel(
  //       percentageOff: mergedPercentageOff,
  //       happyHourSpecials: mergedHappyHour,
  //     );
  //     // print(
  //     //     '=======================================================================');
  //     // print(
  //     //     '==================================Persentage off=====================================');

  //     // print(
  //     //     '=======================================================================');
  //     // print(
  //     //     '=======================================================================');
  //     return mergedMenu; // Return the merged MenuModel
  //   } catch (e) {
  //     print("Error fetching menu data: $e");
  //     return MenuModel.initialize(); // Return an empty model in case of error
  //   }
  // }

  // Initialize restaurants list
  void initializeSelectors(List<RestaurantModel> screenRestaurants) {
    allRestaurants = screenRestaurants;
    filteredRestaurants = screenRestaurants;
    update();
  }

  // Initialize cusines list
  void initializeCuisinesSelectors(Map<String, List<String>> cuisines) {
    cusinesMapFilter = cuisines;
    update();
  }

  // Filter restaurants
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

  //Geofencing

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
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

  bool isWithinRadius(
      Position userLocation, double restLat, double restLng, double radiusKm) {
    double distance = Geolocator.distanceBetween(
        userLocation.latitude, userLocation.longitude, restLat, restLng);

    return distance <= radiusKm * 1000; // Convert km to meters
  }

  // Future<List<RestaurantModel>> getNearbyRestaurants(
  //     List<RestaurantModel> allRestaurants, double radiusKm) async {
  //   // Position userLocation = await getCurrentLocation();

  //   return allRestaurants.where((restaurant) {
  //     return true;

  //     // isWithinRadius(
  //     //   userLocation,
  //     //   restaurant.latitude,
  //     //   restaurant.longitude,
  //     //   radiusKm,
  //     // );
  //   }).toList();
  // }

// filter code

  Future<List<RestaurantModel>> getNearbyRestaurants(
    List<RestaurantModel> allRestaurants,
    double radiusInMeters, {
    List<String> vibes = const [],
    List<String> experiences = const [],
    List<String> cuisines = const [],
  }) async {
    try {
      final userLocation = await getCurrentLocation();

      return allRestaurants.where((restaurant) {
        // Skip restaurants without valid coordinates
        if (restaurant.latitude == null || restaurant.longitude == null) {
          return false;
        }

        // Calculate distance
        final double distance = Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          restaurant.latitude!,
          restaurant.longitude!,
        );

        // Convert all to lowercase for case-insensitive comparison
        final restaurantVibes =
            restaurant.atmosphereList.map((e) => e.toLowerCase()).toList();
        final restaurantExperiences =
            restaurant.facilityList.map((e) => e.toLowerCase()).toList();
        final restaurantCuisines = restaurant.menuList
            .map((e) => e.cuisineType?.toLowerCase() ?? '')
            .toList();

        // Check filters (empty filter lists means no filtering)
        final bool matchesVibes = vibes.isEmpty ||
            vibes.any((v) => restaurantVibes.contains(v.toLowerCase()));

        final bool matchesExperiences = experiences.isEmpty ||
            experiences
                .any((e) => restaurantExperiences.contains(e.toLowerCase()));

        final bool matchesCuisines = cuisines.isEmpty ||
            cuisines.any((c) => restaurantCuisines.contains(c.toLowerCase()));

        return distance <= radiusInMeters &&
            (vibes.isEmpty || matchesVibes) &&
            (experiences.isEmpty || matchesExperiences) &&
            (cuisines.isEmpty || matchesCuisines);
      }).toList();
    } catch (e) {
      // If location fails, return all restaurants that match other filters
      return allRestaurants.where((restaurant) {
        final restaurantVibes =
            restaurant.atmosphereList.map((e) => e.toLowerCase()).toList();
        final restaurantExperiences =
            restaurant.facilityList.map((e) => e.toLowerCase()).toList();
        final restaurantCuisines = restaurant.menuList
            .map((e) => e.cuisineType?.toLowerCase() ?? '')
            .toList();

        final bool matchesVibes = vibes.isEmpty ||
            vibes.any((v) => restaurantVibes.contains(v.toLowerCase()));

        final bool matchesExperiences = experiences.isEmpty ||
            experiences
                .any((e) => restaurantExperiences.contains(e.toLowerCase()));

        final bool matchesCuisines = cuisines.isEmpty ||
            cuisines.any((c) => restaurantCuisines.contains(c.toLowerCase()));

        return matchesVibes && matchesExperiences && matchesCuisines;
      }).toList();
    }
  }

  // Widget favoriteHeart({resturant_id}) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(auth.currentUser?.uid) // Current user's document
  //         .collection('favorite')
  //         .where('resturantID',
  //             isEqualTo: resturant_id) // Filter by restaurantID
  //         .snapshots(), // Stream the snapshot for real-time updates
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Icon(
  //           Icons.favorite_border_outlined,
  //           size: 22,
  //           color: AppColors.primaryColor,
  //         ); // Show loading indicator while waiting for data
  //       }

  //       if (snapshot.hasError) {
  //         return Icon(
  //           Icons.favorite_border_outlined,
  //           size: 22,
  //           color: AppColors.primaryColor,
  //         ); // Show error icon if there's an error
  //       }

  //       // Check if the restaurant exists in the favorite collection
  //       bool isFavorite = snapshot.data?.docs.isNotEmpty ?? false;

  //       return InkWell(
  //         onTap: () {
  //           // Toggle favorite status
  //           if (isFavorite) {
  //             // Remove the restaurant from favorites
  //             FirebaseFirestore.instance
  //                 .collection('users')
  //                 .doc(auth.currentUser!.uid)
  //                 .collection('favorite')
  //                 .where('resturantID', isEqualTo: resturant_id)
  //                 .get()
  //                 .then((snapshot) {
  //               for (var doc in snapshot.docs) {
  //                 doc.reference.delete(); // Remove from favorites
  //               }
  //             });
  //           } else {
  //             // Add the restaurant to favorites
  //             String favId = FirebaseFirestore.instance
  //                 .collection('users')
  //                 .doc(auth.currentUser!.uid)
  //                 .collection('favorite')
  //                 .doc()
  //                 .id;

  //             FirebaseFirestore.instance
  //                 .collection('users')
  //                 .doc(auth.currentUser!.uid)
  //                 .collection('favorite')
  //                 .doc(favId)
  //                 .set({
  //               'resturantID': resturant_id,
  //               'favID': favId,
  //             });
  //           }
  //         },
  //         child: isFavorite
  //             ? Image.asset(
  //                 'assets/images/heart_icon.png',
  //                 color: AppColors.primaryColor,
  //                 height: 22,
  //                 width: 22,
  //               )
  //             : Icon(
  //                 Icons.favorite_border_outlined,
  //                 size: 22,
  //                 color: AppColors.primaryColor,
  //               ),
  //       );
  //     },
  //   );
  // }



Widget favoriteHeart({required String resturant_id}) {
  final favoriteController = Get.find<FavoriteController>();

  return Obx(() {
    bool isFavorite = favoriteController.favoriteIds.contains(resturant_id);

    return InkWell(
      onTap: () {
        favoriteController.toggleFavorite(resturant_id);
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
  });
}

//............Top rated solve filpering issue -----------------------

  Rxn<Position> userPosition = Rxn<Position>();
  Rxn<Map<String, dynamic>> featuredRestaurantMeta =
      Rxn<Map<String, dynamic>>();

  Future<void> loadTopRatedData() async {
    try {
      userPosition.value = await Geolocator.getCurrentPosition();
      featuredRestaurantMeta.value = await getFeaturedRestaurantID().first;
      allRestaurants.assignAll(await getAllRestaurants().first);
    } catch (e) {
      print("Error loading top rated data: $e");
    }
  }

//....................
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
    return _firestore
        .collection('restaurants')
        .where('docID', isEqualTo: restID)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        lastDocument = snapshot.docs.last; // Optional: for pagination
        return RestaurantModel.fromDocumentSnapshot(doc);
      } else {
        return null;
      }
    });
  }
}




///----------------- solve filpering problem----------------




//--------------------

