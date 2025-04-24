import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/app_colors.dart';
import 'package:savrly/main.dart';
import 'package:savrly/widgets/global_functions.dart';
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
      update();
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

  approvedResturnatsClaims() async {
    try {
      RestaurantClaimsModel restaurantModel = viewClaimsDetails!;
      // Show loading dialog
      loadingDialog();

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantModel.resID)
          .delete();

      String docID = await assignedCredencialsLogin(
          email: restaurantModel.email,
          userPassword: passwordController.text.trim());

      final restaurantData = {
        'about': 'Coming Soon!! Stay tuned for something exciting!',
        'address': restaurantModel.address,
        'atmopshereList': [], // Empty array as per your data
        'averageRating': 0,
        'city': restaurantModel.city,
        'country': restaurantModel.country,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'dietaryList': [], // Empty array as per your data
        'docID': docID, // Will be set after adding the document
        'entertainmentScheduleList': [],
        'facilityList': [],
        'resImages': restaurantModel.resImages,
        'latitude': restaurantModel.latitude,
        'logoImage': restaurantModel.photoUrl,
        'longitude': restaurantModel.longitude,
        'menuList': [], // Empty array as per your data
        'password': passwordController.text.trim(),
        'priceRange': '', // Hardcoded for now; you can add a field for this
        'resEmail': restaurantModel.email,
        'resName': restaurantModel.restaurantsName,
        'socialLink': '',
        'socialMedia': '',
        'specialConditions': 'Coming Soon!! Stay tuned for something exciting!',
        'spokenLanguage': '',
      };

      // Add the restaurant to Firestore
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(docID)
          .set(restaurantData);
      await FirebaseFirestore.instance
          .collection('businessClaims')
          .doc(restaurantModel.id)
          .update({
        'status': 'Approved',
      });
      await getAllBusinessClaims();
      Get.back();
      Get.snackbar('Success!', "Restaurant approved successfully",
          maxWidth: 400,
          backgroundColor: primaryColor,
          colorText: Colors.white);
    } catch (e) {
      print('Error $e');
    }
  }

  Future<String> assignedCredencialsLogin(
      {required String email, required String userPassword}) async {
    try {
      // Get admin credentials from SharedPreferences
      String? adminEmail = preferences?.getString('adminEmail');
      String? adminPassword = preferences?.getString('adminPassword');

      // Sign out temporarily
      await FirebaseAuth.instance.signOut();
      print('admin logout successfully');
      // Create restaurant user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: userPassword,
      );
      print(
          'restaurant user regiester successfully with id ${userCredential.user?.uid}');
      User? newUser = userCredential.user;

      if (newUser != null) {
        // Sign out restaurant
        await FirebaseAuth.instance.signOut();
        print('logout restaurant');
        // Sign admin back in
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmail!,
          password: adminPassword!,
        );
        print('login admin again');
      } else {
        Get.snackbar('Error', 'Failed to create restaurant',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print('failf to create restaurant');
      }
      return newUser!.uid;
    } catch (e) {
      print('create reaturant issue $e');
      return 'error';
    }
  }
}
