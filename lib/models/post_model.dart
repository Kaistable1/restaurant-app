import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? postID;
  String? userID;
  String? userName;
  String? userImage;
  String? content;
  List<String>? images;
  int? likesCount;
  List<String>? likedBy; // List of user IDs who liked the post
  int? commentsCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? restaurantID; // Optional reference to a restaurant
  String? restaurantName;

  PostModel({
    this.postID,
    this.userID,
    this.userName,
    this.userImage,
    this.content,
    this.images,
    this.likesCount,
    this.likedBy,
    this.commentsCount,
    this.createdAt,
    this.updatedAt,
    this.restaurantID,
    this.restaurantName,
  });

  // Factory method to create a PostModel from Firestore document
  factory PostModel.fromFirestore(Map<String, dynamic> json) {
    return PostModel(
      postID: json['postID'],
      userID: json['userID'],
      userName: json['userName'],
      userImage: json['userImage'],
      content: json['content'],
      images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      likesCount: json['likesCount'] ?? 0,
      likedBy: (json['likedBy'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      commentsCount: json['commentsCount'] ?? 0,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
      restaurantID: json['restaurantID'],
      restaurantName: json['restaurantName'],
    );
  }

  // Method to convert PostModel to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'postID': postID,
      'userID': userID,
      'userName': userName,
      'userImage': userImage,
      'content': content,
      'images': images ?? [],
      'likesCount': likesCount ?? 0,
      'likedBy': likedBy ?? [],
      'commentsCount': commentsCount ?? 0,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'restaurantID': restaurantID,
      'restaurantName': restaurantName,
    };
  }
}
