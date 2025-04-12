import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../models/terms_conditions_model.dart';

class TermsController extends GetxController {
  var terms = TermsAndConditionsModel.initialize().obs;
  var isLoading = true.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchTerms();
  }

  // Fetch terms from Firestore
  Future<void> fetchTerms() async {
    try {
      isLoading.value = true;
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('terms_and_conditions')
          .doc('current')
          .get();

      if (doc.exists) {
        terms.value = TermsAndConditionsModel.fromDocumentSnapshot(doc);
      } else {
        terms.value =
            TermsAndConditionsModel(text: 'No terms and conditions found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load terms: $e',
          backgroundColor: primaryColor, colorText: white);
    } finally {
      isLoading.value = false;
    }
  }

  // Update terms in Firestore
  Future<void> updateTermsText(String newText) async {
    try {
      isLoading.value = true;
      final newTerms = TermsAndConditionsModel(
        text: newText,
        updatedAt: DateTime.now(),
      );
      await _firestore
          .collection('terms_and_conditions')
          .doc('current')
          .set(newTerms.toJson());
      terms.value = newTerms;
      Get.snackbar('Success', 'Terms updated successfully',
          backgroundColor: primaryColor, colorText: white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update terms: $e',
          backgroundColor: primaryColor, colorText: white);
    } finally {
      isLoading.value = false;
    }
  }
}