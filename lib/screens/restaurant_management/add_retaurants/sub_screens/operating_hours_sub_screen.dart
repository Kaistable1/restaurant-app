import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/app_colors.dart';
import 'package:savrly/constants/text_styles.dart';
import 'package:savrly/controllers/operating_hours_sub_screen_controller.dart';
import 'package:savrly/widgets/button.dart';

class OperatingHoursSubScreen extends StatelessWidget {
  const OperatingHoursSubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth < 1000;
    bool isDesktop = screenWidth >= 1000;

    final controller = Get.put(OperatingHoursSubScreenController());

    // Responsive sizing
    double headerFontSize =
        isMobile
            ? 12
            : isTablet
            ? 14
            : 16;
    double cellFontSize =
        isMobile
            ? 10
            : isTablet
            ? 12
            : 14;
    double cellPadding =
        isMobile
            ? 6
            : isTablet
            ? 8
            : 10;
    double buttonHeight =
        isMobile
            ? 28
            : isTablet
            ? 32
            : 36;
    double buttonWidth =
        isMobile
            ? screenWidth * 0.08
            : isTablet
            ? screenWidth * 0.088
            : screenWidth * 0.092;
    double buttonFontSize =
        isMobile
            ? 8
            : isTablet
            ? 10
            : 12;
    double onOffContainerWidth =
        isMobile
            ? 20
            : isTablet
            ? 22
            : 24;
    double onOffContainerHeight =
        isMobile
            ? 30
            : isTablet
            ? 35
            : 40;
    double onOffFontSize =
        isMobile
            ? 8
            : isTablet
            ? 9
            : 10;

    // Column widths
    double dayColumnWidth =
        isMobile
            ? screenWidth * 0.5
            : isTablet
            ? screenWidth * 0.10
            : screenWidth * 0.129;
    double slotColumnWidth =
        isMobile
            ? screenWidth * 0.5
            : isTablet
            ? screenWidth * 0.13
            : screenWidth * 0.15;

    // Define the slots for the header and columns
    const List<String> slots = ['Breakfast', 'Brunch', 'Lunch', 'Dinner'];

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              SizedBox(
                height: screenHeight - 96,
                width: screenWidth - 32,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() {
                      if (controller.daySwitches.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // List of days from the controller
                      List<dynamic> days = controller.daySwitches.keys.toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Row(
                            children: [
                              // Day column header
                              Container(
                                width: dayColumnWidth,
                                padding: EdgeInsets.all(cellPadding),
                                color: blackColor.withOpacity(0.3),
                                child: Center(
                                  child: Text(
                                    'Day',
                                    style: headingText.copyWith(
                                      fontSize: headerFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              // Slot column headers (Breakfast, Brunch, Lunch, Dinner)
                              ...slots.map(
                                (slot) => Container(
                                  width: slotColumnWidth,
                                  color: blackColor.withOpacity(0.3),
                                  padding: EdgeInsets.all(cellPadding),
                                  child: Text(
                                    slot,
                                    style: headingText.copyWith(
                                      fontSize: headerFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 1, color: Colors.grey),
                          // Rows for each day
                          ...days.map(
                            (day) => Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Day column with switch
                                    Container(
                                      width: dayColumnWidth,
                                      padding: EdgeInsets.all(cellPadding),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          FlutterSwitch(
                                            width:
                                                isMobile
                                                    ? 30
                                                    : isTablet
                                                    ? 40
                                                    : 50,
                                            height:
                                                isMobile
                                                    ? 15
                                                    : isTablet
                                                    ? 20
                                                    : 25,
                                            value:
                                                controller.daySwitches[day] ??
                                                false,
                                            activeColor: primaryColor,
                                            inactiveColor: Colors.grey.shade300,
                                            toggleColor: Colors.white,
                                            inactiveToggleColor: Colors.white,
                                            borderRadius: 50.0,
                                            padding: 2.0,
                                            showOnOff: false,
                                            toggleSize:
                                                isMobile
                                                    ? 12
                                                    : isTablet
                                                    ? 16
                                                    : 20,
                                            onToggle: (val) {
                                              controller
                                                  .daySwitchControllers[day]
                                                  ?.value = val;
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            day,
                                            style: simpleText.copyWith(
                                              fontSize: cellFontSize,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Slot columns (Breakfast, Brunch, Lunch, Dinner)
                                    ...slots.map(
                                      (slot) => Container(
                                        width: slotColumnWidth,
                                        padding: EdgeInsets.all(cellPadding),
                                        child:
                                            controller.daySwitches[day] ?? false
                                                ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomButton(
                                                      laBelText: _getButtonText(
                                                        controller
                                                                .slotStates[day]?[slot] ??
                                                            false,
                                                        controller
                                                                .slotTimes[day]?[slot] ??
                                                            '',
                                                      ),
                                                      fontSize: buttonFontSize,
                                                      height: buttonHeight,
                                                      width: buttonWidth,
                                                      containerColor: _getButtonColor(
                                                        controller
                                                                .slotStates[day]?[slot] ??
                                                            false,
                                                        controller
                                                                .slotTimes[day]?[slot] ??
                                                            '',
                                                      ),
                                                      textColor: white,
                                                      shadow: [],
                                                      ontapp: () {
                                                        if (controller
                                                                .slotStates[day]?[slot] ??
                                                            false) {
                                                          controller.setTime(
                                                            Get.context!,
                                                            day,
                                                            slot,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(width: 10),
                                                    MouseRegion(
                                                      cursor:
                                                          SystemMouseCursors
                                                              .click,
                                                      child: Container(
                                                        height:
                                                            onOffContainerHeight,
                                                        width:
                                                            onOffContainerWidth,
                                                        decoration: BoxDecoration(
                                                          color: white,
                                                          border: Border.all(
                                                            color: secondaryColor
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6,
                                                              ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  if (!(controller
                                                                          .slotStates[day]?[slot] ??
                                                                      false)) {
                                                                    controller
                                                                        .toggleSlotState(
                                                                          day,
                                                                          slot,
                                                                        );
                                                                  }
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color:
                                                                        (controller.slotStates[day]?[slot] ??
                                                                                false)
                                                                            ? primaryColor
                                                                            : white,
                                                                    borderRadius:
                                                                        const BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                            6,
                                                                          ),
                                                                        ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'On',
                                                                      style: simpleText.copyWith(
                                                                        color:
                                                                            (controller.slotStates[day]?[slot] ??
                                                                                    false)
                                                                                ? white
                                                                                : blackColor,
                                                                        fontSize:
                                                                            onOffFontSize,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  if (controller
                                                                          .slotStates[day]?[slot] ??
                                                                      false) {
                                                                    controller
                                                                        .toggleSlotState(
                                                                          day,
                                                                          slot,
                                                                        );
                                                                  }
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color:
                                                                        !(controller.slotStates[day]?[slot] ??
                                                                                false)
                                                                            ? secondaryColor.withOpacity(
                                                                              0.3,
                                                                            )
                                                                            : white,
                                                                    borderRadius:
                                                                        const BorderRadius.vertical(
                                                                          bottom:
                                                                              Radius.circular(
                                                                                6,
                                                                              ),
                                                                        ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Off',
                                                                      style: simpleText.copyWith(
                                                                        color:
                                                                            !(controller.slotStates[day]?[slot] ??
                                                                                    false)
                                                                                ? white
                                                                                : blackColor,
                                                                        fontSize:
                                                                            onOffFontSize,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                : Center(
                                                  child: Text(
                                                    'Closed',
                                                    style: simpleText.copyWith(
                                                      fontSize: cellFontSize,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 1, color: Colors.grey),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to determine button text
  String _getButtonText(bool isSlotOn, String time) {
    if (!isSlotOn) return 'Closed';
    return time.isNotEmpty ? time : 'Set Time';
  }

  // Helper method to determine button color
  Color _getButtonColor(bool isSlotOn, String time) {
    if (!isSlotOn) return secondaryColor.withOpacity(0.3); // For "Closed"
    return primaryColor; // For "Set Time" and when time is set
  }
}
