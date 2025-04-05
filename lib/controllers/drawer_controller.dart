import 'package:get/get.dart';

class DrawerControllerX extends GetxController {
  // Active screen state
  RxInt selectedScreen = 0.obs;
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
  RxBool newNotificationsSend = false.obs;
  RxBool orderDetails = false.obs;


  RxBool addRestaurants = false.obs;



  void resetAllBooleans() {
    showNotifications.value = false;
    newNotificationsSend.value = false;
    orderDetails.value = false;



    addRestaurants.value = false;

  }
}
