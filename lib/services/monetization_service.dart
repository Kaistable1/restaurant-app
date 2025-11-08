import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaistable_website/models/badge_model.dart';
import 'package:kaistable_website/models/transaction_model.dart';

class MonetizationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection references
  CollectionReference get _badgesCollection => _firestore.collection('badges');
  CollectionReference get _transactionsCollection => _firestore.collection('transactions');
  CollectionReference get _userBadgesCollection => _firestore.collection('userBadges');

  // Get available badges
  Stream<List<BadgeModel>> getAvailableBadges() {
    return _badgesCollection
        .where('isActive', isEqualTo: true)
        .orderBy('price', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BadgeModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Purchase a badge (creates transaction record)
  Future<String?> purchaseBadge({
    required String badgeID,
    required double amount,
    required String paymentMethod,
  }) async {
    try {
      final currentUserID = _auth.currentUser?.uid;
      if (currentUserID == null) return null;

      final docRef = _transactionsCollection.doc();
      final transaction = TransactionModel(
        transactionID: docRef.id,
        userID: currentUserID,
        type: 'badge_purchase',
        itemID: badgeID,
        amount: amount,
        currency: 'USD',
        paymentMethod: paymentMethod,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await docRef.set(transaction.toFirestore());
      
      // TODO: Integrate with actual payment gateway (Stripe/PayPal)
      // For now, this is a placeholder
      
      return transaction.transactionID;
    } catch (e) {
      print('Error purchasing badge: $e');
      return null;
    }
  }

  // Send a tip to another user
  Future<String?> sendTip({
    required String recipientUserID,
    required double amount,
    required String paymentMethod,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final currentUserID = _auth.currentUser?.uid;
      if (currentUserID == null) return null;

      final docRef = _transactionsCollection.doc();
      final transaction = TransactionModel(
        transactionID: docRef.id,
        userID: currentUserID,
        recipientUserID: recipientUserID,
        type: 'tip',
        amount: amount,
        currency: 'USD',
        paymentMethod: paymentMethod,
        status: 'pending',
        createdAt: DateTime.now(),
        metadata: metadata,
      );

      await docRef.set(transaction.toFirestore());
      
      // TODO: Integrate with actual payment gateway (Stripe/PayPal)
      
      return transaction.transactionID;
    } catch (e) {
      print('Error sending tip: $e');
      return null;
    }
  }

  // Get user's transaction history
  Stream<List<TransactionModel>> getUserTransactions() {
    final currentUserID = _auth.currentUser?.uid;
    if (currentUserID == null) {
      return Stream.value([]);
    }

    return _transactionsCollection
        .where('userID', isEqualTo: currentUserID)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Complete a transaction (called after payment gateway confirmation)
  Future<bool> completeTransaction(String transactionID, String paymentIntentID) async {
    try {
      await _transactionsCollection.doc(transactionID).update({
        'status': 'completed',
        'completedAt': DateTime.now(),
        'paymentIntentID': paymentIntentID,
      });
      return true;
    } catch (e) {
      print('Error completing transaction: $e');
      return false;
    }
  }

  // Stripe payment integration stub
  Future<Map<String, dynamic>> createStripePaymentIntent({
    required double amount,
    required String currency,
  }) async {
    // TODO: Integrate with Stripe API
    // This would call Stripe's createPaymentIntent endpoint
    // For now, return a mock response
    
    return {
      'clientSecret': 'mock_client_secret_${DateTime.now().millisecondsSinceEpoch}',
      'paymentIntentID': 'mock_pi_${DateTime.now().millisecondsSinceEpoch}',
      'status': 'pending',
    };
  }

  // PayPal payment integration stub
  Future<Map<String, dynamic>> createPayPalOrder({
    required double amount,
    required String currency,
  }) async {
    // TODO: Integrate with PayPal API
    // This would call PayPal's create order endpoint
    // For now, return a mock response
    
    return {
      'orderID': 'mock_order_${DateTime.now().millisecondsSinceEpoch}',
      'approvalUrl': 'https://paypal.com/mock-approval',
      'status': 'pending',
    };
  }
}
