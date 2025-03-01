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
  DateTime createdAt;
  List<EntertainmentScheduleModel> entertainmentScheduleList;
  String about;
  String country; // New field added

  // Constructor
  RestaurantModel({
    required this.facilityList,
    required this.docID,
    required this.entertainmentScheduleList,
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
    required this.about,
    required this.createdAt,
    required this.country, // Initialize in constructor
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
      about: '',
      createdAt: DateTime.now(),
      country: '', // Default to empty string for country
    );
  }

  // Convert the model instance to a map for Firestore
  Future<Map<String, dynamic>> toMap() async {
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
      'about': about,
      'createdAt': createdAt,
      'country': country, // Add country to Firestore map
    };
  }

  // Create a model instance from a DocumentSnapshot
  static RestaurantModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return RestaurantModel(
      resName: data['resName'] ?? '',
      averageRating: (data['averageRating'] ?? 0).toDouble(),
      docID: data['docID'] ?? '',
      zipCode: data['zipCode'] ?? '',
      imagesList: List<String>.from(data['resImages'] ?? []),
      city: data['city'] ?? '',
      resEmail: data['resEmail'] ?? '',
      socialLink: data['socialLink'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      facilityList: List<String>.from(data['facilityList'] ?? []),
      atmopshereList: List<String>.from(data['atmopshereList'] ?? []),
      dietaryList: List<String>.from(data['dietaryList'] ?? []),
      specialConditions: data['specialConditions'] ?? '',
      password: data['password'] ?? '',
      spokenLanguage: data['spokenLanguage'] ?? '',
      socialMedia: data['socialMedia'] ?? '',
      priceRange: data['priceRange'] ?? '',
      logoImage: data['logoImage'] ?? '',
      about: data['about'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      entertainmentScheduleList: List<EntertainmentScheduleModel>.from(
        (data['entertainmentScheduleList'] as List<dynamic>? ?? []).map(
          (e) => EntertainmentScheduleModel.fromMap(e as Map<String, dynamic>),
        ),
      ),
      country: data['country'] ?? '', // Fetch country from Firestore
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
