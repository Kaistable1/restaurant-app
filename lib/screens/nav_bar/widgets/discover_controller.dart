import 'package:get/get.dart';

class RestaurantController extends GetxController {
  // var bookmarkedRestaurantIds = <String>[].obs; // Store bookmarked restaurant IDs
  //
  // void toggleBookmark(String docID) {
  //   if (bookmarkedRestaurantIds.contains(docID)) {
  //     bookmarkedRestaurantIds.remove(docID);
  //   } else {
  //     bookmarkedRestaurantIds.add(docID);
  //   }
  //   bookmarkedRestaurantIds.refresh();
  // }
  //
  // void removeBookmark(String docID) {
  //   bookmarkedRestaurantIds.remove(docID);
  //   bookmarkedRestaurantIds.refresh();
  // }
  //
  // List<String> get bookmarkedIds => bookmarkedRestaurantIds.toList();

  final RxList<String> favoriteIds = <String>[].obs;
}