import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../main.dart';

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
