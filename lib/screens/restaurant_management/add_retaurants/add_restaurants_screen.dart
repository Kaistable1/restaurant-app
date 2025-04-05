import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/screens/restaurant_management/add_retaurants/sub_screens/amenities_sub_screen.dart';
import 'package:savrly/screens/restaurant_management/add_retaurants/sub_screens/basic_info_sub_screen.dart';
import 'package:savrly/screens/restaurant_management/add_retaurants/sub_screens/experiences_sub_screen.dart';
import 'package:savrly/screens/restaurant_management/add_retaurants/sub_screens/menu_sub_screen.dart';
import 'package:savrly/screens/restaurant_management/add_retaurants/sub_screens/operating_hours_sub_screen.dart';
import 'package:savrly/widgets/customheader_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/add_restaurants_controller.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../widgets/button.dart';

import 'package:flutter/gestures.dart';

class AddRestaurantsScreen extends StatelessWidget {
  AddRestaurantsScreen({super.key});

  final drawerController = Get.put(DrawerControllerX());
  final tabController = Get.put(AddRestaurantTabController());
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;
    double paddingValue = mobileView ? 16 : 24;
    double buttonTextSize = mobileView ? 11 : 16;

    return Padding(
      padding: EdgeInsets.all(paddingValue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeaderWidget(
            title: 'Add Restaurant',
            back: true,
            onBackTap: () {
              drawerController.addRestaurants.value = false;
            },
            end: true,
            endWidget: CustomButton(
              laBelText: 'Save',
              fontSize: buttonTextSize,
              height: mobileView ? 40 : 45,
              width: mobileView ? 90 : 150,
              shadow: [],
              containerColor: primaryColor,
              ontapp: () {
                // Save logic here
              },
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () => SizedBox(
              height: 40,
              // Fixed height for tabs to ensure they don’t stretch
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  // Handle mouse drag
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
                            tabController.selectedIndex.value = index;
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
                                    color:
                                        isSelected
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
          // Tab Body Content
          Obx(() {
            switch (tabController.selectedIndex.value) {
              case 0:
                return BasicInfoSubScreen();
              case 1:
                return AmenitiesSubScreen();
              case 2:
                return ExperiencesSubScreen();
              case 3:
                return OperatingHoursSubScreen();
              case 4:
                return MenuSubScreen();
              default:
                return BasicInfoSubScreen();
            }
          }),
        ],
      ),
    );
  }
}
