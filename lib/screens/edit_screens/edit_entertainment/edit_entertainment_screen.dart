import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_web_app/main.dart';
import 'package:restaurant_web_app/screens/edit_screens/controller/edit_controller.dart';
import 'package:restaurant_web_app/widgets/global_functions.dart';
import 'package:restaurant_web_app/widgets/loading_dialog.dart';

import '../../../constants/colors.dart';
import '../../../models/resaturant_model.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/round_button.dart';
import '../../../widgets/text_field.dart';
import '../../main_screen/mainscreen_controller/main_controller.dart';
import '../../operating_hour_screen/operating_hour_screen.dart';
import '../../restaurant_detail_screen/restaurant_detail_screen.dart';

class EditEntertainmentScreen extends StatelessWidget {
  // final EventTableController controller = Get.put(EventTableController());
  final controller = Get.put(EditScreenController());

  bool? isFromButtonClick;
  final Function(int)? onNavigate;
  final mainController = Get.put(MainController());

  EditEntertainmentScreen({super.key, this.onNavigate, this.isFromButtonClick});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: isFromButtonClick == null
          ? null
          : AppBar(
              backgroundColor: AppColors.whiteColor,
              toolbarHeight: 110,
              automaticallyImplyLeading: false,
              elevation: 1,
              title: Image.asset(
                'assets/images/appbar_logo.png',
                width: 200,
                height: 70,
              ),
              // actions: [
              //   Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Container(
              //       width: 230,
              //       height: 59,
              //       decoration: BoxDecoration(
              //         color: AppColors.bgColor,
              //         borderRadius: BorderRadius.circular(10),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black.withOpacity(0.1),
              //             offset: Offset(0, 4),
              //             blurRadius: 6,
              //             spreadRadius: 0,
              //           ),
              //         ],
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(4.0),
              //         child: Row(
              //           children: [
              //             SizedBox(width: 8),
              //             Text('Account Settings'),
              //             Spacer(),
              //             PopupMenuButton<String>(
              //               icon: Icon(
              //                 Icons.keyboard_arrow_down_sharp,
              //                 color: AppColors.primaryColor,
              //               ),
              //               onSelected: (value) {
              //                 if (value == 'Logout') {
              //                   mainController.showLogoutDialog(context);
              //                 } else {
              //                   mainController.selectedMenuItem = value;
              //                   mainController.isAddingRestaurant = false;
              //                   mainController.update();
              //                   Get.close(3);
              //                 }
              //               },
              //               itemBuilder: (context) => [
              //                 PopupMenuItem(
              //                   value: 'Home',
              //                   child: Row(
              //                     children: [
              //                       Image.asset(
              //                         'assets/images/home.png',
              //                         width: 24,
              //                         height: 24,
              //                       ),
              //                       SizedBox(width: 16),
              //                       Text('Home'),
              //                     ],
              //                   ),
              //                 ),
              //                 PopupMenuItem(
              //                   value: 'View Restaurant Details',
              //                   child: Row(
              //                     children: [
              //                       Image.asset(
              //                         'assets/images/resturant_detail.png',
              //                         width: 24,
              //                         height: 24,
              //                       ),
              //                       SizedBox(width: 16),
              //                       Text('View Restaurant Details'),
              //                     ],
              //                   ),
              //                 ),
              //                 PopupMenuItem(
              //                   value: 'Change Password',
              //                   child: Row(
              //                     children: [
              //                       Image.asset(
              //                         'assets/images/change_password.png',
              //                         width: 24,
              //                         height: 24,
              //                       ),
              //                       SizedBox(width: 16),
              //                       Text('Change Password'),
              //                     ],
              //                   ),
              //                 ),
              //                 PopupMenuItem(
              //                   value: 'Logout',
              //                   child: Row(
              //                     children: [
              //                       Image.asset(
              //                         'assets/images/logout.png',
              //                         width: 24,
              //                         height: 24,
              //                       ),
              //                       SizedBox(width: 16),
              //                       Text('Logout'),
              //                     ],
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ],
            ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: Responsive.isMobile(context)
                        ? 30
                        : (Responsive.isTablet(context) ? 36 : 42),
                    height: Responsive.isMobile(context)
                        ? 30
                        : (Responsive.isTablet(context) ? 36 : 42),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      iconSize: Responsive.isMobile(context)
                          ? 14
                          : (Responsive.isTablet(context) ? 16 : 18),
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.primaryColor),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Edit Entertainment',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontFamily: 'Nunito-Regular',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('restaurants')
                    .doc(auth.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: Get.height * 0.6,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  RestaurantModel resModel;
                  if (snapshot.data != null) {
                    resModel = RestaurantModel.fromDocumentSnapshot(snapshot
                        .data as DocumentSnapshot<Map<String, dynamic>>);

                    // Access the entertainmentScheduleList
                    List<EntertainmentScheduleModel> entertainmentList =
                        resModel.entertainmentScheduleList;

                    // Only update controller values if they are empty
                    if (controller.eventNames.isEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // Extract data from entertainmentList
                        controller.eventNames.assignAll(entertainmentList
                            .map((event) => event.eventName)
                            .toList());

                        controller.byValues.assignAll(entertainmentList
                            .map((event) => event.eventBy)
                            .toList());

                        controller.selectedDays.assignAll(entertainmentList
                            .map((event) => event.day)
                            .toList());

                        controller.selectedDates.assignAll(
                          entertainmentList.map((event) {
                            return event.date.isNotEmpty
                                ? DateFormat('dd MMM, yyyy').parse(event.date)
                                : null; // Ensure null safety
                          }).toList(),
                        );

                        // Parse startTime and endTime to TimeOfDay
                        controller.selectedTimes.assignAll(
                          entertainmentList.map((event) {
                            return {
                              'from': parseTime(event.startTime),
                              'to': parseTime(event.endTime),
                            };
                          }).toList(),
                        );

                        controller.checkBoxValues.assignAll(List.generate(
                            entertainmentList.length, (index) => false));
                      });
                    }
                  } else {
                    resModel = RestaurantModel.initialize();
                  }
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Entertainment Schedule',
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontFamily: 'Nunito-Regular',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.95,
                            ),
                            child: DataTable(
                              border: TableBorder.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              headingRowColor: MaterialStateColor.resolveWith(
                                (states) => AppColors.lightbgColor,
                              ),
                              headingTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              columns: const [
                                DataColumn(
                                  label: Expanded(
                                    child: Center(
                                      child: Text('Name',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Center(
                                      child: Text('By',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Center(
                                      child: Text('Day',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Center(
                                      child: Text('Date',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Center(
                                      child: Text('Time',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                ),
                              ],
                              rows: List.generate(controller.eventNames.length,
                                  (index) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColors.primaryColor,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              child: Checkbox(
                                                value: controller
                                                    .checkBoxValues[index],
                                                side: const BorderSide(
                                                    color: Colors.transparent),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0)),
                                                onChanged: (bool? newValue) {
                                                  controller
                                                      .toggleCheckbox(index);
                                                },
                                                activeColor: Colors.transparent,
                                                checkColor:
                                                    AppColors.primaryColor,
                                              ),
                                            ),
                                          ),
                                          Text(controller.eventNames[index]),
                                        ],
                                      ),
                                    ),
                                    DataCell(Text(controller.byValues[index])),
                                    DataCell(
                                      DropdownButton<String>(
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down_sharp,
                                          color: AppColors.primaryColor,
                                        ),
                                        isExpanded: true,
                                        value: controller.selectedDays[index],
                                        hint: const Text('Select Day'),
                                        items: controller.daysOfWeek
                                            .map(
                                              (day) => DropdownMenuItem(
                                                value: day,
                                                child: Text(day),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (newValue) {
                                          controller.selectedDays[index] =
                                              newValue;
                                        },
                                      ),
                                    ),
                                    DataCell(
                                      GestureDetector(
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          );
                                          if (pickedDate != null) {
                                            controller.selectedDates[index] =
                                                pickedDate;
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 30,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Center(
                                            child: Text(
                                              controller.selectedDates[index] !=
                                                      null
                                                  ? DateFormat('dd MMM, yyyy')
                                                      .format(controller
                                                              .selectedDates[
                                                          index]!)
                                                  : 'Set Date',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      GestureDetector(
                                        onTap: () async {
                                          TimeOfDay? fromTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          if (fromTime != null) {
                                            TimeOfDay? toTime =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: fromTime,
                                            );
                                            if (toTime != null) {
                                              controller.selectedTimes[index] =
                                                  {
                                                "from": fromTime,
                                                "to": toTime,
                                              };
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 30,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Center(
                                            child: Text(
                                              controller.selectedTimes[index]
                                                              ["from"] !=
                                                          null &&
                                                      controller.selectedTimes[
                                                              index]["to"] !=
                                                          null
                                                  ? '${controller.selectedTimes[index]["from"]!.format(context)} - ${controller.selectedTimes[index]["to"]!.format(context)}'
                                                  : 'Set Time',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ), // Time logic here
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Responsive.isMobile(context)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (controller.customEventController.text
                                            .isNotEmpty &&
                                        controller.customByController.text
                                            .isNotEmpty) {
                                      // Add both event name and by name together
                                      controller.addCustomEvent(
                                        controller.customEventController.text,
                                        controller.customByController.text,
                                      );
                                      // Clear both fields after adding
                                      controller.customEventController.clear();
                                      controller.customByController.clear();
                                    }
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        color: AppColors.primaryColor,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  inputFormatterslist: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z ]')),
                                  ],
                                  width: 300,
                                  borderColor:
                                      AppColors.darkGrey.withOpacity(0.1),
                                  borderRadius: 8,
                                  controller: controller.customEventController,
                                  hintText: "Enter Event",
                                  fillColor: AppColors.whiteColor,
                                  cursorColor: AppColors.primaryColor,
                                  inputStyle: const TextStyle(
                                      color: AppColors.blackColor),
                                  hintStyle: const TextStyle(
                                      color: AppColors.blackColor),
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  inputFormatterslist: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z ]')),
                                  ],
                                  width: 300,
                                  borderColor:
                                      AppColors.darkGrey.withOpacity(0.1),
                                  borderRadius: 8,
                                  controller: controller.customByController,
                                  hintText: " By",
                                  fillColor: AppColors.whiteColor,
                                  cursorColor: AppColors.primaryColor,
                                  inputStyle: const TextStyle(
                                      color: AppColors.blackColor),
                                  hintStyle: const TextStyle(
                                      color: AppColors.blackColor),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (controller.customEventController.text
                                            .isNotEmpty &&
                                        controller.customByController.text
                                            .isNotEmpty) {
                                      // Add both event name and by name together
                                      controller.addCustomEvent(
                                        controller.customEventController.text,
                                        controller.customByController.text,
                                      );
                                      // Clear both fields after adding
                                      controller.customEventController.clear();
                                      controller.customByController.clear();
                                    }
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        color: AppColors.primaryColor,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                CustomTextField(
                                  inputFormatterslist: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z ]')),
                                  ],
                                  width: 300,
                                  borderColor:
                                      AppColors.darkGrey.withOpacity(0.1),
                                  borderRadius: 8,
                                  controller: controller.customEventController,
                                  hintText: "Event Name",
                                  fillColor: AppColors.whiteColor,
                                  cursorColor: AppColors.primaryColor,
                                  inputStyle: const TextStyle(
                                      color: AppColors.blackColor),
                                  hintStyle: const TextStyle(
                                      color: AppColors.blackColor),
                                ),
                                const SizedBox(width: 20),
                                CustomTextField(
                                  inputFormatterslist: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z ]')),
                                  ],
                                  width: 300,
                                  borderColor:
                                      AppColors.darkGrey.withOpacity(0.1),
                                  borderRadius: 8,
                                  controller: controller.customByController,
                                  hintText: "Entered By",
                                  fillColor: AppColors.whiteColor,
                                  cursorColor: AppColors.primaryColor,
                                  inputStyle: const TextStyle(
                                      color: AppColors.blackColor),
                                  hintStyle: const TextStyle(
                                      color: AppColors.blackColor),
                                ),
                              ],
                            ),
                      const SizedBox(height: 20),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              title: "Update",
                              textStyle: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize:
                                    Responsive.isMobile(context) ? 16 : 18,
                                fontWeight: FontWeight.w600,
                              ),
                              backgroundColor: AppColors.primaryColor,
                              borderRadius: 8,
                              width: Responsive.isMobile(context)
                                  ? Get.width * 0.4
                                  : Get.width * 0.2,
                              onPressed: () {
                                controller.onTapEntertainment(
                                    context, resModel);

                                // Get.snackbar('Update',
                                //     'Your data is successfully updated.');
                                // Get.to(() => RestaurantDetailScreen(
                                //       isFromButtonClick: true,
                                //     ));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
