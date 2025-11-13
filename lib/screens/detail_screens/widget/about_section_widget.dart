import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/utils/responsive.dart';

class AboutSectionWidget extends StatelessWidget {
  AboutSectionWidget({
    super.key,
    required this.aboutText,
    required this.resturantID,
  });
  String resturantID;
  String aboutText;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Text(
            'Operating hours',
            style: TextStyle(
              color: AppColors.headingTextColor,
              fontSize: Responsive.isMobile(context) ? 20 : 28,
              fontFamily: 'aftika-regular',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 10),
        MyAbout(resturantID: resturantID),
        SizedBox(height: 10),
        aboutText.contains('Soon')
            ? SizedBox()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Text(
                      'About',
                      style: TextStyle(
                        color: AppColors.headingTextColor,
                        fontSize: Responsive.isMobile(context) ? 20 : 28,
                        fontFamily: 'aftika-regular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Text(
                      aboutText,
                      style: TextStyle(
                        color: AppColors.tableHeadingColor,
                        fontSize: 14,
                        fontFamily: 'Nunito-Regular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class MyAbout extends StatelessWidget {
  MyAbout({super.key, required this.resturantID});
  String resturantID;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: StreamBuilder(
        stream: resturantID == ''
            ? null
            : FirebaseFirestore.instance
                  .collection('restaurants')
                  .doc(resturantID)
                  .collection('operatingHours')
                  .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No operating hours available.'));
          }

          // Extract data
          final operatingHours = snapshot.data!.docs;
          const dayOrder = [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday',
          ];
          // Sort operatingHours by day order
          operatingHours.sort((a, b) {
            int indexA = dayOrder.indexOf(
              a.id,
            ); // Use the document ID (e.g., "Monday")
            int indexB = dayOrder.indexOf(b.id);
            return indexA.compareTo(indexB);
          });

          // Build rows dynamically
          List<DataRow> rows = operatingHours.map((doc) {
            final day = doc.id; // e.g., "Monday", "Tuesday"
            final breakfast = doc['Breakfast'] ?? {'isClosed': true};
            final brunch = doc['Brunch'] ?? {'isClosed': true};
            final lunch = doc['Lunch'] ?? {'isClosed': true};
            final dinner = doc['Dinner'] ?? {'isClosed': true};
            // final lateNight = doc['Late Night'] ?? {'isClosed': true};

            // Helper to get the time or "Closed"
            String getTimeRange(Map<String, dynamic> timeData) {
              if (timeData['isClosed'] == true) return 'Closed';
              return '${timeData['startTime']} - ${timeData['endTime']}';
            }

            // Use your `_buildRow` method
            return _buildRow(
              day,
              getTimeRange(breakfast),
              getTimeRange(brunch),
              getTimeRange(lunch),
              getTimeRange(dinner),
              // getTimeRange(lateNight),
            );
          }).toList();

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 4.0,
                right: 4,
                top: 22,
                bottom: 10,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dividerThickness: 1,
                  columnSpacing: 4,
                  horizontalMargin: 5,
                  dataRowMinHeight: 12,
                  headingRowHeight: 32,
                  columns: [
                    DataColumn(
                      label: SizedBox(
                        width: 60,
                        child: Row(
                          children: [
                            Text(
                              '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Nunito-Bold",
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: Get.height,
                              width: 0.5,
                              color: AppColors.hintText,
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Breakfast',
                        style: TextStyle(
                          fontSize: 8,
                          color: AppColors.tableHeadingColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Nunito-Sans",
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Brunch',
                        style: TextStyle(
                          fontSize: 8,
                          color: AppColors.tableHeadingColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Nunito-Sans",
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Lunch',
                        style: TextStyle(
                          fontSize: 8,
                          color: AppColors.tableHeadingColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Nunito-Sans",
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Dinner',
                        style: TextStyle(
                          fontSize: 8,
                          color: AppColors.tableHeadingColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Nunito-Sans",
                        ),
                      ),
                    ),
                    // DataColumn(
                    //   label: Text(
                    //     'Late Night',
                    //     style: TextStyle(
                    //       fontSize: 8,
                    //       color: AppColors.tableHeadingColor,
                    //       fontWeight: FontWeight.w500,
                    //       fontFamily: "Nunito-Sans",
                    //     ),
                    //   ),
                    // ),
                  ],
                  rows: rows,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  DataRow _buildRow(
    String day,
    String breakfast,
    String brunch,
    String lunch,
    String dinner,
  ) {
    Color availableColor = AppColors.primaryColor.withOpacity(.9);
    Color closedColor = AppColors.hintText.withOpacity(.8);

    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: 60,
            child: Row(
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 8,
                    color: AppColors.tableHeadingColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Nunito-Sans",
                  ),
                ),
                const Spacer(),
                Container(
                  height: Get.height,
                  width: 0.5,
                  color: AppColors.hintText,
                ),
              ],
            ),
          ),
        ),
        DataCell(buildCell(breakfast, availableColor, closedColor)),
        DataCell(buildCell(brunch, availableColor, closedColor)),
        DataCell(buildCell(lunch, availableColor, closedColor)),
        DataCell(buildCell(dinner, availableColor, closedColor)),
        // DataCell(buildCell(lateNight, availableColor, closedColor)),
      ],
    );
  }

  Widget buildCell(String value, Color availableColor, Color closedColor) {
    return Container(
      width: 66,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: value == 'Closed' ? closedColor : availableColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 9,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFamily: "Nunito-Sans",
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
