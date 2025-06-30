import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/main.dart';
import 'package:savrly/screens/admin/admin_panel.dart';
import 'package:savrly/screens/sub_admin_panel/sub_admin_panel.dart';
import 'package:savrly/widgets/global_functions.dart';

class LoginController extends GetxController {
  // Text controllers
  final TextEditingController emailController = TextEditingController(text: "norman@gmail.com");
  final TextEditingController subAdminEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController(text: "Admin@1234");
  final TextEditingController subAdminPasswordController =
      TextEditingController();
  final TextEditingController forgotEmailController = TextEditingController();

  // Reactive variables
  var isPasswordVisible = false.obs;
  var isSubAdminPasswordVisible = false.obs;
  var isLoading = false.obs;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    isLoading = true.obs;
    super.onInit();
    // Check if a user is already logged in
    checkCurrentUser();
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    emailController.dispose();
    subAdminEmailController.dispose();
    passwordController.dispose();
    subAdminPasswordController.dispose();
    forgotEmailController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleSubAdminPasswordVisibility() {
    isSubAdminPasswordVisible.value = !isSubAdminPasswordVisible.value;
  }

  // Check if a user is already logged in
  Future<void> checkCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot adminDoc =
            await _firestore.collection('admins').doc(user.uid).get();
        print('uaser name ${adminDoc['name']}');
        if (adminDoc.exists) {
          String role = adminDoc['role'];
          if (role == 'admin') {
            Get.offAll(() => AdminPanel());
          } else if (role == 'sub-admin') {
            Get.offAll(() => SubAdminPanel());
          }
        }
      }
      isLoading.value = false;
    } catch (e) {
      print('Error $e');
    }
  }

  // Login Admin
  Future<void> loginAdmin() async {
    loadingDialog();
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter email and password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
// Check if the email exists in admins collection with role: admin
      QuerySnapshot adminQuery = await _firestore
          .collection('admins')
          .where('email', isEqualTo: emailController.text.trim())
          .where('role', isEqualTo: 'admin')
          .limit(1)
          .get();

      if (adminQuery.docs.isEmpty) {
        Get.snackbar('Error', 'No admin found with this email',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await preferences?.setString('adminEmail', emailController.text.trim());
      await preferences?.setString(
          'adminPassword', passwordController.text.trim());
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot adminDoc =
            await _firestore.collection('admins').doc(user.uid).get();

        if (adminDoc.exists && adminDoc['role'] == 'admin') {
          Get.snackbar('Success', 'Admin login successful',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          Get.back();
          Get.offAll(() => AdminPanel());
          clearAllFields();
        } else {
          Get.back();

          await _auth.signOut();
          Get.snackbar('Error', 'Not authorized as admin',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      } else {
        Get.back();

        Get.snackbar('Error', 'Login failed: No user found',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.back();

      String errorMessage;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No admin found with this email';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email format';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many attempts. Try again later';
            break;
          default:
            errorMessage = e.message ?? 'Login error';
        }
      } else {
        errorMessage = e.toString();
      }
      print('Error in login function $e');
      Get.snackbar('Error', errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Login Sub-Admin
  Future<void> loginSubAdmin() async {
    loadingDialog();
    if (subAdminEmailController.text.trim().isEmpty ||
        subAdminPasswordController.text.trim().isEmpty) {
      Get.back();

      Get.snackbar('Error', 'Please enter email and password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      // Check if the email exists in admins collection with role: admin
      QuerySnapshot adminQuery = await _firestore
          .collection('admins')
          .where('email', isEqualTo: subAdminEmailController.text.trim())
          .where('role', isEqualTo: 'sub-admin')
          .limit(1)
          .get();

      if (adminQuery.docs.isEmpty) {
        Get.back();

        Get.snackbar('Error', 'No sub-admin found with this email',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: subAdminEmailController.text.trim(),
        password: subAdminPasswordController.text.trim(),
      );
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot adminDoc =
            await _firestore.collection('admins').doc(user.uid).get();

        if (adminDoc.exists && adminDoc['role'] == 'sub-admin') {
          Get.snackbar('Success', 'Sub-admin login successful',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white);
          Get.back();

          clearAllFields();
          Get.offAll(SubAdminPanel());
        } else {
          Get.back();

          await _auth.signOut();
          Get.snackbar('Error', 'Not authorized as sub-admin',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      } else {
        Get.back();

        Get.snackbar('Error', 'Login failed: No user found',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.back();

      String errorMessage;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No sub-admin found with this email';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email format';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many attempts. Try again later';
            break;
          default:
            errorMessage = e.message ?? 'Login error';
        }
      } else {
        errorMessage = e.toString();
      }
      Get.snackbar('Error', errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot Password
  Future<void> forgotPassword() async {
    if (forgotEmailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter an email address',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      await _auth.sendPasswordResetEmail(
        email: forgotEmailController.text.trim(),
      );
      Get.snackbar('Success', 'Password reset email sent. Check your inbox.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      clearAllFields();
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email format';
            break;
          default:
            errorMessage = e.message ?? 'Error sending reset email';
        }
      } else {
        errorMessage = e.toString();
      }
      Get.snackbar('Error', errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Clear all text fields
  void clearAllFields() {
    emailController.clear();
    passwordController.clear();
    subAdminEmailController.clear();
    subAdminPasswordController.clear();
    forgotEmailController.clear();
  }
}
