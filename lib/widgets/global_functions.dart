import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/app_colors.dart';

///upload image to firebaseStorage
Future<String> uploadImageToFirebase(
    String refPath, Uint8List imagePath) async {
  var auth = FirebaseAuth.instance;

  String url = '';

  String id = auth.currentUser != null
      ? "${DateTime.now().millisecondsSinceEpoch}${auth.currentUser!.uid.toString()}"
      : '${DateTime.now().millisecondsSinceEpoch}';
  print('id +$id');
//reference for storage
  final ref = FirebaseStorage.instance.ref(refPath).child(id);
//put file
  final uploadTask = await ref.putData(imagePath);
  url = await uploadTask.ref.getDownloadURL();
  print(url);
  return url;
}

loadingDialog() {
  Get.dialog(
    const Center(
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    ),
    barrierDismissible: false,
  );
}


  Future<List<String>> uploadImagesToFirebase(List<Uint8List> images) async {
    List<String> imageUrls = [];
    List<Uint8List> imagesCopy = List.from(images); // 🔥 Fix: Create a copy

    for (var image in imagesCopy) {
      try {
        String imageUrl = await uploadImageToFirebase("items", image);
        imageUrls.add(imageUrl); // Convert String to RxString
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    return imageUrls;
  }

  