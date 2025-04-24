import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestaurantModel {
  String resName;
  String docID;
  String resEmail;
  String specialConditions;
  String socialLink;
  String password;
  double averageRating;
  String city;
  String address;
  String zipCode;
  String logoImage;
  List<String> facilityList;
  List<String> imagesList;
  List<String> dietaryList;
  List<String> atmosphereList;
  String spokenLanguage;
  String socialMedia;
  String priceRange;
  double latitude;
  double longitude;
  List<EntertainmentScheduleModel> entertainmentScheduleList;
  List<MenuModel> menuList;
  String about;
  String country;

  // Constructor
  RestaurantModel({
    required this.facilityList,
    required this.docID,
    required this.entertainmentScheduleList,
    required this.menuList,
    required this.city,
    required this.averageRating,
    required this.longitude,
    required this.latitude,
    required this.imagesList,
    required this.resName,
    required this.resEmail,
    required this.dietaryList,
    required this.specialConditions,
    required this.socialLink,
    required this.password,
    required this.address,
    required this.socialMedia,
    required this.priceRange,
    required this.atmosphereList,
    required this.zipCode,
    required this.logoImage,
    required this.spokenLanguage,
    required this.about,
    required this.country,
  });

  // Initialize the model with defaults
  static RestaurantModel initialize() {
    return RestaurantModel(
      resName: '',
      docID: '',
      socialLink: '',
      averageRating: 0.0,
      resEmail: '',
      city: '',
      address: '',
      logoImage: '',
      facilityList: <String>[],
      dietaryList: <String>[],
      atmosphereList: <String>[],
      imagesList: <String>[],
      specialConditions: '',
      password: '',
      spokenLanguage: '',
      latitude: 0.0,
      longitude: 0.0,
      socialMedia: 'Tiktok',
      priceRange: '',
      zipCode: '',
      entertainmentScheduleList: [],
      menuList: [],
      about: '',
      country: '',
    );
  }

  // Convert to Map
  Future<Map<String, dynamic>> toMap() async {
    logoImage = '';
    List<Map<String, dynamic>> data = [];
    List<Map<String, dynamic>> menuData = [];

    for (var element in entertainmentScheduleList) {
      var d = await element.toMap();
      data.add(d);
    }

    return {
      'resName': resName,
      'docID': docID,
      'facilityList': facilityList,
      'dietaryList': dietaryList,
      'atmopshereList': atmosphereList,
      'resEmail': resEmail,
      'averageRating': averageRating,
      'socialLink': socialLink,
      'address': address,
      'city': city,
      'logoImage': logoImage,
      'specialConditions': specialConditions,
      'password': password,
      'spokenLanguage': spokenLanguage,
      'entertainmentScheduleList': data,
      'imagesList': imagesList,
      'menuList': menuData,
      'latitude': latitude,
      'longitude': longitude,
      'socialMedia': socialMedia,
      'priceRange': priceRange,
      'about': about,
      'country': country,
    };
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> data) {
    List<EntertainmentScheduleModel> entertainmentList = [];
    if (data['entertainmentScheduleList'] != null) {
      try {
        entertainmentList =
            (data['entertainmentScheduleList'] as List<dynamic>).map((e) {
          if (e is Map<String, dynamic>) {
            return EntertainmentScheduleModel.fromMap(e);
          } else {
            print('Invalid entertainmentScheduleList item in fromMap: $e');
            return EntertainmentScheduleModel.initialize();
          }
        }).toList();
      } catch (e) {
        print('Error parsing entertainmentScheduleList in fromMap: $e');
      }
    }

    List<MenuModel> menuList = [];
    if (data['menuList'] != null) {
      try {
        menuList = (data['menuList'] as List<dynamic>).map((e) {
          if (e is Map<String, dynamic>) {
            return MenuModel.fromMap(e);
          } else {
            print('Invalid menuList item in fromMap: $e');
            return MenuModel.initialize();
          }
        }).toList();
      } catch (e) {
        print('Error parsing menuList in fromMap: $e');
      }
    }

    return RestaurantModel(
      about: data['about'] ?? '',
      address: data['address'] ?? '',
      atmosphereList: List<String>.from(data['atmopshereList'] ?? []),
      averageRating: (data['averageRating'] ?? 0).toDouble(),
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      dietaryList: List<String>.from(data['dietaryList'] ?? []),
      docID: data['docID'] ?? '',
      entertainmentScheduleList: entertainmentList,
      facilityList: List<String>.from(data['facilityList'] ?? []),
      imagesList: List<String>.from(data['resImages'] ?? []),
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      logoImage: data['logoImage'] ?? '',
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      menuList: menuList,
      password: data['password'] ?? '',
      priceRange: data['priceRange'] ?? '',
      resEmail: data['resEmail'] ?? '',
      resName: data['resName'] ?? '',
      specialConditions: data['specialConditions'] ?? '',
      spokenLanguage: data['spokenLanguage'] ?? '',
      socialLink: data['socialLink'] ?? '',
      socialMedia: data['socialMedia'] ?? '',
      zipCode: data['zipCode'] ?? '',
    );
  }
}

class EntertainmentScheduleModel {
  String eventName;
  String eventBy;
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
        eventName: '',
        eventBy: '');
  }

  // Convert to Map for Firestore
  Future<Map<String, dynamic>> toMap() async {
    return {
      'eventName': eventName,
      'eventBy': eventBy,
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
      eventName: data['eventName'],
      startTime: data['startTime'],
      endTime: data['endTime'],
      day: data['day'],
      date: data['date'],
      isSelected: data['isSelected'],
      eventBy: data['eventBy'],
    );
  }
}

class MenuModel {
  String cuisineType;
  List<String> foodImages;
  String menuType;

  // Constructor
  MenuModel({
    required this.cuisineType,
    required this.foodImages,
    required this.menuType,
  });

  // Initialize with default values
  static MenuModel initialize() {
    return MenuModel(
      cuisineType: '',
      foodImages: [],
      menuType: '',
    );
  }

  // Convert the model instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'cuisineType': cuisineType,
      'foodImages': foodImages,
      'menuType': menuType,
    };
  }

  // Factory method to create an instance from a Firestore document
  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      cuisineType: map['cuisineType'] ?? '',
      foodImages: List<String>.from(map['foodImages'] ?? []),
      menuType: map['menuType'] ?? '',
    );
  }
}
