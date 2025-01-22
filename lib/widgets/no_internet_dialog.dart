import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showNoInternetDialog() {
  showDialog(
    context: Get.context!,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Add rounded corners
      backgroundColor: Colors.grey[200], // Set a pleasant background color
      title: const Center(
        child: Text(
          "Oops, No Internet!", // Use a friendly title
          style: TextStyle(fontSize: 20, color: Colors.black87),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 15),
          const Text(
            "We can't reach the internet right now. Please check your connection and try again.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            "Try Again",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    ),
  );
}