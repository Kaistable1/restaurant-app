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
      CusinessItemItem(title: 'Buffet', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '09:00', percentText: '50%'),
      CusinessItemItem(title: 'Salad', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '06:00', percentText: '80%'),
      CusinessItemItem(title: 'Pizza', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '12:00', percentText: '60%'),
      CusinessItemItem(title: 'Salad', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '01:00', percentText: '40%'),
      CusinessItemItem(title: 'Buffet', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '18:00', percentText: '20%'),
      CusinessItemItem(title: 'Pasta', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '16:00', percentText: '50%'),
      CusinessItemItem(title: 'Pizza', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '03:00', percentText: '56%'),
      CusinessItemItem(title: 'Salad', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png', timetext: '06:00', percentText: '07%',),
    ]);
  }
}

class CusinessItemItem {
  String title;
  String description;
  String imagePath;
  String timetext;
  String percentText;

  CusinessItemItem({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.timetext,
    required this.percentText

  });
}
