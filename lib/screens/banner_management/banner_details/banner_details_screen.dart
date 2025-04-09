import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savrly/widgets/customheader_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/text_styles.dart';
import '../../../controllers/banner_controller.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../widgets/button.dart';

class BannerDetailsScreen extends StatelessWidget {
  final drawerController = Get.put(DrawerControllerX());
  final controller = Get.put(BannerController());
  BannerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    double screenWidth = size.width;
    double screenHeight = size.height;
    bool isLargeScreen = screenWidth > 1600;

    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth <= 900;
    bool isDesktop = screenWidth > 900;

    // Adjust padding based on view
    double paddingValue = isMobile ? 16 : (isTablet ? 20 : 24);

    // Define container dimensions as a percentage of screen size
    double containerWidth =
        screenWidth * (isMobile ? 0.8 : (isTablet ? 0.8 : 0.5));
    double containerHeight =
        screenHeight * (isMobile ? 0.32 : (isTablet ? 0.32 : 0.32));
    double buttonTextSize = isMobile ? 11 : 16;
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
            CustomHeaderWidget(
              title: 'View Banner',
              back: true,
              onBackTap: () {
                drawerController.viewBannerDetails.value = false;
              },
              end: true,
              endWidget: CustomButton(
                laBelText: 'Edit',


                fontSize: buttonTextSize,
                width: isLargeScreen?200:isMobile ? 120 :162,
                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                shadow: [],
                containerColor: primaryColor,
                ontapp: () {
                  controller.isFromEdit.value=true;
                  drawerController.viewBannerDetails.value = false;
                  drawerController.addBanner.value = true;
                },
              ) ,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 20),
              child: Text(
                'Banner Image',
                style: headingText.copyWith(
                  fontSize: isLargeScreen
                      ? 24
                      : (isMobile ? 14 : (isTablet ? 18 : 20)),
                  fontFamily: GoogleFonts.nunitoSans().fontFamily,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 20),
              child: Container(
                width:
                    isLargeScreen ? 600 : 460, // Fixed width as per your code
                height: isLargeScreen
                    ? 200
                    : containerHeight, // Height set using MediaQuery
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      isMobile ? 10 : (isTablet ? 10 : 10)),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/banner_img.png'),
                    fit: BoxFit.cover, // Ensure the image covers the container
                  ),
                ),
                // Add content inside the container if needed
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 20),
              child: Text(
                'Title',
                style: headingText.copyWith(
                  fontSize: isLargeScreen
                      ? 24
                      : (isMobile ? 14 : (isTablet ? 18 : 20)),
                  fontFamily: GoogleFonts.nunitoSans().fontFamily,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 8),
              child: Text(
                'Title',
                style: simpleText.copyWith(
                  fontSize: isLargeScreen
                      ? 24
                      : (isMobile ? 12 : (isTablet ? 14 : 16)),
                  fontFamily: GoogleFonts.nunitoSans().fontFamily,
                ),
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 20),
                      child: Text(
                        'Start Date',
                        style: headingText.copyWith(
                          fontSize: isLargeScreen
                              ? 24
                              : (isMobile ? 14 : (isTablet ? 18 : 20)),
                          fontFamily: GoogleFonts.nunitoSans().fontFamily,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 8),
                      child: Text(
                        '2023-06-01',
                        style: simpleText.copyWith(
                          fontSize: isLargeScreen
                              ? 24
                              : (isMobile ? 12 : (isTablet ? 14 : 16)),
                          fontFamily: GoogleFonts.nunitoSans().fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 150),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 20),
                      child: Text(
                        'End Date',
                        style: headingText.copyWith(
                          fontSize: isLargeScreen
                              ? 24
                              : (isMobile ? 14 : (isTablet ? 18 : 20)),
                          fontFamily: GoogleFonts.nunitoSans().fontFamily,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 8),
                      child: Text(
                        '2023-06-01',
                        style: simpleText.copyWith(
                          fontSize: isLargeScreen
                              ? 24
                              : (isMobile ? 12 : (isTablet ? 14 : 16)),
                          fontFamily: GoogleFonts.nunitoSans().fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 20),
                      child: Text(
                        'State',
                        style: headingText.copyWith(
                          fontSize: isLargeScreen
                              ? 24
                              : (isMobile ? 14 : (isTablet ? 18 : 20)),
                          fontFamily: GoogleFonts.nunitoSans().fontFamily,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 8),
                      child: Text(
                        'KS',
                        style: simpleText.copyWith(
                          fontSize: isLargeScreen
                              ? 24
                              : (isMobile ? 12 : (isTablet ? 14 : 16)),
                          fontFamily: GoogleFonts.nunitoSans().fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    width: isMobile
                        ? 185
                        : isLargeScreen
                            ? 230
                            : 195),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 20),
                      child: Text(
                        'City',
                        style: headingText.copyWith(
                          fontSize: isLargeScreen
                              ? 24
                              : (isMobile ? 14 : (isTablet ? 18 : 20)),
                          fontFamily: GoogleFonts.nunitoSans().fontFamily,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 8),
                      child: Text(
                        'California',
                        style: simpleText.copyWith(
                          fontSize: isLargeScreen
                              ? 24
                              : (isMobile ? 12 : (isTablet ? 14 : 16)),
                          fontFamily: GoogleFonts.nunitoSans().fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
