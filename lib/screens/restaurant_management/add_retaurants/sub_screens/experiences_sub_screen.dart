import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../../../../controllers/experiences_sub_screen_controller.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/text_and_field_drop_down.dart';

class ExperiencesSubScreen extends StatelessWidget {
  ExperiencesSubScreen({super.key, required this.formKey});

  final controller = Get.put(ExperiencesSubScreenController());
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 1000;

    return Expanded(
      child: SingleChildScrollView(
        child: Form(
          key: controller.experienceSubScreenFormKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Horizontal list of saved events
              Obx(() {
                return controller.events.isNotEmpty
                    ? Container(
                        height: 100, // Adjust height as needed
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.events.length,
                          itemBuilder: (context, index) {
                            final event = controller.events[index];
                            return Container(
                              width: 200, // Fixed width for each event card
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event['eventName'] ?? 'Unnamed Event',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        event['date'] ?? 'No Date',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                       const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            'From ${event['startTime']} To ${event['endTime']}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        controller.removeEvent(index);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink();
              }),
              const SizedBox(height: 16),
              // Form container
              Center(
                child: Container(
                  width: mobileView ? Get.width : Get.width * 0.5,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: dimWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextAndFieldsOrDropDown(
                        labelText: 'Event Name',
                        fieldHintText: 'Music and Arts Festival 2024',
                        fieldController: controller.eventNameController,
                        isDropDown: false,
                        fieldValidator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter event name.';
                          }
                          return null;
                        },
                      ),
                      TextAndFieldsOrDropDown(
                        labelText: 'Hosted by',
                        fieldHintText: 'Cameron Williamson',
                        fieldController: controller.hostedByController,
                        isDropDown: false,
                        fieldValidator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter hosted by.';
                          }
                          return null;
                        },
                      ),
                      GestureDetector(
                        onTap: () => controller.selectDate(context),
                        child: AbsorbPointer(
                          child: TextAndFieldsOrDropDown(
                            labelText: 'Date',
                            fieldHintText: '17 June 2024',
                            fieldController: controller.dateController,
                            isDropDown: false,
                            fieldValidator: (value) {
                              if (value!.isEmpty) {
                                return 'Please select a date.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.selectTime(context),
                        child: AbsorbPointer(
                          child: TextAndFieldsOrDropDown(
                            labelText: 'Start Time',
                            fieldHintText: '9:00 am',
                            fieldController: controller.timeController,
                            isDropDown: false,
                            fieldValidator: (value) {
                              if (value!.isEmpty) {
                                return 'Please select a time.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.selectEndTime(context),
                        child: AbsorbPointer(
                          child: TextAndFieldsOrDropDown(
                            labelText: 'End Time',
                            fieldHintText: '12:00 am',
                            fieldController: controller.endTimeController,
                            isDropDown: false,
                            fieldValidator: (value) {
                              if (value!.isEmpty) {
                                return 'Please select a time.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: CustomButton(
                  laBelText: 'Add another event',
                  fontSize: 16,
                  height: mobileView ? 44 : 48,
                  width: mobileView ? Get.width : Get.width * 0.5,
                  isPrefixIcon: true,
                  isBorder: true,
                  borderColor: green,
                  iconWidget: Icon(
                    Icons.add_box_outlined,
                    color: green,
                    size: 28,
                  ),
                  shadow: [],
                  containerColor: primaryColor.withOpacity(0.4),
                  textColor: blackColor,
                  ontapp: controller.saveEvent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
