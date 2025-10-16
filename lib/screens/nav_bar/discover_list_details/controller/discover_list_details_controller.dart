import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../models/restaurant_model.dart';

class DiscoverListDetailsController extends GetxController{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<RestaurantModel> selectedRestaurants = <RestaurantModel>[].obs;

  RxBool gettingRestaurants = true.obs;

  Future<void> loadSelectedRestaurants(List<dynamic> ids) async {
    selectedRestaurants.clear();
    for (var id in ids) {
      try {
        final doc = await _firestore.collection('restaurants').doc(id).get();
        if (doc.exists) {
          selectedRestaurants.add(RestaurantModel.fromDocumentSnapshot(doc));
        }
      } catch (e) {
        print('Error loading restaurant $id: $e');
      }
    }
    gettingRestaurants.value = false;
    update();
  }

}