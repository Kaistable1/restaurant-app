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
  MenuModel menuList;
  String about;
  String country;
  // New Fields
  String fbLink; //https://facebook.com/
  String instaLink; //https://instagram.com/
  String tiktokLink; //https://tiktok.com
  String twitterLink; // https://twitter.com

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
    required this.about,
    required this.createdAt,
    required this.country,
    // New Fields
    required this.fbLink,
    required this.instaLink,
    required this.tiktokLink,
    required this.twitterLink,
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
      about: '',
      createdAt: DateTime.now(),
      country: '',
      fbLink: '',
      instaLink: '',
      tiktokLink: '',
      twitterLink: '',
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
      'createdAt': createdAt.toIso8601String(),
      'country': country,
      // New Fields
      'facebookLink': fbLink,
      'instaLink': instaLink,
      'xLink': tiktokLink,
      'youtubeLink': twitterLink,
    };
  }

  // From Firestore Document
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
      menuList: MenuModel.initialize(),
      country: data['country'] ?? '',
      // New Fields
      fbLink: data['fbLink'] ?? '',
      instaLink: data['instaLink'] ?? '',
      tiktokLink: data['tiktokLink'] ?? '',
      twitterLink: data['twitterLink'] ?? '',
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
      'discountType': discountType,
      'endTime': endTime,
      'fromDate': fromDate,
      'toDate': toDate,
      'percentage': percentage,
      'food': food,
      'drink': drink,
      'cuisine': cuisine,
    };
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
