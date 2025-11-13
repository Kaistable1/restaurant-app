import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? reviewID;
  String? restaurantID;
  String? userName;
  String? userID;
  List<String>? images; // List of image URLs
  double? starRating; // Star rating
  String? description; // Description note
  DateTime? createdAt;

  ReviewModel({
    this.reviewID,
    this.restaurantID,
    this.userName,
    this.userID,
    this.images,
    this.starRating,
    this.description,
    this.createdAt,
  });

  // Factory method to create a ReviewModel from a Firestore document
  factory ReviewModel.fromFirestore(Map<String, dynamic> json) {
    return ReviewModel(
      reviewID: json['reviewID'],
      restaurantID: json['restaurantID'],
      userName: json['userName'],
      userID: json['userID'],
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      starRating: (json['starRating'] as num?)?.toDouble(),
      description: json['description'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Method to convert ReviewModel to a Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'reviewID': reviewID,
      'restaurantID': restaurantID,
      'userName': userName,
      'userID': userID,
      'images': images,
      'starRating': starRating,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
