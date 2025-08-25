import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

Future<Position> getCurrentLocation(BuildContext context) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are disabled.');
    return Future.error('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied.');
      return Future.error('Location permissions are denied.');
    }
    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return Future.error('Location permissions are permanently denied.');
    }
  }

  return await Geolocator.getCurrentPosition();
}

// Get today's date in yyyy-MM-dd format
String getTodayDate() {
return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

// Get date 31 days from today in yyyy-MM-dd format
String getDate31DaysFromNow() {
return DateFormat('yyyy-MM-dd')
    .format(DateTime.now().add(Duration(days: 30)));
}

// Get date 31 days before today in yyyy-MM-dd format
String getDate31DaysBeforeNow() {
  return DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(Duration(days: 30)));
}