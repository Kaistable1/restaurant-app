import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => ListView.builder(
              itemCount: controller.restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = controller.restaurants[index];
                return _buildRestaurantCard(restaurant);
              },
            )),
      ),
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
