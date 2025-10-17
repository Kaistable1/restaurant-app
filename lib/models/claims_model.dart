import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savrly/models/resaturant_model.dart';

class RestaurantClaimsModel {
  final String id;
  final String ownerName;
  final String email;
  final String message;
  final String status;
  final String contact;
  final DateTime? createdAt;
  final String password;
  final String priceRange;
  final RestaurantModel restaurantData;

  // final String restaurantsName;
  // final String photoUrl;
  // final String about;
  // final String address;
  // final List<dynamic> atmopshereList;
  // final List<dynamic> vibesList;
  // final double averageRating;
  // final String city;
  // final String country;
  // final List<dynamic> dietaryList;
  // final String resID;
  // final List<dynamic> entertainmentScheduleList;
  // final List<dynamic> facilityList;
  // final List<dynamic> resImages;
  // final double latitude;
  // final double longitude;
  // final List<dynamic> menuList;
  // final String InstagramLink;
  // final String websiteUrl;
  // final String phoneNo;
  // final String TiktokLink;
  // final String specialConditions;
  // final String spokenLanguage;

  RestaurantClaimsModel(
      {required this.id,

      required this.ownerName,
      required this.email,
      required this.contact,
      required this.message,
      required this.status,
        this.createdAt,
        required this.password,
        required this.priceRange,
        required this.restaurantData
      // required this.restaurantsName,
      // required this.photoUrl,
      // required this.about,
      // required this.address,
      // required this.atmopshereList,
      // required this.vibesList,
      // required this.averageRating,
      // required this.city,
      // required this.country,
      // required this.dietaryList,
      // required this.resID,
      // required this.entertainmentScheduleList,
      // required this.facilityList,
      // required this.resImages,
      // required this.latitude,
      // required this.longitude,
      // required this.menuList,
      //
      // required this.InstagramLink,
      // required this.TiktokLink,
      // required this.specialConditions,
      // required this.spokenLanguage,
      // required this.phoneNo,
      // required this.websiteUrl
      });

  factory RestaurantClaimsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RestaurantClaimsModel(
        id: doc.id,
        ownerName: data['ownerName'] ?? '',
        email: data['email'] ?? '',
        message: data['message'] ?? '',
        status: data['status'] ?? 'Pending',
        createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
        contact: data['contact'] ?? '',
        password: data['password'] ?? '',
        priceRange: data['priceRange'] ?? '',
        restaurantData: RestaurantModel.fromMap(data['restaurantData']));
        // restaurantsName: data['restaurantsName'] ?? '',
        // photoUrl: data['photoUrl'] ?? '',
        // about: data['about'] ?? '',
        // address: data['address'] ?? '',
        // atmopshereList: List.from(data['atmopshereList'] ?? []),
        // vibesList: List.from(data['vibesList'] ?? []),
        // averageRating: data['averageRating']?.toDouble() ?? 0.0,
        // city: data['city'] ?? '',
        // country: data['country'] ?? '',
        // dietaryList: List.from(data['dietaryList'] ?? []),
        // resID: data['resID'] ?? '',
        // entertainmentScheduleList:
        //     List.from(data['entertainmentScheduleList'] ?? []),
        // facilityList: List.from(data['facilityList'] ?? []),
        // resImages: List.from(data['resImages'] ?? []),
        // latitude: data['latitude']?.toDouble() ?? 0.0,
        // longitude: data['longitude']?.toDouble() ?? 0.0,
        // menuList: List.from(data['menuList'] ?? []),
        //
        // InstagramLink: data['InstagramLink'] ?? '',
        // TiktokLink: data['TiktokLink'] ?? '',
        // specialConditions: data['specialConditions'] ?? '',
        // spokenLanguage: data['spokenLanguage'] ?? '',
        // websiteUrl: data['websiteUrl'] ?? " ",
        // phoneNo: data['phoneNo']);
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerName': ownerName,
      'email': email,
      'message': message,
      'status': status,
      'contact': contact,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'password': password,
      'priceRange': priceRange,
      'restaurantData': restaurantData.toMap(),

      // 'restaurantsName': restaurantsName,
      // 'photoUrl': photoUrl,
      // 'about': about,
      // 'address': address,
      // 'atmopshereList': atmopshereList,
      // 'vibesList': vibesList,
      // 'averageRating': averageRating,
      // 'city': city,
      // 'country': country,
      // 'dietaryList': dietaryList,
      // 'resID': resID,
      // 'entertainmentScheduleList': entertainmentScheduleList,
      // 'facilityList': facilityList,
      // 'resImages': resImages,
      // 'latitude': latitude,
      // 'longitude': longitude,
      // 'menuList': menuList,
      //
      // 'InstagramLink': InstagramLink,
      // 'TiktokLink': TiktokLink,
      // 'specialConditions': specialConditions,
      // 'spokenLanguage': spokenLanguage,
      // 'websiteUrl': websiteUrl,
      // 'phoneNo': phoneNo
    };
  }
}
