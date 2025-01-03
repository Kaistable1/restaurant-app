import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../utils/responsive.dart';

class OperatingHours extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Determine responsive font size
    double baseFontSize = Responsive.isMobile(context) ? 12 : 16;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            width: Get.width * 0.95, // Dynamic width based on screen size
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Operating hours',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontFamily: 'Nunito-Regular',
                      fontSize: Responsive.isMobile(context)
                          ? 16
                          : Responsive.isTablet(context)
                              ? 16
                              : 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  Row(
                    children: _buildHeadingRow(baseFontSize),
                  ),
                  const Divider(thickness: 1),
                  Column(
                    children: _buildDataRows(baseFontSize),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHeadingRow(double fontSize) {
    return [
      _buildHeaderCell('Days', fontSize,
          flex: 1), // Reduced flex for Days column
      SizedBox(width: 8), // Space between columns
      _buildHeaderCell('Breakfast', fontSize),
      SizedBox(width: 8), // Space between columns
      _buildHeaderCell('Brunch', fontSize),
      SizedBox(width: 8), // Space between columns
      _buildHeaderCell('Lunch', fontSize),
      SizedBox(width: 8), // Space between columns
      _buildHeaderCell('Dinner', fontSize),
    ];
  }

  Widget _buildHeaderCell(String label, double fontSize, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          color: const Color(0xFF555555),
          fontWeight: FontWeight.w700,
          fontFamily: "Nunito-Bold",
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _buildDataRows(double fontSize) {
    final data = [
      [
        'Monday',
        '09:00 am - 11:00 am',
        '12:00 pm - 02:00 pm',
        '12:00 pm - 02:00 pm',
        '03:00 pm - 06:00 pm'
      ],
      [
        'Tuesday',
        '09:00 am - 11:00 am',
        '12:00 pm - 02:00 pm',
        '12:00 pm - 02:00 pm',
        '03:00 pm - 06:00 pm'
      ],
      [
        'Wednesday',
        '09:00 am - 11:00 am',
        '12:00 pm - 02:00 pm',
        '12:00 pm - 02:00 pm',
        '03:00 pm - 06:00 pm'
      ],
      [
        'Thursday',
        'Closed',
        'Closed',
        '09:00 am - 11:00 am',
        '12:00 pm - 02:00 pm'
      ],
      ['Friday', 'Closed', 'Closed', 'Closed', '12:00 pm - 02:00 pm'],
      ['Saturday', 'Closed', 'Closed', 'Closed', 'Closed'],
      ['Sunday', 'Closed', 'Closed', 'Closed', 'Closed'],
    ];

    return data.map((row) {
      return Column(
        children: [
          Row(
            children: [
              _buildDataCell(row[0], fontSize,
                  flex: 1, isDay: true), // Reduced flex for Days column
              SizedBox(width: 8), // Space between columns
              _buildDataCell(row[1], fontSize),
              SizedBox(width: 8), // Space between columns
              _buildDataCell(row[2], fontSize),
              SizedBox(width: 8), // Space between columns
              _buildDataCell(row[3], fontSize),
              SizedBox(width: 8), // Space between columns
              _buildDataCell(row[4], fontSize),
            ],
          ),
          const Divider(thickness: 1), // Divider between rows
        ],
      );
    }).toList();
  }

  Widget _buildDataCell(String text, double fontSize,
      {int flex = 1, bool isDay = false}) {
    Color availableColor = const Color(0xFF4ECCA3).withOpacity(.9);
    Color closedColor = const Color(0xFF98A2B3).withOpacity(.8);

    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          color: isDay
              ? Colors.transparent
              : (text == 'Closed' ? closedColor : availableColor),
          borderRadius: BorderRadius.circular(3),
        ),
        padding: EdgeInsets.symmetric(vertical: isDay ? 0 : 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: isDay ? const Color(0xFF555555) : Colors.white,
            fontWeight: isDay ? FontWeight.w500 : FontWeight.w700,
            fontFamily: "Nunito-Regular",
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
