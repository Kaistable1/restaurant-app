import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savrly/constants/app_colors.dart';
import '../models/privacy_model.dart';

class PrivacyPolicyController extends GetxController {
  var privacyPolicy = PrivacyPolicyModel.initialize().obs; // Use model
  var isLoading = true.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  // Fetch privacy policy from Firestore
  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading.value = true;
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('privacy_policy').doc('current').get();

      if (doc.exists) {
        privacyPolicy.value = PrivacyPolicyModel.fromDocumentSnapshot(doc);
      } else {
        privacyPolicy.value =
            PrivacyPolicyModel(text: 'No privacy policy found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load privacy policy: $e',
          backgroundColor: primaryColor, colorText: white);
    } finally {
      isLoading.value = false;
    }
  }

  // Update privacy policy in Firestore
  Future<void> updatePrivacyPolicy(String newText) async {
    try {
      isLoading.value = true;
      final newPolicy = PrivacyPolicyModel(
        text: newText,
        updatedAt: DateTime.now(),
      );
      await _firestore
          .collection('privacy_policy')
          .doc('current')
          .set(newPolicy.toJson());
      privacyPolicy.value = newPolicy;
      Get.snackbar('Success', 'Privacy policy updated successfully',
          backgroundColor: primaryColor, colorText: white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update privacy policy: $e',
          backgroundColor: primaryColor, colorText: white);
    } finally {
      isLoading.value = false;
    }
  }
}
