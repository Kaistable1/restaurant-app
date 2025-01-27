import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/controller/restaurant_detail_controller.dart';
import 'package:restaurant_web_app/utils/responsive.dart';
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
  Uint8List? _imageBytes; // For the logo image
  Uint8List? _addedImageBytes;
  // Function to pick an image using File Picker
  Future<void> _pickImage({bool isLogo = false}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );

    if (result != null) {
      final file = result.files.single;

      setState(() {
        if (isLogo) {
          _imageBytes = file.bytes; // Set the logo image bytes
        } else {
          _addedImageBytes = file.bytes; // Set the added image bytes
        }
      });
    } else {
      print("No file selected");
    }
  }

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
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  iconSize: Responsive.isMobile(context)
                      ? 14
                      : (Responsive.isTablet(context) ? 16 : 18),
                  icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              SizedBox(width: 10),
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
          SizedBox(
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
                    SizedBox(height: 8),
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
                    SizedBox(height: 24),

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
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Image 1
                            Container(
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
                                image: DecorationImage(
                                  image: AssetImage('assets/images/img3.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            SizedBox(width: 16),
                            // Image 2
                            Container(
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
                                image: DecorationImage(
                                  image: AssetImage('assets/images/img4.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            SizedBox(width: 16),
                            // Add New Image
                            GestureDetector(
                              onTap: () => _pickImage(isLogo: false),
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
                                      color: Colors.grey.withOpacity(.2)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _addedImageBytes == null
                                    ? Icon(Icons.add,
                                        color: AppColors.primaryColor,
                                        size: widget.isDesktop
                                            ? 40
                                            : widget.isTablet
                                                ? 30
                                                : 28)
                                    : Image.memory(_addedImageBytes!,
                                        fit: BoxFit.cover),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                    SizedBox(height: 24),

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
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickImage(isLogo: true),
                      child: _imageBytes == null
                          ? Container(
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
                                  radius: Radius.circular(12),
                                  dashPattern: [6, 3],
                                  color: AppColors.primaryColor,
                                  strokeWidth: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.whiteColor,
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.upload_file_outlined,
                                              size: 32,
                                              color: AppColors.primaryColor),
                                          Text(
                                            'Upload Logo',
                                            style: TextStyle(
                                              fontSize:
                                                  Responsive.isMobile(context)
                                                      ? 12
                                                      : (Responsive.isTablet(
                                                              context)
                                                          ? 14
                                                          : 16),
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          Text(
                                            'Upload a .png file only',
                                            style: TextStyle(
                                              fontSize:
                                                  Responsive.isMobile(context)
                                                      ? 12
                                                      : (Responsive.isTablet(
                                                              context)
                                                          ? 14
                                                          : 16),
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: widget.isDesktop
                                  ? 150
                                  : widget.isTablet
                                      ? 120
                                      : 110,
                              width: 516,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage(_imageBytes!),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                    ),
                    SizedBox(height: 24),

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
                    SizedBox(height: 8),
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
                      suffixIcon: Icon(Icons.location_on,
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
                        iconStyleData: IconStyleData(
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
                          },
                        ),
                        SizedBox(
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
                    SizedBox(height: 8),
                    CustomTextField(
                      controller: restaurantController.phoneController,
                      borderColor: AppColors.darkGrey.withOpacity(.1),
                      width: 516,
                      borderRadius: 8,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          width: 20,
                          height: 45,
                          decoration: BoxDecoration(
                            color: AppColors.darkGrey.withOpacity(.1),
                          ),
                          child: Center(
                            child: Text(
                              '+1',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
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
                    SizedBox(height: 8),
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
                    SizedBox(height: 8),
                    CustomTextField(
                      controller: restaurantController.restaurantModel.city,
                      borderColor: AppColors.darkGrey.withOpacity(.1),
                      width: 516,
                      borderRadius: 8,
                      hintText: "City",
                      fillColor: AppColors.whiteColor,
                      cursorColor: AppColors.primaryColor,
                      inputStyle: const TextStyle(color: AppColors.blackColor),
                      hintStyle: const TextStyle(color: AppColors.blackColor),
                    ),
                    const SizedBox(height: 5),
                    Obx(() => restaurantController.cityError.value.isNotEmpty
                        ? Text(
                            restaurantController.cityError.value,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          )
                        : const SizedBox.shrink()),
                    SizedBox(height: 8),
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
                    SizedBox(height: 8),
                    CustomTextField(
                      controller: restaurantController.restaurantModel.zipCode,
                      borderColor: AppColors.darkGrey.withOpacity(.1),
                      width: 516,
                      borderRadius: 8,
                      hintText: "45626",
                      fillColor: AppColors.whiteColor,
                      cursorColor: AppColors.primaryColor,
                      inputStyle: const TextStyle(color: AppColors.blackColor),
                      hintStyle: const TextStyle(color: AppColors.blackColor),
                    ),
                    const SizedBox(height: 5),
                    Obx(() => restaurantController.zipCodeError.value.isNotEmpty
                        ? Text(
                            restaurantController.zipCodeError.value,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          )
                        : const SizedBox.shrink()),
                    SizedBox(height: 8),
                    // Text(
                    //   'Cuisine',
                    //   style: TextStyle(
                    //     fontSize: Responsive.isMobile(context)
                    //         ? 16
                    //         : Responsive.isTablet(context)
                    //             ? 18
                    //             : 24,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    // SizedBox(height: 8),
                    //
                    // Row(
                    //   children: [
                    //     CustomTextField(
                    //       borderColor: AppColors.darkGrey
                    //           .withOpacity(.1),
                    //       width: Responsive.isMobile(context)
                    //           ? screenWidth * 0.28
                    //           : screenWidth * 0.3,
                    //       borderRadius: 8,
                    //       controller: restaurantController
                    //           .cuisineController,
                    //       hintText: "Cuisines",
                    //       fillColor: AppColors.whiteColor,
                    //       cursorColor: AppColors.primaryColor,
                    //       inputStyle: const TextStyle(
                    //           color: AppColors.blackColor),
                    //       hintStyle: const TextStyle(
                    //           color: AppColors.blackColor),
                    //     ),
                    //     SizedBox(width: 10),
                    //     InkWell(
                    //       onTap: () {
                    //         if (restaurantController
                    //             .cuisineController
                    //             .text
                    //             .isNotEmpty) {
                    //           setState(() {
                    //             restaurantController
                    //                 .addedCuisines
                    //                 .add(restaurantController
                    //                     .cuisineController
                    //                     .text);
                    //             restaurantController
                    //                 .cuisineController
                    //                 .clear();
                    //           });
                    //           restaurantController
                    //               .cusineError.value = '';
                    //         }
                    //       },
                    //       child: Container(
                    //         width: 24,
                    //         height: 24,
                    //         decoration: BoxDecoration(
                    //           border: Border.all(
                    //               color:
                    //                   AppColors.primaryColor,
                    //               width: 2),
                    //           borderRadius:
                    //               BorderRadius.circular(4.0),
                    //         ),
                    //         child: Center(
                    //           child: Icon(Icons.add,
                    //               color:
                    //                   AppColors.primaryColor,
                    //               size: 16),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 5),
                    // Obx(() => restaurantController
                    //         .cusineError.value.isNotEmpty
                    //     ? Text(
                    //         restaurantController
                    //             .cusineError.value,
                    //         style: const TextStyle(
                    //             color: Colors.red,
                    //             fontSize: 12),
                    //       )
                    //     : const SizedBox.shrink()),
                    //
                    // SizedBox(height: 10),
                    // Wrap(
                    //   spacing:
                    //       10.0, // Horizontal space between items
                    //   runSpacing:
                    //       10.0, // Vertical space between rows
                    //   children: List.generate(
                    //     restaurantController
                    //         .addedCuisines.length,
                    //     (index) {
                    //       return _buildCuisineContainer(
                    //           index);
                    //     },
                    //   ),
                    // ),
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
