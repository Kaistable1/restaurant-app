import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/text_styles.dart';
import 'package:savrly/utils/globalVars.dart';
import 'package:savrly/widgets/map_widget.dart';

import '../../../../constants/app_colors.dart';
import '../../../../controllers/add_restaurants_controller.dart';
import '../../../../utils/validations.dart';
import '../../../../widgets/text_and_field_drop_down.dart';

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
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextAndFieldsOrDropDown(
              //         labelText: 'Email',
              //         fieldHintText: 'abc@dff.com',
              //         fieldController: controller.emailController,
              //         fieldValidator: (value) => isEmailValid(value!),
              //         isDropDown: false,
              //       ),
              //     ),
              //     const SizedBox(width: 24),
              //     Expanded(
              //       child: Obx(
              //         () => TextAndFieldsOrDropDown(
              //           labelText: 'Assign Password',
              //           fieldHintText: '123@abc',
              //           fieldController: controller.assignPasswordController,
              //           fieldValidator: (value) => isPasswordValid(value!),
              //           isObscure: !controller.isPasswordVisible.value,
              //           fieldSuffixIcon: IconButton(
              //             icon: Icon(
              //               controller.isPasswordVisible.value
              //                   ? Icons.visibility_off
              //                   : Icons.visibility,
              //               color: primaryColor,
              //             ),
              //             onPressed: controller.togglePasswordVisibility,
              //           ),
              //           isDropDown: false,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // Updated Row with suffix icons
              Row(
                children: [
                  Expanded(
                    child: TextAndFieldsOrDropDown(
                      labelText: 'Email',
                      fieldHintText: 'abc@dff.com',
                      fieldController: controller.emailController,
                      fieldValidator: (value) {
                        if (value!.isEmpty) {
                          return null;
                        }
                        return isEmailValid(value);
                      },
                      isDropDown: false,
                      // Add this if your TextAndFieldsOrDropDown supports multiple suffix icons
                      fieldSuffixIcon:
                          // Password visibility icon (if needed for email)
                          // ... existing suffix icon
                          IconButton(
                        icon: Icon(
                          Icons.email_outlined,
                          color: primaryColor,
                        ),
                        onPressed: controller.generateEmailOnly,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Obx(
                      () => TextAndFieldsOrDropDown(
                        labelText: 'Assign Password',
                        fieldHintText: '123@abc',
                        fieldController: controller.assignPasswordController,
                        fieldValidator: (value) {
                          if (value!.isEmpty) {
                            return null;
                          }
                          return isPasswordValid(value);
                        },
                        isObscure: !controller.isPasswordVisible.value,
                        fieldSuffixIcon: SizedBox(
                          width: 80,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: primaryColor,
                                  ),
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.password,
                                    color: primaryColor,
                                  ),
                                  onPressed: controller.generatePasswordOnly,
                                ),
                              ]),
                        ),
                        isDropDown: false,
                      ),
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
                                SizedBox(height: 10),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.grey[300]!),
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
                                SizedBox(height: 10),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.grey[300]!),
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
                                SizedBox(height: 10),
                                DropdownSearch<String>(
                                  key: const Key('state_dropdown'),
                                  selectedItem:
                                      controller.selectedState.value.isNotEmpty
                                          ? controller.selectedState.value
                                          : null,
                                  items: (String? filter, _) =>
                                      controller.getFilteredStates(filter),
                                  itemAsString: (String? item) => item ?? '',
                                  onChanged:
                                      controller.isLocationDataLoading.value
                                          ? null
                                          : controller.onStateSelected,
                                  validator: (String? value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please select a state.';
                                    }
                                    return null;
                                  },
                                  // Clear button (optional; remove if IDE error persists - it's not required)
                                  // clearButtonProps: const ClearButtonProps(isVisible: true),
                                  popupProps: PopupProps.menu(
                                    menuProps: MenuProps(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    showSearchBox: true,
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        hintText: 'Type to search states...',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(color: lightColor),
                                        ),
                                        prefixIcon: const Icon(Icons.search),
                                      ),
                                    ),
                                    showSelectedItems: true,
                                    fit: FlexFit.loose,
                                    constraints:
                                        const BoxConstraints(maxHeight: 300),
                                    itemBuilder:
                                        (context, item, isSelected, _) {
                                      return Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? primaryColor.withOpacity(0.1)
                                              : null,
                                        ),
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            color: isSelected
                                                ? primaryColor
                                                : Colors.black87,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  decoratorProps: DropDownDecoratorProps(
                                    decoration: InputDecoration(
                                      hintText: 'Select or search state',
                                      hintStyle: TextStyle(color: lightColor),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                            BorderSide(color: lightColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                            BorderSide(color: lightColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                            BorderSide(color: lightColor),
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
                              labelText:
                                  'City', // No separate label since we have Text above
                              fieldHintText:
                                  controller.selectedState.value.isNotEmpty
                                      ? 'Enter or select city'
                                      : 'Select State First',
                              fieldController: controller.cityController,
                              isDropDown: false,
                              readOnly: !controller.selectedState.value
                                      .isNotEmpty || // Add 'enabled' if your widget supports it; else, use readOnly
                                  controller.isLocationDataLoading.value,
                              fieldSuffixIcon: IconButton(
                                icon: const Icon(Icons.arrow_drop_down,
                                    color: primaryColor),
                                onPressed: controller
                                            .selectedState.value.isNotEmpty &&
                                        !controller.isLocationDataLoading.value
                                    ? () => controller.showCityPicker(context)
                                    : null, // Disable if no state selected
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
                                return null; // Sync on change (redundant with listener but ensures)
                              },
                            ),
                          ),
                          // City Searchable Dropdown
                          // Expanded(
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text(
                          //         'City',
                          //         style: headingText.copyWith(fontSize: mobileView ? 16 : 20),
                          //       ),
                          //       SizedBox(height: 10),
                          //       DropdownSearch<String>(
                          //         key: const Key('city_dropdown'),
                          //         selectedItem: controller.selectedCity.value.isNotEmpty
                          //             ? controller.selectedCity.value
                          //             : null,
                          //         items: (String? filter, _) =>
                          //             controller.getFilteredCities(filter),
                          //         itemAsString: (String? item) => item ?? '',
                          //         onChanged: controller.selectedState.value.isNotEmpty &&
                          //             !controller.isLocationDataLoading.value
                          //             ? controller.onCitySelected
                          //             : null,
                          //         validator: (String? value) {
                          //           if (controller.selectedState.value.isEmpty) {
                          //             return 'Please select a state first.';
                          //           }
                          //           if (value == null || value.trim().isEmpty) {
                          //             return 'Please select a city.';
                          //           }
                          //           return null;
                          //         },
                          //         // Clear button (optional; remove if IDE error persists - it's not required)
                          //         // clearButtonProps: const ClearButtonProps(isVisible: true),
                          //         popupProps: PopupProps.menu(
                          //           menuProps: MenuProps(
                          //             borderRadius: BorderRadius.circular(10),
                          //           ),
                          //           showSearchBox: true,
                          //           searchFieldProps: TextFieldProps(
                          //             decoration: InputDecoration(
                          //               hintText: 'Type to search cities...',
                          //               border: OutlineInputBorder(
                          //                 borderRadius: BorderRadius.circular(10),
                          //                 borderSide: BorderSide(color: lightColor),
                          //               ),
                          //               prefixIcon: const Icon(Icons.search),
                          //             ),
                          //           ),
                          //           // title: Container(
                          //           //   height: 50,
                          //           //   decoration: const BoxDecoration(
                          //           //     color: primaryColor, // Use your app's primaryColor
                          //           //     borderRadius: BorderRadius.only(
                          //           //       topLeft: Radius.circular(8),
                          //           //       topRight: Radius.circular(8),
                          //           //     ),
                          //           //   ),
                          //           //   child: const Center(
                          //           //     child: Text(
                          //           //       'Select a City',
                          //           //       style: TextStyle(
                          //           //         color: Colors.white,
                          //           //         fontWeight: FontWeight.bold,
                          //           //       ),
                          //           //     ),
                          //           //   ),
                          //           // ),
                          //           showSelectedItems: true,
                          //           fit: FlexFit.loose,
                          //           constraints: const BoxConstraints(maxHeight: 300),
                          //           itemBuilder: (context, item, isSelected, _) {
                          //             return Container(
                          //               padding: const EdgeInsets.all(12),
                          //               decoration: BoxDecoration(
                          //                 color: isSelected ? primaryColor.withOpacity(0.1) : null,
                          //               ),
                          //               child: Text(
                          //                 item,
                          //                 style: TextStyle(
                          //                   color: isSelected ? primaryColor : Colors.black87,
                          //                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          //                 ),
                          //               ),
                          //             );
                          //           },
                          //         ),
                          //         decoratorProps: DropDownDecoratorProps(
                          //           decoration: InputDecoration(
                          //             hintText: controller.selectedState.value.isNotEmpty
                          //                 ? 'Select or search city'
                          //                 : 'Select State First',
                          //             hintStyle: TextStyle(color: lightColor),
                          //             border: OutlineInputBorder(
                          //               borderRadius: BorderRadius.circular(8),
                          //               borderSide: BorderSide(color: lightColor),
                          //             ),
                          //             focusedBorder: OutlineInputBorder(
                          //               borderRadius: BorderRadius.circular(8),
                          //               borderSide: BorderSide(color: lightColor),
                          //             ),
                          //             enabledBorder: OutlineInputBorder(
                          //               borderRadius: BorderRadius.circular(8),
                          //               borderSide: BorderSide(color: lightColor),
                          //             ),
                          //             suffixIcon: const Icon(Icons.arrow_drop_down, color: primaryColor),
                          //           ),
                          //         ),
                          //         enabled: controller.selectedState.value.isNotEmpty &&
                          //             !controller.isLocationDataLoading.value,
                          //       ),
                          //       const SizedBox(height: 16),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextAndFieldsOrDropDown(
                      labelText: 'Street',
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
                      labelText: 'Zip Code',
                      fieldHintText: '90210',
                      fieldController: controller.zipCodeController,
                      fieldValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return null; // ZIP code is optional
                        }
                        if (!RegExp(r'^\d{5}$').hasMatch(value)) {
                          return 'Please enter a valid 5-digit ZIP code';
                        }
                        return null;
                      },
                      // ========== ADD ZIP CODE LISTENER - NEW ==========
                      onChangedTextfield: (value) {
                        print('onChange val ' + value.toString());
                        if (value != null && value.length == 5) {
                          // Debounce for 500ms to avoid multiple API calls
                          Timer(const Duration(milliseconds: 300), () {
                            if (controller.zipCodeController.text == value) {
                              print('Inside debounce');
                              controller.lookupZipCode(value);
                            }
                          });
                        }
                        return null;
                      },
                      // ========== END ZIP CODE LISTENER ==========
                      isDropDown: false,
                    ),
                  ),
                  // Expanded(
                  //   child: TextAndFieldsOrDropDown(
                  //     labelText: 'Zip Code',
                  //     fieldHintText: '25235',
                  //     fieldController: controller.zipCodeController,
                  //     fieldValidator: (value) {
                  //       return null;
                  //     },
                  //     isDropDown: false,
                  //   ),
                  // ),
                ],
              ),
              //add extra fields phone number and website url
              Row(
                children: [
                  Expanded(
                    child: TextAndFieldsOrDropDown(
                      labelText: 'Phone No',
                      fieldHintText: '(123) 456-7890',
                      fieldController: controller.phoneNoController,
                      fieldValidator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter phoneNo.';
                        }
                        return null;
                      },
                      isDropDown: false,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: TextAndFieldsOrDropDown(
                      labelText: 'Website Url',
                      fieldHintText: 'https://example.com',
                      fieldController: controller.websiteUrlController,
                      fieldValidator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter website url.';
                        }
                        return null;
                      },
                      isDropDown: false,
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
