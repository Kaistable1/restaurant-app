import 'package:get/get.dart';

class HomeTrendingController extends GetxController {
  var trendingItem = <TrendingItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTrending();
  }

  void loadTrending() {
    // Dummy data. Replace with your actual data source.
    trendingItem.addAll([
      TrendingItem(
          title: 'Pasta',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timetext: '09:00',endTimeText: '08:00',
          percentText: '50%'),
      TrendingItem(
          title: 'Buffet',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          timetext: '06:00',endTimeText: '08:00',
          percentText: '80%'),
      TrendingItem(
          title: 'Pizza',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          timetext: '12:00',endTimeText: '08:00',
          percentText: '60%'),
      TrendingItem(
          title: 'Salad',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timetext: '01:00',endTimeText: '08:00',
          percentText: '40%'),
      TrendingItem(
          title: 'Buffet',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          timetext: '18:00',endTimeText: '08:00',
          percentText: '20%'),
      TrendingItem(
          title: 'Pasta',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timetext: '16:00',endTimeText: '08:00',
          percentText: '50%'),
      TrendingItem(
          title: 'Pizza',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          timetext: '03:00',endTimeText: '08:00',
          percentText: '56%'),
      TrendingItem(
        title: 'Salad',
        description:
            'Duis aute irure dolor in reprehend voluptate velit esse cillum',
        imagePath: 'assets/images/a3.png',
        timetext: '06:00',endTimeText: '08:00',
        percentText: '07%',
      ),
    ]);
  }
}

class TrendingItem {
  String title;
  String description;
  String imagePath;
  String timetext;
  String endTimeText;
  String percentText;

  TrendingItem(
      {required this.title,
      required this.description,
      required this.imagePath,
      required this.timetext,
      required this.endTimeText,
      required this.percentText});
}
