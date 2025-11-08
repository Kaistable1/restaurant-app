import 'package:cloud_firestore/cloud_firestore.dart';

class BadgeModel {
  String? badgeID;
  String? name;
  String? description;
  String? imageUrl;
  double? price;
  String? currency; // 'USD', 'EUR', etc.
  bool? isActive;
  DateTime? createdAt;

  BadgeModel({
    this.badgeID,
    this.name,
    this.description,
    this.imageUrl,
    this.price,
    this.currency,
    this.isActive,
    this.createdAt,
  });

  // Factory method to create a BadgeModel from Firestore document
  factory BadgeModel.fromFirestore(Map<String, dynamic> json) {
    return BadgeModel(
      badgeID: json['badgeID'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] ?? 'USD',
      isActive: json['isActive'] ?? true,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Method to convert BadgeModel to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'badgeID': badgeID,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'currency': currency ?? 'USD',
      'isActive': isActive ?? true,
      'createdAt': createdAt,
    };
  }
}
