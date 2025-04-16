import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
   String contact;
   Timestamp createdAt;
   String docID;
   String email;
   String img;
   String name;
   String role;
   String status;

  AdminModel({
    required this.contact,
    required this.createdAt,
    required this.docID,
    required this.email,
    required this.img,
    required this.name,
    required this.role,
    required this.status,
  });

  factory AdminModel.fromMap(Map<String, dynamic> data, String docID) {
    return AdminModel(
      contact: data['contact'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      docID: docID,
      
      email: data['email'] ?? '',
      img: data['img'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      status: data['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contact': contact,
      'createdAt': createdAt,
      'email': email,
      'img': img,
      'name': name,
      'role': role,
      'status': status,
    };
  }
}