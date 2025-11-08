import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String? reportID;
  String? reportedByUserID;
  String? reportedByUserName;
  String? reportedUserID; // User being reported
  String? reportedUserName;
  String? contentID; // Post ID or other content ID
  String? contentType; // 'post', 'profile', 'review', etc.
  String? reason;
  String? description;
  String? status; // 'pending', 'reviewed', 'resolved', 'dismissed'
  DateTime? createdAt;
  DateTime? reviewedAt;
  String? reviewedBy; // Admin user ID
  String? resolution; // Admin's resolution note
  bool? aiModerated; // Whether AI moderation flagged this
  String? aiModerationResult; // AI moderation details

  ReportModel({
    this.reportID,
    this.reportedByUserID,
    this.reportedByUserName,
    this.reportedUserID,
    this.reportedUserName,
    this.contentID,
    this.contentType,
    this.reason,
    this.description,
    this.status,
    this.createdAt,
    this.reviewedAt,
    this.reviewedBy,
    this.resolution,
    this.aiModerated,
    this.aiModerationResult,
  });

  // Factory method to create a ReportModel from Firestore document
  factory ReportModel.fromFirestore(Map<String, dynamic> json) {
    return ReportModel(
      reportID: json['reportID'],
      reportedByUserID: json['reportedByUserID'],
      reportedByUserName: json['reportedByUserName'],
      reportedUserID: json['reportedUserID'],
      reportedUserName: json['reportedUserName'],
      contentID: json['contentID'],
      contentType: json['contentType'],
      reason: json['reason'],
      description: json['description'],
      status: json['status'] ?? 'pending',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      reviewedAt: (json['reviewedAt'] as Timestamp?)?.toDate(),
      reviewedBy: json['reviewedBy'],
      resolution: json['resolution'],
      aiModerated: json['aiModerated'] ?? false,
      aiModerationResult: json['aiModerationResult'],
    );
  }

  // Method to convert ReportModel to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'reportID': reportID,
      'reportedByUserID': reportedByUserID,
      'reportedByUserName': reportedByUserName,
      'reportedUserID': reportedUserID,
      'reportedUserName': reportedUserName,
      'contentID': contentID,
      'contentType': contentType,
      'reason': reason,
      'description': description,
      'status': status ?? 'pending',
      'createdAt': createdAt,
      'reviewedAt': reviewedAt,
      'reviewedBy': reviewedBy,
      'resolution': resolution,
      'aiModerated': aiModerated ?? false,
      'aiModerationResult': aiModerationResult,
    };
  }
}
