import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:savrly/models/operatingHour.dart';
import 'package:savrly/models/resaturant_model.dart';

class RestaurantManagementController extends GetxController {
  final searchController = TextEditingController();
  RxString selectedCity = ''.obs;
  RxString selectedCuisine = ''.obs;
  RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  RxList<RestaurantModel> filteredResults =
      <RestaurantModel>[].obs; // For search and city filter results
  DocumentSnapshot? lastDocument;
  RxBool hasMoreData = true.obs;
  RxBool isLoading = false.obs;
  final int pageSize = 10;
  RxString currentSearchQuery = ''.obs;
  RxString currentCityFilter = ''.obs;
  RxString currentCuisineFilter = ''.obs;
  RxList<String> cityList = <String>[
    "Beverly Hills",
    "Santa Monica",
    "West Hollywood",
    "Downtown LA",
    "Hollywood",
    "Pasadena",
    "Long Beach",
    "Malibu",
    "Glendale",
    "Burbank",
    "Culver City",
    "Torrance",
    "Manhattan Beach",
    "Redondo Beach",
    "Hermosa Beach",
    "Inglewood",
    "Compton",
    "Carson",
    "Downey",
    "Norwalk",
    "Whittier",
    "Arcadia",
    "Monterey Park",
    "Alhambra",
    "San Gabriel",
    "Rosemead",
    "El Monte",
    "West Covina",
    "Pomona",
    "Diamond Bar",
    "Walnut",
    "La Puente",
    "Baldwin Park",
    "Industry",
    "Duarte",
    "Monrovia",
    "Sierra Madre",
    "San Marino",
    "South Pasadena",
    "La Canada Flintridge",
    "Altadena",
    "North Hollywood",
    "Studio City",
    "Sherman Oaks",
    "Encino",
    "Tarzana",
    "Woodland Hills",
    "Calabasas",
    "Agoura Hills",
    "Westlake Village",
    "Thousand Oaks",
    "Simi Valley",
    "Chatsworth",
    "Granada Hills",
    "Porter Ranch",
    "Northridge",
    "Reseda",
    "Van Nuys",
    "Panorama City",
    "Mission Hills",
    "Sylmar",
    "San Fernando",
    "Sun Valley",
    "Sunland",
    "Tujunga",
    "La Crescenta",
    "Montrose",
    "Eagle Rock",
    "Highland Park",
    "Glassell Park",
    "Atwater Village",
    "Los Feliz",
    "Silver Lake",
    "Echo Park",
    "Koreatown",
    "Mid-City",
    "West Adams",
    "Leimert Park",
    "Crenshaw",
  ].obs;

  RxList<String> cuisineList = <String>[
    'Chinese',
    'Italian',
    'Fast Food',
    'Mexican',
    'Thai',
    'Japanese',
    'Mediterranean',
    'American',
  ].obs;
  RxInt totalRestaurantsLength = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
    getAllRestaurantsLength();
    searchController.addListener(() {
      currentSearchQuery.value = searchController.text;
      if (currentSearchQuery.value.isNotEmpty) {
        fetchAllRestaurantsForFilters(); // Fetch all for search or city filter
      } else if (currentCityFilter.value.isNotEmpty &&
          currentCityFilter.value != 'All') {
        fetchAllRestaurantsForFilters(); // Fetch all if city filter is still active
      } else {
        fetchRestaurants(isRefresh: true); // Reset to normal pagination
      }
      getAllRestaurantsLength();
    });
    ever(selectedCity, (value) {
      currentCityFilter.value = value;
      if (currentCityFilter.value.isNotEmpty &&
          currentCityFilter.value != 'All') {
        fetchAllRestaurantsForFilters(); // Fetch all for city filter
      } else if (currentSearchQuery.value.isNotEmpty) {
        fetchAllRestaurantsForFilters(); // Fetch all if search is still active
      } else {
        fetchRestaurants(isRefresh: true); // Reset to normal pagination
      }
      getAllRestaurantsLength();
    });
    ever(selectedCuisine, (_) {
      fetchRestaurants(isRefresh: true);
      getAllRestaurantsLength();
    });
  }

  Future<void> getAllRestaurantsLength({
    String? searchQuery,
    String? cityFilter,
    String? cuisineFilter,
  }) async {
    try {
      CollectionReference restaurantsRef =
          FirebaseFirestore.instance.collection('restaurants');
      Query query = restaurantsRef;

      QuerySnapshot querySnapshot = await query.get();
      //update doc id
      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(doc.id)
            .update({'docID': doc.id});
      }
      List<RestaurantModel> restaurants = querySnapshot.docs.map((doc) {
        return RestaurantModel.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();

      if (searchQuery != null && searchQuery.isNotEmpty) {
        restaurants = restaurants
            .where((restaurant) => restaurant.resName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();
      }

      if (cityFilter != null && cityFilter.isNotEmpty && cityFilter != 'All') {
        restaurants = restaurants
            .where((restaurant) =>
                restaurant.city.toLowerCase() == cityFilter.toLowerCase())
            .toList();
      }

      if (cuisineFilter != null) {
        restaurants = [];
      }

      totalRestaurantsLength.value = restaurants.length;
      print('Total restaurants in database: ${totalRestaurantsLength.value}');
    } catch (e) {
      print('Error fetching total restaurants length: $e');
      totalRestaurantsLength.value = 0;
    }
  }

  // Fetch all restaurants for search or city filter
  Future<void> fetchAllRestaurantsForFilters() async {
    try {
      isLoading.value = true;
      CollectionReference restaurantsRef =
          FirebaseFirestore.instance.collection('restaurants');
      Query query = restaurantsRef;

      QuerySnapshot querySnapshot = await query.get();
      List<RestaurantModel> allRestaurants = querySnapshot.docs.map((doc) {
        return RestaurantModel.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();

      // Apply filters
      filteredResults.value = allRestaurants;

      // Apply search filter if active
      if (currentSearchQuery.value.isNotEmpty) {
        filteredResults.value = filteredResults
            .where((restaurant) => restaurant.resName
                .toLowerCase()
                .contains(currentSearchQuery.value.toLowerCase()))
            .toList();
      }

      // Apply city filter if active
      if (currentCityFilter.value.isNotEmpty &&
          currentCityFilter.value != 'All') {
        filteredResults.value = filteredResults
            .where((restaurant) =>
                restaurant.city.toLowerCase() ==
                currentCityFilter.value.toLowerCase())
            .toList();
      }

      // Apply cuisine filter if active
      if (currentCuisineFilter.value.isNotEmpty &&
          currentCuisineFilter.value != 'All') {
        filteredResults.value = [];
      }

      // Reset restaurants list and paginate filtered results
      restaurants.clear();
      lastDocument = null;
      hasMoreData.value = true;
      paginateFilteredResults();
    } catch (e) {
      print('Error fetching all restaurants for filters: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Paginate the filtered results
  void paginateFilteredResults() {
    if (!hasMoreData.value) {
      return;
    }

    int startIndex = restaurants.length;
    int endIndex = startIndex + pageSize;
    if (endIndex >= filteredResults.length) {
      endIndex = filteredResults.length;
      hasMoreData.value = false;
    }

    if (startIndex >= filteredResults.length) {
      hasMoreData.value = false;
      return;
    }

    List<RestaurantModel> newRestaurants =
        filteredResults.sublist(startIndex, endIndex);
    restaurants.addAll(newRestaurants);
  }

  Future<List<RestaurantModel>> getRestaurantsWithPagination({
    required int pageSize,
    DocumentSnapshot? lastDocument,
    String? searchQuery,
    String? cityFilter,
    String? cuisineFilter,
  }) async {
    try {
      CollectionReference restaurantsRef =
          FirebaseFirestore.instance.collection('restaurants');
      Query query = restaurantsRef;

      // Apply pagination limit (fetch more than pageSize to account for client-side filtering)
      query = query.limit(pageSize * 2);

      // Start after the last document if it exists
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot querySnapshot = await query.get();

      List<RestaurantModel> restaurants = querySnapshot.docs.map((doc) {
        return RestaurantModel.fromDocumentSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();

      // Apply all filters client-side
      if (searchQuery != null && searchQuery.isNotEmpty) {
        restaurants = restaurants
            .where((restaurant) => restaurant.resName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();
      }

      if (cityFilter != null && cityFilter.isNotEmpty && cityFilter != 'All') {
        restaurants = restaurants
            .where((restaurant) =>
                restaurant.city.toLowerCase() == cityFilter.toLowerCase())
            .toList();
      }

      if (cuisineFilter != null &&
          cuisineFilter.isNotEmpty &&
          cuisineFilter != 'All') {
        restaurants = restaurants
            .where((restaurant) => restaurant.menuList
                .map((cuisine) => cuisine.cuisineType.toLowerCase())
                .contains(cuisineFilter.toLowerCase()))
            .toList();
        print(
            'After cuisine filter ---------- : ${restaurants.length} restaurants');
      }

      // Limit to pageSize after filtering
      restaurants = restaurants.take(pageSize).toList();
      print('After limiting to pageSize: ${restaurants.length} restaurants');

      // Update lastDocument for the next fetch
      this.lastDocument =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
      if (this.lastDocument != null) {
        print('Updated lastDocument to: ${this.lastDocument!.id}');
      } else {
        print('No more documents to set as lastDocument');
      }

      return restaurants;
    } catch (e) {
      print('Error fetching restaurants: $e');
      return [];
    }
  }

  Future<void> fetchRestaurants({
    bool isRefresh = false,
    String? searchQuery,
    String? cityFilter,
    String? cuisineFilter,
  }) async {
    if (isLoading.value) {
      print('Already loading, skipping fetch');
      return;
    }

    // If search query or city filter is active, paginate filtered results instead
    if (currentSearchQuery.value.isNotEmpty ||
        (currentCityFilter.value.isNotEmpty &&
            currentCityFilter.value != 'All')) {
      isLoading.value = true;
      try {
        paginateFilteredResults();
      } finally {
        isLoading.value = false;
      }
      return;
    }

    isLoading.value = true;

    try {
      if (isRefresh ||
          (searchQuery != null && searchQuery != currentSearchQuery.value) ||
          (cityFilter != null && cityFilter != currentCityFilter.value) ||
          (selectedCuisine.value.isNotEmpty &&
              selectedCuisine.value != currentCuisineFilter.value)) {
        restaurants.clear();
        lastDocument = null;
        hasMoreData.value = true;
        currentSearchQuery.value = searchQuery ?? currentSearchQuery.value;
        currentCityFilter.value = cityFilter ?? currentCityFilter.value;
        currentCuisineFilter.value = selectedCuisine.value;
      }

      if (!hasMoreData.value) {
        print('No more data to fetch');
        return;
      }

      List<RestaurantModel> newRestaurants = await getRestaurantsWithPagination(
        pageSize: pageSize,
        lastDocument: lastDocument,
        searchQuery: currentSearchQuery.value,
        cityFilter: currentCityFilter.value,
        cuisineFilter: currentCuisineFilter.value,
      );

      restaurants.addAll(newRestaurants);

      // Only set hasMoreData to false if we fetched no new restaurants
      if (newRestaurants.isEmpty || restaurants.length < 10) {
        hasMoreData.value = false;
      }
    } catch (e) {
      print('Error in fetchRestaurants: $e');
    } finally {
      isLoading.value = false;
      print('Finished fetchRestaurants');
    }
  }

  Stream<List<OperatingHours>> getOperatingHours(String restId) {
    try {
      // Reference to the operatingHours subcollection for the given restId
      final Stream<QuerySnapshot> operatingHoursStream = FirebaseFirestore
          .instance
          .collection('restaurants')
          .doc(restId)
          .collection('operatingHours')
          .snapshots();

      // Transform the stream of QuerySnapshots into a stream of List<OperatingHours>
      return operatingHoursStream.map((QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot doc) {
          return OperatingHours.fromDocument(doc);
        }).toList();
      });
    } catch (e) {
      // Return a stream with error if something goes wrong
      return Stream.error('Error fetching operating hours: $e');
    }
  }

void deleteRestaurantFromFiltered(RestaurantModel restaurant) async {
  try {
    final docID = restaurant.docID;
    print('Deleting docID: $docID');

    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(docID)
        .collection('operatingHours')
        .doc('Monday').delete();
    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(docID)
        .collection('operatingHours')
        .doc('Tuesday').delete();
    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(docID)
        .collection('operatingHours')
        .doc('Wednesday').delete();
    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(docID)
        .collection('operatingHours')
        .doc('Thursday').delete();
    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(docID)
        .collection('operatingHours')
        .doc('Friday').delete();
    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(docID)
        .collection('operatingHours')
        .doc('Saturday').delete();
    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(docID)
        .collection('operatingHours')
        .doc('Sunday').delete();

    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(docID)
        .delete();

    restaurants.removeWhere((r) => r.docID == docID);
    restaurants.refresh();

    filteredResults.removeWhere((r) => r.docID == docID);
    filteredResults.refresh();

    getAllRestaurantsLength(
      searchQuery: currentSearchQuery.value,
      cityFilter: currentCityFilter.value,
      cuisineFilter: currentCuisineFilter.value,
    );

    Get.snackbar('Success', '${restaurant.resName} deleted.');
  } catch (e) {
    print('Error deleting restaurant: $e');
    Get.snackbar('Error', 'Deletion failed');
  }
}



  final TextEditingController descriptionController = TextEditingController();
  Future<void> setFeaturedRestaurant({
    required String restaurantID,
    String? description,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('featured')
          .doc('mainFeatured')
          .set({
        'restaurantID': restaurantID,
        'description': description ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Added featured exception $e');
    }
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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
