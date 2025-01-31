import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/models/review_model.dart';
import 'package:kaistable_website/screens/detail_screens/controller/restaurant_detail_controller.dart';
import 'package:kaistable_website/screens/detail_screens/widget/map_widget.dart';
import 'package:kaistable_website/screens/detail_screens/widget/review_widget.dart';
import 'package:kaistable_website/screens/detail_screens/widget/tabs_widget.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/app_colors.dart';
import '../home_screen/location_pages/location_controller/location_list_controller.dart';
import '../home_screen/location_pages/widget/location_star_widget.dart';
import 'widget/about_section_widget.dart';

class RestaurantDetailScreen extends StatefulWidget {
  List<String>? happyList;
  RestaurantModel? restaurantModel;

  RestaurantDetailScreen({super.key, this.happyList, this.restaurantModel});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final controller = Get.put(RestaurantDetailController());

  final LocationListController locationController = LocationListController();

  final HomeLocationController homeLocationController =
      Get.put(HomeLocationController());
  MenuModel menuModel = MenuModel.initialize();
  @override
  void initState() {
   
    homeLocationController.addRecentView(
        restaurantID: widget.restaurantModel?.docID ?? '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // func();
    return Obx(() {
      int indexOfMenuPersentageOff = 0;
      int indexOfMenuHappyHourOff = 0;

      indexOfMenuPersentageOff =
          homeLocationController.selectedPersentage.indexOf(true);
      indexOfMenuHappyHourOff =
          homeLocationController.selectedHappyhour.indexOf(true);
      print(
          'happyHourSpecials menu model ${menuModel.happyHourSpecials.length}');
      print('percentageOff menu model ${menuModel.percentageOff.length}');

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
                HomeLocationController()
                    .favoriteHeart(resturant_id: widget.restaurantModel?.docID),
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
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(
                                  widget.restaurantModel?.logoImage ?? ''))),
                    ),
                    SizedBox(height: 130),
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
                                String link = widget.restaurantModel?.socialLink
                                            .contains('facebook') ??
                                        false
                                    ? widget.restaurantModel?.socialLink ?? ''
                                    : '';
                                if (link == '') {
                                  Get.snackbar('Oops!', 'URl not available');
                                } else {
                                  await launchUrl(
                                    Uri.parse(widget.restaurantModel?.socialLink
                                                .contains('facebook') ??
                                            false
                                        ? widget.restaurantModel?.socialLink ??
                                            ''
                                        : ''),
                                  );
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
                                String link = widget.restaurantModel?.socialLink
                                            .contains('instagram') ??
                                        false
                                    ? widget.restaurantModel?.socialLink ?? ''
                                    : '';
                                if (link == '') {
                                  Get.snackbar('Oops!', 'URl not available');
                                } else {
                                  await launchUrl(
                                    Uri.parse(widget.restaurantModel?.socialLink
                                                .contains('instagram') ??
                                            false
                                        ? widget.restaurantModel?.socialLink ??
                                            ''
                                        : ''),
                                  );
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
                                String link = widget.restaurantModel?.socialLink
                                            .contains('youtube') ??
                                        false
                                    ? widget.restaurantModel?.socialLink ?? ''
                                    : '';
                                if (link == '') {
                                  Get.snackbar('Oops!', 'URl not available');
                                } else {
                                  await launchUrl(
                                    Uri.parse(widget.restaurantModel?.socialLink
                                                .contains('youtube') ??
                                            false
                                        ? widget.restaurantModel?.socialLink ??
                                            ''
                                        : ''),
                                  );
                                }
                              },
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
                                String link = widget.restaurantModel?.socialLink
                                            .contains('twitter') ??
                                        false
                                    ? widget.restaurantModel?.socialLink ?? ''
                                    : '';
                                if (link == '') {
                                  Get.snackbar('Oops!', 'URl not available');
                                } else {
                                  await launchUrl(
                                    Uri.parse(widget.restaurantModel?.socialLink
                                                .contains('twitter') ??
                                            false
                                        ? widget.restaurantModel?.socialLink ??
                                            ''
                                        : ''),
                                  );
                                }
                              },
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                      ...widget.restaurantModel!
                                          .entertainmentScheduleList
                                          .map((data) {
                                        return TableRow(
                                          decoration: const BoxDecoration(
                                            color: Colors
                                                .white, // Row background color
                                          ),
                                          children: [
                                            buildDataCell(data.eventName ?? ""),
                                            buildDataCell(data.eventBy ?? ""),
                                            buildDataCell(data.day ?? ""),
                                            buildDataCell(data.date ?? ""),
                                            buildDataCell(data.startTime +
                                                    ' - ' +
                                                    data.endTime ??
                                                ""),
                                          ],
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : controller.selectedTop.value == 'About'
                              ? AboutSectionWidget(
                                  aboutText:
                                      widget.restaurantModel?.about ?? '',
                                  resturantID:
                                      widget.restaurantModel?.docID ?? '',
                                )
                              : controller.selectedTop.value == 'Reviews'
                                  ? ReviewWidget(
                                      restaurantModel: widget.restaurantModel,
                                    )
                                  : StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('restaurants')
                                          .doc('qA4ZwrICw8NWshCaZ52a5dqgDSj2')
                                          .collection('MealMenu')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        MenuModel mealMenu =
                                            MenuModel.initialize();
                                        // Access the snapshot data
                                        var menuDocs = snapshot.data?.docs;
                                        // print('menu data -------- $menuDocs');
                                        if (menuDocs != null) {
                                          // Print each document's raw data in the debug console
                                          for (var doc in menuDocs) {
                                            // print("Document ID: ${doc.id}");
                                            // print(
                                            //     "Document Data: ${doc.data()}");
                                            Map<String, dynamic> dataMap =
                                                doc.data();
                                            String fromDate = dataMap[
                                                'fromDate']; // From date
                                            String toDate =
                                                dataMap['toDate']; // To date
                                            DateTime now =
                                                DateTime.now(); // Current date

                                            // Convert fromDate and toDate to DateTime
                                            DateTime fromDateTime =
                                                DateFormat("dd/MM/yyyy")
                                                    .parse(fromDate);
                                            DateTime toDateTime =
                                                DateFormat("dd/MM/yyyy")
                                                    .parse(toDate);

                                            if (now.isAfter(fromDateTime) &&
                                                now.isBefore(toDateTime)) {
                                              List<OfferModel> percentageOff =
                                                  [];
                                              List<OfferModel> happyHour = [];
                                              for (var offer
                                                  in dataMap['menu']) {
                                                MealModel food = MealModel(
                                                    imagesList: [],
                                                    offerName: '');
                                                MealModel drink = MealModel(
                                                    imagesList: [],
                                                    offerName: '');
                                                String cuisine = offer['items']
                                                    [0]['cuisineName'];
                                                if (offer['items'][0]
                                                        ['cuisineMenu'] ==
                                                    'Drinks Menu') {
                                                  drink = MealModel(
                                                    imagesList: offer['items']
                                                        [0]['images'],
                                                    offerName: offer['items'][0]
                                                        ['offer'],
                                                  );
                                                } else {
                                                  food = MealModel(
                                                    imagesList: offer['items']
                                                        [0]['images'],
                                                    offerName: offer['items'][0]
                                                        ['offer'],
                                                  );
                                                }
                                                if (offer['discountType'] ==
                                                    'Happy Hour Special') {
                                                  happyHour.add(
                                                    OfferModel(
                                                      startTime:
                                                          offer['fromTime'],
                                                      endTime: offer['toTime'],
                                                      percentage: offer[
                                                          'percentageValue'],
                                                      food: food,
                                                      drink: drink,
                                                      cuisine: cuisine,
                                                    ),
                                                  );
                                                } else {
                                                  percentageOff.add(
                                                    OfferModel(
                                                      startTime:
                                                          offer['fromTime'],
                                                      endTime: offer['toTime'],
                                                      percentage: offer[
                                                          'percentageValue'],
                                                      food: food,
                                                      drink: drink,
                                                      cuisine: cuisine,
                                                    ),
                                                  );
                                                }
                                              }
                                              mealMenu = MenuModel(
                                                percentageOff: percentageOff,
                                                happyHourSpecials: happyHour,
                                              );
                                            }
                                          }
                                        }

                                        return Column(
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
                                                  left: 16.0,
                                                  right: 16,
                                                  top: 16),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.access_time_filled,
                                                    color:
                                                        AppColors.primaryColor,
                                                    size: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    'choose time & discount',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.textColor,
                                                      fontSize: 14,
                                                      fontFamily:
                                                          'Nunito-Regular',
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                                        controller:
                                                            locationController
                                                                .scrollController,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: widget
                                                            .restaurantModel!
                                                            .menuList
                                                            .happyHourSpecials
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item = widget
                                                              .restaurantModel!
                                                              .menuList
                                                              .happyHourSpecials[index];
                                                          return Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        4,
                                                                    vertical:
                                                                        6),
                                                            child:
                                                                LocationStarWidget(
                                                              index: index,
                                                              menuType:
                                                                  'HappyHour',
                                                              timeText1:
                                                                  item.startTime ??
                                                                      '',
                                                              timeText2:
                                                                  item.endTime ??
                                                                      '',
                                                              percentageText:
                                                                  item.percentage ??
                                                                      '',
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
                                                        controller:
                                                            locationController
                                                                .scrollController,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: widget
                                                            .restaurantModel
                                                            ?.menuList
                                                            .percentageOff
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item = widget
                                                                  .restaurantModel
                                                                  ?.menuList
                                                                  .percentageOff[
                                                              index];
                                                          return Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        4,
                                                                    vertical:
                                                                        6),
                                                            child:
                                                                LocationStarWidget(
                                                              timeText1:
                                                                  item?.startTime ??
                                                                      '',
                                                              index: index,
                                                              menuType:
                                                                  'PercentageOff',
                                                              timeText2:
                                                                  item?.endTime ??
                                                                      '',
                                                              percentageText:
                                                                  item?.percentage ??
                                                                      '',
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Meals',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.textColor,
                                                      fontSize: 15,
                                                      fontFamily:
                                                          'Nunito-Regular',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Obx(
                                                        () => Text(
                                                          controller.selectedMenu
                                                                      .value ==
                                                                  'Happy Hours Specials'
                                                              ? widget
                                                                      .restaurantModel!
                                                                      .menuList
                                                                      .happyHourSpecials
                                                                      .isEmpty
                                                                  ? ''
                                                                  : widget
                                                                          .restaurantModel
                                                                          ?.menuList
                                                                          .happyHourSpecials[
                                                                              indexOfMenuHappyHourOff]
                                                                          .cuisine ??
                                                                      ''
                                                              : widget
                                                                      .restaurantModel!
                                                                      .menuList
                                                                      .happyHourSpecials
                                                                      .isEmpty
                                                                  ? ''
                                                                  : widget
                                                                          .restaurantModel
                                                                          ?.menuList
                                                                          .percentageOff[
                                                                              indexOfMenuPersentageOff]
                                                                          .cuisine ??
                                                                      '',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .textColor,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Nunito-Regular',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
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
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      // First part: Menu items and before discount columns
                                                      Obx(() {
                                                        return Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            // height: 420,
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            4),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            4))),

                                                            child: Table(
                                                              border: TableBorder.symmetric(
                                                                  inside: BorderSide(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.5))),
                                                              children: [
                                                                _buildTableHeader(
                                                                    context),
                                                                _buildTableRow(
                                                                  context,
                                                                  imageList: controller
                                                                              .selectedMenu
                                                                              .value ==
                                                                          'Happy Hours Specials'
                                                                      ? widget
                                                                              .restaurantModel!
                                                                              .menuList
                                                                              .happyHourSpecials
                                                                              .isEmpty
                                                                          ? []
                                                                          : widget
                                                                              .restaurantModel!
                                                                              .menuList
                                                                              .happyHourSpecials[
                                                                                  indexOfMenuHappyHourOff]
                                                                              .food
                                                                              .imagesList
                                                                      : widget
                                                                              .restaurantModel!
                                                                              .menuList
                                                                              .percentageOff
                                                                              .isEmpty
                                                                          ? []
                                                                          : widget
                                                                              .restaurantModel!
                                                                              .menuList
                                                                              .percentageOff[indexOfMenuPersentageOff]
                                                                              .food
                                                                              .imagesList,
                                                                  menuItem:
                                                                      'Food Menu',
                                                                  menuItemNumbers: controller
                                                                              .selectedMenu
                                                                              .value ==
                                                                          'Happy Hours Specials'
                                                                      ? '(${widget.restaurantModel!.menuList.happyHourSpecials.isEmpty ? 0 : widget.restaurantModel!.menuList.happyHourSpecials[indexOfMenuHappyHourOff].food.imagesList.length.toString()})'
                                                                      : '(${widget.restaurantModel!.menuList.percentageOff.isEmpty ? 0 : widget.restaurantModel!.menuList.percentageOff[indexOfMenuPersentageOff].food.imagesList.length.toString()})',
                                                                ),
                                                                _buildTableRow(
                                                                  context,
                                                                  imageList: controller
                                                                              .selectedMenu
                                                                              .value ==
                                                                          'Happy Hours Specials'
                                                                      ? widget
                                                                              .restaurantModel!
                                                                              .menuList
                                                                              .happyHourSpecials
                                                                              .isEmpty
                                                                          ? []
                                                                          : widget
                                                                              .restaurantModel!
                                                                              .menuList
                                                                              .happyHourSpecials[
                                                                                  indexOfMenuHappyHourOff]
                                                                              .drink
                                                                              .imagesList
                                                                      : widget
                                                                              .restaurantModel!
                                                                              .menuList
                                                                              .percentageOff
                                                                              .isEmpty
                                                                          ? []
                                                                          : widget
                                                                              .restaurantModel!
                                                                              .menuList
                                                                              .percentageOff[indexOfMenuPersentageOff]
                                                                              .drink
                                                                              .imagesList,
                                                                  menuItem:
                                                                      'Drink Menu',
                                                                  menuItemNumbers: controller
                                                                              .selectedMenu
                                                                              .value ==
                                                                          'Happy Hours Specials'
                                                                      ? '(${widget.restaurantModel!.menuList.happyHourSpecials.isEmpty ? 0 : widget.restaurantModel!.menuList.happyHourSpecials[indexOfMenuHappyHourOff].drink.imagesList.length.toString()})'
                                                                      : '(${widget.restaurantModel!.menuList.percentageOff.isEmpty ? 0 : widget.restaurantModel!.menuList.percentageOff[indexOfMenuPersentageOff].drink.imagesList.length.toString()})',
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                      // Second part: After discount (green column)
                                                      Obx(
                                                        () => Expanded(
                                                          child: Container(
                                                            height: 290,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .primaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          9),
                                                              child: Table(
                                                                border: TableBorder.symmetric(
                                                                    inside: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.5))),
                                                                children: [
                                                                  _buildGreenHeader(
                                                                      context),
                                                                  _buildGreenRow(
                                                                    context,
                                                                    afterPrice: controller.selectedMenu.value ==
                                                                            'Happy Hours Specials'
                                                                        ? widget
                                                                                .restaurantModel!.menuList.happyHourSpecials.isEmpty
                                                                            ? ''
                                                                            : widget.restaurantModel!.menuList.happyHourSpecials[indexOfMenuHappyHourOff].food.offerName ??
                                                                                ''
                                                                        : widget
                                                                                .restaurantModel!.menuList.percentageOff.isEmpty
                                                                            ? ''
                                                                            : widget.restaurantModel!.menuList.percentageOff[indexOfMenuPersentageOff].food.offerName ??
                                                                                '',
                                                                  ),
                                                                  _buildGreenRow(
                                                                    context,
                                                                    afterPrice: controller.selectedMenu.value ==
                                                                            'Happy Hours Specials'
                                                                        ? widget
                                                                                .restaurantModel!.menuList.happyHourSpecials.isEmpty
                                                                            ? ''
                                                                            : widget.restaurantModel!.menuList.happyHourSpecials[indexOfMenuHappyHourOff].drink.offerName ??
                                                                                ''
                                                                        : widget
                                                                                .restaurantModel!.menuList.percentageOff.isEmpty
                                                                            ? ''
                                                                            : widget.restaurantModel!.menuList.percentageOff[indexOfMenuPersentageOff].drink.offerName ??
                                                                                '',
                                                                  ),
                                                                ],
                                                              ),
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
                                                  color: AppColors
                                                      .headingTextColor,
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
                                                  children: [
                                                    Text(widget.restaurantModel
                                                            ?.specialConditions ??
                                                        '')
                                                  ],
                                                )),
                                          ],
                                        );
                                      });
                    }),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.topLeft,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Get.width,
                              height: 500,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16)),
                              child: MapWidget(
                                controller: controller,
                                lat: widget.restaurantModel?.latitude ?? 0.0,
                                long: widget.restaurantModel?.longitude ?? 0.0,
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            MapDetailWidget(
                              address: widget.restaurantModel?.address ?? '',
                              atmospher:
                                  widget.restaurantModel?.atmopshereList ?? [],
                              dietaryList:
                                  widget.restaurantModel?.dietaryList ?? [],
                              entertainmentList: widget.restaurantModel
                                      ?.entertainmentScheduleList ??
                                  [],
                              facilitiesList:
                                  widget.restaurantModel?.facilityList ?? [],
                              priceRange:
                                  widget.restaurantModel?.priceRange ?? '',
                              spokenLanguage:
                                  widget.restaurantModel?.spokenLanguage ?? '',
                            ),
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
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, top: 145),
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
                                    widget.restaurantModel?.address ?? '',
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
                              StreamBuilder<List<ReviewModel>>(
                                  stream: homeLocationController.getReviews(
                                      widget.restaurantModel?.docID ?? ''),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return SizedBox();
                                    }

                                    final reviews = snapshot.data!;
                                    return Row(
                                      children: [
                                        Text(
                                          '(${reviews.map((e) => e.starRating).reduce((a, b) => a! + b!)! / reviews.length})',
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
                                            initialRating: reviews
                                                    .map((e) =>
                                                        e.starRating ?? 0)
                                                    .reduce((a, b) => a + b) /
                                                reviews.length,
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
                                          '${reviews.length} reviews',
                                          style: TextStyle(
                                            color: AppColors.darkGrey,
                                            fontSize: 16,
                                            fontFamily: 'Nunito-Regular',
                                            fontWeight: FontWeight.w400,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    );
                                  }),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                widget.restaurantModel?.spokenLanguage ?? '',
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
                                child: widget
                                        .restaurantModel!.imagesList.isEmpty
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: widget
                                            .restaurantModel!.imagesList
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          String imagePath = entry.value;

                                          if (index < 4) {
                                            // Display the first 4 images normally
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.network(
                                                imagePath,
                                                fit: BoxFit.cover,
                                                height: 41,
                                                width: 46,
                                              ),
                                            );
                                          } else if (index == 4 &&
                                              widget.restaurantModel!.imagesList
                                                      .length >
                                                  5) {
                                            // Display "5+" overlay on the 5th image if more than 5 images exist
                                            return Stack(
                                              children: [
                                                Image.network(
                                                  imagePath,
                                                  height: 41,
                                                  width: 46,
                                                ),
                                                Container(
                                                  height: 41,
                                                  width: 46,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      '5+',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else if (index == 4) {
                                            // Display the 5th image normally if there are exactly 5 images
                                            return Image.network(
                                              imagePath,
                                              height: 41,
                                              width: 46,
                                            );
                                          } else {
                                            // Skip additional images
                                            return const SizedBox.shrink();
                                          }
                                        }).toList(),
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
    });
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageList[index],
                            fit: BoxFit.cover,
                            width: 60,
                            height: 50,
                          ),
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
  String user_name;
  double rating;
  String description;
  String date;
  RatingRowWidget({
    super.key,
    required this.isImage,
    required this.imagePaths,
    required this.rating,
    required this.date,
    required this.description,
    required this.user_name,
  });

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
                      user_name,
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
                      date,
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
                        text: '${rating}', // Rating text
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
                            initialRating: rating,
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
                    description,
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
                            image: NetworkImage(imagePaths[index]),
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
