import 'package:cloud_firestore/cloud_firestore.dart';

class RecentViewModel {
  String recentViewID;
  String restaurantID;
  String userID;
  String userName;
  DateTime dateTime;

  // Constructor
  RecentViewModel({
    required this.recentViewID,
    required this.restaurantID,
    required this.userID,
    required this.userName,
    required this.dateTime,
  });

  // Factory method to create a RecentViewModel from a Firestore document (Map)
  factory RecentViewModel.fromMap(Map<String, dynamic> map) {
    return RecentViewModel(
      recentViewID: map['recentViewID'] ?? '',
      restaurantID: map['restaurantID'] ?? '',
      userID: map['userID'] ?? '',
      userName: map['userName'] ?? '',
      dateTime: (map['dateTime'] as Timestamp)
          .toDate(), // Convert Timestamp to DateTime
    );
  }

  // Method to convert the model to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'recentViewID': recentViewID,
      'restaurantID': restaurantID,
      'userID': userID,
      'userName': userName,
      'dateTime': Timestamp.fromDate(dateTime), // Convert DateTime to Timestamp
    };
  }
}
