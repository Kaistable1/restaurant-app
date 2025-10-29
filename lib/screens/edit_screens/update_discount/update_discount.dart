import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/main.dart';
import 'package:restaurant_web_app/utils/responsive.dart';
import 'package:restaurant_web_app/widgets/account_settings_popup_widget.dart';
import 'package:restaurant_web_app/widgets/global_functions.dart';

import '../../../../widgets/round_button.dart';
import '../../../../widgets/text_field.dart';
import '../../../universal_models/discount_model.dart';
import '../../add_restaurant/edit_restaurant/edit_restaurant_controller/edit_restaurant_controller.dart';
import '../../main_screen/mainscreen_controller/main_controller.dart';
import '../../restaurant_detail_screen/restaurant_detail_screen.dart';
import '../../restaurant_detail_screen/widget/star_widget_gen_discount.dart';

class UpdateDiscount extends StatelessWidget {
  final Function(int)? onNavigate;

  final mainController = Get.put(MainController());

  UpdateDiscount(
      {super.key,
      this.onNavigate,
      this.isFromButtonClick,
      required this.discountModel,
      required this.docID});
  bool? isFromButtonClick;
  bool isChecked = false;
  final String docID;
  final DiscountModel discountModel;

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
                          offset: const Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AccountSettingsPopupWidget()),
                  ),
                ),
              ],
            ),
      body: DiscountTimeSetup(
        docID: docID,
        discountModel: discountModel,
      ),
    );
  }
}

class DiscountTimeSetup extends StatefulWidget {
  final String docID;
  final DiscountModel discountModel;
  const DiscountTimeSetup({
    Key? key,
    required this.docID,
    required this.discountModel,
  }) : super(key: key);
  @override
  _DiscountTimeSetupState createState() => _DiscountTimeSetupState();
}

class _DiscountTimeSetupState extends State<DiscountTimeSetup> {
  final Rxn<int> selectedStarIndex = Rxn<int>(); // Use Rxn<int> to allow null
  String? selected_generalDiscounts;
  final controller = Get.put(EditRestaurantController());
  String? selected_cuisne1;
  String? selected_cuisne3;
  // String? selected_menuType;

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
    'Soul food',
    'Southern food',
    'Cajun & Creole',
    'Barbecue',
    'Diner / Comfort Food',
    'Jamaican',
    'Fusion',
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
    ///assigning variables
    _dateController.text = widget.discountModel.fromDate;
    _dateControllerTo.text = widget.discountModel.toDate;
    controller.selected_cuisne = widget.discountModel.discountType;
    // isChecked = widget.discountModel.menu.first.lifeTime;
    // isAllDay = widget.discountModel.menu.first.isAllDay;
    // fromTime =  widget.discountModel.menu.first.fromTime ?? '';
    // toTime =  widget.discountModel.menu.first.toTime ?? '';
    // itemController.selected_cuisne =  widget.discountModel.menu.first.discountType ?? '';
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
                const SizedBox(
                  width: 10,
                ),
                // Title
                Text(
                  widget.discountModel.discountType,
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
                        child: Image.network(
                          widget.discountModel.menu[0].items[0].itemImages
                                  .isNotEmpty
                              ? widget.discountModel.menu[0].items[0]
                                  .itemImages[0].value
                              : '', // Empty string to trigger errorBuilder
                          width: double.infinity,
                          height: Responsive.isMobile(context)
                              ? 95
                              : (Responsive.isTablet(context) ? 120 : 140),
                          fit: BoxFit.fitHeight,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: Responsive.isMobile(context)
                                  ? 100
                                  : (Responsive.isTablet(context) ? 120 : 140),
                              color: Colors
                                  .grey[300], // Placeholder background color
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.grey[600]),
                            );
                          },
                        ),
                      ),
                      // Cross Icon at the top right corner

                      // Plus Icon at the bottom right corner

                      // Meal Info below the image
                      Positioned(
                        top: 8,
                        right: 12,
                        child: GestureDetector(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection('restaurants')
                                .doc(auth.currentUser!.uid)
                                .collection('MealMenu')
                                .doc(widget.docID)
                                .delete()
                                .then((value) {
                              print('done');
                              Get.back();
                            }).onError((error, stackTrace) {
                              print('error');
                            });
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 10),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 5,
                        left: 8,
                        right: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.discountModel.discountType,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(
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
                                itemCount: widget.discountModel.menu.length,
                                itemBuilder: (context, index) {
                                  CategoryModel menuModel =
                                      widget.discountModel.menu[index];
                                  return SizedBox(
                                    width: Responsive.isMobile(context)
                                        ? 40
                                        : Responsive.isDesktop(context)
                                            ? 60
                                            : 50, // Width of each item
                                    child: LocationStarWidget(
                                      timeText:
                                          '${menuModel.fromTime} - ${menuModel.toTime}',
                                      persentText:
                                          '${menuModel.percentageValue}% OFF',
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
                                      isSelected: false,
                                      onTap: () {},
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
                        right: 30,
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
                                      widget.discountModel.fromDate == '' &&
                                              widget.discountModel.toDate == ''
                                          ? '  Lifetime  '
                                          : '${formatDate(widget.discountModel.fromDate)} - ${formatDate(widget.discountModel.toDate)}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //     top: 0,
                      //     right: 8,
                      //     bottom: 2,
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Image.asset(
                      //         'assets/images/btn_image.png',
                      //         width: 24,
                      //         height: 24,
                      //       ),
                      //     )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Conditional Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
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
                          const SizedBox(
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
                                    hintText: "09.03.2024",
                                    fillColor: AppColors.whiteColor,
                                    cursorColor: AppColors.primaryColor,
                                    inputStyle: const TextStyle(
                                        color: AppColors.blackColor),
                                    hintStyle: const TextStyle(
                                        color: AppColors.blackColor),
                                  ),
                                  const SizedBox(
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
                          const SizedBox(
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
                          const SizedBox(
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
                                    hintText: "09.03.2024",
                                    fillColor: AppColors.whiteColor,
                                    cursorColor: AppColors.primaryColor,
                                    inputStyle: const TextStyle(
                                        color: AppColors.blackColor),
                                    hintStyle: const TextStyle(
                                        color: AppColors.blackColor),
                                  ),
                                  const SizedBox(
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
                          const SizedBox(
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
                                  const BorderSide(color: AppColors.whiteColor),
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
                          const SizedBox(width: 10),
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
                              const SizedBox(
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
                                        hintText: "09.03.2024",
                                        fillColor: AppColors.whiteColor,
                                        cursorColor: AppColors.primaryColor,
                                        inputStyle: const TextStyle(
                                            color: AppColors.blackColor),
                                        hintStyle: const TextStyle(
                                            color: AppColors.blackColor),
                                      ),
                                      const SizedBox(
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
                          const SizedBox(
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
                              const SizedBox(
                                width: 28,
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
                                        hintText: "09.03.2024",
                                        fillColor: AppColors.whiteColor,
                                        cursorColor: AppColors.primaryColor,
                                        inputStyle: const TextStyle(
                                            color: AppColors.blackColor),
                                        hintStyle: const TextStyle(
                                            color: AppColors.blackColor),
                                      ),
                                      const SizedBox(
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
                              const SizedBox(
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
                                  side: const BorderSide(
                                      color: AppColors.whiteColor),
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
                              const SizedBox(width: 10),
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

                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
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
                      value: controller.selected_cuisne,
                      onChanged: (String? value) {
                        setState(() {
                          controller.selected_cuisne = value;
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
                ),
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
                const SizedBox(height: 10),

                Row(
                  children: [
                    Wrap(
                      spacing: 10,
                      children: List.generate(widget.discountModel.menu.length,
                          (index) {
                        final menuItem = widget.discountModel.menu[index];
                        return Obx(
                          () {
                            return LocationStarWidget(
                              timeTextStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Responsive.isMobile(context)
                                    ? 6
                                    : Responsive.isTablet(context)
                                        ? 8
                                        : 10,
                                fontFamily: 'Nunito-Regular',
                              ),
                              persentTextStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Responsive.isMobile(context)
                                    ? 6
                                    : Responsive.isTablet(context)
                                        ? 8
                                        : 10,
                                fontFamily: 'Nunito-Regular',
                              ),
                              timeText:
                                  '${menuItem.fromTime} to ${menuItem.toTime}',
                              persentText: '${menuItem.percentageValue}% off',
                              isSelected: selectedStarIndex.value == index,
                              onTap: () {
                                print(selectedStarIndex.value);
                                selectedStarIndex.value =
                                    index; // Update selected
                              },
                            );
                          },
                        );
                      }),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            // ✅ Create a new category and add it to `menu`
                            // widget.discountModel.menu.add(CategoryModel(
                            //   fromDate: _dateController.text,
                            //   toDate: _dateControllerTo.text,
                            //   percentageValue: _selectedDiscount.toString(),
                            //   fromTime: "${controller.fromTimeHourController.text}:${controller.fromTimeMintController.text} ${isAmSelected ? 'AM' : 'PM'}",
                            //   toTime: "${controller.toTimeHourController.text}:${controller.toTimeMintController.text} ${isAmSelected ? 'AM' : 'PM'}",
                            //   discountType: controller.selected_cuisne ?? '',
                            //   toTimeType: isAmSelected2 == true ? "AM" : "PM",
                            //   lifeTime: isChecked,
                            //   isAllDay: isAllDay,
                            //   items: [], // Start with an empty list of items
                            // ));

                            // ✅ Update `selectedStarIndex` to point to the newly added category
                            // selectedStarIndex.value =  widget. discountModel.menu.length + 1;
                            selectedStarIndex.value = null;
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
                            child: const Center(
                              child: Icon(Icons.add,
                                  color: AppColors.primaryColor, size: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
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
                const SizedBox(height: 10),

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
                                  hint: const Text(
                                    "Select Percentage Value",
                                    style: TextStyle(
                                        color: Colors.grey), // Hint text style
                                  ),
                                  value: _selectedDiscount,
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      _selectedDiscount = newValue;
                                    });
                                  },
                                  items: [10, 20, 30]
                                      .map<DropdownMenuItem<int>>((int value) {
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
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons
                                          .keyboard_arrow_down_outlined, // Custom dropdown icon
                                      color:
                                          AppColors.primaryColor, // Icon color
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
                const SizedBox(height: 10),

                //////star and its details widget
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: widget.discountModel.menu.map<Widget>((menuItem) {
                //           return Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //
                //               // Star List (Selectable)
                //               Wrap(
                //                 spacing: 10,
                //                 children: List.generate(widget.discountModel.menu.length, (index) {
                //                   final menuItem = widget.discountModel.menu[index];
                //                   return GestureDetector(
                //                     onTap: () {
                //                       setState(() {
                //                         selectedStarIndex = index; // Update selected star
                //                       });
                //                     },
                //                     child: LocationStarWidget(
                //                       timeText: '${menuItem.fromTime} to ${menuItem.toTime}',
                //                       persentText: '${menuItem.percentageValue}% off',
                //                     ),
                //                   );
                //                 }),
                //               ),
                //               // LocationStarWidget(
                //               //   timeText: '${menuItem.fromTime} to ${menuItem.toTime}',
                //               //   persentText: '${menuItem.percentageValue}% off',
                //               // ),
                //               const SizedBox(height: 10),
                //               // Wrap details in a Row instead of a Column
                //               Row(
                //                 children: [
                //                   SingleChildScrollView(
                //                     scrollDirection: Axis.horizontal,
                //                     child: Row(
                //                       children: menuItem.items.map<Widget>((item) {
                //                         return Padding(
                //                           padding: const EdgeInsets.only(right: 10),
                //                           child: Row(
                //                             children: [
                //                               StarDetailsWidget(
                //                                 imageUrl: item.itemImages[0].value,
                //                                 cuisine: item.cuisineName,
                //                                 menu: item.cuisineMenu,
                //                                 offer: item.offer,
                //                                 onRemove: () {},
                //                               ),
                //
                //
                //                             ],
                //                           ),
                //                         );
                //                       }).toList(),
                //                     ),
                //                   ),
                //                   Column(
                //                     children: [
                //                       InkWell(
                //                         onTap: () {
                //                           // Handle Add Meal Click
                //                         },
                //                         child: Container(
                //                           width: 24,
                //                           height: 24,
                //                           decoration: BoxDecoration(
                //                             border: Border.all(color: Colors.blue, width: 2),
                //                             borderRadius: BorderRadius.circular(4.0),
                //                           ),
                //                           child: const Center(
                //                             child: Icon(Icons.add, color: Colors.blue, size: 16),
                //                           ),
                //                         ),
                //                       ),
                //                       const SizedBox(height: 10),
                //                       const Text(
                //                         'Add meal',
                //                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                //                       ),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           );
                //         }).toList(),
                //       ),
                //     ),
                //     const SizedBox(width: 10),
                //     Column(
                //       children: [
                //         InkWell(
                //           onTap: () {
                //             setState(() {
                //               _isColumn3Visible = !_isColumn3Visible;
                //             });
                //           },
                //           child: Container(
                //             width: 24,
                //             height: 24,
                //             decoration: BoxDecoration(
                //               border: Border.all(color: AppColors.primaryColor, width: 2),
                //               borderRadius: BorderRadius.circular(4.0),
                //             ),
                //             child: const Center(
                //               child: Icon(Icons.add, color: AppColors.primaryColor, size: 16),
                //             ),
                //           ),
                //         ),
                //         const SizedBox(height: 10),
                //         const Text(
                //           'Percentage Value',
                //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                //         ),
                //       ],
                //     ),
                //   ],
                // )
// ,
                // Star List (Selectable)

                const SizedBox(height: 20),

                ///to add new
                if (_isColumn3Visible)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const SizedBox(height: 10),
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
                                const SizedBox(width: 10),
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
                                          controller:
                                              controller.fromTimeHourController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    bottom: 10),
                                            hintText: '02',
                                            fillColor:
                                                Colors.grey.withOpacity(.4),
                                            filled: true,
                                            hintStyle: const TextStyle(
                                                fontSize: 18,
                                                color: AppColors.whiteColor),
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                                2), // Restrict to 2 digits
                                          ],
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                              int? intValue =
                                                  int.tryParse(value);
                                              if (intValue != null &&
                                                  (intValue < 1 ||
                                                      intValue > 24)) {
                                                controller
                                                        .fromTimeHourController
                                                        .text =
                                                    ''; // Clear the field if the value is invalid
                                              }
                                            }
                                          },
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    // Colon Separator
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4),
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
                                          controller:
                                              controller.fromTimeMintController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    bottom: 10),
                                            hintText: '25',
                                            fillColor:
                                                Colors.grey.withOpacity(.4),
                                            filled: true,
                                            hintStyle: const TextStyle(
                                                fontSize: 18,
                                                color: AppColors.whiteColor),
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                                2), // Restrict to 2 digits
                                          ],
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                              int? intValue =
                                                  int.tryParse(value);
                                              if (intValue != null &&
                                                  (intValue < 1 ||
                                                      intValue > 60)) {
                                                controller
                                                        .fromTimeMintController
                                                        .text =
                                                    ''; // Clear the field if the value is invalid
                                              }
                                            }
                                          },
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
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
                                                borderRadius:
                                                    const BorderRadius.only(
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
                                                borderRadius:
                                                    const BorderRadius.only(
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
                                    const SizedBox(width: 12),
                                    const Icon(
                                      Icons.watch_later_outlined,
                                      size: 30,
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
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
                                const SizedBox(width: 10),
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
                                          controller:
                                              controller.toTimeHourController,
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                              int? intValue =
                                                  int.tryParse(value);
                                              if (intValue != null &&
                                                  (intValue < 1 ||
                                                      intValue > 24)) {
                                                controller.toTimeHourController
                                                        .text =
                                                    ''; // Clear the field if the value is invalid
                                              }
                                            }
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    bottom: 10),
                                            hintText: '03',
                                            fillColor:
                                                Colors.grey.withOpacity(.4),
                                            filled: true,
                                            hintStyle: const TextStyle(
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
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    // Colon Separator
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4),
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
                                          controller:
                                              controller.toTimeMintController,
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                              int? intValue =
                                                  int.tryParse(value);
                                              if (intValue != null &&
                                                  (intValue < 1 ||
                                                      intValue > 60)) {
                                                controller.toTimeMintController
                                                        .text =
                                                    ''; // Clear the field if the value is invalid
                                              }
                                            }
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    bottom: 10),
                                            hintText: '56',
                                            fillColor:
                                                Colors.grey.withOpacity(.4),
                                            filled: true,
                                            hintStyle: const TextStyle(
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
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
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
                                                borderRadius:
                                                    const BorderRadius.only(
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
                                                borderRadius:
                                                    const BorderRadius.only(
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
                                    const SizedBox(width: 12),
                                    const Icon(
                                      Icons.watch_later_outlined,
                                      size: 30,
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(
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
                                    side: const BorderSide(
                                        color: AppColors.whiteColor),
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
                                const SizedBox(width: 10),
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
                                    const SizedBox(width: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Hour Input
                                        Container(
                                          width: 44,
                                          height: 39,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade400,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Center(
                                            child: TextField(
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        bottom: 10),
                                                hintText: '02',
                                                fillColor:
                                                    Colors.grey.withOpacity(.4),
                                                filled: true,
                                                hintStyle: const TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        AppColors.whiteColor),
                                              ),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    2), // Restrict to 2 digits
                                              ],
                                              textAlign: TextAlign.center,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        // Colon Separator
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
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
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Center(
                                            child: TextField(
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        bottom: 10),
                                                hintText: '25',
                                                fillColor:
                                                    Colors.grey.withOpacity(.4),
                                                filled: true,
                                                hintStyle: const TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        AppColors.whiteColor),
                                              ),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    2), // Restrict to 2 digits
                                              ],
                                              textAlign: TextAlign.center,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // AM/PM Toggle
                                        Container(
                                          height: 39,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8),
                                                      bottomLeft:
                                                          Radius.circular(8),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'AM',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(8),
                                                      bottomRight:
                                                          Radius.circular(8),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'PM',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                        const SizedBox(width: 12),
                                        const Icon(
                                          Icons.watch_later_outlined,
                                          size: 30,
                                          color: AppColors.primaryColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
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
                                    const SizedBox(width: 28),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Hour Input
                                        Container(
                                          width: 44,
                                          height: 39,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade400,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Center(
                                            child: TextField(
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        bottom: 10),
                                                hintText: '03',
                                                fillColor:
                                                    Colors.grey.withOpacity(.4),
                                                filled: true,
                                                hintStyle: const TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        AppColors.whiteColor),
                                              ),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    2), // Restrict to 2 digits
                                              ],
                                              textAlign: TextAlign.center,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        // Colon Separator
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
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
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Center(
                                            child: TextField(
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        bottom: 10),
                                                hintText: '56',
                                                fillColor:
                                                    Colors.grey.withOpacity(.4),
                                                filled: true,
                                                hintStyle: const TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        AppColors.whiteColor),
                                              ),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    2), // Restrict to 2 digits
                                              ],
                                              textAlign: TextAlign.center,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // AM/PM Toggle
                                        Container(
                                          height: 39,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8),
                                                      bottomLeft:
                                                          Radius.circular(8),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'AM',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(8),
                                                      bottomRight:
                                                          Radius.circular(8),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'PM',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                        const SizedBox(width: 12),
                                        const Icon(
                                          Icons.watch_later_outlined,
                                          size: 30,
                                          color: AppColors.primaryColor,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.primaryColor,
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Checkbox(
                                        value: isAllDay,
                                        side: const BorderSide(
                                            color: AppColors.whiteColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
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
                                    const SizedBox(width: 10),
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
                    ],
                  ),
                const SizedBox(height: 10),
                // Display Details of Selected Star
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                Obx(
                  () => selectedStarIndex.value != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: widget.discountModel
                                        .menu[selectedStarIndex.value!].items
                                        .map<Widget>((item) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: StarDetailsWidget(
                                          imageBytes:
                                              (item.itemMemoryImages.isNotEmpty)
                                                  ? item.itemMemoryImages[0]
                                                  : null,
                                          imageUrl: item.itemImages[0].value,
                                          cuisine: item.cuisineName,
                                          menu: item.cuisineMenu,
                                          offer: item.offer,
                                          onRemove: () {
                                            setState(() {
                                              widget
                                                  .discountModel
                                                  .menu[
                                                      selectedStarIndex.value!]
                                                  .items
                                                  .remove(item);
                                            });
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isColumn2Visible =
                                              !_isColumn2Visible;
                                        });
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blue, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.add,
                                              color: Colors.blue, size: 16),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Add meal',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Add Meal Button
                          ],
                        )
                      : controller.items.isNotEmpty
                          ? Container(
                              height: 238,
                              child: Obx(
                                () => ListView.builder(
                                  itemCount: controller.items.length +
                                      1, // Add 1 for the "Add Meal" button
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    if (index < controller.items.length) {
                                      final item = controller.items[index];
                                      return Container(
                                        width: 211,
                                        height: 238,
                                        margin: const EdgeInsets.only(
                                            right: 8), // Spacing between items
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColors.whiteColor,
                                          border: Border.all(
                                            color: AppColors.darkGrey
                                                .withOpacity(.1),
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            // Image at the top
                                            Container(
                                              width: 211,
                                              height: 150,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: item.itemMemoryImages
                                                        .first.isNotEmpty
                                                    ? Image.memory(
                                                        item.itemMemoryImages
                                                            .first,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : const SizedBox
                                                        .shrink(), // Placeholder if no image
                                              ),
                                            ),
                                            // Meal Info
                                            Positioned(
                                              bottom: 20,
                                              left: 8,
                                              right: 8,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Cuisine: ${item.cuisineName}',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .textColor),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Menu: ${item.cuisineMenu}',
                                                    style: const TextStyle(
                                                      color:
                                                          AppColors.textColor,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Offer: ${item.offer}',
                                                    style: const TextStyle(
                                                      color:
                                                          AppColors.textColor,
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
                                                  controller.items.removeAt(
                                                      index); // Remove item
                                                },
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColors.darkGrey,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
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
                                                _isColumn2Visible =
                                                    !_isColumn2Visible;
                                              }); // Example function
                                            },
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColors.primaryColor,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.add,
                                                  color: AppColors.primaryColor,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
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
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isColumn2Visible = !_isColumn2Visible;
                                    });
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.primaryColor,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.add,
                                          color: AppColors.primaryColor,
                                          size: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Add menu',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                ),

                // Row(
                //   children: [
                //     Container(
                //       width: 211,
                //       height: 238,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         color: AppColors.whiteColor,
                //         border: Border.all(
                //             color: AppColors.darkGrey.withOpacity(.1)),
                //       ),
                //       child: Stack(
                //         children: [
                //           // Image at the top, take the full height of the container
                //           ClipRRect(
                //             borderRadius: BorderRadius.circular(10.0),
                //             child: Image.asset(
                //               'assets/images/p1.png', // Replace with your image asset
                //               width: 211, // Set width to match the container
                //               height:
                //                   150, // Set height to match the container
                //               fit: BoxFit
                //                   .cover, // Make sure the image covers the entire area
                //             ),
                //           ),
                //           // Cross Icon at the top right corner
                //
                //           // Plus Icon at the bottom right corner
                //
                //           // Meal Info below the image
                //           const Positioned(
                //             bottom: 20,
                //             left: 8,
                //             right: 8,
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text(
                //                   'Cuisine: Italian',
                //                   style: TextStyle(
                //                     fontSize: 14,
                //                   ),
                //                 ),
                //                 SizedBox(height: 4),
                //                 Text(
                //                   'Menu: Food/Drink Menu',
                //                   style: TextStyle(
                //                     fontSize: 14,
                //                   ),
                //                 ),
                //                 SizedBox(height: 4),
                //                 Text(
                //                   'Offer: 2 for 1',
                //                   style: TextStyle(
                //                     fontSize: 14,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           Positioned(
                //             top: 0,
                //             right: 8,
                //             child: Center(
                //               child: Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Container(
                //                   width: 20, // width of the circle
                //                   height: 20, // height of the circle
                //                   decoration: const BoxDecoration(
                //                     color: AppColors
                //                         .darkGrey, // background color
                //                     shape: BoxShape
                //                         .circle, // makes the container circular
                //                   ),
                //                   child: GestureDetector(
                //                     onTap: () {
                //                       onPressed:
                //                       _removeContainer;
                //                     },
                //                     child: const Icon(
                //                       Icons.close, // cross icon
                //                       color: Colors.white, // icon color
                //                       size:
                //                           10, // adjust icon size to fit the circle
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //           Positioned(
                //               top: 0,
                //               right: 8,
                //               bottom: 2,
                //               child: Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Image.asset(
                //                   'assets/images/btn_image.png',
                //                   width: 24,
                //                   height: 24,
                //                 ),
                //               )),
                //         ],
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 30,
                //     ),
                //     Column(
                //       children: [
                //         InkWell(
                //           onTap: () {
                //             setState(() {
                //               _isColumn2Visible = !_isColumn2Visible;
                //             });
                //           },
                //           child: Container(
                //             width: 24,
                //             height: 24,
                //             decoration: BoxDecoration(
                //               border: Border.all(
                //                   color: AppColors.primaryColor, width: 2),
                //               borderRadius: BorderRadius.circular(4.0),
                //             ),
                //             child: const Center(
                //               child: Icon(Icons.add,
                //                   color: AppColors.primaryColor, size: 16),
                //             ),
                //           ),
                //         ),
                //         const SizedBox(height: 10),
                //         const Text(
                //           'Add meal',
                //           style: TextStyle(
                //             fontSize: 16,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
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
                      const SizedBox(height: 10),
                      Visibility(
                        visible: selected_cuisne3 == 'other',
                        child: Row(
                          children: [
                            CustomTextField(
                                borderColor: AppColors.darkGrey.withOpacity(.1),
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
                                    icon: const Icon(Icons.add,
                                        color: Colors.white),
                                    iconSize: 18,
                                    splashRadius: 20,
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              AppColors.primaryColor),
                                      shape: MaterialStateProperty.all<
                                          CircleBorder>(
                                        const CircleBorder(),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
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
                        ),
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      SizedBox(
                        width: Responsive.isDesktop(context)
                            ? screenWidth * .27
                            : double.infinity,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            hint: Text(
                              'Select Menu Type',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: menuType.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            value:
                                menuType.contains(controller.selected_menuType)
                                    ? controller.selected_menuType
                                    : null, // ✅ Ensure valid value
                            onChanged: (String? value) {
                              setState(() {
                                controller.selected_menuType = value;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.darkGrey.withOpacity(.1)),
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                                color: AppColors.whiteColor,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              height: 40,
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
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Obx(
                            () => Wrap(
                              spacing: 8,
                              children: controller.memoryImages.map((image) {
                                return Stack(
                                  clipBehavior: Clip
                                      .none, // Allows the cross icon to overflow if needed
                                  children: [
                                    // Circular Image with Border
                                    Container(
                                      width: Responsive.isDesktop(context)
                                          ? 160
                                          : 120, // Adjust the size as needed
                                      height: Responsive.isDesktop(context)
                                          ? 150
                                          : 110,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Image.memory(
                                        image,
                                        // width: 80,
                                        // height: 80,
                                        fit: BoxFit.cover,
                                      ), /*Image.asset(
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
                                          controller.memoryImages.remove(image);
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
                                  // In the GestureDetector
                                  List<Uint8List> selectedImages =
                                      await getImages();
                                  controller.memoryImages
                                      .addAll(selectedImages);
                                },
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
                                              color:
                                                  Colors.grey.withOpacity(.1)),
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                        Icons
                                                            .upload_file_outlined,
                                                        size: 25,
                                                        color: AppColors
                                                            .primaryColor),
                                                    Text(
                                                      'Upload Image',
                                                      style: TextStyle(
                                                        fontSize: Responsive
                                                                .isMobile(
                                                                    context)
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
                                                                .isMobile(
                                                                    context)
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: controller.offerController,
                        borderColor: AppColors.darkGrey.withOpacity(.1),
                        width: 516,
                        borderRadius: 8,
                        hintText: "2 for 1",
                        fillColor: AppColors.whiteColor,
                        cursorColor: AppColors.primaryColor,
                        inputStyle:
                            const TextStyle(color: AppColors.blackColor),
                        hintStyle: const TextStyle(color: AppColors.blackColor),
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                          title: 'Add Menu',
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
                            // 🛑 If more than 2 items exist, prevent adding
                            if (controller.items.length >= 2) {
                              Get.snackbar(
                                "Limit Reached",
                                "You can only add 1 Food Menu and 1 Drinks Menu.",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: AppColors.primaryColor,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                              );
                              return;
                            }

                            // 🛑 Ensure selected_menuType, selected_cuisine3, and offer are filled
                            if (controller.selected_menuType == null ||
                                selected_cuisne3 == null ||
                                controller.offerController.text.isEmpty) {
                              Get.snackbar(
                                "Validation Error",
                                "Please fill Cuisine, Menu Type, Image, and Offer before adding the menu.",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: AppColors.primaryColor,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                              );
                              return;
                            }

                            // ✅ Check if "Food Menu" and "Drinks Menu" exist
                            bool hasFoodMenu = controller.items
                                .any((item) => item.cuisineMenu == "Food Menu");
                            bool hasDrinksMenu = controller.items.any(
                                (item) => item.cuisineMenu == "Drinks Menu");

                            // 🛑 Prevent adding duplicates
                            if ((hasFoodMenu &&
                                    controller.selected_menuType ==
                                        "Food Menu") ||
                                (hasDrinksMenu &&
                                    controller.selected_menuType ==
                                        "Drinks Menu")) {
                              Get.snackbar(
                                "Duplicate Entry",
                                "You can only add one Food Menu and one Drinks Menu.",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: AppColors.primaryColor,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                              );
                              return;
                            }

                            // ✅ If all conditions pass, add the item
                            controller.addItem(
                                selected_cuisne3.toString(),
                                selectedStarIndex.value == null
                                    ? 9
                                    : selectedStarIndex.value!,
                                widget.docID,
                                widget.discountModel);
                            // widget.discountModel
                            //     .menu[selectedStarIndex.value!].items
                            //     .add(ItemModel(
                            //   cuisineMenu:
                            //       controller.selected_menuType.toString(),
                            //   cuisineName: selected_cuisne3.toString(),
                            //   offer: controller.offerController.text,
                            //   itemImages: RxList<RxString>(),
                            //   itemMemoryImages: RxList<Uint8List>.from(
                            //       controller.memoryImages),
                            // ));
                            setState(() {
                              _isColumn2Visible = !_isColumn2Visible;
                            });
                          }),
                      const SizedBox(height: 10),
                    ],
                  ),

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 100.0),
                  child: CustomButton(
                    title: "Update Percentage Value",
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
                      final fromTime = isAllDay
                          ? 'All'
                          : '${controller.toTimeHourController.text}:${controller.toTimeMintController.text} ${isAmSelected ? 'AM' : 'PM'}';

                      final toTime = isAllDay
                          ? ' Day'
                          : '${controller.fromTimeHourController.text}:${controller.fromTimeMintController.text} ${isAmSelected ? 'AM' : 'PM'}';

                      // **Validation Logic**
                      if (!isAllDay &&
                          (controller.fromTimeHourController.text.isEmpty ||
                              controller.fromTimeMintController.text.isEmpty ||
                              controller.toTimeHourController.text.isEmpty ||
                              controller.toTimeMintController.text.isEmpty)) {
                        Get.snackbar(
                          "Validation Error",
                          "Please select a valid time range or check the 'All Day' option.",
                          backgroundColor: AppColors.primaryColor,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      // 🛑 If less than 2 items exist, prevent saving
                      if (controller.items.length < 2) {
                        Get.snackbar(
                          "Add More Items",
                          "Please add at least 2 menu items before saving.",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: AppColors.primaryColor,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                        return;
                      }

                      // 🛑 Ensure a discount is selected
                      if (_selectedDiscount == null) {
                        Get.snackbar(
                          "Discount Not Selected",
                          "Please select a percentage value before saving.",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: AppColors.primaryColor,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                        return;
                      }

                      if (controller.selected_cuisne == null) {
                        Get.snackbar(
                          "Discount Type not selected",
                          "Please select at least one discount type",
                          backgroundColor: AppColors.primaryColor,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // ✅ If all conditions pass, proceed with saving
                      controller.addCategoryAndSubcategory(
                        widget.discountModel,
                        _dateController.text,
                        _dateControllerTo.text,
                        fromDate: _dateController.text,
                        lifeTime: isChecked,
                        isAllDay: isAllDay,
                        toDate: _dateControllerTo.text,
                        percentageValue: _selectedDiscount.toString(),
                        FromTime: fromTime,
                        ToTime: toTime,
                        discountType: controller.selected_cuisne,
                        toTimeType: isAmSelected2 == true ? "AM" : "PM",
                      );
                      _selectedDiscount = null;
                    },
                    // Get.snackbar("Update ",
                    //     "Percentage value is successfully updated",
                    //     maxWidth: 400,
                    //     backgroundColor: AppColors.primaryColor);
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: CustomButton(
                    title: " Update Discount",
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
                      controller.updateDiscount(
                          widget.discountModel, widget.docID);
                      Get.snackbar(
                          "Update Discount", "Discount is successfully updated",
                          maxWidth: 400,
                          backgroundColor: AppColors.primaryColor);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     CustomButton(
                //       title: "Update",
                //       borderClr: AppColors.primaryColor,
                //       textStyle: TextStyle(
                //         color: AppColors.primaryColor,
                //         fontSize: Responsive.isMobile(context) ? 16 : 18,
                //         fontWeight: FontWeight.w600,
                //       ),
                //       backgroundColor: AppColors.whiteColor,
                //       borderRadius: 8,
                //       width: Responsive.isMobile(context)
                //           ? screenWidth * 0.4
                //           : screenWidth * 0.2,
                //       onPressed: () {
                //         showDoneDialog(context);
                //         // print('hy');
                //       },
                //     ),
                //   ],
                // ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                Text(
                  'Would you like to add another discount?',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: CustomButton(
                        title: "Yes",
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
                          Get.snackbar("Edit other Discount",
                              "Please edit another discount that you want",
                              maxWidth: 400,
                              duration: const Duration(seconds: 3),
                              backgroundColor: AppColors.primaryColor);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: CustomButton(
                        title: "No",
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
                          Get.snackbar("Update Discount",
                              "Discount is successfully updated",
                              maxWidth: 400,
                              backgroundColor: AppColors.primaryColor);
                          Get.to(() => RestaurantDetailScreen(
                                isFromButtonClick: true,
                              )); // Close the dialog
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class StarDetailsWidget extends StatelessWidget {
  final String cuisine;
  final String menu;
  final String offer;
  final String imageUrl;
  final VoidCallback onRemove;
  final Uint8List? imageBytes; // Add this line*

  const StarDetailsWidget({
    Key? key,
    required this.cuisine,
    required this.menu,
    required this.offer,
    required this.imageUrl,
    required this.onRemove,
    this.imageBytes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 211,
          height: 238,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(.1)),
          ),
          child: Stack(
            children: [
              // Display selected image
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  imageUrl, // Use selected image
                  width: 211,
                  height: 142,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.memory(
                      imageBytes!, // Use selected image
                      width: 211,
                      height: 150,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),

              // Meal Info below the image
              Positioned(
                bottom: 20,
                left: 8,
                right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cuisine: $cuisine',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Menu: $menu',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Offer: $offer',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Close Button
              Positioned(
                top: 0,
                right: 8,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 30),
      ],
    );
  }
}
