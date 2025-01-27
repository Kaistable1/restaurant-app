import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/screens/add_restaurant/add_resturant_controller/add_resturant%20_controller.dart';

import '../../../constants/colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/round_button.dart';
import '../../../widgets/text_field.dart';
import '../../facilities_screen/facilities_controller/facilities_controller.dart';
import '../../main_screen/mainscreen_controller/main_controller.dart';
import '../../restaurant_detail_screen/restaurant_detail_screen.dart';

class EditFacilitiesScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  final facilitiesController = Get.put(AddRestaurantController());
  final mainController = Get.put(MainController());

  EditFacilitiesScreen({super.key, this.onNavigate, this.isFromButtonClick});
  bool? isFromButtonClick;
  final TextEditingController facilitiesTextController =
      TextEditingController();
  final TextEditingController atmosphereTextController =
      TextEditingController();
  final TextEditingController dietaryTextController = TextEditingController();
  // final TextEditingController entertainmentTextController =
  //     TextEditingController();
  final TextEditingController priceRangeTextController =
      TextEditingController();
  final TextEditingController reservationTextController =
      TextEditingController();
  String? selectedFacility;
  String? selectedAtmosphere;
  String? selectedDietary;
  // String? selectedEntertainment;
  String? selectedPriceRange;
  String? selectedReservation;

  String? selected_social_media;

  final List<String> socialMedia = [
    'Tiktok',
    'Facebook',
    'Instagram',
    'Twitter',
    'Youtube',
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    bool isLargeScreen = screenWidth > 1600;

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
                                Get.close(2);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: SingleChildScrollView(
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
                      icon:
                          Icon(Icons.arrow_back, color: AppColors.primaryColor),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Edit Amenities',
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
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: isLargeScreen ? screenHeight * 1.8 : screenHeight * 2.7,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double maxWidth = constraints.maxWidth;
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        // maxWidth: 800,
                        minHeight: constraints.maxHeight, // Full screen height
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'Facilities/Service ',
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
                                    SizedBox(height: 10),
                                    Obx(() {
                                      return Column(
                                        children: facilitiesController
                                            .facilities
                                            .map((facility) {
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (facilitiesController
                                                          .facilitySelection
                                                          .contains(facility)) {
                                                        facilitiesController
                                                            .facilitySelection
                                                            .remove(facility);
                                                      } else {
                                                        facilitiesController
                                                            .facilitySelection
                                                            .add(facility);
                                                      }
                                                    },
                                                    child: Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: AppColors
                                                              .primaryColor,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        color: facilitiesController
                                                                .facilitySelection
                                                                .contains(
                                                                    facility)
                                                            ? AppColors
                                                                .primaryColor
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                      child: Icon(Icons.check,
                                                          size: 18,
                                                          color: AppColors
                                                              .whiteColor),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Flexible(
                                                    child: Text(
                                                      facility,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Nunito-Regular',
                                                        fontSize: Responsive
                                                                .isMobile(
                                                                    context)
                                                            ? 12
                                                            : Responsive
                                                                    .isTablet(
                                                                        context)
                                                                ? 14
                                                                : 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                color: AppColors.primaryColor,
                                                thickness: .2,
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      );
                                    }),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (facilitiesTextController
                                                .text.isNotEmpty) {
                                              facilitiesController.addFacility(
                                                  facilitiesTextController
                                                      .text);
                                              facilitiesTextController.clear();
                                            }
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.primaryColor,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Center(
                                              child: Icon(Icons.add,
                                                  color: AppColors.primaryColor,
                                                  size: 16),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        CustomTextField(
                                          inputFormatterslist: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(
                                                    r'[a-zA-Z]')), // Allow letters only
                                          ],
                                          borderColor: AppColors.darkGrey
                                              .withOpacity(.1),
                                          width: Responsive.isMobile(context)
                                              ? screenWidth * 0.28
                                              : screenWidth * 0.3,
                                          borderRadius: 8,
                                          controller: facilitiesTextController,
                                          hintText: "Add more",
                                          fillColor: AppColors.whiteColor,
                                          cursorColor: AppColors.primaryColor,
                                          inputStyle: const TextStyle(
                                              color: AppColors.blackColor),
                                          hintStyle: const TextStyle(
                                              color: AppColors.blackColor),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Dietary Preferences ',
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
                                    SizedBox(height: 10),
                                    Obx(() {
                                      return Column(
                                        children: facilitiesController.dietary
                                            .map((dietary) {
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (facilitiesController
                                                          .dietarySelection
                                                          .contains(dietary)) {
                                                        facilitiesController
                                                            .dietarySelection
                                                            .remove(dietary);
                                                      } else {
                                                        facilitiesController
                                                            .dietarySelection
                                                            .add(dietary);
                                                      }
                                                    },
                                                    child: Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: AppColors
                                                              .primaryColor,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        color: facilitiesController
                                                                .dietarySelection
                                                                .contains(
                                                                    dietary)
                                                            ? AppColors
                                                                .primaryColor
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                      child: Icon(Icons.check,
                                                          size: 18,
                                                          color: AppColors
                                                              .whiteColor),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Flexible(
                                                    child: Text(
                                                      dietary,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Nunito-Regular',
                                                        fontSize: Responsive
                                                                .isMobile(
                                                                    context)
                                                            ? 12
                                                            : Responsive
                                                                    .isTablet(
                                                                        context)
                                                                ? 14
                                                                : 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                color: AppColors.primaryColor,
                                                thickness: .2,
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      );
                                    }),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (dietaryTextController
                                                .text.isNotEmpty) {
                                              facilitiesController.adddietary(
                                                  dietaryTextController.text);
                                              dietaryTextController.clear();
                                            }
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.primaryColor,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Center(
                                              child: Icon(Icons.add,
                                                  color: AppColors.primaryColor,
                                                  size: 16),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        CustomTextField(
                                          inputFormatterslist: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(
                                                    r'[a-zA-Z]')), // Allow letters only
                                          ],
                                          borderColor: AppColors.darkGrey
                                              .withOpacity(.1),
                                          width: Responsive.isMobile(context)
                                              ? screenWidth * 0.28
                                              : screenWidth * 0.3,
                                          borderRadius: 8,
                                          controller: dietaryTextController,
                                          hintText: "Add more",
                                          fillColor: AppColors.whiteColor,
                                          cursorColor: AppColors.primaryColor,
                                          inputStyle: const TextStyle(
                                              color: AppColors.blackColor),
                                          hintStyle: const TextStyle(
                                              color: AppColors.blackColor),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Atmosphere ',
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
                                    SizedBox(height: 10),
                                    Obx(() {
                                      return Column(
                                        children: facilitiesController
                                            .atmosphere
                                            .map((atmosphere) {
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (facilitiesController
                                                          .atmosphereSelection
                                                          .contains(
                                                              atmosphere)) {
                                                        facilitiesController
                                                            .atmosphereSelection
                                                            .remove(atmosphere);
                                                      } else {
                                                        facilitiesController
                                                            .atmosphereSelection
                                                            .add(atmosphere);
                                                      }
                                                    },
                                                    child: Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: AppColors
                                                              .primaryColor,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        color: facilitiesController
                                                                .atmosphereSelection
                                                                .contains(
                                                                    atmosphere)
                                                            ? AppColors
                                                                .primaryColor
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                      child: Icon(Icons.check,
                                                          size: 18,
                                                          color: AppColors
                                                              .whiteColor),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Flexible(
                                                    child: Text(
                                                      atmosphere,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Nunito-Regular',
                                                        fontSize: Responsive
                                                                .isMobile(
                                                                    context)
                                                            ? 12
                                                            : Responsive
                                                                    .isTablet(
                                                                        context)
                                                                ? 14
                                                                : 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                color: AppColors.primaryColor,
                                                thickness: .2,
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      );
                                    }),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (atmosphereTextController
                                                .text.isNotEmpty) {
                                              facilitiesController
                                                  .addAtmosphere(
                                                      atmosphereTextController
                                                          .text);
                                              atmosphereTextController.clear();
                                            }
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.primaryColor,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Center(
                                              child: Icon(Icons.add,
                                                  color: AppColors.primaryColor,
                                                  size: 16),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        CustomTextField(
                                          inputFormatterslist: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(
                                                    r'[a-zA-Z]')), // Allow letters only
                                          ],
                                          borderColor: AppColors.darkGrey
                                              .withOpacity(.1),
                                          width: Responsive.isMobile(context)
                                              ? screenWidth * 0.28
                                              : screenWidth * 0.3,
                                          borderRadius: 8,
                                          controller: atmosphereTextController,
                                          hintText: "Add more",
                                          fillColor: AppColors.whiteColor,
                                          cursorColor: AppColors.primaryColor,
                                          inputStyle: const TextStyle(
                                              color: AppColors.blackColor),
                                          hintStyle: const TextStyle(
                                              color: AppColors.blackColor),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Price Range ',
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
                                    SizedBox(height: 10),
                                    Obx(() {
                                      return Column(
                                        children: facilitiesController
                                            .pricerange
                                            .map((pricerange) {
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      facilitiesController
                                                          .selectPriceRange(
                                                              pricerange);
                                                    },
                                                    child: Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: AppColors
                                                              .primaryColor,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        color: facilitiesController
                                                                    .selectedPriceRange
                                                                    .value ==
                                                                pricerange
                                                            ? AppColors
                                                                .primaryColor
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                      child: facilitiesController
                                                                  .selectedPriceRange
                                                                  .value ==
                                                              pricerange
                                                          ? Icon(Icons.check,
                                                              size: 18,
                                                              color: AppColors
                                                                  .whiteColor)
                                                          : null,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Flexible(
                                                    child: Text(
                                                      pricerange,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Nunito-Regular',
                                                        fontSize: Responsive
                                                                .isMobile(
                                                                    context)
                                                            ? 12
                                                            : Responsive
                                                                    .isTablet(
                                                                        context)
                                                                ? 14
                                                                : 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                color: AppColors.primaryColor,
                                                thickness: .2,
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      );
                                    }),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (priceRangeTextController
                                                .text.isNotEmpty) {
                                              facilitiesController
                                                  .addPriceRange(
                                                      priceRangeTextController
                                                          .text);
                                              priceRangeTextController.clear();
                                            }
                                          },
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.primaryColor,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Center(
                                              child: Icon(Icons.add,
                                                  color: AppColors.primaryColor,
                                                  size: 16),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        CustomTextField(
                                          inputFormatterslist: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(
                                                    r'[0-9!@#$%^&*(),.?":{}|<>]')),
                                          ],
                                          borderColor: AppColors.darkGrey
                                              .withOpacity(.1),
                                          width: Responsive.isMobile(context)
                                              ? screenWidth * 0.28
                                              : screenWidth * 0.3,
                                          borderRadius: 8,
                                          controller: priceRangeTextController,
                                          hintText: "Add more",
                                          fillColor: AppColors.whiteColor,
                                          cursorColor: AppColors.primaryColor,
                                          inputStyle: const TextStyle(
                                              color: AppColors.blackColor),
                                          hintStyle: const TextStyle(
                                              color: AppColors.blackColor),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Specials Conditions',
                                        style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontFamily: 'Nunito-Regular',
                                          fontSize: Responsive.isMobile(context)
                                              ? 16
                                              : Responsive.isTablet(context)
                                                  ? 18
                                                  : 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      CustomTextField(
                                        contentPadding:
                                            EdgeInsets.only(left: 18, top: 22),
                                        controller: facilitiesController
                                            .descriptionController,
                                        maxLine: 5,
                                        borderColor:
                                            AppColors.darkGrey.withOpacity(.1),
                                        borderRadius: 8,
                                        hintText: "Add text",
                                        fillColor: AppColors.whiteColor,
                                        cursorColor: AppColors.primaryColor,
                                        inputStyle: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.blackColor),
                                        hintStyle: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.blackColor),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Social media',
                                        style: TextStyle(
                                          fontFamily: 'Nunito-Regular',
                                          fontSize: Responsive.isMobile(context)
                                              ? 16
                                              : Responsive.isTablet(context)
                                                  ? 18
                                                  : 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Obx(
                                        () => DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            isExpanded: true,
                                            hint: Text(
                                              'Tiktok',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            ),
                                            items: facilitiesController
                                                .socialMedia
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
                                            value: facilitiesController
                                                .selectedSocialMedia.value,
                                            onChanged: (String? value) {
                                              facilitiesController
                                                  .selectedSocialMedia
                                                  .value = value!;
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColors.darkGrey
                                                      .withOpacity(.1),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: AppColors.whiteColor,
                                              ),
                                              height: 40,
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              height: 40,
                                            ),
                                            iconStyleData: IconStyleData(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_outlined,
                                                color: AppColors.primaryColor,
                                              ),
                                              iconSize: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Link',
                                        style: TextStyle(
                                          fontFamily: 'Nunito-Regular',
                                          fontSize: Responsive.isMobile(context)
                                              ? 16
                                              : Responsive.isTablet(context)
                                                  ? 18
                                                  : 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      CustomTextField(
                                        contentPadding:
                                            EdgeInsets.only(left: 18),
                                        controller:
                                            facilitiesController.linkController,
                                        borderColor:
                                            AppColors.darkGrey.withOpacity(.1),
                                        borderRadius: 8,
                                        hintText: "Tiktok.com",
                                        fillColor: AppColors.whiteColor,
                                        cursorColor: AppColors.primaryColor,
                                        inputStyle: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.blackColor),
                                        hintStyle: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.blackColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                title: "Update",
                                textStyle: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize:
                                      Responsive.isMobile(context) ? 16 : 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                backgroundColor: AppColors.primaryColor,
                                borderRadius: 8,
                                width: Responsive.isMobile(context)
                                    ? Get.width * 0.2
                                    : Get.width * 0.2,
                                onPressed: () {
                                  Get.snackbar('Update',
                                      'Your data is successfully updated.');
                                  Get.to(() => RestaurantDetailScreen(
                                        isFromButtonClick: true,
                                      ));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
