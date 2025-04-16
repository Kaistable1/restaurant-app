import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../models/contact_us_model.dart';
import '../widgets/global_functions.dart';

class ContactUsController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  var contactUs = ContactUsModel.initialize().obs;
  var hasData = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    // Defer fetchContactUs until after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchContactUs();
    });
  }

  // Fetch contact details from Firestore
  fetchContactUs() async {
    try {
      loadingDialog();
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('contact_us').doc('current').get();

      if (doc.exists) {
        contactUs.value = ContactUsModel.fromDocumentSnapshot(doc);
        emailController.text = contactUs.value.email;
        phoneController.text = contactUs.value.phone;
        hasData.value = true; // Set hasData to true when data exists
      } else {
        contactUs.value = ContactUsModel(email: '', phone: '');
        emailController.clear();
        phoneController.clear();
        hasData.value = false; // No data
      }
    } catch (e) {
      // Defer snackbar to avoid build conflict
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'Failed to load contact details: $e',
            maxWidth: 400, backgroundColor: primaryColor, colorText: white);
      });
    } finally {
      // Only close dialog if one is open
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  // Save contact details to Firestore
  saveContactUs(String email, String phone) async {
    try {
      loadingDialog();
      final newContact = ContactUsModel(
        email: email,
        phone: phone,
        updatedAt: DateTime.now(),
      );
      await _firestore
          .collection('contact_us')
          .doc('current')
          .set(newContact.toJson());
      contactUs.value = newContact;
      hasData.value = true; // Data now exists
      // Defer snackbar to ensure UI is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Success!', 'Data saved successfully',
            maxWidth: 400, backgroundColor: primaryColor, colorText: white);
      });
    } catch (e) {
      // Defer snackbar to avoid build conflict
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'Failed to save contact details: $e',
            maxWidth: 400, backgroundColor: primaryColor, colorText: white);
      });
    } finally {
      // Only close dialog if one is open
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }
}
