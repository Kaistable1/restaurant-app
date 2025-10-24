import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/controllers/operating_hours_sub_screen_controller.dart';
import 'package:savrly/controllers/restaurant_management_controller.dart';
import 'package:savrly/screens/restaurant_management/add_retaurants/sub_screens/amenities_sub_screen.dart';
import 'package:savrly/screens/restaurant_management/add_retaurants/sub_screens/basic_info_sub_screen.dart';
import 'package:savrly/screens/restaurant_management/add_retaurants/sub_screens/experiences_sub_screen.dart';
import 'package:savrly/screens/restaurant_management/add_retaurants/sub_screens/menu_sub_screen.dart';
import 'package:savrly/screens/restaurant_management/add_retaurants/sub_screens/operating_hours_sub_screen.dart';
import 'package:savrly/widgets/customheader_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/add_restaurants_controller.dart';
import '../../../controllers/amenities_sub_screen_controller.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../controllers/edit_restaurant_controller.dart';
import '../../../controllers/experiences_sub_screen_controller.dart';
import '../../../controllers/menu_sub_screen_controller.dart';
import '../../../widgets/button.dart';

import 'package:flutter/gestures.dart';

class AddRestaurantsScreen extends StatelessWidget {
  AddRestaurantsScreen({super.key});
  final drawerController = Get.put(DrawerControllerX());
  final tabController = Get.put(AddRestaurantTabController());
  final restaurantController = Get.put(RestaurantManagementController());
  final amenitiesController = Get.put(AmenitiesSubScreenController());
  final experiencesController = Get.put(ExperiencesSubScreenController());
  final menuController = Get.put(MenuSubScreenController());
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 1000;
    double paddingValue = mobileView ? 16 : 24;
    double buttonTextSize = mobileView ? 12 : 16;

    return Padding(
      padding: EdgeInsets.all(paddingValue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeaderWidget(
            title: 'Add Restaurant',
            back: true,
            onBackTap: () {
              // ✅ Clean up all controllers and fields before going back
              tabController.clearFields();
              amenitiesController.clearFields();
              experiencesController.clearFields(); // This now clears events too
              menuController.clearFields();

              // Clear operating hours if registered
              if (Get.isRegistered<OperatingHoursSubScreenController>()) {
                final opHoursController =
                    Get.find<OperatingHoursSubScreenController>();
                opHoursController.daySwitches.clear();
                opHoursController.slotStates.clear();
                opHoursController.slotTimes.clear();
              }

              // Delete EditRestaurantController if it exists
              if (Get.isRegistered<EditRestaurantController>()) {
                Get.delete<EditRestaurantController>();
              }

              drawerController.addRestaurants.value = false;
            },
            end: true,
            endWidget: !mobileView
                ? Obx(() {
                    int selectedIndex = tabController.selectedIndex.value;
                    if (selectedIndex == 4) {
                      return Row(
                        children: [
                          CustomButton(
                            laBelText: 'Previous',
                            fontSize: buttonTextSize,
                            height: 45,
                            width: 130,
                            shadow: [],
                            containerColor: secondaryColor.withOpacity(0.2),
                            textColor: blackColor,
                            ontapp: () {
                              tabController.selectedIndex.value--;
                            },
                          ),
                          const SizedBox(width: 8),
                          CustomButton(
                            laBelText: 'Save',
                            fontSize: buttonTextSize,
                            height: 45,
                            width: 130,
                            shadow: [],
                            containerColor: primaryColor,
                            ontapp: () async {
                              await menuController.addMeneRestaurants();
                              tabController
                                  .clearFields(); // Clear Basic Info fields
                              amenitiesController.clearFields();
                              experiencesController.clearFields();
                              menuController.clearFields();
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Success'),
                                  content: const Text(
                                    'Data added successfully!',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back(); // Close dialog
                                        drawerController.addRestaurants.value =
                                            false;
                                        tabController.selectedIndex.value = 0;
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        if (selectedIndex > 0)
                          CustomButton(
                            laBelText: 'Previous',
                            fontSize: buttonTextSize,
                            height: 45,
                            width: 130,
                            shadow: [],
                            containerColor: secondaryColor.withOpacity(0.2),
                            textColor: blackColor,
                            ontapp: () {
                              tabController.selectedIndex.value--;
                            },
                          ),
                        const SizedBox(width: 8),
                        CustomButton(
                          laBelText: 'Next',
                          fontSize: buttonTextSize,
                          height: 45,
                          width: 130,
                          shadow: [],
                          containerColor: primaryColor,
                          ontapp: () async {
                            int selectedIndex = tabController
                                .selectedIndex.value; // Get current index
                            if (selectedIndex < 4) {
                              if (selectedIndex == 0) {
                                // Validate Basic Info tab
                                final basicInfoFormKey =
                                    tabController.basicInfoFormKey;
                                final formState = basicInfoFormKey.currentState;
                                if (tabController.uploadedImage.isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Please upload at least one restaurant image',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                } else if (formState != null &&
                                    formState.validate() &&
                                    tabController.areBasicInfoFieldsFilled()) {
                                  if (tabController.restaurantModel != null) {
                                    await tabController.updateBasicInfo();
                                  } else {
                                    await tabController.addRestaurant();
                                  }
                                }
                              } else if (selectedIndex == 1) {
                                await amenitiesController.addAmenities();
                              } else if (selectedIndex == 2) {
                                await experiencesController.addExperience();
                              } else if (selectedIndex == 3) {
                                OperatingHoursSubScreenController
                                    operatingHoursSubScreenController = Get.put(
                                        OperatingHoursSubScreenController());
                                await operatingHoursSubScreenController
                                    .saveAllOperatingHours();
                                tabController.selectedIndex.value++;
                              } else if (selectedIndex == 4) {
                                await menuController.addMeneRestaurants();
                              }
                            }
                          },
                        ),
                      ],
                    );
                  })
                : null,
          ),
          SizedBox(height: mobileView ? 16 : 0),
          if (mobileView)
            Obx(() {
              int selectedIndex = tabController.selectedIndex.value;
              if (selectedIndex == 4) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      laBelText: 'Previous',
                      fontSize: buttonTextSize,
                      height: 40,
                      width: 130,
                      shadow: [],
                      containerColor: secondaryColor.withOpacity(0.2),
                      textColor: blackColor,
                      ontapp: () {
                        tabController.selectedIndex.value--;
                      },
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      laBelText: 'Save',
                      fontSize: buttonTextSize,
                      height: 40,
                      width: 130,
                      shadow: [],
                      containerColor: primaryColor,
                      ontapp: () async {
                        await menuController.addMeneRestaurants();
                        tabController.clearFields(); // Clear Basic Info fields
                        amenitiesController.clearFields();
                        experiencesController.clearFields();
                        menuController.clearFields();
                        tabController.clearFields(); // Clear Basic Info fields
                        amenitiesController
                            .clearFields(); // Clear Amenities fields
                        experiencesController
                            .clearFields(); // Already clearing here
                        Get.dialog(
                          AlertDialog(
                            title: const Text('Success'),
                            content:
                                const Text('Restaurant added successfully!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back(); // Close dialog
                                  drawerController.addRestaurants.value = false;
                                  tabController.selectedIndex.value = 0;
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selectedIndex > 0)
                    CustomButton(
                      laBelText: 'Previous',
                      fontSize: buttonTextSize,
                      height: 40,
                      width: 130,
                      shadow: [],
                      containerColor: secondaryColor.withOpacity(0.2),
                      textColor: blackColor,
                      ontapp: () {
                        tabController.selectedIndex.value--;
                      },
                    ),
                  if (selectedIndex > 0) const SizedBox(width: 8),
                  CustomButton(
                    laBelText: 'Next',
                    fontSize: buttonTextSize,
                    height: 45,
                    width: 130,
                    shadow: [],
                    containerColor: primaryColor,
                    ontapp: () async {
                      int selectedIndex = tabController
                          .selectedIndex.value; // Get current index
                      if (selectedIndex < 4) {
                        if (selectedIndex == 0) {
                          // Validate Basic Info tab
                          final basicInfoFormKey =
                              tabController.basicInfoFormKey;
                          final formState = basicInfoFormKey.currentState;
                          if (tabController.uploadedImage.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please upload at least one restaurant image',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else if (formState != null &&
                              formState.validate() &&
                              tabController.areBasicInfoFieldsFilled()) {
                            if (tabController.restaurantModel != null) {
                              await tabController.updateBasicInfo();
                            } else {
                              await tabController.addRestaurant();
                            }
                          }
                        } else if (selectedIndex == 1) {
                          // Validate Amenities tab
                          final amenitiesValidation =
                              await amenitiesController.areAmenitiesValid();
                          if (!amenitiesValidation.values
                              .every((valid) => valid)) {
                            List<String> errors = [];
                            if (!amenitiesValidation['facilities']!) {
                              errors.add(
                                  'Please select at least one Facility/Service.');
                            }
                            if (!amenitiesValidation['dietary']!) {
                              errors.add(
                                  'Please select at least one Dietary Preference.');
                            }
                            if (!amenitiesValidation['atmosphere']!) {
                              errors.add(
                                  'Please select at least one Atmosphere option.');
                            }
                            if (!amenitiesValidation['priceRange']!) {
                              errors.add(
                                  'Please select at least one Price Range.');
                            }
                            Get.snackbar(
                              'Error',
                              errors.join('\n'),
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 5),
                            );
                          } else {
                            await amenitiesController.addAmenities();
                          }
                        } else if (selectedIndex == 2) {
                          print("Validating Tab 2...");
                          if (experiencesController
                                  .experienceSubScreenFormKey.currentState!
                                  .validate() &&
                              experiencesController
                                  .areExperienceFieldsFilled()) {
                            print("Tab 2 validated, moving to Tab 3");

                            tabController.selectedIndex.value++;
                          } else {
                            print("Tab 2 validation failed");
                            Get.snackbar(
                              'Error',
                              'Please add at least one event or fill all event fields.',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        } else {
                          await menuController.addMeneRestaurants();
                        }
                      }
                    },
                  ),
                ],
              );
            }),
          SizedBox(height: 24),
          Obx(
            () => SizedBox(
              height: 40,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  final newOffset = scrollController.offset - details.delta.dx;
                  scrollController.jumpTo(
                    newOffset.clamp(
                      0.0,
                      scrollController.position.maxScrollExtent,
                    ),
                  );
                },
                child: Listener(
                  onPointerSignal: (PointerSignalEvent event) {
                    if (event is PointerScrollEvent) {
                      final scrollDelta = event.scrollDelta.dy;
                      scrollController.jumpTo(
                        scrollController.offset + scrollDelta,
                      );
                    }
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Row(
                      children: List.generate(tabController.tabs.length, (
                        index,
                      ) {
                        bool isSelected =
                            tabController.selectedIndex.value == index;
                        return GestureDetector(
                          onTap: () {
                            if (tabController.restaurantModel != null) {
                              tabController.selectedIndex.value =
                                  index; // Disabled
                            }
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: mobileView ? 12 : 16,
                              ),
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isSelected
                                        ? primaryColor
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                tabController.tabs[index],
                                style: TextStyle(
                                  color:
                                      isSelected ? primaryColor : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: mobileView ? 14 : 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            switch (tabController.selectedIndex.value) {
              case 0:
                return BasicInfoSubScreen(
                  formKey: tabController.basicInfoFormKey,
                );
              case 1:
                return AmenitiesSubScreen();
              case 2:
                return ExperiencesSubScreen(
                  formKey: experiencesController.experienceSubScreenFormKey,
                );
              case 3:
                return OperatingHoursSubScreen();
              case 4:
                return MenuSubScreen();
              default:
                return BasicInfoSubScreen(
                  formKey: tabController.basicInfoFormKey,
                );
            }
          }),
        ],
      ),
    );
  }
}
