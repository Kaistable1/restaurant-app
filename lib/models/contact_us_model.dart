import 'package:cloud_firestore/cloud_firestore.dart';

class ContactUsModel {
  String email;
  String phone;
  DateTime? updatedAt;

  ContactUsModel({
    required this.email,
    required this.phone,
    this.updatedAt,
  });

  static ContactUsModel initialize() {
    return ContactUsModel(email: '', phone: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'updated_at': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : null,
    };
  }

  static ContactUsModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final doc = snapshot.data()!;
    return ContactUsModel(
      email: doc['email'] ?? '',
      phone: doc['phone'] ?? '',
      updatedAt: (doc['updated_at'] as Timestamp?)?.toDate(),
    );
  }
}