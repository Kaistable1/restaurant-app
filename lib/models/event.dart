import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String? docId; // Firestore document ID
  String eventName;
  String eventType;
  String location;
  String city;
  String country;
  String date;
  String time;
  String phoneNumber;
  String url;
  String description;
  List<String> imageUrls; // Firebase Storage URLs
  double latitude;
  double longitude;
  DateTime createdAt;

  Event({
    this.docId,
    required this.eventName,
    required this.eventType,
    required this.location,
    required this.city,
    required this.country,
    required this.date,
    required this.time,
    required this.phoneNumber,
    required this.url,
    required this.description,
    required this.imageUrls,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  // Convert Event to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'eventType': eventType,
      'location': location,
      'city': city,
      'country': country,
      'date': date,
      'time': time,
      'phoneNumber': phoneNumber,
      'url': url,
      'description': description,
      'imageUrls': imageUrls,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt,
    };
  }

  // Create Event from Firestore document
  factory Event.fromMap(String id, Map<String, dynamic> map) {
    return Event(
      docId: id,
      eventName: map['eventName'] ?? '',
      eventType: map['eventType'] ?? '',
      location: map['location'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      url: map['url'] ?? '',
      description: map['description'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
