import 'package:cloud_firestore/cloud_firestore.dart';

class TermsAndConditionsModel {
  String text;
  DateTime? updatedAt;

  TermsAndConditionsModel({
    required this.text,
    this.updatedAt,
  });

  static TermsAndConditionsModel initialize() {
    return TermsAndConditionsModel(text: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'updated_at': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : null,
    };
  }

  static TermsAndConditionsModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final doc = snapshot.data()!;
    return TermsAndConditionsModel(
      text: doc['text'] ?? '',
      updatedAt: (doc['updated_at'] as Timestamp?)?.toDate(),
    );
  }
}