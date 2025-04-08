import 'package:get/get.dart';

class DrawerControllerX extends GetxController {
  // Active screen state
  RxInt selectedScreen = 2.obs;
  var isUserManagementExpanded = false.obs;
  var hoveredItem = "".obs;

  void changeScreen(int screenNumber) {
    selectedScreen.value = screenNumber;
  }

  void toggleUserManagement() {
    isUserManagementExpanded.value = !isUserManagementExpanded.value;
  }

  void selectMainScreen(int index) {
    resetAllBooleans();
    selectedScreen.value = index;
    print("Main screen selected: $index");
  }

  //SubScreens
  RxBool showNotifications = false.obs;
  RxBool showProfile = false.obs;
  RxBool addRestaurants = false.obs;

  void resetAllBooleans() {
    showNotifications.value = false;
    showProfile.value = false;
    addRestaurants.value = false;
  }
}
