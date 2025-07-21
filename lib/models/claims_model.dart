import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantClaimsModel {
  final String id;
  final String restaurantsName;
  final String ownerName;
  final String email;
  final String message;
  final String status;
  final String photoUrl;
  final String contact;
  final DateTime? createdAt;
  final String about;
  final String address;
  final List<dynamic> atmopshereList;
  final List<dynamic> vibesList;
  final double averageRating;
  final String city;
  final String country;
  final List<dynamic> dietaryList;
  final String resID;
  final List<dynamic> entertainmentScheduleList;
  final List<dynamic> facilityList;
  final List<dynamic> resImages;
  final double latitude;
  final double longitude;
  final List<dynamic> menuList;
  final String password;
  final String priceRange;
  final String InstagramLink;
  final String websiteUrl;
  final String phoneNo;
  final String TiktokLink;
  final String specialConditions;
  final String spokenLanguage;

  RestaurantClaimsModel(
      {required this.id,
      required this.restaurantsName,
      required this.ownerName,
      required this.email,
      required this.contact,
      required this.message,
      required this.status,
      required this.photoUrl,
      this.createdAt,
      required this.about,
      required this.address,
      required this.atmopshereList,
      required this.vibesList,
      required this.averageRating,
      required this.city,
      required this.country,
      required this.dietaryList,
      required this.resID,
      required this.entertainmentScheduleList,
      required this.facilityList,
      required this.resImages,
      required this.latitude,
      required this.longitude,
      required this.menuList,
      required this.password,
      required this.priceRange,
      required this.InstagramLink,
      required this.TiktokLink,
      required this.specialConditions,
      required this.spokenLanguage,
      required this.phoneNo,
      required this.websiteUrl});

  factory RestaurantClaimsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RestaurantClaimsModel(
        id: doc.id,
        restaurantsName: data['restaurantsName'] ?? '',
        ownerName: data['ownerName'] ?? '',
        email: data['email'] ?? '',
        message: data['message'] ?? '',
        status: data['status'] ?? 'Pending',
        photoUrl: data['photoUrl'] ?? '',
        createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
        contact: data['contact'] ?? '',
        about: data['about'] ?? '',
        address: data['address'] ?? '',
        atmopshereList: List.from(data['atmopshereList'] ?? []),
        vibesList: List.from(data['vibesList'] ?? []),
        averageRating: data['averageRating']?.toDouble() ?? 0.0,
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        dietaryList: List.from(data['dietaryList'] ?? []),
        resID: data['resID'] ?? '',
        entertainmentScheduleList:
            List.from(data['entertainmentScheduleList'] ?? []),
        facilityList: List.from(data['facilityList'] ?? []),
        resImages: List.from(data['resImages'] ?? []),
        latitude: data['latitude']?.toDouble() ?? 0.0,
        longitude: data['longitude']?.toDouble() ?? 0.0,
        menuList: List.from(data['menuList'] ?? []),
        password: data['password'] ?? '',
        priceRange: data['priceRange'] ?? '',
        InstagramLink: data['InstagramLink'] ?? '',
        TiktokLink: data['TiktokLink'] ?? '',
        specialConditions: data['specialConditions'] ?? '',
        spokenLanguage: data['spokenLanguage'] ?? '',
        websiteUrl: data['websiteUrl'] ?? " ",
        phoneNo: data['phoneNo']);
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantsName': restaurantsName,
      'ownerName': ownerName,
      'email': email,
      'message': message,
      'status': status,
      'photoUrl': photoUrl,
      'contact': contact,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'about': about,
      'address': address,
      'atmopshereList': atmopshereList,
      'vibesList': vibesList,
      'averageRating': averageRating,
      'city': city,
      'country': country,
      'dietaryList': dietaryList,
      'resID': resID,
      'entertainmentScheduleList': entertainmentScheduleList,
      'facilityList': facilityList,
      'resImages': resImages,
      'latitude': latitude,
      'longitude': longitude,
      'menuList': menuList,
      'password': password,
      'priceRange': priceRange,
      'InstagramLink': InstagramLink,
      'TiktokLink': TiktokLink,
      'specialConditions': specialConditions,
      'spokenLanguage': spokenLanguage,
      'websiteUrl': websiteUrl,
      'phoneNo': phoneNo
    };
  }
}
