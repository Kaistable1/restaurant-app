import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var selectedCategory = "".obs;
  RxBool isSpotlightFinish = false.obs;
  final List<String> carouselImages = [
    'assets/images/img4.png',
    'assets/images/img2.png',
    'assets/images/img3.png',
  ];
  var categories = [
    {"name": "Cuisines", "image": 'assets/images/cuisines.png'},
    {"name": "New", "image": 'assets/images/new.png'},
    {"name": "Trending", "image": 'assets/images/trending.png'},
    {"name": "Experience", "image": 'assets/images/entertainment.png'},
    {"name": "Events", "image": 'assets/images/new.png'},
  ].obs;

  var trendingItems = [
    {
      "name": "Spice Symphony",
      "description": 'Lorem ipsum dolor sit amet.',
      "image": 'assets/images/spice.png'
    },
    {
      "name": "Flavor Harmony",
      "description": 'Lorem ipsum dolor sit amet.',
      "image": 'assets/images/flavor.png'
    },
    {
      "name": "Spice Symphony",
      "description": 'Lorem ipsum dolor sit amet.',
      "image": 'assets/images/new.png'
    },
    {
      "name": "Flavor Harmony",
      "description": 'Lorem ipsum dolor sit amet.',
      "image": 'assets/images/trending.png'
    },
  ].obs;

  var nearRestaurants = [
    {
      "name": "Spice Symphony",
      "description": 'Lorem ipsum dolor sit amet.',
      "image": 'assets/images/spice.png'
    },
    {
      "name": "Flavor Harmony",
      "description": 'Lorem ipsum dolor sit amet.',
      "image": 'assets/images/flavor.png'
    },
    {
      "name": "Spice Symphony",
      "description": 'Lorem ipsum dolor sit amet.',
      "image": 'assets/images/new.png'
    },
    {
      "name": "Flavor Harmony",
      "description": 'Lorem ipsum dolor sit amet.',
      "image": 'assets/images/trending.png'
    },
  ].obs;
  // Track the selected category

  void selectCategory(String category, Widget page) {
    selectedCategory.value = category;
    Get.to(() => page); // Navigate using Get.to()
  }
}
