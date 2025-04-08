import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/text_styles.dart';

import '../../../../constants/app_colors.dart';
import '../../../../controllers/operating_hours_sub_screen_controller.dart';
import '../../../../widgets/button.dart';

class OperatingHoursSubScreen extends StatelessWidget {
  const OperatingHoursSubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Define breakpoints for mobile, tablet, and desktop
    bool isMobile = screenWidth < 600; // Mobile: < 600px
    bool isTablet =
        screenWidth >= 600 && screenWidth < 1000; // Tablet: 600px - 999px
    bool isDesktop = screenWidth >= 1000; // Desktop: >= 1000px

    final controller = Get.put(OperatingHoursSubScreenController());

    // Adjust font sizes and padding based on screen size
    double headerFontSize =
        isMobile
            ? 14
            : isTablet
            ? 16
            : 18;
    double cellFontSize =
        isMobile
            ? 12
            : isTablet
            ? 14
            : 16;
    double cellPadding =
        isMobile
            ? 6.0
            : isTablet
            ? 8.0
            : 12.0;
    double buttonHeight =
        isMobile
            ? 36
            : isTablet
            ? 40
            : 44;
    double buttonFontSize =
        isMobile
            ? 10
            : isTablet
            ? 12
            : 14;
    double onOffContainerWidth =
        isMobile
            ? 20
            : isTablet
            ? 22
            : 26;
    double onOffContainerHeight =
        isMobile
            ? 32
            : isTablet
            ? 36
            : 40;
    double onOffFontSize =
        isMobile
            ? 8
            : isTablet
            ? 9
            : 10;

    // Calculate total table width to fit the screen
    double totalTableWidth =
        screenWidth - 32; // Subtract padding (16 on each side)

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Table for operating hours
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: totalTableWidth, // Set table width to fit screen
                child: Obx(
                  () => Table(
                    // Modified border to show only horizontal lines
                    border: const TableBorder(
                      horizontalInside: BorderSide(
                        color: dimWhite,
                        width: 1,
                      ), // Only horizontal lines
                    ),
                    columnWidths: {
                      0: FractionColumnWidth(
                        isMobile
                            ? 0.12
                            : isTablet
                            ? 0.10
                            : 0.03,
                      ),
                      1: FractionColumnWidth(
                        isMobile
                            ? 0.12
                            : isTablet
                            ? 0.12
                            : 0.03,
                      ),
                      2: FractionColumnWidth(
                        isMobile
                            ? 0.12
                            : isTablet
                            ? 0.12
                            : 0.03,
                      ),
                      3: FractionColumnWidth(
                        isMobile
                            ? 0.12
                            : isTablet
                            ? 0.12
                            : 0.03,
                      ),
                      4: FractionColumnWidth(
                        isMobile
                            ? 0.12
                            : isTablet
                            ? 0.12
                            : 0.03,
                      ),
                    },
                    children: [
                      // Header Row
                      TableRow(
                        decoration: BoxDecoration(color: secondaryColor.withOpacity(0.16)) ,
                        children: [
                          _buildTableCell(
                            'Days',
                            isHeader: true,
                            fontSize: headerFontSize,
                            padding: cellPadding,
                          ),
                          _buildTableCell(
                            'Breakfast',
                            isHeader: true,
                            fontSize: headerFontSize,
                            padding: cellPadding,
                          ),
                          _buildTableCell(
                            'Brunch',
                            isHeader: true,
                            fontSize: headerFontSize,
                            padding: cellPadding,
                          ),
                          _buildTableCell(
                            'Lunch',
                            isHeader: true,
                            fontSize: headerFontSize,
                            padding: cellPadding,
                          ),
                          _buildTableCell(
                            'Dinner',
                            isHeader: true,
                            fontSize: headerFontSize,
                            padding: cellPadding,
                          ),
                        ],
                      ),
                      // Data Rows
                      ...controller.daySwitches.keys.map((day) {
                        return TableRow(
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.1),
                          ),
                          // Removed decoration to avoid background overlap with lines
                          children: [
                            // Days column with switch (centered)
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(cellPadding),
                                child: SizedBox(
                                  width:
                                      isMobile
                                          ? 50.0
                                          : isTablet
                                          ? 60.0
                                          : 70.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FlutterSwitch(
                                        width:
                                            isMobile
                                                ? 35.0
                                                : isTablet
                                                ? 40.0
                                                : 45.0,
                                        height:
                                            isMobile
                                                ? 20.0
                                                : isTablet
                                                ? 23.0
                                                : 28.0,
                                        value:
                                            controller
                                                .daySwitchControllers[day]!
                                                .value,
                                        activeColor: primaryColor,
                                        inactiveColor: white,
                                        toggleColor: white,
                                        inactiveToggleColor: primaryColor,
                                        borderRadius: 50.0,
                                        padding: 2.0,
                                        showOnOff: false,
                                        toggleSize:
                                            isMobile
                                                ? 16.0
                                                : isTablet
                                                ? 20.0
                                                : 24.0,
                                        onToggle: (val) {
                                          controller
                                              .daySwitchControllers[day]!
                                              .value = val;
                                        },
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        day,
                                        style: simpleText.copyWith(
                                          fontSize: cellFontSize,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Breakfast
                            _buildSlotCell(
                              controller,
                              day,
                              'Breakfast',
                              isDinner: false,
                              buttonHeight: buttonHeight,
                              buttonFontSize: buttonFontSize,
                              onOffContainerWidth: onOffContainerWidth,
                              onOffContainerHeight: onOffContainerHeight,
                              onOffFontSize: onOffFontSize,
                              cellFontSize: cellFontSize,
                              padding: cellPadding,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                            // Brunch
                            _buildSlotCell(
                              controller,
                              day,
                              'Brunch',
                              isDinner: false,
                              buttonHeight: buttonHeight,
                              buttonFontSize: buttonFontSize,
                              onOffContainerWidth: onOffContainerWidth,
                              onOffContainerHeight: onOffContainerHeight,
                              onOffFontSize: onOffFontSize,
                              cellFontSize: cellFontSize,
                              padding: cellPadding,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                            // Lunch
                            _buildSlotCell(
                              controller,
                              day,
                              'Lunch',
                              isDinner: false,
                              buttonHeight: buttonHeight,
                              buttonFontSize: buttonFontSize,
                              onOffContainerWidth: onOffContainerWidth,
                              onOffContainerHeight: onOffContainerHeight,
                              onOffFontSize: onOffFontSize,
                              cellFontSize: cellFontSize,
                              padding: cellPadding,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                            // Dinner
                            _buildSlotCell(
                              controller,
                              day,
                              'Dinner',
                              isDinner: true,
                              buttonHeight: buttonHeight,
                              buttonFontSize: buttonFontSize,
                              onOffContainerWidth: onOffContainerWidth,
                              onOffContainerHeight: onOffContainerHeight,
                              onOffFontSize: onOffFontSize,
                              cellFontSize: cellFontSize,
                              padding: cellPadding,
                              isMobile: isMobile,
                              isTablet: isTablet,
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper to build table header cells
  Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    required double fontSize,
    required double padding,
  }) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center, // Center align text
          style: simpleText.copyWith(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  // Helper to build slot cells (Breakfast, Brunch, Lunch, Dinner)
  Widget _buildSlotCell(
    OperatingHoursSubScreenController controller,
    String day,
    String slot, {
    required bool isDinner, // Flag to handle Dinner column differently
    required double buttonHeight,
    required double buttonFontSize,
    required double onOffContainerWidth,
    required double onOffContainerHeight,
    required double onOffFontSize,
    required double cellFontSize,
    required double padding,
    required bool isMobile,
    required bool isTablet,
  }) {
    bool isDayEnabled = controller.daySwitches[day]!;
    bool isSlotOn = controller.slotStates[day]![slot]!;
    String buttonText =
        isSlotOn
            ? (isDinner && controller.slotTimes[day]![slot]!.isNotEmpty
                ? controller.slotTimes[day]![slot]!
                : 'Set Time')
            : 'Closed';

    // Calculate button width dynamically based on text length
    final textPainter = TextPainter(
      text: TextSpan(
        text: buttonText,
        style: simpleText.copyWith(fontSize: buttonFontSize),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    double buttonWidth =
        textPainter.width + 32; // Add padding (16 on each side)

    // Ensure minimum width for readability
    buttonWidth = buttonWidth.clamp(
      isMobile
          ? 100
          : isTablet
          ? 120
          : 140,
      double.infinity,
    );

    return TableCell(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child:
            isDayEnabled
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center align
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      laBelText: buttonText,
                      fontSize: buttonFontSize,
                      height: buttonHeight,
                      width: buttonWidth,
                      // Dynamic width based on text
                      containerColor:
                          isSlotOn
                              ? primaryColor
                              : secondaryColor.withOpacity(0.2),
                      textColor: white,
                      shadow: [],
                      ontapp: () {
                        if (isSlotOn) {
                          controller.setTime(Get.context!, day, slot);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        height: onOffContainerHeight,
                        width: onOffContainerWidth,
                        decoration: BoxDecoration(
                          color: white,
                          border: Border.all(
                            color: secondaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Prevent overflow
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (!isSlotOn) {
                                    // Only toggle to "On" if currently "Off"
                                    controller.toggleSlotState(day, slot);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSlotOn ? primaryColor : white,
                                    border: Border.all(
                                      color:
                                          isSlotOn
                                              ? primaryColor
                                              : Colors.transparent,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                      topRight: Radius.circular(6),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'On',
                                      style: simpleText.copyWith(
                                        color: isSlotOn ? white : blackColor,
                                        fontSize: onOffFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (isSlotOn) {
                                    // Only toggle to "Off" if currently "On"
                                    controller.toggleSlotState(day, slot);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        !isSlotOn
                                            ? secondaryColor.withOpacity(0.2)
                                            : white,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(6),
                                      bottomRight: Radius.circular(6),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Off',
                                      style: simpleText.copyWith(
                                        color: !isSlotOn ? white : blackColor,
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
                    // Remove separate time text for Dinner column
                    if (!isDinner &&
                        isSlotOn &&
                        controller.slotTimes[day]![slot]!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          controller.slotTimes[day]![slot]!,
                          style: simpleText.copyWith(fontSize: cellFontSize),
                        ),
                      ),
                  ],
                )
                : Center(
                  child: Text(
                    'Closed',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: cellFontSize,
                    ),
                  ),
                ),
      ),
    );
  }
}
