import 'package:get/get.dart';

class HomeNewController extends GetxController {
  var newItem = <NewItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNew();
  }

  void loadNew() {
    // Dummy data. Replace with your actual data source.
    newItem.addAll([
      NewItem(
          title: 'Pasta',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          timetext: '09:00',endTimeText: '08:00',
          percentText: '50%'),
      NewItem(
          title: 'Buffet',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timetext: '06:00',endTimeText: '08:00',
          percentText: '80%'),
      NewItem(
          title: 'Pizza',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          timetext: '12:00',endTimeText: '08:00',
          percentText: '60%'),
      NewItem(
          title: 'Salad',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          timetext: '01:00',endTimeText: '08:00',
          percentText: '40%'),
      NewItem(
          title: 'Buffet',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          timetext: '18:00',endTimeText: '08:00',
          percentText: '20%'),
      NewItem(
          title: 'Pasta',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timetext: '16:00',endTimeText: '08:00',
          percentText: '50%'),
      NewItem(
          title: 'Pizza',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          timetext: '03:00',endTimeText: '08:00',
          percentText: '56%'),
      NewItem(
        title: 'Salad',
        description:
            'Duis aute irure dolor in reprehend voluptate velit esse cillum',
        imagePath: 'assets/images/a1.png',
        timetext: '06:00',endTimeText: '08:00',
        percentText: '07%',
      ),
    ]);
  }
}

class NewItem {
  String title;
  String description;
  String imagePath;
  String timetext;
  String endTimeText;
  String percentText;

  NewItem(
      {required this.title,
      required this.description,
      required this.imagePath,
      required this.timetext,
      required this.endTimeText,
      required this.percentText});
}
