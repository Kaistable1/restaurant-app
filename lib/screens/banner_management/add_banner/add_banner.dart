import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  AddBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    bool isLargeScreen = screenWidth > 1600;
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth <= 1000;

    double paddingValue = isMobile ? 16 : (isTablet ? 20 : 24);
    double buttonTextSize = isMobile ? 11 : 16;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(paddingValue),
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
                  controller.clearInputs();
                },
                end: true,
                endWidget: CustomButton(
                  laBelText: controller.isFromEdit.value ? 'Update' : 'Save',
                  fontSize: buttonTextSize,
                  width: isLargeScreen
                      ? 200
                      : isMobile
                          ? 120
                          : 162,
                  containerColor: primaryColor,
                  ontapp: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        if (controller.isFromEdit.value) {
                          await controller.updateBanner();
                        } else {
                          await controller.addBanner();
                        }
                        controller.isFromEdit.value = false;
                        drawerController.addBanner.value = false;
                      } catch (e) {
                        // Error handling is in controller
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Upload Banner Image',
                style: headingText.copyWith(
                  fontSize: isLargeScreen
                      ? 24
                      : isMobile
                          ? 14
                          : 20,
                ),
              ),
              SizedBox(height: isMobile ? 8 : 12),
              Container(
                width: isMobile ? size.width * 0.9 : size.width * 0.38,
                height: isMobile ? 120 : 150,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DottedBorder(
                  dashPattern: const [7, 5],
                  color: primaryColor,
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(6),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    child: InkWell(
                      onTap: controller.pickImage,
                      child: Obx(() {
                        final imageBytes = controller.selectedImageBytes.value;
                        final existingUrl = controller.existingImageUrl.value;

                        if (imageBytes == null && existingUrl.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/upload_doc.png',
                                  width: isMobile ? 20 : 24,
                                  height: isMobile ? 20 : 24,
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
                                    color: const Color(0xFF232931),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Upload a .png file only',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isMobile ? 10 : 14,
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
                              imageBytes != null
                                  ? Image.memory(
                                      imageBytes,
                                      width: isMobile
                                          ? size.width * 0.9
                                          : size.width * 0.38,
                                      height: isMobile ? 120 : 150,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      existingUrl,
                                      width: isMobile
                                          ? size.width * 0.9
                                          : size.width * 0.38,
                                      height: isMobile ? 120 : 150,
                                      fit: BoxFit.cover,
                                    ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: controller.removeImage,
                                  child: Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 3,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: isMobile ? 16 : 18,
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
              SizedBox(height: isMobile ? 8 : 12),
              SizedBox(
                width: isMobile ? size.width * 0.9 : 325,
                child: TextAndFieldsOrDropDown(
                  labelText: 'Title',
                  fieldHintText: 'Spring Sale',
                  fieldController: controller.titleController,
                  isDropDown: false,
                  fieldValidator: (value) =>
                      value!.isEmpty ? 'Please enter title.' : null,
                ),
              ),
              (isMobile || isTablet)
                  ? Column(
                      children: [
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : 325,
                          child: TextAndFieldsOrDropDown(
                            labelText: 'Start Date',
                            fieldHintText: 'June 15-17, 2024',
                            fieldController: controller.startDateController,
                            isDropDown: false,
                            readOnly: true,
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
                            fieldValidator: (value) =>
                                value!.isEmpty ? 'Please select a date.' : null,
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : 325,
                          child: TextAndFieldsOrDropDown(
                            labelText: 'End Date',
                            fieldHintText: 'June 15-17, 2024',
                            fieldController: controller.endDateController,
                            isDropDown: false,
                            readOnly: true,
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
                            fieldValidator: (value) =>
                                value!.isEmpty ? 'Please select a date.' : null,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        SizedBox(
                          width: 325,
                          child: TextAndFieldsOrDropDown(
                            labelText: 'Start Date',
                            fieldHintText: 'June 15-17, 2024',
                            fieldController: controller.startDateController,
                            isDropDown: false,
                            readOnly: true,
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
                            fieldValidator: (value) =>
                                value!.isEmpty ? 'Please select a date.' : null,
                          ),
                        ),
                        const SizedBox(width: 40),
                        SizedBox(
                          width: 325,
                          child: TextAndFieldsOrDropDown(
                            labelText: 'End Date',
                            fieldHintText: 'June 15-17, 2024',
                            fieldController: controller.endDateController,
                            isDropDown: false,
                            readOnly: true,
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
                            fieldValidator: (value) =>
                                value!.isEmpty ? 'Please select a date.' : null,
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: isMobile ? 8 : 12),
              (isMobile || isTablet)
                  ? Column(
                      children: [
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : 325,
                          child: TextAndFieldsOrDropDown(
                            labelText: 'State',
                            dropHintText: 'Select State',
                            items: controller.stateList,
                            currentValue: controller.selectedState.value,
                            onChanged: (value) {
                              controller.selectedState.value = value!;
                              controller.selectedCity.value = '';
                            },
                            dropDownValidator: (value) =>
                                value == null || value.isEmpty
                                    ? 'Please select a state.'
                                    : null,
                            isDropDown: true,
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: isMobile ? size.width * 0.9 : 325,
                          child: TextAndFieldsOrDropDown(
                            labelText: 'City',
                            dropHintText: 'Select City',
                            currentValue: controller.selectedCity.value,
                            items:
                                controller.selectedState.value == 'California'
                                    ? controller.losAngelusCities
                                    : controller.newYorkCitiesList,
                            onChanged: (value) =>
                                controller.selectedCity.value = value!,
                            dropDownValidator: (value) =>
                                value == null || value.isEmpty
                                    ? 'Please select a city.'
                                    : null,
                            isDropDown: true,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        SizedBox(
                          width: 325,
                          child: TextAndFieldsOrDropDown(
                            labelText: 'State',
                            dropHintText: 'Select State',
                            items: controller.stateList,
                            currentValue: controller.selectedState.value,
                            onChanged: (value) {
                              controller.selectedState.value = value!;
                              controller.selectedCity.value = '';
                            },
                            dropDownValidator: (value) =>
                                value == null || value.isEmpty
                                    ? 'Please select a state.'
                                    : null,
                            isDropDown: true,
                          ),
                        ),
                        const SizedBox(width: 40),
                        SizedBox(
                          width: 325,
                          child: TextAndFieldsOrDropDown(
                            labelText: 'City',
                            dropHintText: 'Select City',
                            currentValue: controller.selectedCity.value,
                            items:
                                controller.selectedState.value == 'California'
                                    ? controller.losAngelusCities
                                    : controller.newYorkCitiesList,
                            onChanged: (value) =>
                                controller.selectedCity.value = value!,
                            dropDownValidator: (value) =>
                                value == null || value.isEmpty
                                    ? 'Please select a city.'
                                    : null,
                            isDropDown: true,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
