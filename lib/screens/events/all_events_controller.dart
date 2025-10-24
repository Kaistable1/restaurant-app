import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../models/events.dart';

class AllEventsController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  RxBool searchToggle = true.obs;
  // RxString searchQuery = ''.obs;
  // Timer? _debounceTimer;

  List<String> menuItems = [
    'Concerts',
    'Sports',
    'Day Parties',
    'Pool Parties',
    'Pop-ups',
    'Festivals',
    'Global Events',
    'City Sponsored Events',
  ];
  // RxString menuItem = ''.obs;

  Position? currentPosition = null;

  final distanceOptions = ['1 mi', '3 mi', '5 mi', '10 mi', '25 mi', 'All'];
  RxInt selectedDistance = 0.obs;

  RxList<String> selectedMenuItems = <String>[].obs;

  RxInt tabIndex = 0.obs;

  List<Event> filteredEventsList = [];

  // City selector
  RxString selectedCity = 'Los Angeles'.obs;
  final List<Map<String, String>> cities = [
    {'name': 'Los Angeles', 'image': 'assets/images/city_los.png'},
    {'name': 'New York', 'image': 'assets/images/city_new.png'},
    {'name': 'Miami', 'image': 'assets/images/city_miami.png'},
    {'name': 'Chicago', 'image': 'assets/images/city_chicago.png'},
  ];

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions denied; handle accordingly
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions permanently denied; handle accordingly (e.g., open settings)
      return;
    }
    // Get position and store it
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
  }

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation(); // ADDED: Fetch user's location on initialization
  }
  // void debounceSearch(String query, {Duration duration = const Duration(milliseconds: 500)}) {
  //   // Cancel the previous timer if it exists
  //   _debounceTimer?.cancel();
  //
  //   // Set a new timer
  //   _debounceTimer = Timer(duration, () {
  //     searchQuery.value = query;
  //   });
  // }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }
}
