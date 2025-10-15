import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/models/sub_admins_model.dart';

import '../models/user_management_model.dart';

class DrawerControllerX extends GetxController {
  RxString selectedType = ''.obs;

  SubAdminsModel? subAdminsModel;
  // Active screen state
  RxInt selectedScreen = 0.obs;
  var isUserManagementExpanded = false.obs;
  var hoveredItem = "".obs;

  void changeScreen(int screenNumber) {
    selectedScreen.value = screenNumber;
  }

  void toggleUserManagement() {
    isUserManagementExpanded.value = !isUserManagementExpanded.value;
  }

  void selectMainScreen(int index) {
    resetAllBooleans();
    selectedScreen.value = index;
    print("Main screen selected: $index");
  }

  //SubScreens
  RxBool showCreateNotifications = false.obs;
  RxBool showNotifications = false.obs;
  RxBool showProfile = false.obs;
  RxBool addRestaurants = false.obs;
  RxBool viewRestaurantsDetails = false.obs;
  RxBool userDetails = false.obs;
  RxBool addSubAdmin = false.obs;

  RxBool viewEvents = false.obs;
  RxBool viewEventsGallery = false.obs;
  RxBool addEvent = false.obs;

  RxBool addDiscoveryLists = false.obs;

  RxBool viewClaimsDetails = false.obs;

  RxBool viewBannerDetails = false.obs;
  RxBool addBanner = false.obs;

  void resetAllBooleans() {
    showCreateNotifications.value = false;
    showNotifications.value = false;
    showProfile.value = false;
    addRestaurants.value = false;
    viewEvents.value = false;
    viewEventsGallery.value = false;
    addEvent.value = false;

    addDiscoveryLists.value = false;

    viewRestaurantsDetails.value = false;
    userDetails.value = false;
    addSubAdmin.value = false;
    viewClaimsDetails.value = false;
    viewBannerDetails.value = false;
    addBanner.value = false;
  }

  // Add this to store the selected user
  Rx<UserManagementModel?> selectedUser = Rx<UserManagementModel?>(null);

  void setSelectedUser(UserManagementModel user) {
    selectedUser.value = user;
  }

  void clearSelectedUser() {
    selectedUser.value = null;
  }

  getCurrentUserData() async {
    try {
      // Get current user
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Get.snackbar('Error', 'User not authenticated',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return null;
      }
      print('currentUser.uid ${currentUser.uid}');
      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        Get.snackbar('Error', 'User data not found',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return null;
      }

      // Map Firestore data to SubAdminsModel
      var data = userDoc.data() as Map<String, dynamic>;
      subAdminsModel = SubAdminsModel(
        name: data['name'] ?? '',
        contact: data['contact'] ?? '',
        email: data['email'] ?? currentUser.email ?? '',
        passwords: data['passwords'] ?? '',
        status: data['status'] ?? 'Active',
        docID: userDoc.id,
      );
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print('Error: $e');
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentUserData();
  }
}
