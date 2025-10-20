import 'dart:typed_data';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;
import 'dart:async';

import '../main.dart';
import '../models/claim_model.dart';

Future<void> getCurrentUserData() async {
  print('Getting user data...');

  if (auth.currentUser != null) {
    DocumentSnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection('restaurantOwner')
        .doc(auth.currentUser!.uid.toString())
        .get();

    if (value.exists && value.data()!.isNotEmpty) {
      // ✅ Correct way to update observable
      currentRestaurantOwner.value = RestaurantClaimsModel.fromFirestore(value);

      // ✅ If currentRestaurant is also observable, update it correctly
      // currentRestaurant = value;

      print('User data found ✅');
    } else {
      print('User data not found, deleting user...');
      await auth.currentUser!.delete();
    }
  }
}


///upload image to firebaseStorage
Future<String> uploadImageToFirebase(
    String refPath, Uint8List imagePath) async {
  print('hjdvvh');
  String url = '';

  String id = auth.currentUser != null
      ? "${DateTime.now().millisecondsSinceEpoch}${auth.currentUser!.uid.toString()}"
      : '${DateTime.now().millisecondsSinceEpoch}';
  print('id +$id');
//reference for storage
  final ref = FirebaseStorage.instance.ref(refPath).child(id);
  print(ref);
  print(imagePath.length);
//put file
  final uploadTask = await ref.putData(imagePath);
  print(uploadTask);
  url = await uploadTask.ref.getDownloadURL();
  print(url);
  return url;
}

String mediaType = '';

Future<Uint8List?> getImage() async {
  var mediaData = await ImagePickerWeb.getImageInfo;
  String? mimeType = mime(Path.basename(mediaData!.fileName!));
  File mediaFile =
      File(mediaData.data!, mediaData.fileName!, {'type': mimeType});

  if (mediaFile.name.isNotEmpty) {
    mediaType = 'image';
    return mediaData.data!;
  }
  return null;
}

Future<List<Uint8List>> getImages() async {
  List<Uint8List> images = [];

  try {
    // Pick multiple images as Uint8List
    List<Uint8List>? mediaData = await ImagePickerWeb.getMultiImagesAsBytes();

    if (mediaData != null) {
      images.addAll(mediaData);
    }
  } catch (e) {
    print('Error picking images: $e');
  }
  print(images);

  return images; // Return the list of selected images
}

String formatDate(String date) {
  try {
    DateTime parsedDate = DateFormat('dd/MM/yy').parse(date);
    return DateFormat('dd.MM.yyyy').format(parsedDate);
  } catch (e) {
    return date; // Return original if parsing fails
  }
}
// Utility function to parse time string into TimeOfDay
// Utility function to parse time string into TimeOfDay
TimeOfDay? parseTime(String timeStr) {
  try {
    if (timeStr.isEmpty) return null;

    // Print time for debugging
    print("Original Time String: '$timeStr'");

    // Normalize spaces and remove non-breaking spaces
    timeStr = timeStr.replaceAll(RegExp(r'[\u00A0\u202F\u2007\u2060]'), ' ').trim();

    // Print cleaned time string for debugging
    print("Cleaned Time String: '$timeStr'");

    // Split the time into time and AM/PM parts
    final timeParts = timeStr.split(' ');

    if (timeParts.length != 2) {
      print("Error: Invalid time format.");
      return null;
    }

    final time = timeParts[0]; // e.g., '1:23'
    final period = timeParts[1]; // e.g., 'PM'

    final timeSplit = time.split(':');
    if (timeSplit.length != 2) {
      print("Error: Invalid time format.");
      return null;
    }

    final hour = int.parse(timeSplit[0]);
    final minute = int.parse(timeSplit[1]);

    // Convert 12-hour format to 24-hour format based on AM/PM
    int adjustedHour = hour;
    if (period == 'PM' && hour != 12) {
      adjustedHour += 12;
    } else if (period == 'AM' && hour == 12) {
      adjustedHour = 0; // Handle midnight (12 AM)
    }

    // Return the TimeOfDay object
    return TimeOfDay(hour: adjustedHour, minute: minute);

  } catch (e) {
    print("Error parsing time: $e (Time String: '$timeStr')");
    return null;
  }
}


var mapControllerr= Completer<GoogleMapController>();
var latitude = 37.42796133580664.obs;
var longitude = 122.085749655962.obs;
Future<void> getCurrentLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  latitude.value = position.latitude;
  longitude.value = position.longitude;

  final GoogleMapController controller = await mapControllerr.future;
  controller.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(target: LatLng(latitude.value, longitude.value), zoom: 14),
  ));
}
