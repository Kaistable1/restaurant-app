import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:savrly/models/resaturant_model.dart';

class RestaurantManagementController extends GetxController {
  final searchController = TextEditingController();
  RxString selectedCity = ''.obs;
  RxString selectedCuisine = ''.obs;
  RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  RxList<RestaurantModel> searchResults =
      <RestaurantModel>[].obs; // For search results
  DocumentSnapshot? lastDocument;
  RxBool hasMoreData = true.obs;
  RxBool isLoading = false.obs;
  final int pageSize = 10;
  RxString currentSearchQuery = ''.obs;
  RxString currentCityFilter = ''.obs;
  RxString currentCuisineFilter = ''.obs;
  RxList<String> cityList =
      <String>['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Peshawar'].obs;
  RxList<String> cuisineList =
      <String>['Pakistani', 'Chinese', 'Italian', 'Fast Food', 'Indian'].obs;
  RxInt totalRestaurantsLength = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
    getAllRestaurantsLength();
    searchController.addListener(() {
      currentSearchQuery.value = searchController.text;
      if (currentSearchQuery.value.isNotEmpty) {
        fetchAllRestaurantsForSearch(); // Fetch all for search
      } else {
        fetchRestaurants(isRefresh: true); // Reset to normal pagination
      }
      getAllRestaurantsLength();
    });
    ever(selectedCity, (_) {
      fetchRestaurants(isRefresh: true);
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

      if (cuisineFilter != null &&
          cuisineFilter.isNotEmpty &&
          cuisineFilter != 'All') {
        restaurants = restaurants
            .where((restaurant) => restaurant.dietaryList
                .map((cuisine) => cuisine.toLowerCase())
                .contains(cuisineFilter.toLowerCase()))
            .toList();
      }

      totalRestaurantsLength.value = restaurants.length;
      print('Total restaurants in database: ${totalRestaurantsLength.value}');
    } catch (e) {
      print('Error fetching total restaurants length: $e');
      totalRestaurantsLength.value = 0;
    }
  }

  // Fetch all restaurants for search
  Future<void> fetchAllRestaurantsForSearch() async {
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

      // Apply search filter
      searchResults.value = allRestaurants
          .where((restaurant) => restaurant.resName
              .toLowerCase()
              .contains(currentSearchQuery.value.toLowerCase()))
          .toList();

      // Apply city and cuisine filters if active
      if (currentCityFilter.value.isNotEmpty &&
          currentCityFilter.value != 'All') {
        searchResults.value = searchResults
            .where((restaurant) =>
                restaurant.city.toLowerCase() ==
                currentCityFilter.value.toLowerCase())
            .toList();
      }

      if (currentCuisineFilter.value.isNotEmpty &&
          currentCuisineFilter.value != 'All') {
        searchResults.value = searchResults
            .where((restaurant) => restaurant.dietaryList
                .map((cuisine) => cuisine.toLowerCase())
                .contains(currentCuisineFilter.value.toLowerCase()))
            .toList();
      }

      // Reset restaurants list and paginate search results
      restaurants.clear();
      lastDocument = null;
      hasMoreData.value = true;
      paginateSearchResults();
    } catch (e) {
      print('Error fetching all restaurants for search: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Paginate the search results
  void paginateSearchResults() {
    if (!hasMoreData.value) {
      print('No more search results to paginate');
      return;
    }

    int startIndex = restaurants.length;
    int endIndex = startIndex + pageSize;
    if (endIndex >= searchResults.length) {
      endIndex = searchResults.length;
      hasMoreData.value = false;
    }

    if (startIndex >= searchResults.length) {
      hasMoreData.value = false;
      return;
    }

    List<RestaurantModel> newRestaurants =
        searchResults.sublist(startIndex, endIndex);
    restaurants.addAll(newRestaurants);
    print('Paginated ${newRestaurants.length} search results');
    print('Total restaurants in list: ${restaurants.length}');
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
        print('Starting after document: ${lastDocument.id}');
        query = query.startAfterDocument(lastDocument);
      }

      print('Executing query...');
      QuerySnapshot querySnapshot = await query.get();
      print('Fetched ${querySnapshot.docs.length} documents');

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
        print('After search filter: ${restaurants.length} restaurants');
      }

      if (cityFilter != null && cityFilter.isNotEmpty && cityFilter != 'All') {
        restaurants = restaurants
            .where((restaurant) =>
                restaurant.city.toLowerCase() == cityFilter.toLowerCase())
            .toList();
        print('After city filter: ${restaurants.length} restaurants');
      }

      if (cuisineFilter != null &&
          cuisineFilter.isNotEmpty &&
          cuisineFilter != 'All') {
        restaurants = restaurants
            .where((restaurant) => restaurant.dietaryList
                .map((cuisine) => cuisine.toLowerCase())
                .contains(cuisineFilter.toLowerCase()))
            .toList();
        print('After cuisine filter: ${restaurants.length} restaurants');
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

    // If search query is active, paginate search results instead
    if (currentSearchQuery.value.isNotEmpty) {
      isLoading.value = true;
      try {
        paginateSearchResults();
      } finally {
        isLoading.value = false;
      }
      return;
    }

    isLoading.value = true;
    print('Starting fetchRestaurants (isRefresh: $isRefresh)');

    try {
      if (isRefresh ||
          (searchQuery != null && searchQuery != currentSearchQuery.value) ||
          (cityFilter != null && cityFilter != currentCityFilter.value) ||
          (cuisineFilter != null &&
              cuisineFilter != currentCuisineFilter.value)) {
        print('Resetting state for refresh or filter change');
        restaurants.clear();
        lastDocument = null;
        hasMoreData.value = true;
        currentSearchQuery.value = searchQuery ?? currentSearchQuery.value;
        currentCityFilter.value = cityFilter ?? currentCityFilter.value;
        currentCuisineFilter.value =
            cuisineFilter ?? currentCuisineFilter.value;
      }

      if (!hasMoreData.value) {
        print('No more data to fetch');
        return;
      }

      print('Fetching restaurants with pageSize: $pageSize');
      print('currentCityFilter.value ----------- ${cityFilter}');
      List<RestaurantModel> newRestaurants = await getRestaurantsWithPagination(
        pageSize: pageSize,
        lastDocument: lastDocument,
        searchQuery: currentSearchQuery.value,
        cityFilter: currentCityFilter.value,
        cuisineFilter: currentCuisineFilter.value,
      );

      print('Fetched ${newRestaurants.length} new restaurants');
      restaurants.addAll(newRestaurants);
      print('Total restaurants in list: ${restaurants.length}');

      // Only set hasMoreData to false if we fetched no new restaurants
      if (newRestaurants.isEmpty) {
        hasMoreData.value = false;
        print('Reached end of data (no new restaurants fetched)');
      } else {
        print('More data might be available, continuing pagination');
      }
    } catch (e) {
      print('Error in fetchRestaurants: $e');
    } finally {
      isLoading.value = false;
      print('Finished fetchRestaurants');
    }
  }

  void deleteRestaurant(int index) async {
    try {
      String docID = restaurants[index].docID;
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(docID)
          .delete();
      restaurants.removeAt(index);
      if (currentSearchQuery.value.isNotEmpty) {
        searchResults.removeWhere((restaurant) => restaurant.docID == docID);
      }
      getAllRestaurantsLength(
        searchQuery: currentSearchQuery.value,
        cityFilter: currentCityFilter.value,
        cuisineFilter: currentCuisineFilter.value,
      );
      Get.snackbar('Success', 'Restaurant deleted successfully');
    } catch (e) {
      print('Error deleting restaurant: $e');
      Get.snackbar('Error', 'Failed to delete restaurant');
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
