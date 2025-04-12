import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_colors.dart';
import '../models/about_model.dart';

class AboutAppController extends GetxController {
  var aboutApp = AboutModel.initialize().obs;
  var isLoading = true.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchAboutApp();
  }

  Future<void> fetchAboutApp() async {
    try {
      isLoading.value = true;
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('about_app').doc('current').get();

      if (doc.exists) {
        aboutApp.value = AboutModel.fromDocumentSnapshot(doc);
      } else {
        aboutApp.value = AboutModel(text: 'No about app information found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load about app: $e',
          backgroundColor: primaryColor, colorText: white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAboutAppText(String newText) async {
    try {
      isLoading.value = true;
      final newAbout = AboutModel(
        text: newText,
        updatedAt: DateTime.now(),
      );
      await _firestore
          .collection('about_app')
          .doc('current')
          .set(newAbout.toJson());
      aboutApp.value = newAbout;
      Get.snackbar('Success', 'About app updated successfully',
          backgroundColor: primaryColor, colorText: white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update about app: $e',
          backgroundColor: primaryColor, colorText: white);
    } finally {
      isLoading.value = false;
    }
  }
}
