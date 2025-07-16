import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String id;
  final String url;
  final String fileName;
  final String caption;
  final String restaurantName;
  final String city;
  final String state;
  final String streetNo;
  final String zipCode;
  final String vibes;
  final String atmosphere;
  final String experience;
  final String cuisines;
  final DateTime timestamp;

  VideoModel({
    required this.id,
    required this.url,
    required this.fileName,
    required this.caption,
    required this.restaurantName,
    required this.city,
    required this.state,
    required this.streetNo,
    required this.zipCode,
    required this.vibes,
    required this.atmosphere,
    required this.experience,
    required this.cuisines,
    required this.timestamp,
  });

  factory VideoModel.fromFirestore(String id, Map<String, dynamic> data) {
    return VideoModel(
      id: id,
      url: data['url'] ?? '',
      fileName: data['fileName'] ?? '',
      caption: data['caption'] ?? '',
      restaurantName: data['restaurantName'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      streetNo: data['streetNo'] ?? '',
      zipCode: data['zipCode'] ?? '',
      vibes: data['vibes'] ?? '',
      atmosphere: data['atmosphere'] ?? '',
      experience: data['experience'] ?? '',
      cuisines: data['causines'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
