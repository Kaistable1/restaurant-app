import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/models/usermodel.dart';

class NotificationController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Rx<File?> selectedImage = Rx<File?>(null);
  Rx<Uint8List?> selectedWebImage = Rx<Uint8List?>(null);

  // Filter states for all 9 preferences
  RxString favoriteCuisinesFilter = ''.obs;
  RxString dietaryPreferencesFilter = ''.obs;
  RxString chooseRestaurantFactorsFilter = ''.obs;
  RxString diningPlanningStyleFilter = ''.obs;
  RxString diningPrioritiesFilter = ''.obs;
  RxString diningExperiencesFilter = ''.obs;
  RxString travelDistanceFilter = ''.obs;
  RxString notificationPreferencesFilter = ''.obs;
  RxString notificationFrequencyFilter = ''.obs;

  // 1. Top Three Favorite Cuisines
  RxList<String> favoriteCuisines = [
    'American',
    'Caribbean',
    'Chinese',
    'Creole/Cajun',
    'Ethiopian',
    'French',
    'Greek',
    'Indian',
    'Italian',
    'Japanese',
    'Mexican',
    'Middle Eastern',
    'Southern',
    'Thai',
    'Vietnamese',
  ].obs;

  // 2. Dietary Preferences or Restrictions
  RxList<String> dietaryPreferences = [
    'Vegan & Plant-Based',
    'Vegetarian',
    'Gluten-Free',
    'Pescatarian',
    'Flexitarian',
    'Raw Food',
    'Keto',
    'Paleo',
  ].obs;

  // 3. How Do You Usually Choose Where To Eat? (Select up to 2)
  RxList<String> chooseRestaurantFactors = [
    'Recommendations from friends/family',
    'Online reviews & ratings',
    'Social media posts & food influencers',
    'Special promotions & discounts',
    'Restaurant ambiance & atmosphere',
  ].obs;

  // 4. Planner or Spontaneous Diner
  RxList<String> diningPlanningStyle = [
    'I plan my meals in advance',
    'I like to go with the flow and decide last minute',
    'A mix of both',
  ].obs;

  // 5. Most Important When Dining Out (Rank in order of importance 1-6)
  RxList<String> diningPriorities = [
    'Food quality',
    'Service',
    'Atmosphere & decor',
    'Entertainment (live music, DJs, etc.)',
    'Pricing & discount',
    'Location/Proximity',
  ].obs;

  // 6. Preferred Dining Experiences
  RxList<String> diningExperiences = [
    'Cozy & intimate',
    'Trendy & social',
    'Lively with entertainment',
    'Outdoor & scenic',
    'Family-friendly',
  ].obs;

  // 7. Willingness to Travel for Dining
  RxList<String> travelDistance = [
    'Under 5 miles',
    '5–15 miles',
    '15–30 miles',
    'I’d travel anywhere for an amazing meal',
  ].obs;

  // 8. Type of Notifications
  RxList<String> notificationPreferences = [
    'New restaurant openings',
    'Happy Hour & special discounts',
    'Live entertainment events',
    'Personalized dining recommendations',
    'No notifications, I prefer browsing on my own',
  ].obs;

  // 9. Notification Frequency
  RxList<String> notificationFrequency = [
    'Daily',
    'Weekly',
    'Occasionally',
  ].obs;
// Dynamic filtered users from Firestore
  RxList<UserModel> filteredUsers = <UserModel>[].obs;

  // Track multiple selected users
  var selectedUsers = <int>[].obs;

  // Method to toggle user selection
  void toggleUserSelection(int index) {
    if (selectedUsers.contains(index)) {
      selectedUsers.remove(index);
    } else {
      selectedUsers.add(index);
    }
  }

  // Check if a user is selected
  bool isUserSelected(int index) {
    return selectedUsers.contains(index);
  }

  // Stream function to fetch all users
  Stream<List<UserModel>> fetchAllUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromDocumentSnapshot(doc);
      }).toList();
    });
  }

  // Apply filters to users
  void applyFilters(List<UserModel> users) {
    final filtered = users.where((user) {
      bool matchesFilters = true;

      if (favoriteCuisinesFilter.value.isNotEmpty &&
          !user.topThreeCuisines.contains(favoriteCuisinesFilter.value)) {
        matchesFilters = false;
      }
      if (dietaryPreferencesFilter.value.isNotEmpty &&
          !user.dietaryPrefList.contains(dietaryPreferencesFilter.value)) {
        print('user.dietaryPrefList: ${user.dietaryPrefList}');
        print('dietary prferences: ${dietaryPreferencesFilter.value}');
        matchesFilters = false;
      }
      if (chooseRestaurantFactorsFilter.value.isNotEmpty &&
          !user.whereToEat.contains(chooseRestaurantFactorsFilter.value)) {
        matchesFilters = false;
      }
      if (diningPlanningStyleFilter.value.isNotEmpty &&
          user.planner != diningPlanningStyleFilter.value) {
        matchesFilters = false;
      }
      if (diningPrioritiesFilter.value.isNotEmpty &&
          !user.impDiningOut.contains(diningPrioritiesFilter.value)) {
        matchesFilters = false;
      }
      if (diningExperiencesFilter.value.isNotEmpty &&
          !user.diningExp.contains(diningExperiencesFilter.value)) {
        matchesFilters = false;
      }
      if (notificationPreferencesFilter.value.isNotEmpty &&
          !user.notificationType
              .contains(notificationPreferencesFilter.value)) {
        matchesFilters = false;
      }
      if (notificationFrequencyFilter.value.isNotEmpty &&
          user.notifiedDiningOpp != notificationFrequencyFilter.value) {
        matchesFilters = false;
      }

      return matchesFilters;
    }).toList();

    filteredUsers.assignAll(filtered);
  }

  @override
  void onInit() {
    super.onInit();
    // Listen to the user stream and apply filters
    fetchAllUsers().listen((users) {
      applyFilters(users);
    });

    // Watch filter changes and reapply filters
    everAll([
      favoriteCuisinesFilter,
      dietaryPreferencesFilter,
      chooseRestaurantFactorsFilter,
      diningPlanningStyleFilter,
      diningPrioritiesFilter,
      diningExperiencesFilter,
      notificationPreferencesFilter,
      notificationFrequencyFilter,
    ], (_) {
      fetchAllUsers().listen((users) {
        applyFilters(users);
      });
    });
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null) {
      if (kIsWeb) {
        selectedWebImage.value = result.files.first.bytes!;
      } else {
        selectedImage.value = File(result.files.single.path!);
      }
    }
  }

  void removeImage() {
    selectedImage.value = null;
    selectedWebImage.value = null;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
