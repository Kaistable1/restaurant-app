import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:savrly/controllers/add_restaurants_controller.dart';
import 'package:savrly/widgets/button.dart';
import 'package:savrly/widgets/map_widget.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/text_styles.dart';
import '../../../controllers/add_event_controller.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../widgets/customheader_widget.dart';
import '../../../widgets/text_and_field_drop_down.dart';

class AddEvents extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final drawerController = Get.put(DrawerControllerX());
  final controller = Get.put(AddEventController());
  AddEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    double screenWidth = size.width;
    double screenHeight = size.height;
    bool isLargeScreen = screenWidth > 1600;

    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth <= 900;

    double paddingValue = isMobile ? 16 : (isTablet ? 20 : 24);
    double imageWidth = 216;
    double imageHeight = 162;
    if (screenWidth < 500) {
      imageWidth = 140;
      imageHeight = 100;
    } else if (screenWidth < 900) {
      imageWidth = 180;
      imageHeight = 130;
    }
    final ScrollController horizontalScrollController = ScrollController();

    if (controller.selectedEventModel != null) {
      controller.eventNameController.text =
          controller.selectedEventModel!.eventName;
      controller.selectEvent.value = controller.selectedEventModel!.eventType;

      controller.locationController.text =
          controller.selectedEventModel!.location;
      controller.phoneNumberController.text =
          controller.selectedEventModel!.phoneNumber;
      controller.urlController.text = controller.selectedEventModel!.url;
      controller.dateController.text = controller.selectedEventModel!.date;
      controller.timeController.text = controller.selectedEventModel!.time;
      controller.descriptionController.text =
          controller.selectedEventModel!.description;
      controller.selectEvent.value = controller.selectedEventModel!.eventType;
      controller.uploadedImages.clear();
      for (var url in controller.selectedEventModel!.imageUrls) {
        controller.uploadedImages.add(
          UploadedImageModel(url: url),
        );
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        right: paddingValue,
        top: paddingValue,
        left: paddingValue,
        bottom: paddingValue,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeaderWidget(
                title: 'Add event',
                back: true,
                onBackTap: () {
                  drawerController.addEvent.value = false;
                },
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Container(
                  width: isTablet
                      ? screenWidth * .9
                      : isMobile
                          ? screenWidth * .9
                          : screenWidth * .6,
                  height:
                      isLargeScreen ? screenHeight * 2.1 : screenHeight * 3.1,
                  decoration: BoxDecoration(
                    color: dimWhite,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Event images',
                          style: headingText.copyWith(
                              fontSize: isMobile ? 16 : 20),
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () => SizedBox(
                            height: imageHeight + 20,
                            // Fixed height for scrollable area
                            child: GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                // Handle mouse drag
                                final newOffset =
                                    horizontalScrollController.offset -
                                        details.delta.dx;
                                horizontalScrollController.jumpTo(
                                  newOffset.clamp(
                                    0.0,
                                    horizontalScrollController
                                        .position.maxScrollExtent,
                                  ),
                                );
                              },
                              child: Scrollbar(
                                controller: horizontalScrollController,
                                thumbVisibility:
                                    controller.uploadedImages.length *
                                            (imageWidth + 12) >
                                        screenWidth,
                                // Show scrollbar only when content exceeds width
                                child: Listener(
                                  onPointerSignal: (PointerSignalEvent event) {
                                    if (event is PointerScrollEvent) {
                                      final scrollDelta = event.scrollDelta.dy;
                                      horizontalScrollController.jumpTo(
                                        horizontalScrollController.offset +
                                            scrollDelta,
                                      );
                                    }
                                  },
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    controller: horizontalScrollController,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: Row(
                                      children: [
                                        ...controller.uploadedImages
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          UploadedImageModel image =
                                              entry.value;

                                          return Stack(
                                            children: [
                                              Container(
                                                width: imageWidth,
                                                height: imageHeight,
                                                margin: const EdgeInsets.only(
                                                    right: 12),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: DecorationImage(
                                                    image: image.url != null
                                                        ? NetworkImage(
                                                            image.url!)
                                                        : MemoryImage(
                                                                image.bytes!)
                                                            as ImageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 4,
                                                right: 4,
                                                child: GestureDetector(
                                                  onTap: () => controller
                                                      .removeImage(index),
                                                  child: const MouseRegion(
                                                    cursor: SystemMouseCursors
                                                        .click,
                                                    child: CircleAvatar(
                                                      radius: 10,
                                                      backgroundColor:
                                                          Colors.red,
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 13,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                        // Upload Image Box
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: InkWell(
                                            onTap: controller.pickImageWeb,
                                            child: Container(
                                              width: imageWidth,
                                              height: imageHeight,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: primaryColor
                                                      .withOpacity(0.4),
                                                  width: 0.6,
                                                ),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    spreadRadius: 1,
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .add_circle_outline_rounded,
                                                    color: primaryColor,
                                                    size: 40,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    'Add More Photos',
                                                    style: simpleText.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextAndFieldsOrDropDown(
                          labelText: 'Event name',
                          fieldHintText: 'Music and Arts Festival 2024',
                          fieldController: controller.eventNameController,
                          isDropDown: false,
                          fieldValidator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter events name.';
                            }
                            return null;
                          },
                        ),
                        TextAndFieldsOrDropDown(
                          labelText: 'Event type',
                          dropHintText: 'Concert',
                          items: controller.events,
                          currentValue: controller.selectEvent.value,
                          onChanged: (value) =>
                              controller.selectEvent.value = value!,
                          dropDownValidator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please select an event type.';
                            }
                            return null;
                          },
                          isDropDown: true,
                        ),
                        TextAndFieldsOrDropDown(
                          labelText: 'Location',
                          fieldHintText: 'Street abc',
                          fieldController: controller.locationController,
                          isDropDown: false,
                          readOnly: true,
                          fieldValidator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter location.';
                            }
                            return null;
                          },
                        ),
                        MapWidget(),
                        TextAndFieldsOrDropDown(
                          labelText: 'Date',
                          fieldHintText: 'June 15-17, 2024',
                          fieldController: controller.dateController,
                          isDropDown: false,
                          readOnly: true, // Make field read-only
                          ontap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              controller.dateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            }
                          },
                          fieldValidator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please select a date.';
                            }
                            return null;
                          },
                        ),
                        TextAndFieldsOrDropDown(
                          labelText: 'Time',
                          fieldHintText: '9:00 AM',
                          fieldController: controller.timeController,
                          isDropDown: false,
                          readOnly: true,
                          ontap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              final now = DateTime.now();
                              final formattedTime = TimeOfDay(
                                hour: pickedTime.hour,
                                minute: pickedTime.minute,
                              ).format(context);
                              controller.timeController.text = formattedTime;
                            }
                          },
                          fieldValidator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please select a time.';
                            }
                            return null;
                          },
                        ),
                        TextAndFieldsOrDropDown(
                          labelText: 'Phone number',
                          fieldHintText: '0899787878787',
                          fieldController: controller.phoneNumberController,
                          isDropDown: false,
                          fieldValidator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter phone number.';
                            }

                            final trimmedValue = value.trim();
                            final phoneRegExp =
                                RegExp(r'^[0-9]+$'); // Only digits

                            if (!phoneRegExp.hasMatch(trimmedValue)) {
                              return 'Phone number must contain digits only.';
                            }

                            if (trimmedValue.length < 10 ||
                                trimmedValue.length > 15) {
                              return 'Phone number must be between 10 to 15 digits.';
                            }

                            return null;
                          },
                        ),
                        TextAndFieldsOrDropDown(
                          labelText: 'URL',
                          fieldHintText: 'www.example.com',
                          fieldController: controller.urlController,
                          isDropDown: false,
                          fieldValidator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a URL.';
                            }

                            final urlPattern =
                                r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(\S*)?$';
                            final urlRegExp = RegExp(urlPattern);

                            if (!urlRegExp.hasMatch(value.trim())) {
                              return 'Please enter a valid URL (e.g., https://example.com).';
                            }
                            return null;
                          },
                        ),
                        TextAndFieldsOrDropDown(
                          maxLines: 5,
                          labelText: 'Description',
                          fieldHintText: 'description',
                          fieldController: controller.descriptionController,
                          isDropDown: false,
                          fieldValidator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter description.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: CustomButton(
                              ontapp: () async {
                                if (formKey.currentState!.validate()) {
                                  if (controller.uploadedImages.isEmpty) {
                                    Get.snackbar(
                                      'Image Required',
                                      'Please upload at least one image for the event.',
                                      maxWidth: 400,
                                      backgroundColor: primaryColor,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                    return;
                                  }
                                  if (controller.isEdit.value) {
                                    await controller.updateEvent(
                                        docID: controller
                                            .selectedEventModel!.docId!);
                                    return;
                                  } else {
                                    await controller.addEvent();
                                  }
                                }
                              },
                              width: 169,
                              laBelText:
                                  controller.isEdit.value ? 'Update' : 'Save'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
