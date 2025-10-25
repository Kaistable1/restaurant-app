import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String? videoId;
  final String? atmosphere;
  final String? causines;
  final String? city;
  final String? experience;
  final String? fileName;
  final String? restaurantName;
  final String? restaurantType;
  final String? state;
  final String? streetNo;
  final DateTime? timestamp;
  final String? url;
  final String? vibes;
  final String? zipCode;
  final String? mediaType;
  final String? description;

  VideoModel({
    this.videoId,
    this.atmosphere,
    this.causines,
    this.city,
    this.experience,
    this.fileName,
    this.restaurantName,
    this.restaurantType,
    this.state,
    this.streetNo,
    this.timestamp,
    this.url,
    this.vibes,
    this.zipCode,
    this.mediaType,
    this.description,
  });

  factory VideoModel.fromMap(Map<String, dynamic> map, String docId) {
    return VideoModel(
      videoId: docId,
      atmosphere: map['atmosphere'],
      causines: map['causines'],
      city: map['city'],
      experience: map['experience'],
      fileName: map['fileName'],
      restaurantName: map['restaurantName'],
      restaurantType: map['restaurantType'],
      state: map['state'],
      streetNo: map['streetNo'],
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : null,
      url: map['url'],
      vibes: map['vibes'],
      zipCode: map['zipCode'],
      mediaType: map['mediaType'],
      description: map['description'],
    );
  }
}
