import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
class LocationListController extends GetxController {
  ScrollController scrollController = ScrollController();
  final List<LocationListModel> circleItems = [
    LocationListModel(
      timeText: '20:20',
      timeText2: '22:20',
      percentageText: '12%',
    ),
    LocationListModel(
      timeText: '20:20',
      timeText2: '22:20',
      percentageText: '12%',
    ),
    LocationListModel(
      timeText: '20:20',
      timeText2: '22:20',
      percentageText: '12%',
    ),
    LocationListModel(
      timeText: '20:20',
      timeText2: '22:20',
      percentageText: '12%',
    ),
    LocationListModel(
      timeText: '20:20',
      timeText2: '22:20',
      percentageText: '12%',
    ),
    LocationListModel(
      timeText: '20:20',
      timeText2: '22:20',
      percentageText: '12% ',
    ),
    LocationListModel(
      timeText: '20:20',
      timeText2: '22:20',
      percentageText: '12%',
    ),
    LocationListModel(
      timeText: '20:20',
      timeText2: '22:20',
      percentageText: '12%',
    ),
    LocationListModel(
      timeText: '20:20',
      timeText2: '22:20',
      percentageText: '12%',
    ),
  ];
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