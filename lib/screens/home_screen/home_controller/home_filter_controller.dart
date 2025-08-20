import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/resaturant_model.dart';

class HomeFilterController extends GetxController {
  var filterItem = <FilterItems>[].obs;
  final searchController = TextEditingController();
  var cusinesMapFilter = <String, List<String>>{}.obs;
  var selectedTop = ''.obs;
  var _originalCuisineMap = <String, List<String>>{}; // Store original map

  @override
  void onInit() {
    super.onInit();
    loadFilter();
    // Add listener for search text changes
    searchController.addListener(_filterCuisines);
  }

  void loadFilter() {
    // Dummy data. Replace with your actual data source.
    filterItem.addAll([]);
  }

  void initializeCuisinesSelectors(Map<String, List<String>> cuisineMap) {
    // Store the original map and update filter
    _originalCuisineMap = Map.from(cuisineMap);
    cusinesMapFilter.clear();
    cusinesMapFilter.addAll(cuisineMap);
  }

  void _filterCuisines() {
    final searchText = searchController.text.toLowerCase().trim();

    if (searchText.isEmpty) {
      // Restore the original unfiltered map
      cusinesMapFilter.clear();
      cusinesMapFilter.addAll(_originalCuisineMap);
    } else {
      // Filter based on search text
      final filteredMap = _originalCuisineMap.entries
          .where((entry) => entry.key.toLowerCase().contains(searchText))
          .fold<Map<String, List<String>>>({}, (map, entry) {
        map[entry.key] = entry.value;
        return map;
      });
      cusinesMapFilter.clear();
      cusinesMapFilter.addAll(filteredMap);
    }
  }

  @override
  void onClose() {
    searchController.removeListener(_filterCuisines);
    searchController.dispose();
    super.onClose();
  }

  Stream<Map<String, List<String>>> getRestaurantsGroupedByCuisine() async* {
    print('Fetching cuisines list ----------------------------');
    final firestore = FirebaseFirestore.instance;

    final restaurantsSnapshot = await firestore.collection('restaurants').get();

    if (restaurantsSnapshot.docs.isEmpty) {
      yield {};
      return;
    }

    Map<String, List<String>> cuisineMap = {};

    for (var restaurantDoc in restaurantsSnapshot.docs) {
      final restaurant = RestaurantModel.fromDocumentSnapshot(restaurantDoc);
      for (var menu in restaurant.menuList) {
        if (menu.cuisineType.isNotEmpty) {
          if (cuisineMap.containsKey(menu.cuisineType)) {
            cuisineMap[menu.cuisineType]!.add(restaurantDoc.id);
          } else {
            cuisineMap[menu.cuisineType] = [restaurantDoc.id];
          }
        }
      }
    }

    // Update original map when new data is fetched
    _originalCuisineMap = Map.from(cuisineMap);
    cusinesMapFilter.clear();
    cusinesMapFilter.addAll(cuisineMap);

    yield cuisineMap;
  }

  Future<Map<String, List<String>>> getRestaurantsGroupedByAddress(
      {String? city}) async {
    final firestore = FirebaseFirestore.instance;

    QuerySnapshot restaurantsSnapshot =
        await firestore.collection('restaurants').get();

    Map<String, List<String>> addressMap = {};

    for (var restaurantDoc in restaurantsSnapshot.docs) {
      var restaurantData = restaurantDoc.data() as Map<String, dynamic>;
      var address = restaurantData['address'];
      if (address != null && address is String) {
        if (!addressMap.containsKey(address)) {
          addressMap[address] = [];
        }
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
