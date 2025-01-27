import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/testing.dart';
import 'package:restaurant_web_app/utils/responsive.dart';

import '../../../../widgets/round_button.dart';
import '../../../../widgets/text_field.dart';
import '../../main_screen/mainscreen_controller/main_controller.dart';
import '../../restaurant_detail_screen/restaurant_detail_screen.dart';
import '../../restaurant_detail_screen/widget/star_widget_gen_discount.dart';
import 'edit_restaurant_controller/edit_restaurant_controller.dart';

class EditRestaurantScreen extends StatelessWidget {
  final Function(int)? onNavigate;

  final mainController = Get.put(MainController());

  EditRestaurantScreen({super.key, this.onNavigate, this.isFromButtonClick});
  bool? isFromButtonClick;
  bool isChecked = false;

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
                                Get.close(4);
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
      body: DiscountTimeSetup(),
    );
  }
}

class DiscountTimeSetup extends StatefulWidget {
  @override
  _DiscountTimeSetupState createState() => _DiscountTimeSetupState();
}

class _DiscountTimeSetupState extends State<DiscountTimeSetup> {
  String? selected_generalDiscounts;
  final controller = Get.put(EditRestaurantController());
  final  itemController = Get.put(ItemController());
  String? selected_cuisne1;
  String? selected_cuisne3;
  String? selected_menuType;
  String? selected_cuisne;
  bool _isDiscountListVisible = true;
  final List<String> generalDiscounts = [
    'Percentage Off',
    'Happy Hour Special ',
  ];
  final List<String> cuisine = [
    'Italian',
    'Mexican',
    'Asian',
    'American',
    'Vegan',
    'Mediterranean',
    'other',
  ];
  final List<String> menuType = [
    'Food Menu',
    'Drinks Menu',
  ];
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dateControllerTo = TextEditingController();
  TextEditingController customCuisineController = TextEditingController();
  @override
  void dispose() {
    customCuisineController
        .dispose(); // Dispose controller when widget is destroyed
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select Date', // Customizable text
      cancelText: 'Cancel',
      confirmText: 'OK',
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            DateFormat('dd/MM/yy').format(pickedDate); // Formatting the date
      });
    }
  }

  Future<void> _selectDateTo(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select Date', // Customizable text
      cancelText: 'Cancel',
      confirmText: 'OK',
    );

    if (pickedDate != null) {
      setState(() {
        _dateControllerTo.text =
            DateFormat('dd/MM/yy').format(pickedDate); // Formatting the date
      });
    }
  }

  Uint8List? _addedImageBytes;
  Uint8List? _imageBytes; // For the logo image
  // For the added image
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

  List<int> discounts = [10, 20, 30, 40, 50, 60]; // Initial discounts
  int maxDiscount = 60; // Maximum discount value
  bool _isVisible = true;
  bool _isColumn2Visible = false;
  bool _isColumnVisible = false;
  bool _isColumn3Visible = false; // To control visibility of the column
  int? _selectedIndex; // Checkbox states

  List<Map<String, dynamic>> _discounts = [
    {"value": 10, "isSelected": false},
    {"value": 20, "isSelected": false},
    {"value": 30, "isSelected": false},
    {"value": 40, "isSelected": false},
    {"value": 50, "isSelected": false},
    {"value": 60, "isSelected": false},
    {"value": null, "isSelected": false}, // Add more field
  ];

  void _onCheckboxChanged(int index) {
    setState(() {
      // Unselect all checkboxes and select only the current one
      _selectedIndex = index;
      for (var i = 0; i < _discounts.length; i++) {
        _discounts[i]["isSelected"] = i == index;
      }
    });
  }

  void _addNewDiscount() {
    setState(() {
      // Calculate the next discount in the series
      maxDiscount += 10;
      discounts.add(maxDiscount);
    });
  }

  get screenWidth => MediaQuery.of(context).size.width;

  bool isAmSelected = true;
  bool isAmSelected2 = true;

  bool isChecked = false;
  bool isAllDay = false;

  void _removeContainer() {
    setState(() {
      _isVisible = false;
    });
  }

  int? _selectedDiscount;

  bool showTextField = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Leading back button
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
                SizedBox(
                  width: 10,
                ),
                // Title
                Text(
                  'Add Meal Discounts',
                  textAlign: TextAlign.center,
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

                // Placeholder for alignment
              ],
            ),

            SizedBox(
              height: Responsive.isMobile(context)
                  ? 10
                  : (Responsive.isTablet(context) ? 15 : 20),
            ),
            Text(
              'Discounts',
              style: TextStyle(
                fontSize: Responsive.isMobile(context)
                    ? 16
                    : Responsive.isTablet(context)
                        ? 18
                        : 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 211,
                  height: 238,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.whiteColor,
                    border:
                        Border.all(color: AppColors.darkGrey.withOpacity(.1)),
                  ),
                  child: Stack(
                    children: [
                      // Image at the top, take the full height of the container
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          'assets/images/p1.png', // Replace with your image asset
                          width: 211, // Set width to match the container
                          height: 150, // Set height to match the container
                          fit: BoxFit
                              .cover, // Make sure the image covers the entire area
                        ),
                      ),
                      // Cross Icon at the top right corner

                      // Plus Icon at the bottom right corner

                      // Meal Info below the image
                      Positioned(
                        bottom: 5,
                        left: 8,
                        right: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Happy Hour',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            SizedBox(
                                height: 8), // Spacing between text and list
                            Container(
                              height: Responsive.isMobile(context)
                                  ? 40
                                  : Responsive.isDesktop(context)
                                      ? 60
                                      : 50, // Adjusted height for horizontal list items
                              child: ListView.builder(
                                scrollDirection:
                                    Axis.horizontal, // Horizontal scrolling
                                itemCount: controller
                                    .circleItems3.length, // Number of items
                                itemBuilder: (context, index) {
                                  final item = controller.circleItems3[
                                      index]; // Get item from model list
                                  return SizedBox(
                                    width: Responsive.isMobile(context)
                                        ? 40
                                        : Responsive.isDesktop(context)
                                            ? 60
                                            : 50, // Width of each item
                                    child: LocationStarWidget(
                                      timeText: 'item.timeText',
                                      persentText: item.persentText,
                                      persentTextStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: Responsive.isMobile(context)
                                            ? 4
                                            : Responsive.isTablet(context)
                                                ? 5
                                                : 7,
                                        fontFamily: 'Nunito-Regular',
                                      ),
                                      timeTextStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: Responsive.isMobile(context)
                                            ? 4
                                            : Responsive.isTablet(context)
                                                ? 5
                                                : 7,
                                        fontFamily: 'Nunito-Regular',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        top: 0,
                        right: 8,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 120, // width of the circle
                                  height: 18, // height of the circle
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors
                                        .primaryColor, // background color
                                    shape: BoxShape
                                        .rectangle, // makes the container circular
                                  ),
                                  child: Center(
                                    child: Text(
                                      '03.10.2024 - 04.10.2024',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 20, // width of the circle
                                  height: 20, // height of the circle
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.darkGrey, // background color
                                    shape: BoxShape
                                        .circle, // makes the container circular
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      onPressed:
                                      _removeContainer;
                                    },
                                    child: Icon(
                                      Icons.close, // cross icon
                                      color: Colors.white, // icon color
                                      size:
                                          10, // adjust icon size to fit the circle
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          right: 8,
                          bottom: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/btn_image.png',
                              width: 24,
                              height: 24,
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  width: Responsive.isMobile(context) ? 8 : 30,
                ),
                // Add Button
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isColumnVisible = !_isColumnVisible;
                        });
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Center(
                          child: Icon(Icons.add,
                              color: AppColors.primaryColor, size: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Add Discount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            // Conditional Column
            if (_isColumnVisible)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Date',
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context)
                          ? 16
                          : Responsive.isTablet(context)
                              ? 18
                              : 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  Responsive.isDesktop(context)
                      ? Row(
                          children: [
                            Text(
                              'From',
                              style: TextStyle(
                                fontSize: Responsive.isMobile(context)
                                    ? 14
                                    : Responsive.isTablet(context)
                                        ? 16
                                        : 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: Row(
                                  children: [
                                    CustomTextField(
                                      borderColor:
                                          AppColors.darkGrey.withOpacity(.1),
                                      controller: _dateController,
                                      width: 117,
                                      borderRadius: 8,
                                      hintText: "DD.MM.YY",
                                      fillColor: AppColors.whiteColor,
                                      cursorColor: AppColors.primaryColor,
                                      inputStyle: const TextStyle(
                                          color: AppColors.blackColor),
                                      hintStyle: const TextStyle(
                                          color: AppColors.blackColor),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      'assets/images/date_calender.png',
                                      width: 25,
                                      height: 25,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'To',
                              style: TextStyle(
                                fontSize: Responsive.isMobile(context)
                                    ? 14
                                    : Responsive.isTablet(context)
                                        ? 16
                                        : 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () => _selectDateTo(context),
                              child: AbsorbPointer(
                                child: Row(
                                  children: [
                                    CustomTextField(
                                      borderColor:
                                          AppColors.darkGrey.withOpacity(.1),
                                      controller: _dateControllerTo,
                                      width: 117,
                                      borderRadius: 8,
                                      hintText: "DD.MM.YY",
                                      fillColor: AppColors.whiteColor,
                                      cursorColor: AppColors.primaryColor,
                                      inputStyle: const TextStyle(
                                          color: AppColors.blackColor),
                                      hintStyle: const TextStyle(
                                          color: AppColors.blackColor),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      'assets/images/date_calender.png',
                                      width: 25,
                                      height: 25,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Checkbox(
                                value: isChecked,
                                side: BorderSide(color: AppColors.whiteColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value ?? false;
                                  });
                                },
                                activeColor: Colors.white,
                                checkColor: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Lifetime',
                              style: TextStyle(
                                fontSize: Responsive.isMobile(context)
                                    ? 14
                                    : Responsive.isTablet(context)
                                        ? 16
                                        : 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'From',
                                  style: TextStyle(
                                    fontSize: Responsive.isMobile(context)
                                        ? 14
                                        : Responsive.isTablet(context)
                                            ? 16
                                            : 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: AbsorbPointer(
                                    child: Row(
                                      children: [
                                        CustomTextField(
                                          borderColor: AppColors.darkGrey
                                              .withOpacity(.1),
                                          controller: _dateController,
                                          width: 117,
                                          borderRadius: 8,
                                          hintText: "DD.MM.YY",
                                          fillColor: AppColors.whiteColor,
                                          cursorColor: AppColors.primaryColor,
                                          inputStyle: const TextStyle(
                                              color: AppColors.blackColor),
                                          hintStyle: const TextStyle(
                                              color: AppColors.blackColor),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/images/date_calender.png',
                                          width: 25,
                                          height: 25,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  'To',
                                  style: TextStyle(
                                    fontSize: Responsive.isMobile(context)
                                        ? 14
                                        : Responsive.isTablet(context)
                                            ? 16
                                            : 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  width: 28,
                                ),
                                GestureDetector(
                                  onTap: () => _selectDateTo(context),
                                  child: AbsorbPointer(
                                    child: Row(
                                      children: [
                                        CustomTextField(
                                          borderColor: AppColors.darkGrey
                                              .withOpacity(.1),
                                          controller: _dateControllerTo,
                                          width: 117,
                                          borderRadius: 8,
                                          hintText: "DD.MM.YY",
                                          fillColor: AppColors.whiteColor,
                                          cursorColor: AppColors.primaryColor,
                                          inputStyle: const TextStyle(
                                              color: AppColors.blackColor),
                                          hintStyle: const TextStyle(
                                              color: AppColors.blackColor),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          'assets/images/date_calender.png',
                                          width: 25,
                                          height: 25,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Checkbox(
                                    value: isChecked,
                                    side:
                                        BorderSide(color: AppColors.whiteColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value ?? false;
                                      });
                                    },
                                    activeColor: Colors.white,
                                    checkColor: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Lifetime',
                                  style: TextStyle(
                                    fontSize: Responsive.isMobile(context)
                                        ? 14
                                        : Responsive.isTablet(context)
                                            ? 16
                                            : 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                  // Text displayed before the list
                  SizedBox(height: 10),

                  // Spacing between the heading and the list

                  Text(
                    'Add Percentage Value',
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context)
                          ? 16
                          : Responsive.isTablet(context)
                              ? 18
                              : 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      LocationStarWidget(
                        timeText: '20:00 to 21:00',
                        persentText: '10% off',
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isColumn3Visible = !_isColumn3Visible;
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.primaryColor, width: 2),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Center(
                                child: Icon(Icons.add,
                                    color: AppColors.primaryColor, size: 16),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Percentage Value',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // List items
                  if (_isColumn3Visible)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isDiscountListVisible)
                          Row(
                            children: [
                              // Dropdown button to select discount
                              SizedBox(
                                width: screenWidth * .3,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<int>(
                                    hint: Text(
                                      "Select Percentage Value",
                                      style: TextStyle(
                                          color:
                                              Colors.grey), // Hint text style
                                    ),
                                    value: _selectedDiscount,
                                    onChanged: (int? newValue) {
                                      setState(() {
                                        _selectedDiscount = newValue;
                                      });
                                    },
                                    items: [
                                      10,
                                      20,
                                      30
                                    ].map<DropdownMenuItem<int>>((int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text('$value%'),
                                      );
                                    }).toList(),
                                    buttonStyleData: ButtonStyleData(
                                      decoration: BoxDecoration(
                                        color: AppColors
                                            .whiteColor, // Background color
                                        border: Border.all(
                                          color: AppColors.darkGrey
                                              .withOpacity(.1), // Border color
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            8), // Rounded corners
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              16), // Padding inside button
                                      height: 40, // Button height
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40, // Menu item height
                                    ),
                                    iconStyleData: IconStyleData(
                                      icon: Icon(
                                        Icons
                                            .keyboard_arrow_down_outlined, // Custom dropdown icon
                                        color: AppColors
                                            .primaryColor, // Icon color
                                      ),
                                      iconSize: 24, // Icon size
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Time ',
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
                  SizedBox(height: 10),
                  Responsive.isDesktop(context)
                      ? Row(
                          children: [
                            Text(
                              'From',
                              style: TextStyle(
                                fontSize: Responsive.isMobile(context)
                                    ? 14
                                    : Responsive.isTablet(context)
                                        ? 16
                                        : 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Hour Input
                                Container(
                                  width: 44,
                                  height: 39,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400, width: 1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(bottom: 10),
                                        hintText: '00',
                                        fillColor: Colors.grey.withOpacity(.4),
                                        filled: true,
                                        hintStyle: TextStyle(
                                            fontSize: 18,
                                            color: AppColors.whiteColor),
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(
                                            2), // Restrict to 2 digits
                                      ],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                // Colon Separator
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                // Minute Input
                                Container(
                                  width: 44,
                                  height: 39,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400, width: 1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(bottom: 10),
                                        hintText: '00',
                                        fillColor: Colors.grey.withOpacity(.4),
                                        filled: true,
                                        hintStyle: TextStyle(
                                            fontSize: 18,
                                            color: AppColors.whiteColor),
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(
                                            2), // Restrict to 2 digits
                                      ],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                // AM/PM Toggle
                                Container(
                                  height: 39,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.grey.shade400, width: 1),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isAmSelected = true;
                                          });
                                        },
                                        child: Container(
                                          width: 44,
                                          height: 39,
                                          decoration: BoxDecoration(
                                            color: isAmSelected
                                                ? AppColors.primaryColor
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'AM',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: isAmSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isAmSelected = false;
                                          });
                                        },
                                        child: Container(
                                          height: 39,
                                          width: 44,
                                          decoration: BoxDecoration(
                                            color: !isAmSelected
                                                ? AppColors.primaryColor
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'PM',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: !isAmSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(
                                  Icons.watch_later_outlined,
                                  size: 30,
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Text(
                              'To',
                              style: TextStyle(
                                fontSize: Responsive.isMobile(context)
                                    ? 14
                                    : Responsive.isTablet(context)
                                        ? 16
                                        : 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Hour Input
                                Container(
                                  width: 44,
                                  height: 39,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400, width: 1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(bottom: 10),
                                        hintText: '00',
                                        fillColor: Colors.grey.withOpacity(.4),
                                        filled: true,
                                        hintStyle: TextStyle(
                                            fontSize: 18,
                                            color: AppColors.whiteColor),
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(
                                            2), // Restrict to 2 digits
                                      ],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                // Colon Separator
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                // Minute Input
                                Container(
                                  width: 44,
                                  height: 39,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400, width: 1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(bottom: 10),
                                        hintText: '00',
                                        fillColor: Colors.grey.withOpacity(.4),
                                        filled: true,
                                        hintStyle: TextStyle(
                                            fontSize: 18,
                                            color: AppColors.whiteColor),
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(
                                            2), // Restrict to 2 digits
                                      ],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                // AM/PM Toggle
                                Container(
                                  height: 39,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.grey.shade400, width: 1),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isAmSelected2 = true;
                                          });
                                        },
                                        child: Container(
                                          width: 44,
                                          height: 39,
                                          decoration: BoxDecoration(
                                            color: isAmSelected2
                                                ? AppColors.primaryColor
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'AM',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: isAmSelected2
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isAmSelected2 = false;
                                          });
                                        },
                                        child: Container(
                                          height: 39,
                                          width: 44,
                                          decoration: BoxDecoration(
                                            color: !isAmSelected2
                                                ? AppColors.primaryColor
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'PM',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: !isAmSelected2
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(
                                  Icons.watch_later_outlined,
                                  size: 30,
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Checkbox(
                                value: isAllDay,
                                side: BorderSide(color: AppColors.whiteColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                onChanged: (bool? value) {
                                  setState(() {
                                    isAllDay = value ?? false;
                                  });
                                },
                                activeColor: Colors.white,
                                checkColor: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'All Day',
                              style: TextStyle(
                                fontSize: Responsive.isMobile(context)
                                    ? 14
                                    : Responsive.isTablet(context)
                                        ? 16
                                        : 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'From',
                                  style: TextStyle(
                                    fontSize: Responsive.isMobile(context)
                                        ? 14
                                        : Responsive.isTablet(context)
                                            ? 16
                                            : 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Hour Input
                                    Container(
                                      width: 44,
                                      height: 39,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Center(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(bottom: 10),
                                            hintText: '00',
                                            fillColor:
                                                Colors.grey.withOpacity(.4),
                                            filled: true,
                                            hintStyle: TextStyle(
                                                fontSize: 18,
                                                color: AppColors.whiteColor),
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                                2), // Restrict to 2 digits
                                          ],
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    // Colon Separator
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    // Minute Input
                                    Container(
                                      width: 44,
                                      height: 39,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Center(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(bottom: 10),
                                            hintText: '00',
                                            fillColor:
                                                Colors.grey.withOpacity(.4),
                                            filled: true,
                                            hintStyle: TextStyle(
                                                fontSize: 18,
                                                color: AppColors.whiteColor),
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                                2), // Restrict to 2 digits
                                          ],
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    // AM/PM Toggle
                                    Container(
                                      height: 39,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1),
                                      ),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isAmSelected = true;
                                              });
                                            },
                                            child: Container(
                                              width: 44,
                                              height: 39,
                                              decoration: BoxDecoration(
                                                color: isAmSelected
                                                    ? AppColors.primaryColor
                                                    : Colors.transparent,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomLeft:
                                                      Radius.circular(8),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'AM',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: isAmSelected
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isAmSelected = false;
                                              });
                                            },
                                            child: Container(
                                              height: 39,
                                              width: 44,
                                              decoration: BoxDecoration(
                                                color: !isAmSelected
                                                    ? AppColors.primaryColor
                                                    : Colors.transparent,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(8),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'PM',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: !isAmSelected
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Icon(
                                      Icons.watch_later_outlined,
                                      size: 30,
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'To',
                                  style: TextStyle(
                                    fontSize: Responsive.isMobile(context)
                                        ? 14
                                        : Responsive.isTablet(context)
                                            ? 16
                                            : 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 28),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Hour Input
                                    Container(
                                      width: 44,
                                      height: 39,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Center(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(bottom: 10),
                                            hintText: '00',
                                            fillColor:
                                                Colors.grey.withOpacity(.4),
                                            filled: true,
                                            hintStyle: TextStyle(
                                                fontSize: 18,
                                                color: AppColors.whiteColor),
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                                2), // Restrict to 2 digits
                                          ],
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    // Colon Separator
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    // Minute Input
                                    Container(
                                      width: 44,
                                      height: 39,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Center(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(bottom: 10),
                                            hintText: '00',
                                            fillColor:
                                                Colors.grey.withOpacity(.4),
                                            filled: true,
                                            hintStyle: TextStyle(
                                                fontSize: 18,
                                                color: AppColors.whiteColor),
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                                2), // Restrict to 2 digits
                                          ],
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    // AM/PM Toggle
                                    Container(
                                      height: 39,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1),
                                      ),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isAmSelected2 = true;
                                              });
                                            },
                                            child: Container(
                                              width: 44,
                                              height: 39,
                                              decoration: BoxDecoration(
                                                color: isAmSelected2
                                                    ? AppColors.primaryColor
                                                    : Colors.transparent,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomLeft:
                                                      Radius.circular(8),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'AM',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: isAmSelected2
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isAmSelected2 = false;
                                              });
                                            },
                                            child: Container(
                                              height: 39,
                                              width: 44,
                                              decoration: BoxDecoration(
                                                color: !isAmSelected2
                                                    ? AppColors.primaryColor
                                                    : Colors.transparent,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(8),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'PM',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: !isAmSelected2
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Icon(
                                      Icons.watch_later_outlined,
                                      size: 30,
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Checkbox(
                                    value: isAllDay,
                                    side:
                                        BorderSide(color: AppColors.whiteColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isAllDay = value ?? false;
                                      });
                                    },
                                    activeColor: Colors.white,
                                    checkColor: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'All Day',
                                  style: TextStyle(
                                    fontSize: Responsive.isMobile(context)
                                        ? 14
                                        : Responsive.isTablet(context)
                                            ? 16
                                            : 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Select Discount Type ',
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
                  SizedBox(height: 10),
                  SizedBox(
                    width: screenWidth * .3,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select discount type',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: generalDiscounts
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
                        value: selected_cuisne,
                        onChanged: (String? value) {
                          setState(() {
                            selected_cuisne = value;
                            _isDiscountListVisible = true;
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
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Add Menu ',
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
                  SizedBox(height: 10),
                  Container(
                    height: 238,
                    child: Obx(
                          () => ListView.builder(
                        itemCount: itemController.items.length + 1, // Add 1 for the "Add Meal" button
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if (index < itemController.items.length) {
                            final item = itemController.items[index];
                            return Container(
                              width: 211,
                              height: 238,
                              margin: EdgeInsets.only(right: 8), // Spacing between items
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.whiteColor,
                                border: Border.all(
                                  color: AppColors.darkGrey.withOpacity(.1),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Image at the top
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: (item['images'] as List<XFile>).isNotEmpty
                                        ? Image.network(
                                      (item['images'] as List<XFile>).first.path,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                        : SizedBox.shrink(), // Placeholder if no image
                                  ),
                                  // Meal Info
                                  Positioned(
                                    bottom: 20,
                                    left: 8,
                                    right: 8,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Cuisine: ${item['description']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Menu: ${item['name']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Offer: 2 for 1',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Close Icon
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        itemController.items.removeAt(index); // Remove item
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: AppColors.darkGrey,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Add Meal Button at the end
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isColumn2Visible = !_isColumn2Visible;
                                    });// Example function
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        color: AppColors.primaryColor,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Add meal',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  if (_isColumn2Visible)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cuisine',
                          style: TextStyle(
                            fontSize: Responsive.isMobile(context)
                                ? 16
                                : Responsive.isTablet(context)
                                    ? 18
                                    : 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10),
                        Visibility(
                          visible: selected_cuisne3 == 'other',
                          child: Row(
                            children: [
                              CustomTextField(
                                  borderColor:
                                      AppColors.darkGrey.withOpacity(.1),
                                  controller: customCuisineController,
                                  width: 500,
                                  borderRadius: 8,
                                  hintText: "Type",
                                  fillColor: AppColors.whiteColor,
                                  cursorColor: AppColors.primaryColor,
                                  inputStyle: const TextStyle(
                                      color: AppColors.blackColor),
                                  hintStyle: const TextStyle(
                                      color: AppColors.blackColor),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (customCuisineController
                                              .text.isNotEmpty) {
                                            // Add the custom cuisine to the list
                                            cuisine.insert(cuisine.length - 1,
                                                customCuisineController.text);
                                            // Set it as the selected cuisine
                                            selected_cuisne3 =
                                                customCuisineController.text;
                                            showTextField = false;
                                            customCuisineController.clear();
                                          }
                                        });
                                      },
                                      icon:
                                          Icon(Icons.add, color: Colors.white),
                                      iconSize: 18,
                                      splashRadius: 20,
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppColors.primaryColor),
                                        shape: MaterialStateProperty.all<
                                            CircleBorder>(
                                          CircleBorder(),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: selected_cuisne3 != 'other',
                          child: SizedBox(
                            width: Responsive.isDesktop(context)
                                ? screenWidth * .27
                                : double.infinity,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                // isExpanded: true,
                                hint: Text(
                                  'Select Cuisine',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: cuisine
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
                                value: selected_cuisne3,
                                onChanged: (String? value) {
                                  setState(() {
                                    selected_cuisne3 = value;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.darkGrey.withOpacity(.1),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        8), // Rounded corners
                                    color: AppColors.whiteColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  height: 40,
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
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Menu Type',
                          style: TextStyle(
                            fontSize: Responsive.isMobile(context)
                                ? 16
                                : Responsive.isTablet(context)
                                    ? 18
                                    : 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: Responsive.isDesktop(context)
                              ? screenWidth * .27
                              : double.infinity,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              // isExpanded: true,
                              hint: Text(
                                'Select Menu Type',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: menuType
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                  .toList(),
                              value: selected_menuType,
                              onChanged: (String? value) {
                                setState(() {
                                  selected_menuType = value;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.darkGrey.withOpacity(.1),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                  color: AppColors.whiteColor,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
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
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Image',
                          style: TextStyle(
                            fontSize: Responsive.isMobile(context)
                                ? 16
                                : Responsive.isTablet(context)
                                    ? 18
                                    : 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Obx(
                                  () => Wrap(
                                spacing: 8,
                                children: itemController.images.map((image) {
                                  return Stack(
                                    clipBehavior: Clip
                                        .none, // Allows the cross icon to overflow if needed
                                    children: [
                                      // Circular Image with Border
                                      Container(
                                        width: Responsive.isDesktop(context)
                                            ? 160
                                            : 120, // Adjust the size as needed
                                        height:
                                        Responsive.isDesktop(context) ? 150 : 110,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Image.network(
                                          image.path,
                                          // width: 80,
                                          // height: 80,
                                          fit: BoxFit.cover,
                                        ),/*Image.asset(
                                          'assets/images/img3.png',
                                          fit: BoxFit
                                              .cover, // Ensures the image fits within the circular container
                                        ),*/
                                      ),

                                      // Close Icon in Top Right
                                      Positioned(
                                        top: 8, // Adjust position as needed
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () {
                                            itemController.images.remove(image);
                                          },
                                          child: Container(
                                            width: 19,
                                            height: 19,
                                            decoration: BoxDecoration(
                                              color: AppColors.darkGrey,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
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
                                  onTap: () => itemController.pickImages(),
                                  child: _imageBytes == null
                                      ? Container(
                                          height: Responsive.isDesktop(context)
                                              ? 150
                                              : Responsive.isTablet(context)
                                                  ? 120
                                                  : 110,
                                          width: 160,
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
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: AppColors.whiteColor,
                                                ),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .upload_file_outlined,
                                                          size: 25,
                                                          color: AppColors
                                                              .primaryColor),
                                                      Text(
                                                        'Upload Image',
                                                        style: TextStyle(
                                                          fontSize: Responsive
                                                                  .isMobile(context)
                                                              ? 7
                                                              : (Responsive
                                                                      .isTablet(
                                                                          context)
                                                                  ? 8
                                                                  : 10),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Upload a .png file only',
                                                        style: TextStyle(
                                                          fontSize: Responsive
                                                                  .isMobile(context)
                                                              ? 7
                                                              : (Responsive
                                                                      .isTablet(
                                                                          context)
                                                                  ? 8
                                                                  : 10),
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
                                          height: Responsive.isDesktop(context)
                                              ? 150
                                              : Responsive.isTablet(context)
                                                  ? 120
                                                  : 110,
                                          width: 160,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: MemoryImage(_imageBytes!),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                ),

                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Offer',
                          style: TextStyle(
                            fontSize: Responsive.isMobile(context)
                                ? 16
                                : Responsive.isTablet(context)
                                    ? 18
                                    : 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          borderColor: AppColors.darkGrey.withOpacity(.1),
                          width: 516,
                          borderRadius: 8,
                          hintText: "2 for 1",
                          controller: itemController.offerController,
                          fillColor: AppColors.whiteColor,
                          cursorColor: AppColors.primaryColor,
                          inputStyle:
                              const TextStyle(color: AppColors.blackColor),
                          hintStyle:
                              const TextStyle(color: AppColors.blackColor),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 100.0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  itemController.addItem(
                                    selected_menuType.toString(),
                                    selected_cuisne3.toString(),
                                    itemController.offerController.text,
                                  );
                                  selected_menuType = null;
                                  selected_cuisne3 = null;
                                  itemController.offerController.clear();
                                  // descriptionController.clear();
                                  // priceController.clear();
                                },
                                child: const Text('Add Item'),
                              ),
                              CustomButton(
                                title: "Save Percentage Value",
                                textStyle: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: Responsive.isMobile(context) ? 16 : 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                backgroundColor: AppColors.primaryColor,
                                borderRadius: 8,
                                width: Responsive.isMobile(context)
                                    ? screenWidth * 0.4
                                    : screenWidth * 0.2,
                                onPressed: () {
                                  Get.snackbar("Percentage Value ",
                                      "Percentage value is successfully saved",
                                      maxWidth: 400,
                                      backgroundColor: AppColors.primaryColor);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  SizedBox(height: 20),
                  Center(
                    child: CustomButton(
                      title: " Save Discount",
                      textStyle: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: Responsive.isMobile(context) ? 16 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: AppColors.primaryColor,
                      borderRadius: 8,
                      width: Responsive.isMobile(context)
                          ? screenWidth * 0.4
                          : screenWidth * 0.2,
                      onPressed: () {
                        FirebaseFirestore.instance.collection("Testing").add({
                          "MenuDiscount": itemController.items,
                          "age": 50,
                        });
                        // Get.snackbar(
                        //     "Discount", "Discount is successfully saved",
                        //     maxWidth: 400,
                        //     backgroundColor: AppColors.primaryColor);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        title: "Done",
                        borderClr: AppColors.primaryColor,
                        textStyle: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: Responsive.isMobile(context) ? 16 : 18,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: AppColors.whiteColor,
                        borderRadius: 8,
                        width: Responsive.isMobile(context)
                            ? screenWidth * 0.4
                            : screenWidth * 0.2,
                        onPressed: () {
                          showDoneDialog(context);
                          // print('hy');
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

showDoneDialog(BuildContext context) {
  Get.dialog(
    WillPopScope(
      onWillPop: () async =>
          false, // Prevent dialog from being dismissed on back press
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Center(
          child: Container(
            width: Get.width * 0.6, // Increased width for larger screens
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/tick_image.png', // Path to your image
                  width: Get.width * .15, // Optional: Set width
                  height: Get.height * .15, // Optional: Set height
                  // Optional: Adjust image fitting
                ),
                const SizedBox(height: 20),
                Text(
                  'Congratulations you have successfully add restaurants details',
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context)
                        ? 12
                        : 16, // Adjusted font size
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                    color: AppColors.blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Material(
                  color: Colors.transparent,
                  child: CustomButton(
                    title: "Okay",
                    textStyle: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: Responsive.isMobile(context) ? 12 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: AppColors.primaryColor,
                    borderRadius: 8,
                    width: Responsive.isMobile(context)
                        ? 80
                        : 100, // Responsive button width
                    height:
                        40, // Adjusted button height for better clickability
                    onPressed: () {
                      Get.to(() => RestaurantDetailScreen(
                            isFromButtonClick: true,
                          )); // Close the dialog
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
