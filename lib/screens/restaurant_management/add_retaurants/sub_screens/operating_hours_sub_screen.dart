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

    final controller = Get.put(OperatingHoursSubScreenController());

    // Responsive sizing
    double headerFontSize = isMobile
        ? 12
        : isTablet
            ? 14
            : 16;
    double cellFontSize = isMobile
        ? 10
        : isTablet
            ? 12
            : 14;
    double cellPadding = isMobile
        ? 6
        : isTablet
            ? 8
            : 10;
    double buttonHeight = isMobile
        ? 28
        : isTablet
            ? 32
            : 36;
    double buttonWidth = isMobile
        ? 80
        : isTablet
            ? 90
            : 150;
    double buttonFontSize = isMobile
        ? 8
        : isTablet
            ? 10
            : 12;
    double onOffContainerWidth = isMobile
        ? 30
        : isTablet
            ? 35
            : 40;
    double onOffContainerHeight = isMobile
        ? 30
        : isTablet
            ? 35
            : 40;
    double onOffFontSize = isMobile
        ? 8
        : isTablet
            ? 10
            : 12;

    // Column widths
    double dayColumnWidth = isMobile
        ? 60
        : isTablet
            ? 80
            : 160;
    double slotColumnWidth = isMobile
        ? 100
        : isTablet
            ? 110
            : 220;

    // Define the slots for the header and columns
    const List<String> slots = ['Breakfast', 'Brunch', 'Lunch', 'Dinner'];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Scrollable content for both vertical and horizontal scrolling
              SizedBox(
                height: screenHeight,
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
                                child: Text(
                                  'Day',
                                  style: headingText.copyWith(
                                    fontSize: headerFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              // Slot column headers (Breakfast, Brunch, Lunch, Dinner)
                              ...slots.map((slot) => Container(
                                    width: slotColumnWidth,
                                    padding: EdgeInsets.all(cellPadding),
                                    child: Text(
                                      slot,
                                      style: headingText.copyWith(
                                        fontSize: headerFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            ],
                          ),
                          const Divider(height: 1, color: Colors.grey),
                          // Rows for each day
                          ...days.map((day) => Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Day column with switch
                                      Container(
                                        width: dayColumnWidth,
                                        padding: EdgeInsets.all(cellPadding),
                                        child: Row(
                                          //
                                          children: [
                                            FlutterSwitch(
                                              width: isMobile
                                                  ? 30
                                                  : isTablet
                                                      ? 40
                                                      : 50,
                                              height: isMobile
                                                  ? 15
                                                  : isTablet
                                                      ? 20
                                                      : 25,
                                              value:
                                                  controller.daySwitches[day] ??
                                                      false,
                                              activeColor: primaryColor,
                                              inactiveColor:
                                                  Colors.grey.shade300,
                                              toggleColor: Colors.white,
                                              inactiveToggleColor: Colors.white,
                                              borderRadius: 50.0,
                                              padding: 2.0,
                                              showOnOff: false,
                                              toggleSize: isMobile
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
                                            const SizedBox(width: 4),
                                            Text(
                                              day,
                                              style: simpleText.copyWith(
                                                  fontSize: cellFontSize),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Slot columns (Breakfast, Brunch, Lunch, Dinner)
                                      ...slots.map((slot) => Container(
                                            width: slotColumnWidth,
                                            padding:
                                                EdgeInsets.all(cellPadding),
                                            child:
                                                controller.daySwitches[day] ??
                                                        false
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          CustomButton(
                                                            laBelText:
                                                                _getButtonText(
                                                              controller.slotStates[
                                                                          day]
                                                                      ?[slot] ??
                                                                  false,
                                                              controller.slotTimes[
                                                                          day]
                                                                      ?[slot] ??
                                                                  '',
                                                            ),
                                                            fontSize:
                                                                buttonFontSize,
                                                            height:
                                                                buttonHeight,
                                                            width: buttonWidth,
                                                            containerColor: (controller.slotStates[day]
                                                                            ?[
                                                                            slot] ??
                                                                        false) &&
                                                                    (controller.slotTimes[day]?[slot] ??
                                                                            '')
                                                                        .isNotEmpty
                                                                ? primaryColor
                                                                : Colors.grey
                                                                    .shade300,
                                                            textColor: (controller.slotStates[day]
                                                                            ?[
                                                                            slot] ??
                                                                        false) &&
                                                                    (controller.slotTimes[day]?[slot] ??
                                                                            '')
                                                                        .isNotEmpty
                                                                ? Colors.white
                                                                : Colors.black,
                                                            ontapp: () {
                                                              if (controller.slotStates[
                                                                          day]
                                                                      ?[slot] ??
                                                                  false) {
                                                                controller.setTime(
                                                                    Get.context!,
                                                                    day,
                                                                    slot);
                                                              }
                                                            },
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          MouseRegion(
                                                            cursor:
                                                                SystemMouseCursors
                                                                    .click,
                                                            child: Container(
                                                              height:
                                                                  onOffContainerHeight,
                                                              width:
                                                                  onOffContainerWidth,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 1,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        if (!(controller.slotStates[day]?[slot] ??
                                                                            false)) {
                                                                          controller.toggleSlotState(
                                                                              day,
                                                                              slot);
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: (controller.slotStates[day]?[slot] ?? false)
                                                                              ? primaryColor
                                                                              : Colors.white,
                                                                          borderRadius: const BorderRadius
                                                                              .vertical(
                                                                              top: Radius.circular(4)),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'On',
                                                                            style:
                                                                                simpleText.copyWith(
                                                                              color: (controller.slotStates[day]?[slot] ?? false) ? Colors.white : Colors.black,
                                                                              fontSize: onOffFontSize,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        if (controller.slotStates[day]?[slot] ??
                                                                            false) {
                                                                          controller.toggleSlotState(
                                                                              day,
                                                                              slot);
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: !(controller.slotStates[day]?[slot] ?? false)
                                                                              ? Colors.grey.shade300
                                                                              : Colors.white,
                                                                          borderRadius: const BorderRadius
                                                                              .vertical(
                                                                              bottom: Radius.circular(4)),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Off',
                                                                            style:
                                                                                simpleText.copyWith(
                                                                              color: !(controller.slotStates[day]?[slot] ?? false) ? Colors.black : Colors.black,
                                                                              fontSize: onOffFontSize,
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
                                                          style: simpleText
                                                              .copyWith(
                                                            fontSize:
                                                                cellFontSize,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                          )),
                                    ],
                                  ),
                                  const Divider(height: 1, color: Colors.grey),
                                ],
                              )),
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
}
