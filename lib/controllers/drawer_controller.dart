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
  RxBool showCreateNotifications = false.obs;
  RxBool showNotifications = false.obs;
  RxBool showProfile = false.obs;
  RxBool addRestaurants = false.obs;
  RxBool viewRestaurantsDetails = false.obs;
  RxBool userDetails = false.obs;
  RxBool addSubAdmin = false.obs;


  RxBool viewEvents=false.obs;
  RxBool viewEventsGallery=false.obs;
  RxBool addEvent=false.obs;



  void resetAllBooleans() {
    showCreateNotifications.value = false;
     showNotifications.value = false;
    showProfile.value = false;
    addRestaurants.value = false;
    viewEvents.value=false;
    viewEventsGallery.value=false;
    addEvent.value=false;
    viewRestaurantsDetails.value = false;
    userDetails.value = false;
    addSubAdmin.value = false;

  }
}
