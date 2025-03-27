import 'package:get/get.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate some startup delay
    //Get.offAll(OnboardingScreen()); // Navigate to the home screen
  }
}
