import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabControllerModel extends GetxController
    with SingleGetTickerProviderMixin {
  late TabController tabController;
  var selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController =
        TabController(length: 3, vsync: this); // Adjust length as per your tabs
  }

  // Update selected tab index
  void setTabIndex(int index) {
    selectedTabIndex.value = index;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
