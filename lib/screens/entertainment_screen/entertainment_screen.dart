import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_web_app/screens/add_restaurant/add_resturant_controller/add_resturant%20_controller.dart';
import 'package:restaurant_web_app/widgets/account_settings_popup_widget.dart';
import 'package:restaurant_web_app/widgets/global_functions.dart';
import '../../constants/colors.dart';
import '../../main.dart';
import '../../utils/responsive.dart';
import '../../widgets/round_button.dart';
import '../../widgets/text_field.dart';
import '../main_screen/mainscreen_controller/main_controller.dart';

class EventTableController extends GetxController {
  final List<String> eventNames = [
    "Live Music",
    "DJ Night",
    "Karaoke",
    "Trivia Nights",
    "Sports Screening",
    "Hookah",
  ].obs;

  final List<String> byValues = [
    "Neil Young",
    "Neil Young",
    "Neil Young",
    "Neil Young",
    "Neil Young",
    "Neil Young",
  ].obs;

  final List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  final selectedDays = List<String?>.filled(7, null).obs;
  final selectedDates = List<DateTime?>.filled(7, null).obs;
  final selectedTimes = List<Map<String, TimeOfDay?>>.generate(
    7,
    (_) => {"from": null, "to": null},
  ).obs;

  final customEventController = TextEditingController();
  final customByController = TextEditingController();
  final checkBoxValues = List<bool>.filled(6, false).obs;

  void addCustomEvent(String eventName, String byName) {
    eventNames.add(eventName);
    byValues.add(byName);
    checkBoxValues.add(false); // Add a checkbox for the new entry
    selectedDays.add(null);
    selectedDates.add(null);
    selectedTimes.add({"from": null, "to": null});
  }

  void toggleCheckbox(int index) {
    checkBoxValues[index] = !checkBoxValues[index];
    update();
  }
}

class Entertainment_Screen extends StatelessWidget {
  final controller = Get.put(AddRestaurantController());

  bool? isFromButtonClick;
  final Function(int)? onNavigate;
  final mainController = Get.put(MainController());

  Entertainment_Screen({super.key, this.onNavigate, this.isFromButtonClick});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

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
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 230,
                    height: 59,
                    decoration: BoxDecoration(
                      color: AppColors.bgColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Obx(() => currentUserDataModel.value!.address.text != ''? AccountSettingsPopupWidget():AccountNoAuthPopupWidget(),),
                    ),
                  ),
                ),
              ],
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
                    'Add Entertainment',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontFamily: 'Nunito-Regular',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // controller.updateRestaurantData(context);
                },
                child: const Text(
                  'Entertainment Schedule',
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: controller.eventNames.length == 0
                      ? SizedBox()
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width * 0.95,
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
                                                        .selectedDates[index]!)
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
                                            controller.selectedTimes[index] = {
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
                            if (controller
                                    .customEventController.text.isNotEmpty &&
                                controller.customByController.text.isNotEmpty) {
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
                          borderColor: AppColors.darkGrey.withOpacity(0.1),
                          borderRadius: 8,
                          controller: controller.customEventController,
                          hintText: "Enter Event",
                          fillColor: AppColors.whiteColor,
                          cursorColor: AppColors.primaryColor,
                          inputStyle:
                              const TextStyle(color: AppColors.blackColor),
                          hintStyle:
                              const TextStyle(color: AppColors.blackColor),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          inputFormatterslist: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z ]')),
                          ],
                          width: 300,
                          borderColor: AppColors.darkGrey.withOpacity(0.1),
                          borderRadius: 8,
                          controller: controller.customByController,
                          hintText: "Enter By",
                          fillColor: AppColors.whiteColor,
                          cursorColor: AppColors.primaryColor,
                          inputStyle:
                              const TextStyle(color: AppColors.blackColor),
                          hintStyle:
                              const TextStyle(color: AppColors.blackColor),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (controller
                                    .customEventController.text.isNotEmpty &&
                                controller.customByController.text.isNotEmpty) {
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
                          borderColor: AppColors.darkGrey.withOpacity(0.1),
                          borderRadius: 8,
                          controller: controller.customEventController,
                          hintText: "Enter Event",
                          fillColor: AppColors.whiteColor,
                          cursorColor: AppColors.primaryColor,
                          inputStyle:
                              const TextStyle(color: AppColors.blackColor),
                          hintStyle:
                              const TextStyle(color: AppColors.blackColor),
                        ),
                        const SizedBox(width: 20),
                        CustomTextField(
                          inputFormatterslist: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z ]')),
                          ],
                          width: 300,
                          borderColor: AppColors.darkGrey.withOpacity(0.1),
                          borderRadius: 8,
                          controller: controller.customByController,
                          hintText: "Enter By",
                          fillColor: AppColors.whiteColor,
                          cursorColor: AppColors.primaryColor,
                          inputStyle:
                              const TextStyle(color: AppColors.blackColor),
                          hintStyle:
                              const TextStyle(color: AppColors.blackColor),
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      title: "Save and Continue",
                      textStyle: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: Responsive.isMobile(context) ? 16 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: AppColors.primaryColor,
                      borderRadius: 8,
                      width: Responsive.isMobile(context)
                          ? screenWidth * 0.3
                          : screenWidth * 0.2,
                      onPressed: () {
                        controller.onTapEntertainment(context);
                        // Prepare entertainment schedule data
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
