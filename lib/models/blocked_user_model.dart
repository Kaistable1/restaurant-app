import 'package:cloud_firestore/cloud_firestore.dart';

class BlockedUserModel {
  String? blockID;
  String? blockedByUserID;
  String? blockedUserID;
  String? blockedUserName;
  DateTime? createdAt;
  String? reason;

  BlockedUserModel({
    this.blockID,
    this.blockedByUserID,
    this.blockedUserID,
    this.blockedUserName,
    this.createdAt,
    this.reason,
  });

  // Factory method to create a BlockedUserModel from Firestore document
  factory BlockedUserModel.fromFirestore(Map<String, dynamic> json) {
    return BlockedUserModel(
      blockID: json['blockID'],
      blockedByUserID: json['blockedByUserID'],
      blockedUserID: json['blockedUserID'],
      blockedUserName: json['blockedUserName'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      reason: json['reason'],
    );
  }

  // Method to convert BlockedUserModel to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'blockID': blockID,
      'blockedByUserID': blockedByUserID,
      'blockedUserID': blockedUserID,
      'blockedUserName': blockedUserName,
      'createdAt': createdAt,
      'reason': reason,
    };
  }
}
