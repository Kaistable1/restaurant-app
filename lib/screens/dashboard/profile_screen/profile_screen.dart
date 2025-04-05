import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savrly/constants/app_colors.dart';

import '../../../constants/text_styles.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../widgets/button.dart';
import '../../../widgets/profile_tab_widget.dart';
import 'change_password_section.dart';
import 'edit_profile_section.dart';

class ProfileScreen extends StatelessWidget {
  final drawerController = Get.put(DrawerControllerX());
  final controller = Get.put(ProfileController());
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 600;

    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1600;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: isMobile ? 10 : 26,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          drawerController.showProfile.value = false;
                        },
                        child: Container(
                          height: isMobile ? 36 : 42,
                          width: isMobile ? 36 : 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // subtle shadow
                                blurRadius: 8, // how soft the shadow is
                                offset: Offset(
                                    0, 4), // horizontal & vertical offset
                              ),
                            ],
                          ),
                          child: Icon(Icons.arrow_back, color: primaryColor),
                        ),
                      ),
                      SizedBox(
                        width: isMobile ? 12 : 18,
                      ),
                      Text(
                        'Profile',
                        style:
                            headingText.copyWith(fontSize: isMobile ? 22 : 34),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: isMobile ? 16 : 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Stack(
                children: [
                  Container(
                    width: Get.width,
                    height: 800,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/images/profile_top_img.png',
                        height: isMobile ? 220 : 289,
                        width: isMobile ? 600 : size.width * 0.6,
                        fit: BoxFit.cover),
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
                                color: Colors.black
                                    .withOpacity(0.1), // subtle shadow
                                blurRadius: 8, // how soft the shadow is
                                offset: Offset(
                                    0, 4), // horizontal & vertical offset
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
                                        controller.webImageBytes.value !=
                                            null) {
                                      return ClipOval(
                                        child: Image.memory(
                                          controller.webImageBytes.value!,
                                          height: isMobile ? 62 : 78,
                                          width: isMobile ? 62 : 78,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else if (!kIsWeb &&
                                        controller.pickedImage.value != null) {
                                      return ClipOval(
                                        child: Image.file(
                                          controller.pickedImage.value!,
                                          height: isMobile ? 62 : 78,
                                          width: isMobile ? 62 : 78,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else {
                                      return ClipOval(
                                        child: Image.asset(
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
                                        onTap: controller.pickImageFromPC,
                                        child: Image.asset(
                                          'assets/images/cam_icon.png',
                                          height: isMobile ? 16 : 24,
                                          width: isMobile ? 16 : 24,
                                        ),
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                'Guy Hawkins',
                                style: simpleText.copyWith(
                                    fontSize: 14,
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                'Guy@gmail.com',
                                style: simpleText.copyWith(
                                    fontSize: 14,
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    fontWeight: FontWeight.w500,
                                    color: secondaryColor),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Phone number',
                                style: simpleText.copyWith(
                                    fontSize: 14,
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                '+71 737373464',
                                style: simpleText.copyWith(
                                    fontSize: 14,
                                    fontFamily:
                                        GoogleFonts.nunitoSans().fontFamily,
                                    fontWeight: FontWeight.w500,
                                    color: secondaryColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: isMobile ? 8 : 16,
                        ),
                        Container(
                          height: isMobile ? 400 : 558,
                          width:
                              isMobile ? size.width * 0.5 : size.width * 0.38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // subtle shadow
                                blurRadius: 8, // how soft the shadow is
                                offset: Offset(
                                    0, 4), // horizontal & vertical offset
                              ),
                            ],
                          ),
                          child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 22,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(
                                        () => GestureDetector(
                                          onTap: () {
                                            controller.editProfileView.value =
                                                0;
                                          },
                                          child: profileTabWidget(
                                            context: context,
                                            text: "Edit profile",
                                            index: 0,
                                            selectIndex: controller
                                                .editProfileView.value,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                          flex: 1, child: SizedBox()),
                                      Obx(
                                        () => GestureDetector(
                                          onTap: () {
                                            controller.editProfileView.value =
                                                1;
                                          },
                                          child: profileTabWidget(
                                            context: context,
                                            text: "Change Password",
                                            index: 1,
                                            selectIndex: controller
                                                .editProfileView.value,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //divider
                                const SizedBox(),
                                const Divider(
                                  color: primaryColor,
                                  thickness: 0.2,
                                  height: 1,
                                ),
                                Expanded(
                                  child: Obx(() =>
                                      controller.editProfileView.value == 0
                                          ? EditProfileSection()
                                          : ChangePasswordSection()),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: isMobile ? 16 : 32,
            ),
          ],
        ),
      ),
    );
  }
}
