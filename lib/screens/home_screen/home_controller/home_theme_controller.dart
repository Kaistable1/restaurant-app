import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../model/home-model.dart';
import '../model/theme_model.dart';
// Import your model

class HomeThemeController extends GetxController {
  // ScrollController to control the ListView scroll position
  ScrollController scrothemellController = ScrollController();

  // List of CircleContainerModel objects
  final List<ThemeModel> circleItems = [
    ThemeModel(
      imgPath: 'assets/images/circle_img.png',
      titleText: 'Super mega sale',
      descriptionText: '14 restaurants',
    ),
    ThemeModel(
      imgPath: 'assets/images/circle_img2.png',
      titleText: 'Discount fiesta',
      descriptionText: '20 restaurants',
    ),
    ThemeModel(
      imgPath: 'assets/images/circle_img3.png',
      titleText: 'Discount fiesta',
      descriptionText: '20 restaurants',
    ),
    ThemeModel(
      imgPath: 'assets/images/circle_img.png',
      titleText: 'Super mega sale',
      descriptionText: '14 restaurants',
    ),
    ThemeModel(
      imgPath: 'assets/images/circle_img2.png',
      titleText: 'Discount fiesta',
      descriptionText: '20 restaurants',
    ),
    ThemeModel(
      imgPath: 'assets/images/circle_img3.png',
      titleText: 'Discount fiesta',
      descriptionText: '20 restaurants',
    ),
    ThemeModel(
      imgPath: 'assets/images/circle_img.png',
      titleText: 'Super mega sale',
      descriptionText: '14 restaurants',
    ),
    ThemeModel(
      imgPath: 'assets/images/circle_img2.png',
      titleText: 'Discount fiesta',
      descriptionText: '20 restaurants',
    ),
    ThemeModel(
      imgPath: 'assets/images/circle_img3.png',
      titleText: 'Discount fiesta',
      descriptionText: '20 restaurants',
    ),

    // Add more items as needed
  ];

  // Function to scroll left
  void scrollLeft() {
    scrothemellController.animateTo(
      scrothemellController.offset - 300, // Scroll left by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Function to scroll right
  void scrollRight() {
    scrothemellController.animateTo(
      scrothemellController.offset + 300, // Scroll right by 300 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    scrothemellController.dispose(); // Dispose the controller when not in use
    super.onClose();
  }
}
