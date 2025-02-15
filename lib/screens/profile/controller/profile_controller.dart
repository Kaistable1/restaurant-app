import 'package:get/get.dart';

class ProfileController extends GetxController {
  var userName = "Alexa Johnson".obs;
  var bio = "Food enthusiast, traveler, and blogger.".obs;
  var profileImage = "assets/images/profile.png".obs;

  void logout() {
    // Handle logout logic
    Get.offAllNamed('/login'); // Example: Redirect to Login Screen
  }
}
