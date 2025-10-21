import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/globalVars.dart';
import 'package:restaurant_web_app/constants/text_styles.dart';
import 'package:restaurant_web_app/screens/restaurant_management/widgets/my_map.dart';
import 'package:restaurant_web_app/widgets/text_fields.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../../../constants/app_colors.dart';
import '../../../../controllers/add_restaurants_controller.dart';

class BasicInfoSubScreen extends StatelessWidget {
  BasicInfoSubScreen({super.key, required this.formKey});

  final controller = Get.find<AddRestaurantTabController>();
  final GlobalKey<FormState> formKey;
  GlobalVariables globalVariables = GlobalVariables();

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
                () {
                  print(
                      '🖼️ UI rebuilding - uploadedImage length: ${controller.uploadedImage.length}');
                  return SizedBox(
                    height: imageHeight + 20,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        final newOffset = horizontalScrollController.offset -
                            details.delta.dx;
                        horizontalScrollController.jumpTo(
                          newOffset.clamp(
                            0.0,
                            horizontalScrollController.position.maxScrollExtent,
                          ),
                        );
                      },
                      child: Scrollbar(
                        controller: horizontalScrollController,
                        thumbVisibility: controller.uploadedImage.length *
                                (imageWidth + 12) >
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
                                  print(
                                      '  🖼️  Rendering image[$index]: url=${image.url}, hasBytes=${image.bytes != null}');

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
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: image.url != null
                                              ? Image.network(
                                                  image.url!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      child: const Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                      ),
                                                    );
                                                  },
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Image.memory(
                                                  image.bytes!,
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
                                }),

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
                                            color:
                                                Colors.black.withOpacity(0.1),
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
                                          const Icon(
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
                  );
                },
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
              Obx(
                () => controller.isLocationDataLoading.value
                    ? Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'State',
                                  style: headingText.copyWith(
                                      fontSize: mobileView ? 16 : 20),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'City',
                                  style: headingText.copyWith(
                                      fontSize: mobileView ? 16 : 20),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: const Center(
                                      child: Text('Select State First')),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          // State Searchable Dropdown
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'State',
                                  style: headingText.copyWith(
                                      fontSize: mobileView ? 16 : 20),
                                ),
                                const SizedBox(height: 10),
                                DropdownSearch<String>(
                                  key: const Key('state_dropdown'),
                                  selectedItem:
                                      controller.selectedState.value.isNotEmpty
                                          ? controller.selectedState.value
                                          : null,
                                  items: controller.stateList,
                                  onChanged:
                                      controller.isLocationDataLoading.value
                                          ? null
                                          : controller.onStateSelected,
                                  popupProps: PopupPropsMultiSelection.menu(
                                    showSearchBox: true,
                                    searchDelay:
                                        const Duration(milliseconds: 300),
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        hintText: 'Type to search states...',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                        prefixIcon: const Icon(Icons.search,
                                            color: primaryColor),
                                      ),
                                    ),
                                    menuProps: MenuProps(
                                      backgroundColor: Colors.white,
                                      elevation: 8,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    itemBuilder: (context, item, isSelected) {
                                      return ListTile(
                                        title: Text(item),
                                        selected: isSelected,
                                        selectedTileColor:
                                            primaryColor.withOpacity(0.1),
                                      );
                                    },
                                  ),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      hintText: 'Select or search state',
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: primaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      suffixIcon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: primaryColor),
                                    ),
                                  ),
                                  enabled:
                                      !controller.isLocationDataLoading.value,
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),

                          Expanded(
                            child: TextAndFieldsOrDropDown(
                              labelText: 'City',
                              fieldHintText:
                                  controller.selectedState.value.isNotEmpty
                                      ? 'Enter or select city'
                                      : 'Select State First',
                              fieldController: controller.cityController,
                              isDropDown: false,
                              readOnly:
                                  !controller.selectedState.value.isNotEmpty ||
                                      controller.isLocationDataLoading.value,
                              fieldSuffixIcon: IconButton(
                                icon: const Icon(Icons.arrow_drop_down,
                                    color: primaryColor),
                                onPressed: controller
                                            .selectedState.value.isNotEmpty &&
                                        !controller.isLocationDataLoading.value
                                    ? () => controller.showCityPicker(context)
                                    : null,
                              ),
                              fieldValidator: (value) {
                                if (controller.selectedState.value.isEmpty) {
                                  return 'Please select a state first.';
                                }
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a city.';
                                }
                                return null;
                              },
                              onChangedTextfield: (value) {
                                controller.selectedCity.value = value ?? '';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
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
                child: MyMapWidget(),
              ),
              SizedBox(height: mobileView ? 12 : 16),
            ],
          ),
        ),
      ),
    );
  }
}
