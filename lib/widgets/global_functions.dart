import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/usermodel.dart';

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
