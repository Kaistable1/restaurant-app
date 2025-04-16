import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/app_colors.dart';
import 'package:savrly/models/admin_model.dart';
import 'package:savrly/widgets/global_functions.dart';

class ProfileController extends GetxController {
  Rx<Uint8List?> webImageBytes = Rx<Uint8List?>(null);
  Rx<AdminModel?> profile = Rx<AdminModel?>(null);

  Rx<Uint8List?> uploadedImage = Rx<Uint8List?>(null);
  void pickImageWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      print("Picked ${result.files.length} files");
      for (var file in result.files) {
        if (file.bytes != null) {
          uploadedImage.value = file.bytes!;
        }
      }
    } else {
      print("No file selected");
    }
  }

  RxInt editProfileView = 0.obs;
  var selectedTab = 0.obs;

  void switchTab(int index) {
    selectedTab.value = index;
  }

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isCurrentPasswordVisible = false.obs;
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  var isNewPasswordVisible = false.obs;
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  var isConfirmPasswordVisible = false.obs;
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  bool validatePasswordsMatch() {
    String current = currentPasswordController.text.trim();
    String newPass = newPasswordController.text.trim();
    String confirm = confirmPasswordController.text.trim();

    if (newPass == current) {
      Get.snackbar(
          "Error", "New password must not be the same as current password",
          backgroundColor: primaryColor,
          colorText: Colors.white,
          maxWidth: 400);
      return false;
    }

    if (confirm != newPass) {
      Get.snackbar("Error", "New and confirm password must match",
          backgroundColor: primaryColor,
          colorText: Colors.white,
          maxWidth: 400);
      return false;
    }

    if (newPass.length < 6) {
      Get.snackbar("Error", "New password must be at least 6 characters",
          backgroundColor: primaryColor,
          colorText: Colors.white,
          maxWidth: 400);
      return false;
    }

    return true;
  }

  // Fill text fields with profile data
  void fillProfileFields() {
    if (profile.value != null) {
      firstNameController.text = profile.value!.name;
      emailController.text = profile.value!.email;
      phoneController.text = profile.value!.contact;
    }
  }

  // Get profile
  Future<void> getProfile() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('admins')
          .doc(currentUser?.uid)
          .get();

      if (!doc.exists) {
        Get.snackbar('Error', 'Profile not found',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      profile.value = AdminModel.fromMap(doc.data()!, doc.id);
      fillProfileFields();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch profile: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print('Error: $e');
    }
  }

  // Update profile
  Future<void> updateProfile() async {
    try {
      loadingDialog();
      User? currentUser = FirebaseAuth.instance.currentUser;

      // Validate inputs
      String name = firstNameController.text.trim();
      String contact = phoneController.text.trim();

      // Upload image if selected
      String? imgUrl = uploadedImage.value == null
          ? profile.value?.img
          : await uploadImageToFirebase('adminProfile', uploadedImage.value!);

      // Prepare updated data
      final updatedData = {
        'name': name,
        'contact': contact,
        'img': imgUrl,
        'email': emailController.text.trim(),
        'createdAt': profile.value?.createdAt ?? FieldValue.serverTimestamp(),
        'role': profile.value?.role ?? 'admin',
        'status': profile.value?.status ?? 'Active',
      };

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(currentUser?.uid)
          .update(updatedData);
      // Update profile model
      profile.value = AdminModel.fromMap(updatedData, currentUser!.uid);
      Get.back();

      Get.snackbar('Success', 'Profile updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.back();

      Get.snackbar('Error', 'Failed to update profile: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print('Error: $e');
    }
  }

  //change password

  changePassword() async {
    try {
      // Show a loading dialog
      loadingDialog();

      final auth = FirebaseAuth.instance;
      final user = auth.currentUser;

      // Re-authenticate
      final credential = EmailAuthProvider.credential(
        email: emailController.text.trim(),
        password: currentPasswordController.text,
      );

      await user!.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(confirmPasswordController.text);

      // Update Firestore
      if (profile.value?.docID != null) {
        await FirebaseFirestore.instance
            .collection('admins')
            .doc(profile.value!.docID)
            .update({'passwords': confirmPasswordController.text});
      }

      // Close the loading dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Success!',
        "Password changed successfully",
        maxWidth: 400,
        backgroundColor: primaryColor,
        colorText: Colors.white,
      );

      // Clear controllers
      newPasswordController.clear();
      currentPasswordController.clear();
      confirmPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        "Error",
        e.message ?? "An error occurred",
        maxWidth: 400,
        backgroundColor: redColor,
        colorText: Colors.white,
      );
      print("FirebaseAuthException: $e");
    } catch (e) {
      Get.back(); // Close loading dialog
      print("Unexpected error: $e");
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
