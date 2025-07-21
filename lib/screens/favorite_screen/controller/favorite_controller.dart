// import 'package:get/get.dart';

// class FavoriteController extends GetxController {
//   var favoriteItems = <FavoriteItem>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//   //  loadFavorites();
//   }

//   // void loadFavorites() {
//   //   // Dummy data. Replace with your actual data source.
//   //   favoriteItems.addAll([
//   //     FavoriteItem(
//   //         title: 'Pasta',
//   //         description:
//   //             'Duis aute irure dolor in reprehend voluptate velit esse cillum',
//   //         imagePath: 'assets/images/a2.png',
//   //         timetext: '09:00',
//   //         percentText: '50%',endTimeText: '08:00',
//   //         isFavorite: false.obs),
//   //     FavoriteItem(
//   //         title: 'Pasta',
//   //         description:
//   //             'Duis aute irure dolor in reprehend voluptate velit esse cillum',
//   //         imagePath: 'assets/images/a1.png',
//   //         timetext: '06:00',endTimeText: '08:00',
//   //         percentText: '80%',
//   //         isFavorite: false.obs),
//   //     FavoriteItem(
//   //         title: 'Pizza',
//   //         description:
//   //             'Duis aute irure dolor in reprehend voluptate velit esse cillum',
//   //         imagePath: 'assets/images/a3.png',
//   //         timetext: '12:00',
//   //         percentText: '60%',endTimeText: '08:00',
//   //         isFavorite: false.obs),
//   //     FavoriteItem(
//   //         title: 'Salad',
//   //         description:
//   //             'Duis aute irure dolor in reprehend voluptate velit esse cillum',
//   //         imagePath: 'assets/images/a1.png',
//   //         timetext: '01:00',
//   //         percentText: '40%',endTimeText: '08:00',
//   //         isFavorite: false.obs),
//   //     FavoriteItem(
//   //         title: 'Buffet',
//   //         description:
//   //             'Duis aute irure dolor in reprehend voluptate velit esse cillum',
//   //         imagePath: 'assets/images/a2.png',
//   //         timetext: '18:00',
//   //         percentText: '20%',endTimeText: '08:00',
//   //         isFavorite: false.obs),
//   //     FavoriteItem(
//   //         title: 'Pasta',
//   //         description:
//   //             'Duis aute irure dolor in reprehend voluptate velit esse cillum',
//   //         imagePath: 'assets/images/a3.png',
//   //         timetext: '16:00',endTimeText: '08:00',
//   //         percentText: '50%',
//   //         isFavorite: false.obs),
//   //     FavoriteItem(
//   //         title: 'Pizza',
//   //         description:
//   //             'Duis aute irure dolor in reprehend voluptate velit esse cillum',
//   //         imagePath: 'assets/images/a2.png',
//   //         timetext: '03:00',endTimeText: '08:00',
//   //         percentText: '56%',
//   //         isFavorite: false.obs),
//   //     FavoriteItem(
//   //         title: 'Salad',
//   //         description:
//   //             'Duis aute irure dolor in reprehend voluptate velit esse cillum',
//   //         imagePath: 'assets/images/a1.png',
//   //         timetext: '06:00',
//   //         percentText: '07%',endTimeText: '08:00',
//   //         isFavorite: false.obs),
//   //   ]);
//   // }
// }

// class FavoriteItem {
//   String title;
//   String description;
//   String imagePath;
//   String timetext;
//   String endTimeText;
//   String percentText;
//   RxBool isFavorite;

//   FavoriteItem(
//       {required this.title,
//       required this.isFavorite,
//       required this.description,
//       required this.imagePath,
//       required this.timetext,
//       required this.endTimeText,
//       required this.percentText});
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kaistable_website/models/resaturant_model.dart';

class FavoriteController extends GetxController {
  var favoriteIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavoriteIds();
  }

  void fetchFavoriteIds() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorite')
        .get();

    favoriteIds.value =
       snapshot.docs.map((doc) => doc.id).toList();

  }

 void toggleFavorite(String restaurantId) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  final favRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('favorite')
      .doc(restaurantId); // ✅ Use restaurant ID

  final docSnapshot = await favRef.get();

  if (docSnapshot.exists) {
    await favRef.delete();
    favoriteIds.remove(restaurantId);
  } else {
    await favRef.set({
      'resturantID': restaurantId,
    });
    favoriteIds.add(restaurantId);
  }
}

Stream<List<RestaurantModel>> getFavoriteRestaurants() async* {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    yield [];
    return;
  }

  await for (var favSnapshot in FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('favorite')
      .snapshots()) {
        
    final favoriteIds = favSnapshot.docs.map((doc) => doc.id).toList();

    if (favoriteIds.isEmpty) {
      yield [];
      continue;
    }

    List<RestaurantModel> allRestaurants = [];

    // Batch favorite IDs into chunks of 10
    for (int i = 0; i < favoriteIds.length; i += 10) {
      final batchIds = favoriteIds.sublist(
        i,
        i + 10 > favoriteIds.length ? favoriteIds.length : i + 10,
      );

      final snapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where(FieldPath.documentId, whereIn: batchIds)
          .get();

      final batchRestaurants = snapshot.docs
          .map((doc) => RestaurantModel.fromDocumentSnapshot(doc))
          .toList();

      allRestaurants.addAll(batchRestaurants);
    }

    yield allRestaurants;
  }
}



}
