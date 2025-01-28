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
  List<EntertainmentScheduleModel> entertainmentScheduleList;

  //constructor
  RestaurantModel({
    required this.facilityList,
    required this.entertainmentScheduleList,
    required this.city,
    required this.longitude,
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
    );
  }

// Convert the model instance to a map for storing in Firestore
  Future<Map<String, dynamic>> toMap() async {
    // logoImage.value =
    //     logoImage.value.contains('https://firebasestorage.googleapis.com/') &&
    //             logoImageMemory.value.isEmpty
    //         ? logoImage.value
    //         : logoImageMemory.value.isNotEmpty
    //             ? await uploadImageToFirebase('logo', logoImageMemory.value)
    //             : '';
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

    return RestaurantModel(
      resName: TextEditingController(
        text: data['resName'] ?? '',
      ),
      zipCode: TextEditingController(
        text: data['zipCode'] ?? '',
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
      docID: data['docID'],
      logoImage: RxString(data['logoImage'] ?? ''),
      logoImageMemory: Uint8List(0).obs,
      entertainmentScheduleList: RxList<EntertainmentScheduleModel>.from(
        (data['entertainmentScheduleList'] as List<dynamic>? ?? [])
            .map((e) => EntertainmentScheduleModel.fromMap(e)),
      ),
    );
  }

//   static RestaurantModel fromDocumentSnapshot(
//       DocumentSnapshot<Map<String, dynamic>> snapshot) {
//     // print('Entire snapshot data: ${snapshot.data()}');
//     // print('Value of warning: ${snapshot.data()!['warning']}');
//
//     // Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//     return RestaurantModel(
//       resName: TextEditingController(
//         text: snapshot.data()!['resName'],
//       ),
//       zipCode: TextEditingController(
//         text: snapshot.data()!['zipCode'],
//       ),
//       city: TextEditingController(
//         text: snapshot.data()!['city'],
//       ),
//       resEmail: TextEditingController(
//         text: snapshot.data()!['resEmail'],
//       ),
//       socialLink: TextEditingController(
//         text: snapshot.data()!['socialLink'],
//       ),
//       address: TextEditingController(
//         text: snapshot.data()!['address'],
//       ),
//       latitude: snapshot.data()!['latitude'] ?? '33.602018',
//       longitude: snapshot.data()!['longitude'] ?? '33.602018',
//       facilityList: RxList<String>.from(
//           snapshot.data()!['facilityList'].map((e) => e.toString())),
//       atmopshereList: RxList<String>.from(
//           snapshot.data()!['atmopshereList'].map((e) => e.toString())),
//       dietaryList: RxList<String>.from(
//           snapshot.data()!['dietaryList'].map((e) => e.toString())),
//       specialConditions:
//           TextEditingController(text: snapshot.data()!['specialConditions']),
//       password: TextEditingController(text: snapshot.data()!['password']),
//       spokenLanguage: RxString(snapshot.data()!['spokenLanguage'] == ''
//           ? 'MALE'
//           : snapshot.data()!['spokenLanguage']),
//       socialMedia: RxString(snapshot.data()!['socialMedia']),
//       priceRange: RxString(snapshot.data()!['priceRange']),
//       docID: snapshot.data()!['docID'],
//       logoImage: RxString(
//         snapshot.data()!['logoImage'],
//       ),
//       logoImageMemory: Uint8List(0).obs,
//       entertainmentScheduleList: RxList<EntertainmentScheduleModel>.from(
//         (snapshot.data()!['entertainmentScheduleList'] as List<dynamic>? ?? [])
//             .map((e) =>
//                 EntertainmentScheduleModel.fromMap(e as Map<String, dynamic>))
//             .toList(),
//       ),
//     );
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

//
// class OperatingHoursModel {
//   List<DaysModel> days;
//
//   // Constructor
//
//   OperatingHoursModel({
//     required this.days,
//   });
//
//   static OperatingHoursModel initialize() {
//     return OperatingHoursModel(
//       days: [],
//     );
//   }
//
//   // Convert to Map for Firestore
//   Future<Map<String, dynamic>> toMap() async {
//     List<Map<String, dynamic>> data = [];
//     for (var element in days) {
//       var d = await element.toMap();
//       data.add(d);
//     }
//     return {'days': data};
//   }
//
//   // Create an instance from Firestore data
//   static OperatingHoursModel fromMap(Map<String, dynamic> data) {
//     return OperatingHoursModel(
//         days: RxList<DaysModel>.from(
//       (data['days'] as List<dynamic>? ?? [])
//           .map((e) => DaysModel.fromMap(e as Map<String, dynamic>))
//           .toList(),
//     ));
//   }
// }
//
// class DaysModel {
//   List<EatTimeModel> meals;
//
//   // Constructor
//   DaysModel({
//     required this.meals,
//   });
//   static DaysModel initialize() {
//     return DaysModel(meals: []);
//   }
//   // Convert to Map for Firestore
//   Future<Map<String, dynamic>> toMap() async {
//     List<Map<String, dynamic>> dataTimes = [];
//     for (var element in meals) {
//       var d = await element.toMap();
//       dataTimes.add(d);
//     }
//     return {'dataTimes': dataTimes};
//   }
//
//   // Create an instance from Firestore data
//   static DaysModel fromMap(Map<String, dynamic> data) {
//     return DaysModel(
//         meals: RxList<EatTimeModel>.from(
//       (data['meals'] as List<dynamic>? ?? [])
//           .map((e) => EatTimeModel.fromMap(e as Map<String, dynamic>))
//           .toList(),
//     ));
//   }
// }
//
// class EatTimeModel {
//   bool isClosed;
//   String startTime;
//   String endTime;
//   List<EatTimeModel> meals;
//
//   // Constructor
//   EatTimeModel({
//     required this.isClosed,
//     required this.meals,
//     required this.startTime,
//     required this.endTime,
//   });
//
//   static EatTimeModel initialize() {
//     return EatTimeModel(
//         meals: [], isClosed: false, endTime: '', startTime: '');
//   }
//
//   // Convert to Map for Firestore
//   Future<Map<String, dynamic>> toMap() async {
//     List<Map<String, dynamic>> dataTimes = [];
//     for (var element in meals) {
//       var d = await element.toMap();
//       dataTimes.add(d);
//     }
//     return {
//       'startTime': startTime,
//       'endTime': endTime,
//       'dataTimes': dataTimes,
//       'isClosed': isClosed
//     };
//   }
//
//   // Create an instance from Firestore data
//   static EatTimeModel fromMap(Map<String, dynamic> data) {
//     return EatTimeModel(
//         isClosed: data['isClosed'],
//         startTime: data['startTime'],
//         endTime: data['endTime'],
//         meals: RxList<EatTimeModel>.from(
//           (data['meals'] as List<dynamic>? ?? [])
//               .map((e) => EatTimeModel.fromMap(e as Map<String, dynamic>))
//               .toList(),
//         ));
//   }
// }
////////////////////
// class OperatingHoursModel {
//   Map<String, DaysModel> days;
//
//   // Constructor
//   OperatingHoursModel({
//     required this.days,
//   });
//
//   static OperatingHoursModel initialize() {
//     return OperatingHoursModel(days: {});
//   }
//
//   // Convert to Map for Firestore
//   Future<Map<String, dynamic>> toMap() async {
//     Map<String, dynamic> daysMap = {};
//     for (var entry in days.entries) {
//       daysMap[entry.key] = await entry.value.toMap();
//     }
//     return daysMap;
//   }
//
//   // Create an instance from Firestore data
//   static OperatingHoursModel fromFirestore(Map<String, dynamic> data) {
//     return OperatingHoursModel(
//       days: Map<String, DaysModel>.from(
//         data.map(
//               (key, value) => MapEntry(key, DaysModel.fromFirestore(value)),
//         ),
//       ),
//     );
//   }
// }
//
// class DaysModel {
//   Map<String, EatTimeModel> meals;
//
//   // Constructor
//   DaysModel({
//     required this.meals,
//   });
//
//   static DaysModel initialize() {
//     return DaysModel(meals: {});
//   }
//
//   // Convert to Map for Firestore
//   Future<Map<String, dynamic>> toMap() async {
//     Map<String, dynamic> mealMap = {};
//     for (var entry in meals.entries) {
//       mealMap[entry.key] = await entry.value.toMap();
//     }
//     return mealMap;
//   }
//
//   // Create an instance from Firestore data
//   static DaysModel fromFirestore(Map<String, dynamic> data) {
//     return DaysModel(
//       meals: Map<String, EatTimeModel>.from(
//         data.map(
//               (key, value) => MapEntry(key, EatTimeModel.fromFirestore(value)),
//         ),
//       ),
//     );
//   }
// }
//
// class EatTimeModel {
//   bool isClosed;
//   String? startTime;
//   String? endTime;
//
//   // Constructor
//   EatTimeModel({
//     required this.isClosed,
//     this.startTime,
//     this.endTime,
//   });
//
//   static EatTimeModel initialize() {
//     return EatTimeModel(isClosed: true, startTime: null, endTime: null);
//   }
//
//   // Convert to Map for Firestore
//   Future<Map<String, dynamic>> toMap() async {
//     return {
//       'isClosed': isClosed,
//       'startTime': startTime ?? '',
//       'endTime': endTime ?? '',
//     };
//   }
//
//   // Create an instance from Firestore data
//   static EatTimeModel fromFirestore(Map<String, dynamic> data) {
//     return EatTimeModel(
//       isClosed: data['isClosed'] ?? true,
//       startTime: data['startTime'] ?? '',
//       endTime: data['endTime'] ?? '',
//     );
//   }
// }

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
