import 'package:get/get.dart';

class LocationController extends GetxController {
  var locationItem = <LocationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLocation();
  }

  void loadLocation() {
    // Dummy data. Replace with your actual data source.
    locationItem.addAll([
      LocationItem(title: 'Pizza', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '09:00', percentText: '50%'),
      LocationItem(title: 'Buffet', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '06:00', percentText: '80%'),
      LocationItem(title: 'Pizza', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '12:00', percentText: '60%'),
      LocationItem(title: 'Salad', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '01:00', percentText: '40%'),
      LocationItem(title: 'Buffet', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '18:00', percentText: '20%'),
      LocationItem(title: 'Pasta', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '16:00', percentText: '50%'),
      LocationItem(title: 'Pizza', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '03:00', percentText: '56%'),
      LocationItem(title: 'Salad', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png', timetext: '06:00', percentText: '07%',),
    ]);
  }
}

class LocationItem {
  String title;
  String description;
  String imagePath;
  String timetext;
  String percentText;

  LocationItem ({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.timetext,
    required this.percentText

  });
}
