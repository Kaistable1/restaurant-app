import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  String resName;
  String docID;
  String resEmail;
  String specialConditions;
  String socialLink;
  String password;
  double averageRating;
  String state;
  String city;
  String address;
  String zipCode;
  String websiteUrl;
  String phoneNo;

  String logoImage;
  List<String> facilityList;
  List<String> vibesList;
  List<String> experiencesList;
  List<String> entertainmentList;

  List<String> imagesList;
  List<String> dietaryList;
  List<String> atmosphereList;
  String spokenLanguage;
  String socialMedia;
  String priceRange;
  double latitude;
  double longitude;
  DateTime createdAt;
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
    required this.state,
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
    required this.createdAt,
    required this.country,
    required this.websiteUrl,
    required this.phoneNo,
    required this.vibesList,
    required this.experiencesList,
    required this.entertainmentList,
  });

  // Initialize the model with defaults
  static RestaurantModel initialize() {
    return RestaurantModel(
        vibesList: <String>[],
        experiencesList: <String>[],
        entertainmentList: <String>[],
        resName: '',
        docID: '',
        socialLink: '',
        averageRating: 0.0,
        resEmail: '',
        state: '',
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
        createdAt: DateTime.now(),
        country: '',
        websiteUrl: '',
        phoneNo: '');
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
      'vibesList': vibesList,
      'experiencesList': experiencesList,
      'entertainmentList': entertainmentList,
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
      'country': country,
      'zipCode': zipCode,
      'phoneNo': phoneNo,
      'websiteUrl': websiteUrl
    };
  }

  // Optional: Factory to create from map
  static RestaurantModel fromMap(Map<String, dynamic> data) {
    return RestaurantModel(
        about: data['about'] ?? '',
        address: data['address'] ?? '',
        atmosphereList: List<String>.from(data['atmopshereList'] ?? []),
        vibesList: List<String>.from(data['vibesList'] ?? []),
        experiencesList: List<String>.from(data['experiencesList'] ?? []),
        entertainmentList: List<String>.from(data['entertainmentList'] ?? []),
        averageRating: (data['averageRating'] ?? 0).toDouble(),
        city: data['city'] ?? '',
        state: data['state'] ?? '',
        country: data['country'] ?? '',
        createdAt: data['createdAt'] != null
            ? (data['createdAt'] as Timestamp).toDate()
            : DateTime.now(),
        dietaryList: List<String>.from(data['dietaryList'] ?? []),
        docID: data['docID'] ?? '',
        entertainmentScheduleList: List<EntertainmentScheduleModel>.from(
          (data['entertainmentScheduleList'] as List<dynamic>? ?? []).map(
            (e) =>
                EntertainmentScheduleModel.fromMap(e as Map<String, dynamic>),
          ),
        ),
        facilityList: List<String>.from(data['facilityList'] ?? []),
        imagesList:
            List<String>.from(data['imagesList'] ?? data['resImages'] ?? []),
        latitude: (data['latitude'] ?? 0.0).toDouble(),
        logoImage: data['logoImage'] ?? '',
        longitude: (data['longitude'] ?? 0.0).toDouble(),
        menuList: List<MenuModel>.from(
          (data['menuList'] as List<dynamic>? ?? []).map(
            (e) => MenuModel.fromMap(e as Map<String, dynamic>),
          ),
        ),
        password: data['password'] ?? '',
        priceRange: data['priceRange'] ?? '',
        resEmail: data['resEmail'] ?? '',
        resName: data['resName'] ?? '',
        specialConditions: data['specialConditions'] ?? '',
        spokenLanguage: data['spokenLanguage'] ?? '',
        socialLink: '',
        socialMedia: '',
        zipCode: data['zipCode'] != null
            ? data['zipCode']
            : data['zipcode'] != null
                ? data['zipcode']
                : '',
        phoneNo: data['phoneNo'] ?? "",
        websiteUrl: data['websiteUrl'] ?? " ");
  }

  // From Firestore Document
  static RestaurantModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return RestaurantModel(
      resName: data['resName'] ?? '',
      averageRating: (data['averageRating'] ?? 0).toDouble(),
      docID: snapshot.id,
      zipCode: data['zipCode'] ?? '',
      phoneNo: data['phoneNo'] ?? '',
      websiteUrl: data['websiteUrl'] ?? '',
      imagesList:
          List<String>.from(data['imagesList'] ?? data['resImages'] ?? []),
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      resEmail: data['resEmail'] ?? '',
      socialLink: data['socialLink'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      facilityList: List<String>.from(data['facilityList'] ?? []),
      atmosphereList: List<String>.from(data['atmopshereList'] ?? []),
      vibesList: List<String>.from(data['vibesList'] ?? []),
      experiencesList: List<String>.from(data['experiencesList'] ?? []),
      entertainmentList: List<String>.from(data['entertainmentList'] ?? []),
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
      menuList: List<MenuModel>.from(
        (data['menuList'] as List<dynamic>? ?? []).map(
          (e) => MenuModel.fromMap(e as Map<String, dynamic>),
        ),
      ),
      country: data['country'] ?? '',
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
