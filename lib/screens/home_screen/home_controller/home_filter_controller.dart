import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';

class HomeFilterController extends GetxController {
  var filterItem = <FilterItems>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFilter();
  }

  void loadFilter() {
    // Dummy data. Replace with your actual data source.
    filterItem.addAll([
      FilterItems(
          title: 'Abc restaurant',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/filter_img.png'),
      FilterItems(
          title: 'Abc restaurant',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/filter_img.png'),
      FilterItems(
          title: 'Abc restaurant',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/filter_img.png'),
      FilterItems(
          title: 'Abc restaurant',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/filter_img.png'),
      FilterItems(
          title: 'Abc restaurant',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/filter_img.png'),
      FilterItems(
          title: 'Abc restaurant',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/filter_img.png'),
      FilterItems(
          title: 'Abc restaurant',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/filter_img.png'),
      FilterItems(
          title: 'Abc restaurant',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/filter_img.png'),
      FilterItems(
          title: 'Abc restaurant',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/filter_img.png'),
    ]);
  }

  Future<Map<String, List<String>>> getRestaurantsGroupedByCuisine() async {
    // Initialize Firestore
    final firestore = FirebaseFirestore.instance;

    // Fetch all restaurants
    QuerySnapshot restaurantsSnapshot =
        await firestore.collection('restaurants').get();

    // Map to hold cuisine as key and list of restaurants as value
    Map<String, List<String>> cuisineMap = {};
    Map<String, List<String>> cuisineMapWithImg = {};

    for (var restaurantDoc in restaurantsSnapshot.docs) {
      // Access MealMenu inner collection
      QuerySnapshot mealMenuSnapshot = await firestore
          .collection('restaurants')
          .doc(restaurantDoc.id)
          .collection('MealMenu')
          .get();

      for (var restaurantDoc in restaurantsSnapshot.docs) {
        // Access MealMenu inner collection
        QuerySnapshot mealMenuSnapshot = await firestore
            .collection('restaurants')
            .doc(restaurantDoc.id)
            .collection('MealMenu')
            .get();

        for (var mealDoc in mealMenuSnapshot.docs) {
          // Cast 'mealDoc.data()' to Map<String, dynamic>
          var mealData = mealDoc.data() as Map<String, dynamic>;

          // Access 'menu' array
          var menuList = mealData['menu'];
          if (menuList != null && menuList is List) {
            for (var menuEntry in menuList) {
              if (menuEntry is Map<String, dynamic>) {
                // Access 'items' array
                var itemsList = menuEntry['items'];
                if (itemsList != null && itemsList is List) {
                  for (var item in itemsList) {
                    if (item is Map<String, dynamic>) {
                      // Extract cuisineName
                      var cuisineName = item['cuisineName'];
                      if (cuisineName != null) {
                        if (!cuisineMap.containsKey(cuisineName)) {
                          cuisineMap[cuisineName] = [];
                        }
                        cuisineMap[cuisineName]!.add(restaurantDoc.id);
                      }
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

  Future<Map<String, List<String>>> getRestaurantsGroupedByAddress() async {
    // Initialize Firestore
    final firestore = FirebaseFirestore.instance;

    // Fetch all restaurants
    QuerySnapshot restaurantsSnapshot = await firestore
        .collection('restaurants')
        .where('city', isEqualTo: currentUserDataModel?.value.city)
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
