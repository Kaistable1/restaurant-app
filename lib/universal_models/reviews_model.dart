import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String reviewID;
  String userID;
  String userName;
  String restaurantID;
  String description;
  double starRating;
  List<String> images;
  DateTime dateTime;

  ReviewModel({
    required this.reviewID,
    required this.userID,
    required this.userName,
    required this.restaurantID,
    required this.description,
    required this.starRating,
    required this.images,
    required this.dateTime,
  });

  // Factory constructor to create an instance from Firestore
  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      reviewID: map['reviewID'] ?? '',
      userID: map['userID'] ?? '',
      userName: map['userName'] ?? '',
      restaurantID: map['restaurantID'] ?? '',
      description: map['description'] ?? '',
      starRating: map['starRating'] ?? 0,
      images: List<String>.from(map['images'] ?? []),
      dateTime: (map['dateTime'] as Timestamp).toDate(),
    );
  }

  // Convert the model to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'reviewID': reviewID,
      'userID': userID,
      'userName': userName,
      'restaurantID': restaurantID,
      'description': description,
      'starRating': starRating,
      'images': images,
      'dateTime': Timestamp.fromDate(dateTime),
    };
  }
}
