import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/utils/responsive.dart';

// ignore: must_be_immutable
class AboutSectionWidget extends StatefulWidget {
  AboutSectionWidget({
    super.key,
    required this.aboutText,
    required this.resturantID,
  });
  String resturantID;
  String aboutText;

  @override
  State<AboutSectionWidget> createState() => _AboutSectionWidgetState();
}

class _AboutSectionWidgetState extends State<AboutSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        MyAbout(resturantID: widget.resturantID),

        // //MyAbout(resturantID: widget.resturantID),
        // SizedBox(
        //   height: 10,
        // ),
        widget.aboutText.contains('Soon')
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
                      widget.aboutText,
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
      ],
    );
  }
}

class MyAbout extends StatefulWidget {
  const MyAbout({super.key, required this.resturantID});
  final String resturantID;

  @override
  State<MyAbout> createState() => _MyAboutState();
}

class _MyAboutState extends State<MyAbout> {
  Stream<QuerySnapshot>? _operatingHoursStream;

  final List<String> dayOrder = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.resturantID.isNotEmpty) {
      _operatingHoursStream = FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.resturantID)
          .collection('operatingHours')
          .snapshots();
    }
  }

  String getToday() {
    final now = DateTime.now();
    return dayOrder[now.weekday - 1]; // DateTime.weekday: 1 = Monday
  }

  String getTimeRange(Map<String, dynamic> timeData) {
    if (timeData['isClosed'] == true) return 'Closed';
    return '${timeData['startTime']} - ${timeData['endTime']}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _operatingHoursStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No operating hours available.'));
        }

        final docs = snapshot.data!.docs;
        final Map<String, Map<String, dynamic>> dayData = {
          for (var doc in docs) doc.id: doc.data() as Map<String, dynamic>
        };

        final today = getToday();
        final todayHours = dayData[today] ?? {};

        String todayHoursText = ['Breakfast', 'Brunch', 'Lunch', 'Dinner']
            .map((meal) => getTimeRange(todayHours[meal] ?? {'isClosed': true}))
            .where((range) => range != 'Closed')
            .join(', ');

        if (todayHoursText.isEmpty) todayHoursText = 'Closed';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Text(
                    'Open hours:',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontFamily: 'Nunito-Regular',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Today:\n${todayHoursText.replaceAll(',','\n')}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito-Regular',
                      color: AppColors.darkGrey,
                    ),
                    maxLines: null, // Allow unlimited lines if needed
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                _showBottomSheet(dayData);
              },
              child: Text(
                'See Hours',
                style: TextStyle(
                    color: const Color.fromARGB(255, 15, 70, 16),
                    fontFamily: 'Nunito-Bold',
                    fontWeight: FontWeight.w900,
                    fontSize: 16),
              ),
            )
          ],
        );
      },
    );
  }

  void _showBottomSheet(Map<String, Map<String, dynamic>> allHours) {
    final today = getToday();
    final filteredDays = dayOrder.where((day) => day != today).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  const Text(
                    "Open Time",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito-Regular',
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredDays.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, thickness: 0.4),
                  itemBuilder: (_, index) {
                    final day = filteredDays[index];
                    final data = allHours[day] ?? {};
                    final timeRanges = [
                      'Breakfast',
                      'Brunch',
                      'Lunch',
                      'Dinner'
                    ]
                        .map((meal) =>
                            getTimeRange(data[meal] ?? {'isClosed': true}))
                        .where((range) => range != 'Closed')
                        .toList();

                    final isClosed = timeRanges.isEmpty;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            day,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontFamily: 'Nunito-Regular',
                            ),
                          ),
                          Flexible(
                            child: isClosed
                                ? Text(
                                    'Closed',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 13,
                                      fontFamily: 'Nunito-BoldItalic',
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: timeRanges
                                        .map(
                                          (range) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4),
                                            child: Text(
                                              range,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: 13,
                                                fontFamily: 'Nunito-BoldItalic',
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}





// class MyAbout extends StatefulWidget {
//   MyAbout({
//     super.key,
//     required this.resturantID,
//   });
//   String resturantID;

//   @override
//   State<MyAbout> createState() => _MyAboutState();
// }

// class _MyAboutState extends State<MyAbout> {

//  Stream? _operatingHoursStream;

//     @override
//   void initState() {
//     super.initState();
//     if (widget.resturantID != '') {
//       _operatingHoursStream = FirebaseFirestore.instance
//           .collection('restaurants')
//           .doc(widget.resturantID)
//           .collection('operatingHours')
//           .snapshots();
//     }
//   }
//   Widget build(BuildContext context) {

//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: StreamBuilder(
//         stream: widget.resturantID == ''
//             ? null
//             : _operatingHoursStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No operating hours available.'));
//           }

//           // Extract data
//           final operatingHours = snapshot.data!.docs;
//           const dayOrder = [
//             'Monday',
//             'Tuesday',
//             'Wednesday',
//             'Thursday',
//             'Friday',
//             'Saturday',
//             'Sunday'
//           ];
//           // Sort operatingHours by day order
//           operatingHours.sort((a, b) {
//             int indexA =
//                 dayOrder.indexOf(a.id); // Use the document ID (e.g., "Monday")
//             int indexB = dayOrder.indexOf(b.id);
//             return indexA.compareTo(indexB);
//           });

//           // Build rows dynamically
//           List<DataRow> rows = operatingHours.map<DataRow>((doc)  {
//             final day = doc.id; // e.g., "Monday", "Tuesday"
//             final breakfast = doc['Breakfast'] ?? {'isClosed': true};
//             final brunch = doc['Brunch'] ?? {'isClosed': true};
//             final lunch = doc['Lunch'] ?? {'isClosed': true};
//             final dinner = doc['Dinner'] ?? {'isClosed': true};
//             // final lateNight = doc['Late Night'] ?? {'isClosed': true};

//             // Helper to get the time or "Closed"
//             String getTimeRange(Map<String, dynamic> timeData) {
//               if (timeData['isClosed'] == true) return 'Closed';
//               return '${timeData['startTime']} - ${timeData['endTime']}';
//             }

//             // Use your `_buildRow` method
//             return _buildRow(day, getTimeRange(breakfast), getTimeRange(brunch),
//                 getTimeRange(lunch), getTimeRange(dinner)
//                 // getTimeRange(lateNight),
//                 );
//           }).toList();

//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(6),
//             ),
//             width: Get.width,
//             child: Padding(
//               padding: const EdgeInsets.only(
//                   left: 4.0, right: 4, top: 22, bottom: 10),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   dividerThickness: 1,
//                   columnSpacing: 4,
//                   horizontalMargin: 5,
//                   dataRowMinHeight: 12,
//                   headingRowHeight: 32,
//                   columns: [
//                     DataColumn(
//                       label: SizedBox(
//                         width: 60,
//                         child: Row(
//                           children: [
//                             Text(
//                               '',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xFF555555),
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: "Nunito-Bold",
//                               ),
//                             ),
//                             Spacer(),
//                             Container(
//                               height: Get.height,
//                               width: 0.5,
//                               color: AppColors.hintText,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text(
//                         'Breakfast',
//                         style: TextStyle(
//                           fontSize: 8,
//                           color: AppColors.tableHeadingColor,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: "Nunito-Sans",
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text(
//                         'Brunch',
//                         style: TextStyle(
//                           fontSize: 8,
//                           color: AppColors.tableHeadingColor,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: "Nunito-Sans",
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text(
//                         'Lunch',
//                         style: TextStyle(
//                           fontSize: 8,
//                           color: AppColors.tableHeadingColor,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: "Nunito-Sans",
//                         ),
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text(
//                         'Dinner',
//                         style: TextStyle(
//                           fontSize: 8,
//                           color: AppColors.tableHeadingColor,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: "Nunito-Sans",
//                         ),
//                       ),
//                     ),
//                     // DataColumn(
//                     //   label: Text(
//                     //     'Late Night',
//                     //     style: TextStyle(
//                     //       fontSize: 8,
//                     //       color: AppColors.tableHeadingColor,
//                     //       fontWeight: FontWeight.w500,
//                     //       fontFamily: "Nunito-Sans",
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                   rows: rows,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   DataRow _buildRow(String day, String breakfast, String brunch, String lunch,
//       String dinner) {
//     Color availableColor = AppColors.primaryColor.withOpacity(.9);
//     Color closedColor = AppColors.hintText.withOpacity(.8);

//     return DataRow(
//       cells: [
//         DataCell(
//           SizedBox(
//             width: 60,
//             child: Row(
//               children: [
//                 Text(
//                   day,
//                   style: TextStyle(
//                     fontSize: 8,
//                     color: AppColors.tableHeadingColor,
//                     fontWeight: FontWeight.w500,
//                     fontFamily: "Nunito-Sans",
//                   ),
//                 ),
//                 const Spacer(),
//                 Container(
//                   height: Get.height,
//                   width: 0.5,
//                   color: AppColors.hintText,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         DataCell(buildCell(breakfast, availableColor, closedColor)),
//         DataCell(buildCell(brunch, availableColor, closedColor)),
//         DataCell(buildCell(lunch, availableColor, closedColor)),
//         DataCell(buildCell(dinner, availableColor, closedColor)),
//         // DataCell(buildCell(lateNight, availableColor, closedColor)),
//       ],
//     );
//   }

//   Widget buildCell(String value, Color availableColor, Color closedColor) {
//     return Container(
//       width: 66,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(3),
//         color: value == 'Closed' ? closedColor : availableColor,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
//         child: Text(
//           value,
//           style: const TextStyle(
//             fontSize: 9,
//             color: Colors.white,
//             fontWeight: FontWeight.w700,
//             fontFamily: "Nunito-Sans",
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }