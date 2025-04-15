import 'package:cloud_firestore/cloud_firestore.dart';

class PrivacyPolicyModel {
  String text;
  DateTime? updatedAt;
  String? version;
  String? language;

  PrivacyPolicyModel({
    required this.text,
    this.updatedAt,
    this.version,
    this.language,
  });

  static PrivacyPolicyModel initialize() {
    return PrivacyPolicyModel(text: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'updated_at': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : null,
      if (version != null) 'version': version,
      if (language != null) 'language': language,
    };
  }

  static PrivacyPolicyModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final doc = snapshot.data()!;
    return PrivacyPolicyModel(
      text: doc['text'] ?? '',
      updatedAt: (doc['updated_at'] as Timestamp?)?.toDate(),
      version: doc['version'],
      language: doc['language'],
    );
  }
}

