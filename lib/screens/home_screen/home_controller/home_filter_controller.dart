import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeFilterController extends GetxController{
  var filterItem = <FilterItems>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFilter();
  }
  void loadFilter() {
    // Dummy data. Replace with your actual data source.
    filterItem.addAll([
      FilterItems(title: 'Abc restaurant', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/filter_img.png'),
      FilterItems(title: 'Abc restaurant', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/filter_img.png'),
      FilterItems(title: 'Abc restaurant', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/filter_img.png'),
      FilterItems(title: 'Abc restaurant', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/filter_img.png'),
      FilterItems(title: 'Abc restaurant', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/filter_img.png'),
      FilterItems(title: 'Abc restaurant', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/filter_img.png'),
      FilterItems(title: 'Abc restaurant', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/filter_img.png'),
      FilterItems(title: 'Abc restaurant', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/filter_img.png'),
      FilterItems(title: 'Abc restaurant', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/filter_img.png'),
    ]);
  }
}
class FilterItems {
  String title;
  String description;
  String imagePath;


  FilterItems({
    required this.title,
    required this.description,
    required this.imagePath,


  });
}