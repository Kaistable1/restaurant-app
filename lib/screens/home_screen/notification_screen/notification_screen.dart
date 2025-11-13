import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/main.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  Stream<QuerySnapshot> getUserNotificationsStream(String userId) {
    final notificationsRef = FirebaseFirestore.instance.collection(
      'notifications',
    );

    return notificationsRef
        .where('createdAt', isGreaterThan: Timestamp(0, 0))
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> deleteAllNotifications(String userID) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (data['userID'] == userID || data['IsAllForUser'] == true) {
        batch.delete(doc.reference);
      }
    }

    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    final userID = currentUserDataModel!.value.token;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.arrow_back,
                size: 18,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 17,
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito-Bold',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.primaryColor),
            onPressed: () async {
              final confirm = await Get.dialog<bool>(
                AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text(
                    'Are you sure you want to delete all notifications?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Get.back(result: true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await deleteAllNotifications(userID!);
                Get.snackbar(
                  'Deleted',
                  'All notifications deleted',
                  backgroundColor: Colors.white,
                  colorText: Colors.black,
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getUserNotificationsStream(userID!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No notifications yet. Check back later!',
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito-Bold',
                ),
              ),
            );
          }

          final notifications = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['userID'] == userID || data['IsAllForUser'] == true;
          }).toList();

          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                'No notifications for you yet!',
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito-Bold',
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = notifications[index].data() as Map<String, dynamic>;
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Nunito-Bold',
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data['message'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Nunito-Regular',
                        color: AppColors.bottomSheetColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (data['createdAt'] != null)
                      Text(
                        (data['createdAt'] as Timestamp).toDate().toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: 'Nunito-Regular',
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
