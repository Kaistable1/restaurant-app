import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savrly/controllers/add_event_controller.dart';
import 'package:savrly/models/event.dart';
import 'package:savrly/widgets/map_widget.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/text_styles.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../controllers/event_management_controller.dart';
import '../../../widgets/customheader_widget.dart';

class ViewEvent extends StatelessWidget {
  final controller = Get.put(EventManagementController());
  final addController = Get.put(AddEventController());
  final drawerController = Get.put(DrawerControllerX());

  ViewEvent({super.key});

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

    double containerHeight =
        screenHeight * (isMobile ? 0.38 : (isTablet ? 0.38 : 0.4));
    Event event = addController.selectedEventModel!;

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomHeaderWidget(
              title: 'Event details',
              back: true,
              onBackTap: () {
                drawerController.viewEvents.value = false;
              },
            ),
            const SizedBox(height: 30),
            Stack(
              children: [
                // Main container with background image
                Container(
                  width:
                      isLargeScreen ? 680 : 500, // Fixed width as per your code
                  height: isLargeScreen
                      ? 260
                      : containerHeight, // Height set using MediaQuery
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        isMobile ? 10 : (isTablet ? 10 : 10)),
                    image: DecorationImage(
                      image: NetworkImage(event.imageUrls.first),
                      fit:
                          BoxFit.cover, // Ensure the image covers the container
                    ),
                  ),
                  // Add content inside the container if needed
                ),
                // Small container positioned at the bottom center with blur effect
                Positioned(
                  bottom: 10, // Distance from the bottom edge
                  left: 0,
                  right: 0, // Stretch across the width to allow centering
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 5, sigmaY: 5), // Apply blur effect
                        child: InkWell(
                          onTap: () {
                            drawerController.viewEventsGallery.value = true;
                            drawerController.viewEvents.value = false;
                          },
                          child: Container(
                            height: 32,
                            width: 151,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white.withOpacity(
                                  0.3), // Semi-transparent white for glass effect
                            ),
                            child: Center(
                              child: Text(
                                'See all 8 photos',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily:
                                      GoogleFonts.nunitoSans().fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: Container(
                width: isLargeScreen ? 680 : 500,
                height:
                    isLargeScreen ? screenHeight * 0.48 : screenHeight * 0.74,
                decoration: BoxDecoration(
                  color: dimWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 20),
                      child: Text(
                        'Details',
                        style: headingText.copyWith(
                          fontSize: isLargeScreen
                              ? 24
                              : (isMobile ? 14 : (isTablet ? 18 : 20)),
                          fontFamily: GoogleFonts.nunitoSans().fontFamily,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Event name: ',
                              style: headingText.copyWith(
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 12 : 14)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                fontWeight: FontWeight
                                    .bold, // Example: Make "Event name" bold
                              ),
                            ),
                            TextSpan(
                              text: event.eventName,
                              style: headingText.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 11 : 13)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                color:
                                    secondaryColor, // Example: Make the colon grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Event type: ',
                              style: headingText.copyWith(
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 12 : 14)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                fontWeight: FontWeight
                                    .bold, // Example: Make "Event name" bold
                              ),
                            ),
                            TextSpan(
                              text: event.eventType,
                              style: headingText.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 11 : 13)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                color:
                                    secondaryColor, // Example: Make the colon grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Location: ',
                              style: headingText.copyWith(
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 12 : 14)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                fontWeight: FontWeight
                                    .bold, // Example: Make "Event name" bold
                              ),
                            ),
                            TextSpan(
                              text: event.location,
                              style: headingText.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 11 : 13)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                color:
                                    secondaryColor, // Example: Make the colon grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                        height: Get.height * 0.45,
                        child: MapWidget(
                          latitude: event.latitude,
                          longitude: event.longitude,
                        ))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: Container(
                width: isLargeScreen ? 680 : 500,
                height:
                    isLargeScreen ? screenHeight * 0.34 : screenHeight * 0.5,
                decoration: BoxDecoration(
                  color: dimWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 20),
                      child: Text(
                        'Additional details',
                        style: headingText.copyWith(
                          fontSize: isLargeScreen
                              ? 24
                              : (isMobile ? 14 : (isTablet ? 18 : 20)),
                          fontFamily: GoogleFonts.nunitoSans().fontFamily,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Date: ',
                              style: headingText.copyWith(
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 12 : 14)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                fontWeight: FontWeight
                                    .bold, // Example: Make "Event name" bold
                              ),
                            ),
                            TextSpan(
                              text: event.date,
                              style: headingText.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 11 : 13)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                color:
                                    secondaryColor, // Example: Make the colon grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Time: ',
                              style: headingText.copyWith(
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 12 : 14)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                fontWeight: FontWeight
                                    .bold, // Example: Make "Event name" bold
                              ),
                            ),
                            TextSpan(
                              text: event.time,
                              style: headingText.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 11 : 13)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                color:
                                    secondaryColor, // Example: Make the colon grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Phone: ',
                              style: headingText.copyWith(
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 12 : 14)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                fontWeight: FontWeight
                                    .bold, // Example: Make "Event name" bold
                              ),
                            ),
                            TextSpan(
                              text: event.phoneNumber,
                              style: headingText.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 11 : 13)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                color:
                                    secondaryColor, // Example: Make the colon grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'URL: ',
                              style: headingText.copyWith(
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 12 : 14)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                fontWeight: FontWeight
                                    .bold, // Example: Make "Event name" bold
                              ),
                            ),
                            TextSpan(
                              text: event.url,
                              style: headingText.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 11 : 13)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                color:
                                    secondaryColor, // Example: Make the colon grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Description: ',
                              style: headingText.copyWith(
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 12 : 14)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                fontWeight: FontWeight
                                    .bold, // Example: Make "Event name" bold
                              ),
                            ),
                            TextSpan(
                              text: event.description,
                              style: headingText.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: isLargeScreen
                                    ? 16
                                    : (isMobile ? 10 : (isTablet ? 11 : 13)),
                                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                color:
                                    secondaryColor, // Example: Make the colon grey
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 18,
            ),
          ],
        ),
      ),
    );
  }
}
