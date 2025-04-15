import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  FirebaseFirestore _firebase = FirebaseFirestore.instance;
  RxInt totalRestaurants = 0.obs;
  RxInt totalEvents = 0.obs;
  RxInt registeredCount = 0.obs;
  RxInt pendingCount = 0.obs;

  Future<void> getTotalRestaurants() async {
    final snapshot = await _firebase.collection('restaurants').get();
    totalRestaurants.value = snapshot.docs.length;
  }

  Future<void> getTotalEvents() async {
    final snapshot = await _firebase.collection('events').get();
    totalEvents.value = snapshot.docs.length;
  }

  // Stream for Registered Restaurants Count
  Stream<int> streamRegisteredRestaurantsCount() {
    CollectionReference restaurantsRef =
        FirebaseFirestore.instance.collection('restaurants');

    return restaurantsRef
        .where('resEmail', isNotEqualTo: '')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.length;
    });
  }

  // Stream for Pending Restaurants Count
  Stream<int> streamPendingRestaurantsCount() {
    CollectionReference restaurantsRef =
        FirebaseFirestore.instance.collection('restaurants');

    return restaurantsRef
        .where('resEmail', isEqualTo: '')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.length;
    });
  }

  // Initialize streams for a specific email
  initCountStreams() {
    streamRegisteredRestaurantsCount().listen((count) {
      registeredCount.value = count;
    });

    streamPendingRestaurantsCount().listen((count) {
      pendingCount.value = count;
    });
  }

  @override
  void onInit() {
    super.onInit();
    getTotalRestaurants();
    getTotalEvents();
    initCountStreams();
  }
}
