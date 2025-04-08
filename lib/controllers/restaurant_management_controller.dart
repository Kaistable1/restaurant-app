import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:savrly/models/resaturant_model.dart';

class RestaurantManagementController extends GetxController {
  final searchController = TextEditingController();
  RxString selectedCity = ''.obs;
  RxString selectedCuisine = ''.obs;
  RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
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
      fetchRestaurants(isRefresh: true);
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

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query
            .where('resName', isGreaterThanOrEqualTo: searchQuery)
            .where('resName', isLessThanOrEqualTo: '$searchQuery\uf8ff');
      }

      if (cityFilter != null && cityFilter.isNotEmpty && cityFilter != 'All') {
        query = query.where('city', isEqualTo: cityFilter);
      }

      if (cuisineFilter != null &&
          cuisineFilter.isNotEmpty &&
          cuisineFilter != 'All') {
        query = query.where('dietaryList', arrayContains: cuisineFilter);
      }

      QuerySnapshot querySnapshot = await query.get();
      totalRestaurantsLength.value = querySnapshot.docs.length;
      print('Total restaurants in database: ${totalRestaurantsLength.value}');
    } catch (e) {
      print('Error fetching total restaurants length: $e');
      totalRestaurantsLength.value = 0;
    }
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

      // Apply search filter without orderBy
      if (searchQuery != null && searchQuery.isNotEmpty) {
        print('Applying search filter: $searchQuery');
        // Search will be handled client-side
      }

      // Apply city filter
      if (cityFilter != null && cityFilter.isNotEmpty && cityFilter != 'All') {
        print('Applying city filter: $cityFilter');
        query = query.where('city', isEqualTo: cityFilter);
      }

      // Apply cuisine filter
      if (cuisineFilter != null &&
          cuisineFilter.isNotEmpty &&
          cuisineFilter != 'All') {
        print('Applying cuisine filter: $cuisineFilter');
        query = query.where('dietaryList', arrayContains: cuisineFilter);
      }

      // Apply pagination limit
      query = query.limit(pageSize);

      // Start after the last document if it exists (using the full DocumentSnapshot)
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

      // Apply search filter client-side if searchQuery is provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        restaurants = restaurants
            .where((restaurant) => restaurant.resName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();
        print(
            'After client-side search filter: ${restaurants.length} restaurants');
      }

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
  //

  void deleteRestaurant(int index) async {
    try {
      String docID = restaurants[index].docID;
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(docID)
          .delete();
      restaurants.removeAt(index);
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
