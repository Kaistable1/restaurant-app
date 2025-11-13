import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/events.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class EventsController extends GetxController {
  RxInt upcomingAppointmentsCheck = 0.obs;
  RxBool isBookmarked = true.obs;

  void toggleBookmark() {
    isBookmarked.value = !isBookmarked.value;
  }

  //backend

  RxList<Event> events = <Event>[].obs;
  RxList<Event> filteredEvents = <Event>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  final int pageSize = 10;
  final searchController = TextEditingController();

  RxString searchQuery = ''.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    // Initial fetch
    resetFiltersAndFetch();
    // Listen to search changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      fetchAllEventsForFilters();
    });
  }

  // Method to reset filters and fetch all events
  void resetFiltersAndFetch() {
    fetchAllEventsForFilters();
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  double _calculateDistance(GeoPoint p1, GeoPoint p2) {
    const double earthRadius = 6371; // Radius of the earth in km
    double lat1 = p1.latitude;
    double lon1 = p1.longitude;
    double lat2 = p2.latitude;
    double lon2 = p2.longitude;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * asin(sqrt(a));
    return earthRadius * c; // Distance in km
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  Future<void> fetchAllEventsForFilters() async {
    try {
      isLoading.value = true;

      // Get user's current location
      Position position = await _getCurrentLocation();
      print('lat lng current user ${position.latitude} ${position.longitude}');
      GeoPoint userLocation = GeoPoint(
        position.latitude,
        position.longitude,
      ); // Hardcoded for testing

      // Fetch all events
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('events')
          .orderBy('createdAt', descending: true)
          .limit(pageSize)
          .get();

      // Convert to Event objects
      List<Event> allEvents = snapshot.docs.map((doc) {
        final data = doc.data();
        return Event.fromMap(doc.id, data);
      }).toList();

      // Filter events within 20 miles (32.1868 km)
      const double radiusInKm = 20 * 1.60934;
      filteredEvents.value = allEvents.where((event) {
        GeoPoint eventPoint = GeoPoint(event.latitude, event.longitude);
        double distanceKm = _calculateDistance(userLocation, eventPoint);
        return distanceKm <= radiusInKm;
      }).toList();

      // Apply search filter
      if (searchQuery.value.isNotEmpty) {
        String search = searchQuery.value.trim().toLowerCase();
        filteredEvents.value = filteredEvents
            .where((event) => event.eventName.toLowerCase().contains(search))
            .toList();
      }

      // Reset events and paginate filtered results
      events.clear();
      hasMore.value = filteredEvents.isNotEmpty;
      paginateFilteredEvents();
    } catch (e) {
      print('Exception Error: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch events: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Paginate the filtered events
  void paginateFilteredEvents() {
    if (!hasMore.value) return;

    int startIndex = events.length;
    int endIndex = startIndex + pageSize;
    if (endIndex >= filteredEvents.length) {
      endIndex = filteredEvents.length;
      hasMore.value = false;
    }

    if (startIndex >= filteredEvents.length) {
      hasMore.value = false;
      return;
    }

    List<Event> newEvents = filteredEvents.sublist(startIndex, endIndex);
    events.addAll(newEvents);
  }
}
