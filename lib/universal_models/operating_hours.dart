import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimeSlot {
  final bool isClosed;
  final String? startTime;
  final String? endTime;

  TimeSlot({
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

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      isClosed: map['isClosed'] ?? true,
      startTime: map['startTime'],
      endTime: map['endTime'],
    );
  }
}

class OperatingHours {
  final Map<String, TimeSlot> timeSlots;

  OperatingHours({required this.timeSlots});

  Map<String, dynamic> toMap() {
    return timeSlots.map((key, value) => MapEntry(key, value.toMap()));
  }

  factory OperatingHours.fromMap(Map<String, dynamic> map) {
    return OperatingHours(
      timeSlots: map.map(
        (key, value) =>
            MapEntry(key, TimeSlot.fromMap(value as Map<String, dynamic>)),
      ),
    );
  }
}

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
