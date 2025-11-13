import 'package:get/get.dart';

class HomeRecentlyViewedController extends GetxController {
  var recentlyViewedItem = <RecentlyViewedItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRecents();
  }

  void loadRecents() {
    // Dummy data. Replace with your actual data source.
    recentlyViewedItem.addAll([
      RecentlyViewedItem(
        title: 'Buffet',
        description:
            'Duis aute irure dolor in reprehend voluptate velit esse cillum',
        imagePath: 'assets/images/a1.png',
        timeText: '09:00',
        endTimeText: '08:00',
        percentText: '50%',
      ),
      RecentlyViewedItem(
        title: 'Buffet',
        description:
            'Duis aute irure dolor in reprehend voluptate velit esse cillum',
        imagePath: 'assets/images/a3.png',
        timeText: '06:00',
        endTimeText: '08:00',
        percentText: '80%',
      ),
      RecentlyViewedItem(
        title: 'Pizza',
        description:
            'Duis aute irure dolor in reprehend voluptate velit esse cillum',
        imagePath: 'assets/images/a2.png',
        timeText: '12:00',
        endTimeText: '08:00',
        percentText: '60%',
      ),
      RecentlyViewedItem(
        title: 'Salad',
        description:
            'Duis aute irure dolor in reprehend voluptate velit esse cillum',
        imagePath: 'assets/images/a1.png',
        timeText: '01:00',
        endTimeText: '08:00',
        percentText: '40%',
      ),
      RecentlyViewedItem(
        title: 'Buffet',
        description:
            'Duis aute irure dolor in reprehend voluptate velit esse cillum',
        imagePath: 'assets/images/a2.png',
        timeText: '18:00',
        endTimeText: '08:00',
        percentText: '20%',
      ),
      RecentlyViewedItem(
        title: 'Pasta',
        description:
            'Duis aute irure dolor in reprehend voluptate velit esse cillum',
        imagePath: 'assets/images/a3.png',
        timeText: '16:00',
        endTimeText: '08:00',
        percentText: '50%',
      ),
      RecentlyViewedItem(
        title: 'Pizza',
        description:
            'Duis aute irure dolor in reprehend voluptate velit esse cillum',
        imagePath: 'assets/images/a1.png',
        timeText: '03:00',
        endTimeText: '08:00',
        percentText: '56%',
      ),
      RecentlyViewedItem(
        title: 'Salad',
        description:
            'Duis aute irure dolor in reprehend voluptate velit esse cillum',
        imagePath: 'assets/images/a2.png',
        timeText: '06:00',
        percentText: '07%',
        endTimeText: '08:00',
      ),
    ]);
  }
}

class RecentlyViewedItem {
  String title;
  String description;
  String imagePath;
  String timeText;
  String endTimeText;
  String percentText;

  RecentlyViewedItem({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.timeText,
    required this.endTimeText,
    required this.percentText,
  });
}
