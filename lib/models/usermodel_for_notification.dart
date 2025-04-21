import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // Fields
  TextEditingController userEmail;
  TextEditingController password;
  TextEditingController username;
  TextEditingController confirmpass;
  String? token;
  String userID;
  RxString userImage;
  List<String> topThreeCuisines;
  List<String> dietaryPrefList;
  List<String> whereToEat;
  List<String> impDiningOut;
  List<String> diningExp;
  List<String> willingToTravel;
  List<String> notificationType;
  String planner;
  String notifiedDiningOpp;

  // Constructor
  UserModel({
    required this.userEmail,
    required this.password,
    required this.username,
    required this.confirmpass,
    this.token,
    required this.userID,
    required this.userImage,
    this.topThreeCuisines = const [],
    this.dietaryPrefList = const [],
    this.whereToEat = const [],
    this.impDiningOut = const [],
    this.diningExp = const [],
    this.willingToTravel = const [],
    this.notificationType = const [],
    this.planner = '',
    this.notifiedDiningOpp = '',
  });

  // Factory method to initialize with default values
  static UserModel initialize() {
    return UserModel(
      userEmail: TextEditingController(),
      password: TextEditingController(),
      username: TextEditingController(),
      confirmpass: TextEditingController(),
      userID: '',
      userImage: ''.obs,
    );
  }

  // Convert the model to a map (useful for storing in Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail.text,
      'password': password.text,
      'username': username.text,
      'confirmpass': confirmpass.text,
      'token': token,
      'userID': userID,
      'userImage': userImage.value,
      'topThreeCuisines': topThreeCuisines,
      'dietaryPrefList': dietaryPrefList,
      'whereToEat': whereToEat,
      'impDiningOut': impDiningOut,
      'diningExp': diningExp,
      'willingToTravel': willingToTravel,
      'notificationType': notificationType,
      'planner': planner,
      'notifiedDiningOpp': notifiedDiningOpp,
    };
  }

  // Create a model instance from a map (useful for fetching from Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userEmail: TextEditingController(text: map['userEmail'] ?? ''),
      password: TextEditingController(text: map['password'] ?? ''),
      username: TextEditingController(text: map['username'] ?? ''),
      confirmpass: TextEditingController(text: map['confirmpass'] ?? ''),
      token: map['token'],
      userID: map['userID'] ?? '',
      userImage: RxString(map['userImage'] ?? ''),
      topThreeCuisines: List<String>.from(map['topThreeCuisines'] ?? []),
      dietaryPrefList: List<String>.from(map['dietaryPrefList'] ?? []),
      whereToEat: List<String>.from(map['whereToEat'] ?? []),
      impDiningOut: List<String>.from(map['impDiningOut'] ?? []),
      diningExp: List<String>.from(map['diningExp'] ?? []),
      willingToTravel: List<String>.from(map['willingToTravel'] ?? []),
      notificationType: List<String>.from(map['notificationType'] ?? []),
      planner: map['planner'] ?? '',
      notifiedDiningOpp: map['notifiedDiningOpp'] ?? '',
    );
  }

  // Create a model instance from a Firestore DocumentSnapshot
  factory UserModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      userEmail: TextEditingController(text: data['userEmail'] ?? ''),
      password: TextEditingController(text: data['password'] ?? ''),
      username: TextEditingController(text: data['username'] ?? ''),
      confirmpass: TextEditingController(text: data['confirmpass'] ?? ''),
      token: data['token'],
      userID: data['userID'] ?? doc.id,
      userImage: RxString(data['userImage'] ?? ''),
      topThreeCuisines: List<String>.from(data['topThreeCuisines'] ?? []),
      dietaryPrefList: List<String>.from(data['dietaryPrefList'] ?? []),
      whereToEat: List<String>.from(data['whereToEat'] ?? []),
      impDiningOut: List<String>.from(data['impDiningOut'] ?? []),
      diningExp: List<String>.from(data['diningExp'] ?? []),
      willingToTravel: List<String>.from(data['willingToTravel'] ?? []),
      notificationType: List<String>.from(data['notificationType'] ?? []),
      planner: data['planner'] ?? '',
      notifiedDiningOpp: data['notifiedDiningOpp'] ?? '',
    );
  }
}