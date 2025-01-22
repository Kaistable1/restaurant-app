import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/global_functions.dart';

class RestaurantModel {
  TextEditingController resName;
  TextEditingController resEmail;
  TextEditingController specialConditions;
  TextEditingController socialLink;
  TextEditingController password;
  TextEditingController city;
  TextEditingController address;
  TextEditingController zipCode;
  RxString logoImage;
  Rx<Uint8List> logoImageMemory;
  RxList<String> facilityList;
  RxList<String> dietaryList;
  RxList<String> atmopshereList;
  RxString spokenLanguage;
  RxString socialMedia;
  double latitude;
  double longitude;
  List<EntertainmentScheduleModel> entertainmentScheduleList;
  List<OperatingHoursModel> operatingHours;

  //constructor
  RestaurantModel({
    required this.facilityList,
    required this.entertainmentScheduleList,
    required this.operatingHours,
    required this.city,
    required this.longitude,
    required this.latitude,
    required this.resName,
    required this.resEmail,
    required this.dietaryList,
    required this.specialConditions,
    required this.socialLink,
    required this.password,
    required this.address,
    required this.socialMedia,
    required this.atmopshereList,
    required this.zipCode,
    required this.logoImage,
    required this.logoImageMemory,
    required this.spokenLanguage,
  });

// Initialize the model with default values

  static RestaurantModel initialize() {
    return RestaurantModel(
      resName: TextEditingController(),
      socialLink: TextEditingController(),
      resEmail: TextEditingController(),
      city: TextEditingController(),
      address: TextEditingController(),
      logoImage: ''.obs,
      logoImageMemory: Uint8List(0).obs,
      facilityList: <String>[].obs,
      dietaryList: <String>[].obs,
      atmopshereList: <String>[].obs,
      specialConditions: TextEditingController(),
      password: TextEditingController(),
      spokenLanguage: ''.obs,
      latitude: 0.0,
      longitude: 0.0,
      socialMedia: 'POUND'.obs,
      zipCode: TextEditingController(),
      entertainmentScheduleList: [],
      operatingHours: [],
    );
  }

// Convert the model instance to a map for storing in Firestore
  Future<Map<String, dynamic>> toMap() async {
    logoImage.value =
        logoImage.value.contains('https://firebasestorage.googleapis.com/') &&
                logoImageMemory.value.isEmpty
            ? logoImage.value
            : logoImageMemory.value.isNotEmpty
                ? await uploadImageToFirebase('logo', logoImageMemory.value)
                : '';
    List<Map<String, dynamic>> data = [];
    for (var element in entertainmentScheduleList) {
      var d = await element.toMap();
      data.add(d);
    }
    List<Map<String, dynamic>> dataHours = [];
    for (var element in entertainmentScheduleList) {
      var d = await element.toMap();
      dataHours.add(d);
    }
    return {
      'resName': resName.text,
      'facilityList': facilityList,
      'dietaryList': dietaryList,
      'atmopshereList': atmopshereList,
      'resEmail': resEmail.text,
      'socialLink': socialLink.text,
      'address': address.text,
      'city': city.text,
      'logoImage': logoImage.value,
      'logoImageMemory': Uint8List(0),
      'specialConditions': specialConditions.text,
      'password': password.text, // Add password field
      'spokenLanguage': spokenLanguage.value,
      'entertainmentScheduleList': data,
      'operatingHours': dataHours,
      'latitude': latitude,
      'longitude': longitude,
      'socialMedia': socialMedia.value,
    };
  }

// Create a model instance from a DocumentSnapshot
  static RestaurantModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    // print('Entire snapshot data: ${snapshot.data()}');
    // print('Value of warning: ${snapshot.data()!['warning']}');

    // Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return RestaurantModel(
        resName: TextEditingController(
          text: snapshot.data()!['resName'],
        ),
        zipCode: TextEditingController(
          text: snapshot.data()!['zipCode'],
        ),
        city: TextEditingController(
          text: snapshot.data()!['city'],
        ),
        resEmail: TextEditingController(
          text: snapshot.data()!['resEmail'],
        ),
        socialLink: TextEditingController(
          text: snapshot.data()!['socialLink'],
        ),
        address: TextEditingController(
          text: snapshot.data()!['address'],
        ),
        latitude: snapshot.data()!['latitude'] ?? 33.602018,
        longitude: snapshot.data()!['longitude'] ?? 33.602018,
        facilityList: RxList<String>.from(
            snapshot.data()!['facilityList'].map((e) => e.toString())),
        atmopshereList: RxList<String>.from(
            snapshot.data()!['atmopshereList'].map((e) => e.toString())),
        dietaryList: RxList<String>.from(
            snapshot.data()!['dietaryList'].map((e) => e.toString())),
        specialConditions:
            TextEditingController(text: snapshot.data()!['specialConditions']),
        password: TextEditingController(text: snapshot.data()!['password']),
        spokenLanguage: RxString(snapshot.data()!['spokenLanguage'] == ''
            ? 'MALE'
            : snapshot.data()!['spokenLanguage']),
        socialMedia: RxString(snapshot.data()!['socialMedia']),
        logoImage: RxString(
          snapshot.data()!['logoImage'],
        ),
        logoImageMemory: Uint8List(0).obs,
        entertainmentScheduleList: RxList<EntertainmentScheduleModel>.from(
          (snapshot.data()!['entertainmentScheduleList'] as List<dynamic>? ??
                  [])
              .map((e) =>
                  EntertainmentScheduleModel.fromMap(e as Map<String, dynamic>))
              .toList(),
        ),
        operatingHours: RxList<OperatingHoursModel>.from((snapshot
                    .data()!['operatingHours'] as List<dynamic>? ??
                [])
            .map((e) => OperatingHoursModel.fromMap(e as Map<String, dynamic>))
            .toList()));
  }
}

class EntertainmentScheduleModel {
  TextEditingController eventName;
  TextEditingController eventBy;
  String startTime;
  String endTime;
  String day;

  // Constructor
  EntertainmentScheduleModel({
    required this.eventName,
    required this.eventBy,
    required this.startTime,
    required this.endTime,
    required this.day,
  });

  // Convert to Map for Firestore
  Future<Map<String, dynamic>> toMap() async {
    return {
      'eventName': eventName.text,
      'eventBy': eventBy.text,
      'startTime': startTime,
      'endTime': endTime,
      'day': day,
    };
  }

  // Create an instance from Firestore data
  static EntertainmentScheduleModel fromMap(Map<String, dynamic> data) {
    return EntertainmentScheduleModel(
      eventName: TextEditingController(
        text: data['eventName'],
      ),
      startTime: data['startTime'],
      endTime: data['endTime'],
      day: data['day'],
      eventBy: TextEditingController(
        text: data['eventBy'],
      ),
    );
  }
}

class OperatingHoursModel {
  TextEditingController eventName;
  TextEditingController eventBy;
  String startTime;
  String endTime;
  String day;
  List<OperatingHoursModel> days;


  // Constructor
  OperatingHoursModel({
    required this.eventName,
    required this.days,
    required this.eventBy,
    required this.startTime,
    required this.endTime,
    required this.day,
  });

  // Convert to Map for Firestore
  Future<Map<String, dynamic>> toMap() async {
    return {
      'eventName': eventName.text,
      'eventBy': eventBy.text,
      'startTime': startTime,
      'endTime': endTime,
      'day': day,
    };
  }

  // Create an instance from Firestore data
  static OperatingHoursModel fromMap(Map<String, dynamic> data) {


    return OperatingHoursModel(
      eventName: TextEditingController(
        text: data['eventName'],
      ),
        eventBy: TextEditingController(
          text: data['eventBy'],
        ),
      startTime: data['startTime'],
      endTime: data['endTime'],
      day: data['day'],
      days: RxList<OperatingHoursModel>.from(
        (data['days'] as List<dynamic>? ?? [])
            .map((e) => OperatingHoursModel.fromMap(e as Map<String, dynamic>))
            .toList(),

    ));
  }
}
class DaysModel {
  TextEditingController eventName;
  TextEditingController eventBy;
  String startTime;
  String endTime;
  String day;
  List<OperatingHoursModel> days;


  // Constructor
  DaysModel({
    required this.eventName,
    required this.days,
    required this.eventBy,
    required this.startTime,
    required this.endTime,
    required this.day,
  });

  // Convert to Map for Firestore
  Future<Map<String, dynamic>> toMap() async {
    return {
      'eventName': eventName.text,
      'eventBy': eventBy.text,
      'startTime': startTime,
      'endTime': endTime,
      'day': day,
    };
  }

  // Create an instance from Firestore data
  static DaysModel fromMap(Map<String, dynamic> data) {


    return DaysModel(
      eventName: TextEditingController(
        text: data['eventName'],
      ),
        eventBy: TextEditingController(
          text: data['eventBy'],
        ),
      startTime: data['startTime'],
      endTime: data['endTime'],
      day: data['day'],
      days: RxList<OperatingHoursModel>.from(
        (data['days'] as List<dynamic>? ?? [])
            .map((e) => OperatingHoursModel.fromMap(e as Map<String, dynamic>))
            .toList(),

    ));
  }
}
