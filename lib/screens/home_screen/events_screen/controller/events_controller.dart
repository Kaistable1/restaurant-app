import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/events.dart';
import '../../../../models/event_model.dart';

class EventsController extends GetxController {
  RxInt upcomingAppointmentsCheck = 0.obs;
  RxBool isBookmarked = true.obs;

  void toggleBookmark() {
    isBookmarked.value = !isBookmarked.value;
  }

  var eventsList = <EventModel>[
    EventModel(
      image: 'assets/images/tile_img1.png',
      title: 'The Cozy Nook',
      location: 'Abc Location',
      categories: ['Concert', 'Festival'],
    ),
    EventModel(
      image: 'assets/images/tile_img2.png',
      title: 'The Gourmet Bistro',
      location: 'XYZ Arena',
      categories: ['Music', 'Live'],
    ),
    EventModel(
      image: 'assets/images/tile_img3.png',
      title: 'The Art Haven',
      location: 'Central Park',
      categories: ['Festival', 'Food'],
    ),
    EventModel(
      image: 'assets/images/tile_img2.png',
      title: 'The Sports Arena',
      location: 'XYZ Arena',
      categories: ['Music', 'Live'],
    ),
    EventModel(
      image: 'assets/images/tile_img3.png',
      title: 'Food Fest',
      location: 'Central Park',
      categories: ['Festival', 'Food'],
    ),
    EventModel(
      image: 'assets/images/tile_img2.png',
      title: 'Music Night',
      location: 'XYZ Arena',
      categories: ['Music', 'Live'],
    ),
    EventModel(
      image: 'assets/images/tile_img3.png',
      title: 'Flavor Harmony',
      location: 'Central Park',
      categories: ['Festival', 'Food'],
    ),
  ].obs;

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
    print('calling');
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

  // Fetch all events and apply filters client-side
  fetchAllEventsForFilters() async {
    try {
      isLoading.value = true;

      // Fetch events without where clauses to avoid index issues
      Query<Map<String, dynamic>> query = _firestore
          .collection('events')
          .orderBy('createdAt', descending: true);

      // Fetch a large batch
      query = query.limit(pageSize);

      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      List<Event> allEvents = snapshot.docs.map((doc) {
        return Event.fromMap(doc.id, doc.data());
      }).toList();

      // Apply filters client-side
      filteredEvents.value = allEvents;

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
    print('events length ${newEvents.length}');
    events.addAll(newEvents);
  }
}
