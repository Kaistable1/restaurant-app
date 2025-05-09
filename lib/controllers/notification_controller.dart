import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/models/usermodel_for_notification.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'drawer_controller.dart';

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
  RxString stateFilter = ''.obs;
  RxString cityFilter = ''.obs;

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
    '5-15 miles',
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

  RxList<String> stateList = <String>["New York", "Los Angeles"].obs;

// Dynamic filtered users from Firestore
  RxList<UserModel> filteredUsers = <UserModel>[].obs;

// Track multiple selected users (multi selection allowed)
  var selectedUsers = <int>[].obs;

// Method to toggle user selection
  void toggleUserSelection(int index) {
    if (selectedUsers.contains(index)) {
      selectedUsers.remove(index); // already selected to remove
    } else {
      selectedUsers.add(index); // not selected to add
    }
  }

// Method to check if user is selected
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

  List<UserModel> applyFilters(List<UserModel> users) {
    final filtered = users.where((user) {
      bool matchesFilters = true;

      if (favoriteCuisinesFilter.value.isNotEmpty &&
          !(user.topThreeCuisines ?? [])
              .contains(favoriteCuisinesFilter.value)) {
        matchesFilters = false;
      }
      if (dietaryPreferencesFilter.value.isNotEmpty &&
          !(user.dietaryPrefList ?? [])
              .contains(dietaryPreferencesFilter.value)) {
        matchesFilters = false;
      }
      if (chooseRestaurantFactorsFilter.value.isNotEmpty &&
          !(user.whereToEat ?? [])
              .contains(chooseRestaurantFactorsFilter.value)) {
        matchesFilters = false;
      }
      if (diningPlanningStyleFilter.value.isNotEmpty &&
          (user.planner ?? '') != diningPlanningStyleFilter.value) {
        matchesFilters = false;
      }
      if (diningPrioritiesFilter.value.isNotEmpty &&
          !(user.impDiningOut ?? []).contains(diningPrioritiesFilter.value)) {
        matchesFilters = false;
      }
      if (diningExperiencesFilter.value.isNotEmpty &&
          !(user.diningExp ?? []).contains(diningExperiencesFilter.value)) {
        matchesFilters = false;
      }
      if (notificationPreferencesFilter.value.isNotEmpty &&
          !(user.notificationType ?? [])
              .contains(notificationPreferencesFilter.value)) {
        matchesFilters = false;
      }
      if (notificationFrequencyFilter.value.isNotEmpty &&
          (user.notifiedDiningOpp ?? '') != notificationFrequencyFilter.value) {
        matchesFilters = false;
      }

      if (travelDistanceFilter.value.isNotEmpty) {
        String filter = travelDistanceFilter.value.trim().replaceAll('–', '-');
        String userValue =
            (user.willingToTravel ?? '').trim().replaceAll('–', '-');

        if (filter.contains('-')) {
          // Agar filter mein hyphen hai (range)
          List<String> filterParts = filter.split('-');
          if (filterParts.length == 2) {
            int filterStart = int.tryParse(
                    filterParts[0].replaceAll(RegExp(r'[^0-9]'), '')) ??
                0;
            int filterEnd = int.tryParse(
                    filterParts[1].replaceAll(RegExp(r'[^0-9]'), '')) ??
                0;

            int userStart = 0;
            int userEnd = 0;
            if (userValue.contains('-')) {
              List<String> userParts = userValue.split('-');
              userStart = int.tryParse(
                      userParts[0].replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0;
              userEnd = int.tryParse(
                      userParts[1].replaceAll(RegExp(r'[^0-9]'), '')) ??
                  0;
            }

            if (!(filterStart == userStart && filterEnd == userEnd)) {
              matchesFilters = false;
            }
          } else {
            // Safety net
            if (!userValue.contains(filter)) {
              matchesFilters = false;
            }
          }
        } else {
          if (!userValue.contains(filter)) {
            matchesFilters = false;
          }
        }
      }

      if (stateFilter.value.isNotEmpty &&
          (user.country ?? '') != stateFilter.value) {
        matchesFilters = false;
      }
      if (cityFilter.value.isNotEmpty &&
          (user.city ?? '') != cityFilter.value) {
        matchesFilters = false;
      }

      return matchesFilters;
    }).toList();
    return filtered; // 👈 now returning List<UserModel>
  }
// Controller mein

  void updateFilteredUsers(List<UserModel> users) {
    filteredUsers.assignAll(applyFilters(users));
    print('filteredUsers: ${filteredUsers.length}');
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

  // firebase notification sending function by "modassir"

  /// Sends a push notification to a specific user via Cloud Function.
  Future<void> sendPushNotification({
    required String token,
    required String message,
    required String title,
  }) async {
    const String endpoint = 'https://sendpushtouser-6nrfvx3mia-uc.a.run.app';
    debugPrint(
        'Sending notification to token: $token, Title: $title, Body: $message');

    try {
      // Validate inputs
      if (token.isEmpty || title.isEmpty || message.isEmpty) {
        throw Exception('Token, title, or message cannot be empty');
      }

      // Prepare request
      final request = http.Request('POST', Uri.parse(endpoint));
      request.headers.addAll({'Content-Type': 'application/json'});
      request.body = json.encode({
        'token': token,
        'title': title,
        'body': message,
      });
      final http.Client _client = http.Client();
      // Send request
      final response = await _client.send(request);
      final responseBody = await response.stream.bytesToString();

      // Handle response
      if (response.statusCode == 200) {
        try {
          final jsonResponse = json.decode(responseBody);
          debugPrint('Notification sent successfully: $jsonResponse');
          Get.snackbar(
            'Success',
            'Notification sent successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          titleController.clear();
          descriptionController.clear();
          Get.put(DrawerControllerX()).showNotifications.value = false;
        } on FormatException catch (e) {
          debugPrint(
              'Failed to parse response as JSON: $responseBody, Error: $e');
          throw Exception('Invalid response format from server');
        }
      } else {
        debugPrint(
            'Failed to send notification: Status=${response.statusCode}, Response=$responseBody');
        throw Exception(
          'Failed to send notification: ${response.statusCode} ${response.reasonPhrase ?? responseBody}',
        );
      }
    } on http.ClientException catch (e) {
      debugPrint('Network error sending notification: $e');
      _showErrorSnackbar(
          'Network error: Please check your internet connection');
    } on Exception catch (e) {
      debugPrint('Error sending notification: $e');
      _showErrorSnackbar('Failed to send notification: $e');
    } catch (e) {
      debugPrint('Unexpected error sending notification: $e');
      _showErrorSnackbar('An unexpected error occurred');
    }
  }

  // firebase notification sending function by "modassir" for all users
  Future<void> sendPushAllUsersNotification(
      {required String message, required String title}) async {
    try {
      var headers = {'Content-Type': 'application/json'};

      var request = http.Request(
        'POST',
        Uri.parse('https://sendpushtoall-6nrfvx3mia-uc.a.run.app'),
      );

      request.body = json.encode({"title": title, "body": message});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        debugPrint("Notification Sent Successfully: $responseData");

        // Show success dialog/snackbar
        Get.snackbar(
          'Success',
          'Notification sent successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        titleController.clear();
        descriptionController.clear();
      } else {
        var errorData = await response.stream.bytesToString();
        debugPrint("Failed to send notification: ${response.reasonPhrase}");

        // Show error dialog/snackbar
        Get.snackbar(
          'Error',
          'Failed to send notification.\n${response.reasonPhrase ?? errorData}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint("Exception: $e");

      // Handle network/unknown error
      Get.snackbar(
        'Error',
        'Something went wrong!\n$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Helper method to show error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
