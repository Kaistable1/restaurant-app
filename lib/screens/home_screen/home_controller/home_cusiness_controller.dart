import 'package:get/get.dart';

class HomeCusinessController extends GetxController {
  var cusinessItem = <CusinessItemItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCusiness();
  }

  void loadCusiness() {
    // Dummy data. Replace with your actual data source.
    cusinessItem.addAll([
      CusinessItemItem(
          title: 'Buffet',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          timeText: '09:00',
          percentText: '50%', endTimeText: '09:00'),
      CusinessItemItem(
          title: 'Salad',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timeText: '06:00',
          percentText: '80%', endTimeText: '09:00'),
      CusinessItemItem(
          title: 'Pizza',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          timeText: '12:00',
          percentText: '60%', endTimeText: '09:00'),
      CusinessItemItem(
          title: 'Salad',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timeText: '01:00',
          percentText: '40%', endTimeText: '09:00'),
      CusinessItemItem(
          title: 'Buffet',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          timeText: '18:00',
          percentText: '20%', endTimeText: '09:00'),
      CusinessItemItem(
          title: 'Pasta',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          timeText: '16:00',
          percentText: '50%', endTimeText: '09:00'),
      CusinessItemItem(
          title: 'Pizza',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timeText: '03:00',
          percentText: '56%', endTimeText: '09:00'),
      CusinessItemItem(
        title: 'Salad',
        description:
            'Duis aute irure dolor in reprehend voluptate velit esse cillum',
        imagePath: 'assets/images/a2.png',
        timeText: '06:00',
        percentText: '07%', endTimeText: '09:00',
      ),
    ]);
  }
}

class CusinessItemItem {
  String title;
  String description;
  String imagePath;
  String timeText;
  String endTimeText;
  String percentText;

  CusinessItemItem(
      {required this.title,
      required this.description,
      required this.imagePath,
      required this.timeText,
      required this.endTimeText,
      required this.percentText});
}
