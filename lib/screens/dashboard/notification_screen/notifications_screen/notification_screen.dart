import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savrly/models/usermodel_for_notification.dart';
import 'package:savrly/utils/globalVars.dart';

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
  GlobalVariables globalVariables = GlobalVariables();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double screenWidth = size.width;

    // Define view breakpoints
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth <= 900;
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
                borderRadius:
                    BorderRadius.circular(isMobile ? 10 : (isTablet ? 12 : 20)),
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
                        fontSize: isLargeScreen
                            ? 24
                            : (isMobile ? 14 : (isTablet ? 18 : 20)),
                        fontFamily: GoogleFonts.nunitoSans().fontFamily,
                      ),
                    ),
                  ),
                  (isMobile || isTablet)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8),
                          child: Column(
                            children: [
                              CustomDropDownWidget(
                                hint: 'Favorite Cuisines',
                                items: controller.favoriteCuisines,
                                onChanged: (value) {
                                  controller.favoriteCuisinesFilter.value =
                                      value!;
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomDropDownWidget(
                                hint: 'Dietary Preferences',
                                items: controller.dietaryPreferences,
                                onChanged: (value) {
                                  controller.dietaryPreferencesFilter.value =
                                      value!;
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomDropDownWidget(
                                hint: 'Restaurant Factors',
                                items: controller.chooseRestaurantFactors,
                                onChanged: (value) {
                                  controller.chooseRestaurantFactorsFilter
                                      .value = value!;
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomDropDownWidget(
                                hint: 'Dining Planning Style',
                                items: controller.diningPlanningStyle,
                                onChanged: (value) {
                                  controller.diningPlanningStyleFilter.value =
                                      value!;
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomDropDownWidget(
                                hint: 'Dining Priorities',
                                items: controller.diningPriorities,
                                onChanged: (value) {
                                  controller.diningPrioritiesFilter.value =
                                      value!;
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomDropDownWidget(
                                hint: 'Dining Experiences',
                                items: controller.diningExperiences,
                                onChanged: (value) {
                                  controller.diningExperiencesFilter.value =
                                      value!;
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomDropDownWidget(
                                hint: 'Notification Preferences',
                                items: controller.notificationPreferences,
                                onChanged: (value) {
                                  controller.notificationPreferencesFilter
                                      .value = value!;
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomDropDownWidget(
                                hint: 'Notification Frequency',
                                items: controller.notificationFrequency,
                                onChanged: (value) {
                                  controller.notificationFrequencyFilter.value =
                                      value!;
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomDropDownWidget(
                                hint: 'Travel Distance',
                                items: controller.travelDistance,
                                onChanged: (value) {
                                  controller.travelDistanceFilter.value =
                                      value!;
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomDropDownWidget(
                                hint: 'State',
                                items: controller.stateList,
                                onChanged: (value) {
                                  controller.stateFilter.value =
                                  value!;
                                },
                              ),
                              const SizedBox(height: 10),
                              Obx(
                                    () => CustomDropDownWidget(
                                  hint: 'City',
                                  items: controller.stateFilter.value ==
                                      'Los Angeles'
                                      ? globalVariables.losAngelesCities
                                      : globalVariables.newYorkCitiesList,
                                  onChanged: (value) {
                                    controller.cityFilter
                                        .value = value!;
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomDropDownWidget(
                                      hint: 'Favorite Cuisines',
                                      items: controller.favoriteCuisines,
                                      onChanged: (value) {
                                        controller.favoriteCuisinesFilter
                                            .value = value!;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(
                                    child: CustomDropDownWidget(
                                      hint: 'Dietary Preferences',
                                      items: controller.dietaryPreferences,
                                      onChanged: (value) {
                                        controller.dietaryPreferencesFilter
                                            .value = value!;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(
                                    child: CustomDropDownWidget(
                                      hint: 'Restaurant Factors',
                                      items: controller.chooseRestaurantFactors,
                                      onChanged: (value) {
                                        controller.chooseRestaurantFactorsFilter
                                            .value = value!;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomDropDownWidget(
                                      hint: 'Dining Planning Style',
                                      items: controller.diningPlanningStyle,
                                      onChanged: (value) {
                                        controller.diningPlanningStyleFilter
                                            .value = value!;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(
                                    child: CustomDropDownWidget(
                                      hint: 'Dining Priorities',
                                      items: controller.diningPriorities,
                                      onChanged: (value) {
                                        controller.diningPrioritiesFilter
                                            .value = value!;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(
                                    child: CustomDropDownWidget(
                                      hint: 'Dining Experiences',
                                      items: controller.diningExperiences,
                                      onChanged: (value) {
                                        controller.diningExperiencesFilter
                                            .value = value!;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomDropDownWidget(
                                      hint: 'Notification Preferences',
                                      items: controller.notificationPreferences,
                                      onChanged: (value) {
                                        controller.notificationPreferencesFilter
                                            .value = value!;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(
                                    child: CustomDropDownWidget(
                                      hint: 'Notification Frequency',
                                      items: controller.notificationFrequency,
                                      onChanged: (value) {
                                        controller.notificationFrequencyFilter
                                            .value = value!;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(
                                    child: CustomDropDownWidget(
                                      hint: 'Travel Distance',
                                      items: controller.travelDistance,
                                      onChanged: (value) {
                                        controller.travelDistanceFilter.value =
                                            value!;
                                      },
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
                                      items: controller.stateList,
                                      onChanged: (value) {
                                        controller.stateFilter.value = value!;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(
                                    child: Obx(
                                      () => CustomDropDownWidget(
                                        hint: 'City',
                                        items: controller.stateFilter.value ==
                                                'Los Angeles'
                                            ? globalVariables.losAngelesCities
                                            : globalVariables.newYorkCitiesList,
                                        onChanged: (value) {
                                          controller.cityFilter
                                              .value = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(child: SizedBox()),
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
                  fontSize: isLargeScreen
                      ? 24
                      : (isMobile ? 14 : (isTablet ? 18 : 20)),
                  fontFamily: GoogleFonts.nunitoSans().fontFamily,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 300,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.data!.docs.isEmpty) {
                          print(
                              'No users match the filters ${snapshot.data!.docs.length}');
                          return const Center(
                              child: Text('No users match the filters'));
                        } else {
                          List<UserModel> users = snapshot.data!.docs
                              .map((doc) => UserModel.fromMap(
                                  doc.data() as Map<String, dynamic>))
                              .toList();

                          return Obx(() {
                            controller.updateFilteredUsers(users);
                            return ListView.builder(
                              itemCount: controller
                                  .filteredUsers.length, // ✅ filtered list here
                              itemBuilder: (context, index) {
                                final user = controller.filteredUsers[
                                    index]; // ✅ filtered userr here

                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: isTablet
                                        ? 10
                                        : isMobile
                                            ? 10
                                            : 300.0,
                                  ),
                                  child: Container(
                                    height: 70,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: paddingValue,
                                      vertical:
                                          isMobile ? 10 : (isTablet ? 8 : 8),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(30),
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
                                          borderRadius: BorderRadius.circular(
                                              avatarSize / 2),
                                          child: user.userImage.isNotEmpty
                                              ? Image.network(
                                                  user.userImage.value,
                                                  width: avatarSize,
                                                  height: avatarSize,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      width: avatarSize,
                                                      height: avatarSize,
                                                      color: Colors.grey[300],
                                                      child: const Icon(
                                                          Icons.person,
                                                          color: Colors.grey),
                                                    );
                                                  },
                                                )
                                              : Container(
                                                  width: avatarSize,
                                                  height: avatarSize,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                      Icons.person,
                                                      color: Colors.grey),
                                                ),
                                        ),
                                        SizedBox(
                                          width: isMobile
                                              ? 12
                                              : (isTablet ? 16 : 20),
                                        ),
                                        // User Name
                                        Expanded(
                                          child: Text(
                                            user.username.text,
                                            style: TextStyle(
                                              fontSize: fontSize,
                                              fontFamily:
                                                  GoogleFonts.nunitoSans()
                                                      .fontFamily,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                        // Checkbox for multiple selection
                                        Obx(() => CustomRadioButton(
                                          isSelected: controller.isUserSelected(index),
                                          onTap: () => controller.toggleUserSelection(index),
                                          activeColor: primaryColor,
                                        ))

                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(
                        left: isMobile
                            ? 150
                            : isTablet
                                ? 200
                                : isLargeScreen
                                    ? 500
                                    : 250.0),
                    child: CustomButton(
                      width: 162,
                      laBelText: 'Send',
                      ontapp: () async {
                        // Check if at least one user is selected
                        bool isUserSelected = controller.selectedUsers.isNotEmpty;

                        // Check if at least one filter is selected
                        bool isAnyFilterSelected =
                            controller.favoriteCuisinesFilter.value.isNotEmpty ||
                                controller.dietaryPreferencesFilter.value.isNotEmpty ||
                                controller.chooseRestaurantFactorsFilter.value.isNotEmpty ||
                                controller.diningPlanningStyleFilter.value.isNotEmpty ||
                                controller.diningPrioritiesFilter.value.isNotEmpty ||
                                controller.diningExperiencesFilter.value.isNotEmpty ||
                                controller.notificationPreferencesFilter.value.isNotEmpty ||
                                controller.notificationFrequencyFilter.value.isNotEmpty ||
                                controller.travelDistanceFilter.value.isNotEmpty ||
                                controller.stateFilter.value.isNotEmpty ||
                                controller.cityFilter.value.isNotEmpty;

                        if (!isUserSelected || !isAnyFilterSelected) {
                          Get.snackbar(
                            'Error',
                            !isUserSelected && !isAnyFilterSelected
                                ? 'Please select at least one user and one filter.'
                                : !isUserSelected
                                ? 'Please select at least one user.'
                                : 'Please select at least one filter.',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: primaryColor,
                            colorText: Colors.white,
                            maxWidth: 400,
                          );
                          return;
                        }

                        // Get selected users' data
                        List<UserModel> selectedUserData = controller.selectedUsers
                            .map((index) => controller.filteredUsers[index])
                            .toList();

                        // Print selected users' data
                        print('Selected Users: ${selectedUserData.length}');
                        for (var user in selectedUserData) {
                          print('--- User ---');
                          print('User ID: ${user.userID}');
                          print('Username: ${user.username.text}');
                          print('User Image: ${user.userImage.value}');
                          print('Top Three Cuisines: ${user.topThreeCuisines?.join(", ") ?? "None"}');
                          print('Dietary Preferences: ${user.dietaryPrefList?.join(", ") ?? "None"}');
                          print('Choose Restaurant Factors: ${user.whereToEat?.join(", ") ?? "None"}');
                          print('Dining Planning Style: ${user.planner ?? "None"}');
                          print('Dining Priorities: ${user.impDiningOut?.join(", ") ?? "None"}');
                          print('Dining Experiences: ${user.diningExp?.join(", ") ?? "None"}');
                          print('Travel Distance: ${user.willingToTravel ?? "None"}');
                          print('Notification Preferences: ${user.notificationType?.join(", ") ?? "None"}');
                          print('Notification Frequency: ${user.notifiedDiningOpp ?? "None"}');
                          print('State: ${user.country ?? "None"}');
                          print('City: ${user.city ?? "None"}');
                        }

                        // Existing logic for sending notifications
                        List<String> selectedUserIds = controller.selectedUsers
                            .map((index) => controller.filteredUsers[index].token.toString())
                            .toList();
//                         Send notifications to selected users
                        for (var user in selectedUserData) {
                          if (selectedUserIds.isNotEmpty && user.token != null) {
                            await controller.sendPushNotification(
                              token: user.token!,
                              title: controller.titleController.text,
                              message: controller.descriptionController.text,
                            );
                            // drawerController.showNotifications.value = false;
                          } else {
                            print('No FCM token for user: ${user.userID}');
                          }
                        }
                        // controller.sendPushNotification(token: selectedUserIds, message: controller.descriptionController.text, title: controller.titleController.text);
                        print('Sending notifications to user IDs: $selectedUserIds');
                        // Add your notification logic here

                      },
                    ),
                    /*CustomButton(
                      width: 162,
                      laBelText: 'Send',
                      ontapp: () {
                        // Check if at least one user is selected
                        bool isUserSelected =
                            controller.selectedUsers.isNotEmpty;

                        // Check if at least one filter is selected
                        bool isAnyFilterSelected = controller
                                .favoriteCuisinesFilter.value.isNotEmpty ||
                            controller
                                .dietaryPreferencesFilter.value.isNotEmpty ||
                            controller.chooseRestaurantFactorsFilter.value
                                .isNotEmpty ||
                            controller
                                .diningPlanningStyleFilter.value.isNotEmpty ||
                            controller
                                .diningPrioritiesFilter.value.isNotEmpty ||
                            controller
                                .diningExperiencesFilter.value.isNotEmpty ||
                            controller.notificationPreferencesFilter.value
                                .isNotEmpty ||
                            controller
                                .notificationFrequencyFilter.value.isNotEmpty;

                        if (!isUserSelected || !isAnyFilterSelected) {
                          Get.snackbar(
                              'Error',
                              !isUserSelected && !isAnyFilterSelected
                                  ? 'Please select at least one user and one filter.'
                                  : !isUserSelected
                                      ? 'Please select at least one user.'
                                      : 'Please select at least one filter.',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: primaryColor,
                              colorText: Colors.white,
                              maxWidth: 400);
                          return;
                        }

                        // Placeholder for sending notifications
                        List<String> selectedUserIds = controller.selectedUsers
                            .map((index) =>
                                controller.filteredUsers[index].userID)
                            .toList();
                        print(
                            'Sending notifications to user IDs: $selectedUserIds');
                        // Add your notification logic here
                        drawerController.showNotifications.value = false;
                      },
                    ),*/
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
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
    this.activeColor = const Color(0xFF00C4B4),
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
