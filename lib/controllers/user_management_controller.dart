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
      time: Duration(milliseconds: 500),
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
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    if (!hasMoreData.value || isLoading.value) return;

    isLoading.value = true;

    try {
      Query query = _firestore.collection('users').orderBy('username').limit(pageSize);

      if (lastDocument != null && currentSearchQuery.value.isEmpty) {
        query = query.startAfterDocument(lastDocument!);
      }

      if (currentSearchQuery.value.isNotEmpty) {
        String searchText = currentSearchQuery.value.trim().toLowerCase();
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
        if (currentSearchQuery.value.isNotEmpty && userManagement.isEmpty) {
          Get.snackbar('Info', 'User not found');
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
            userId: data['userID'] ?? '',
            userImage: data['userImage'] ?? '',
            username: data['username'] ?? '',
            whereToEat: List<String>.from(data['whereToEat'] ?? []),
            willingToTravel: data['willingToTravel'] ?? '',
          );
        }).toList();

        if (currentSearchQuery.value.isNotEmpty) {
          userManagement.value = newUsers; // Replace list when searching
        } else {
          userManagement.addAll(newUsers); // Append for pagination
        }
        hasMoreData.value = snapshot.docs.length == pageSize;
      }

      totalUsersLength.value = (await _firestore.collection('users').count().get()).count ?? 0;
    } catch (e) {
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
      Get.snackbar('Success', 'Restaurant deleted successfully'); // Added success message
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user: $e');
    }
  }
}
