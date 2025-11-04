import 'package:cloud_firestore/cloud_firestore.dart';

import './resaturant_model.dart';

class RestaurantOwnerModel {
  final String docID;
  final String contact;
  final String email;
  final String img;
  final String password;
  final RestaurantModel restaurantData;

  RestaurantOwnerModel({
    required this.docID,
    required this.contact,
    required this.email,
    required this.img,
    required this.password,
    required this.restaurantData,
  });

  factory RestaurantOwnerModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() as Map<String, dynamic>;

    return RestaurantOwnerModel(
      docID: doc.id,
      contact: data['contact'] ?? '',
      email: data['email'] ?? '',
      img: data['img'] ?? '',
      password: data['password'] ?? '',
      restaurantData: RestaurantModel.fromMap(data['restaurantData'] ?? {}),
    );
  }

  factory RestaurantOwnerModel.fromMap(Map<String, dynamic> data) {
    return RestaurantOwnerModel(
      docID: data['docID'] ?? '',
      contact: data['contact'] ?? '',
      email: data['email'] ?? '',
      img: data['img'] ?? '',
      password: data['password'] ?? '',
      restaurantData: RestaurantModel.fromMap(data['restaurantData'] ?? {}),
    );
  }

  Future<Map<String, dynamic>> toMap() async {
    return {
      'docID': docID,
      'contact': contact,
      'email': email,
      'img': img,
      'password': password,
      'restaurantData': await restaurantData.toMap(),
    };
  }
}

