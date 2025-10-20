import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/main.dart';
import '../widgets/global_functions.dart';

class RestaurantModel {
  String docID;
  TextEditingController resName;
  TextEditingController resEmail;
  TextEditingController specialConditions;
  TextEditingController socialLink;
  TextEditingController password;
  TextEditingController city;
  TextEditingController address;
  TextEditingController zipCode;
  TextEditingController phoneNumber;
  TextEditingController about;
  TextEditingController country;
  DateTime createdAt;
  RxString logoImage;
  Rx<Uint8List> logoImageMemory;
  RxList<String> facilityList;
  RxList<String> dietaryList;
  RxList<String> atmopshereList;
  RxString spokenLanguage;
  RxString socialMedia;
  RxString priceRange;
  double latitude;
  double longitude;
  List<RxString> resImages;
  RxList<Uint8List> resImageMemory;
  List<EntertainmentScheduleModel> entertainmentScheduleList;

  //constructor
  RestaurantModel({
    required this.facilityList,
    required this.phoneNumber,
    required this.entertainmentScheduleList,
    required this.city,
    required this.createdAt,
    required this.longitude,
    required this.about,
    required this.latitude,
    required this.resName,
    required this.docID,
    required this.resEmail,
    required this.dietaryList,
    required this.specialConditions,
    required this.socialLink,
    required this.password,
    required this.address,
    required this.socialMedia,
    required this.priceRange,
    required this.country,
    required this.atmopshereList,
    required this.zipCode,
    required this.logoImage,
    required this.logoImageMemory,
    required this.resImageMemory,
    required this.resImages,
    required this.spokenLanguage,
  });

// Initialize the model with default values

  static RestaurantModel initialize() {
    DateTime now = DateTime.now();
    DateTime createdAt = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    return RestaurantModel(
      resName: TextEditingController(),
      socialLink: TextEditingController(),
      resEmail: TextEditingController(),
      city: TextEditingController(),
      country: TextEditingController(),
      address: TextEditingController(),
      phoneNumber: TextEditingController(),
      about: TextEditingController(),
      createdAt: createdAt,
      logoImage: ''.obs,
      docID: auth.currentUser!.uid,
      logoImageMemory: Uint8List(0).obs,
      facilityList: <String>[].obs,
      dietaryList: <String>[].obs,
      atmopshereList: <String>[].obs,
      specialConditions: TextEditingController(),
      password: TextEditingController(),
      spokenLanguage: ''.obs,
      latitude: 0.0,
      longitude: 0.0,
      socialMedia: 'Tiktok'.obs,
      priceRange: ''.obs,
      zipCode: TextEditingController(),
      entertainmentScheduleList: [],
      resImages: [],
      resImageMemory: RxList<Uint8List>(),
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

    List<String> imageUrls = [];
    for (var image in resImages) {
      imageUrls.add(image.value);
    }
    for (int i = 0; i < resImageMemory.length; i++) {
      print('adding media in listing');
      String uploadedUrl =
          await uploadImageToFirebase('listings', resImageMemory[i]);
      imageUrls.add(uploadedUrl);
    }

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
      'resImages': imageUrls,
      'createdAt': createdAt,
      'resName': resName.text,
      'phoneNumber': phoneNumber.text,
      'country': country.text,
      'about': about.text,
      'docID': docID,
      'facilityList': facilityList,
      'dietaryList': dietaryList,
      'atmopshereList': atmopshereList,
      'resEmail': resEmail.text,
      'socialLink': socialLink.text,
      'address': address.text,
      'zipCode': zipCode.text,
      'city': city.text,
      'logoImage': logoImage.value,
      'specialConditions': specialConditions.text,
      'password': password.text, // Add password field
      'spokenLanguage': spokenLanguage.value,
      'entertainmentScheduleList': data,
      'latitude': latitude,
      'longitude': longitude,
      'socialMedia': socialMedia.value,
      'priceRange': priceRange.value,
    };
  }

// Create a model instance from a DocumentSnapshot
  static RestaurantModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? {}; // Ensure data is not null
    ///images
//     List<String> images = List<String>.from(snapshot.data()!['resImages']);

    List<String> images = List<String>.from(data['resImages'] ?? []);
    List<RxString> resImages = [];

    for (String image in images) {
      resImages.add(RxString(image));
    }
    return RestaurantModel(
        resName: TextEditingController(
          text: data['resName'] ?? '',
        ),
        country: TextEditingController(
          text: data['country'] ?? '',
        ),
        zipCode: TextEditingController(
          text: data['zipCode'] ?? '',
        ),
        about: TextEditingController(
          text: data['about'] ?? '',
        ),
        phoneNumber: TextEditingController(
          text: data['phoneNumber'] ?? '',
        ),
        city: TextEditingController(
          text: data['city'] ?? '',
        ),
        resEmail: TextEditingController(
          text: data['resEmail'] ?? '',
        ),
        socialLink: TextEditingController(
          text: data['socialLink'] ?? '',
        ),
        address: TextEditingController(
          text: data['address'] ?? '',
        ),
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        latitude: snapshot.data()!['latitude'] ?? 33.602018,
        longitude: snapshot.data()!['longitude'] ?? 33.602018,
        facilityList: RxList<String>.from(
            (data['facilityList'] as List<dynamic>? ?? [])
                .map((e) => e.toString())),
        atmopshereList: RxList<String>.from(
            (data['atmopshereList'] as List<dynamic>? ?? [])
                .map((e) => e.toString())),
        dietaryList: RxList<String>.from(
            (data['dietaryList'] as List<dynamic>? ?? [])
                .map((e) => e.toString())),
        specialConditions:
            TextEditingController(text: data['specialConditions'] ?? ''),
        password: TextEditingController(text: data['password'] ?? ''),
        spokenLanguage: RxString(data['spokenLanguage'] ?? 'English'),
        socialMedia: RxString(data['socialMedia'] ?? ''),
        priceRange: RxString(data['priceRange'] ?? ''),
        docID: data['docID'] ?? '',
        logoImage: RxString(data['logoImage'] ?? ''),
        logoImageMemory: Uint8List(0).obs,
        entertainmentScheduleList: RxList<EntertainmentScheduleModel>.from(
          (data['entertainmentScheduleList'] as List<dynamic>? ?? [])
              .map((e) => EntertainmentScheduleModel.fromMap(e)),
        ),
        resImageMemory: RxList<Uint8List>(),
        resImages: resImages);
  }

  // Create a model instance from a Map
  static RestaurantModel fromMap(Map<String, dynamic> data) {
    List<String> images = List<String>.from(data['resImages'] ?? []);
    List<RxString> resImages = [];

    for (String image in images) {
      resImages.add(RxString(image));
    }

    return RestaurantModel(
        resName: TextEditingController(
          text: data['resName'] ?? '',
        ),
        country: TextEditingController(
          text: data['country'] ?? '',
        ),
        zipCode: TextEditingController(
          text: data['zipCode'] ?? '',
        ),
        about: TextEditingController(
          text: data['about'] ?? '',
        ),
        phoneNumber: TextEditingController(
          text: data['phoneNumber'] ?? '',
        ),
        city: TextEditingController(
          text: data['city'] ?? '',
        ),
        resEmail: TextEditingController(
          text: data['resEmail'] ?? '',
        ),
        socialLink: TextEditingController(
          text: data['socialLink'] ?? '',
        ),
        address: TextEditingController(
          text: data['address'] ?? '',
        ),
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        latitude: (data['latitude'] ?? 33.602018).toDouble(),
        longitude: (data['longitude'] ?? 33.602018).toDouble(),
        facilityList: RxList<String>.from(
            (data['facilityList'] as List<dynamic>? ?? [])
                .map((e) => e.toString())),
        atmopshereList: RxList<String>.from(
            (data['atmopshereList'] as List<dynamic>? ?? [])
                .map((e) => e.toString())),
        dietaryList: RxList<String>.from(
            (data['dietaryList'] as List<dynamic>? ?? [])
                .map((e) => e.toString())),
        specialConditions:
            TextEditingController(text: data['specialConditions'] ?? ''),
        password: TextEditingController(text: data['password'] ?? ''),
        spokenLanguage: RxString(data['spokenLanguage'] ?? 'English'),
        socialMedia: RxString(data['socialMedia'] ?? ''),
        priceRange: RxString(data['priceRange'] ?? ''),
        docID: data['docID'] ?? '',
        logoImage: RxString(data['logoImage'] ?? ''),
        logoImageMemory: Uint8List(0).obs,
        entertainmentScheduleList: RxList<EntertainmentScheduleModel>.from(
          (data['entertainmentScheduleList'] as List<dynamic>? ?? [])
              .map((e) => EntertainmentScheduleModel.fromMap(e)),
        ),
        resImageMemory: RxList<Uint8List>(),
        resImages: resImages);
  }
}

class EntertainmentScheduleModel {
  TextEditingController eventName;
  TextEditingController eventBy;
  String startTime;
  String endTime;
  String day;
  String date;
  bool isSelected;

  // Constructor
  EntertainmentScheduleModel({
    required this.eventName,
    required this.eventBy,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.day,
    required this.isSelected,
  });

  static EntertainmentScheduleModel initialize() {
    return EntertainmentScheduleModel(
        date: '',
        isSelected: false,
        startTime: '',
        endTime: '',
        day: '',
        eventName: TextEditingController(),
        eventBy: TextEditingController());
  }

  // Convert to Map for Firestore
  Future<Map<String, dynamic>> toMap() async {
    return {
      'eventName': eventName.text,
      'eventBy': eventBy.text,
      'startTime': startTime,
      'endTime': endTime,
      'day': day,
      'date': date,
      'isSelected': isSelected,
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
      date: data['date'],
      isSelected: data['isSelected'],
      eventBy: TextEditingController(
        text: data['eventBy'],
      ),
    );
  }
}

/// Model for a single time slot (e.g., Breakfast, Lunch, Dinner)
class TimeSlot {
  final String? startTime;
  final String? endTime;
  final bool isClosed;

  TimeSlot({
    this.startTime,
    this.endTime,
    required this.isClosed,
  });

  /// Converts Firestore document to TimeSlot model
  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      startTime: map['startTime'] as String?,
      endTime: map['endTime'] as String?,
      isClosed: map['isClosed'] as bool,
    );
  }

  /// Converts TimeSlot model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'isClosed': isClosed,
    };
  }
}

/// Model for a single day's operating hours
class OperatingHours {
  final Map<String, TimeSlot> timeSlots; // Key: Breakfast, Lunch, Dinner

  OperatingHours({required this.timeSlots});

  /// Converts Firestore document to OperatingHours model
  factory OperatingHours.fromMap(Map<String, dynamic> map) {
    Map<String, TimeSlot> slots = {};
    map.forEach((key, value) {
      slots[key] = TimeSlot.fromMap(value as Map<String, dynamic>);
    });
    return OperatingHours(timeSlots: slots);
  }

  /// Converts OperatingHours model to Firestore document
  Map<String, dynamic> toMap() {
    return timeSlots.map((key, value) => MapEntry(key, value.toMap()));
  }
}
