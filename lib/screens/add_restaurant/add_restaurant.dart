import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/screens/add_restaurant/widgets/restaurant_basic_widget.dart';

import '../../../utils/responsive.dart';
import '../../../widgets/round_button.dart';
import '../../../widgets/text_field.dart';
import '../main_screen/mainscreen_controller/main_controller.dart';
import '../restaurant_detail_screen/controller/restaurant_detail_controller.dart';
import '../restaurant_detail_screen/widget/map_widget.dart';
import 'add_resturant_controller/add_resturant _controller.dart';

class AddEditRestaurantScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  final controller = Get.put(AddRestaurantController());
  final mainController = Get.put(MainController());

  AddEditRestaurantScreen({super.key, this.onNavigate, this.isFromButtonClick});
  bool? isFromButtonClick;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: isFromButtonClick == null
          ? null
          : AppBar(
              backgroundColor: AppColors.whiteColor,
              toolbarHeight: 110,
              automaticallyImplyLeading: false,
              elevation: 1,
              title: Image.asset(
                'assets/images/appbar_logo.png',
                width: 200,
                height: 70,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 230,
                    height: 59,
                    decoration: BoxDecoration(
                      color: AppColors.bgColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Text('Account Settings'),
                          Spacer(),
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: AppColors.primaryColor,
                            ),
                            onSelected: (value) {
                              if (value == 'Logout') {
                                mainController.showLogoutDialog(
                                    context); // Show logout dialog
                              } else {
                                mainController.selectedMenuItem = value;
                                mainController.isAddingRestaurant = false;
                                mainController.update();
                                Get.close(1);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'Home',
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/home.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: 16),
                                    Text('Home'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'View Restaurant Details',
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/resturant_detail.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: 16),
                                    Text('View Restaurant Details'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Change Password',
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/change_password.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: 16),
                                    Text('Change Password'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'Logout',
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/logout.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: 16),
                                    Text('Logout'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      body: AddEditRestaurantContent(),
    );
  }
}

class AddEditRestaurantContent extends StatefulWidget {
  @override
  State<AddEditRestaurantContent> createState() =>
      _AddEditRestaurantContentState();
}

class _AddEditRestaurantContentState extends State<AddEditRestaurantContent> {
  final _formKey = GlobalKey<FormState>();

  final controller = Get.put(RestaurantDetailController());
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
    restaurantController.restaurantsNameError.value = '';
    restaurantController.addressError.value = '';
    restaurantController.phoneError.value = '';
    // restaurantController.cusineError.value = '';
    restaurantController.cityError.value = '';
    restaurantController.zipCodeError.value = '';
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth > 530
        ? 530
        : screenWidth * 0.9; // max width 530, else 90% of screen width

    return GetBuilder<AddRestaurantController>(builder: (addResConotroller) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1024;
          final isTablet =
              constraints.maxWidth >= 600 && constraints.maxWidth < 1024;

          return Responsive.isDesktop(context)
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Container(
                        // width: containerWidth, // Width responsive to screen
                        child: Restaurantbasicwidget(
                      isDesktop: isDesktop,
                      isTablet: isTablet,
                    )),
                  ),
                )
              : GetBuilder<AddRestaurantController>(
                  init: AddRestaurantController(),
                  builder: (restaurantController) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: restaurantController.formKey,
                          child: Container(
                            // width: containerWidth, // Width responsive to screen
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: Responsive.isMobile(context)
                                          ? 30
                                          : (Responsive.isTablet(context)
                                              ? 36
                                              : 42),
                                      height: Responsive.isMobile(context)
                                          ? 30
                                          : (Responsive.isTablet(context)
                                              ? 36
                                              : 42),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        iconSize: Responsive.isMobile(context)
                                            ? 14
                                            : (Responsive.isTablet(context)
                                                ? 16
                                                : 18),
                                        icon: Icon(Icons.arrow_back,
                                            color: AppColors.primaryColor),
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Add Restaurant Details',
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
                                SizedBox(height: 8),
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
                                  controller: restaurantController
                                      .restaurantNameController,
                                  borderColor:
                                      AppColors.darkGrey.withOpacity(.1),
                                  width: 516,
                                  borderRadius: 8,
                                  hintText: "Restaurant name",
                                  fillColor: AppColors.whiteColor,
                                  cursorColor: AppColors.primaryColor,
                                  inputStyle: const TextStyle(
                                      color: AppColors.blackColor),
                                  hintStyle: const TextStyle(
                                      color: AppColors.blackColor),
                                ),
                                const SizedBox(height: 5),
                                Obx(() => restaurantController
                                        .restaurantsNameError.value.isNotEmpty
                                    ? Text(
                                        restaurantController
                                            .restaurantsNameError.value,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // Image 1
                                        Container(
                                          height: isDesktop
                                              ? 160
                                              : isTablet
                                                  ? 150
                                                  : 100,
                                          width: isDesktop
                                              ? 160
                                              : isTablet
                                                  ? 150
                                                  : 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/img3.png'),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        // Image 2
                                        Container(
                                          height: isDesktop
                                              ? 160
                                              : isTablet
                                                  ? 150
                                                  : 100,
                                          width: isDesktop
                                              ? 160
                                              : isTablet
                                                  ? 150
                                                  : 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/img4.png'),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        // Add New Image
                                        GestureDetector(
                                          onTap: () =>
                                              _pickImage(isLogo: false),
                                          child: Container(
                                            height: isDesktop
                                                ? 160
                                                : isTablet
                                                    ? 150
                                                    : 100,
                                            width: isDesktop
                                                ? 160
                                                : isTablet
                                                    ? 150
                                                    : 100,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(.2)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: _addedImageBytes == null
                                                ? Icon(Icons.add,
                                                    color:
                                                        AppColors.primaryColor,
                                                    size: isDesktop
                                                        ? 40
                                                        : isTablet
                                                            ? 30
                                                            : 28)
                                                : Image.memory(
                                                    _addedImageBytes!,
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

                                ///start of logo

                                GestureDetector(
                                  onTap: () async {
                                    Uint8List? selectedImage = await controller.getImage();

                                    if (selectedImage != null && selectedImage.isNotEmpty) {
                                      restaurantController.restaurantModel.logoImageMemory.value =
                                          selectedImage;
                                    }

                                  }/*=> _pickImage(isLogo: true)*/,
                                  child: _imageBytes == null
                                      ? Container(
                                          height: isDesktop
                                              ? 150
                                              : isTablet
                                                  ? 120
                                                  : 110,
                                          width: 516,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(.1)),
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: AppColors.whiteColor,
                                                ),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .upload_file_outlined,
                                                          size: 32,
                                                          color: AppColors
                                                              .primaryColor),
                                                      Text(
                                                        'Upload Logo',
                                                        style: TextStyle(
                                                          fontSize: Responsive
                                                                  .isMobile(
                                                                      context)
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
                                                                  .isMobile(
                                                                      context)
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
                                      : Container(
                                          height: isDesktop
                                              ? 150
                                              : isTablet
                                                  ? 120
                                                  : 110,
                                          width: 516,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: MemoryImage(_imageBytes!),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                ),

                             ///end of logo
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
                                  controller:
                                      restaurantController.restaurantModel.address,
                                  borderColor:
                                      AppColors.darkGrey.withOpacity(.1),
                                  width: 516,
                                  borderRadius: 8,
                                  hintText: "Address",
                                  fillColor: AppColors.whiteColor,
                                  cursorColor: AppColors.primaryColor,
                                  inputStyle: const TextStyle(
                                      color: AppColors.blackColor),
                                  hintStyle: const TextStyle(
                                      color: AppColors.blackColor),
                                  suffixIcon: Icon(Icons.location_on,
                                      color: AppColors.primaryColor),
                                ),
                                const SizedBox(height: 5),
                                Obx(() => restaurantController
                                        .addressError.value.isNotEmpty
                                    ? Text(
                                        restaurantController.addressError.value,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 12),
                                      )
                                    : const SizedBox.shrink()),
                                SizedBox(
                                    height:
                                        Responsive.isMobile(context) ? 12 : 22),
                                Column(
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
                                              fontSize: Responsive.isMobile(
                                                      context)
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
                                      controller:
                                          restaurantController.phoneController,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          width: 20,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: AppColors.darkGrey
                                                .withOpacity(.1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '+1',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      borderColor:
                                          AppColors.darkGrey.withOpacity(.1),
                                      width: 516,
                                      borderRadius: 8,
                                      hintText: "Phone no",
                                      fillColor: AppColors.whiteColor,
                                      cursorColor: AppColors.primaryColor,
                                      inputStyle: const TextStyle(
                                          color: AppColors.blackColor),
                                      hintStyle: const TextStyle(
                                          color: AppColors.blackColor),
                                    ),
                                    const SizedBox(height: 5),
                                    Obx(() => restaurantController
                                            .phoneError.value.isNotEmpty
                                        ? Text(
                                            restaurantController
                                                .phoneError.value,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12),
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
                                              fontSize: Responsive.isMobile(
                                                      context)
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
                                      controller:
                                          restaurantController.cityController,
                                      borderColor:
                                          AppColors.darkGrey.withOpacity(.1),
                                      width: 516,
                                      borderRadius: 8,
                                      hintText: "City",
                                      fillColor: AppColors.whiteColor,
                                      cursorColor: AppColors.primaryColor,
                                      inputStyle: const TextStyle(
                                          color: AppColors.blackColor),
                                      hintStyle: const TextStyle(
                                          color: AppColors.blackColor),
                                    ),
                                    const SizedBox(height: 5),
                                    Obx(() => restaurantController
                                            .cityError.value.isNotEmpty
                                        ? Text(
                                            restaurantController
                                                .cityError.value,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12),
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
                                              fontSize: Responsive.isMobile(
                                                      context)
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
                                      controller: restaurantController
                                          .zipCodeController,
                                      borderColor:
                                          AppColors.darkGrey.withOpacity(.1),
                                      width: 516,
                                      borderRadius: 8,
                                      hintText: "45625",
                                      fillColor: AppColors.whiteColor,
                                      cursorColor: AppColors.primaryColor,
                                      inputStyle: const TextStyle(
                                          color: AppColors.blackColor),
                                      hintStyle: const TextStyle(
                                          color: AppColors.blackColor),
                                    ),
                                    const SizedBox(height: 5),

                                    Obx(() => restaurantController
                                            .zipCodeError.value.isNotEmpty
                                        ? Text(
                                            restaurantController
                                                .zipCodeError.value,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12),
                                          )
                                        : const SizedBox.shrink()),
                                    SizedBox(height: 8),
                                    // Text(
                                    //   'Cuisines',
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
                                    //       hintText: "Cuisine",
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
                                    // Column(
                                    //   children: List.generate(
                                    //       restaurantController
                                    //           .addedCuisines.length, (index) {
                                    //     return _buildCuisineContainer(index);
                                    //   }),
                                    // ),
                                  ],
                                ),
                                Text(
                                  'Map',
                                  style: TextStyle(
                                    fontSize: Responsive.isMobile(context)
                                        ? 16
                                        : Responsive.isTablet(context)
                                            ? 18
                                            : 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        Responsive.isMobile(context) ? 12 : 22),
                                Container(
                                  height: Get.height * 0.4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16)),
                                  child: MapWidget(controller: controller),
                                ),
                                SizedBox(
                                    height:
                                        Responsive.isMobile(context) ? 12 : 22),
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
                                SizedBox(
                                    height:
                                        Responsive.isMobile(context) ? 12 : 22),

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
                                        .map((String item) =>
                                            DropdownMenuItem<String>(
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
                                      });
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.darkGrey
                                              .withOpacity(.1),
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            8), // Rounded corners
                                        color: AppColors.whiteColor,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
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
                                SizedBox(
                                    height:
                                        Responsive.isMobile(context) ? 12 : 22),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomButton(
                                      title: "Save and Continue",
                                      textStyle: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: Responsive.isMobile(context)
                                            ? 16
                                            : 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      backgroundColor: AppColors.primaryColor,
                                      borderRadius: 8,
                                      width: Responsive.isMobile(context)
                                          ? Get.width * 0.3
                                          : Get.width * 0.2,
                                      onPressed: () {
                                        restaurantController.saveNextScreen();
                                      },
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    // CustomButton(
                                    //   title: "Next",
                                    //   textStyle: TextStyle(
                                    //     color: AppColors.primaryColor,
                                    //     fontSize: Responsive.isMobile(context)
                                    //         ? 16
                                    //         : 18,
                                    //     fontWeight: FontWeight.w600,
                                    //   ),
                                    //   backgroundColor: AppColors.whiteColor,
                                    //   borderClr: AppColors.primaryColor,
                                    //   borderRadius: 8,
                                    //   width: Responsive.isMobile(context)
                                    //       ? Get.width * 0.1
                                    //       : Get.width * 0.2,
                                    //   onPressed: () {
                                    //     restaurantController
                                    //         .saveNextScreen(); // Disable if not saved
                                    //   },
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                    height:
                                        Responsive.isMobile(context) ? 12 : 22),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
        },
      );
    });
  }

  Widget _buildCuisineContainer(int index) {
    return Stack(
      children: [
        // Container for displaying the cuisine
        Container(
          width: 170, // Adjusted width
          height: 50, // Adjusted height
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          margin:
              EdgeInsets.only(bottom: 10), // Adds spacing between containers
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.darkGrey.withOpacity(.2),
              )
              // border: Border.all(color: Colors.blue, width: 2),
              ),
          child: Center(
            child: Text(
              restaurantController.addedCuisines[index],
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        // Positioned Circular Container with Cross Icon
        Positioned(
          top: 3, // Half of the cross button is above the container
          right: 3, // Half of the cross button is outside the container
          child: GestureDetector(
            onTap: () {
              setState(() {
                restaurantController.addedCuisines
                    .removeAt(index); // Remove the item when clicked
              });
            },
            child: Container(
              width: 15, // Circular button size
              height: 15, // Circular button size
              decoration: BoxDecoration(
                color: AppColors
                    .primaryColor, // Background color for the circular container
                shape: BoxShape.circle, // Makes the container circular
              ),
              child: Icon(
                Icons.close, // Cross icon
                color: Colors.white, // Icon color
                size: 10, // Icon size
              ),
            ),
          ),
        ),
      ],
    );
  }
}
