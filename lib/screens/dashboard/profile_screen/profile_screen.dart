import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savrly/constants/app_colors.dart';

import '../../../constants/text_styles.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../widgets/customheader_widget.dart';
import '../../../widgets/profile_tab_widget.dart';
import 'change_password_section.dart';
import 'edit_profile_section.dart';

class ProfileScreen extends StatelessWidget {
  final drawerController = Get.put(DrawerControllerX());
  final controller = Get.put(ProfileController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getProfile();

    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 600;

    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;
    double paddingValue = mobileView ? 16 : 24;

    return Padding(
      padding: EdgeInsets.all(paddingValue),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeaderWidget(
              title: 'Profile',
              back: true,
              onBackTap: () {
                drawerController.showProfile.value = false;
              },
            ),
            SizedBox(height: isMobile ? 16 : 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Stack(
                children: [
                  Container(width: Get.width, height: 800),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/profile_top_img.png',
                      height: isMobile ? 220 : 289,
                      width: isMobile ? 600 : size.width * 0.6,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: isMobile ? 12 : 20,
                    top: isMobile ? 170 : 230,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: isMobile ? 222 : 246,
                          width: isMobile ? 171 : size.width * 0.14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Obx(() {
                                    if (kIsWeb &&
                                        controller.uploadedImage.value !=
                                            null) {
                                      return ClipOval(
                                        child: Image.memory(
                                          controller.uploadedImage.value!,
                                          height: isMobile ? 62 : 78,
                                          width: isMobile ? 62 : 78,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else {
                                      return ClipOval(
                                        child: controller.profile.value?.img !=
                                                null
                                            ? Image.network(
                                                controller.profile.value!.img!,
                                                height: isMobile ? 62 : 78,
                                                width: isMobile ? 62 : 78,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/images/profile_img.png',
                                                height: isMobile ? 62 : 78,
                                                width: isMobile ? 62 : 78,
                                                fit: BoxFit.cover,
                                              ),
                                      );
                                    }
                                  }),
                                  Positioned(
                                    left: isMobile ? 48 : 54,
                                    top: isMobile ? 40 : 50,
                                    child: InkWell(
                                      onTap: controller.pickImageWeb,
                                      child: Image.asset(
                                        'assets/images/cam_icon.png',
                                        height: isMobile ? 16 : 24,
                                        width: isMobile ? 16 : 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Obx(
                                () => Text(
                                  controller.profile.value?.name ?? '',
                                  style: simpleText.copyWith(
                                    fontSize: 14,
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 6),
                              Obx(
                                () => Text(
                                  controller.profile.value?.email ?? '',
                                  style: simpleText.copyWith(
                                    fontSize: 14,
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    fontWeight: FontWeight.w500,
                                    color: secondaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Phone number',
                                style: simpleText.copyWith(
                                  fontSize: 14,
                                  fontFamily:
                                      GoogleFonts.nunitoSans().fontFamily,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 6),
                              Obx(
                                () => Text(
                                    controller.profile.value?.contact ?? '',
                                    style: simpleText.copyWith(
                                      fontSize: 14,
                                      fontFamily:
                                          GoogleFonts.nunitoSans().fontFamily,
                                      fontWeight: FontWeight.w500,
                                      color: secondaryColor,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: isMobile ? 8 : 16),
                        Container(
                          height: isMobile ? 400 : 558,
                          width:
                              isMobile ? size.width * 0.5 : size.width * 0.38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            // Removed Expanded here
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 22),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(
                                      () => GestureDetector(
                                        onTap: () {
                                          controller.editProfileView.value = 0;
                                        },
                                        child: profileTabWidget(
                                          context: context,
                                          text: "Edit profile",
                                          index: 0,
                                          selectIndex:
                                              controller.editProfileView.value,
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      flex: 1,
                                      child: SizedBox(),
                                    ),
                                    Obx(
                                      () => GestureDetector(
                                        onTap: () {
                                          controller.editProfileView.value = 1;
                                        },
                                        child: profileTabWidget(
                                          context: context,
                                          text: "Change Password",
                                          index: 1,
                                          selectIndex:
                                              controller.editProfileView.value,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8), // Added spacing
                              const Divider(
                                color: primaryColor,
                                thickness: 0.2,
                                height: 1,
                              ),
                              Expanded(
                                // Moved Expanded here to take remaining space
                                child: Obx(
                                  () => controller.editProfileView.value == 0
                                      ? EditProfileSection()
                                      : ChangePasswordSection(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 16 : 32),
          ],
        ),
      ),
    );
  }
}
