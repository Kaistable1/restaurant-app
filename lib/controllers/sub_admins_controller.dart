import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/controllers/drawer_controller.dart';
import 'package:savrly/main.dart';
import 'package:savrly/widgets/global_functions.dart';

import '../models/sub_admins_model.dart';

class SubAdminsController extends GetxController {
  final searchController = TextEditingController();
  final fullNameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final assignPasswordController = TextEditingController();
  SubAdminsModel? subAdminsModel;
  var isPasswordVisible = false.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  var subAdminsList = <SubAdminsModel>[].obs;
  var subAdminsFilteredList = <SubAdminsModel>[].obs;

  // Function to fetch sub-admins from Firestore
  getSubAdmins() async {
    try {
      // Reference to the admins collection
      CollectionReference adminsRef =
          FirebaseFirestore.instance.collection('admins');

      // Query for sub-admins only
      QuerySnapshot querySnapshot =
          await adminsRef.where('role', isEqualTo: 'sub-admin').get();

      // Map Firestore documents to SubAdminsModel
      subAdminsList.value = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return SubAdminsModel(
          name: data['name'] ?? '',
          contact: data['contact'] ?? '',
          email: data['email'] ?? '',
          passwords: data['passwords'] ?? '',
          status: data['status'] ?? 'Active',
          docID: doc.id,
        );
      }).toList();
    } catch (e) {
      print('Error fetching sub-admins: $e');
      // Optionally show a snackbar or error message
      Get.snackbar('Error', 'Failed to fetch sub-admins: $e');
    }
  }

  Future<void> createSubAdmin() async {
    loadingDialog();
    try {
      // Validate inputs
      if (emailController.text.trim().isEmpty ||
          assignPasswordController.text.trim().isEmpty ||
          fullNameController.text.trim().isEmpty ||
          contactController.text.trim().isEmpty) {
        Get.snackbar('Error', 'Please fill all fields',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        Get.back();
        return;
      }

      // Verify current user is admin
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Get.snackbar('Error', 'User not authenticated',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        Get.back();
        return;
      }
      DocumentSnapshot adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(currentUser.uid)
          .get();
      if (!adminDoc.exists || adminDoc['role'] != 'admin') {
        Get.snackbar('Error', 'Unauthorized: Not an admin',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        Get.back();
        return;
      }

      // Get admin credentials from SharedPreferences
      String? adminEmail = preferences?.getString('adminEmail');
      String? adminPassword = preferences?.getString('adminPassword');

      if (adminEmail == null || adminPassword == null) {
        Get.snackbar('Error', 'Admin credentials not found',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        Get.back();
        return;
      }

      // Store admin UID
      String adminUid = currentUser.uid;

      // Sign out temporarily
      await FirebaseAuth.instance.signOut();

      // Create sub-admin user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: assignPasswordController.text.trim(),
      );
      User? newUser = userCredential.user;

      if (newUser != null) {
        // Update display name
        await newUser.updateDisplayName(fullNameController.text.trim());

        // Store sub-admin data in Firestore
        await FirebaseFirestore.instance
            .collection('admins')
            .doc(newUser.uid)
            .set({
          'name': fullNameController.text.trim(),
          'contact': contactController.text.trim(),
          'email': emailController.text.trim(),
          'passwords': assignPasswordController.text.trim(),
          'status': 'Active',
          'role': 'sub-admin',
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Sign out sub-admin
        await FirebaseAuth.instance.signOut();

        // Sign admin back in
        UserCredential adminCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
        User? restoredUser = adminCredential.user;

        if (restoredUser == null || restoredUser.uid != adminUid) {
          Get.snackbar('Error', 'Failed to restore admin session',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          Get.back();
          return;
        }
        Get.back();
        // Update UI
        getSubAdmins();
        final drawerController = Get.put(DrawerControllerX());
        drawerController.addSubAdmin.value = false;

        Get.snackbar('Success',
            'Sub-admin created. Email: ${emailController.text}, Password: ${assignPasswordController.text}',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 10));
      } else {
        Get.snackbar('Error', 'Failed to create sub-admin',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'Email is already registered';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email format';
            break;
          case 'weak-password':
            errorMessage = 'Password is too weak';
            break;
          default:
            errorMessage = e.message ?? 'Error creating sub-admin';
        }
      } else {
        errorMessage = e.toString();
      }
      Get.snackbar('Error', errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print('Error: $e');
    } finally {
      Get.back();
      clearAllFields();
    }
  }

  updateSubAdminInfo({docID}) async {
    try {
      loadingDialog();
      await FirebaseFirestore.instance.collection('admins').doc(docID).update({
        'name': fullNameController.text.trim(),
        'contact': contactController.text.trim(),
      });
      Get.back();
      getSubAdmins();
      final drawerController = Get.put(DrawerControllerX());

      drawerController.addSubAdmin.value = false;
      Get.snackbar('SAVRLY', 'Sub-admin updated successfully');
      clearAllFields();
    } catch (e) {
      print('Error update sub admin $e');
      Get.back();
    }
  }

  deleteSubAdmin(int index, {docID}) async {
    try {
      print('docid $docID');
      await FirebaseFirestore.instance.collection('admins').doc(docID).delete();
      getSubAdmins();
      update();
      Get.snackbar('SAVRLY', 'Sub-admin deleted successfully');
    } catch (e) {
      print('Error $e');
    }
  }

  filteredSubAdmins({search}) {
    if (search.isEmpty) {
      subAdminsFilteredList.value = subAdminsList;
    } else {
      subAdminsFilteredList.value = subAdminsList
          .where((subAdmin) =>
              subAdmin.name.toLowerCase().contains(search.toLowerCase()) ||
              subAdmin.email.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    update();
  }

  clearAllFields() {
    fullNameController.clear();
    contactController.clear();
    emailController.clear();
    assignPasswordController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    getSubAdmins();
  }
}
