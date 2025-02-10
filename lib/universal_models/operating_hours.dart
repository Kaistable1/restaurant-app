import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class OperatingHour {
  final bool isClosed;
  final String? startTime;
  final String? endTime;

  OperatingHour({
    required this.isClosed,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'isClosed': isClosed,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory OperatingHour.fromMap(Map<String, dynamic> map) {
    return OperatingHour(
      isClosed: map['isClosed'] ?? true,
      startTime: map['startTime'],
      endTime: map['endTime'],
    );
  }
}

class OperatingHoursService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveOperatingHours(
      String day, String mealPeriod, OperatingHour hour) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception("User not logged in.");
    }
    print('fhvioh');
    await _firestore
        .collection('restaurants')
        .doc(uid)
        .collection(day)
        .doc(mealPeriod)
        .set(hour.toMap())
        .then(
      (value) {
        print('jbds');
      },
    );
  }
}
