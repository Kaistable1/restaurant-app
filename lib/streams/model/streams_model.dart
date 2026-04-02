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
          ? (map['timestamp'] is Timestamp
              ? (map['timestamp'] as Timestamp).toDate()
              : DateTime.tryParse(map['timestamp'].toString()))
          : null,
      url: map['url'],
      vibes: map['vibes'],
      zipCode: map['zipCode'],
      mediaType: map['mediaType'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'atmosphere': atmosphere,
      'causines': causines,
      'city': city,
      'experience': experience,
      'fileName': fileName,
      'restaurantName': restaurantName,
      'restaurantType': restaurantType,
      'state': state,
      'streetNo': streetNo,
      'timestamp': timestamp?.toIso8601String(),
      'url': url,
      'vibes': vibes,
      'zipCode': zipCode,
      'mediaType': mediaType,
      'description': description,
    };
  }

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      videoId: json['videoId'],
      atmosphere: json['atmosphere'],
      causines: json['causines'],
      city: json['city'],
      experience: json['experience'],
      fileName: json['fileName'],
      restaurantName: json['restaurantName'],
      restaurantType: json['restaurantType'],
      state: json['state'],
      streetNo: json['streetNo'],
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
      url: json['url'],
      vibes: json['vibes'],
      zipCode: json['zipCode'],
      mediaType: json['mediaType'],
      description: json['description'],
    );
  }
}
