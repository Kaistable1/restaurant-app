import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/claims_model.dart';

class RestaurantsClaimsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getAllBusinessClaims();
  }

  final passwordController = TextEditingController();
  var restaurantsClaims = <RestaurantClaimsModel>[].obs;
  var filteredClaimsRestaurants = <RestaurantClaimsModel>[].obs;
  RestaurantClaimsModel? viewClaimsDetails;

// Fetch all business claims from Firestore and update restaurantsClaims
  Future<void> getAllBusinessClaims() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('businessClaims').get();
      final claims = querySnapshot.docs
          .map((doc) => RestaurantClaimsModel.fromFirestore(doc))
          .toList();
      restaurantsClaims.assignAll(claims); // Update observable list
      print('Fetched ${claims.length} business claims');
    } catch (e) {
      print('Error fetching all business claims: $e');
      Get.snackbar('Error', 'Failed to fetch business claims: $e');
    }
  }

  // Delete a business claim from Firestore and update restaurantsClaims
  Future<void> deleteBusinessClaim(String docID) async {
    try {
      await FirebaseFirestore.instance
          .collection('businessClaims')
          .doc(docID)
          .delete();
      restaurantsClaims
          .removeWhere((claim) => claim.id == docID); // Update observable list
      print('Deleted business claim with docID: $docID');
      Get.snackbar('Success', 'Business claim deleted successfully');
    } catch (e) {
      print('Error deleting business claim: $e');
      Get.snackbar('Error', 'Failed to delete business claim: $e');
    }
  }

  filteredClaims({search}) {
    if (search.isEmpty) {
      filteredClaimsRestaurants.value = restaurantsClaims;
    } else {
      filteredClaimsRestaurants.value = restaurantsClaims
          .where((subAdmin) =>
              subAdmin.restaurantsName
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              subAdmin.ownerName.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    update();
  }
}
