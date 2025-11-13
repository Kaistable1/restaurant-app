import 'dart:ui'; // Required for ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kaistable_website/constants/app_colors.dart';

class EventDetailsGallery extends StatelessWidget {
  EventDetailsGallery({super.key, required this.imageList});
  List<String> imageList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              height: 16,
              width: 16,
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
              child: Icon(
                Icons.arrow_back,
                size: 18,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
        title: const Text(
          'Event Details',
          style: TextStyle(
            fontSize: 17,
            color: AppColors.headingTextColor,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito-Bold',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: MasonryGridView.count(
          padding: EdgeInsets.only(bottom: 20),
          crossAxisCount: 2, // 2 columns for staggered effect
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showImageDialog(context, imageList[index]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(imageList[index], fit: BoxFit.cover),
              ),
            );
          },
        ),
      ),
    );
  }

  // Show Dialog Function with Back Button
  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: true, // Close dialog when tapping outside
      builder: (context) {
        return Stack(
          children: [
            // Blurred Background
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2,
                  sigmaY: 2,
                ), // Blur intensity
                child: Container(
                  color: Colors.black.withOpacity(0.1), // Dark overlay effect
                ),
              ),
            ),

            // Image Dialog with Back Button
            Center(
              child: Stack(
                children: [
                  // Image Container
                  Container(
                    width: 340, // Adjust width
                    height: 640, // Fixed height
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(imagePath, fit: BoxFit.cover),
                    ),
                  ),

                  // Back Button Positioned at Top-Left
                  Positioned(
                    top: 10,
                    left: 10,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColors.primaryColor,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
