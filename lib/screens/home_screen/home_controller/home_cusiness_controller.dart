import 'package:get/get.dart';

class HomeCusinessController extends GetxController {
  var cusinessItem = <CusinessItemItem>[].obs;
  var exploreRestaurantsItem = <ExploreRestaurantItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCusiness();
    loadExploreRestaurants();
  }


  void loadExploreRestaurants() {
    exploreRestaurantsItem.addAll([
      ExploreRestaurantItem(
          title: 'Buffet',
          description:
          'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          timeText: '09:00',
          percentText: '50%', endTimeText: '09:00'),
      ExploreRestaurantItem(
          title: 'Salad',
          description:
          'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timeText: '06:00',
          percentText: '80%', endTimeText: '09:00'),
      ExploreRestaurantItem(
          title: 'Pizza',
          description:
          'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          timeText: '12:00',
          percentText: '60%', endTimeText: '09:00'),
      ExploreRestaurantItem(
          title: 'Salad',
          description:
          'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timeText: '01:00',
          percentText: '40%', endTimeText: '09:00'),
      ExploreRestaurantItem(
          title: 'Buffet',
          description:
          'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          timeText: '18:00',
          percentText: '20%', endTimeText: '09:00'),
      ExploreRestaurantItem(
          title: 'Pasta',
          description:
          'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          timeText: '16:00',
          percentText: '50%', endTimeText: '09:00'),
      ExploreRestaurantItem(
          title: 'Pizza',
          description:
          'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timeText: '03:00',
          percentText: '56%', endTimeText: '09:00'),
      ExploreRestaurantItem(
        title: 'Salad',
        description:
        'Duis aute irure dolor in reprehend voluptate velit esse cillum',
        imagePath: 'assets/images/a2.png',
        timeText: '06:00',
        percentText: '07%', endTimeText: '09:00',
      ),
    ]);
  }
  void loadCusiness() {
    // Dummy data. Replace with your actual data source.
    cusinessItem.addAll([
      CusinessItemItem(
          title: 'Indian Food',
          description:
              '14 restaurants',
          imagePath: 'assets/images/location_img1.png',),
      CusinessItemItem(
        title: 'Indian Food',
        description:
        '14 restaurants',
          imagePath: 'assets/images/location_img1.png',),
      CusinessItemItem(
        title: 'Indian Food',
        description:
        '14 restaurants',
          imagePath: 'assets/images/location_img1.png',),
      CusinessItemItem(
        title: 'Indian Food',
        description:
        '14 restaurants',
          imagePath: 'assets/images/location_img1.png',),
      CusinessItemItem(
        title: 'Indian Food',
        description:
        '14 restaurants',
          imagePath: 'assets/images/location_img1.png',),
      CusinessItemItem(
        title: 'Indian Food',
        description:
        '14 restaurants',
          imagePath: 'assets/images/location_img1.png',),
      CusinessItemItem(
        title: 'Indian Food',
        description:
        '14 restaurants',
          imagePath: 'assets/images/location_img1.png',),
      CusinessItemItem(
        title: 'Indian Food',
        description:
        '14 restaurants',
        imagePath: 'assets/images/location_img1.png',
      ),
      CusinessItemItem(
        title: 'Indian Food',
        description:
        '14 restaurants',
        imagePath: 'assets/images/location_img1.png',),
      CusinessItemItem(
        title: 'Indian Food',
        description:
        '14 restaurants',
        imagePath: 'assets/images/location_img1.png',
      ),
      CusinessItemItem(
        title: 'Indian Food',
        description:
        '14 restaurants',
        imagePath: 'assets/images/location_img1.png',),
      CusinessItemItem(
        title: 'Indian Food',
        description:
        '14 restaurants',
        imagePath: 'assets/images/location_img1.png',
      ),
      CusinessItemItem(
        title: 'Indian Food',
        description:
        '14 restaurants',
        imagePath: 'assets/images/location_img1.png',),
      CusinessItemItem(
        title: 'Indian Food',
        description:
        '14 restaurants',
        imagePath: 'assets/images/location_img1.png',
      ),
    ]);
  }
}

class CusinessItemItem {
  String title;
  String description;
  String imagePath;

  CusinessItemItem(
      {required this.title,
      required this.description,
      required this.imagePath,});
}


class ExploreRestaurantItem {
  String title;
  String description;
  String imagePath;
  String timeText;
  String endTimeText;
  String percentText;

  ExploreRestaurantItem(
      {required this.title,
        required this.description,
        required this.imagePath,
        required this.timeText,
        required this.endTimeText,
        required this.percentText});
}
