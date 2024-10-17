import 'package:get/get.dart';

class FavoriteController extends GetxController {
  var favoriteItems = <FavoriteItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    // Dummy data. Replace with your actual data source.
    favoriteItems.addAll([
      FavoriteItem(title: 'Buffet', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '09:00', percentText: '50%'),
      FavoriteItem(title: 'Pasta', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '06:00', percentText: '80%'),
      FavoriteItem(title: 'Pizza', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '12:00', percentText: '60%'),
      FavoriteItem(title: 'Salad', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '01:00', percentText: '40%'),
      FavoriteItem(title: 'Buffet', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '18:00', percentText: '20%'),
      FavoriteItem(title: 'Pasta', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '16:00', percentText: '50%'),
      FavoriteItem(title: 'Pizza', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png',timetext: '03:00', percentText: '56%'),
      FavoriteItem(title: 'Salad', description: 'Duis aute irure dolor in reprehend voluptate velit esse cillum', imagePath: 'assets/images/plate_img.png', timetext: '06:00', percentText: '07%',),
    ]);
  }
}

class FavoriteItem {
  String title;
  String description;
  String imagePath;
  String timetext;
  String percentText;

  FavoriteItem({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.timetext,
    required this.percentText

  });
}
