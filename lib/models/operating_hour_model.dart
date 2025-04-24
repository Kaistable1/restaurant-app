import 'package:cloud_firestore/cloud_firestore.dart';

// Model class to represent operating hours for a day
class MyOperatingHours {
  final String day;
  final Map<String, dynamic> breakfast;
  final Map<String, dynamic> brunch;
  final Map<String, dynamic> dinner;
  final Map<String, dynamic> lunch;

  MyOperatingHours({
    required this.day,
    required this.breakfast,
    required this.brunch,
    required this.dinner,
    required this.lunch,
  });

  factory MyOperatingHours.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MyOperatingHours(
      day: doc.id,
      breakfast: data['Breakfast'] ?? {'isClosed': true},
      brunch: data['Brunch'] ?? {'isClosed': true},
      dinner: data['Dinner'] ?? {'isClosed': true},
      lunch: data['Lunch'] ?? {'isClosed': true},
    );
  }
}
