import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/main.dart';
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
    'Soul food',
    'Southern food',
    'Cajun & Creole',
    'Barbecue',
    'Diner / Comfort Food',
    'Jamaican',
    'Fusion',
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
          .doc('Monday')
          .delete();
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(docID)
          .collection('operatingHours')
          .doc('Tuesday')
          .delete();
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(docID)
          .collection('operatingHours')
          .doc('Wednesday')
          .delete();
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(docID)
          .collection('operatingHours')
          .doc('Thursday')
          .delete();
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(docID)
          .collection('operatingHours')
          .doc('Friday')
          .delete();
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(docID)
          .collection('operatingHours')
          .doc('Saturday')
          .delete();
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(docID)
          .collection('operatingHours')
          .doc('Sunday')
          .delete();

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

  // Fix restaurants with missing auth users or restaurantOwner documents
  RxBool isFixingRestaurants = false.obs;
  RxInt fixedCount = 0.obs;
  RxInt errorCount = 0.obs;
  RxInt totalProcessed = 0.obs;
  RxInt skippedCount = 0.obs;
  
  // List of restaurant doc IDs to skip when fixing credentials
  // You can populate this list with restaurant doc IDs that should be skipped
  // Example: ['restaurantDocId1', 'restaurantDocId2', 'restaurantDocId3']
  List<String> skipRestaurantDocIds = [
    '03LLNueNHzTsccpj2iXJzxLYdzw1',
    '05JmWObz0xQDRPDVfrfLKrkDyQA3',
    '08eFManng0MBZfMd9ysDIpHQCpi1',
    '0SCABSOnvWetmQkthmdnEktk9dn1',
    '0UYNrgoyJFcBMs8LZiwUf665cqp2',
    '0XdLT8CyfHSyZTGVr2YJzq1ofoz2',
    '0oaOk7o2ZsVPiYSyY12ri7zCbug1',
    '0tYmqyLTATYKXF1aC6YROCMGp203',
    '0ukyksFBWqMFw6X4AHgmFLBgfzh1',
    '17U93elJISSSEFrwIfqq4xlWmhb2',
    '19KMHqh0tRccQSpwSZArYQJHRX22',
    '1HbpYopdpPZ3FrrQZwRA9gMNggq2',
    '1P4geNo7ENeQhUTEwyTe83rAWP93',
    '1Ti203Azd0WmQRhLDEyzUbgTXt63',
    '1eczh1EbH5ZQc9aYGOrL00xsUIm1',
    '1vVeUh4O9EULgFbc7pGQGtxmc5L2',
    '1wBGLSoCT7c4F9I6dI0WqAAHhrj1',
    '2LnJCoxsO0g7dF12ba2JsXr9mqn1',
    '2MtwEqpyPPhmwzP68HxGYCDQnXh2',
    '2Qxuxy9Oi8gKmSSZdAbGDY4eMNl1',
    '2gSWlHQ3YiS0lIOChJs1SwXDt872',
    '2jqBMosm8BfH4U1decsS7HYnaQr2',
    '2v5nx84xu3Q4FKcKfVgPR1vDH7C3',
    '2yCRnFBZjuZSUiIVfmblhZ2z5yt2',
    '3Hn4CKWTaNNgV0ecY49gYsKo8is2',
    '3LMZMHtYo3OXBqQWu6LjjM1a5SX2',
    '3eeMEWvctcMrrwRZt63Ummc4OXT2',
    '3hRj8xqfEcViF436MFaTCYM5IeL2',
    '3hWOK8gaBJVEAz8hCHG1wkwDzuL2',
    '3iXlHtxJGISVSz4mu5RSL2lX4Cw2',
    '3uL2XqJvvtaxurD9VA90O9D6kJT2',
    '3yZldOkcCTV3A0guZPCzJCsTs0H2',
    '45gZeSvWudSk0Gq6ovBjBz0c6bs2',
    '48RBgPPTSqNnjEU6QQGnJUOLeI12',
    '4K0cGqkTD7gph8IoelCUB8cW2zg2',
    '4LHK9YblR7RXGHnH2dQkchpF0ii1',
    '4SHSGahiDva9iXNVlSh57TcAeuJ3',
    '4UWg7t7A7vMvEnbitirH2G9heXt1',
    '4UnpyulOk9cDy3NMAujZmXteBsz1',
    '4ZfQvDx37iXG5my9PqPTpCuEMa73',
    '4a1VPOO67pdVGWADIPi7m8hrlmr1',
    '4erYiphRk1aU6aW8cYO2NDTCuAH3',
    '5DIU3TTAYyaP2hxRbqZYioQq1Lh2',
    '65t70VXfQlhBMAOSdk2w1kdZtOJ3',
    '6770rL6yEGNfLqa9IAYfwdLY2E33',
    '6HjgczaANEMlXqCo93Q4yZPSTdc2',
    '6XOotLSfq0UpyR59yYARl3gXF232',
    '6m0qvbZbo4TTVGusF86RLMLMsRg2',
    '6yTRkIX9voPbDH1Eaa0kRJfnmGM2',
    '6yndj6NRwsg0fhwyjA2nIXvlSIK2',
    '7CM0YDFfh2feYwHIqqHME1ylSy52',
    '7HqPBbhbpWSSEZeCNVaTiWmutDo2',
    '7KVKfQHlyIenaaUbE1U7nfweV002',
    '7Qtq3JOOM0eJRceFYJ1QwexuBQk2',
    '7RppCST3xyTPbaFA1auZxTuXEYt2',
    '7cm59smJXAcNhCAo2hFYqsb5M973',
    '7hyqubFjCBdBV9zGSVMNpaAyRdw2',
    '7lFMW7BaaWPrwAAKdpEreNVx5S53',
    '7mc1etaQ6Ig2ItV6keyC3nFWr2T2',
    '7vrWLP3VJugOluM0bHJJmjl9F8t2',
    '7wnJ52XCRZQayBY11PF2scGdYkh1',
    '87xxv04qbaZPnzF6Q1TUDJOaMnx1',
    '8Dvl2WWluGXb17MyA1UxQUQXgmt2',
    '8QRG2HKwAugZi3LOTpxX1UKtLPn2',
    '8Z0cJBgS1sSrfFxxisU22kQWPrd2',
    '8ZtTE65sZhWTyIByTfAtTt3It833',
    '8f2CkpmOSdf9ycScoIxbN4puskP2',
    '8kGD19GpZ1XI38Esf6BjN87csiq1',
    '8loBivzQgYcQNwf7JPcUDPLz35x2',
    '8rZ0tuSmKJf3ClTXlTb8E2YMMgi2',
    '8u9nx4nZY7VNNxc0vjgXeX9bY2v1',
    '8vqpt8OjUXNpYhqNCuv4PEc6pvH3',
    '8wDumPglnJT1mrJF4Y8bD4v2RDd2',
    '93wGP05IdzeXLD2Z5FiG73YWtu43',
    '9SAPRikGi0XDaR9s3nh4xLqFp313',
    '9W8ypAnYS8O5fvW6ZlF4jAcuLzR2',
    '9c7YofigA0ZPBGB9nDnfvmmM8Ll1',
    '9gnz7lmtWBN6V8G8e5t9owxJhQK2',
    '9h5Pm1QdSiXuaixDUL2aljEiksI2',
    '9imfrwux44OQz6MnpUOeVgh3fK22',
    '9jAlBaiWbbSu2lVdoakPPM9RXZk2',
    '9rSmKSGcrkbOneJaOvcFJayA0lF3',
    '9viu7XeAjGQwfqprb6W5lEoGYCo1',
    'A81emKaoqsNAORg0Nja2pDlyd5e2',
    'AGOl1UWphSNSpKQRPSNTzXZk3633',
    'ALsoO1vUZjRLUmREwnRIZ3kupOy1',
    'ANlc0yJM8KQSl5Wls1mmwxR2mYE2',
    'AanREBqj9SU822iJheWalPKSvDv1',
    'AeHhigu3zcThPIs4gEaTxeB1RKD2',
    'AeKMya2nzBXwyZXil8Xa4qyTAWw2',
    'AvWslmACNUQve0maaFYNw30xeZG3',
    'AyPzBalFauUKAg7pi6vFJ6LqLnb2',
    'B5LHxUlZFlajzATbQPVBfPIjghD2',
    'B5l5OEv8GAYHcBcd7SlQvRBqwba2',
    'B8099kDtMGPvpIgYMx1NrxG9XOv1',
    'BAOiGV5QitbNQdJOrf3BgMEeRB63',
    'BO6k7qXBdnha5hX1peOsQRxjxHV2',
    'BSthyLQv1NdwCKOmPMSnYnj340u1',
    'BWaCjIZwsgbCDFpDeaOT3CtVnzc2',
    'BogeVdUqNheHcbOHoUnPa39cDZo1',
    'BxkxxOaXeKcuA4evE81Ve88AK8I3',
    'C0Ec7vaEiMOrNOvwTIbVefX0Jpv1',
    'C1Lg3hNNtUQLgnauYiYJRQ8kfsL2',
    'C38wXYtAYhayIXuPCL514ufERUr2',
    'C6EDoOTm1NeU0EimFmGpAr5QwAh2',
    'C8TzHvoCpqVlq1Wi9iAuOWGI9fg1',
    'C98GnWM8hsZk4iUiJjWr98aWk352',
    'CNIClFMQyLOY9endKY1urhhSNOl1',
    'CT1BA6ftSDWDZLL2rGoqbkTD6kD2',
    'CWjBHzsebNhnsCFX7wlVIWZYDaH2',
    'CpiDOVzkCDP8fKXseeqeLZLMQTg1',
    'CvfIL0zEzzfTyLuT29PbiF2fBkn2',
    'D6Z0oo3Ew5WVtaAbhQI6rlHefpf2',
    'DA891IQqxnfvL128IA5gb0m5cHg2',
    'DLFvKT7w2LfXZaT2ItK5ttQpEeL2',
    'DaxRHjRqaaUBagQtXt2mMYCF8073',
    'Dg1cGNv5N1RA8MoC9X4qzYQG4qY2',
    'DpQx14UNs5ZJzuUacIOMsxvJTip1',
    'DputyIhpezTtLKayhe7EjFiO25I3',
    'DpzFcKKRWpgU8atMQPMzZW4URnq1',
    'EBiXqRPbTeVu5ZliJ10OzsJEYGU2',
    'EEFvtpWxYeeLy3MS9IsnHrqx9rI3',
    'EFc59Jvxi2f8j7glcI5PWZILDr43',
    'EI0MsJEbQ1UdmjbClhHpd8ub9CF3',
    'ERbaw0Fw23RqicCCcdrjUQQ5Qdz2',
    'ET7ozw3lwOMEjEIGw6hu9NwPBJI2',
    'EU9sbCLXUqdRqVhzWz89BZuEaN73',
    'EUBd8aaAMpRkxbV6GD6LqIL0HDs1',
    'EdqWM0uXQ5gHdQEQmzQBELPsH0m2',
    'EiBNnB3cnOOR1MZ5WTGBINMmFz92',
    'EnMuOEncD8Ne7xmhkTrZr7ditVj2',
    'EsgPIthLMvOHomQROdIdtDCyxBk2',
    'FNAHAV1iGAbLHTwtuXvrGkNW4qp1',
    'FRgASLOLfgb9TmJtWU86iT4kl973',
    'FWJAKZZol3R4ogqzgWkx3hSo3b93',
    'FY4PfsaSF6eBpAelPajCpIbKQo53',
    'FcbygEcQW9RmkZ1xSR5ZpEUO6Mv1',
    'FfXKqL8P5lXFVnoS1XO5zWltrWp1',
    'FfiAt7kHEBaMS9Tyxa1tTUg0ZF62',
    'Fs10G8ozP3g3vmykmUUgFiLK9Af2',
    'G1xFCnOuvuTMbmzOPORvqL6zNeg2',
    'G5DujAnn4cfsO2flCefb9SeqWS33',
    'G8lIxfx0kjOLpEFZQ7sVS1pPfSi1',
    'GKijn8vLG3UYzks2RObfUxjlxbs2',
    'GO7wY9ihyIO38HBZO1re7FPRQ742',
    'GQsbBBfWO3etX2lwpXNwtYvKtou1',
    'GSALJy5vAcPSL6HEp7m9bv4Thkr2',
    'GVPXhlWtaDUzjwox5tOkx2xiaVA2',
    'GsECIi71vSZkIgcbgSF9KUyKsIr1',
    'Gv22sv78p7YXgpXPfmkYJVg9KMo1',
    'HIUraqRJ9JdWzk6269f5kxOMkI33',
    'HKNqkMty2oYSBRJwMeyBA5YRDBs2',
    'HKStgsjxtzRIxT2RuIaOjAeh1y12',
    'HTpJGLfBxaWvEYyPse7H6DgNRBh1',
    'HcYobE7g4ldPdmoescfemNO1wqo2',
    'HfPXwIddZJbFcLBuQWAYu67iloM2',
    'HprPETYfX9b4T2tKrFFuFoqLLeO2',
    'HuiGVMzVWucXqOSTS49a1eB0cgd2',
    'Hw7oJJrxpzPDDvjQuqQ2mI2OI8k1',
    'I19xepyKkzLE5mRPAHzpChEbQc72',
    'I1QZtc24rrSVEmc3L4fu36uWWxJ3',
    'I59yhsZfgldFquCnLIMRbgoH0fu2',
    'IAjen1vJwSOUqJuS0DBayy56HlJ3',
    'IDO9T7VwzbZ7KIydCnFWLCPA2ho1',
    'IG53XK9rX1Tikz18b1EnOwg8NSI2',
    'IYQLuvGygecILCDaxpMHYCu1FhA3',
    'IZEACQwA65NmNNndHI7DpUbk4xU2',
    'IdKKcTTZXhhTQhpiKyxc5vClqWM2',
    'IdSo7zq477gD9SezVdFHqzuP9KI2',
    'IhBQ3DeTPGY7VmcjWQL2dpeEGqt1',
    'IhpT082b4KQYFBouUpnekYAWbtf2',
    'IoiMj1aXrQULqYsMgEh4lk365Bm1',
    'IulgMCyp3NZQQGDhXm0YFsBesMF3',
    'J2oZSLZ7khMIwRaUvWL57A6bD112',
    'J8pAP8EFPJP0fCKjiosl8kuTER63',
    'JCG4k9AjNuXMMzfd9rmTfjtO39g2',
    'JSQuGdh3nQebLLidIl7ct7iCIJi1',
    'Jiswa2uYm0QwUjqrPNob9y5HZth1',
    'JltfQVgDaqX2iae9k44EqV8E4a43',
    'Jnrovlwuj3Ukssyriw82gRiuLJ82',
    'JprmpKNn1IgXVnsyP6yPAUKHrPC3',
    'K4tK2qVoY3VnTiEw1TaXdVvWKhN2',
    'K8mOfUvjAwbrtwQDJpKDWQIdVfI3',
    'KGhCDPmqcGVzpzFbj4hUv8YZYBv2',
    'KOESvFbdOgeMRiecIdwIqKEqsQo1',
    'KXe7v6Mzo0WtDYXPx8gmQTxhHOX2',
    'Kg4i1dry2Lf2YU4gDAYGtFjIWIc2',
    'KltywJykvaVTNd8eMGURh6MPMms2',
    'Kluwjt9tZBYAd2rk9UOlr4MYaR32',
    'KnaM4AuV9XR4IZ3XvUvMifpMJWh2',
    'KviLbFJklZcLXVrjfEuXboFK6BH2',
    'KyhRtP2exfbGg7CrJb1awgxIRY73',
    'KzratwNBWeMTkUOCTQHFoEYJASB3',
    'L3Ko4bWPn2cVgDYM7NFolR5zr063',
    'L3nfBNqqAGclUXaCJOgyU0utjnA2',
    'L9gppW4TIQhcPOmInaa61uGEnWW2',
    'LGXAmYUKY5SXAwkMm8Q2Tv8gPb53',
    'LITfqIzziQSHwijJJ2CZK0u5pYn1',
    'LLgYdFvB7bWlu5AlhC6nP7CACBz1',
    'LPKy3QNLEZNFDkTh6er7I1tq1Cs2',
    'LXUNXTLdj7esjSChOXCcWUxIDbY2',
    'LYfhyoohEUc9beHuNcXcgAM8bVr2',
    'LZ6EcNOV15XkcpDMno97lG0laqg2',
    'LZXs17LUMude4Aln4bVPRN5FrkP2',
    'Lt2TFujeBoTDxhLFJeupGbskhhR2',
    'LtOfogic8vbDhA39iQvTlZ1FP3O2',
    'LucFJCcZpfSFMno26oCLmyZkkVC3',
    'Lw9AptZiebT7DCJvWmFjPyz3dpA2',
    'LxlX14C02zgtU0hFppisFL8wGVn2',
    'M2vpPly4wMYb3cBC4OiyGwp6wJI2',
    'MMKgSCLWQUUIBYxptoVhTFVINYg1',
    'MMt9tIkobZdUosAOBe7P8digsay2',
    'MTDq7kLQz5U0y5x05zKN5QzNAeW2',
    'MbjkVR1m83ed2ldBP4CqgUhQBGg1',
    'Mep0NxXwSSSbxGdHFHgPzwgMkWP2',
    'MiBDbmPJR6QUUbKvMcPUJDPeMsU2',
    'MqS5c7vyyaMMltayw1b1dmYdn2H3',
    'N2iT592TxyZsG6lt3dOJdnVmQdu1',
    'N7Zh5dt3xraXZXaiZAimLVRQjpB3',
    'N8YZVmh6UfVHBiG8cyhoiLxSYtD2',
    'NPORrpKiLbUjQxupV1h7iw7uzOy1',
    'NgGxAFmdpZbISIu4DmnL43w9jVi2',
    'NgdFI7986CZukYcLltE7Z0oGkam1',
    'NjO4PClStjQdimhuM2WFyk82wZt1',
    'NoaFroEoivRiCGPZEMHTH6qxMVp1',
    'O2XjmwnijBaiUWAUsNiQSVTlZ9v2',
    'O55mLHNgL1SnovWInJzzrI578ev2',
    'O9rLdKRVwRU3r4oW5y5JYNPH6lf1',
    'OK7SfWZoqfTDaL3CrORVYuydUCp2',
    'OLQaPj5vgxO71ej0auCK1V9tbnh2',
    'OQBDbXYufIc3kXvx3oH1OaSGJTJ3',
    'OXogfig6XbVbO5G2RF3wrX9MB4W2',
    'OYC7EfUTjaSfaQK9zwchPR6Oq4C3',
    'ObxJhA89EFMY94lkiSKTr4OViow2',
    'OcG5PdO4nYUu1HKnXSlmIz9ab1Z2',
    'Oe7wwYQ1AxWfENs6BUYTAFEKVKB2',
    'Ol3YWJXVz2OD0i2XsfSRcbiR7xo2',
    'OnIoUusPtggltkPl553XFzDp5dr1',
    'P2o6liMaLOYMtqmLKag4c3Ya0Ut2',
    'P3Ntj6KNh6TMAhnL6p1oC7zC24x1',
    'PAiVw0Omw3XuIOG9pvTRb09gzH82',
    'PBHTodR11VPpIdT2AaJoxE66TWi1',
    'PCzx7jUprHhYMU30mY2mwzlc2B73',
    'PDkjxI9pk1Q3jUzIRJwNPWrMEio1',
    'POlwadliH6czhpIPR5Ymy3hew5j2',
    'PR9AyyuZPTMHi1XW4pgGllbUwPI3',
    'PZDtOP0xy1hNFqtiSd99yGH6YUc2',
    'PlN6WzIQBwgdOuNRo3JFTglqI1z1',
    'PmCRNDOroEdddjOA588Mwxq2slU2',
    'Pp4CpndGSeWGuKi8xFHLM9wFBlg1',
    'PqoOsdzbpVTDpnzpgauxiYYMQfg2',
    'QF256LSeCdbqWfwSWF5o83FA4Is2',
    'QMLPrVBrWbNVU1LGet6wX5c4FW43',
    'QPT9tax2qdhrhXABMZpcQswv6yb2',
    'QU2edHjsjtPfVDJInIz0LuOlzFl1',
    'QVYjHR7zyUaHBzU8USmEsP8Gas32',
    'QWUUYlDFgBQPlJNihfRdrV3qTyY2',
    'Qa7WlkRadQTbeeavCDSrEEaPpSk1',
    'QczzgzwnOacjcFW8EtJ77MGCi1I3',
    'Qf1jfdJlb6cCqCmSxobg6SDkKD73',
    'Ql68FhksbxN5NQ3bGcjZEG5q5QH3',
    'QqothU5GuFeN7R0Kyasa0UUvSmW2',
    'QwF1x2Mmu9Vyd1fxqQUFXcRirxa2',
    'Qyn4edp8PxaXSpYEkhL5BaWF0oY2',
    'R33N6Wqij5diZYuuPZwWpWRD9K22',
    'R4cz6NXMTnY8qb6doTQb2Wph0BE3',
    'R5A0YulVTZZrpzv4n2gSqvkFZep2',
    'RBm8rYG81LVY8wHi7kvobG9pUe13',
    'RMBBN95723RxwekXjOvultljy3n2',
    'RN4NBH5CL9hPXNpv75kgSWyP9ft1',
    'RUPfqpcaVHhJ48KHM9wxaE6VSxL2',
    'Rcwrv3bguCOl0cDsii851tskHv23',
    'RlVis0LS81Y29EvbUvSdkGKE00K3',
    'Rt4LykH0gaYaimuxylnBoJpM2u42',
    'S4viVPw5gBXkL7cNVsqhyHJMQ2w1',
    'S7zRFlv0KdTWPA1SYscxzrOZsoG2',
    'S8tJ5HlL8DXSiXvUZQ9JyE8cKw62',
    'SDGo5F0p1RQ41qt3PueZZ7OlIAu1',
    'STKWcpSY76Tk21Zmx6qoCClKrxV2',
    'SdHt1AUX4xbfdu63tOYrVBDVjhK2',
    'SjxGiAoHeSNElzUDj51fbyhsKD23',
    'Sk5NC0mdZQbVAbWGCuPjpvnjfj23',
    'SotzZabnrnN0mJGwBIpI1UjhDKt2',
    'Sr7jkDxcXyYwhkgLNrEI4FcHdg92',
    'StEqmr7OdMeqiecafMTp9kHsYF02',
    'SvidC9k3gcfC3SryJT4gkxsBPL92',
    'SzPW5jdZzkfUnZdXnw4Cir5pM4B2',
    'T2g7FGwbi9e99UBuakvQKKMvgwA2',
    'TFLsMMi0IEc00t0Zdxg1A9f6JXD3',
    'TH6fHjl7D7Yz7bl9rPHl3hJaq9p2',
    'TPRjVvSRU3aQUIBQhO2fltuucUG2',
    'TcihrXQNKLOJxy9NOHv2Z1aOlH63',
    'Tg5LDuNRPghhE2vIdMLBJszPN103',
    'TiiiFPEw7IZtUT7WkxBK7zSVCBc2',
    'TpYMN1g2UZQPVXctnshspk1kuW82',
    'TpeMNtt2L8Ra5k0YWtlOiNmzJwi1',
    'TrRVSnRAniZSJ2JawHXEp4UYfyg1',
    'TzFGe48hsKbSIz082bsvAu6SzF52',
    'U2q8lacqFoW0P09gJnnG5H5sH6m1',
    'UBBC5mdLyUMOMni3AvFCosdUgbr2',
    'UJvZH7zo3HWQrsnZYSRgR9vxRNw1',
    'UUVbYlsnqLPkstvpBTUhTH1s5DM2',
    'Uei9uk0MVsfD1Rk1VRgtwi4EQBz1',
    'Up7v5EGwP4PTDxJxX3mNKMDk3QS2',
    'V6JIIqTfk3cG1AkNLPScJiXWjvH2',
    'VBbuxxe897OzHvPslrx3Yu7zO8X2',
    'VD8noU9FvKV2132Os74NC4hKpqR2',
    'VN1fW4e9SvU2arkgqAyhJ3fEQ032',
    'VVpnmlF3CxeQw8KsraduWVIJCAn2',
    'VdsVg1gkbCZSVFyrJG2GieZxkeO2',
    'VtqudiHkLDRBVNXjeEcqKsW02z12',
    'Vy47DXu6IUUZA0ncrxB1FJ86HLA2',
    'VzNdYeqnfPQ1x1FfYxYwdZCiGg83',
    'WF3efnifpRWNm85cMpmDcXokvfX2',
    'WHCvgH2T37VaNkPGbbp1SFJQsRF2',
    'WMiU9sweqrRsSi9SwxYigSy8uB02',
    'WRhWApzL6bZUGsPjtINiP94kesv1',
    'WXUam5lFHkdt9MhkMD53njxbZhs2',
    'WXqc1MsZPGVpqiYDv37OljfbotN2',
    'WcexEsSCDATa3evVZl2G3awUfM33',
    'Wg4ezx2ddAfLSdfQxMPhT2cIEBR2',
    'Wi7Ka1NOFAe709j246oEZ88iNCe2',
    'Wj0C2Mus2zNBRhT9jVY9qge97D43',
    'WloAZfpfuAZfvY7dJyy1fEHRyxW2',
    'WqMxwghFfAb8x37vr5wChBBHGja2',
    'X0frINbBwcO9tA8OoMS6hDV5aZT2',
    'XArimGclRaORbGZu0P3WggZGF0S2',
    'XK8zi5ApFAQbrVPotScUcs4jRdy1',
    'XXho2I3iOERTHcUcxQO5lbOMBUC3',
    'XZC1Tf3wluVai04s36jpBJ6smTG3',
    'XZhdd77V24f5obO3sGDOwJlLPO92',
    'XrNbBrgTWagqcdS5TlfdNdqADBf2',
    'Y52CgMexaOR8rW6uFUVaNutqVPR2',
    'YA9xn3ZjpAZRtgj0AqliNCGIR8g1',
    'YChM0PH7AAYmCadmWwvcrAAB4Ii2',
    'YCo3a1JcVJcORoDLRiCw9A4kqqE2',
    'YElSWa7SXve7p6ciLm36DrntLeO2',
    'YGZZuMfRjAb38WBqWIeK499JUJI2',
    'YTkCCRKG1Qb9w73eE1KtOwR92kB2',
    'YVmTAOrx1OVBrskXPDpK7JuyCfl1',
    'YaQKMyHfodTPmDH49ubfo0wlHQ93',
    'Ygp2ycgrmdP9gV5gDo6UuwqDxfx2',
    'YrDLUM4Ny4aM1J4sSMAFeqU6M172',
    'YrUYri4hQuYauku44KyVOMeIG6m1',
    'Z0Cp0DIFWVc7dG9EJAzhrAyvuQ63',
    'Z0ZT3kYwVbSkESP8jWc39At4pT02',
    'Z8H0GINA6CUlTYYIbwdA0yfN8lE3',
    'ZCeCBKxXZlhD86C7M2rVvAqMUFw2',
    'ZYJ3sZJgRdhJ0RYefhAEK3mXjEo1',
    'Zgs1HeftuETu37PYW9a0uaHFu662',
    'ZiUpOe18EJQMQhfFJNBvjzTl7a43',
    'Zmv7loEFzvUNZYr35gaYjQ69rv22',
    'Zrt4Z23SAwf0h1sV44zVFWgJdUc2',
    'ZtV4gUSqJubo6IAjKRa8cJJiB9A3',
    'a3aLtKRCxoZLWIKfk0FrVeNoO6m2',
    'a4RHqPptDvcbpIuiJ7JLQPefLxX2',
    'a61bLhkB4WYqu8sSktjSaUM6JhH2',
    'a9KzOMhoxfNiSezc17XTwtCvehq2',
    'aHqQJlP7hrQX2HH2TpIvDHvL8UQ2',
    'aOkuEAGlRQfcfdJ1nqj5hi9ryiA2',
    'apdKblrxtCeBDywxC8bRLNZSTWF2',
    'auPnp7zNIIbFYbOsMnkBbWsxi223',
    'azeBAIBCeFMOD6R4FFMjfX8ODoT2',
    'bAUe8mvIDSe6wwv7JPN1e3r7fQX2',
    'bMKrj8ZHJ5gI49RBoxJOi48Vf9C3',
    'bW3K3K0Mhgh6YdOX91CTuJWz17T2',
    'blObh0fTCKTmXMbglieaQ1OEFKZ2',
    'buSX9hmYOwOjkoHw20BOA6XbHBB3',
    'c4SlfX297DcXpDyYdwUpEOHnQk92',
    'cIXogUPuLyZ5yCh2o99zM0ftLSm1',
    'cQDc4q3j96YJU2h80J5Tl3Gz6nw1',
    'cc4fuRxIZZN6RagiUY9vNA9Fg7q1',
    'cnCrdiYsYZXqIJvbR75o8O6a8g82',
    'csRnx7fCtVdUx4gXnN10k5ZnyG33',
    'cwvSrApeeBeS8L5BojCAeysnVOE2',
    'd6of8iK4WSNZCbp4oiOdWGZfahH3',
    'd6ugpzZPgwRWM34HGqbilnKFWeF2',
    'dFXL5VnRszSloeRSvVrd8NnqPCa2',
    'dQHJJ7eKtZVNrrJAJ1xdwFTlmmd2',
    'dTEo0HdYVGdila54B5oElOpyIyJ3',
    'ddudc5X4XONAyg5j1ehcCzA9px73',
    'dnApdVGqWMUCb0mI2c9cYxcyY6w2',
    'dpAbnLjB9tZrqSkt60TwYcKyR7M2',
    'dqFEd5si7dbAHH6IPvur9sUq2cJ2',
    'du0zJPeNG0dGtUvspQBfnngoNTp2',
    'dvTZKKKewHcRnmFS5dxOJAx2a3u2',
    'dwzAx3ApY3gNeziu3AO0EINY8k72',
    'eBeVtZonTvQMaf6lhG83GhrOLFD2',
    'ePqc0QiCbaTJIBrLUnsTBnxxXUf1',
    'eRJfgYF9TTRvJRPVU7krNsga1ll2',
    'eUpZamWSlkhT7ly2vYLZ10e3Azm2',
    'eVVMSA9rsLe1FNBR57mjlD5vdIq1',
    'eZbbmvxJkUbVgYg3dd0huiPHP8Y2',
  ];

  Future<void> fixRestaurantOwnerCredentials({
    List<String> skipRestaurantDocIds = const [],
  }) async {
    try {
      isFixingRestaurants.value = true;
      fixedCount.value = 0;
      errorCount.value = 0;
      totalProcessed.value = 0;
      skippedCount.value = 0;

      // Get admin credentials
      String? adminEmail = preferences?.getString('adminEmail');
      String? adminPassword = preferences?.getString('adminPassword');

      if (adminEmail == null || adminPassword == null) {
        Get.snackbar('Error', 'Admin credentials not found',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        isFixingRestaurants.value = false;
        return;
      }

      // Fetch all restaurants and filter those with email and password
      QuerySnapshot restaurantsSnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .get();

      // Filter restaurants that have both email and password
      final restaurantsWithCredentials = restaurantsSnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final email = data['resEmail'] as String? ?? '';
        final password = data['password'] as String? ?? '';
        return email.isNotEmpty && password.isNotEmpty;
      }).toList();

      print('Found ${restaurantsWithCredentials.length} restaurants with email and password');
      print('Skipping ${skipRestaurantDocIds.length} restaurants: $skipRestaurantDocIds');

      int processed = 0;
      int fixed = 0;
      int errors = 0;
      int skipped = 0;

      for (var doc in restaurantsWithCredentials) {
        try {
          final restaurantData = doc.data() as Map<String, dynamic>;
          final restaurantDocID = doc.id;

          // Skip restaurants in the skip list
          if (skipRestaurantDocIds.contains(restaurantDocID)) {
            skipped++;
            skippedCount.value = skipped;
            print('⏭️ Skipping restaurant ${restaurantDocID} (in skip list)');
            continue;
          }

          totalProcessed.value = processed + 1;
          processed++;

          final email = restaurantData['resEmail'] as String? ?? '';
          final password = restaurantData['password'] as String? ?? '';

          if (email.isEmpty || password.isEmpty) {
            print('Skipping restaurant ${restaurantDocID}: empty email or password');
            skipped++;
            skippedCount.value = skipped;
            continue;
          }

          print('Processing restaurant: $restaurantDocID, Email: $email');

          // Check if auth user exists by trying to sign in
          String? authUid;
          bool authUserExists = false;

          try {
            // Sign out admin temporarily
            await FirebaseAuth.instance.signOut();

            // Try to sign in with restaurant credentials
            try {
              UserCredential userCredential =
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: email,
                password: password,
              );

              if (userCredential.user != null) {
                authUid = userCredential.user!.uid;
                authUserExists = true;
                print('✅ Auth user exists for $email with UID: $authUid');
              }

              // Sign out restaurant user
              await FirebaseAuth.instance.signOut();
            } catch (authError) {
              // Auth user doesn't exist or wrong password
              print('⚠️ Auth user not found or invalid credentials for $email: $authError');
              authUserExists = false;
            }
          } catch (e) {
            print('Error checking auth user: $e');
          }

          // Create auth user if it doesn't exist
          if (!authUserExists) {
            try {
              await FirebaseAuth.instance.signOut();

              // Create new auth user
              UserCredential userCredential =
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: email,
                password: password,
              );

              if (userCredential.user != null) {
                authUid = userCredential.user!.uid;
                print('✅ Created auth user for $email with UID: $authUid');
                fixed++;

                // Sign out restaurant user
                await FirebaseAuth.instance.signOut();
              }
            } catch (createError) {
              // Check if error is due to email already existing
              if (createError is FirebaseAuthException) {
                if (createError.code == 'email-already-in-use') {
                  print('⚠️ Email $email already exists in Firebase Auth, but sign in failed. Skipping.');
                  errors++;
                } else {
                  print('❌ Error creating auth user for $email: ${createError.code} - ${createError.message}');
                  errors++;
                }
              } else {
                print('❌ Error creating auth user for $email: $createError');
                errors++;
              }

              // Sign admin back in and continue to next restaurant
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: adminEmail,
                  password: adminPassword,
                );
              } catch (signInError) {
                print('Failed to sign admin back in: $signInError');
              }
              continue;
            }
          }

          // Sign admin back in
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: adminEmail,
            password: adminPassword,
          );

          if (authUid == null) {
            print('❌ No auth UID available for restaurant $restaurantDocID');
            errors++;
            continue;
          }

          // Check if restaurantOwner document exists with correct auth UID
          final ownerDocByUid = await FirebaseFirestore.instance
              .collection('restaurantOwner')
              .doc(authUid)
              .get();

          // Also check if restaurantOwner document exists with same email but different docID
          final ownerDocsByEmail = await FirebaseFirestore.instance
              .collection('restaurantOwner')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

          // Find owner document with mismatched docID (if any)
          DocumentSnapshot? ownerDocWithMismatch;
          if (ownerDocsByEmail.docs.isNotEmpty) {
            final existingDoc = ownerDocsByEmail.docs.first;
            if (existingDoc.id != authUid) {
              ownerDocWithMismatch = existingDoc;
              print('⚠️ Found restaurantOwner document with email $email but different docID: ${existingDoc.id} (should be $authUid)');
            }
          }

          if (ownerDocByUid.exists) {
            // Document exists with correct auth UID
            print('✅ RestaurantOwner document already exists for $email with correct UID: $authUid');
            
            // If there's a duplicate with mismatched docID, delete it
            if (ownerDocWithMismatch != null) {
              try {
                await FirebaseFirestore.instance
                    .collection('restaurantOwner')
                    .doc(ownerDocWithMismatch.id)
                    .delete();
                print('✅ Deleted duplicate restaurantOwner document with mismatched docID: ${ownerDocWithMismatch.id}');
                fixed++;
              } catch (deleteError) {
                print('❌ Error deleting duplicate restaurantOwner document: $deleteError');
              }
            }
          } else if (ownerDocWithMismatch != null) {
            // Document exists with same email but wrong docID - migrate it
            try {
              print('🔄 Migrating restaurantOwner document from ${ownerDocWithMismatch.id} to $authUid');
              
              // Get the old document data
              final oldData = ownerDocWithMismatch.data() as Map<String, dynamic>;
              
              // Convert restaurant data to map (create a copy to avoid modifying original)
              final restaurantDataMap = Map<String, dynamic>.from(restaurantData);
              restaurantDataMap['docID'] = restaurantDocID;

              // Prepare owner data with correct auth UID
              final ownerData = {
                'docID': authUid, // Auth user's UID (same as document ID)
                'contact': restaurantData['phoneNo'] ?? oldData['contact'] ?? '',
                'createdAt': oldData['createdAt'] ?? restaurantData['createdAt'] ?? FieldValue.serverTimestamp(),
                'email': email,
                'img': (restaurantData['imagesList'] != null &&
                        (restaurantData['imagesList'] as List).isNotEmpty)
                    ? (restaurantData['imagesList'] as List).first
                    : oldData['img'] ?? 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg',
                'password': password,
                'restaurantData': restaurantDataMap, // Contains restaurant's own docID inside
              };

              // Create new document with correct auth UID
              await FirebaseFirestore.instance
                  .collection('restaurantOwner')
                  .doc(authUid)
                  .set(ownerData);

              // Delete the old document with wrong docID
              await FirebaseFirestore.instance
                  .collection('restaurantOwner')
                  .doc(ownerDocWithMismatch.id)
                  .delete();

              print('✅ Migrated restaurantOwner document for $email from ${ownerDocWithMismatch.id} to $authUid');
              fixed++;
            } catch (migrateError) {
              print('❌ Error migrating restaurantOwner document for $email: $migrateError');
              errors++;
            }
          } else {
            // No document exists - create new one
            try {
              // Convert restaurant data to map (create a copy to avoid modifying original)
              final restaurantDataMap = Map<String, dynamic>.from(restaurantData);
              restaurantDataMap['docID'] = restaurantDocID;

              // Prepare owner data
              final ownerData = {
                'docID': authUid, // Auth user's UID (same as document ID)
                'contact': restaurantData['phoneNo'] ?? '',
                'createdAt': restaurantData['createdAt'] ?? FieldValue.serverTimestamp(),
                'email': email,
                'img': (restaurantData['imagesList'] != null &&
                        (restaurantData['imagesList'] as List).isNotEmpty)
                    ? (restaurantData['imagesList'] as List).first
                    : 'https://s3-media2.fl.yelpcdn.com/bphoto/iCP4QYCjWf9i-qDIBQrsnQ/o.jpg',
                'password': password,
                'restaurantData': restaurantDataMap, // Contains restaurant's own docID inside
              };

              // Create restaurant owner document
              await FirebaseFirestore.instance
                  .collection('restaurantOwner')
                  .doc(authUid)
                  .set(ownerData);

              print('✅ Created restaurantOwner document for $email with UID: $authUid');
              fixed++;
            } catch (ownerError) {
              print('❌ Error creating restaurantOwner document for $email: $ownerError');
              errors++;
            }
          }

          fixedCount.value = fixed;
          errorCount.value = errors;

        } catch (e) {
          print('❌ Error processing restaurant ${doc.id}: $e');
          errors++;
          errorCount.value = errors;

          // Ensure admin is signed back in
          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: adminEmail,
              password: adminPassword,
            );
          } catch (signInError) {
            print('Failed to sign admin back in: $signInError');
          }
        }
      }

      isFixingRestaurants.value = false;

      Get.snackbar(
        'Fix Complete',
        'Processed: $processed, Fixed: $fixed, Errors: $errors, Skipped: $skipped',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

      print('✅ Fix complete: Processed=$processed, Fixed=$fixed, Errors=$errors, Skipped=$skipped');
    } catch (e) {
      isFixingRestaurants.value = false;
      Get.snackbar('Error', 'Failed to fix restaurants: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print('❌ Error in fixRestaurantOwnerCredentials: $e');

      // Ensure admin is signed back in
      try {
        String? adminEmail = preferences?.getString('adminEmail');
        String? adminPassword = preferences?.getString('adminPassword');
        if (adminEmail != null && adminPassword != null) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: adminEmail,
            password: adminPassword,
          );
        }
      } catch (signInError) {
        print('Failed to sign admin back in: $signInError');
      }
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
