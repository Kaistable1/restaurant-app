import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/restaurant_model.dart';

class NewRestaurantsController extends GetxController {
  final searchController = TextEditingController();
  RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  RxList<RestaurantModel> filteredResults = <RestaurantModel>[].obs;
  DocumentSnapshot? lastDocument;
  RxBool isLoading = false.obs;
  RxBool hasMoreData = true.obs;
  RxInt totalRestaurantsLength = 0.obs;
  int pageSize = 10;
  RxString currentSearchQuery = ''.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
    getAllRestaurantsLength();

    // Listen to search query changes
    searchController.addListener(() {
      currentSearchQuery.value = searchController.text;
      if (currentSearchQuery.value.isNotEmpty) {
        fetchAllRestaurantsForSearch(); // Fetch all for search
      } else {
        fetchRestaurants(isRefresh: true); // Reset to normal pagination
      }
      getAllRestaurantsLength();
    });
  }

  /// Fetches initial restaurants with pagination support using streams
  Stream<List<RestaurantModel>> fetchRestaurants({bool isRefresh = false}) {
    if (isRefresh) {
      lastDocument = null;
      restaurants.clear();
      hasMoreData.value = true;
    }

    Query query = _firestore
        .collection('restaurants')
        .orderBy('createdAt', descending: true)
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    return query.snapshots().asyncMap((snapshot) async {
      if (snapshot.docs.isEmpty) {
        hasMoreData.value = false;
        return restaurants;
      }

      lastDocument = snapshot.docs.last;

      List<RestaurantModel> newRestaurants = await Future.wait(
        snapshot.docs.map((doc) async {
          return RestaurantModel.fromDocumentSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }),
      );

      // Apply search filter
      newRestaurants = _applySearchFilter(newRestaurants);

      if (isRefresh) {
        restaurants.assignAll(newRestaurants);
      } else {
        restaurants.addAll(newRestaurants);
      }

      return restaurants;
    });
  }

  /// Loads more restaurants for pagination
  Future<void> loadMoreRestaurants() async {
    if (isLoading.value || !hasMoreData.value) return;

    isLoading.value = true;

    if (currentSearchQuery.value.isNotEmpty) {
      paginateFilteredResults();
    } else {
      await fetchRestaurants().first; // Fetch next batch
    }

    isLoading.value = false;
  }

  /// Fetches all restaurants for search filtering
  Future<void> fetchAllRestaurantsForSearch() async {
    try {
      isLoading.value = true;
      Query query = _firestore.collection('restaurants');

      QuerySnapshot querySnapshot = await query.get();
      List<RestaurantModel> allRestaurants = await Future.wait(
        querySnapshot.docs.map((doc) async {
          return RestaurantModel.fromDocumentSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }),
      );

      // Apply search filter
      filteredResults.assignAll(_applySearchFilter(allRestaurants));

      // Reset restaurants list and paginate filtered results
      restaurants.clear();
      lastDocument = null;
      hasMoreData.value = true;
      paginateFilteredResults();
    } catch (e) {
      print('Error fetching all restaurants for search: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Paginates the filtered results
  void paginateFilteredResults() {
    if (!hasMoreData.value) return;

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

  /// Applies search filter
  List<RestaurantModel> _applySearchFilter(List<RestaurantModel> restaurants) {
    if (currentSearchQuery.value.isEmpty) return restaurants;

    return restaurants
        .where((restaurant) => restaurant.resName
            .toLowerCase()
            .contains(currentSearchQuery.value.toLowerCase()))
        .toList();
  }

  /// Gets the total number of restaurants after applying search filter
  Future<void> getAllRestaurantsLength({String? searchQuery}) async {
    try {
      Query query = _firestore.collection('restaurants');
      QuerySnapshot querySnapshot = await query.get();

      List<RestaurantModel> restaurants = await Future.wait(
        querySnapshot.docs.map((doc) async {
          return RestaurantModel.fromDocumentSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }),
      );

      // Apply search filter
      if (searchQuery != null && searchQuery.isNotEmpty) {
        restaurants = restaurants
            .where((restaurant) => restaurant.resName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();
      }

      totalRestaurantsLength.value = restaurants.length;
      print('Total restaurants in database: ${totalRestaurantsLength.value}');
    } catch (e) {
      print('Error fetching total restaurants length: $e');
      totalRestaurantsLength.value = 0;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}