import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/models/event.dart';

class EventManagementController extends GetxController {
  final searchController = TextEditingController();
  RxString selectedCity = ''.obs;
  RxString selectedState = ''.obs;
  RxString selectedEvents = ''.obs;
  RxString searchQuery = ''.obs;

  RxList<String> stateList = <String>['New York', 'California'].obs;
  RxList<String> eventsList = <String>['Festival', 'Concert', 'Sports'].obs;

  RxList<Event> events = <Event>[].obs;
  RxList<Event> filteredEvents = <Event>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  final int pageSize = 10;

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
    // Listen to filter changes
    everAll([selectedCity, selectedState, selectedEvents], (_) {
      fetchAllEventsForFilters();
    });
  }

  // Method to reset filters and fetch all events
  void resetFiltersAndFetch() {
    clearFilters();
    fetchAllEventsForFilters();
  }

  // Fetch all events and apply filters client-side
  fetchAllEventsForFilters() async {
    try {
      isLoading.value = true;

      // Fetch events without where clauses to avoid index issues
      Query<Map<String, dynamic>> query = _firestore
          .collection('events')
          .orderBy('createdAt', descending: true);

      // Fetch a large batch
      query = query.limit(100);

      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      List<Event> allEvents = snapshot.docs.map((doc) {
        return Event.fromMap(doc.id, doc.data());
      }).toList();

      // Apply filters client-side
      filteredEvents.value = allEvents;

      // Apply country filter
      if (selectedState.value.isNotEmpty) {
        filteredEvents.value = filteredEvents
            .where((event) => event.country
                .toLowerCase()
                .contains(selectedState.value.toLowerCase()))
            .toList();
      }

      // Apply city filter
      if (selectedCity.value.isNotEmpty) {
        filteredEvents.value = filteredEvents
            .where((event) =>
                event.city.toLowerCase() == selectedCity.value.toLowerCase())
            .toList();
      }

      // Apply event type filter
      if (selectedEvents.value.isNotEmpty) {
        filteredEvents.value = filteredEvents
            .where((event) =>
                event.eventType.toLowerCase() ==
                selectedEvents.value.toLowerCase())
            .toList();
      }

      // Apply search filter
      if (searchQuery.value.isNotEmpty) {
        String search = searchQuery.value.trim().toLowerCase();
        filteredEvents.value = filteredEvents
            .where((event) => event.eventName.toLowerCase().contains(search))
            .toList();
      }

      // Reset events and paginate filtered results
      events.clear();
      hasMore.value = true;
      paginateFilteredEvents();
    } catch (e) {
      print('Exception Error $e');
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

  // Delete an event
  deleteEvent(String docId) async {
    try {
      await _firestore.collection('events').doc(docId).delete();
      events.removeWhere((event) => event.docId == docId);
      filteredEvents.removeWhere((event) => event.docId == docId);
      Get.snackbar(
        'Success',
        'Event deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete event: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Clear filters and search
  void clearFilters() {
    selectedCity.value = '';
    selectedState.value = '';
    selectedEvents.value = '';
    searchController.clear();
    searchQuery.value = '';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
