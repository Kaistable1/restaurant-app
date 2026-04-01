import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String bannerImage;
  String title;
  String state;
  String city;
  String startDate;
  String endDate;
  String userID;
  String status;


  BannerModel({
    required this.bannerImage,
    required this.title,
    required this.state,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.userID,
    required this.status,
  });

  static BannerModel initialize() {
    return BannerModel(
        bannerImage: '',
        title: '',
        state: '',
        city: '',
        startDate: '',
        endDate: '',
        userID: '',
        status: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'bannerImage': bannerImage,
      'title': title,
      'state': state,
      'city': city,
      'startDate': startDate,
      'endDate': endDate,
      'userID':userID,
      'status':status,
    };
  }

  static BannerModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final doc = snapshot.data()!;
    return BannerModel(
      bannerImage: doc['bannerImage'] ?? '',
      title: doc['title'] ?? '',
      state: doc['state'] ?? '',
      city: doc['city'] ?? '',
      startDate: doc['startDate'] ?? '',
      endDate: doc['endDate'] ?? '',
      userID: doc['userID'] ??'',
      status: doc['status']??'',
    );
  }
}
