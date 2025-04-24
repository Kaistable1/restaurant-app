import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/text_styles.dart';
import 'package:restaurant_web_app/controllers/add_restaurants_controller.dart';
import 'package:restaurant_web_app/widgets/drop_down.dart';
import 'package:restaurant_web_app/widgets/text_fields.dart';
import '../../../../constants/app_colors.dart';
import '../../../../controllers/menu_sub_screen_controller.dart';

class MenuSubScreen extends StatelessWidget {
  MenuSubScreen({super.key});

  final controller = Get.put(MenuSubScreenController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;
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
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            SizedBox(
              width: mobileView ? Get.width : Get.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextAndFieldsOrDropDown(
                    labelText: 'Special conditions',
                    fieldController: controller.specialConditionsController,
                    fieldHintText: 'Add special conditions',
                    maxLines: 5,
                  ),
                  Text(
                    'Discount type',
                    style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
                  ),
                  Text(
                    'Coming soon',
                    style: simpleText.copyWith(
                      fontSize: mobileView ? 14 : 18,
                      color: secondaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cuisine type',
                    style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
                  ),
                  SizedBox(height: 10),
                  CustomDropDownWidget(
                    hint: 'Select cuisine',
                    value: controller.selectedCuisine.value,
                    items: controller.cuisineList,
                    onChanged: (value) {
                      controller.selectedCuisine.value = value!;
                    },
                  ),
                  SizedBox(height: 16),

                  Text(
                    'Menu type',
                    style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
                  ),
                  SizedBox(height: 10),
                  // Custom Checkboxes for Menu Type
                  Obx(
                    () => Column(
                      children: [
                        CustomCheckbox(
                          isChecked: controller.isFoodMenuSelected.value,
                          label: 'Food Menu',
                          onTap: controller.toggleFoodMenu,
                          mobileView: mobileView,
                        ),
                        SizedBox(height: 8),
                        CustomCheckbox(
                          isChecked: controller.isDrinkMenuSelected.value,
                          label: 'Drink Menu',
                          onTap: controller.toggleDrinkMenu,
                          mobileView: mobileView,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Food Images',
                    style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => SizedBox(
                      height: imageHeight + 20,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          final newOffset = horizontalScrollController.offset -
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
                          thumbVisibility: controller.uploadedImages.length *
                                  (imageWidth + 12) >
                              screenWidth,
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
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Row(
                                children: [
                                  // Uploaded Images with Remove Button
                                  ...controller.uploadedImages
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
                                          margin:
                                              const EdgeInsets.only(right: 12),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: InkWell(
                                      onTap: controller.pickImageWeb,
                                      child: Container(
                                        width: imageWidth,
                                        height: imageHeight,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: primaryColor.withOpacity(
                                              0.4,
                                            ),
                                            width: 0.6,
                                          ),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final String label;
  final VoidCallback onTap;
  final bool mobileView;

  CustomCheckbox({
    required this.isChecked,
    required this.label,
    required this.onTap,
    required this.mobileView,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 1.5),
                borderRadius: BorderRadius.circular(4),
                color: isChecked ? primaryColor : white,
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 16, color: white)
                  : null,
            ),
            SizedBox(width: 16),
            Text(
              label,
              style: simpleText.copyWith(
                fontSize: mobileView ? 14 : 18,
                color: secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
