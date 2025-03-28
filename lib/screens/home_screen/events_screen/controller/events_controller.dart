import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/event_model.dart';

class EventsController extends GetxController{
  RxInt upcomingAppointmentsCheck = 0.obs;
  RxBool isBookmarked=true.obs;
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

}