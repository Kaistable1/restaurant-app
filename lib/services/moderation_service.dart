import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaistable_website/models/report_model.dart';
import 'package:kaistable_website/models/blocked_user_model.dart';

class ModerationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection references
  CollectionReference get _reportsCollection =>
      _firestore.collection('reports');
  CollectionReference get _blockedUsersCollection =>
      _firestore.collection('blockedUsers');

  // Submit a report
  Future<String?> submitReport(ReportModel report) async {
    try {
      final docRef = _reportsCollection.doc();
      report.reportID = docRef.id;
      report.createdAt = DateTime.now();
      report.status = 'pending';

      await docRef.set(report.toFirestore());
      return report.reportID;
    } catch (e) {
      print('Error submitting report: $e');
      return null;
    }
  }

  // Get all pending reports (for admin)
  Stream<List<ReportModel>> getPendingReports() {
    return _reportsCollection
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              ReportModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get all reports (for admin)
  Stream<List<ReportModel>> getAllReports({String? status}) {
    Query query = _reportsCollection.orderBy('createdAt', descending: true);

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              ReportModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Review a report (admin action)
  Future<bool> reviewReport(
    String reportID,
    String resolution,
    String status,
  ) async {
    try {
      final currentUserID = _auth.currentUser?.uid;
      if (currentUserID == null) return false;

      await _reportsCollection.doc(reportID).update({
        'status': status,
        'resolution': resolution,
        'reviewedBy': currentUserID,
        'reviewedAt': DateTime.now(),
      });
      return true;
    } catch (e) {
      print('Error reviewing report: $e');
      return false;
    }
  }

  // Block a user
  Future<String?> blockUser(String blockedUserID, String blockedUserName,
      {String? reason}) async {
    try {
      final currentUserID = _auth.currentUser?.uid;
      if (currentUserID == null) return null;

      // Check if already blocked
      final existingBlock = await _blockedUsersCollection
          .where('blockedByUserID', isEqualTo: currentUserID)
          .where('blockedUserID', isEqualTo: blockedUserID)
          .get();

      if (existingBlock.docs.isNotEmpty) {
        return existingBlock.docs.first.id;
      }

      final docRef = _blockedUsersCollection.doc();
      final blockModel = BlockedUserModel(
        blockID: docRef.id,
        blockedByUserID: currentUserID,
        blockedUserID: blockedUserID,
        blockedUserName: blockedUserName,
        createdAt: DateTime.now(),
        reason: reason,
      );

      await docRef.set(blockModel.toFirestore());
      return blockModel.blockID;
    } catch (e) {
      print('Error blocking user: $e');
      return null;
    }
  }

  // Unblock a user
  Future<bool> unblockUser(String blockedUserID) async {
    try {
      final currentUserID = _auth.currentUser?.uid;
      if (currentUserID == null) return false;

      final blockDocs = await _blockedUsersCollection
          .where('blockedByUserID', isEqualTo: currentUserID)
          .where('blockedUserID', isEqualTo: blockedUserID)
          .get();

      for (var doc in blockDocs.docs) {
        await doc.reference.delete();
      }
      return true;
    } catch (e) {
      print('Error unblocking user: $e');
      return false;
    }
  }

  // Get blocked users for current user
  Stream<List<BlockedUserModel>> getBlockedUsers() {
    final currentUserID = _auth.currentUser?.uid;
    if (currentUserID == null) {
      return Stream.value([]);
    }

    return _blockedUsersCollection
        .where('blockedByUserID', isEqualTo: currentUserID)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BlockedUserModel.fromFirestore(
              doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Check if a user is blocked
  Future<bool> isUserBlocked(String userID) async {
    try {
      final currentUserID = _auth.currentUser?.uid;
      if (currentUserID == null) return false;

      final blockDocs = await _blockedUsersCollection
          .where('blockedByUserID', isEqualTo: currentUserID)
          .where('blockedUserID', isEqualTo: userID)
          .limit(1)
          .get();

      return blockDocs.docs.isNotEmpty;
    } catch (e) {
      print('Error checking block status: $e');
      return false;
    }
  }
}
