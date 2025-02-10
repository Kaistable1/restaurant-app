// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class TabControllerModel extends GetxController
//     with SingleGetTickerProviderMixin {
//   late TabController tabController;
//   var selectedTabIndex = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     tabController =
//         TabController(length: 3, vsync: this); // Adjust length as per your tabs
//   }
//
//   // Update selected tab index
//   void setTabIndex(int index) {
//     selectedTabIndex.value = index;
//   }
//
//   @override
//   void onClose() {
//     tabController.dispose();
//     super.onClose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//
// class TabControllerModel extends GetxController with GetSingleTickerProviderStateMixin {
//   TabController? tabController;
//   var selectedTabIndex = 0.obs;
//
//   void initializeController(int length, TickerProvider vsync) {
//     tabController = TabController(length: length, vsync: vsync);
//     tabController!.addListener(() {
//       selectedTabIndex.value = tabController!.index;
//     });
//   }
//
//   void setTabIndex(int index) {
//     selectedTabIndex.value = index;
//     tabController?.animateTo(index);
//   }
//
//   @override
//   void onClose() {
//     tabController?.dispose();
//     super.onClose();
//   }
// }


class TabControllerModel extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  var selectedTabIndex = 0.obs;

  /// Initialize or reinitialize TabController
  void initializeController(int length, TickerProvider vsync) {
    if (tabController != null) {
      tabController!.dispose(); // Dispose old instance to prevent memory leaks
    }
    tabController = TabController(length: length, vsync: vsync);
    tabController!.addListener(() {
      selectedTabIndex.value = tabController!.index;
    });
  }

  void setTabIndex(int index) {
    selectedTabIndex.value = index;
    tabController?.animateTo(index);
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }
}
