import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/controller/restaurant_detail_controller.dart';
import 'package:restaurant_web_app/utils/responsive.dart';
import 'package:restaurant_web_app/widgets/global_functions.dart';
import 'package:restaurant_web_app/widgets/text_field.dart';

import '../../../widgets/round_button.dart';
import '../../restaurant_detail_screen/widget/map_widget.dart';
import '../add_resturant_controller/add_resturant _controller.dart';

class Restaurantbasicwidget extends StatefulWidget {
  Restaurantbasicwidget(
      {super.key, required this.isDesktop, required this.isTablet});

  final bool isDesktop;
  final bool isTablet;

  @override
  State<Restaurantbasicwidget> createState() => _RestaurantbasicwidgetState();
}

class _RestaurantbasicwidgetState extends State<Restaurantbasicwidget> {
  final restaurantController = Get.put(AddRestaurantController());

  final List<String> items = [
    'Chinese',
    'Germany',
    'France',
    'Spain',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: restaurantController.formKey,
      child: Column(
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
              const SizedBox(width: 10),
              Text(
                'Add Restaurant Detail',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontFamily: 'Nunito-Regular',
                  fontSize: Responsive.isMobile(context)
                      ? 24
                      : Responsive.isTablet(context)
                          ? 28
                          : 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Placeholder for spacing to align the title to the center.
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Name Section

                    RichText(
                      text: TextSpan(
                        text: 'Restaurant name ',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 16
                              : Responsive.isTablet(context)
                                  ? 18
                                  : 24,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: '*', // Add the red asterisk
                            style: TextStyle(
                              fontSize: Responsive.isMobile(context)
                                  ? 16
                                  : Responsive.isTablet(context)
                                      ? 18
                                      : 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: restaurantController.restaurantModel.resName,
                      borderColor: AppColors.darkGrey.withOpacity(.1),
                      width: 516,
                      borderRadius: 8,
                      hintText: "Restaurant name",
                      fillColor: AppColors.whiteColor,
                      cursorColor: AppColors.primaryColor,
                      inputStyle: const TextStyle(color: AppColors.blackColor),
                      hintStyle: const TextStyle(color: AppColors.blackColor),
                    ),
                    const SizedBox(height: 5),
                    Obx(() => restaurantController
                            .restaurantsNameError.value.isNotEmpty
                        ? Text(
                            restaurantController.restaurantsNameError.value,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          )
                        : const SizedBox.shrink()),
                    const SizedBox(height: 24),

                    // Image Section
                    RichText(
                      text: TextSpan(
                        text: 'Image ',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 16
                              : Responsive.isTablet(context)
                                  ? 18
                                  : 24,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: '*', // Add the red asterisk
                            style: TextStyle(
                              fontSize: Responsive.isMobile(context)
                                  ? 16
                                  : Responsive.isTablet(context)
                                      ? 18
                                      : 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Obx(
                              () => Wrap(
                                spacing: 8,
                                children: restaurantController
                                    .restaurantModel.resImageMemory
                                    .map((image) {
                                  return Stack(
                                    clipBehavior: Clip
                                        .none, // Allows the cross icon to overflow if needed
                                    children: [
                                      // Circular Image with Border
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: Responsive.isDesktop(context)
                                              ? 160
                                              : 150, // Adjust the size as needed
                                          height: Responsive.isDesktop(context)
                                              ? 160
                                              : 110,

                                          child: Image.memory(
                                            image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),

                                      // Close Icon in Top Right
                                      Positioned(
                                        top: 8, // Adjust position as needed
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () {
                                            restaurantController
                                                .restaurantModel.resImageMemory
                                                .remove(image);
                                          },
                                          child: Container(
                                            width: 19,
                                            height: 19,
                                            decoration: const BoxDecoration(
                                              color: AppColors.darkGrey,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      Uint8List? selectedImage =
                                          await getImage();

                                      if (selectedImage != null &&
                                          selectedImage.isNotEmpty) {
                                        restaurantController
                                            .restaurantModel.resImageMemory
                                            .add(selectedImage);
                                        // print(
                                        //     '${controller.listingModel!.listingImageMemories.length}++++++++++++++++++ gallery');
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                          height: widget.isDesktop
                                              ? 160
                                              : widget.isTablet
                                                  ? 150
                                                  : 100,
                                          width: widget.isDesktop
                                              ? 160
                                              : widget.isTablet
                                                  ? 150
                                                  : 100,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(.2)),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(Icons.add,
                                              color: AppColors.primaryColor,
                                              size: widget.isDesktop
                                                  ? 40
                                                  : widget.isTablet
                                                      ? 30
                                                      : 28)),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Logo Section
                    RichText(
                      text: TextSpan(
                        text: 'Logo ',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 16
                              : Responsive.isTablet(context)
                                  ? 18
                                  : 24,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: '*', // Add the red asterisk
                            style: TextStyle(
                              fontSize: Responsive.isMobile(context)
                                  ? 16
                                  : Responsive.isTablet(context)
                                      ? 18
                                      : 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      return GestureDetector(
                          onTap: () async {
                            print('abcdef');

                            Uint8List? selectedImage =
                                await Get.put(RestaurantDetailController())
                                    .getImage();

                            if (selectedImage != null &&
                                selectedImage.isNotEmpty) {
                              restaurantController.restaurantModel
                                  .logoImageMemory.value = selectedImage;
                            }
                          },
                          child: restaurantController.restaurantModel
                                  .logoImageMemory.value.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(
                                    height: widget.isDesktop
                                        ? 150
                                        : widget.isTablet
                                            ? 120
                                            : 110,
                                    width: 516,
                                    restaurantController
                                        .restaurantModel.logoImageMemory.value,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : restaurantController
                                          .restaurantModel.logoImage.value !=
                                      ''
                                  ? Image.network(
                                      restaurantController
                                          .restaurantModel.logoImage.value,
                                      fit: BoxFit.cover)
                                  : Container(
                                      height: widget.isDesktop
                                          ? 150
                                          : widget.isTablet
                                              ? 120
                                              : 110,
                                      width: 516,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.withOpacity(.1)),
                                        borderRadius: BorderRadius.circular(12),
                                        color: AppColors.whiteColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(12),
                                          dashPattern: [6, 3],
                                          color: AppColors.primaryColor,
                                          strokeWidth: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: AppColors.whiteColor,
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                      Icons
                                                          .upload_file_outlined,
                                                      size: 32,
                                                      color: AppColors
                                                          .primaryColor),
                                                  Text(
                                                    'Upload Logo',
                                                    style: TextStyle(
                                                      fontSize: Responsive
                                                              .isMobile(context)
                                                          ? 12
                                                          : (Responsive
                                                                  .isTablet(
                                                                      context)
                                                              ? 14
                                                              : 16),
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Upload a .png file only',
                                                    style: TextStyle(
                                                      fontSize: Responsive
                                                              .isMobile(context)
                                                          ? 12
                                                          : (Responsive
                                                                  .isTablet(
                                                                      context)
                                                              ? 14
                                                              : 16),
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                          // : Container(
                          //     height: widget.isDesktop
                          //         ? 150
                          //         : widget.isTablet
                          //             ? 120
                          //             : 110,
                          //     width: 516,
                          //     decoration: BoxDecoration(
                          //       image: DecorationImage(
                          //         image: MemoryImage(_imageBytes!),
                          //         fit: BoxFit.cover,
                          //       ),
                          //       borderRadius: BorderRadius.circular(12),
                          //     ),
                          //   ),
                          );
                    }),
                    const SizedBox(height: 24),

                    // Save Button
                    RichText(
                      text: TextSpan(
                        text: 'Address ',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 16
                              : Responsive.isTablet(context)
                                  ? 18
                                  : 24,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: '*', // Add the red asterisk
                            style: TextStyle(
                              fontSize: Responsive.isMobile(context)
                                  ? 16
                                  : Responsive.isTablet(context)
                                      ? 18
                                      : 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: restaurantController.restaurantModel.address,
                      borderColor: AppColors.darkGrey.withOpacity(.1),
                      width: 516,
                      borderRadius: 8,
                      hintText: "Address",
                      fillColor: AppColors.whiteColor,
                      cursorColor: AppColors.primaryColor,
                      inputStyle: const TextStyle(color: AppColors.blackColor),
                      hintStyle: const TextStyle(color: AppColors.blackColor),
                      suffixIcon: const Icon(Icons.location_on,
                          color: AppColors.primaryColor),
                    ),
                    const SizedBox(height: 5),
                    Obx(() => restaurantController.addressError.value.isNotEmpty
                        ? Text(
                            restaurantController.addressError.value,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          )
                        : const SizedBox.shrink()),
                    SizedBox(height: Responsive.isMobile(context) ? 12 : 22),
                    RichText(
                      text: TextSpan(
                        text: 'Map',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 16
                              : Responsive.isTablet(context)
                                  ? 18
                                  : 24,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: '*', // Add the red asterisk
                            style: TextStyle(
                              fontSize: Responsive.isMobile(context)
                                  ? 16
                                  : Responsive.isTablet(context)
                                      ? 18
                                      : 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.isMobile(context) ? 12 : 22),
                    Container(
                      height: Get.height * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16)),
                      child: MapWidget(
                          controller: Get.put(RestaurantDetailController())),
                    ),
                    SizedBox(height: Responsive.isMobile(context) ? 12 : 22),
                    Text(
                      'Spoken languages',
                      style: TextStyle(
                        fontSize: Responsive.isMobile(context)
                            ? 16
                            : Responsive.isTablet(context)
                                ? 18
                                : 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Dropdown for spoken languages
                    SizedBox(height: Responsive.isMobile(context) ? 12 : 22),

                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Chinese',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: items
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue = value;
                            restaurantController
                                .restaurantModel.spokenLanguage.value = value!;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.darkGrey.withOpacity(.1),
                            ),
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                            color: AppColors.whiteColor,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          // width: 140,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons
                                .keyboard_arrow_down_outlined, // Custom icon for dropdown
                            color: AppColors.primaryColor,
                          ),
                          iconSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.isMobile(context) ? 12 : 22),
                    Row(
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
                              ? Get.width * 0.1
                              : Get.width * 0.2,
                          onPressed: () {
                            restaurantController.saveNextScreen();
                            // restaurantController.saveNextScreenTemporary();
                          },
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        // CustomButton(
                        //   title: "Next",
                        //   textStyle: TextStyle(
                        //     color: AppColors.primaryColor,
                        //     fontSize:
                        //         Responsive.isMobile(context)
                        //             ? 16
                        //             : 18,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        //   backgroundColor:
                        //       AppColors.whiteColor,
                        //   borderClr: AppColors.primaryColor,
                        //   borderRadius: 8,
                        //   width: Responsive.isMobile(context)
                        //       ? Get.width * 0.1
                        //       : Get.width * 0.2,
                        //   onPressed: () {
                        //     restaurantController
                        //         .saveNextScreen();
                        //   },
                        // ),
                      ],
                    ),
                    SizedBox(height: Responsive.isMobile(context) ? 12 : 22),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Name Section
                    RichText(
                      text: TextSpan(
                        text: 'Phone number ',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 16
                              : Responsive.isTablet(context)
                                  ? 18
                                  : 24,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: '*', // Add the red asterisk
                            style: TextStyle(
                              fontSize: Responsive.isMobile(context)
                                  ? 16
                                  : Responsive.isTablet(context)
                                      ? 18
                                      : 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller:
                          restaurantController.restaurantModel.phoneNumber,
                      borderColor: AppColors.darkGrey.withOpacity(.1),
                      width: 516,
                      borderRadius: 8,
                      // prefixIcon: Padding(
                      //   padding: const EdgeInsets.all(2.0),
                      //   child: Container(
                      //     width: 20,
                      //     height: 45,
                      //     decoration: BoxDecoration(
                      //       color: AppColors.darkGrey.withOpacity(.1),
                      //     ),
                      //     child: const Center(
                      //       child: Text(
                      //         '+1',
                      //         style: TextStyle(
                      //             fontSize: 16, fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      hintText: " Phone no",
                      fillColor: AppColors.whiteColor,
                      cursorColor: AppColors.primaryColor,
                      inputStyle: const TextStyle(color: AppColors.blackColor),
                      hintStyle: const TextStyle(color: AppColors.blackColor),
                    ),
                    const SizedBox(height: 5),
                    Obx(() => restaurantController.phoneError.value.isNotEmpty
                        ? Text(
                            restaurantController.phoneError.value,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          )
                        : const SizedBox.shrink()),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: 'City ',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 16
                              : Responsive.isTablet(context)
                                  ? 18
                                  : 24,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: '*', // Add the red asterisk
                            style: TextStyle(
                              fontSize: Responsive.isMobile(context)
                                  ? 16
                                  : Responsive.isTablet(context)
                                      ? 18
                                      : 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      return DropdownSearch<String>(
                        items: restaurantController.citiesByState[
                                restaurantController.selectedState.value] ??
                            [],
                        selectedItem:
                            restaurantController.selectedCity.value.isEmpty
                                ? null
                                : restaurantController.selectedCity.value,
                        popupProps: PopupPropsMultiSelection.menu(
                          showSearchBox: true,
                          searchDelay: const Duration(milliseconds: 300),
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search city...",
                              prefixIcon: const Icon(Icons.search,
                                  color: AppColors.primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: AppColors.darkGrey.withOpacity(.1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: AppColors.primaryColor),
                              ),
                            ),
                          ),
                          menuProps: MenuProps(
                            backgroundColor: AppColors.whiteColor,
                            elevation: 8,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          itemBuilder: (context, item, isSelected) {
                            return ListTile(
                              title: Text(item),
                              selected: isSelected,
                              selectedTileColor:
                                  AppColors.primaryColor.withOpacity(0.1),
                            );
                          },
                          emptyBuilder: (context, searchEntry) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  restaurantController
                                          .selectedState.value.isEmpty
                                      ? 'Please select a state first'
                                      : 'No cities found',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            );
                          },
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText:
                                restaurantController.selectedState.value.isEmpty
                                    ? "Select state first"
                                    : "Select city",
                            hintStyle:
                                const TextStyle(color: AppColors.blackColor),
                            filled: true,
                            fillColor: AppColors.whiteColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: AppColors.darkGrey.withOpacity(.1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: AppColors.darkGrey.withOpacity(.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: AppColors.primaryColor),
                            ),
                            suffixIcon: const Icon(Icons.arrow_drop_down,
                                color: AppColors.primaryColor),
                          ),
                        ),
                        enabled: restaurantController
                                .selectedState.value.isNotEmpty &&
                            !restaurantController.isLocationDataLoading.value,
                        onChanged: (String? newValue) {
                          restaurantController.onCitySelected(newValue);
                        },
                      );
                    }),
                    const SizedBox(height: 5),
                    Obx(() => restaurantController.cityError.value.isNotEmpty
                        ? Text(
                            restaurantController.cityError.value,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          )
                        : const SizedBox.shrink()),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: 'State ',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 16
                              : Responsive.isTablet(context)
                                  ? 18
                                  : 24,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: '*', // Add the red asterisk
                            style: TextStyle(
                              fontSize: Responsive.isMobile(context)
                                  ? 16
                                  : Responsive.isTablet(context)
                                      ? 18
                                      : 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      return DropdownSearch<String>(
                        items: restaurantController.stateList,
                        selectedItem:
                            restaurantController.selectedState.value.isEmpty
                                ? null
                                : restaurantController.selectedState.value,
                        popupProps: PopupPropsMultiSelection.menu(
                          showSearchBox: true,
                          searchDelay: const Duration(milliseconds: 300),
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search state...",
                              prefixIcon: const Icon(Icons.search,
                                  color: AppColors.primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: AppColors.darkGrey.withOpacity(.1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: AppColors.primaryColor),
                              ),
                            ),
                          ),
                          menuProps: MenuProps(
                            backgroundColor: AppColors.whiteColor,
                            elevation: 8,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          itemBuilder: (context, item, isSelected) {
                            return ListTile(
                              title: Text(item),
                              selected: isSelected,
                              selectedTileColor:
                                  AppColors.primaryColor.withOpacity(0.1),
                            );
                          },
                          emptyBuilder: (context, searchEntry) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'No states found',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            );
                          },
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "Select state",
                            hintStyle:
                                const TextStyle(color: AppColors.blackColor),
                            filled: true,
                            fillColor: AppColors.whiteColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: AppColors.darkGrey.withOpacity(.1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: AppColors.darkGrey.withOpacity(.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: AppColors.primaryColor),
                            ),
                            suffixIcon: const Icon(Icons.arrow_drop_down,
                                color: AppColors.primaryColor),
                          ),
                        ),
                        enabled:
                            !restaurantController.isLocationDataLoading.value,
                        onChanged: (String? newValue) {
                          restaurantController.onStateSelected(newValue);
                        },
                      );
                    }),
                    const SizedBox(height: 5),
                    Obx(() => restaurantController.countryError.value.isNotEmpty
                        ? Text(
                            restaurantController.countryError.value,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          )
                        : const SizedBox.shrink()),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: 'Zip code ',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 16
                              : Responsive.isTablet(context)
                                  ? 18
                                  : 24,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: '*', // Add the red asterisk
                            style: TextStyle(
                              fontSize: Responsive.isMobile(context)
                                  ? 16
                                  : Responsive.isTablet(context)
                                      ? 18
                                      : 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller:
                                restaurantController.restaurantModel.zipCode,
                            borderColor: AppColors.darkGrey.withOpacity(.1),
                            borderRadius: 8,
                            hintText: "45626",
                            fillColor: AppColors.whiteColor,
                            cursorColor: AppColors.primaryColor,
                            inputStyle:
                                const TextStyle(color: AppColors.blackColor),
                            hintStyle:
                                const TextStyle(color: AppColors.blackColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Obx(() => ElevatedButton.icon(
                              onPressed: restaurantController
                                      .isLocationDataLoading.value
                                  ? null
                                  : () {
                                      final zipCode = restaurantController
                                          .restaurantModel.zipCode.text
                                          .trim();
                                      if (zipCode.isNotEmpty) {
                                        restaurantController
                                            .lookupZipCode(zipCode);
                                      }
                                    },
                              icon: restaurantController
                                      .isLocationDataLoading.value
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.search, size: 18),
                              label: const Text('Lookup'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Obx(() => restaurantController.zipCodeError.value.isNotEmpty
                        ? Text(
                            restaurantController.zipCodeError.value,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          )
                        : const SizedBox.shrink()),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: 'About ',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 16
                              : Responsive.isTablet(context)
                                  ? 18
                                  : 24,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: '*', // Add the red asterisk
                            style: TextStyle(
                              fontSize: Responsive.isMobile(context)
                                  ? 16
                                  : Responsive.isTablet(context)
                                      ? 18
                                      : 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: restaurantController.restaurantModel.about,
                      borderColor: AppColors.darkGrey.withOpacity(.1),
                      width: 516,
                      borderRadius: 8,
                      hintText: "About",
                      fillColor: AppColors.whiteColor,
                      cursorColor: AppColors.primaryColor,
                      inputStyle: const TextStyle(color: AppColors.blackColor),
                      hintStyle: const TextStyle(color: AppColors.blackColor),
                    ),
                    const SizedBox(height: 5),
                    Obx(() => restaurantController.aboutError.value.isNotEmpty
                        ? Text(
                            restaurantController.aboutError.value,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          )
                        : const SizedBox.shrink()),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
