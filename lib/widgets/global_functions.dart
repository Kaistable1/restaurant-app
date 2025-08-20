import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/usermodel.dart';
import 'package:shimmer/shimmer.dart';

Future<void> requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
}

Future<void> getCurrentUserData() async {
  if (auth.currentUser != null) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid.toString())
        .get()
        .then((value) async {
      if (value.exists && value.data()!.isNotEmpty) {
        currentUserDataModel = UserModel.fromDocumentSnapshot(value).obs;
      } else {
        auth.currentUser!.delete();
      }
    });
  }
}

Future<String> uploadImageToFirebase(
    String refPath, Uint8List imagePath) async {
  try {
    String url = '';

    String id = auth.currentUser != null
        ? "${DateTime.now().millisecondsSinceEpoch}${auth.currentUser!.uid.toString()}"
        : '${DateTime.now().millisecondsSinceEpoch}';

    final ref = FirebaseStorage.instance.ref(refPath).child(id);
    final uploadTask = await ref.putData(imagePath);

    url = await uploadTask.ref.getDownloadURL();
    print('image url ------------------ $url');
    return url;
  } catch (e) {
    print('image upload error ------------- $e');
    return '';
  }
}

String formatDate(DateTime date) {
  return DateFormat('MMMM d, y').format(date);
}

/// Shimmer effect for GridView placeholder
Widget buildShimmerEffect() {
  return GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisExtent: Get.height * 0.2,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 20,
    ),
    itemCount: 8, // Show 6 shimmer items
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: Get.height * 0.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    },
  );
}
