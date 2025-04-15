import 'dart:ui'; // Required for ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:savrly/controllers/add_event_controller.dart';

import '../../../../constants/app_colors.dart';
import '../../../../controllers/drawer_controller.dart';
import '../../../../controllers/event_management_controller.dart';
import '../../../../widgets/customheader_widget.dart';

class EventDetailsGallery extends StatelessWidget {
  final controller = Get.put(EventManagementController());
  final drawerController = Get.put(DrawerControllerX());
  final addController = Get.put(AddEventController());

  EventDetailsGallery({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions using MediaQuery
    final size = MediaQuery.of(context).size;

    double screenWidth = size.width;
    double screenHeight = size.height;
    bool isLargeScreen = screenWidth > 1600;
    // Define view breakpoints
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth <= 900;

    // Adjust padding based on view
    double paddingValue = isMobile ? 16 : (isTablet ? 20 : 24);

    List<String> imageList = addController.selectedEventModel?.imageUrls ?? [];

    return Padding(
      padding: EdgeInsets.only(
        right: paddingValue,
        top: paddingValue,
        left: paddingValue,
        bottom: paddingValue,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header Widget
            CustomHeaderWidget(
              title: 'Event details',
              back: true,
              onBackTap: () {
                drawerController.viewEventsGallery.value = false;
              },
            ),
            const SizedBox(height: 30),
            // Masonry Grid View for Images
            SizedBox(
              width: isLargeScreen ? 800 : 600,
              child: MasonryGridView.count(
                padding: const EdgeInsets.only(bottom: 20),
                crossAxisCount: 2, // 2 columns for staggered effect
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                itemCount: imageList.length,
                shrinkWrap:
                    true, // Allow the grid to take only the space it needs
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling in the grid
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showImageDialog(context, imageList[index]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageList[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show Dialog Function with Back Button
  void _showImageDialog(BuildContext context, String imagePath) {
    final size = MediaQuery.of(context).size;

    double screenWidth = size.width;
    bool isLargeScreen = screenWidth > 1600;
    showDialog(
      context: context,
      barrierDismissible: true, // Close dialog when tapping outside
      builder: (context) {
        return Stack(
          children: [
            // Blurred Background
            Positioned.fill(
              child: BackdropFilter(
                filter:
                    ImageFilter.blur(sigmaX: 2, sigmaY: 2), // Blur intensity
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: Get.width * 0.7, // Adjust width
                      height: Get.height * 0.8, // Fixed height
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Back Button Positioned at Top-Left
                  Positioned(
                    top: 10,
                    left: 10,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.close, color: primaryColor, size: 22),
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
