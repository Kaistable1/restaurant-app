import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:savrly_data_entry_app/constants/app_colors.dart';
import 'package:savrly_data_entry_app/constants/text_styles.dart';

import 'controller/history_controller.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "History",
          style: headingText,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('history').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No history found."));
            }
            controller.restaurants.clear();
            for (var doc in snapshot.data!.docs) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              String searchText = data['searchText'] ?? 'N/A';
              Timestamp timestamp = data['createdAt'] as Timestamp;
              DateTime dateTime = timestamp.toDate();
              controller.restaurants.add({
                "name": searchText,
                "date": DateFormat('dd MMMM yyyy hh:mm a').format(dateTime),
                "image": "assets/images/mumbai.png"
              });
            }
            controller.restaurants
                .sort((a, b) => b["date"]!.compareTo(a["date"]!));

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() => ListView.builder(
                    itemCount: controller.restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = controller.restaurants[index];
                      return _buildRestaurantCard(restaurant);
                    },
                  )),
            );
          }),
    );
  }

  Widget _buildRestaurantCard(Map<String, String> restaurant) {
    return Card(
      color: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            restaurant["image"]!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(restaurant["name"]!,
            style: subHeadingText.copyWith(fontWeight: FontWeight.w900)),
        subtitle: Text(restaurant["date"]!, style: hintText),
        onTap: () {},
      ),
    );
  }
}
