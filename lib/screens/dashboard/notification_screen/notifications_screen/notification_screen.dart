import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/text_styles.dart';
import '../../../../controllers/drawer_controller.dart';
import '../../../../controllers/notification_controller.dart';
import '../../../../widgets/CustomDropDownWidget.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/customheader_widget.dart';

class NotificationScreen extends StatelessWidget {
  final drawerController = Get.put(DrawerControllerX());
  final controller = Get.put(NotificationController());

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double screenWidth = size.width;

    // Define view breakpoints
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth <= 900;
    bool isDesktop = screenWidth > 900;
    bool isLargeScreen = screenWidth > 1600;

    // Adjust padding based on view
    double paddingValue = isMobile ? 16 : (isTablet ? 20 : 24);
    double avatarSize = isMobile ? 48 : (isTablet ? 48 : 48);
    double fontSize = isMobile ? 14 : (isTablet ? 16 : 18);

    return Padding(
      padding: EdgeInsets.all(paddingValue),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeaderWidget(
              title: 'Notification',
              back: true,
              onBackTap: () {
                drawerController.showNotifications.value = false;
              },
              end: true,
              endWidget: CustomButton(
                ontapp: () {
                  drawerController.showCreateNotifications.value = true;
                },
                laBelText: 'New Notification',
                isPrefixIcon: true,
                iconWidget: Image.asset(
                  'assets/images/notification_icon.png',
                  color: Colors.white,
                  height: isMobile ? 14 : (isTablet ? 18 : 24),
                  width: isMobile ? 14 : (isTablet ? 18 : 24),
                ),
                width: isMobile ? 160 : (isTablet ? 200 : 234),
                height: isMobile ? 32 : (isTablet ? 40 : 48),
                fontSize: isMobile ? 12 : (isTablet ? 14 : 16),
              ),
            ),
            SizedBox(
              height: isMobile ? 16 : (isTablet ? 24 : 32),
            ),

            /// Filter Container
            Container(
              width: Get.width,
              height: isMobile
                  ? size.height * 0.99
                  : (isTablet ? size.height * 0.99 : size.height * 0.39),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isMobile ? 10 : (isTablet ? 12 : 20)),
                color: dimWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 10),
                    child: Text(
                      'Filter',
                      style: headingText.copyWith(
                        fontSize: isLargeScreen ? 24 : (isMobile ? 14 : (isTablet ? 18 : 20)),
                        fontFamily: GoogleFonts.nunitoSans().fontFamily,
                      ),
                    ),
                  ),
                  (isMobile || isTablet)
                      ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                    child: Column(
                      children: [
                        CustomDropDownWidget(
                          hint: 'Facilities',
                          items: controller.facilities,
                          onChanged: (value) => controller.facilitiesFilter.value = value!,
                        ),
                        const SizedBox(height: 10),
                        CustomDropDownWidget(
                          hint: 'Atmosphere',
                          items: controller.atmosphere,
                          onChanged: (value) => controller.atmosphereFilter.value = value!,
                        ),
                        const SizedBox(height: 10),
                        CustomDropDownWidget(
                          hint: 'Dietary preference',
                          items: controller.dietaryPreferences,
                          onChanged: (value) =>
                          controller.dietaryPreferencesFilter.value = value!,
                        ),
                        const SizedBox(height: 10),
                        CustomDropDownWidget(
                          hint: 'State',
                          items: controller.state,
                          onChanged: (value) => controller.stateFilter.value = value!,
                        ),
                        const SizedBox(height: 10),
                        CustomDropDownWidget(
                          hint: 'State',
                          items: controller.state,
                          onChanged: (value) => controller.stateFilter.value = value!,
                        ),
                        const SizedBox(height: 10),
                        CustomDropDownWidget(
                          hint: 'State',
                          items: controller.state,
                          onChanged: (value) => controller.stateFilter.value = value!,
                        ),
                        const SizedBox(height: 10),
                        CustomDropDownWidget(
                          hint: 'State',
                          items: controller.state,
                          onChanged: (value) => controller.stateFilter.value = value!,
                        ),
                        const SizedBox(height: 10),
                        CustomDropDownWidget(
                          hint: 'State',
                          items: controller.state,
                          onChanged: (value) => controller.stateFilter.value = value!,
                        ),
                      ],
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomDropDownWidget(
                                hint: 'Facilities',
                                items: controller.facilities,
                                onChanged: (value) =>
                                controller.facilitiesFilter.value = value!,
                              ),
                            ),
                            const SizedBox(width: 40),
                            Expanded(
                              child: CustomDropDownWidget(
                                hint: 'Atmosphere',
                                items: controller.atmosphere,
                                onChanged: (value) =>
                                controller.atmosphereFilter.value = value!,
                              ),
                            ),
                            const SizedBox(width: 40),
                            Expanded(
                              child: CustomDropDownWidget(
                                hint: 'Dietary preference',
                                items: controller.dietaryPreferences,
                                onChanged: (value) =>
                                controller.dietaryPreferencesFilter.value = value!,
                              ),
                            ),
                            const SizedBox(width: 40),
                            Expanded(
                              child: CustomDropDownWidget(
                                hint: 'State',
                                items: controller.state,
                                onChanged: (value) => controller.stateFilter.value = value!,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomDropDownWidget(
                                hint: 'State',
                                items: controller.state,
                                onChanged: (value) => controller.stateFilter.value = value!,
                              ),
                            ),
                            const SizedBox(width: 40),
                            Expanded(
                              child: CustomDropDownWidget(
                                hint: 'State',
                                items: controller.state,
                                onChanged: (value) => controller.stateFilter.value = value!,
                              ),
                            ),
                            const SizedBox(width: 40),
                            Expanded(
                              child: CustomDropDownWidget(
                                hint: 'State',
                                items: controller.state,
                                onChanged: (value) => controller.stateFilter.value = value!,
                              ),
                            ),
                            const SizedBox(width: 40),
                            Expanded(
                              child: CustomDropDownWidget(
                                hint: 'State',
                                items: controller.state,
                                onChanged: (value) => controller.stateFilter.value = value!,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Select User
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 20),
              child: Text(
                'Select user',
                style: headingText.copyWith(
                  fontSize: isLargeScreen ? 24 : (isMobile ? 14 : (isTablet ? 18 : 20)),
                  fontFamily: GoogleFonts.nunitoSans().fontFamily,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                        () => SizedBox(
                          height: 300,
                          child: ListView.builder(
                                          itemCount: controller.users.length,
                                          itemBuilder: (context, index) {
                          final user = controller.users[index];
                          return Padding(
                            padding:  EdgeInsets.only(right: isTablet?10:isMobile?10:300.0),
                            child: Container(
                              height: 70,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: EdgeInsets.symmetric(
                                horizontal: paddingValue,
                                vertical: isMobile ? 10 : (isTablet ? 8 : 8),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(30)
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Row(

                                children: [
                                  // Profile Picture
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(avatarSize / 2),
                                    child: Image.asset(
                                      user['image']!,
                                      width: avatarSize,
                                      height: avatarSize,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: avatarSize,
                                          height: avatarSize,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.person, color: Colors.grey),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: isMobile ? 12 : (isTablet ? 16 : 20)),
                                  // User Name
                                  Expanded(
                                    child: Text(
                                      user['name']!,
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontFamily: GoogleFonts.nunitoSans().fontFamily,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                  // Checkbox for multiple selection
                                   Obx(
                                          () => CustomRadioButton(
                                        isSelected: controller.isUserSelected(index),
                                        onTap: () {
                                          controller.toggleUserSelection(index);
                                        },
                                        activeColor: primaryColor, // Use primaryColor for consistency
                                      ),
                                    ),

                                ],
                              ),
                            ),
                          );
                                          },
                                        ),
                        ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding:  EdgeInsets.only(left: isMobile?150:isTablet?200:isLargeScreen?500:250.0),
                    child: CustomButton(
                      width: 162,
                      laBelText: 'Send',
                      ontapp: () {
                        // Check if at least one user is selected
                        bool isUserSelected = controller.selectedUsers.isNotEmpty;

                        // Check if any dropdown is unselected
                        bool isAnyFilterMissing =
                            controller.facilitiesFilter.value.isEmpty ||
                                controller.atmosphereFilter.value.isEmpty ||
                                controller.dietaryPreferencesFilter.value.isEmpty ||
                                controller.stateFilter.value.isEmpty;

                        if (!isUserSelected || isAnyFilterMissing) {
                          // Show error snackbar
                          Get.snackbar(
                            'Error',
                            !isUserSelected && isAnyFilterMissing
                                ? 'Please select at least one user and one item from each dropdown.'
                                : !isUserSelected
                                ? 'Please select at least one user.'
                                : 'Please select one item from each dropdown.',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: primaryColor,
                            colorText: Colors.white,
                            maxWidth: 400
                          );
                          return;
                        }

                        // If valid, proceed
                       drawerController.showNotifications.value = false;
                      },

                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
class CustomRadioButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;

  const CustomRadioButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.activeColor = const Color(0xFF00C4B4), // Default teal color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey,
            width: 2,
          ),
        ),
        child: isSelected
            ? Center(
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: activeColor,
            ),
          ),
        )
            : null,
      ),
    );
  }
}