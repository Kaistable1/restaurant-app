import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationListController extends GetxController {
  ScrollController scrollController = ScrollController();

  void scrollLeft() {
    scrollController.animateTo(
      scrollController.offset - 300, // Scroll left by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight() {
    scrollController.animateTo(
      scrollController.offset + 300, // Scroll right by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    scrollController.dispose(); // Dispose the controller when not in use
    super.onClose();
  }
}

class LocationListModel {
  final String timeText;
  final String timeText2;
  final String percentageText;
  LocationListModel({
    required this.timeText,
    required this.timeText2,
    required this.percentageText,
  });
}
