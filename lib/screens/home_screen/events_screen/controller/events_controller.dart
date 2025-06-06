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

  // Future<Position> _getCurrentLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     throw Exception('Location services are disabled.');
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       throw Exception('Location permissions are denied.');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     throw Exception('Location permissions are permanently denied.');
  //   }

  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }


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


  // Future<Position?> _getCurrentLocation() async {
  //   try {
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       await _showLocationServiceDisabledDialog();
  //       return null; // Don't force loop
  //     }

  //     LocationPermission permission = await Geolocator.checkPermission();

  //     if (permission == LocationPermission.denied) {
  //       bool? granted = await _showPermissionRequestDialog();
  //       if (granted == true) {
  //         permission = await Geolocator.requestPermission();
  //       }
  //     }

  //     if (permission == LocationPermission.deniedForever) {
  //       await _showPermissionPermanentlyDeniedDialog();
  //       return null;
  //     }

  //     if (permission == LocationPermission.whileInUse ||
  //         permission == LocationPermission.always) {
  //       return await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //       );
  //     }

  //     return null;
  //   } catch (e) {
  //     print('Location error: $e');
  //     return null; // Don't return dummy Position
  //   }
  // }

// Updated dialog methods that return Future<bool?>
  // Future<bool?> _showPermissionRequestDialog() async {
  //   return await Get.dialog<bool>(
  //     AlertDialog(
  //       title: Text('Location Access Needed'),
  //       content: Text(
  //         'To show events near you, we need access to your location. '
  //         'We only use this to find nearby events and never share your data.',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(result: false),
  //           child: Text('Not Now'),
  //         ),
  //         TextButton(
  //           onPressed: () => Get.back(result: true),
  //           child: Text('Allow'),
  //         ),
  //       ],
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

  // Future<bool?> _showLocationServiceDisabledDialog() async {
  //   return await Get.dialog<bool>(
  //     AlertDialog(
  //       title: Text('Location Services Disabled'),
  //       content: Text(
  //         'Your device\'s location services are turned off. '
  //         'Please enable them to see events near you.',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(result: false),
  //           child: Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             Get.back(result: true); // Close dialog immediately
  //             await Future.delayed(
  //                 Duration(milliseconds: 300)); // Let dialog close
  //             await Geolocator.openLocationSettings(); // Then open settings
  //           },
  //           child: Text('Enable Location'),
  //         ),
  //       ],
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

  // Future<bool?> _showPermissionPermanentlyDeniedDialog() async {
  //   return await Get.dialog<bool>(
  //     AlertDialog(
  //       title: Text('Location Permission Required'),
  //       content: Text(
  //         'You have permanently denied location permissions. '
  //         'To use this feature, please enable location permissions '
  //         'in your device settings.',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(result: false),
  //           child: Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             Get.back(result: true); // Close dialog first
  //             await Future.delayed(
  //                 Duration(milliseconds: 300)); // Let dialog fully disappear
  //             await Geolocator.openAppSettings(); // or openLocationSettings()
  //           },
  //           child: Text('Open Settings'),
  //         ),
  //       ],
  //     ),
  //     barrierDismissible: false,
  //   );
  // }




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



Future<void> fetchAllEventsForFilters() async {
  try {
    isLoading.value = true;

    Position? position = await _getCurrentLocation();

    GeoPoint? userLocation;
    if (position != null) {
      userLocation = GeoPoint(position.latitude, position.longitude);
    }

    // Fetch all events
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('events')
        .orderBy('createdAt', descending: true)
        .limit(pageSize)
        .get();

    List<Event> allEvents = snapshot.docs.map((doc) {
      final data = doc.data();
      return Event.fromMap(doc.id, data);
    }).toList();

    // Optional: Filter if location available
    if (userLocation != null) {
      const double radiusInKm = 20 * 1.60934;
      filteredEvents.value = allEvents.where((event) {
        double distance = _calculateDistance(
            userLocation!, GeoPoint(event.latitude, event.longitude));
        return distance <= radiusInKm;
      }).toList();
    } else {
      // If no location, show all
      filteredEvents.value = allEvents;
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      String search = searchQuery.value.trim().toLowerCase();
      filteredEvents.value = filteredEvents
          .where((event) => event.eventName.toLowerCase().contains(search))
          .toList();
    }

    events.clear();
    hasMore.value = filteredEvents.isNotEmpty;
    paginateFilteredEvents();
  } catch (e) {
    print("Error fetching events: $e");
  } finally {
    isLoading.value = false;
  }
}





  // Future<void> fetchAllEventsForFilters() async {
  //   try {
  //     isLoading.value = true;

  //     // Get user's current location
  //     Position? position = await _getCurrentLocation();
  //     print('lat lng current user ${position!.latitude} ${position.longitude}');
  //     GeoPoint userLocation = GeoPoint(
  //         position.latitude, position.longitude); // Hardcoded for testing

  //     // Fetch all events
  //     QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
  //         .collection('events')
  //         .orderBy('createdAt', descending: true)
  //         .limit(pageSize)
  //         .get();

  //     // Convert to Event objects
  //     List<Event> allEvents = snapshot.docs.map((doc) {
  //       final data = doc.data();
  //       return Event.fromMap(doc.id, data);
  //     }).toList();

  //     // Filter events within 20 miles (32.1868 km)
  //     const double radiusInKm = 20 * 1.60934;
  //     filteredEvents.value = allEvents.where((event) {
  //       GeoPoint eventPoint = GeoPoint(event.latitude, event.longitude);
  //       double distanceKm = _calculateDistance(userLocation, eventPoint);
  //       return distanceKm <= radiusInKm;
  //     }).toList();

  //     // Apply search filter
  //     if (searchQuery.value.isNotEmpty) {
  //       String search = searchQuery.value.trim().toLowerCase();
  //       filteredEvents.value = filteredEvents
  //           .where((event) => event.eventName.toLowerCase().contains(search))
  //           .toList();
  //     }

  //     // Reset events and paginate filtered results
  //     events.clear();
  //     hasMore.value = filteredEvents.isNotEmpty;
  //     paginateFilteredEvents();
  //   } catch (e) {
  //     print('Exception Error: $e');
  //     Get.snackbar(
  //       'Error',
  //       'Failed to fetch events: $e',
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       snackPosition: SnackPosition.TOP,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }




// Future<void> fetchAllEventsForFilters() async {
//   try {
//     isLoading.value = true;

//     GeoPoint userLocation;
//     try {
//       Position position = await _getCurrentLocation();
//       userLocation = GeoPoint(position.latitude, position.longitude);
//     } catch (e) {
//       // Use default location if permission denied
//       userLocation = GeoPoint(0.0, 0.0);
//     }

//     QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
//         .collection('events')
//         .orderBy('createdAt', descending: true)
//         .limit(pageSize)
//         .get();

//     List<Event> allEvents = snapshot.docs.map((doc) {
//       return Event.fromMap(doc.id, doc.data());
//     }).toList();

//     // Only filter by distance if we have real user location
//     if (userLocation.latitude != 0.0 && userLocation.longitude != 0.0) {
//       const double radiusInKm = 20 * 1.60934;
//       filteredEvents.value = allEvents.where((event) {
//         double distanceKm = _calculateDistance(
//           userLocation,
//           GeoPoint(event.latitude, event.longitude)
//         );
//         return distanceKm <= radiusInKm;
//       }).toList();
//     } else {
//       // Show all events if location not available
//       filteredEvents.value = allEvents;
//       Get.snackbar(
//         'Notice',
//         'Showing all events as location access was denied',
//         backgroundColor: Colors.orange,
//       );
//     }

//     // Rest of your filtering logic...
//   } catch (e) {
//     // Error handling...
//   } finally {
//     isLoading.value = false;
//   }
// }

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
