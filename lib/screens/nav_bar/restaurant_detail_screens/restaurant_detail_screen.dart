import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kaistable_website/models/restaurant_model.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/custom_button.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../../constants/app_colors.dart';
import '../../../custom_widget/app_bar.dart';
import '../../../utils/functions.dart';
import '../../../widgets/claim_dialog.dart';
import '../../home_screen/home_controller/home_location_controller.dart';
import '../full_screen_video/full_screen_video_screen.dart';
import 'controller/restaurant_detail_controller.dart';
import 'controller/restaurant_video_controller.dart';

class RestaurantDetailScreen extends StatelessWidget {
  List<String>? happyList;
  RestaurantModel? restaurantModel;

  RestaurantDetailScreen({super.key, this.happyList, this.restaurantModel});

  RxInt tabIndex = 0.obs;
  RestaurantVideoController vc = Get.put(RestaurantVideoController());

  RxBool expExpand = false.obs;
  RxBool vibExpand = false.obs;
  RxBool atmExpand = false.obs;
  RxBool facExpand = false.obs;

  @override
  Widget build(BuildContext context) {
    // Collect all menu food images
    List<String> menuImages = [];
    for (var menu in restaurantModel!.menuList) {
      menuImages.addAll(menu.foodImages);
    }

    // Combine restaurant images and menu images
    List<String> allImages = [...restaurantModel!.imagesList, ...menuImages];

    // Added menuList to fetchVideos call
    vc.fetchVideos(restaurantModel!.resName, restaurantModel!.zipCode,
        restaurantModel!.imagesList, restaurantModel!.menuList);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurantModel!.resName,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'PlusJakartaSans',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Image.asset(
                                  'assets/icons/car.png',
                                  height: 12,
                                  width: 12,
                                ),
                              ),
                              FutureBuilder(
                                future: getCurrentLocation(context)
                                    .then((position) =>
                                        (Geolocator.distanceBetween(
                                              position.latitude,
                                              position.longitude,
                                              restaurantModel!.latitude,
                                              restaurantModel!.longitude,
                                            ) /
                                            1000) /
                                        1.609),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                      '   Calculating...',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            GoogleFonts.plusJakartaSans()
                                                .fontFamily,
                                        color: const Color.fromRGBO(
                                            142, 142, 147, 1),
                                      ),
                                    );
                                  }

                                  if (snapshot.hasError) {
                                    print(
                                        'Error retrieving location: ${snapshot.error}');
                                    return Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'PlusJakartaSans',
                                      ),
                                    );
                                  }

                                  return Text(
                                    snapshot.hasData
                                        ? '   ${snapshot.data!.toStringAsFixed(2)} miles'
                                        : '   Unknown',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'PlusJakartaSans',
                                    ),
                                  );
                                },
                              ),
                              // Text(
                              //   '   3.5 miles',
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.w500,
                              //     fontFamily: 'PlusJakartaSans',
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Restaurant',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'PlusJakartaSans',
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      allImages.length == 0
                          ? Row(
                              children: [
                                ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/restaurant_detail_img1.png',
                                    height: 246,
                                    width: (Get.width - 24 - 24 - 8) / 2,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  children: [
                                    ClipRRect(
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/restaurant_detail_img2.png',
                                        height: (246 - 8) / 2,
                                        width: (Get.width - 24 - 24 - 8) / 2,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/restaurant_detail_img3.png',
                                        height: (246 - 8) / 2,
                                        width: (Get.width - 24 - 24 - 8) / 2,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : allImages.length == 1
                              ? ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    allImages
                                        .first, // 'assets/images/restaurant_detail_img1.png',
                                    height: 246,
                                    width: Get.width - 48,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : allImages.length == 2
                                  ? Row(children: [
                                      ClipRRect(
                                        clipBehavior: Clip.hardEdge,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          allImages.first,
                                          height: 246,
                                          width: (Get.width - 24 - 24 - 8) / 2,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ClipRRect(
                                        clipBehavior: Clip.hardEdge,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          allImages.last,
                                          height: 246,
                                          width: (Get.width - 24 - 24 - 8) / 2,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ])
                                  : Row(
                                      children: [
                                        ClipRRect(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            allImages.first,
                                            height: 246,
                                            width:
                                                (Get.width - 24 - 24 - 8) / 2,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          children: [
                                            ClipRRect(
                                              clipBehavior: Clip.hardEdge,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                allImages[1],
                                                height: (246 - 8) / 2,
                                                width:
                                                    (Get.width - 24 - 24 - 8) /
                                                        2,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            ClipRRect(
                                              clipBehavior: Clip.hardEdge,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                allImages[2],
                                                height: (246 - 8) / 2,
                                                width:
                                                    (Get.width - 24 - 24 - 8) /
                                                        2,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                      const SizedBox(height: 24),
                      TabBar(
                        tabs: [
                          Tab(text: 'Info'),
                          Tab(text: 'Filter'),
                          Tab(text: 'Map'),
                          Tab(text: 'Gallery'),
                        ],
                        onTap: (index) {
                          tabIndex.value = index;
                        },
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.green,
                        tabAlignment: TabAlignment.fill,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'PlusJakartaSans',
                        ),
                      ),
                      Obx(
                        () => tabIndex.value == 0
                            ? Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    // Container(
                                    //   padding: EdgeInsets.symmetric(
                                    //       horizontal: 16, vertical: 12),
                                    //   decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(5),
                                    //       border: Border.all(
                                    //           color: Colors.black.withOpacity(0.04))),
                                    //   child: Text(
                                    //     restaurantModel!.about, // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore.',
                                    //     style: TextStyle(
                                    //       fontSize: 14,
                                    //       fontWeight: FontWeight.w500,
                                    //       fontFamily: 'PlusJakartaSans',
                                    //     ),
                                    //   ),
                                    // ),
                                    CustomButton(
                                      laBelText: 'Claim Your Restaurant',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'PlusJakartaSans',
                                      textColor: Colors.white,
                                      containerColor: Colors.orange,
                                      height: 32,
                                      radius: BorderRadius.circular(15),
                                      ontapp: () {
                                        showCustomDialog(context,
                                            resaturant_model: restaurantModel!);
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    Divider(color: AppColors.dividerColor),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Image.asset(
                                              'assets/icons/location.png',
                                              height: 12,
                                              width: 12),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            '${restaurantModel?.address ?? ''}, ${restaurantModel?.city ?? ''}, ${restaurantModel?.state ?? ''}, ${restaurantModel?.country ?? ''}${restaurantModel == null || restaurantModel!.zipCode == '' ? '' : ', ${restaurantModel!.zipCode}'}', // '304 Liverpool Blvd, Portsmouth, CA 30103',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'PlusJakartaSans',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Divider(color: AppColors.dividerColor),
                                    // const SizedBox(height: 16),
                                    Obx(() {
                                      final controller =
                                          Get.find<HomeLocationController>();
                                      final operatingHours =
                                          controller.operatingHoursCache[
                                              restaurantModel!.docID];
                                      final isFetching = controller
                                          .fetchingOperatingHours
                                          .contains(restaurantModel!.docID);
                                      final currentDay = DateFormat('EEEE')
                                          .format(DateTime.now());

                                      if (operatingHours == null ||
                                          operatingHours[currentDay] == null) {
                                        if (!isFetching) {
                                          controller.getOperatingHours(
                                              restaurantModel!.docID,
                                              triggerFilterUpdate: false);
                                        }
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 2),
                                                  child: Image.asset(
                                                      'assets/icons/time.png',
                                                      height: 12,
                                                      width: 12),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  isFetching
                                                      ? 'Retrieving...'
                                                      : 'Not mentioned',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'PlusJakartaSans',
                                                    color: const Color.fromRGBO(
                                                        142, 142, 147, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                          ],
                                        );
                                      }

                                      if (operatingHours.isEmpty) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Column(
                                              children: [
                                                const SizedBox(height: 16),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 2),
                                                  child: Image.asset(
                                                      'assets/icons/time.png',
                                                      height: 12,
                                                      width: 12),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  isFetching
                                                      ? 'Retrieving...'
                                                      : 'Not mentioned',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'PlusJakartaSans',
                                                    color: const Color.fromRGBO(
                                                        142, 142, 147, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                          ],
                                        );
                                      }

                                      final dayHours =
                                          operatingHours[currentDay]!;
                                      final fullDayHours =
                                          controller.getFullDayHours(dayHours);
                                      // Use the controller's method to properly check if restaurant is open
                                      bool isOpen =
                                          controller.isRestaurantOpen(dayHours);

                                      // Weekly hours for dropdown
                                      List<Map<String, String>> weeklyHours =
                                          [];
                                      final days = [
                                        'Monday',
                                        'Tuesday',
                                        'Wednesday',
                                        'Thursday',
                                        'Friday',
                                        'Saturday',
                                        'Sunday',
                                      ];
                                      for (var day in days) {
                                        final hours =
                                            operatingHours[day] != null
                                                ? controller.getFullDayHours(
                                                    operatingHours[day]!)
                                                : 'Closed';
                                        weeklyHours
                                            .add({'day': day, 'hours': hours});
                                      }

                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 2),
                                                child: Image.asset(
                                                    'assets/icons/time.png',
                                                    height: 12,
                                                    width: 12),
                                              ),
                                              const SizedBox(width: 8),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    isOpen ? 'Open' : 'Closed',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'PlusJakartaSans',
                                                      color: isOpen
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  DropdownButtonHideUnderline(
                                                    child:
                                                        DropdownButton2<String>(
                                                      hint: Text(
                                                        isOpen
                                                            ? 'Closes ${fullDayHours.split('–')[1]}'
                                                            : 'View Hours',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'PlusJakartaSans',
                                                        ),
                                                      ),
                                                      items: weeklyHours
                                                          .map((dayHours) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value: dayHours[
                                                                    'day'],
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      dayHours['day']! ==
                                                                              'Monday'
                                                                          ? 'Mon'
                                                                          : dayHours['day']! == 'Tuesday'
                                                                              ? 'Tue'
                                                                              : dayHours['day']! == 'Wednesday'
                                                                                  ? 'Wed'
                                                                                  : dayHours['day']! == 'Thursday'
                                                                                      ? 'Thu'
                                                                                      : dayHours['day']! == 'Friday'
                                                                                          ? 'Fri'
                                                                                          : dayHours['day']! == 'Saturday'
                                                                                              ? 'Sat'
                                                                                              : 'Sun',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontFamily:
                                                                            'PlusJakartaSans',
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      dayHours[
                                                                          'hours']!,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontFamily:
                                                                            'PlusJakartaSans',
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ))
                                                          .toList(),
                                                      onChanged: (value) {},
                                                      buttonStyleData:
                                                          ButtonStyleData(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 12),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                      ),
                                                      dropdownStyleData:
                                                          DropdownStyleData(
                                                        maxHeight: 200,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 12,
                                                                vertical: 8),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.04)),
                                                        ),
                                                      ),
                                                      menuItemStyleData:
                                                          MenuItemStyleData(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 4),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),

                                    // const SizedBox(height: 16),
                                    Divider(color: AppColors.dividerColor),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Image.asset(
                                              'assets/icons/site.png',
                                              height: 12,
                                              width: 12),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            restaurantModel == null ||
                                                    restaurantModel!
                                                            .websiteUrl ==
                                                        ''
                                                ? 'No website'
                                                : restaurantModel!
                                                    .websiteUrl, // 'www.website.com',
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'PlusJakartaSans',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Divider(color: AppColors.dividerColor),
                                    // const SizedBox(height: 16),
                                    // Row(
                                    //   children: [
                                    //     Padding(
                                    //       padding: EdgeInsets.only(top: 2),
                                    //       child: Image.asset(
                                    //           'assets/icons/cuisine.png',
                                    //           height: 12,
                                    //           width: 12),
                                    //     ),
                                    //     const SizedBox(width: 8),
                                    //     Text(
                                    //       restaurantModel!.dietaryList.isEmpty ? 'Cuisine' : restaurantModel!.dietaryList.map((e)=>e.toString()).join(', '), // 'Cuisine',
                                    //       style: TextStyle(
                                    //         fontSize: 14,
                                    //         fontWeight: FontWeight.w500,
                                    //         fontFamily: 'PlusJakartaSans',
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // const SizedBox(height: 16),
                                    // Divider(color: AppColors.dividerColor),
                                  ],
                                ),
                              )
                            : tabIndex.value == 1
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Column(children: [
                                      // ExpansionTile(
                                      //   title: Text(
                                      //     'Experiences',
                                      //     style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.w500,
                                      //       fontFamily: 'PlusJakartaSans',
                                      //     ),
                                      //   ),
                                      //   tilePadding: EdgeInsets.symmetric(horizontal: 16),
                                      //   shape: Border.all(width: 0, color: Colors.transparent),
                                      //   iconColor: Colors.grey[800],
                                      //   expandedAlignment: Alignment.centerLeft,
                                      //   children: [
                                      //     Wrap(
                                      //       spacing: 8,
                                      //       runSpacing: 8,
                                      //       children: restaurantModel!.entertainmentScheduleList
                                      //           .map((schedule) => Container(
                                      //         width: Get.width - 32,
                                      //             height: 40,
                                      //             padding: EdgeInsets.symmetric(horizontal: 18),
                                      //             decoration: BoxDecoration(
                                      //               color: Colors.green,
                                      //               borderRadius: BorderRadius.circular(20),
                                      //             ),
                                      //             child: Row(
                                      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //               children: [
                                      //                 Expanded(
                                      //                   child: Text(
                                      //                     schedule.eventName + '(${schedule.eventBy})',
                                      //                     overflow: TextOverflow.ellipsis,
                                      //                     maxLines: 2,
                                      //                     style: TextStyle(
                                      //                       fontSize: 12,
                                      //                       fontFamily: 'PlusJakartaSans',
                                      //                       fontWeight: FontWeight.bold,
                                      //                       color: Colors.white
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //                 const SizedBox(width: 4),
                                      //                 Text(
                                      //                   schedule.day + '    ' + schedule.startTime + ' - ' + schedule.endTime,
                                      //                   style: TextStyle(
                                      //                       fontSize: 12,
                                      //                       fontFamily: 'PlusJakartaSans',
                                      //                       fontWeight: FontWeight.bold,
                                      //                       color: Colors.white
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //
                                      //
                                      //
                                      //
                                      //           ))
                                      //           .toList(),
                                      //     ),
                                      //   ],
                                      // ),
                                      ExpansionTile(
                                        title: Text(
                                          'Experiences',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'PlusJakartaSans',
                                          ),
                                        ),
                                        tilePadding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        shape: Border.all(
                                            width: 0,
                                            color: Colors.transparent),
                                        iconColor: Colors.grey[800],
                                        expandedAlignment: Alignment.centerLeft,
                                        children: [
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 0,
                                            children: restaurantModel!
                                                .experiencesList
                                                .map((experience) => Chip(
                                                      label: Text(
                                                        experience ?? '',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'PlusJakartaSans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 0),
                                                      backgroundColor:
                                                          Colors.green,
                                                      labelPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 2),
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                      Divider(color: AppColors.dividerColor),
                                      ExpansionTile(
                                        title: Text(
                                          'Entertainment',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'PlusJakartaSans',
                                          ),
                                        ),
                                        tilePadding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        shape: Border.all(
                                            width: 0,
                                            color: Colors.transparent),
                                        iconColor: Colors.grey[800],
                                        expandedAlignment: Alignment.centerLeft,
                                        children: [
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 0,
                                            children: restaurantModel!
                                                .entertainmentList
                                                .map((entertainment) => Chip(
                                                      label: Text(
                                                        entertainment ?? '',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'PlusJakartaSans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 0),
                                                      backgroundColor:
                                                          Colors.green,
                                                      labelPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 2),
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                      Divider(color: AppColors.dividerColor),
                                      ExpansionTile(
                                        title: Text(
                                          'Vibes',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'PlusJakartaSans',
                                          ),
                                        ),
                                        tilePadding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        shape: Border.all(
                                            width: 0,
                                            color: Colors.transparent),
                                        iconColor: Colors.grey[800],
                                        expandedAlignment: Alignment.centerLeft,
                                        children: [
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 0,
                                            children: restaurantModel!.vibesList
                                                .map((vibe) => Chip(
                                                      label: Text(
                                                        vibe ?? '',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'PlusJakartaSans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 0),
                                                      backgroundColor:
                                                          Colors.green,
                                                      labelPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 2),
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                      Divider(color: AppColors.dividerColor),
                                      // InkWell(
                                      //   onTap: () => atmExpand.toggle(),
                                      //   child: Container(
                                      //     padding: EdgeInsets.all(16),
                                      //     child: Row(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.spaceBetween,
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.center,
                                      //         children: [
                                      //           Text(
                                      //             'Atmosphere',
                                      //             style: TextStyle(
                                      //               fontSize: 14,
                                      //               fontWeight: FontWeight.w500,
                                      //               fontFamily: 'PlusJakartaSans',
                                      //             ),
                                      //           ),
                                      //           Icon(Icons.chevron_right, size: 14)
                                      //         ]),
                                      //   ),
                                      // ),
                                      ExpansionTile(
                                        title: Text(
                                          'Atmosphere',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'PlusJakartaSans',
                                          ),
                                        ),
                                        tilePadding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        shape: Border.all(
                                            width: 0,
                                            color: Colors.transparent),
                                        iconColor: Colors.grey[800],
                                        expandedAlignment: Alignment.centerLeft,
                                        children: [
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 0,
                                            children: restaurantModel!
                                                .atmosphereList
                                                .map((atm) => Chip(
                                                      label: Text(
                                                        atm ?? '',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'PlusJakartaSans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 0),
                                                      backgroundColor:
                                                          Colors.green,
                                                      labelPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 2),
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                      Divider(color: AppColors.dividerColor),
                                      // InkWell(
                                      //   onTap: () => facExpand.toggle(),
                                      //   child: Container(
                                      //     padding: EdgeInsets.all(16),
                                      //     child: Row(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.spaceBetween,
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.center,
                                      //         children: [
                                      //           Text(
                                      //             'Facilities',
                                      //             style: TextStyle(
                                      //               fontSize: 14,
                                      //               fontWeight: FontWeight.w500,
                                      //               fontFamily: 'PlusJakartaSans',
                                      //             ),
                                      //           ),
                                      //           Icon(Icons.chevron_right, size: 14)
                                      //         ]),
                                      //   ),
                                      // ),
                                      ExpansionTile(
                                        title: Text(
                                          'Facilities',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'PlusJakartaSans',
                                          ),
                                        ),
                                        tilePadding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        shape: Border.all(
                                            width: 0,
                                            color: Colors.transparent),
                                        iconColor: Colors.grey[800],
                                        expandedAlignment: Alignment.centerLeft,
                                        children: [
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 0,
                                            children: restaurantModel!
                                                .facilityList
                                                .map((fac) => Chip(
                                                      label: Text(
                                                        fac ?? '',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'PlusJakartaSans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 0),
                                                      backgroundColor:
                                                          Colors.green,
                                                      labelPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 2),
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                      Divider(color: AppColors.dividerColor),
                                      ExpansionTile(
                                        title: Text(
                                          'Cuisines',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'PlusJakartaSans',
                                          ),
                                        ),
                                        tilePadding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        shape: Border.all(
                                            width: 0,
                                            color: Colors.transparent),
                                        iconColor: Colors.grey[800],
                                        expandedAlignment: Alignment.centerLeft,
                                        children: [
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 0,
                                            children: restaurantModel!.menuList
                                                .map((menu) => Chip(
                                                      label: Text(
                                                        menu.cuisineType ?? '',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'PlusJakartaSans',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 0),
                                                      backgroundColor:
                                                          Colors.green,
                                                      labelPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 2),
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                      Divider(color: AppColors.dividerColor),
                                      // const SizedBox(height: 16),
                                      // GestureDetector(
                                      //   onTap: () {},
                                      //   child: Container(
                                      //     padding: EdgeInsets.symmetric(
                                      //         horizontal: 16, vertical: 12),
                                      //     decoration: BoxDecoration(
                                      //       color: Colors.transparent,
                                      //       borderRadius: BorderRadius.circular(10),
                                      //     ),
                                      //     child: Text(
                                      //       'Reset',
                                      //       style: TextStyle(
                                      //         fontSize: 14,
                                      //         fontWeight: FontWeight.w500,
                                      //         fontFamily: 'PlusJakartaSans',
                                      //         color: Colors.green,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // )
                                    ]),
                                  )
                                : tabIndex.value == 2
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        child: Column(children: [
                                          SizedBox(
                                            height: 256,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              clipBehavior: Clip.hardEdge,
                                              child: GoogleMap(
                                                initialCameraPosition:
                                                    CameraPosition(
                                                  target: LatLng(
                                                      restaurantModel!.latitude,
                                                      restaurantModel!
                                                          .longitude),
                                                  zoom: 14,
                                                ),
                                                markers: {
                                                  Marker(
                                                    markerId: MarkerId('1'),
                                                    position: LatLng(
                                                        restaurantModel!
                                                            .latitude,
                                                        restaurantModel!
                                                            .longitude),
                                                  )
                                                },
                                                zoomControlsEnabled: false,
                                                myLocationEnabled: true,
                                                myLocationButtonEnabled: false,
                                                mapType: MapType.normal,
                                                gestureRecognizers: {
                                                  Factory<OneSequenceGestureRecognizer>(
                                                      () =>
                                                          EagerGestureRecognizer()),
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 32),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 2),
                                                        child: Image.asset(
                                                            'assets/icons/location.png',
                                                            height: 12,
                                                            width: 12)),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        '${restaurantModel?.address ?? ''}, ${restaurantModel?.city ?? ''}${restaurantModel == null ? '' : restaurantModel?.state == '' ? '' : ', ${restaurantModel!.state}'}, ${restaurantModel?.country ?? ''}${restaurantModel == null || restaurantModel!.zipCode == '' ? '' : ', ${restaurantModel!.zipCode}'}', // '304 Liverpool Blvd, Portsmouth, CA 30103',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'PlusJakartaSans',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 24),
                                              FutureBuilder(
                                                future: getCurrentLocation(
                                                        context)
                                                    .then((position) =>
                                                        Geolocator
                                                            .distanceBetween(
                                                          position.latitude,
                                                          position.longitude,
                                                          restaurantModel!
                                                              .latitude,
                                                          restaurantModel!
                                                              .longitude,
                                                        ) /
                                                        1000),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Text(
                                                      'Calculating...',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: GoogleFonts
                                                                .plusJakartaSans()
                                                            .fontFamily,
                                                        color: const Color
                                                            .fromRGBO(
                                                            142, 142, 147, 1),
                                                      ),
                                                    );
                                                  }

                                                  if (snapshot.hasError) {
                                                    print(
                                                        'Error retrieving location: ${snapshot.error}');
                                                    return Text(
                                                      '',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            'PlusJakartaSans',
                                                        color: Colors.grey[400],
                                                      ),
                                                    );
                                                  }

                                                  return Text(
                                                    snapshot.hasData
                                                        ? '${snapshot.data!.toStringAsFixed(2)} km away'
                                                        : 'Unknown',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'PlusJakartaSans',
                                                      color: Colors.grey[400],
                                                    ),
                                                  );
                                                },
                                              ),
                                              // FutureBuilder(
                                              //   future: getCurrentLocation(context).then((position) =>
                                              //   Geolocator.distanceBetween(
                                              //     position.latitude,
                                              //     position.longitude,
                                              //     restaurantModel!.latitude,
                                              //     restaurantModel!.longitude,
                                              //   ) /
                                              //       1000),
                                              //   builder: (context, snapshot) {
                                              //
                                              //     if (snapshot.connectionState == ConnectionState.waiting) {
                                              //       return Text(
                                              //         'Calculating...',
                                              //         style: TextStyle(
                                              //           fontSize: 12,
                                              //           fontWeight: FontWeight.w500,
                                              //           fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                              //           color: const Color.fromRGBO(142, 142, 147, 1),
                                              //         ),
                                              //       );
                                              //     }
                                              //
                                              //     return Text(
                                              //       snapshot.hasData
                                              //           ? '${snapshot.data!.toStringAsFixed(1)} km away'
                                              //           : 'Unknown',
                                              //       style: TextStyle(
                                              //         fontSize: 14,
                                              //         fontWeight: FontWeight.w500,
                                              //         fontFamily: 'PlusJakartaSans',
                                              //         color: Colors.grey[400],
                                              //       ),
                                              //     );
                                              //   }
                                              // ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 2),
                                                child: Image.asset(
                                                    'assets/icons/time.png',
                                                    height: 12,
                                                    width: 12),
                                              ),
                                              const SizedBox(width: 8),
                                              Obx(() {
                                                final controller = Get.find<
                                                    HomeLocationController>();
                                                final operatingHours = controller
                                                        .operatingHoursCache[
                                                    restaurantModel!.docID];
                                                final isFetching = controller
                                                    .fetchingOperatingHours
                                                    .contains(
                                                        restaurantModel!.docID);
                                                final currentDay =
                                                    DateFormat('EEEE')
                                                        .format(DateTime.now());

                                                if (operatingHours == null ||
                                                    operatingHours[
                                                            currentDay] ==
                                                        null) {
                                                  if (!isFetching) {
                                                    controller
                                                        .getOperatingHours(
                                                            restaurantModel!
                                                                .docID,
                                                            triggerFilterUpdate:
                                                                false);
                                                  }
                                                  return Text(
                                                    isFetching
                                                        ? 'Retrieving...'
                                                        : 'Not mentioned',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'PlusJakartaSans',
                                                      color:
                                                          const Color.fromRGBO(
                                                              142, 142, 147, 1),
                                                    ),
                                                  );
                                                }

                                                if (operatingHours.isEmpty) {
                                                  return Text(
                                                    'Not mentioned',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'PlusJakartaSans',
                                                    ),
                                                  );
                                                }

                                                final dayHours =
                                                    operatingHours[currentDay]!;
                                                // Use the new method to get current operating hours
                                                final hoursText = controller
                                                    .getDisplayHours(dayHours);
                                                final isOpen = controller
                                                    .isRestaurantOpen(dayHours);

                                                return Row(
                                                  children: [
                                                    Text(
                                                      hoursText,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            'PlusJakartaSans',
                                                        color: isOpen
                                                            ? Colors.green
                                                            : const Color
                                                                .fromRGBO(142,
                                                                142, 147, 1),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      isOpen
                                                          ? 'Open now'
                                                          : 'Closed now',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            'PlusJakartaSans',
                                                        color: isOpen
                                                            ? Colors.green
                                                            : Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                            ],
                                          ),
                                          const SizedBox(height: 32),
                                          GestureDetector(
                                            onTap: () async {
                                              MapsLauncher.launchCoordinates(
                                                restaurantModel!.latitude,
                                                restaurantModel!.longitude,
                                                restaurantModel!.resName,
                                              );

                                              // final availableMaps = await ml.MapLauncher.installedMaps;
                                              //
                                              // await availableMaps.first.showDirections(
                                              //   destination: ml.Coords(restaurantModel!.latitude, restaurantModel!.longitude),
                                              //   destinationTitle: restaurantModel!.resName,
                                              // );
                                            },
                                            child: CustomButton(
                                              laBelText: 'Get Directions',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'PlusJakartaSans',
                                              textColor: Colors.white,
                                              containerColor:
                                                  AppColors.primaryColor,
                                              height: 32,
                                              radius: BorderRadius.circular(15),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          GestureDetector(
                                            onTap: () async {
                                              // Copy text to clipboard
                                              await Clipboard.setData(ClipboardData(
                                                  text:
                                                      '${restaurantModel?.address ?? ''}, ${restaurantModel?.city ?? ''}, ${restaurantModel?.state}, ${restaurantModel?.country ?? ''}${restaurantModel == null || restaurantModel!.zipCode == '' ? '' : ', ${restaurantModel!.zipCode}'}'));
                                              // Show a snackbar to confirm the action
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Text copied to clipboard!')),
                                              );
                                            },
                                            child: CustomButton(
                                              laBelText: 'Copy Address',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'PlusJakartaSans',
                                              textColor: Colors.black,
                                              containerColor: AppColors
                                                  .secondaryColor
                                                  .withOpacity(0.4),
                                              height: 32,
                                              radius: BorderRadius.circular(15),
                                            ),
                                          ),
                                        ]),
                                      )
                                    : tabIndex.value == 3
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Obx(() {
                                                    if (vc.videos.isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No media available'));
                                                    }

                                                    return GridView.builder(
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                        crossAxisSpacing: 8,
                                                        childAspectRatio:
                                                            110 / 120,
                                                        mainAxisSpacing: 8,
                                                      ),
                                                      itemCount:
                                                          vc.videos.length,
                                                      shrinkWrap: true,
                                                      primary: false,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final media =
                                                            vc.videos[index];

                                                        // Trigger thumbnail only for videos (already handled in controller)

                                                        return GestureDetector(
                                                          onTap: () async {
                                                            // Get.back();
                                                            await Navigator
                                                                .push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    FullVideoScreen(
                                                                        video:
                                                                            media), // Renamed screen and param
                                                              ),
                                                            );
                                                          },
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              AspectRatio(
                                                                aspectRatio:
                                                                    110 / 120,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child: media.mediaType ==
                                                                          'video'
                                                                      ? Obx(() => vc.thumbnailPaths[index] !=
                                                                              null
                                                                          ? Image
                                                                              .file(
                                                                              File(vc.thumbnailPaths[index]!),
                                                                              fit: BoxFit.cover,
                                                                              errorBuilder: (context, error, stackTrace) => Container(
                                                                                color: Colors.grey[300],
                                                                                child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                                                              ),
                                                                            )
                                                                          : Image
                                                                              .network(
                                                                              'https://via.placeholder.com/640x360',
                                                                              fit: BoxFit.cover,
                                                                              loadingBuilder: (context, child, loadingProgress) {
                                                                                if (loadingProgress == null) return child;
                                                                                return const Center(child: CircularProgressIndicator());
                                                                              },
                                                                              errorBuilder: (context, error, stackTrace) => Container(
                                                                                color: Colors.grey[300],
                                                                                child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                                                              ),
                                                                            ))
                                                                      : Image
                                                                          .network(
                                                                          media
                                                                              .url!,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          loadingBuilder: (context,
                                                                              child,
                                                                              loadingProgress) {
                                                                            if (loadingProgress ==
                                                                                null)
                                                                              return child;
                                                                            return const Center(child: CircularProgressIndicator());
                                                                          },
                                                                          errorBuilder: (context, error, stackTrace) =>
                                                                              Container(
                                                                            color:
                                                                                Colors.grey[300],
                                                                            child: const Icon(Icons.broken_image,
                                                                                size: 50,
                                                                                color: Colors.grey),
                                                                          ),
                                                                        ),
                                                                ),
                                                              ),
                                                              if (media
                                                                      .mediaType ==
                                                                  'video') // Only show play icon for videos
                                                                Positioned.fill(
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Icon(
                                                                      Icons
                                                                          .play_circle_fill_rounded,
                                                                      size: 60,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }),
                                                ]),
                                          )
                                        : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'dart:ui';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:kaistable_website/main.dart';
// import 'package:kaistable_website/models/restaurant_model.dart';
// import 'package:kaistable_website/screens/home_screen/events_screen/events_details_screen/event_details_gallary.dart';
// import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
// import 'package:kaistable_website/screens/nav_bar/widgets/custom_button.dart';
// import 'package:kaistable_website/screens/restaurant_detail_screens/widget/map_widget.dart';
// import 'package:kaistable_website/screens/restaurant_detail_screens/widget/restaurant_details_widget.dart';
// import 'package:kaistable_website/screens/restaurant_detail_screens/widget/review_widget.dart';
// import 'package:kaistable_website/utils/responsive.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:video_player/video_player.dart';
//
// import '../../../constants/app_colors.dart';
// import '../home_screen/location_pages/location_controller/location_list_controller.dart';
// import 'controller/restaurant_detail_controller.dart';
// import 'controller/restaurant_video_controller.dart';
// import 'widget/about_section_widget.dart';
//
//
// class RestaurantDetailScreen extends StatelessWidget {
//   List<String>? happyList;
//   RestaurantModel? restaurantModel;
//
//   RestaurantDetailScreen({super.key, this.happyList, this.restaurantModel});
//
//   RxInt tabIndex = 0.obs;
//   RestaurantVideoController vc = Get.put(RestaurantVideoController());
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.only(left: 24, top: 24, right: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       restaurantModel!.resName,
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'PlusJakartaSans',
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           '4.6',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: 'PlusJakartaSans',
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         SizedBox(
//                           height: 10,
//                           child: RatingBar(
//                             itemSize: 10,
//                             ignoreGestures: true,
//                             initialRating: 5,
//                             minRating: 1,
//                             direction: Axis.horizontal,
//                             allowHalfRating: true,
//                             itemCount: 5,
//                             ratingWidget: RatingWidget(
//                               full: Image.asset(
//                                 'assets/images/star yellow.png',
//                                 height: 14,
//                                 color: Colors.yellow[600],
//                               ),
//                               half: Image.asset(
//                                 'assets/images/star yellow.png',
//                                 height: 14,
//                                 color: Colors.yellow[600],
//                               ),
//                               empty: Image.asset(
//                                 'assets/images/star_empty.png',
//                                 height: 14,
//                                 color: const Color(0xFFBBBBBB),
//                               ),
//                             ),
//                             itemPadding: const EdgeInsets.only(left: 2.0),
//                             onRatingUpdate: (rating) {
//                               print(rating);
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 2),
//                           child: Image.asset('assets/icons/car.png',
//                             height: 12,
//                             width: 12,
//                           ),
//                         ),
//                         Text(
//                           '   3.5 miles',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: 'PlusJakartaSans',
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Restaurant',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'PlusJakartaSans',
//                         color: Colors.grey[400],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 28),
//                 Row(
//                   children: [
//                     ClipRRect(
//                       clipBehavior: Clip.hardEdge,
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.asset('assets/images/restaurant_detail_img1.png', height: 246, width: (Get.width-24-24-8)/2, fit: BoxFit.cover,),
//                     ),
//                     const SizedBox(width: 8),
//                     Column(
//                       children: [
//                         ClipRRect(
//                           clipBehavior: Clip.hardEdge,
//                           borderRadius: BorderRadius.circular(10),
//                           child: Image.asset('assets/images/restaurant_detail_img2.png', height: (246 - 8)/2, width: (Get.width-24-24-8)/2, fit: BoxFit.cover,),
//                         ),
//                         const SizedBox(height: 8),
//                         ClipRRect(
//                           clipBehavior: Clip.hardEdge,
//                           borderRadius: BorderRadius.circular(10),
//                           child: Image.asset('assets/images/restaurant_detail_img3.png', height: (246 - 8)/2, width: (Get.width-24-24-8)/2, fit: BoxFit.cover,),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//
//             TabBar(
//                 tabs: [
//                   Tab(text: 'Info'),
//                   Tab(text: 'Filter'),
//                   Tab(text: 'Map'),
//                   Tab(text: 'Videos'),
//                 ],
//                 onTap: (index){
//                   tabIndex.value = index;
//                 },
//                 labelColor: Colors.green,
//                 unselectedLabelColor: Colors.grey,
//                 indicatorColor: Colors.green,
//                 tabAlignment: TabAlignment.fill,
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 labelStyle: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   fontFamily: 'PlusJakartaSans',
//                 ),
//               ),
//                 // // Replaced TabBar with a row of buttons for navigation
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 //   children: [
//                 //     ElevatedButton(
//                 //       onPressed: () {},
//                 //       style: ElevatedButton.styleFrom(
//                 //         backgroundColor: Colors.white,
//                 //         foregroundColor: Colors.green,
//                 //         side: BorderSide(color: Colors.green),
//                 //       ),
//                 //       child: Text('Info'),
//                 //     ),
//                 //     ElevatedButton(
//                 //       onPressed: () {},
//                 //       style: ElevatedButton.styleFrom(
//                 //         backgroundColor: Colors.white,
//                 //         foregroundColor: Colors.grey,
//                 //         side: BorderSide(color: Colors.grey),
//                 //       ),
//                 //       child: Text('Filter'),
//                 //     ),
//                 //     ElevatedButton(
//                 //       onPressed: () {},
//                 //       style: ElevatedButton.styleFrom(
//                 //         backgroundColor: Colors.white,
//                 //         foregroundColor: Colors.grey,
//                 //         side: BorderSide(color: Colors.grey),
//                 //       ),
//                 //       child: Text('Map'),
//                 //     ),
//                 //     ElevatedButton(
//                 //       onPressed: () {},
//                 //       style: ElevatedButton.styleFrom(
//                 //         backgroundColor: Colors.white,
//                 //         foregroundColor: Colors.grey,
//                 //         side: BorderSide(color: Colors.grey),
//                 //       ),
//                 //       child: Text('Videos'),
//                 //     ),
//                 //   ],
//                 // ),
//                 // Info Container
//                 Obx(()=>
//                 tabIndex.value == 0 ? Container(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 10),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             border: Border.all(
//                               color: Colors.black.withOpacity(0.04)
//                             )
//                           ),
//                           child: Text(
//                             'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore.',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: 'PlusJakartaSans',
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Divider(color: AppColors.dividerColor),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: [
//                             Padding(
//                                 padding: EdgeInsets.only(top: 2),
//                                 child: Image.asset('assets/icons/location.png', height: 12, width: 12)),
//                             const SizedBox(width: 8),
//                             // Icon(Icons.location_on, color: Colors.green),
//                             Text('304 Liverpool Blvd, Portsmouth, CA 30103',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: 'PlusJakartaSans',
//                               ),),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Divider(color: AppColors.dividerColor),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(top: 2),
//                               child: Image.asset('assets/icons/time.png', height: 12, width: 12),
//                             ),
//                             const SizedBox(width: 8),
//                             // Icon(Icons.access_time, color: Colors.green),
//                             Text('Open',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: 'PlusJakartaSans',
//                                 color: Colors.green,
//                               ),),
//                             Text('        Closes 10PM',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: 'PlusJakartaSans',
//                               ),),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Divider(color: AppColors.dividerColor),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(top: 2),
//                               child: Image.asset('assets/icons/site.png', height: 12, width: 12),
//                             ),
//                             const SizedBox(width: 8),
//                             // Icon(Icons.language, color: Colors.green),
//                             Text('www.website.com',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: 'PlusJakartaSans',
//                               ),),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Divider(color: AppColors.dividerColor),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(top: 2),
//                               child: Image.asset('assets/icons/cuisine.png', height: 12, width: 12),
//                             ),
//                             const SizedBox(width: 8),
//                             // Icon(Icons.restaurant_outlined, color: Colors.green),
//                             Text('Cuisine',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: 'PlusJakartaSans',
//                               ),),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Divider(color: AppColors.dividerColor),
//                       ],
//                     ),
//                   ) :
//                 tabIndex.value == 1 ? Container(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   child: Column(
//                       children: [
//                     InkWell(
//                       onTap:(){},
//                       child: Container(
//                         padding: EdgeInsets.all(16),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Experiences',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: 'PlusJakartaSans',
//                               ),
//                             ),
//                             Icon(Icons.chevron_right, size: 14)
//                           ]
//                         ),
//                       ),
//                     ),
//                     Divider(color: AppColors.dividerColor),
//                     InkWell(
//                       onTap:(){},
//                       child: Container(
//                         padding: EdgeInsets.all(16),
//                         child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Vibes',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   fontFamily: 'PlusJakartaSans',
//                                 ),
//                               ),
//                               Icon(Icons.chevron_right, size: 14)
//                             ]
//                         ),
//                       ),
//                     ),
//                     Divider(color: AppColors.dividerColor),
//                     InkWell(
//                       onTap:(){},
//                       child: Container(
//                         padding: EdgeInsets.all(16),
//                         child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Atmosphere',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   fontFamily: 'PlusJakartaSans',
//                                 ),
//                               ),
//                               Icon(Icons.chevron_right, size: 14)
//                             ]
//                         ),
//                       ),
//                     ),
//                     Divider(color: AppColors.dividerColor),
//                     InkWell(
//                       onTap:(){},
//                       child: Container(
//                         padding: EdgeInsets.all(16),
//                         child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Facilities',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   fontFamily: 'PlusJakartaSans',
//                                 ),
//                               ),
//                               Icon(Icons.chevron_right, size: 14)
//                             ]
//                         ),
//                       ),
//                     ),
//                     Divider(color: AppColors.dividerColor),
//                     const SizedBox(height: 16),
//                     GestureDetector(
//                       onTap: (){},
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         decoration: BoxDecoration(
//                           color: Colors.transparent,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text('Reset', style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'PlusJakartaSans',
//                           color: Colors.green,
//                         ),),
//                       ),
//                     )
//                   ]),
//                 ) :
//                 tabIndex.value == 2 ? Container(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 256,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           clipBehavior: Clip.hardEdge,
//                           child: GoogleMap(
//                             initialCameraPosition: const CameraPosition(
//                               target: LatLng(40.7128, -74.0060),
//                               zoom: 14,
//                             ),
//                             markers: {
//                               Marker(
//                                 markerId: MarkerId('1'),
//                                 position: LatLng(40.7128, -74.0060),
//                               )
//                             },
//                             zoomControlsEnabled: false,
//                             myLocationEnabled: true,
//                             myLocationButtonEnabled: false,
//                             mapType: MapType.normal,
//                             gestureRecognizers: {
//                               Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
//                             },
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 32),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Row(
//                               children: [
//                                 Padding(
//                                     padding: EdgeInsets.only(top: 2),
//                                     child: Image.asset('assets/icons/location.png', height: 12, width: 12)),
//                                 const SizedBox(width: 8),
//                                 // Icon(Icons.location_on, color: Colors.green),
//                                 Expanded(
//                                   child: Text('304 Liverpool Blvd, Portsmouth, CA 30103',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                       fontFamily: 'PlusJakartaSans',
//                                     ),),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 24),
//                           Text('3.5 km away',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: 'PlusJakartaSans',
//                               color: Colors.grey[400],
//                             ),),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(top: 2),
//                             child: Image.asset('assets/icons/time.png', height: 12, width: 12),
//                           ),
//                           const SizedBox(width: 8),
//                           // Icon(Icons.access_time, color: Colors.green),
//                           Text('6PM-9PM',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: 'PlusJakartaSans',
//                             ),),
//                           Text('        Closed now',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: 'PlusJakartaSans',
//                               color: Colors.red,
//                             ),),
//                         ],
//                       ),
//                       const SizedBox(height: 32),
//                       CustomButton(
//                         laBelText: 'Get Directions',
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'PlusJakartaSans',
//                         textColor: Colors.white,
//                         containerColor: AppColors.primaryColor,
//                         height: 32,
//                         radius: BorderRadius.circular(15),
//                       ),
//                       const SizedBox(height: 16),
//                       CustomButton(
//                         laBelText: 'Copy Address',
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'PlusJakartaSans',
//                         textColor: Colors.black,
//                         containerColor: AppColors.secondaryColor.withOpacity(0.4),
//                         height: 32,
//                         radius: BorderRadius.circular(15),
//                       ),
//                     ]
//                   ),
//                 ) :
//                 tabIndex.value == 3 ? Container(
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                     Obx(() {
//                       if (vc.videos.isEmpty) {
//                         return const Center(child: Text('No videos available'));
//                       }
//
//                       return GridView.builder(
//                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 3,
//                             crossAxisSpacing: 8,
//                             childAspectRatio: 110/120,
//                             mainAxisSpacing: 8,
//                           ),
//                           itemCount: vc.videos.length,
//                           shrinkWrap: true,
//                           primary: false,
//                           itemBuilder: (context, index){
//
//                             final String? video = vc.videos[index].url;
//                             bool isPlaying = vc.playingIndex.value == index;
//
//                             // Trigger thumbnail generation
//                             if (vc.thumbnailPaths[index] == null &&
//                                 video != null &&
//                                 video.isNotEmpty) {
//                               vc.generateThumbnail(index, video);
//                             }
//
//                             return Stack(
//                                 alignment: Alignment.center,
//                                 children: [
//                                   AspectRatio(
//                                     aspectRatio: 16 / 9,
//                                     child: isPlaying &&
//                                         vc.playerController != null &&
//                                         vc.playerController!.value.isInitialized
//                                         ? VideoPlayer(vc.playerController!)
//                                         : Obx(() {
//                                       return vc.thumbnailPaths[index] != null
//                                           ? Image.file(
//                                         File(vc.thumbnailPaths[index]!),
//                                         fit: BoxFit.cover,
//                                         // errorBuilder: (context, error, stackTrace) => Image.network(
//                                         //   'https://via.placeholder.com/640x360',
//                                         //   fit: BoxFit.cover,
//                                         //   loadingBuilder: (context, child, loadingProgress) {
//                                         //     if (loadingProgress == null) return child;
//                                         //     return const Center(child: CircularProgressIndicator());
//                                         //   },
//                                         //   errorBuilder: (context, error, stackTrace) => Container(
//                                         //     color: Colors.grey[300],
//                                         //     child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
//                                         //   ),
//                                         // ),
//                                       )
//                                           : Image.network(
//                                         'https://via.placeholder.com/640x360',
//                                         fit: BoxFit.cover,
//                                         loadingBuilder: (context, child, loadingProgress) {
//                                           if (loadingProgress == null) return child;
//                                           return const Center(child: CircularProgressIndicator());
//                                         },
//                                         errorBuilder: (context, error, stackTrace) => Container(
//                                           color: Colors.grey[300],
//                                           child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
//                                         ),
//                                       );
//                                     }),
//                                   ),
//                                   Positioned.fill(
//                                     child: Align(
//                                       alignment: Alignment.center,
//                                       child: IconButton(
//                                         iconSize: 60,
//                                         color: Colors.white,
//                                         icon: Icon(
//                                           isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
//                                         ),
//                                         onPressed: () => vc.playVideo(index),
//                                       ),
//                                     ),
//                                   ),
//                                   if (isPlaying &&
//                                       vc.playerController != null &&
//                                       !vc.playerController!.value.isInitialized)
//                                     const Positioned.fill(
//                                       child: Center(child: CircularProgressIndicator()),
//                                     ),
//                                 ],
//                             );
//                               // ClipRRect(
//                               //   borderRadius: BorderRadius.circular(10),
//                               //   clipBehavior: Clip.hardEdge,
//                               //   child: Image.asset('assets/images/restaurant_detail_img2.png', /*height: (246 - 8)/2, width: (Get.width-24-24-8)/2,*/ fit: BoxFit.cover,));
//                           });
//                   }),
//                   ]),
//                 )
//                     : const SizedBox(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class RestaurantDetailScreen extends StatelessWidget {
//   List<String>? happyList;
//   RestaurantModel? restaurantModel;
//
//   RestaurantDetailScreen({super.key, this.happyList, this.restaurantModel});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 24, top: 24, right: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       restaurantModel!.resName,
//                       style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.w600,
//                         fontFamily: 'PlusJakartaSans',
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 2),
//                           child: Image.asset('assets/images/car.png',
//                             height: 12,
//                             width: 12,
//                           ),
//                         ),
//                         Text(
//                           '   3.5 miles',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: 'PlusJakartaSans',),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Restaurant',
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'PlusJakartaSans',
//                           color: Colors.grey[400]),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 28),
//                 Row(
//                   children: [
//                     ClipRRect(
//                         clipBehavior: Clip.hardEdge,
//                         borderRadius: BorderRadiusGeometry.circular(10),
//                         child: Image.asset('assets/images/restaurant_detail_img1.png', height: 246, width: (Get.width-24-24-8)/2, fit: BoxFit.cover,)),
//                     const SizedBox(width: 8),
//                     Column(
//                       children: [
//                         ClipRRect(
//                             clipBehavior: Clip.hardEdge,
//                             borderRadius: BorderRadiusGeometry.circular(10),
//                             child: Image.asset('assets/images/restaurant_detail_img2.png', height: (246 - 8)/2, width: (Get.width-24-24-8)/2, fit: BoxFit.cover,)),
//                         const SizedBox(height: 8),
//                         ClipRRect(
//                             clipBehavior: Clip.hardEdge,
//                             borderRadius: BorderRadiusGeometry.circular(10),
//                             child: Image.asset('assets/images/restaurant_detail_img3.png', height: (246 - 8)/2, width: (Get.width-24-24-8)/2, fit: BoxFit.cover,)),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//                 TabBar(
//                   tabs: [
//                     Tab(text: 'Info'),
//                     Tab(text: 'Filter'),
//                     Tab(text: 'Map'),
//                     Tab(text: 'Videos'),
//                   ],
//                   labelColor: Colors.green,
//                   unselectedLabelColor: Colors.grey,
//                   indicatorColor: Colors.green,
//                   tabAlignment: TabAlignment.fill,
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   labelStyle: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     fontFamily: 'PlusJakartaSans',
//                   ),
//                 ),
//                 TabBarView(children: [
//                   const SizedBox(),
//                   const SizedBox(),
//                   const SizedBox(),
//                   const SizedBox(),
//                 ]),
//                 Expanded(
//                   child: ListView(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(height: 10),
//                             Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore.'),
//                             SizedBox(height: 10),
//                             Row(
//                               children: [
//                                 Icon(Icons.location_on, color: Colors.green),
//                                 Text('304 Liverpool Blvd, Portsmouth, CA 30103'),
//                               ],
//                             ),
//                             SizedBox(height: 10),
//                             Row(
//                               children: [
//                                 Icon(Icons.access_time, color: Colors.green),
//                                 Text('Open  Closes 10PM'),
//                               ],
//                             ),
//                             SizedBox(height: 10),
//                             Row(
//                               children: [
//                                 Icon(Icons.language, color: Colors.green),
//                                 Text('www.website.com'),
//                               ],
//                             ),
//                             SizedBox(height: 10),
//                             Row(
//                               children: [
//                                 Icon(Icons.restaurant, color: Colors.green),
//                                 Text('Cuisine'),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class RestaurantDetailScreen extends StatefulWidget {
//   List<String>? happyList;
//   RestaurantModel? restaurantModel;
//
//   RestaurantDetailScreen({super.key, this.happyList, this.restaurantModel});
//
//   @override
//   State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
// }
//
// class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
//   final controller = Get.put(RestaurantDetailController());
//
//   final LocationListController locationController = LocationListController();
//
//   final HomeLocationController homeLocationController =
//       Get.put(HomeLocationController());
//   @override
//   void initState() {
//     homeLocationController.addRecentView(
//         restaurantID: widget.restaurantModel?.docID ?? '',
//         resName: widget.restaurantModel?.resName ?? '');
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       int indexOfMenuPersentageOff = 0;
//       int indexOfMenuHappyHourOff = 0;
//
//       indexOfMenuPersentageOff =
//           homeLocationController.selectedPersentage.indexOf(true);
//       indexOfMenuHappyHourOff =
//           homeLocationController.selectedHappyhour.indexOf(true);
//       bool _isCommingSoon = widget.restaurantModel?.resEmail == '' ||
//           (widget.restaurantModel?.resEmail.isEmpty ?? true);
//       print('widget.restaurantModel?.resEmail ${_isCommingSoon}');
//       return WillPopScope(
//           onWillPop: () async {
//             Get.back();
//             return false;
//           },
//           child: Scaffold(
//             backgroundColor: AppColors.bgColor,
//             appBar: AppBar(
//               backgroundColor: AppColors.bgColor,
//               iconTheme: const IconThemeData(
//                 color: AppColors.primaryColor,
//               ),
//               centerTitle: true,
//               automaticallyImplyLeading: true,
//               leading: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Container(
//                   height: 16,
//                   width: 16,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         spreadRadius: 1,
//                         blurRadius: 3,
//                         offset: const Offset(0, 1),
//                       ),
//                     ],
//                   ),
//                   child: GestureDetector(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Icon(Icons.arrow_back, size: 18),
//                   ),
//                 ),
//               ),
//               actions: [
//                 auth.currentUser == null || widget.restaurantModel?.docID == ''
//                     ? SizedBox()
//                     : HomeLocationController().favoriteHeart(
//                         resturant_id: widget.restaurantModel?.docID),
//                 SizedBox(
//                   width: 12,
//                 )
//               ],
//               title: const Text(
//                 'Restaurant details',
//                 style: const TextStyle(
//                   fontSize: 17,
//                   color: AppColors.bottomSheetColor,
//                   fontWeight: FontWeight.w700,
//                   fontFamily: 'Nunito-Bold',
//                 ),
//               ),
//             ),
//             body: SingleChildScrollView(
//               child: Stack(children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     // Container(
//                     //   height: 200,
//                     //   width: Get.width,
//                     //   decoration: BoxDecoration(
//                     //       image: DecorationImage(
//                     //           fit: BoxFit.fitWidth,
//                     //           image: NetworkImage(
//                     //               widget.restaurantModel?.logoImage ?? ''))),
//                     // ),
//                     Stack(
//                       children: [
//                         Container(
//                           height: Get.height * 0.27,
//                           width: Get.width,
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   image: NetworkImage(
//                                       widget.restaurantModel!.logoImage),
//                                   fit: BoxFit.cover)),
//                         ),
//                         widget.restaurantModel?.imagesList.length == 0
//                             ? SizedBox()
//                             : Positioned(
//                                 bottom: 16,
//                                 left: 120,
//                                 child: ClipRRect(
//                                   // Prevents blur from overflowing
//                                   borderRadius: BorderRadius.circular(
//                                       4), // Same as container
//                                   child: BackdropFilter(
//                                     filter: ImageFilter.blur(
//                                         sigmaX: 8, sigmaY: 8), // Blur effect
//                                     child: GestureDetector(
//                                       onTap: () => Get.to(EventDetailsGallery(
//                                         imageList: widget
//                                                 .restaurantModel?.imagesList ??
//                                             [],
//                                       )),
//                                       child: Container(
//                                         height: 32,
//                                         width: 151,
//                                         decoration: BoxDecoration(
//                                           color: AppColors.whiteColor
//                                               .withOpacity(
//                                                   0.2), // Adjust opacity
//                                           borderRadius:
//                                               BorderRadius.circular(4),
//                                         ),
//                                         child: Center(
//                                           child: Text(
//                                             "Sell all ${widget.restaurantModel?.imagesList.length} photos", // Add text if needed
//                                             style: TextStyle(
//                                               color: AppColors.primaryColor,
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                       ],
//                     ),
//
//                     SizedBox(height: 30),
//                     Center(
//                       child: Container(
//                         width: 100,
//                         height: 36,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             // Instagram Icon
//                             GestureDetector(
//                               onTap: () async {
//                                 String link =
//                                     widget.restaurantModel?.instaLink ?? '';
//                                 if (link == '') {
//                                   Get.snackbar('Oops!', 'URl not available');
//                                 } else {
//                                   await launchUrl(
//                                     Uri.parse(link),
//                                   );
//                                 }
//                               },
//                               child: Image.asset(
//                                 "assets/images/instagram.png",
//                                 height: 20,
//                                 width: 20,
//                               ),
//                             ),
//
//                             GestureDetector(
//                               onTap: () async {
//                                 String link =
//                                     widget.restaurantModel?.tiktokLink ?? '';
//                                 if (link == '') {
//                                   Get.snackbar('Oops!', 'URl not available');
//                                 } else {
//                                   await launchUrl(
//                                     Uri.parse(link),
//                                   );
//                                 }
//                               },
//                               child: Image.asset(
//                                 "assets/images/tik-tok.png",
//                                 height: 22,
//                                 color: AppColors.primaryColor,
//                                 width: 22,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 18),
//                     // Column(
//                     //   children: [
//                     //     Padding(
//                     //       padding: const EdgeInsets.symmetric(horizontal: 16),
//                     //       child: Tabs(controller: controller),
//                     //     ),
//                     //   ],
//                     // ),
//                     // SizedBox(height: 2),
//                     // Obx(() {
//                     // return controller.selectedTop.value == 'Experience'
//                     //     ? Column(
//                     //         children: [
//                     //           SizedBox(
//                     //             height: 10,
//                     //           ),
//                     //           Padding(
//                     //             padding: const EdgeInsets.symmetric(
//                     //                 horizontal: 16.0),
//                     //             child: Table(
//                     //               border: TableBorder.all(
//                     //                   color: AppColors.tableBorderColor,
//                     //                   width: 2,
//                     //                   borderRadius:
//                     //                       BorderRadius.circular(10)),
//                     //               columnWidths: const {
//                     //                 0: FlexColumnWidth(1.3),
//                     //                 1: FlexColumnWidth(1.3),
//                     //                 2: FlexColumnWidth(1.3),
//                     //                 3: FlexColumnWidth(1.5),
//                     //                 4: FlexColumnWidth(1.8),
//                     //               },
//                     //               children: [
//                     //                 TableRow(
//                     //                   decoration: BoxDecoration(
//                     //                       color: AppColors.primaryColor
//                     //                           .withOpacity(0.2),
//                     //                       borderRadius:
//                     //                           BorderRadius.circular(10)),
//                     //                   children: [
//                     //                     buildHeaderCell(
//                     //                       "Name",
//                     //                     ),
//                     //                     buildHeaderCell("By"),
//                     //                     buildHeaderCell("Day"),
//                     //                     buildHeaderCell("Date"),
//                     //                     buildHeaderCell("Time"),
//                     //                   ],
//                     //                 ),
//                     //                 // Table data rows
//                     //                 ...widget.restaurantModel!
//                     //                     .entertainmentScheduleList
//                     //                     .map((data) {
//                     //                   return TableRow(
//                     //                     decoration: const BoxDecoration(
//                     //                       color: Colors
//                     //                           .white, // Row background color
//                     //                     ),
//                     //                     children: [
//                     //                       buildDataCell(data.eventName ?? ""),
//                     //                       buildDataCell(data.eventBy ?? ""),
//                     //                       buildDataCell(data.day ?? ""),
//                     //                       buildDataCell(data.date ?? ""),
//                     //                       buildDataCell(data.startTime +
//                     //                               ' - ' +
//                     //                               data.endTime ??
//                     //                           ""),
//                     //                     ],
//                     //                   );
//                     //                 }).toList(),
//                     //               ],
//                     //             ),
//                     //           ),
//                     //         ],
//                     //       )
//                     //     : controller.selectedTop.value == 'About'
//                     //         ?
//
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         AboutSectionWidget(
//                           aboutText: widget.restaurantModel?.about ?? '',
//                           resturantID: widget.restaurantModel?.docID ?? '',
//                         ),
//                         widget.restaurantModel!.entertainmentScheduleList
//                                 .isEmpty
//                             ? SizedBox()
//                             : Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 16.0, right: 16),
//                                     child: Text(
//                                       'Experience',
//                                       style: TextStyle(
//                                         color: AppColors.headingTextColor,
//                                         fontSize: Responsive.isMobile(context)
//                                             ? 20
//                                             : 28,
//                                         fontFamily: 'aftika-regular',
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 16.0),
//                                     child: Table(
//                                       border: TableBorder.all(
//                                           color: AppColors.tableBorderColor,
//                                           width: 2,
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       columnWidths: const {
//                                         0: FlexColumnWidth(1.3),
//                                         1: FlexColumnWidth(1.3),
//                                         2: FlexColumnWidth(1.3),
//                                         3: FlexColumnWidth(1.5),
//                                         4: FlexColumnWidth(1.8),
//                                       },
//                                       children: [
//                                         TableRow(
//                                           decoration: BoxDecoration(
//                                               color: const Color(0xff4ECCA3),
//                                               borderRadius:
//                                                   BorderRadius.circular(10)),
//                                           children: [
//                                             buildHeaderCell(
//                                               "Name",
//                                             ),
//                                             buildHeaderCell("By"),
//                                             buildHeaderCell("Day"),
//                                             buildHeaderCell("Date"),
//                                             buildHeaderCell("Time"),
//                                           ],
//                                         ),
//                                         // Table data rows
//                                         ...widget.restaurantModel!
//                                             .entertainmentScheduleList
//                                             .map((data) {
//                                           return TableRow(
//                                             decoration: const BoxDecoration(
//                                               color: Colors
//                                                   .white, // Row background color
//                                             ),
//                                             children: [
//                                               buildDataCell(
//                                                   data.eventName ?? ""),
//                                               buildDataCell(data.eventBy ?? ""),
//                                               buildDataCell(data.day ?? ""),
//                                               buildDataCell(data.date ?? ""),
//                                               buildDataCell(data.startTime +
//                                                       ' - ' +
//                                                       data.endTime ??
//                                                   ""),
//                                             ],
//                                           );
//                                         }).toList(),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                         widget.restaurantModel!.menuList.isEmpty ||
//                                 widget.restaurantModel!.menuList[0].foodImages
//                                     .isEmpty
//                             ? SizedBox()
//                             : SizedBox(
//                                 height: Get.height * 0.36,
//                                 width: double.infinity,
//                                 child: MenuWidget(
//                                   screenHeight: Get.height,
//                                   mobileView: true,
//                                   screenWidth: Get.width,
//                                   selectedMenuTypes: widget
//                                           .restaurantModel!.menuList.isEmpty
//                                       ? MenuModel(
//                                           cuisineType: '',
//                                           foodImages: [],
//                                           menuType: '')
//                                       : widget.restaurantModel!.menuList.first,
//                                   specialConditions:
//                                       widget.restaurantModel!.specialConditions,
//                                   uploadedImages: widget
//                                           .restaurantModel!.menuList.isNotEmpty
//                                       ? widget.restaurantModel!.menuList[0]
//                                           .foodImages
//                                       : [],
//                                 ),
//                               ),
//                         Column(
//                           children: [
//                             SizedBox(height: 12),
//                             Align(
//                               alignment: Alignment.topLeft,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 16.0, right: 16),
//                                 child: Text(
//                                   'Map',
//                                   style: TextStyle(
//                                     color: AppColors.headingTextColor,
//                                     fontSize: 17,
//                                     fontFamily: 'aftika-regular',
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 16),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 16.0, right: 16),
//                               child: Container(
//                                 width: Get.width,
//                                 decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10))),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       width: Get.width,
//                                       height: 500,
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(16)),
//                                       child: MapWidget(
//                                         lat: widget.restaurantModel?.latitude ??
//                                             0.0,
//                                         long:
//                                             widget.restaurantModel?.longitude ??
//                                                 0.0,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 40,
//                                     ),
//                                     MapDetailWidget(
//                                       restaurantModel: widget.restaurantModel!,
//                                       isCommingSoon: _isCommingSoon,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 50,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     // : controller.selectedTop.value == 'Reviews'
//                     //     ?
//                     // ReviewWidget(
//                     //   restaurantModel: widget.restaurantModel,
//                     // )
//
//                     // : Column(
//                     //     crossAxisAlignment:
//                     //         CrossAxisAlignment.start,
//                     //     children: [
//                     //       // (widget
//                     //       //             .restaurantModel!
//                     //       //             .menuList
//                     //       //             .happyHourSpecials
//                     //       //             .isEmpty &&
//                     //       //         widget.restaurantModel!.menuList
//                     //       //             .percentageOff.isEmpty)
//                     //       //     ? SizedBox()
//                     //       //     : Column(
//                     //       //         children: [
//                     //       //           SizedBox(
//                     //       //             height: 12,
//                     //       //           ),
//                     //       //           OfferSelectionWidget(
//                     //       //               controller: controller),
//                     //       //           Padding(
//                     //       //             padding:
//                     //       //                 const EdgeInsets.only(
//                     //       //                     left: 16.0,
//                     //       //                     right: 16,
//                     //       //                     top: 16),
//                     //       //             child: Row(
//                     //       //               mainAxisAlignment:
//                     //       //                   MainAxisAlignment
//                     //       //                       .start,
//                     //       //               crossAxisAlignment:
//                     //       //                   CrossAxisAlignment
//                     //       //                       .center,
//                     //       //               children: [
//                     //       //                 Icon(
//                     //       //                   Icons
//                     //       //                       .access_time_filled,
//                     //       //                   color: AppColors
//                     //       //                       .primaryColor,
//                     //       //                   size: 20,
//                     //       //                 ),
//                     //       //                 SizedBox(
//                     //       //                   width: 8,
//                     //       //                 ),
//                     //       //                 Text(
//                     //       //                   'choose time & discount',
//                     //       //                   textAlign:
//                     //       //                       TextAlign.center,
//                     //       //                   style: TextStyle(
//                     //       //                     color: AppColors
//                     //       //                         .textColor,
//                     //       //                     fontSize: 14,
//                     //       //                     fontFamily:
//                     //       //                         'Nunito-Regular',
//                     //       //                     fontWeight:
//                     //       //                         FontWeight.w400,
//                     //       //                     height: 0.16,
//                     //       //                   ),
//                     //       //                 ),
//                     //       //               ],
//                     //       //             ),
//                     //       //           ),
//                     //       //           SizedBox(
//                     //       //             height: 16,
//                     //       //           ),
//                     //       //           // controller.selectedMenu
//                     //       //           //             .value ==
//                     //       //           //         'Happy Hours Specials'
//                     //       //           //     ? Padding(
//                     //       //           //         padding:
//                     //       //           //             EdgeInsets.only(
//                     //       //           //           left: 16,
//                     //       //           //         ),
//                     //       //           //         child: SizedBox(
//                     //       //           //           height: 100,
//                     //       //           //           child: ListView
//                     //       //           //               .builder(
//                     //       //           //             controller:
//                     //       //           //                 locationController
//                     //       //           //                     .scrollController,
//                     //       //           //             scrollDirection:
//                     //       //           //                 Axis.horizontal,
//                     //       //           //             itemCount: widget
//                     //       //           //                 .restaurantModel!
//                     //       //           //                 .menuList
//                     //       //           //                 .happyHourSpecials
//                     //       //           //                 .length,
//                     //       //           //             itemBuilder:
//                     //       //           //                 (context,
//                     //       //           //                     index) {
//                     //       //           //               final item = widget
//                     //       //           //                   .restaurantModel!
//                     //       //           //                   .menuList
//                     //       //           //                   .happyHourSpecials[index];
//                     //       //           //               return Padding(
//                     //       //           //                 padding: EdgeInsets
//                     //       //           //                     .symmetric(
//                     //       //           //                         horizontal:
//                     //       //           //                             4,
//                     //       //           //                         vertical:
//                     //       //           //                             6),
//                     //       //           //                 child:
//                     //       //           //                     LocationStarWidget(
//                     //       //           //                   index:
//                     //       //           //                       index,
//                     //       //           //                   menuType:
//                     //       //           //                       'HappyHour',
//                     //       //           //                   timeText1:
//                     //       //           //                       item.startTime ??
//                     //       //           //                           '',
//                     //       //           //                   timeText2:
//                     //       //           //                       item.endTime ??
//                     //       //           //                           '',
//                     //       //           //                   percentageText:
//                     //       //           //                       item.percentage ??
//                     //       //           //                           '',
//                     //       //           //                 ),
//                     //       //           //               );
//                     //       //           //             },
//                     //       //           //           ),
//                     //       //           //         ),
//                     //       //           //       )
//                     //       //           //     : Padding(
//                     //       //           //         padding:
//                     //       //           //             EdgeInsets.only(
//                     //       //           //           left: 16,
//                     //       //           //         ),
//                     //       //           //         child: SizedBox(
//                     //       //           //           height: 100,
//                     //       //           //           child: ListView
//                     //       //           //               .builder(
//                     //       //           //             controller:
//                     //       //           //                 locationController
//                     //       //           //                     .scrollController,
//                     //       //           //             scrollDirection:
//                     //       //           //                 Axis.horizontal,
//                     //       //           //             itemCount: widget
//                     //       //           //                 .restaurantModel
//                     //       //           //                 ?.menuList
//                     //       //           //                 .percentageOff
//                     //       //           //                 .length,
//                     //       //           //             itemBuilder:
//                     //       //           //                 (context,
//                     //       //           //                     index) {
//                     //       //           //               final item = widget
//                     //       //           //                   .restaurantModel
//                     //       //           //                   ?.menuList
//                     //       //           //                   .percentageOff[index];
//                     //       //           //               return Padding(
//                     //       //           //                 padding: EdgeInsets
//                     //       //           //                     .symmetric(
//                     //       //           //                         horizontal:
//                     //       //           //                             4,
//                     //       //           //                         vertical:
//                     //       //           //                             6),
//                     //       //           //                 child:
//                     //       //           //                     LocationStarWidget(
//                     //       //           //                   timeText1:
//                     //       //           //                       item?.startTime ??
//                     //       //           //                           '',
//                     //       //           //                   index:
//                     //       //           //                       index,
//                     //       //           //                   menuType:
//                     //       //           //                       'PercentageOff',
//                     //       //           //                   timeText2:
//                     //       //           //                       item?.endTime ??
//                     //       //           //                           '',
//                     //       //           //                   percentageText:
//                     //       //           //                       item?.percentage ??
//                     //       //           //                           '',
//                     //       //           //                 ),
//                     //       //           //               );
//                     //       //           //             },
//                     //       //           //           ),
//                     //       //           //         ),
//                     //       //           //       ),
//
//                     //       //           SizedBox(
//                     //       //             height: 16,
//                     //       //           ),
//                     //       //           Padding(
//                     //       //             padding: const EdgeInsets
//                     //       //                 .symmetric(
//                     //       //                 horizontal: 16),
//                     //       //             child: Row(
//                     //       //               mainAxisAlignment:
//                     //       //                   MainAxisAlignment
//                     //       //                       .spaceBetween,
//                     //       //               children: [
//                     //       //                 Text(
//                     //       //                   'Meals',
//                     //       //                   textAlign:
//                     //       //                       TextAlign.center,
//                     //       //                   style: TextStyle(
//                     //       //                     color: AppColors
//                     //       //                         .textColor,
//                     //       //                     fontSize: 15,
//                     //       //                     fontFamily:
//                     //       //                         'Nunito-Regular',
//                     //       //                     fontWeight:
//                     //       //                         FontWeight.w600,
//                     //       //                   ),
//                     //       //                 ),
//                     //       //                 Row(
//                     //       //                   children: [
//                     //       //                     // Obx(
//                     //       //                     //   () => Text(
//                     //       //                     //     controller.selectedMenu
//                     //       //                     //                 .value ==
//                     //       //                     //             'Happy Hours Specials'
//                     //       //                     //         ? widget
//                     //       //                     //                 .restaurantModel!
//                     //       //                     //                 .menuList
//                     //       //                     //                 .happyHourSpecials
//                     //       //                     //                 .isEmpty
//                     //       //                     //             ? ''
//                     //       //                     //             : indexOfMenuHappyHourOff <
//                     //       //                     //                     0
//                     //       //                     //                 ? ''
//                     //       //                     //                 : widget.restaurantModel?.menuList.happyHourSpecials[indexOfMenuHappyHourOff].cuisine ??
//                     //       //                     //                     ''
//                     //       //                     //         : widget
//                     //       //                     //                 .restaurantModel!
//                     //       //                     //                 .menuList
//                     //       //                     //                 .percentageOff
//                     //       //                     //                 .isEmpty
//                     //       //                     //             ? ''
//                     //       //                     //             : (indexOfMenuPersentageOff < 0 ||
//                     //       //                     //                     widget.restaurantModel!.menuList.percentageOff.isEmpty)
//                     //       //                     //                 ? ''
//                     //       //                     //                 : widget.restaurantModel?.menuList.percentageOff[indexOfMenuPersentageOff].cuisine ?? '',
//                     //       //                     //     textAlign:
//                     //       //                     //         TextAlign
//                     //       //                     //             .center,
//                     //       //                     //     style:
//                     //       //                     //         TextStyle(
//                     //       //                     //       color: AppColors
//                     //       //                     //           .textColor,
//                     //       //                     //       fontSize: 14,
//                     //       //                     //       fontFamily:
//                     //       //                     //           'Nunito-Regular',
//                     //       //                     //       fontWeight:
//                     //       //                     //           FontWeight
//                     //       //                     //               .w400,
//                     //       //                     //     ),
//                     //       //                     //   ),
//                     //       //                     // ),
//                     //       //                     SizedBox(
//                     //       //                       width: 5,
//                     //       //                     ),
//                     //       //                     Image.asset(
//                     //       //                       'assets/images/meal_Icon..png',
//                     //       //                       height: 10.73,
//                     //       //                       width: 17,
//                     //       //                       fit: BoxFit.fill,
//                     //       //                     ),
//                     //       //                   ],
//                     //       //                 ),
//                     //       //               ],
//                     //       //             ),
//                     //       //           ),
//                     //       //           SizedBox(
//                     //       //             height: 16,
//                     //       //           ),
//                     //       //           Padding(
//                     //       //             padding:
//                     //       //                 const EdgeInsets.only(
//                     //       //                     left: 16.0,
//                     //       //                     right: 16.0),
//                     //       //             child: Center(
//                     //       //               child: Container(
//                     //       //                 width: Get.width,
//                     //       //                 child: Row(
//                     //       //                   mainAxisAlignment:
//                     //       //                       MainAxisAlignment
//                     //       //                           .center,
//                     //       //                   crossAxisAlignment:
//                     //       //                       CrossAxisAlignment
//                     //       //                           .center,
//                     //       //                   children: [
//                     //       //                     // First part: Menu items and before discount columns
//                     //       //                     Obx(() {
//                     //       //                       return Expanded(
//                     //       //                         flex: 2,
//                     //       //                         child:
//                     //       //                             Container(
//                     //       //                           // height: 420,
//                     //       //                           decoration: const BoxDecoration(
//                     //       //                               color: Colors
//                     //       //                                   .white,
//                     //       //                               borderRadius: BorderRadius.only(
//                     //       //                                   topLeft: Radius.circular(
//                     //       //                                       4),
//                     //       //                                   bottomLeft:
//                     //       //                                       Radius.circular(4))),
//
//                     //       //                           child: Table(
//                     //       //                             border: TableBorder.symmetric(
//                     //       //                                 inside: BorderSide(
//                     //       //                                     width:
//                     //       //                                         1,
//                     //       //                                     color:
//                     //       //                                         Colors.grey.withOpacity(0.5))),
//                     //       //                             children: [
//                     //       //                               _buildTableHeader(
//                     //       //                                   context),
//                     //       //                               // _buildTableRow(
//                     //       //                               //   context,
//                     //       //                               //   imageList: controller.selectedMenu.value ==
//                     //       //                               //           'Happy Hours Specials'
//                     //       //                               //       ? widget.restaurantModel!.menuList.happyHourSpecials.isEmpty
//                     //       //                               //           ? []
//                     //       //                               //           : indexOfMenuHappyHourOff < 0
//                     //       //                               //               ? []
//                     //       //                               //               : widget.restaurantModel!.menuList.happyHourSpecials[indexOfMenuHappyHourOff].food.imagesList
//                     //       //                               //       : widget.restaurantModel!.menuList.percentageOff.isEmpty
//                     //       //                               //           ? []
//                     //       //                               //           : indexOfMenuPersentageOff < 0
//                     //       //                               //               ? []
//                     //       //                               //               : widget.restaurantModel!.menuList.percentageOff[indexOfMenuPersentageOff].food.imagesList,
//                     //       //                               //   menuItem:
//                     //       //                               //       'Food Menu',
//                     //       //                               //   menuItemNumbers: controller.selectedMenu.value ==
//                     //       //                               //           'Happy Hours Specials'
//                     //       //                               //       ? '(${widget.restaurantModel!.menuList.happyHourSpecials.isEmpty ? 0 : indexOfMenuHappyHourOff < 0 ? [] : widget.restaurantModel!.menuList.happyHourSpecials[indexOfMenuHappyHourOff].food.imagesList.length.toString()})'
//                     //       //                               //       : '(${widget.restaurantModel!.menuList.percentageOff.isEmpty ? 0 : indexOfMenuPersentageOff < 0 ? [] : widget.restaurantModel!.menuList.percentageOff[indexOfMenuPersentageOff].food.imagesList.length.toString()})',
//                     //       //                               // ),
//                     //       //                               // _buildTableRow(
//                     //       //                               //   context,
//                     //       //                               //   imageList: controller.selectedMenu.value ==
//                     //       //                               //           'Happy Hours Specials'
//                     //       //                               //       ? widget.restaurantModel!.menuList.happyHourSpecials.isEmpty
//                     //       //                               //           ? []
//                     //       //                               //           : indexOfMenuHappyHourOff < 0
//                     //       //                               //               ? []
//                     //       //                               //               : widget.restaurantModel!.menuList.happyHourSpecials[indexOfMenuHappyHourOff].drink.imagesList
//                     //       //                               //       : widget.restaurantModel!.menuList.percentageOff.isEmpty
//                     //       //                               //           ? []
//                     //       //                               //           : indexOfMenuPersentageOff < 0
//                     //       //                               //               ? []
//                     //       //                               //               : widget.restaurantModel!.menuList.percentageOff[indexOfMenuPersentageOff].drink.imagesList,
//                     //       //                               //   menuItem:
//                     //       //                               //       'Drink Menu',
//                     //       //                               //   menuItemNumbers: controller.selectedMenu.value ==
//                     //       //                               //           'Happy Hours Specials'
//                     //       //                               //       ? '(${widget.restaurantModel!.menuList.happyHourSpecials.isEmpty ? 0 : indexOfMenuHappyHourOff < 0 ? [] : widget.restaurantModel!.menuList.happyHourSpecials[indexOfMenuHappyHourOff].drink.imagesList.length.toString()})'
//                     //       //                               //       : '(${widget.restaurantModel!.menuList.percentageOff.isEmpty ? 0 : indexOfMenuPersentageOff < 0 ? [] : widget.restaurantModel!.menuList.percentageOff[indexOfMenuPersentageOff].drink.imagesList.length.toString()})',
//                     //       //                               // ),
//
//                     //       //                             ],
//                     //       //                           ),
//                     //       //                         ),
//                     //       //                       );
//                     //       //                     }),
//                     //       //                     // Second part: After discount (green column)
//                     //       //                     Obx(
//                     //       //                       () => Expanded(
//                     //       //                         child:
//                     //       //                             Container(
//                     //       //                           height: 290,
//                     //       //                           decoration:
//                     //       //                               BoxDecoration(
//                     //       //                             color: AppColors
//                     //       //                                 .primaryColor,
//                     //       //                             borderRadius:
//                     //       //                                 BorderRadius
//                     //       //                                     .circular(4),
//                     //       //                           ),
//                     //       //                           child:
//                     //       //                               Padding(
//                     //       //                             padding: const EdgeInsets
//                     //       //                                 .symmetric(
//                     //       //                                 vertical:
//                     //       //                                     9),
//                     //       //                             child:
//                     //       //                                 Table(
//                     //       //                               border: TableBorder.symmetric(
//                     //       //                                   inside: BorderSide(
//                     //       //                                       width: 1,
//                     //       //                                       color: Colors.grey.withOpacity(0.5))),
//                     //       //                               children: [
//                     //       //                                 _buildGreenHeader(
//                     //       //                                     context),
//                     //       //                                 _buildGreenRow(
//                     //       //                                   context,
//                     //       //                                   afterPrice: controller.selectedMenu.value == 'Happy Hours Specials'
//                     //       //                                       ? widget.restaurantModel!.menuList.happyHourSpecials.isEmpty
//                     //       //                                           ? ''
//                     //       //                                           : indexOfMenuHappyHourOff < 0
//                     //       //                                               ? ''
//                     //       //                                               : widget.restaurantModel!.menuList.happyHourSpecials[indexOfMenuHappyHourOff].food.offerName ?? ''
//                     //       //                                       : widget.restaurantModel!.menuList.percentageOff.isEmpty
//                     //       //                                           ? ''
//                     //       //                                           : indexOfMenuPersentageOff < 0
//                     //       //                                               ? ''
//                     //       //                                               : widget.restaurantModel!.menuList.percentageOff[indexOfMenuPersentageOff].food.offerName ?? '',
//                     //       //                                 ),
//                     //       //                                 _buildGreenRow(
//                     //       //                                   context,
//                     //       //                                   afterPrice: controller.selectedMenu.value == 'Happy Hours Specials'
//                     //       //                                       ? widget.restaurantModel!.menuList.happyHourSpecials.isEmpty
//                     //       //                                           ? ''
//                     //       //                                           : indexOfMenuHappyHourOff < 0
//                     //       //                                               ? ''
//                     //       //                                               : widget.restaurantModel!.menuList.happyHourSpecials[indexOfMenuHappyHourOff].drink.offerName ?? ''
//                     //       //                                       : widget.restaurantModel!.menuList.percentageOff.isEmpty
//                     //       //                                           ? ''
//                     //       //                                           : indexOfMenuPersentageOff < 0
//                     //       //                                               ? ''
//                     //       //                                               : widget.restaurantModel!.menuList.percentageOff[indexOfMenuPersentageOff].drink.offerName ?? '',
//                     //       //                                 ),
//                     //       //                               ],
//                     //       //                             ),
//                     //       //                           ),
//                     //       //                         ),
//                     //       //                       ),
//                     //       //                     ),
//                     //       //                   ],
//                     //       //                 ),
//                     //       //               ),
//                     //       //             ),
//                     //       //           ),
//                     //       //         ],
//                     //       //       ),
//                     //       // SizedBox(
//                     //       //   height: 16,
//                     //       // ),
//                     //       // Row(
//                     //       //   children: [
//                     //       //     Padding(
//                     //       //       padding: const EdgeInsets.only(
//                     //       //           left: 16.0, right: 16),
//                     //       //       child: Text(
//                     //       //         'Special Conditions ',
//                     //       //         style: TextStyle(
//                     //       //           color: AppColors
//                     //       //               .headingTextColor,
//                     //       //           fontSize: 17,
//                     //       //           fontFamily: 'aftika-regular',
//                     //       //           fontWeight: FontWeight.w400,
//                     //       //         ),
//                     //       //       ),
//                     //       //     ),
//                     //       //   ],
//                     //       // ),
//                     //       // const SizedBox(height: 20),
//                     //       // Padding(
//                     //       //     padding: const EdgeInsets.only(
//                     //       //         left: 16.0, right: 16),
//                     //       //     child: Column(
//                     //       //       children: [
//                     //       //         Text(widget.restaurantModel
//                     //       //                 ?.specialConditions ??
//                     //       //             '')
//                     //       //       ],
//                     //       //     )),
//                     //       SizedBox(
//                     //         height: Get.height * 0.5,
//                     //         width: double.infinity,
//                     //         child: MenuWidget(
//                     //           screenHeight: Get.height,
//                     //           mobileView: true,
//                     //           screenWidth: Get.width,
//                     //           selectedMenuTypes: widget
//                     //                   .restaurantModel!
//                     //                   .menuList
//                     //                   .isEmpty
//                     //               ? MenuModel(
//                     //                   cuisineType: '',
//                     //                   foodImages: [],
//                     //                   menuType: '')
//                     //               : widget.restaurantModel!
//                     //                   .menuList.first,
//                     //           specialConditions: widget
//                     //               .restaurantModel!
//                     //               .specialConditions,
//                     //           uploadedImages: widget
//                     //                   .restaurantModel!
//                     //                   .menuList
//                     //                   .isNotEmpty
//                     //               ? widget.restaurantModel!
//                     //                   .menuList[0].foodImages
//                     //               : [],
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   );
//
//                     // }),
//                   ],
//                 ),
//                 // Padding(
//                 //   padding:
//                 //       const EdgeInsets.only(left: 35.0, right: 16, top: 130),
//                 //   child: ClipRRect(
//                 //     borderRadius: BorderRadius.circular(10),
//                 //     // Clip the blur to the rounded corners
//                 //     child: BackdropFilter(
//                 //       filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//                 //       // Adjust the blur intensity
//                 //       child: Container(
//                 //         height: widget.restaurantModel!.imagesList.isEmpty
//                 //             ? 70
//                 //             : 173,
//                 //         width: 358,
//                 //         decoration: BoxDecoration(
//                 //           borderRadius: BorderRadius.circular(10),
//                 //           gradient: LinearGradient(
//                 //             colors: [
//                 //               AppColors.whiteColor.withOpacity(0.4),
//                 //               AppColors.primaryColor.withOpacity(0.3),
//                 //             ],
//                 //             begin: Alignment.topCenter,
//                 //             // Starting point of the gradient
//                 //             end: Alignment
//                 //                 .bottomCenter, // Ending point of the gradient
//                 //           ),
//                 //         ),
//                 //         child: Padding(
//                 //           padding: const EdgeInsets.only(
//                 //               left: 12.0, right: 12, top: 12),
//                 //           child: Column(
//                 //             mainAxisAlignment: MainAxisAlignment.start,
//                 //             crossAxisAlignment: CrossAxisAlignment.start,
//                 //             children: [
//                 //               Row(
//                 //                 children: [
//                 //                   // Image.asset(
//                 //                   //   'assets/images/ihop-restaurant-logo 1.png',
//                 //                   //   height: 33,
//                 //                   //   width: 49,
//                 //                   // ),
//                 //                   // SizedBox(width: 6),
//                 //                   Text(
//                 //                     widget.restaurantModel?.resName ?? '',
//                 //                     style: TextStyle(
//                 //                       color: AppColors.blackColor,
//                 //                       fontFamily: 'Nunito-Bold',
//                 //                       fontSize: 14,
//                 //                       fontWeight: FontWeight.w500,
//                 //                     ),
//                 //                   ),
//                 //                 ],
//                 //               ),
//                 //               SizedBox(
//                 //                 height: 4,
//                 //               ),
//                 //               StreamBuilder<List<ReviewModel>>(
//                 //                   stream: widget.restaurantModel?.docID == ''
//                 //                       ? null
//                 //                       : homeLocationController.getReviews(
//                 //                           widget.restaurantModel?.docID ?? ''),
//                 //                   builder: (context, snapshot) {
//                 //                     if (snapshot.connectionState ==
//                 //                         ConnectionState.waiting) {
//                 //                       return Center(
//                 //                           child: CircularProgressIndicator());
//                 //                     }
//                 //                     if (!snapshot.hasData ||
//                 //                         snapshot.data!.isEmpty) {
//                 //                       return SizedBox();
//                 //                     }
//
//                 //                     final reviews = snapshot.data!;
//                 //                     return Row(
//                 //                       children: [
//                 //                         Text(
//                 //                           '(${(reviews.map((e) => e.starRating).reduce((a, b) => a! + b!)! / reviews.length).toStringAsFixed(1)})',
//                 //                           style: TextStyle(
//                 //                             color: Color(0xFF4F5761),
//                 //                             fontSize: 16,
//                 //                             fontFamily: 'Nunito-Regular',
//                 //                             fontWeight: FontWeight.w400,
//                 //                           ),
//                 //                         ),
//                 //                         SizedBox(
//                 //                           height: 14,
//                 //                           child: RatingBar(
//                 //                             itemSize: 14,
//                 //                             ignoreGestures: true,
//                 //                             initialRating: reviews
//                 //                                     .map((e) =>
//                 //                                         e.starRating ?? 0)
//                 //                                     .reduce((a, b) => a + b) /
//                 //                                 reviews.length,
//                 //                             minRating: 1,
//                 //                             direction: Axis.horizontal,
//                 //                             allowHalfRating: true,
//                 //                             itemCount: 5,
//                 //                             ratingWidget: RatingWidget(
//                 //                               full: Image.asset(
//                 //                                 'assets/images/star yellow.png',
//                 //                                 height: 19,
//                 //                               ),
//                 //                               half: Image.asset(
//                 //                                 'assets/images/star yellow.png',
//                 //                                 height: 19,
//                 //                               ),
//                 //                               empty: Image.asset(
//                 //                                 'assets/images/star_empty.png',
//                 //                                 height: 19,
//                 //                               ),
//                 //                             ),
//                 //                             itemPadding: const EdgeInsets.only(
//                 //                                 left: 2.0, bottom: 20),
//                 //                             onRatingUpdate: (rating) {
//                 //                               print(rating);
//                 //                             },
//                 //                           ),
//                 //                         ),
//                 //                         const SizedBox(width: 10),
//                 //                         Text(
//                 //                           '${reviews.length} reviews',
//                 //                           style: TextStyle(
//                 //                             color: AppColors.darkGrey,
//                 //                             fontSize: 16,
//                 //                             fontFamily: 'Nunito-Regular',
//                 //                             fontWeight: FontWeight.w400,
//                 //                             decoration:
//                 //                                 TextDecoration.underline,
//                 //                           ),
//                 //                         ),
//                 //                         const SizedBox(
//                 //                           width: 10,
//                 //                         )
//                 //                       ],
//                 //                     );
//                 //                   }),
//                 //               SizedBox(
//                 //                 height: 4,
//                 //               ),
//                 //               Text(
//                 //                 widget.restaurantModel?.spokenLanguage ?? '',
//                 //                 style: TextStyle(
//                 //                   color: AppColors.darkGrey,
//                 //                   fontSize: 16,
//                 //                   fontFamily: 'Nunito-Regular',
//                 //                   fontWeight: FontWeight.w400,
//                 //                 ),
//                 //               ),
//                 //               SizedBox(
//                 //                 height: 4,
//                 //               ),
//                 //               Row(
//                 //                 mainAxisAlignment: MainAxisAlignment.center,
//                 //                 children: [
//                 //                   Container(
//                 //                     decoration: BoxDecoration(
//                 //                       color: widget.restaurantModel!.imagesList
//                 //                               .isEmpty
//                 //                           ? Colors.transparent
//                 //                           : AppColors.whiteColor,
//                 //                       borderRadius: BorderRadius.circular(10),
//                 //                     ),
//                 //                     child: widget
//                 //                             .restaurantModel!.imagesList.isEmpty
//                 //                         ? const SizedBox()
//                 //                         : Wrap(
//                 //                             spacing: 5, // Space between images
//                 //                             alignment: WrapAlignment
//                 //                                 .start, // Align images to the start
//                 //                             children: widget
//                 //                                 .restaurantModel!.imagesList
//                 //                                 .asMap()
//                 //                                 .entries
//                 //                                 .map((entry) {
//                 //                               int index = entry.key;
//                 //                               String imagePath = entry.value;
//
//                 //                               if (index < 4) {
//                 //                                 // Display the first 4 images normally
//                 //                                 return GestureDetector(
//                 //                                   onTap: () => showImageDialog(
//                 //                                       context, imagePath),
//                 //                                   child: ClipRRect(
//                 //                                     borderRadius:
//                 //                                         BorderRadius.circular(
//                 //                                             5),
//                 //                                     child: Image.network(
//                 //                                       imagePath,
//                 //                                       fit: BoxFit.cover,
//                 //                                       height: 55,
//                 //                                       width: 58,
//                 //                                     ),
//                 //                                   ),
//                 //                                 );
//                 //                               } else if (index == 4 &&
//                 //                                   widget.restaurantModel!
//                 //                                           .imagesList.length >
//                 //                                       5) {
//                 //                                 // Display "5+" overlay on the 5th image if more than 5 images exist
//                 //                                 return GestureDetector(
//                 //                                   onTap: () => Get.to(
//                 //                                     RestaurantImages(
//                 //                                         imageList: widget
//                 //                                             .restaurantModel!
//                 //                                             .imagesList),
//                 //                                   ),
//                 //                                   child: Stack(
//                 //                                     children: [
//                 //                                       ClipRRect(
//                 //                                         borderRadius:
//                 //                                             BorderRadius
//                 //                                                 .circular(5),
//                 //                                         child: Image.network(
//                 //                                           imagePath,
//                 //                                           height: 55,
//                 //                                           width: 58,
//                 //                                           fit: BoxFit.cover,
//                 //                                         ),
//                 //                                       ),
//                 //                                       Container(
//                 //                                         height: 55,
//                 //                                         width: 58,
//                 //                                         decoration:
//                 //                                             BoxDecoration(
//                 //                                           color: Colors.black
//                 //                                               .withOpacity(0.5),
//                 //                                           borderRadius:
//                 //                                               BorderRadius
//                 //                                                   .circular(5),
//                 //                                         ),
//                 //                                         child: const Center(
//                 //                                           child: Text(
//                 //                                             '5+',
//                 //                                             style: TextStyle(
//                 //                                               color:
//                 //                                                   Colors.white,
//                 //                                               fontWeight:
//                 //                                                   FontWeight
//                 //                                                       .bold,
//                 //                                               fontSize: 14,
//                 //                                             ),
//                 //                                           ),
//                 //                                         ),
//                 //                                       ),
//                 //                                     ],
//                 //                                   ),
//                 //                                 );
//                 //                               } else if (index == 4) {
//                 //                                 // Display the 5th image normally if there are exactly 5 images
//                 //                                 return GestureDetector(
//                 //                                   onTap: () => showImageDialog(
//                 //                                       context, imagePath),
//                 //                                   child: ClipRRect(
//                 //                                     borderRadius:
//                 //                                         BorderRadius.circular(
//                 //                                             5),
//                 //                                     child: Image.network(
//                 //                                       imagePath,
//                 //                                       height: 55,
//                 //                                       width: 58,
//                 //                                       fit: BoxFit.cover,
//                 //                                     ),
//                 //                                   ),
//                 //                                 );
//                 //                               } else {
//                 //                                 // Skip additional images
//                 //                                 return const SizedBox.shrink();
//                 //                               }
//                 //                             }).toList(),
//                 //                           ),
//                 //                   ),
//                 //                 ],
//                 //               )
//                 //             ],
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//               ]),
//             ),
//           ));
//     });
//   }
//
//   // Header cell builder
//   Widget buildHeaderCell(String text) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           fontFamily: 'Nunito-Sans',
//           color: Colors.black,
//         ),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
//
// // Data cell builder
//   Widget buildDataCell(String text) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//         text,
//         style: TextStyle(
//             fontFamily: 'Nunito-Sans',
//             color: AppColors.textColor,
//             fontWeight: FontWeight.w500,
//             fontSize: 8),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
//
//   // Normal table rows for "Menu Items" and "Before Discount" columns
//   TableRow _buildTableRow(
//     BuildContext context, {
//     required String menuItem,
//     required String menuItemNumbers,
//     required List<String> imageList, // Accept a list of images
//   }) {
//     return TableRow(
//       children: [
//         Container(
//           height: 106,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 60,
//                   width: 68,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: imageList.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Image.network(
//                             imageList[index],
//                             fit: BoxFit.cover,
//                             width: 60,
//                             height: 50,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 // SizedBox(height: 6),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       menuItemNumbers,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.black, // Update this color if needed
//                         fontSize: 10,
//                         fontFamily: 'Nunito-Regular',
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       menuItem,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.black, // Update this color if needed
//                         fontSize: 10,
//                         fontFamily: 'Nunito-Regular',
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   TableRow _buildGreenHeader(context) {
//     return TableRow(
//       children: [
//         SizedBox(
//           height: 60,
//           child: Center(
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 16.0),
//               child: Text(
//                 'Offer',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontFamily: 'Nunito-Bold',
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   TableRow _buildTableHeader(context) {
//     return TableRow(
//       children: [
//         Container(
//           height: 60,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Center(
//               child: Text(
//                 'Menus',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontFamily: 'Nunito-Bold',
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Rows for the green column
//   TableRow _buildGreenRow(context, {required String afterPrice}) {
//     return TableRow(
//       children: [
//         Container(
//           height: 106,
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 afterPrice,
//                 style: TextStyle(
//                   color: AppColors.bottomSheetColor,
//                   fontSize: 10,
//                   fontFamily: 'Nunito-Bold',
//                   fontWeight: FontWeight.w700,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

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

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    super.key,
    required this.screenHeight,
    required this.mobileView,
    required this.screenWidth,
    required this.specialConditions,
    required this.uploadedImages,
    required this.selectedMenuTypes,
  });

  final double screenHeight;
  final bool mobileView;
  final double screenWidth;
  final String specialConditions; // Added type
  final MenuModel selectedMenuTypes;
  final List<String> uploadedImages; // Added type

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.bgColor,
      ),
      child: specialConditions.isEmpty || specialConditions.contains('Soon')
          ? SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Special Conditions
                Text(
                  'Special Conditions',
                  style: TextStyle(
                    color: AppColors.bottomSheetColor,
                    fontFamily: 'aftika-regular',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                SizedBox(
                  child: SingleChildScrollView(
                    child: Text(
                      specialConditions.isEmpty
                          ? 'None provided'
                          : specialConditions,
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Menu Type
                Row(
                  children: [
                    Text(
                      'Menu Type: ',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      selectedMenuTypes.menuType.isEmpty
                          ? 'None selected'
                          : selectedMenuTypes.menuType,
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Food Images Section
                Text(
                  'Menu Images',
                  style: TextStyle(
                    color: AppColors.bottomSheetColor,
                    fontFamily: 'aftika-regular',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),

                uploadedImages.isEmpty
                    ? Text(
                        'No images uploaded',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.primaryColor,
                        ),
                      )
                    : SizedBox(
                        height: mobileView ? 100 : 130,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: uploadedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                width: mobileView ? 140 : 180,
                                height: mobileView ? 100 : 130,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    uploadedImages[index],
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.grey[600],
                                          size: 50,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
    );
  }
}
