import 'package:cloud_firestore/cloud_firestore.dart';

import 'functions.dart';

CollectionReference<Map<String, dynamic>> getRestaurantOperatingHours(
    String restId) {
  DateTime dt = DateTime.now();
  String weekDay = '';

  switch (dt.weekday) {
    case 1:
      weekDay = 'Monday';
      break;
    case 2:
      weekDay = 'Tuesday';
      break;
    case 3:
      weekDay = 'Wednesday';
      break;
    case 4:
      weekDay = 'Thursday';
      break;
    case 5:
      weekDay = 'Friday';
      break;
    case 6:
      weekDay = 'Saturday';
      break;
    case 7:
      weekDay = 'Sunday';
      break;
    default:
      weekDay = '';
      break;
  }

  return FirebaseFirestore.instance
      .collection('restaurants')
      .doc(restId)
      .collection('operatingHours');
  /*.doc(weekDay)*/;
}

DocumentReference<Map<String, dynamic>> getRestaurantOperatingHoursForToday(
    String restId) {
  DateTime dt = DateTime.now();
  String weekDay = '';

  switch (dt.weekday) {
    case 1:
      weekDay = 'Monday';
      break;
    case 2:
      weekDay = 'Tuesday';
      break;
    case 3:
      weekDay = 'Wednesday';
      break;
    case 4:
      weekDay = 'Thursday';
      break;
    case 5:
      weekDay = 'Friday';
      break;
    case 6:
      weekDay = 'Saturday';
      break;
    case 7:
      weekDay = 'Sunday';
      break;
    default:
      weekDay = '';
      break;
  }

  return FirebaseFirestore.instance
      .collection('restaurants')
      .doc(restId)
      .collection('operatingHours')
      .doc(weekDay);
}

Query<Map<String, dynamic>> getEventsNext30Days(List<String> eventTypes) {
  Query<Map<String, dynamic>> query =
      FirebaseFirestore.instance.collection('events');

  // Apply date range filter if documents have date field
  query = query
      .where('date',
          isGreaterThanOrEqualTo: getDate31DaysBeforeNow()) // getTodayDate()
      .where('date', isLessThanOrEqualTo: getDate31DaysFromNow());

  // Apply eventType filter if the list is not empty
  if (eventTypes.isNotEmpty) {
    query = query.where('eventType', whereIn: eventTypes);
  }

  return query;
}

// Get all events for the current year
Query<Map<String, dynamic>> getEventsForYear(List<String> eventTypes) {
  Query<Map<String, dynamic>> query =
      FirebaseFirestore.instance.collection('events');

  // Get start and end of current year
  DateTime now = DateTime.now();
  String yearStart = '${now.year}-01-01';
  String yearEnd = '${now.year}-12-31';

  // Apply date range filter for the entire year
  query = query
      .where('date', isGreaterThanOrEqualTo: yearStart)
      .where('date', isLessThanOrEqualTo: yearEnd);

  // Apply eventType filter if the list is not empty
  if (eventTypes.isNotEmpty) {
    query = query.where('eventType', whereIn: eventTypes);
  }

  return query;
}
