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

  RestaurantClaimsModel({
    required this.id,
    required this.restaurantsName,
    required this.ownerName,
    required this.email,
    required this.contact,
    required this.message,
    required this.status,
    required this.photoUrl,
    this.createdAt,
  });

  factory RestaurantClaimsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RestaurantClaimsModel(
      id: doc.id,
      restaurantsName: data['resName'] ?? '',
      ownerName: data['userName'] ?? '',
      email: data['email'] ?? '',
      message: data['message'] ?? '',
      status: data['status'] ?? 'Pending',
      photoUrl: data['img'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(), contact: data['contact'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantsName': restaurantsName,
      'ownerName': ownerName,
      'email': email,
      'message': message,
      'status': status,
      'photoUrl': photoUrl,
      'contact' : contact,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
