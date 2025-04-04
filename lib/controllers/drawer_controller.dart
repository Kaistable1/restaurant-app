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

  RxBool editProfile = false.obs;
  RxBool privacyPolicy = false.obs;
  RxBool aboutUs = false.obs;
  RxBool termsAndConditions = false.obs;
  RxBool contactUs = false.obs;
  RxBool userQuery = false.obs;
  RxBool customerSupport = false.obs;
  RxBool addNewPromo = false.obs;
  RxBool deliverySlotManagement = false.obs;
  RxBool addSlot = false.obs;
  RxBool categories = false.obs;
  RxBool addEditCategories = false.obs;
  RxBool product = false.obs;
  RxBool productDetails = false.obs;
  RxBool addEditProduct = false.obs;
  RxBool productSuggestion = false.obs;
  RxBool productSuggestionEdit = false.obs;
  RxBool recipes = false.obs;
  RxBool recipesAddEdit = false.obs;
  RxBool recipesDetails = false.obs;
  RxBool usersDetails = false.obs;
  RxBool viewUserOrders = false.obs;
  RxBool userOrderDetails = false.obs;
  RxBool driverDetails = false.obs;
  RxBool driverViewOrders = false.obs;
  RxBool driverSetTarget = false.obs;
  RxBool editUserDetails = false.obs;
  RxBool editDriverDetails = false.obs;
  RxBool vehicleDetails = false.obs;
  RxBool vehicleEdit = false.obs;
  RxBool driverDeliveryManagement = false.obs;
  RxBool driverDeliveryDetails = false.obs;
  RxBool userReferrals = false.obs;
  RxBool setReferralDiscounts = false.obs;
  RxBool deliveryDetailsScreen = false.obs;
  RxBool addEditIngredient = false.obs;

  void resetAllBooleans() {
    showNotifications.value = false;
    newNotificationsSend.value = false;
    orderDetails.value = false;

    editProfile.value = false;
    privacyPolicy.value = false;
    aboutUs.value = false;
    termsAndConditions.value = false;
    contactUs.value = false;
    userQuery.value = false;
    customerSupport.value = false;
    addNewPromo.value = false;
    deliverySlotManagement.value = false;
    addSlot.value = false;
    categories.value = false;
    addEditCategories.value = false;
    product.value = false;
    productDetails.value = false;
    addEditProduct.value = false;
    productSuggestion.value = false;
    productSuggestionEdit.value = false;
    recipes.value = false;
    recipesAddEdit.value = false;
    recipesDetails.value = false;
    usersDetails.value = false;
    viewUserOrders.value = false;
    userOrderDetails.value = false;
    driverDetails.value = false;
    driverViewOrders.value = false;
    driverSetTarget.value = false;
    editUserDetails.value = false;
    editDriverDetails.value = false;
    vehicleDetails.value = false;
    vehicleEdit.value = false;
    driverDeliveryManagement.value = false;
    driverDeliveryDetails.value = false;
    userReferrals.value = false;
    setReferralDiscounts.value = false;
    deliveryDetailsScreen.value = false;
    addEditIngredient.value = false;
  }
}
