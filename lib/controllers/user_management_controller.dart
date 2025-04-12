import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/user_management_model.dart';

class UserController extends GetxController {
  final searchController = TextEditingController();
  RxList<UserManagementModel> userManagement = <UserManagementModel>[].obs;
  DocumentSnapshot? lastDocument;
  RxBool hasMoreData = true.obs;
  RxBool isLoading = false.obs;
  RxString currentSearchQuery = ''.obs;
  RxString errorMessage = ''.obs; // To store error messages
  final int pageSize = 10;
  RxInt totalUsersLength = 0.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchInitialUsers();
    // Debounce search input to avoid excessive queries
    debounce(
      currentSearchQuery,
      (_) => fetchInitialUsers(),
      time: const Duration(milliseconds: 500),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void fetchInitialUsers() {
    userManagement.clear();
    lastDocument = null;
    hasMoreData.value = true;
    totalUsersLength.value = 0;
    errorMessage.value = '';
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    if (!hasMoreData.value || isLoading.value) return;

    isLoading.value = true;

    try {
      Query query = _firestore
          .collection('users')
          .orderBy('username', descending: false) // Ensure consistent ordering
          .limit(pageSize);

      // Handle pagination
      if (lastDocument != null && currentSearchQuery.value.isEmpty) {
        query = query.startAfterDocument(lastDocument!);
      }

      // Handle search
      if (currentSearchQuery.value.isNotEmpty) {
        String searchText = currentSearchQuery.value.trim();
        query = _firestore
            .collection('users')
            .where('username', isGreaterThanOrEqualTo: searchText)
            .where('username', isLessThanOrEqualTo: searchText + '\uf8ff')
            .orderBy('username')
            .limit(pageSize);
      }

      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        hasMoreData.value = false;
        if (userManagement.isEmpty && currentSearchQuery.value.isNotEmpty) {
          errorMessage.value = 'No users found for "$currentSearchQuery"';
        } else if (userManagement.isEmpty) {
          errorMessage.value = 'No users available in the database';
        }
      } else {
        lastDocument = snapshot.docs.last;
        final newUsers = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return UserManagementModel(
            city: data['city'] ?? '',
            confirmPass: data['confirmpass'] ?? '',
            country: data['country'] ?? '',
            dietaryPrefList: List<String>.from(data['dietaryPrefList'] ?? []),
            diningExp: List<String>.from(data['diningExp'] ?? []),
            impDiningOut: List<String>.from(data['impDiningOut'] ?? []),
            notificationType: List<String>.from(data['notificationType'] ?? []),
            notifiedDiningOpp: data['notifiedDiningOpp'] ?? '',
            password: data['password'] ?? '',
            planner: data['planner'] ?? '',
            token: data['token'] ?? '',
            topThreeCuisines: List<String>.from(data['topThreeCuisines'] ?? []),
            userEmail: data['userEmail'] ?? '',
            userId: data['userID'] ??
                doc.id, // Fallback to doc ID if userID is missing
            userImage: data['userImage'] ?? '',
            username:
                data['username'] ?? 'Unknown', // Fallback for null usernames
            whereToEat: List<String>.from(data['whereToEat'] ?? []),
            willingToTravel: data['willingToTravel'] ?? '',
          );
        }).toList();

        if (currentSearchQuery.value.isNotEmpty) {
          userManagement.value = newUsers; // Replace list for search
        } else {
          userManagement.addAll(newUsers); // Append for pagination
        }
        hasMoreData.value = snapshot.docs.length == pageSize;
        errorMessage.value = ''; // Clear error if users are found
      }

      // Fetch total count only when not searching
      if (currentSearchQuery.value.isEmpty) {
        totalUsersLength.value =
            (await _firestore.collection('users').count().get()).count ?? 0;
      } else {
        totalUsersLength.value =
            userManagement.length; // Approximate for search
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch users: $e';
      Get.snackbar('Error', 'Failed to fetch users: $e');
      print('Error fetching users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      userManagement.removeWhere((user) => user.userId == userId);
      totalUsersLength.value--;
      Get.snackbar('Success', 'User deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user: $e');
    }
  }
}
