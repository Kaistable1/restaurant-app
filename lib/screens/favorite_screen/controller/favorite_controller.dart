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
      FavoriteItem(
          title: 'Pasta',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          timetext: '09:00',
          percentText: '50%',
          isFavorite: false.obs),
      FavoriteItem(
          title: 'Pasta',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          timetext: '06:00',
          percentText: '80%',
          isFavorite: false.obs),
      FavoriteItem(
          title: 'Pizza',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timetext: '12:00',
          percentText: '60%',
          isFavorite: false.obs),
      FavoriteItem(
          title: 'Salad',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          timetext: '01:00',
          percentText: '40%',
          isFavorite: false.obs),
      FavoriteItem(
          title: 'Buffet',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          timetext: '18:00',
          percentText: '20%',
          isFavorite: false.obs),
      FavoriteItem(
          title: 'Pasta',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a3.png',
          timetext: '16:00',
          percentText: '50%',
          isFavorite: false.obs),
      FavoriteItem(
          title: 'Pizza',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a2.png',
          timetext: '03:00',
          percentText: '56%',
          isFavorite: false.obs),
      FavoriteItem(
          title: 'Salad',
          description:
              'Duis aute irure dolor in reprehend voluptate velit esse cillum',
          imagePath: 'assets/images/a1.png',
          timetext: '06:00',
          percentText: '07%',
          isFavorite: false.obs),
    ]);
  }
}

class FavoriteItem {
  String title;
  String description;
  String imagePath;
  String timetext;
  String percentText;
  RxBool isFavorite;

  FavoriteItem(
      {required this.title,
      required this.isFavorite,
      required this.description,
      required this.imagePath,
      required this.timetext,
      required this.percentText});
}
