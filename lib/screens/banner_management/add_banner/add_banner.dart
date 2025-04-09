import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/text_styles.dart';
import '../../../controllers/banner_controller.dart';
import '../../../controllers/drawer_controller.dart';
import '../../../widgets/button.dart';
import '../../../widgets/customheader_widget.dart';
import '../../../widgets/text_and_field_drop_down.dart';

class AddBanner extends StatelessWidget {
  final drawerController = Get.put(DrawerControllerX());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final controller = Get.put(BannerController());

  AddBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    double screenWidth = size.width;
    double screenHeight = size.height;
    bool isLargeScreen = screenWidth > 1600;

    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth <= 900;
    bool isDesktop = screenWidth > 900;

    // Adjust padding based on view
    double paddingValue = isMobile ? 16 : (isTablet ? 20 : 24);

    // Define container dimensions as a percentage of screen size
    double containerWidth =
        screenWidth * (isMobile ? 0.8 : (isTablet ? 0.8 : 0.5));
    double containerHeight =
        screenHeight * (isMobile ? 0.32 : (isTablet ? 0.32 : 0.32));
    double buttonTextSize = isMobile ? 11 : 16;
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
                title: controller.isFromEdit.value
                    ? 'Edit Banner'
                    : 'Add New Banner',
                back: true,
                onBackTap: () {
                  controller.isFromEdit.value = false;
                  drawerController.addBanner.value = false;
                },
                end: true,
                endWidget: CustomButton(
                    laBelText: 'Save',
                    fontSize: buttonTextSize,
                    width: isLargeScreen
                        ? 200
                        : isMobile
                            ? 120
                            : 162,
                    containerColor: primaryColor,
                    ontapp: () {
                      if (formKey.currentState!.validate()) {
                        try {
                          final startDate = DateFormat('MMMM dd, yyyy')
                              .parse(controller.startDateController.text);
                          final endDate = DateFormat('MMMM dd, yyyy')
                              .parse(controller.endDateController.text);
                          if (endDate.isBefore(startDate)) {
                            Get.snackbar(
                              'Error',
                              'End date must be after start date',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: primaryColor,
                              colorText: Colors.white,
                              maxWidth: 400,
                            );
                            return;
                          }
                          if (controller.selectedImage.value == null &&
                              controller.selectedWebImage.value == null) {
                            Get.snackbar(
                              'Error',
                              'Please upload an image',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: primaryColor,
                              colorText: Colors.white,
                              maxWidth: 400,
                            );
                          } else {
                            Get.snackbar(
                              'Success',
                              'Banner added successfully',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: primaryColor,
                              colorText: Colors.white,
                              maxWidth: 400,
                            );
                            drawerController.addBanner.value = false;
                            controller.titleController.clear();
                            controller.startDateController.clear();
                            controller.endDateController.clear();
                            controller.stateController.clear();
                            controller.cityController.clear();
                            controller.selectedImage.value = null;
                            controller.selectedWebImage.value = null;
                          }
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            'Please enter valid dates.',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: primaryColor,
                            colorText: Colors.white,
                            maxWidth: 400,
                          );
                        }
                      }
                    }),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Upload Banner Image',
                  style: headingText.copyWith(
                      fontSize: isLargeScreen
                          ? 24
                          : isMobile
                              ? 14
                              : 20),
                ),
              ),
              SizedBox(
                height: isMobile ? 8 : 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  width: size.width * 0.38,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // subtle shadow
                        blurRadius: 8, // how soft the shadow is
                        offset: Offset(0, 4), // horizontal & vertical offset
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DottedBorder(
                      dashPattern: const [7, 5],
                      color: primaryColor,
                      strokeWidth: 1,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(6),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        child: InkWell(
                          onTap: controller.pickImage,
                          child: Obx(() {
                            final image = kIsWeb
                                ? controller.selectedWebImage.value
                                : controller.selectedImage.value;

                            if (image == null) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/upload_doc.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Upload Image',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: isMobile ? 12 : 16,
                                        fontFamily:
                                            GoogleFonts.nunitoSans().fontFamily,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF232931),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Upload a .png file only',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: isMobile ? 12 : 16,
                                        fontFamily:
                                            GoogleFonts.nunitoSans().fontFamily,
                                        fontWeight: FontWeight.w500,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Stack(
                                children: [
                                  kIsWeb
                                      ? Image.memory(image as Uint8List,
                                          width: size.width * 0.38,
                                          height: 150,
                                          fit: BoxFit.fill)
                                      : Image.file(image as File,
                                          width: size.width * 0.38,
                                          height: 150,
                                          fit: BoxFit.fill),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: controller.removeImage,
                                      child: Container(
                                        padding: const EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 3,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: isMobile ? 8 : 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  width: 325,
                  child: TextAndFieldsOrDropDown(
                    labelText: 'Title',
                    fieldHintText: 'Spring Sale',
                    fieldController: controller.titleController,
                    isDropDown: false,
                    fieldValidator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter title.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              (isMobile || isTablet)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 325,
                            child: TextAndFieldsOrDropDown(
                              labelText: 'Start Date',
                              fieldHintText: 'June 15-17, 2024',
                              fieldController: controller.startDateController,
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
                                  controller.startDateController.text =
                                      DateFormat('MMMM dd, yyyy')
                                          .format(pickedDate);
                                }
                              },
                              fieldValidator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please select a date.';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: 325,
                            child: TextAndFieldsOrDropDown(
                              labelText: 'End Date',
                              fieldHintText: 'June 15-17, 2024',
                              fieldController: controller.endDateController,
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
                                  controller.endDateController.text =
                                      DateFormat('MMMM dd, yyyy')
                                          .format(pickedDate);
                                }
                              },
                              fieldValidator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please select a date.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 325,
                            child: TextAndFieldsOrDropDown(
                              labelText: 'Start Date',
                              fieldHintText: 'June 15-17, 2024',
                              fieldController: controller.startDateController,
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
                                  controller.startDateController.text =
                                      DateFormat('MMMM dd, yyyy')
                                          .format(pickedDate);
                                }
                              },
                              fieldValidator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please select a date.';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          SizedBox(
                            width: 325,
                            child: TextAndFieldsOrDropDown(
                              labelText: 'End Date',
                              fieldHintText: 'June 15-17, 2024',
                              fieldController: controller.endDateController,
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
                                  controller.endDateController.text =
                                      DateFormat('MMMM dd, yyyy')
                                          .format(pickedDate);
                                }
                              },
                              fieldValidator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please select a date.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
              (isMobile || isTablet)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 325,
                            child: TextAndFieldsOrDropDown(
                              labelText: 'State',
                              fieldHintText: 'New york',
                              fieldController: controller.stateController,
                              isDropDown: false,
                              // Make field read-only
                              fieldValidator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter state name';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: 325,
                            child: TextAndFieldsOrDropDown(
                              labelText: 'City',
                              fieldHintText: 'Brooklyn',
                              fieldController: controller.cityController,
                              isDropDown: false,
                              fieldValidator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter city name.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 325,
                            child: TextAndFieldsOrDropDown(
                              labelText: 'State',
                              fieldHintText: 'New york',
                              fieldController: controller.stateController,
                              isDropDown: false,
                              // Make field read-only
                              fieldValidator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter state name';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          SizedBox(
                            width: 325,
                            child: TextAndFieldsOrDropDown(
                              labelText: 'City',
                              fieldHintText: 'Brooklyn',
                              fieldController: controller.cityController,
                              isDropDown: false,
                              fieldValidator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter city name.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
