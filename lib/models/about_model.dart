import 'package:cloud_firestore/cloud_firestore.dart';

class AboutModel {
  String text;
  DateTime? updatedAt;

  AboutModel({
    required this.text,
    this.updatedAt,
  });

  static AboutModel initialize() {
    return AboutModel(text: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'updated_at': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : null,
    };
  }

  static AboutModel fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final doc = snapshot.data()!;
    return AboutModel(
      text: doc['text'] ?? '',
      updatedAt: (doc['updated_at'] as Timestamp?)?.toDate(),
    );
  }
}