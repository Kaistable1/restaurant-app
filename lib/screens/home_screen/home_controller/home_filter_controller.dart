import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';

class HomeFilterController extends GetxController {
  var filterItem = <FilterItems>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFilter();
  }

  void loadFilter() {
    // Dummy data. Replace with your actual data source.
    filterItem.addAll([]);
  }

  Stream<Map<String, List<String>>> getRestaurantsGroupedByCuisine() async* {
    final firestore = FirebaseFirestore.instance;

    // Fetch the list of restaurants and their meal menus asynchronously
    final restaurantsSnapshot = await firestore.collection('restaurants').get();

    if (restaurantsSnapshot.docs.isEmpty) {
      yield {}; // No restaurants found
      return;
    }

    // Create a list of futures for processing all the restaurants' meal menus
    List<Future<Map<String, List<String>>>> futures = [];

    for (var restaurantDoc in restaurantsSnapshot.docs) {
      futures.add(_processMealMenuForRestaurant(restaurantDoc.id, firestore));
    }

    // Wait for all the futures to complete
    List<Map<String, List<String>>> restaurantResults =
        await Future.wait(futures);

    // Merge all the cuisine maps
    Map<String, List<String>> mergedCuisineMap = {};
    for (var result in restaurantResults) {
      result.forEach((key, value) {
        if (mergedCuisineMap.containsKey(key)) {
          mergedCuisineMap[key]!.addAll(value);
        } else {
          mergedCuisineMap[key] = value;
        }
      });
    }
    yield mergedCuisineMap;
  }

// Helper function to process meal menus for each restaurant
  Future<Map<String, List<String>>> _processMealMenuForRestaurant(
      String restaurantId, FirebaseFirestore firestore) async {
    Map<String, List<String>> cuisineMap = {};

    // Fetch meal menus for a restaurant
    final mealMenuSnapshot = await firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('MealMenu')
        .get();

    for (var mealDoc in mealMenuSnapshot.docs) {
      var mealData = mealDoc.data();
      String startDate = mealData['fromDate'];
      String endDate = mealData['toDate'];
      final homeController = Get.find<HomeLocationController>();

      // Check if the offer is valid for the current date
      if (homeController.isOfferValidForCurrentDate(startDate, endDate)) {
        var menuList = mealData['menu'];
        if (menuList != null && menuList is List) {
          for (var menuEntry in menuList) {
            if (menuEntry is Map<String, dynamic>) {
              var itemsList = menuEntry['items'];
              if (itemsList != null && itemsList is List) {
                for (var item in itemsList) {
                  if (item is Map<String, dynamic>) {
                    var cuisineName = item['cuisineName'];
                    if (cuisineName != null) {
                      if (!cuisineMap.containsKey(cuisineName)) {
                        cuisineMap[cuisineName] = [];
                      }
                      cuisineMap[cuisineName]!.add(restaurantId);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    return cuisineMap;
  }

  Future<Map<String, List<String>>> getRestaurantsGroupedByAddress(
      {city}) async {
    // Initialize Firestore
    final firestore = FirebaseFirestore.instance;

    // Fetch all restaurants
    QuerySnapshot restaurantsSnapshot = await firestore
        .collection('restaurants')
        .where('city', isEqualTo: city)
        .get();

    // Map to hold address as key and list of restaurants as value
    Map<String, List<String>> addressMap = {};

    for (var restaurantDoc in restaurantsSnapshot.docs) {
      // Extract the data from the document
      var restaurantData = restaurantDoc.data() as Map<String, dynamic>;

      // Access the 'address' field
      var address = restaurantData['address'];
      if (address != null && address is String) {
        // Initialize the list for this address if not already present
        if (!addressMap.containsKey(address)) {
          addressMap[address] = [];
        }

        // Add the restaurant ID to the list for this address
        addressMap[address]!.add(restaurantDoc.id);
      }
    }

    return addressMap;
  }
}

class FilterItems {
  String title;
  String description;
  String imagePath;

  FilterItems({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
