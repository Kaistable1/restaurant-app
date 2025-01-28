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
  List<String> topThreeCuisines = [];
  String dietaryPref = '';
  String interestedDeals = '';
  List<String> prefRestSettingList = [];
  List<String> notifyLiveEntertainment = [];
  String notifyDiningOpportunities = '';
  String notifyHappyHour = '';
  String restaurantReviewImp = '';
  String enjoyDiningRestEnter = '';
  String attendingHolidays = '';
  String enjoyDiningActivities = '';
  String favTypeOfLiveMusic = '';
  TextEditingController zipCode;
  String country = '';
  String city = '';

  // Constructor
  UserModel({
    required this.userEmail,
    required this.password,
    required this.username,
    required this.confirmpass,
    this.token,
    required this.userID,
    required this.userImage,
    required this.zipCode,
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
      zipCode: TextEditingController(),
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
      'dietaryPref': dietaryPref,
      'interestedDeals': interestedDeals,
      'prefRestSettingList': prefRestSettingList,
      'notifyLiveEntertainment': notifyLiveEntertainment,
      'notifyDiningOpportunities': notifyDiningOpportunities,
      'notifyHappyHour': notifyHappyHour,
      'restaurantReviewImp': restaurantReviewImp,
      'enjoyDiningRestEnter': enjoyDiningRestEnter,
      'attendingHolidays': attendingHolidays,
      'enjoyDiningActivities': enjoyDiningActivities,
      'favTypeOfLiveMusic': favTypeOfLiveMusic,
      'zipCode': zipCode.text,
      'country': country,
      'city': city,
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
      zipCode: TextEditingController(text: map['zipCode'] ?? ''),
    )
      ..topThreeCuisines = List<String>.from(map['topThreeCuisines'] ?? [])
      ..dietaryPref = map['dietaryPref'] ?? ''
      ..interestedDeals = map['interestedDeals'] ?? ''
      ..prefRestSettingList =
          List<String>.from(map['prefRestSettingList'] ?? [])
      ..notifyLiveEntertainment =
          List<String>.from(map['notifyLiveEntertainment'] ?? [])
      ..notifyDiningOpportunities = map['notifyDiningOpportunities'] ?? ''
      ..notifyHappyHour = map['notifyHappyHour'] ?? ''
      ..restaurantReviewImp = map['restaurantReviewImp'] ?? ''
      ..enjoyDiningRestEnter = map['enjoyDiningRestEnter'] ?? ''
      ..attendingHolidays = map['attendingHolidays'] ?? ''
      ..enjoyDiningActivities = map['enjoyDiningActivities'] ?? ''
      ..favTypeOfLiveMusic = map['favTypeOfLiveMusic'] ?? ''
      ..country = map['country'] ?? ''
      ..city = map['city'] ?? '';
  }

  // Create a model instance from a Firestore DocumentSnapshot
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      userEmail: TextEditingController(text: data['userEmail'] ?? ''),
      password: TextEditingController(text: data['password'] ?? ''),
      username: TextEditingController(text: data['username'] ?? ''),
      confirmpass: TextEditingController(text: data['confirmpass'] ?? ''),
      token: data['token'],
      userID: data['userID'] ?? doc.id, // Fallback to document ID if userID is missing
      userImage: RxString(data['userImage'] ?? ''),
      zipCode: TextEditingController(text: data['zipCode'] ?? ''),
    )
      ..topThreeCuisines = List<String>.from(data['topThreeCuisines'] ?? [])
      ..dietaryPref = data['dietaryPref'] ?? ''
      ..interestedDeals = data['interestedDeals'] ?? ''
      ..prefRestSettingList = List<String>.from(data['prefRestSettingList'] ?? [])
      ..notifyLiveEntertainment = List<String>.from(data['notifyLiveEntertainment'] ?? [])
      ..notifyDiningOpportunities = data['notifyDiningOpportunities'] ?? ''
      ..notifyHappyHour = data['notifyHappyHour'] ?? ''
      ..restaurantReviewImp = data['restaurantReviewImp'] ?? ''
      ..enjoyDiningRestEnter = data['enjoyDiningRestEnter'] ?? ''
      ..attendingHolidays = data['attendingHolidays'] ?? ''
      ..enjoyDiningActivities = data['enjoyDiningActivities'] ?? ''
      ..favTypeOfLiveMusic = data['favTypeOfLiveMusic'] ?? ''
      ..country = data['country'] ?? ''
      ..city = data['city'] ?? '';
  }
}
