import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/events.dart';

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
  Rx<Position?> userPosition = Rx<Position?>(null);

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

    _fetchUserLocation();
  }

  // Method to reset filters and fetch all events
  void resetFiltersAndFetch() {
    fetchAllEventsForFilters();
  }

  Future<void> _fetchUserLocation() async {
    final position = await _getCurrentLocation();
    if (position != null) {
      userPosition.value = position;
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Don't ask, just return null — silently
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Location error: $e");
      return null;
    }
  }

//-----------------------

  double _calculateDistance(GeoPoint p1, GeoPoint p2) {
    const double earthRadius = 6371; // Radius of the earth in km
    double lat1 = p1.latitude;
    double lon1 = p1.longitude;
    double lat2 = p2.latitude;
    double lon2 = p2.longitude;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
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

  // Future<void> fetchAllEventsForFilters() async {
  //   try {
  //     isLoading.value = true;

  //     Position? position = await _getCurrentLocation();

  //     GeoPoint? userLocation;
  //     if (position != null) {
  //       userLocation = GeoPoint(position.latitude, position.longitude);
  //     }

  //     // Fetch all events
  //     QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
  //         .collection('events')
  //         .orderBy('createdAt', descending: true)
  //         .limit(pageSize)
  //         .get();

  //     List<Event> allEvents = snapshot.docs.map((doc) {
  //       final data = doc.data();
  //       return Event.fromMap(doc.id, data);
  //     }).toList();

  //     // Optional: Filter if location available
  //     if (userLocation != null) {
  //       const double radiusInKm = 20 * 1.60934;
  //       filteredEvents.value = allEvents.where((event) {
  //         double distance = _calculateDistance(
  //             userLocation!, GeoPoint(event.latitude, event.longitude));
  //         return distance <= radiusInKm;
  //       }).toList();
  //     } else {
  //       // If no location, show all
  //       filteredEvents.value = allEvents;
  //     }

  //     // Apply search filter
  //     if (searchQuery.value.isNotEmpty) {
  //       String search = searchQuery.value.trim().toLowerCase();
  //       filteredEvents.value = filteredEvents
  //           .where((event) => event.eventName.toLowerCase().contains(search))
  //           .toList();
  //     }

  //     events.clear();
  //     hasMore.value = filteredEvents.isNotEmpty;
  //     paginateFilteredEvents();
  //   } catch (e) {
  //     print("Error fetching events: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

//   Future<void> fetchAllEventsForFilters() async {
//     try {
//       isLoading.value = true;

//       Position? position = await _getCurrentLocation();
//       GeoPoint? userLocation;
//       if (position != null) {
//         userLocation = GeoPoint(position.latitude, position.longitude);
//       }

//       // Fetch all events
//       QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
//           .collection('events')
//           .orderBy('createdAt', descending: true)
//           .limit(50) // Increased for broader fallback
//           .get();

//       List<Event> allEvents = snapshot.docs.map((doc) {
//         final data = doc.data();
//         return Event.fromMap(doc.id, data);
//       }).toList();

//       // 🔥 Step 1: Try Nearby First
//       List<Event> nearbyEvents = [];

//       if (userLocation != null) {
//         const double radiusInKm = 20 * 1.60934;
//         nearbyEvents = allEvents.where((event) {
//           double distance = _calculateDistance(
//             userLocation!,
//             GeoPoint(event.latitude, event.longitude),
//           );
//           return distance <= radiusInKm;
//         }).toList();
//       }

//       // 🔥 Step 2: Fallback — if no nearby or no location, show all
//       if (nearbyEvents.isEmpty) {
//         filteredEvents.value = allEvents;
//       } else {
//         filteredEvents.value = nearbyEvents;
//       }

//       // 🔍 Apply search filter
//       if (searchQuery.value.isNotEmpty) {
//         String search = searchQuery.value.trim().toLowerCase();
//         filteredEvents.value = filteredEvents
//             .where((event) => event.eventName.toLowerCase().contains(search))
//             .toList();
//       }
//       events.value =
//           filteredEvents; // This syncs filtered data to the 'events' list used in the widget

//       // events.clear();
//       hasMore.value = filteredEvents.isNotEmpty;
//       paginateFilteredEvents();
//     } catch (e) {
//       print("Error fetching events: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

Future<void> fetchAllEventsForFilters() async {
  try {
    isLoading.value = true;

    // 1. Fetch all events immediately:
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('events')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();

    List<Event> allEvents = snapshot.docs.map((doc) {
      final data = doc.data();
      return Event.fromMap(doc.id, data);
    }).toList();

    // Show all events immediately:
    events.value = allEvents; // show all immediately
    filteredEvents.value = allEvents;

    isLoading.value = false; // stop loader on screen

    // 2. Now fetch location in background:
    Position? position = await _getCurrentLocation();
    GeoPoint? userLocation;
    if (position != null) {
      userLocation = GeoPoint(position.latitude, position.longitude);
    }

    // 3. Nearby calculation in background:
    List<Event> nearbyEvents = [];
    if (userLocation != null) {
      const double radiusInKm = 20 * 1.60934;
      nearbyEvents = allEvents.where((event) {
        double distance = _calculateDistance(
          userLocation!,
          GeoPoint(event.latitude, event.longitude),
        );
        return distance <= radiusInKm;
      }).toList();
    }

    // 4. Update if nearby found:
    if (nearbyEvents.isNotEmpty) {
      filteredEvents.value = nearbyEvents;
      events.value = nearbyEvents;
    }

    // Apply search if user typed:
    if (searchQuery.value.isNotEmpty) {
      String search = searchQuery.value.trim().toLowerCase();
      filteredEvents.value = filteredEvents
          .where((event) => event.eventName.toLowerCase().contains(search))
          .toList();
      events.value = filteredEvents;
    }

    hasMore.value = filteredEvents.isNotEmpty;
    paginateFilteredEvents();
  } catch (e) {
    print("Error fetching events: $e");
  }
}



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





//   void paginateFilteredEvents() {
//     if (!hasMore.value) return;

//     int startIndex = events.length;
//     int endIndex = startIndex + pageSize;
//     if (endIndex >= filteredEvents.length) {
//       endIndex = filteredEvents.length;
//       hasMore.value = false;
//     }

//     if (startIndex >= filteredEvents.length) {
//       hasMore.value = false;
//       return;
//     }

//     List<Event> newEvents = filteredEvents.sublist(startIndex, endIndex);
//     events.addAll(newEvents);
//   }
// }
