import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/models/operating_hour_model.dart';
import 'package:restaurant_web_app/models/resaturant_model.dart';

class RestaurantManagementController extends GetxController {
  final searchController = TextEditingController();
  RxString selectedCity = ''.obs;
  RxString selectedCuisine = ''.obs;
  RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  RxList<RestaurantModel> filteredResults =
      <RestaurantModel>[].obs; // For search and city filter results
  DocumentSnapshot? lastDocument;
  RxBool hasMoreData = true.obs;
  RxBool isLoading = false.obs;
  final int pageSize = 10;
  RxString currentSearchQuery = ''.obs;
  RxString currentCityFilter = ''.obs;
  RxString currentCuisineFilter = ''.obs;
  RxList<String> cityList = <String>[
    "Beverly Hills",
    "Santa Monica",
    "West Hollywood",
    "Downtown LA",
    "Hollywood",
    "Pasadena",
    "Long Beach",
    "Malibu",
    "Glendale",
    "Burbank",
    "Culver City",
    "Torrance",
    "Manhattan Beach",
    "Redondo Beach",
    "Hermosa Beach",
    "Inglewood",
    "Compton",
    "Carson",
    "Downey",
    "Norwalk",
    "Whittier",
    "Arcadia",
    "Monterey Park",
    "Alhambra",
    "San Gabriel",
    "Rosemead",
    "El Monte",
    "West Covina",
    "Pomona",
    "Diamond Bar",
    "Walnut",
    "La Puente",
    "Baldwin Park",
    "Industry",
    "Duarte",
    "Monrovia",
    "Sierra Madre",
    "San Marino",
    "South Pasadena",
    "La Canada Flintridge",
    "Altadena",
    "North Hollywood",
    "Studio City",
    "Sherman Oaks",
    "Encino",
    "Tarzana",
    "Woodland Hills",
    "Calabasas",
    "Agoura Hills",
    "Westlake Village",
    "Thousand Oaks",
    "Simi Valley",
    "Chatsworth",
    "Granada Hills",
    "Porter Ranch",
    "Northridge",
    "Reseda",
    "Van Nuys",
    "Panorama City",
    "Mission Hills",
    "Sylmar",
    "San Fernando",
    "Sun Valley",
    "Sunland",
    "Tujunga",
    "La Crescenta",
    "Montrose",
    "Eagle Rock",
    "Highland Park",
    "Glassell Park",
    "Atwater Village",
    "Los Feliz",
    "Silver Lake",
    "Echo Park",
    "Koreatown",
    "Mid-City",
    "West Adams",
    "Leimert Park",
    "Crenshaw",
  ].obs;

  RxList<String> cuisineList = <String>[
    'Chinese',
    'Italian',
    'Fast Food',
    'Mexican',
    'Thai',
    'Japanese',
    'Mediterranean',
    'American',
  ].obs;
  RxInt totalRestaurantsLength = 0.obs;

  Stream<List<MyOperatingHours>> getOperatingHours(String restId) {
    try {
      // Reference to the operatingHours subcollection for the given restId
      final Stream<QuerySnapshot> operatingHoursStream = FirebaseFirestore
          .instance
          .collection('restaurants')
          .doc(restId)
          .collection('operatingHours')
          .snapshots();

      // Transform the stream of QuerySnapshots into a stream of List<OperatingHours>
      return operatingHoursStream.map((QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot doc) {
          return MyOperatingHours.fromDocument(doc);
        }).toList();
      });
    } catch (e) {
      // Return a stream with error if something goes wrong
      return Stream.error('Error fetching operating hours: $e');
    }
  }
}
