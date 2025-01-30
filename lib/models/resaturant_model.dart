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
  DateTime dateTime; // New field
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
    required this.dateTime, // Initialize dateTime
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
      dateTime: DateTime.now(), // Default to current datetime
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
      'dateTime': dateTime.toIso8601String(), // Convert DateTime to String
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
      imagesList: snapshot.data()!['imagesList'],
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
      dateTime: snapshot.data()!['dateTime'] != null
          ? DateTime.parse(snapshot.data()!['dateTime'])
          : DateTime.now(), // Parse `dateTime` or set default
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
  List<PersentageModel> percentageOff; // List of percentage offers
  List<HappyHourModel> happyHourSpecials; // List of happy hour specials

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
          .map((item) => PersentageModel.fromMap(item as Map<String, dynamic>))
          .toList(),
      happyHourSpecials: (data['happyHourSpecials'] as List<dynamic>? ?? [])
          .map((item) => HappyHourModel.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PersentageModel {
  String? startTime;
  String? endTime;
  String? percentage;
  MealModel food; // List of food meals
  MealModel drink; // List of drink meals
  String? cuisine;

  // Constructor
  PersentageModel({
    this.startTime,
    this.endTime,
    this.percentage,
    required this.food,
    required this.drink,
    this.cuisine,
  });
  // Convert the model instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'percentage': percentage,
      'food': food,
      'drink': drink,
      'cuisine': cuisine,
    };
  }

  // Create a model instance from Firestore data
  static PersentageModel fromMap(Map<String, dynamic> data) {
    return PersentageModel(
      startTime: data['startTime'],
      endTime: data['endTime'],
      percentage: data['percentage'],
      food: MealModel.fromMap(data['food'] as Map<String, dynamic>),
      drink: MealModel.fromMap(data['drink'] as Map<String, dynamic>),
      cuisine: data['cuisine'],
    );
  }
}

class HappyHourModel {
  String? startTime;
  String? endTime;
  String? percentage;
  MealModel food; // List of food meals
  MealModel drink; // List of drink meals
  String? cuisine;

  // Constructor
  HappyHourModel({
    this.startTime,
    this.endTime,
    this.percentage,
    required this.food,
    required this.drink,
    this.cuisine,
  });

  // Convert the model instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'percentage': percentage,
      'food': food,
      'drink': drink,
      'cuisine': cuisine,
    };
  }

  // Create a model instance from Firestore data
  static HappyHourModel fromMap(Map<String, dynamic> data) {
    return HappyHourModel(
      startTime: data['startTime'],
      endTime: data['endTime'],
      percentage: data['percentage'],
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
      offerName: data['offerName'],
      imagesList: List<String>.from(data['imagesList'] ?? []),
    );
  }
}
