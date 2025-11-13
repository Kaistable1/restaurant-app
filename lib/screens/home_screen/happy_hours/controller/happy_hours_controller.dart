import 'package:get/get.dart';

class HappyHoursController extends GetxController {
  var happyHoursItems = <HappyItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadhappyHoursItems();
  }

  void loadhappyHoursItems() {
    // Dummy data. Replace with your actual data source.
    happyHoursItems.addAll([
      HappyItem(
          title: 'Pasta',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          startTimeText: '09:00',
          endTimeText: '12:00',
          percentText: '50%',
          isFavorite: false.obs),
      HappyItem(
          title: 'Pasta',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          startTimeText: '06:00',
          endTimeText: '12:00',
          percentText: '80%',
          isFavorite: false.obs),
      HappyItem(
          title: 'Pizza',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          startTimeText: '12:00',
          endTimeText: '12:00',
          percentText: '60%',
          isFavorite: false.obs),
      HappyItem(
          title: 'Salad',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          startTimeText: '01:00',
          endTimeText: '08:00',
          percentText: '40%',
          isFavorite: false.obs),
      HappyItem(
          title: 'Buffet',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          startTimeText: '18:00',
          endTimeText: '12:00',
          percentText: '20%',
          isFavorite: false.obs),
      HappyItem(
          title: 'Pasta',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          startTimeText: '16:00',
          endTimeText: '09:00',
          percentText: '50%',
          isFavorite: false.obs),
      HappyItem(
          title: 'Pizza',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          startTimeText: '03:00',
          endTimeText: '01:00',
          percentText: '56%',
          isFavorite: false.obs),
      HappyItem(
          title: 'Salad',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          startTimeText: '06:00',
          endTimeText: '12:00',
          percentText: '07%',
          isFavorite: false.obs),
    ]);
  }
}

class HappyItem {
  String title;
  String description;
  String imagePath;
  String startTimeText;
  String endTimeText;
  String percentText;
  RxBool isFavorite;

  HappyItem(
      {required this.title,
      required this.isFavorite,
      required this.description,
      required this.imagePath,
      required this.startTimeText,
      required this.endTimeText,
      required this.percentText});
}
