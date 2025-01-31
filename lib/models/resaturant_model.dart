import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<String> atmopshereList;
  String spokenLanguage;
  String socialMedia;
  String priceRange;
  double latitude;
  double longitude;
  DateTime createdAt; // New field
  List<EntertainmentScheduleModel> entertainmentScheduleList;
  MenuModel menuList;
  String about; // New field

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
    required this.atmopshereList,
    required this.zipCode,
    required this.logoImage,
    required this.spokenLanguage,
    required this.about, // Initialize in constructor
    required this.createdAt, // Initialize createdAt
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
      atmopshereList: <String>[],
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
      menuList: MenuModel.initialize(),
      about: '', // Default value
      createdAt: DateTime.now(), // Default to current createdAt
    );
  }

  // Convert the model instance to a map for Firestore
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
      'atmopshereList': atmopshereList,
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
      'about': about, // Add to Firestore map
      'createdAt': createdAt.toIso8601String(), // Convert createdAt to String
    };
  }

  // Create a model instance from a DocumentSnapshot
  static RestaurantModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return RestaurantModel(
      resName: snapshot.data()!['resName'],
      averageRating: snapshot.data()!['averageRating'],
      docID: snapshot.data()!['docID'],
      zipCode: snapshot.data()!['zipCode'],
      imagesList: snapshot.data()!['resImages'],
      city: snapshot.data()!['city'],
      resEmail: snapshot.data()!['resEmail'],
      socialLink: snapshot.data()!['socialLink'],
      address: snapshot.data()!['address'],
      latitude: snapshot.data()!['latitude'] ?? 33.602018,
      longitude: snapshot.data()!['longitude'] ?? 33.602018,
      facilityList: List<String>.from(
          snapshot.data()!['facilityList'].map((e) => e.toString())),
      atmopshereList: List<String>.from(
          snapshot.data()!['atmopshereList'].map((e) => e.toString())),
      dietaryList: List<String>.from(
          snapshot.data()!['dietaryList'].map((e) => e.toString())),
      specialConditions: snapshot.data()!['specialConditions'],
      password: snapshot.data()!['password'],
      spokenLanguage: snapshot.data()!['spokenLanguage'] == ''
          ? 'MALE'
          : snapshot.data()!['spokenLanguage'],
      socialMedia: snapshot.data()!['socialMedia'],
      priceRange: snapshot.data()!['priceRange'],
      logoImage: snapshot.data()!['logoImage'],
      about: snapshot.data()!['about'] ?? '', // Extract `about` field
      createdAt: snapshot.data()!['createdAt'] != null
          ? DateTime.parse(snapshot.data()!['createdAt'])
          : DateTime.now(), // Parse `createdAt` or set default
      entertainmentScheduleList: List<EntertainmentScheduleModel>.from(
        (snapshot.data()!['entertainmentScheduleList'] as List<dynamic>? ?? [])
            .map((e) =>
                EntertainmentScheduleModel.fromMap(e as Map<String, dynamic>))
            .toList(),
      ),
      menuList: snapshot.data()!['menuList'],
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
  List<OfferModel> percentageOff; // List of percentage offers
  List<OfferModel> happyHourSpecials; // List of happy hour specials

  // Constructor
  MenuModel({
    required this.percentageOff,
    required this.happyHourSpecials,
  });

  // Initialize the model with default values
  static MenuModel initialize() {
    return MenuModel(
      percentageOff: [],
      happyHourSpecials: [],
    );
  }

  // Convert the model instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'percentageOff': percentageOff.map((item) => item.toMap()).toList(),
      'happyHourSpecials':
          happyHourSpecials.map((item) => item.toMap()).toList(),
    };
  }

  // Create a model instance from Firestore data
  static MenuModel fromMap(Map<String, dynamic> data) {
    return MenuModel(
      percentageOff: (data['percentageOff'] as List<dynamic>? ?? [])
          .map((item) => OfferModel.fromMap(item as Map<String, dynamic>))
          .toList(),
      happyHourSpecials: (data['happyHourSpecials'] as List<dynamic>? ?? [])
          .map((item) => OfferModel.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }
}


class OfferModel {
  String? startTime;
  String? endTime;
  String? percentage;
  MealModel food; // List of food meals
  MealModel drink; // List of drink meals
  String? cuisine;
  String? discountType;
  String? fromDate;
  String? toDate;

  // Constructor
  OfferModel({
    this.startTime,
    this.endTime,
    this.toDate,
    this.percentage,
    this.discountType,
    this.fromDate,
    required this.food,
    required this.drink,
    this.cuisine,
  });

  // Convert the model instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime,
      'discountType' : discountType,
      'endTime': endTime,
      'fromDate' : fromDate,
      'toDate' : toDate,

      'percentage': percentage,
      'food': food,
      'drink': drink,
      'cuisine': cuisine,
    };
  }

  // Create a model instance from Firestore data
  static OfferModel fromMap(Map<String, dynamic> data) {
    return OfferModel(
      startTime: data['menu']['fromTime'],
      endTime: data['menu']['toTime'],
      fromDate: data['fromDate'],
      toDate: data['toDate'],
      discountType : data['menu']['discountType'],
      percentage: data['menu']['percentageValue'],
      food: MealModel.fromMap(data['food'] as Map<String, dynamic>),
      drink: MealModel.fromMap(data['drink'] as Map<String, dynamic>),
      cuisine: data['cuisine'],
    );
  }
}

class MealModel {
  String? offerName;
  List<String> imagesList;

  // Constructor
  MealModel({
    this.offerName,
    required this.imagesList,
  });

  // Convert the model instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'offerName': offerName,
      'imagesList': imagesList,
    };
  }

  // Create a model instance from Firestore data
  static MealModel fromMap(Map<String, dynamic> data) {
    return MealModel(
      offerName: data['offer'],
      imagesList: List<String>.from(data['images'] ?? []),
    );
  }
}
