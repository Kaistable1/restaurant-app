import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savrly/models/banner_model.dart';
import 'package:savrly/widgets/customheader_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/text_styles.dart';
import '../../../controllers/banner_controller.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../widgets/button.dart';

class BannerDetailsScreen extends StatelessWidget {
  final drawerController = Get.find<DrawerControllerX>();
  final controller = Get.find<BannerController>();

  BannerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    double screenHeight = size.height;
    bool isLargeScreen = screenWidth > 1600;
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth <= 900;

    double paddingValue = isMobile ? 16 : (isTablet ? 20 : 24);
    double containerWidth =
        screenWidth * (isMobile ? 0.8 : (isTablet ? 0.8 : 0.5));
    double containerHeight =
        screenHeight * (isMobile ? 0.32 : (isTablet ? 0.32 : 0.32));
    double buttonTextSize = isMobile ? 11 : 16;

    return Padding(
      padding: EdgeInsets.all(paddingValue),
      child: SingleChildScrollView(
        child: Obx(() {
          final index = controller.viewingBannerIndex.value;
          if (index < 0 || index >= controller.bannerList.length) {
            return const Center(child: Text('No banner selected'));
          }
          final banner = controller.bannerList[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeaderWidget(
                title: 'View Banner',
                back: true,
                onBackTap: () {
                  drawerController.viewBannerDetails.value = false;
                  controller.clearInputs(); // Reset view index
                },
                end: true,
                endWidget: CustomButton(
                  laBelText: 'Edit',
                  fontSize: buttonTextSize,
                  width: isLargeScreen ? 200 : (isMobile ? 120 : 162),
                  fontFamily: GoogleFonts.nunitoSans().fontFamily,
                  shadow: [],
                  containerColor: primaryColor,
                  ontapp: () {
                    controller.loadBannerForEdit(index);
                    controller.isFromEdit.value = true;
                    drawerController.viewBannerDetails.value = false;
                    drawerController.addBanner.value = true;
                  },
                ),
              ),
              const SizedBox(height: 50),
              Text(
                'Banner Image',
                style: headingText.copyWith(
                  fontSize: isLargeScreen
                      ? 24
                      : (isMobile ? 14 : (isTablet ? 18 : 20)),
                  fontFamily: GoogleFonts.nunitoSans().fontFamily,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: isLargeScreen ? 600 : 460,
                height: isLargeScreen ? 200 : containerHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      isMobile ? 10 : (isTablet ? 10 : 10)),
                  image: DecorationImage(
                    image: NetworkImage(banner.bannerImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Title',
                style: headingText.copyWith(
                  fontSize: isLargeScreen
                      ? 24
                      : (isMobile ? 14 : (isTablet ? 18 : 20)),
                  fontFamily: GoogleFonts.nunitoSans().fontFamily,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                banner.title,
                style: simpleText.copyWith(
                    fontSize: isLargeScreen
                        ? 24
                        : (isMobile ? 12 : (isTablet ? 14 : 16)),
                    fontFamily: GoogleFonts.nunitoSans().fontFamily,
                    color: secondaryColor),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DoubleTextWidget(
                          isLargeScreen: isLargeScreen,
                          isMobile: isMobile,
                          isTablet: isTablet,
                          firstText: 'Start Date',
                          secondText: banner.startDate,
                        ),
                        SizedBox(height: 16,),
                        DoubleTextWidget(
                          isLargeScreen: isLargeScreen,
                          isMobile: isMobile,
                          isTablet: isTablet,
                          firstText: 'State',
                          secondText: banner.state,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: isMobile ? 185 : (isLargeScreen ? 230 : 195)),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DoubleTextWidget(
                          isLargeScreen: isLargeScreen,
                          isMobile: isMobile,
                          isTablet: isTablet,
                          firstText: 'End Date',
                          secondText: banner.endDate,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        DoubleTextWidget(
                          isLargeScreen: isLargeScreen,
                          isMobile: isMobile,
                          isTablet: isTablet,
                          firstText: 'City',
                          secondText: banner.city,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
            ],
          );
        }),
      ),
    );
  }
}

class DoubleTextWidget extends StatelessWidget {
  const DoubleTextWidget({
    super.key,
    required this.isLargeScreen,
    required this.isMobile,
    required this.isTablet,
    required this.firstText,
    required this.secondText,
  });

  final bool isLargeScreen;
  final bool isMobile;
  final bool isTablet;
  final String firstText;
  final String secondText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          firstText,
          style: headingText.copyWith(
            fontSize:
                isLargeScreen ? 24 : (isMobile ? 14 : (isTablet ? 18 : 20)),
            fontFamily: GoogleFonts.nunitoSans().fontFamily,
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(top: 12),
          child: Text(
            secondText,
            style: simpleText.copyWith(
                fontSize:
                    isLargeScreen ? 22: (isMobile ? 12 : (isTablet ? 14 : 16)),
                fontFamily: GoogleFonts.nunitoSans().fontFamily,
                color: secondaryColor),
          ),
        ),
      ],
    );
  }
}
