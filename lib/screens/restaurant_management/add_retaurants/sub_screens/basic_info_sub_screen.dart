import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/text_styles.dart';
import 'package:savrly/widgets/map_widget.dart';

import '../../../../constants/app_colors.dart';
import '../../../../controllers/add_restaurants_controller.dart';
import '../../../../utils/validations.dart';
import '../../../../widgets/text_and_field_drop_down.dart';

class BasicInfoSubScreen extends StatelessWidget {
  BasicInfoSubScreen({super.key, required this.formKey});

  final controller = Get.find<AddRestaurantTabController>();
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 1000;
    // Responsive size
    double imageWidth = 216;
    double imageHeight = 162;

    if (screenWidth < 500) {
      imageWidth = 140;
      imageHeight = 100;
    } else if (screenWidth < 900) {
      imageWidth = 180;
      imageHeight = 130;
    }

    // ScrollController for horizontal scrolling
    final ScrollController horizontalScrollController = ScrollController();
    return Expanded(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Restaurant Images',
                style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
              ),
              const SizedBox(height: 16),
              Obx(
                () => SizedBox(
                  height: imageHeight + 20,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      final newOffset =
                          horizontalScrollController.offset - details.delta.dx;
                      horizontalScrollController.jumpTo(
                        newOffset.clamp(
                          0.0,
                          horizontalScrollController.position.maxScrollExtent,
                        ),
                      );
                    },
                    child: Scrollbar(
                      controller: horizontalScrollController,
                      thumbVisibility:
                          controller.uploadedImage.length * (imageWidth + 12) >
                              screenWidth,
                      child: Listener(
                        onPointerSignal: (PointerSignalEvent event) {
                          if (event is PointerScrollEvent) {
                            final scrollDelta = event.scrollDelta.dy;
                            horizontalScrollController.jumpTo(
                              horizontalScrollController.offset + scrollDelta,
                            );
                          }
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: horizontalScrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Row(
                            children: [
                              // Uploaded Images with Remove Button
                              ...controller.uploadedImage
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                UploadedImageModel image = entry.value;

                                return Stack(
                                  children: [
                                    Container(
                                      width: imageWidth,
                                      height: imageHeight,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: image.url != null
                                              ? NetworkImage(image.url!)
                                              : MemoryImage(image.bytes!)
                                                  as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.removeImage(index),
                                        child: const MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Colors.red,
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
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: primaryColor.withOpacity(0.4),
                                        width: 0.6,
                                      ),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
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
                                          Icons.add_circle_outline_rounded,
                                          color: primaryColor,
                                          size: 40,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Add More Photos',
                                          style: simpleText.copyWith(
                                            fontWeight: FontWeight.w500,
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextAndFieldsOrDropDown(
                      labelText: 'Restaurant Name',
                      fieldHintText: 'The Hungry Spoon',
                      fieldController: controller.restaurantNameController,
                      isDropDown: false,
                      fieldValidator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter restaurant name.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextAndFieldsOrDropDown(
                      labelText: 'Email',
                      fieldHintText: 'abc@dff.com',
                      fieldController: controller.emailController,
                      readOnly: controller.isNewRegistery != true,
                      fieldValidator: (value) => isEmailValid(value!),
                      isDropDown: false,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Obx(
                      () => TextAndFieldsOrDropDown(
                        labelText: 'Assign Password',
                        fieldHintText: '123@abc',
                        readOnly: controller.isNewRegistery != true,
                        fieldController: controller.assignPasswordController,
                        fieldValidator: (value) => isPasswordValid(value!),
                        isObscure: !controller.isPasswordVisible.value,
                        fieldSuffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: primaryColor,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        isDropDown: false,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextAndFieldsOrDropDown(
                      labelText: 'State',
                      dropHintText: 'State',
                      items: controller.stateList,
                      currentValue: controller.selectedState.value,
                      onChanged: (value) =>
                          controller.selectedState.value = value!,
                      dropDownValidator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please select a state.';
                        }
                        return null;
                      },
                      isDropDown: true,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: TextAndFieldsOrDropDown(
                      labelText: 'City',
                      dropHintText: 'City',
                      currentValue: controller.selectedCity.value,
                      items: controller.selectedState.value == 'Los Angeles'
                          ? controller.losAngelesCities
                          : controller.newYorkCitiesList,
                      onChanged: (value) =>
                          controller.selectedCity.value = value!,
                      dropDownValidator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please select a city.';
                        }
                        return null;
                      },
                      isDropDown: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextAndFieldsOrDropDown(
                      labelText: 'Area',
                      fieldHintText: 'Gujarat,Street 1,house 1',
                      fieldController: controller.areaController,
                      fieldValidator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter area.';
                        }
                        return null;
                      },
                      isDropDown: false,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: TextAndFieldsOrDropDown(
                      labelText: 'Spoken Language',
                      currentValue: controller.selectedSpokenLanguage.value,
                      dropHintText: 'Language',
                      items: controller.spokenLanguageList,
                      onChanged: (value) =>
                          controller.selectedSpokenLanguage.value = value!,
                      dropDownValidator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please select a spoken language.';
                        }
                        return null;
                      },
                      isDropDown: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextAndFieldsOrDropDown(
                      labelText: 'Instagram Link',
                      fieldHintText: 'instagram.com',
                      fieldController: controller.instagramController,
                      fieldValidator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter instagram link.';
                        }
                        return null;
                      },
                      isDropDown: false,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: TextAndFieldsOrDropDown(
                      labelText: 'Tiktok Link',
                      fieldHintText: 'tiktok.com',
                      fieldController: controller.tiktokLinkController,
                      fieldValidator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter tiktok link.';
                        }
                        return null;
                      },
                      isDropDown: false,
                    ),
                  ),
                ],
              ),
              Text(
                'Map',
                style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
              ),
              SizedBox(height: mobileView ? 12 : 16),
              Container(
                height: 266,
                width: mobileView ? Get.width * 0.8 : Get.width * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: MapWidget(),
              ),
              SizedBox(height: mobileView ? 12 : 16),
            ],
          ),
        ),
      ),
    );
  }
}
