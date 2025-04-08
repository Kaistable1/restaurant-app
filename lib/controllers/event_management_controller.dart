import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/events_model.dart';

class EventManagementController extends GetxController{
  final searchController = TextEditingController();
  RxString selectedCity = ''.obs;
  RxString selectedState = ''.obs;
  RxString selectedEvents = ''.obs;
  RxList<String> cityList =
      <String>['Tuscany, Italy', 'San Francisco', 'Washington, D.C.', ].obs;

  RxList<String> stateList =
      <String>['New York', 'Loss Angelos',].obs;
  RxList<String> eventsList =
      <String>['Festival', 'Concert',].obs;



  var restaurants =
      <EventsModel>[
        EventsModel(
          id: 1,
          eventsName: 'Tandoori Flame',
          eventType: 'Concert',
          location: 'Tuscany, Italy',
          date: 'Martch 5,2024',
          status: 'Pending',
          time: '10: 00 AM',
          photoUrl: 'assets/images/res_table_1.png',

        ),
        EventsModel(
          id: 1,
          eventsName: 'Tandoori Flame',
          eventType: 'Concert',
          location: 'Tuscany, Italy',
          date: 'Martch 5,2024',
          status: 'Pending',
          time: '10: 00 AM',
          photoUrl: 'assets/images/res_table_2.png',
        ),
        EventsModel(
          id: 1,
          eventsName: 'Tandoori Flame',
          eventType: 'Concert',
          location: 'Tuscany, Italy',
          date: 'Martch 5,2024',
          status: 'Published',
          time: '10: 00 AM',
          photoUrl: 'assets/images/res_table_3.png',
        ),
        EventsModel(
          id: 1,
          eventsName: 'Tandoori Flame',
          eventType: 'Concert',
          location: 'Tuscany, Italy',
          date: 'Martch 5,2024',
          status: 'Pending',
          time: '10: 00 AM',
          photoUrl: 'assets/images/res_table_4.png',
        ),
        EventsModel(
          id: 1,
          eventsName: 'Tandoori Flame',
          eventType: 'Concert',
          location: 'Tuscany, Italy',
          date: 'Martch 5,2024',
          status: 'Published',
          time: '10: 00 AM',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        EventsModel(
          id: 1,
          eventsName: 'Tandoori Flame',
          eventType: 'Concert',
          location: 'Tuscany, Italy',
          date: 'Martch 5,2024',
          status: 'Pending',
          time: '10: 00 AM',
          photoUrl: 'assets/images/res_table_3.png',
        ),
        EventsModel(
          id: 1,
          eventsName: 'Tandoori Flame',
          eventType: 'Concert',
          location: 'Tuscany, Italy',
          date: 'Martch 5,2024',
          status: 'Published',
          time: '10: 00 AM',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        EventsModel(
          id: 1,
          eventsName: 'Tandoori Flame',
          eventType: 'Concert',
          location: 'Tuscany, Italy',
          date: 'Martch 5,2024',
          status: 'Pending',
          time: '10: 00 AM',
          photoUrl: 'assets/images/res_table_4.png',
        ),
        EventsModel(
          id: 1,
          eventsName: 'Tandoori Flame',
          eventType: 'Concert',
          location: 'Tuscany, Italy',
          date: 'Martch 5,2024',
          status: 'Published',
          time: '10: 00 AM',
          photoUrl: 'assets/images/res_table_1.png',
        ),
        EventsModel(
          id: 1,
          eventsName: 'Tandoori Flame',
          eventType: 'Concert',
          location: 'Tuscany, Italy',
          date: 'Martch 5,2024',
          status: 'Pending',
          time: '10: 00 AM',
          photoUrl: 'assets/images/res_table_4.png',
        ),
        EventsModel(
          id: 1,
          eventsName: 'Tandoori Flame',
          eventType: 'Concert',
          location: 'Tuscany, Italy',
          date: 'Martch 5,2024',
          status: 'Pending',
          time: '10: 00 AM',
          photoUrl: 'assets/images/res_table_3.png',
        ),
        EventsModel(
          id: 1,
          eventsName: 'Tandoori Flame',
          eventType: 'Concert',
          location: 'Tuscany, Italy',
          date: 'Martch 5,2024',
          status: 'Pending',
          time: '10: 00 AM',
          photoUrl: 'assets/images/res_table_2.png',
        ),
        EventsModel(
          id: 1,
          eventsName: 'Tandoori Flame',
          eventType: 'Concert',
          location: 'Tuscany, Italy',
          date: 'Martch 5,2024',
          status: 'Pending',
          time: '10: 00 AM',
          photoUrl: 'assets/images/res_table_4.png',
        ),
        EventsModel(
          id: 1,
          eventsName: 'Tandoori Flame',
          eventType: 'Concert',
          location: 'Tuscany, Italy',
          date: 'Martch 5,2024',
          status: 'Pending',
          time: '10: 00 AM',
          photoUrl: 'assets/images/res_table_3.png',
        ),
        // Add more restaurants...
      ].obs;

  void deleteRestaurant(int index) {
    restaurants.removeAt(index);
  }











}