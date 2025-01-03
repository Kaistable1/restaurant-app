import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/detail_screens/controller/restaurant_detail_controller.dart';

import 'package:kaistable_website/screens/detail_screens/widget/map_widget.dart';
import 'package:kaistable_website/screens/detail_screens/widget/number_text_widget.dart';
import 'package:kaistable_website/screens/detail_screens/widget/review_widget.dart';
import 'package:kaistable_website/screens/detail_screens/widget/tabs_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../home_screen/location_pages/location_controller/location_list_controller.dart';
import '../home_screen/location_pages/widget/location_star_widget.dart';
import 'widget/about_section_widget.dart';

class RestaurantDetailScreen extends StatelessWidget {
  List<String>? happyList;

  final controller = Get.put(RestaurantDetailController());
  final LocationListController locationController = LocationListController();

  RestaurantDetailScreen({super.key, this.happyList});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return false;
        },
        child: Scaffold(
          backgroundColor: AppColors.bgColor,
          appBar: AppBar(
            backgroundColor: AppColors.bgColor,
            iconTheme: const IconThemeData(
              color: AppColors.primaryColor,
            ),
            centerTitle: true,
            automaticallyImplyLeading: true,
            leading: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back, size: 18),
                ),
              ),
            ),
            actions: [
              Obx(() {
                return InkWell(
                    onTap: () {
                      controller.isFavorite.value =
                          !controller.isFavorite.value;
                    },
                    child: controller.isFavorite.value
                        ? Icon(
                            size: 24,
                            Icons.favorite,
                            color: AppColors.primaryColor,
                          )
                        : Icon(
                            size: 24,
                            Icons.favorite_border_outlined,
                            color: AppColors.primaryColor,
                          ));
              }),
              SizedBox(
                width: 12,
              )
            ],
            title: const Text(
              'Restaurant details',
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.bottomSheetColor,
                fontWeight: FontWeight.w700,
                fontFamily: 'Nunito-Bold',
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 202,
                    width: Get.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/restaurant_img.png"))),
                  ),
                  SizedBox(height:  130),
                  Center(
                    child: Container(
                      width: 264,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 22),
                          GestureDetector(
                            onTap: () async {
                              if (!await launchUrl(
                                  Uri.parse('https://facebook.com/'))) {
                                throw Exception('Could not launch ');
                              }
                            },
                            child: Image.asset(
                              "assets/images/facebook.png",
                              height: 20,
                              width: 20,
                            ),
                          ),
                          Spacer(),
                          // Instagram Icon
                          GestureDetector(
                            onTap: () async {
                              if (!await launchUrl(
                                  Uri.parse('https://instagram.com/'))) {
                                throw Exception('Could not launch ');
                              }
                            },
                            child: Image.asset(
                              "assets/images/instagram.png",
                              height: 20,
                              width: 20,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              if (!await launchUrl(
                                  Uri.parse('https://youtube.com/'))) {
                                throw Exception('Could not launch ');
                              }
                            }, // URL to open
                            child: Image.asset(
                              "assets/images/youtube.png",
                              height: 22,
                              width: 22,
                            ),
                          ),
                          Spacer(),
                          // X (Twitter) Icon
                          GestureDetector(
                            onTap: () async {
                              if (!await launchUrl(
                                  Uri.parse('https://twitter.com/'))) {
                                throw Exception('Could not launch ');
                              }
                            }, // URL to open
                            child: Image.asset(
                              "assets/images/X.png",
                              height: 20,
                              width: 20,
                            ),
                          ),
                          SizedBox(width: 22),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Tabs(controller: controller),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Obx(() {
                    return controller.selectedTop.value == 'Entertainment'
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Table(
                                  border: TableBorder.all(
                                      color: AppColors.tableBorderColor,
                                      width: 2,
                                      borderRadius: BorderRadius.circular(10)),
                                  columnWidths: const {
                                    0: FlexColumnWidth(1.3),
                                    1: FlexColumnWidth(1.3),
                                    2: FlexColumnWidth(1.3),
                                    3: FlexColumnWidth(1.5),
                                    4: FlexColumnWidth(1.8),
                                  },
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      children: [
                                        buildHeaderCell(
                                          "Name",
                                        ),
                                        buildHeaderCell("By"),
                                        buildHeaderCell("Day"),
                                        buildHeaderCell("Date"),
                                        buildHeaderCell("Time"),
                                      ],
                                    ),
                                    // Table data rows
                                    ...controller.rowData.map((data) {
                                      return TableRow(
                                        decoration: const BoxDecoration(
                                          color: Colors
                                              .white, // Row background color
                                        ),
                                        children: [
                                          buildDataCell(data["Name"] ?? ""),
                                          buildDataCell(data["By"] ?? ""),
                                          buildDataCell(data["Day"] ?? ""),
                                          buildDataCell(data["Date"] ?? ""),
                                          buildDataCell(data["Time"] ?? ""),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : controller.selectedTop.value == 'About'
                            ? AboutSectionWidget()
                            : controller.selectedTop.value == 'Reviews'
                                ? ReviewWidget()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 12,
                                      ),
                                      OfferSelectionWidget(
                                          controller: controller),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16, top: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.access_time_filled,
                                              color: AppColors.primaryColor,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              'choose time & discount',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.textColor,
                                                fontSize: 14,
                                                fontFamily: 'Nunito-Regular',
                                                fontWeight: FontWeight.w400,
                                                height: 0.16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      controller.selectedMenu.value ==
                                              'Happy Hours Specials'
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                left: 16,
                                              ),
                                              child: SizedBox(
                                                height: 100,
                                                child: ListView.builder(
                                                  controller: locationController
                                                      .scrollController,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: locationController
                                                      .circleItems
                                                      .take(3)
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        locationController
                                                            .circleItems[index];
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4,
                                                              vertical: 6),
                                                      child: LocationStarWidget(
                                                        timeText1:
                                                            item.timeText,
                                                        timeText2:
                                                            item.timeText2,
                                                        percentageText:
                                                            item.percentageText,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                left: 16,
                                              ),
                                              child: SizedBox(
                                                height: 100,
                                                child: ListView.builder(
                                                  controller: locationController
                                                      .scrollController,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: locationController
                                                      .circleItems.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        locationController
                                                            .circleItems[index];
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4,
                                                              vertical: 6),
                                                      child: LocationStarWidget(
                                                        timeText1:
                                                            item.timeText,
                                                        timeText2:
                                                            item.timeText2,
                                                        percentageText:
                                                            item.percentageText,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Meals',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.textColor,
                                                fontSize: 15,
                                                fontFamily: 'Nunito-Regular',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Italian',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: AppColors.textColor,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'Nunito-Regular',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Image.asset(
                                                  'assets/images/meal_Icon..png',
                                                  height: 10.73,
                                                  width: 17,
                                                  fit: BoxFit.fill,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16.0),
                                        child: Center(
                                          child: Container(
                                            width: Get.width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // First part: Menu items and before discount columns
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    // height: 420,
                                                    decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        4),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        4))),

                                                    child: Table(
                                                      border: TableBorder.symmetric(
                                                          inside: BorderSide(
                                                              width: 1,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5))),
                                                      children: [
                                                        _buildTableHeader(
                                                            context),
                                                        _buildTableRow(
                                                          context,
                                                          imageList: controller.foodMenuImages,
                                                          menuItem: 'Food menu', menuItemNumbers: '(${controller.foodMenuImages.length.toString()})',
                                                        ),
                                                        _buildTableRow(
                                                          context,
                                                          imageList: controller.drinkMenuImages,
                                                          menuItemNumbers: '(${controller.drinkMenuImages.length.toString()})',
                                                          menuItem:
                                                              'Drink menu',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                // Second part: After discount (green column)
                                                Expanded(
                                                  child: Container(
                                                    height: 290,
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 9),
                                                      child: Table(
                                                        border: TableBorder.symmetric(
                                                            inside: BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5))),
                                                        children: [
                                                          _buildGreenHeader(
                                                              context),
                                                          _buildGreenRow(
                                                              context,
                                                              afterPrice:
                                                                  '50 \% off'),
                                                          _buildGreenRow(
                                                              context,
                                                              afterPrice:
                                                                  '2 for 1'),
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
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16),
                                        child: Text(
                                          'Special Conditions ',
                                          style: TextStyle(
                                            color: AppColors.headingTextColor,
                                            fontSize: 20,
                                            fontFamily: 'aftika-regular',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                            controller.texts.length,
                                            (index) => NumberedTextWidget(
                                              number: index + 1,
                                              text: controller.texts[index],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                  }),
                  SizedBox(height: 12),
                  Align( alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Text(
                        'Map',
                        style: TextStyle(
                          color: AppColors.headingTextColor,
                          fontSize: 20,
                          fontFamily: 'aftika-regular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Container(
                      width: Get.width,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: Get.width,
                                height: 500,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16)),
                                child: MapWidget(controller: controller),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              const MapDetailWidget(),
                            ],
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 145),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  // Clip the blur to the rounded corners
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    // Adjust the blur intensity
                    child: Container(
                      height: 173,
                      width: 358,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.whiteColor.withOpacity(0.4),
                            AppColors.primaryColor.withOpacity(0.3),
                          ],
                          begin: Alignment.topCenter,
                          // Starting point of the gradient
                          end: Alignment
                              .bottomCenter, // Ending point of the gradient
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12, top: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/ihop-restaurant-logo 1.png',
                                  height: 33,
                                  width: 49,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Ihop restaurant @ Tseug Kwan O',
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontFamily: 'Nunito-Bold',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Text(
                                  '(4.0)',
                                  style: TextStyle(
                                    color: Color(0xFF4F5761),
                                    fontSize: 16,
                                    fontFamily: 'Nunito-Regular',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                  height: 14,
                                  child: RatingBar(
                                    itemSize: 14,
                                    ignoreGestures: true,
                                    initialRating: 4,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    ratingWidget: RatingWidget(
                                      full: Image.asset(
                                        'assets/images/star yellow.png',
                                        height: 19,
                                      ),
                                      half: Image.asset(
                                        'assets/images/star yellow.png',
                                        height: 19,
                                      ),
                                      empty: Image.asset(
                                        'assets/images/star_empty.png',
                                        height: 19,
                                      ),
                                    ),
                                    itemPadding: const EdgeInsets.only(
                                        left: 2.0, bottom: 20),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '234 reviews',
                                  style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontSize: 16,
                                    fontFamily: 'Nunito-Regular',
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Chinese',
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 16,
                                fontFamily: 'Nunito-Regular',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              height: 49,
                              width: 278,
                              decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    "assets/images/image1_resturant.png",
                                    height: 41,
                                    width: 46,
                                  ),
                                  Image.asset(
                                    "assets/images/image2_resturant.png",
                                    height: 41,
                                    width: 46,
                                  ),
                                  Image.asset(
                                    "assets/images/image3_resturant.png",
                                    height: 41,
                                    width: 46,
                                  ),
                                  Image.asset(
                                    "assets/images/image4_resturant.png",
                                    height: 41,
                                    width: 46,
                                  ),
                                  Image.asset(
                                    "assets/images/image5_resturant.png",
                                    height: 41,
                                    width: 46,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }

  // Header cell builder
  Widget buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Nunito-Sans',
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

// Data cell builder
  Widget buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'Nunito-Sans',
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
            fontSize: 8),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Normal table rows for "Menu Items" and "Before Discount" columns
  TableRow _buildTableRow(
      BuildContext context, {
        required String menuItem,
        required String menuItemNumbers,
        required List<String> imageList, // Accept a list of images
      }) {
    return TableRow(
      children: [
        Container(
          height: 106,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: 68,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Image.asset(
                          imageList[index],
                          width: 60,
                          height: 66,
                        ),
                      );
                    },
                  ),
                ),
                // SizedBox(height: 6),
                Expanded(
                  child: Center(
                    child: Text(
                      menuItemNumbers,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black, // Update this color if needed
                        fontSize: 10,
                        fontFamily: 'Nunito-Regular',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      menuItem,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black, // Update this color if needed
                        fontSize: 10,
                        fontFamily: 'Nunito-Regular',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  TableRow _buildGreenHeader(context) {
    return TableRow(
      children: [
        SizedBox(
          height: 60,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Offer',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableHeader(context) {
    return TableRow(
      children: [
        Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Menus',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Rows for the green column
  TableRow _buildGreenRow(context, {required String afterPrice}) {
    return TableRow(
      children: [
        Container(
          height: 106,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                afterPrice,
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontSize: 10,
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OfferSelectionWidget extends StatelessWidget {
  const OfferSelectionWidget({
    super.key,
    required this.controller,
  });

  final RestaurantDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: 40,
        width: Get.width,
        decoration: BoxDecoration(
          color: const Color(0xFFEEEFF2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            controller.menuList.length,
            (index) {
              return Obx(() {
                return InkWell(
                  onTap: () {
                    controller.selectedMenu.value = controller.menuList[index];
                  },
                  child: IntrinsicWidth(
                    child: Container(
                      height: 26,
                      decoration: BoxDecoration(
                        color: controller.selectedMenu.value !=
                                controller.menuList[index]
                            ? Colors.transparent
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Center(
                        child: Text(
                          controller.menuList[index],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: controller.selectedMenu.value !=
                                    controller.menuList[index]
                                ? AppColors.darkGrey
                                : AppColors.primaryColor,
                            fontFamily: 'Nunito-Regular',
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }
}

class Line10 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Container(
        width: 1.5,
        height: 18,
        decoration: const BoxDecoration(color: AppColors.darkGrey),
      ),
    );
  }
}

class RatingRowWidget extends StatelessWidget {
  final bool isImage;
  final List<String> imagePaths;

  const RatingRowWidget(
      {super.key, required this.isImage, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Kristin Watson',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Nunito-Bold',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 180,
                    ),
                    Text(
                      'June 30, 2024',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'Nunito-Bold',
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 4,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '(5.0) ', // Rating text
                        style: TextStyle(
                          color: const Color(0xFF4F5761),
                          fontSize: 10,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      WidgetSpan(
                        child: SizedBox(
                          height: 13,
                          child: RatingBar(
                            itemSize: 12,
                            ignoreGestures: true,
                            initialRating: 4,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            ratingWidget: RatingWidget(
                              full: Image.asset(
                                'assets/images/star yellow.png',
                                height: 14,
                                color: AppColors.primaryColor,
                              ),
                              half: Image.asset('assets/images/star yellow.png',
                                  height: 14),
                              empty: Image.asset('assets/images/green_star.png',
                                  height: 14),
                            ),
                            itemPadding: const EdgeInsets.only(left: 2.0),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                SizedBox(
                  width: 338,
                  height: 32,
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.bottomSheetColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              if (isImage)
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 8.0),
                        // Space between images
                        height: 44,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: AssetImage(imagePaths[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 5),
            ],
          ),
        )
      ],
    );
  }
}
