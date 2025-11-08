import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String? transactionID;
  String? userID;
  String? type; // 'badge_purchase', 'tip', 'payment'
  String? itemID; // Badge ID or other item ID
  String? recipientUserID; // For tips
  double? amount;
  String? currency;
  String? paymentMethod; // 'stripe', 'paypal', etc.
  String? paymentIntentID; // External payment gateway reference
  String? status; // 'pending', 'completed', 'failed', 'refunded'
  DateTime? createdAt;
  DateTime? completedAt;
  Map<String, dynamic>? metadata;

  TransactionModel({
    this.transactionID,
    this.userID,
    this.type,
    this.itemID,
    this.recipientUserID,
    this.amount,
    this.currency,
    this.paymentMethod,
    this.paymentIntentID,
    this.status,
    this.createdAt,
    this.completedAt,
    this.metadata,
  });

  // Factory method to create a TransactionModel from Firestore document
  factory TransactionModel.fromFirestore(Map<String, dynamic> json) {
    return TransactionModel(
      transactionID: json['transactionID'],
      userID: json['userID'],
      type: json['type'],
      itemID: json['itemID'],
      recipientUserID: json['recipientUserID'],
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] ?? 'USD',
      paymentMethod: json['paymentMethod'],
      paymentIntentID: json['paymentIntentID'],
      status: json['status'] ?? 'pending',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      completedAt: (json['completedAt'] as Timestamp?)?.toDate(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  // Method to convert TransactionModel to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'transactionID': transactionID,
      'userID': userID,
      'type': type,
      'itemID': itemID,
      'recipientUserID': recipientUserID,
      'amount': amount,
      'currency': currency ?? 'USD',
      'paymentMethod': paymentMethod,
      'paymentIntentID': paymentIntentID,
      'status': status ?? 'pending',
      'createdAt': createdAt,
      'completedAt': completedAt,
      'metadata': metadata,
    };
  }
}
