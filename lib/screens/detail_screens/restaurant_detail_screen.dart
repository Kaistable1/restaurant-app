import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaistable_website/screens/detail_screens/controller/restaurant_detail_controller.dart';
import 'package:kaistable_website/screens/detail_screens/widget/map_widget.dart';
import 'package:kaistable_website/screens/detail_screens/widget/number_text_widget.dart';
import 'package:kaistable_website/screens/detail_screens/widget/review_widget.dart';
import 'package:kaistable_website/screens/detail_screens/widget/tabs_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/uplaod_dialogBox.dart';
import '../home_screen/location_pages/location_controller/location_list_controller.dart';
import '../home_screen/location_pages/widget/location_star_widget.dart';
import 'widget/about_section_widget.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  final controller = Get.put(RestaurantDetailController());
  final LocationListController locationController = LocationListController();
  RestaurantDetailScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return LayoutBuilder(
      builder: (context, constraints) {
        int itemsPerRow = Responsive.isMobile(context)
            ? 2
            : Responsive.isTablet(context)
                ? 3
                : 4;
        double itemWidth = (constraints.maxWidth / itemsPerRow) - 16;
        double itemHeight = Responsive.isMobile(context)
            ? 320
            : (isLargeScreen ? 500 : 500); // Set a fixed height for items

        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 22 : 46.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/ihop-restaurant-logo 1.png',
                        height: 40,
                        width: 40,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Ihop restaurant @ Tseug Kwan O',
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontFamily: 'Nunito-Regular',
                          fontSize: Responsive.isMobile(context) ? 8 :Responsive.isTablet(context) ?14: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                       Text(
                        '(4.0)',
                        style: TextStyle(
                          color: Color(0xFF4F5761),
                          fontSize: Responsive.isMobile(context) ? 8 :Responsive.isTablet(context) ?10:16,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 14,
                        child: RatingBar(
                          itemSize: Responsive.isMobile(context) ? 8 :Responsive.isTablet(context) ?12:14,
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
                            ),
                            half: Image.asset(
                              'assets/images/star yellow.png',
                              height: 14,
                            ),
                            empty: Image.asset(
                              'assets/images/star_empty.png',
                              height: 14,
                            ),
                          ),
                          itemPadding: const EdgeInsets.only(left: 2.0),
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
                          fontSize: Responsive.isMobile(context) ? 8 :Responsive.isTablet(context) ?10:16,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Line10(),
                       Text(
                        'Chinese',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: Responsive.isMobile(context) ? 8 :Responsive.isTablet(context) ?10:16,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Line10(),
                      Obx(() {
                        return GestureDetector(
                          onTap: () {
                            controller.isFavorite.toggle();
                          },
                          child: Icon(
                            Icons.favorite,
                            color: controller.isFavorite.value
                                ? Colors.red
                                : AppColors.darkGrey,
                          ),
                        );
                      }),
                       Text(
                        'add to favourite',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: Responsive.isMobile(context) ? 8 :Responsive.isTablet(context) ?10:16,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: Responsive.isMobile(context) ? 10 : 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: Responsive.isMobile(context)
                        ? 150
                        : Responsive.isTablet(context)
                            ? 240
                            : isLargeScreen
                                ? 550
                                : 410,
                    width: Responsive.isMobile(context)
                        ? 165
                        : Responsive.isTablet(context)
                            ? Get.width * 0.4
                            : isLargeScreen
                                ? Get.width * 0.4
                                : 480,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(
                            'assets/images/img1.png'), // Replace with your image asset
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(
                    width: Responsive.isMobile(context) ? 2 : 10,
                  ),
                  Column(
                    children: [
                      Container(
                        height: Responsive.isMobile(context)
                            ? 75
                            : Responsive.isTablet(context)
                                ? 115
                                : isLargeScreen
                                    ?270
                                    : 200,
                        width: Responsive.isMobile(context)
                            ? 90
                            : Responsive.isTablet(context)
                                ? Get.width * 0.2
                                : isLargeScreen
                                    ? Get.width * 0.2
                                    : 296,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/images/img1.png'), // Replace with your image asset
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      SizedBox(
                        height: Responsive.isMobile(context) ? 2 : 10,
                      ),
                      Container(
                        height: Responsive.isMobile(context)
                            ? 75
                            : Responsive.isTablet(context)
                            ? 115
                            : isLargeScreen
                            ?270
                            : 200,
                        width: Responsive.isMobile(context)
                            ? 90
                            : Responsive.isTablet(context)
                            ? Get.width * 0.2
                            : isLargeScreen
                            ? Get.width * 0.2
                            : 296,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/images/img1.png'), // Replace with your image asset
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: Responsive.isMobile(context) ? 2 : 10,
                  ),
                  Column(
                    children: [
                      Container(
                        height: Responsive.isMobile(context)
                            ? 75
                            : Responsive.isTablet(context)
                            ? 115
                            : isLargeScreen
                            ?270
                            : 200,
                        width: Responsive.isMobile(context)
                            ? 90
                            : Responsive.isTablet(context)
                            ? Get.width * 0.2
                            : isLargeScreen
                            ? Get.width * 0.2
                            : 296,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/images/img1.png'), // Replace with your image asset
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      SizedBox(
                        height: Responsive.isMobile(context) ? 2 : 10,
                      ),
                      Container(
                        height: Responsive.isMobile(context)
                            ? 75
                            : Responsive.isTablet(context)
                            ? 115
                            : isLargeScreen
                            ? 270
                            : 200,
                        width: Responsive.isMobile(context)
                            ? 90
                            : Responsive.isTablet(context)
                            ? Get.width * 0.2
                            : isLargeScreen
                            ? Get.width * 0.2
                            : 296,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5), // Apply border radius to the container
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Background Image with Blur Effect
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5), // Apply the same borderRadius
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    'assets/images/img1.png', // Your image asset
                                    fit: BoxFit.cover,
                                  ),
                                  BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1), // Apply blur effect
                                    child: Container(
                                      color: Colors.black.withOpacity(0), // Transparent container
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Text on top of the blurred image
                            Center(
                              child: Text(
                                'view all photos',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.whiteColor,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Responsive.isMobile(context) ? 6 : Responsive.isTablet(context) ? 10 : 16,
                                  fontFamily: 'Nunito-Regular',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: Responsive.isMobile(context) ? 10 : 18),
              Column(
                children: [
                  Tabs(controller: controller),
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: Responsive.isMobile(context) ? 40 : 62,
                            right: 10),
                        child: SizedBox(
                          height: Responsive.isMobile(context)
                              ? 140
                              : isLargeScreen
                                  ? 200
                                  : 140,
                          child: ListView.builder(
                            controller: locationController.scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: locationController
                                .circleItems.length, // Number of items
                            itemBuilder: (context, index) {
                              final item = locationController.circleItems[
                                  index]; // Get item from model list
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Responsive.isMobile(context)
                                        ? 29
                                        : isLargeScreen
                                            ? 48
                                            : 21.0,
                                    vertical:
                                        Responsive.isMobile(context) ? 6 : 6),
                                child: LocationStarWidget(
                                  //
                                  // isLocation: true,
                                  //
                                  timeText: item.timeText,
                                  persentText: item.persentText,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // Left Arrow button with padding for spacing
                      Positioned(
                        left: 10, // Adjust the value to add space from the list
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () => locationController.scrollLeft(),
                          child: Image.asset(
                            'assets/images/arrow_back.png',
                            height: Responsive.isMobile(context) ? 32 : 52,
                            width: Responsive.isMobile(context) ? 32 : 52,
                          ),
                        ),
                      ),
                      // Right Arrow button with padding for spacing
                      Positioned(
                        right:
                            10, // Adjust the value to add space from the list
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () => locationController.scrollRight(),
                          child: Image.asset(
                            'assets/images/arrow_forward.png',
                            height: Responsive.isMobile(context) ? 32 : 52,
                            width: Responsive.isMobile(context) ? 32 : 52,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: Responsive.isMobile(context) ? 2 : 22),
              Obx(() {
                return controller.selectedTop.value == 'about'
                    ? AboutSectionWidget()
                    : controller.selectedTop.value == 'reviews'
                        ? ReviewWidget(isLargeScreen: isLargeScreen)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Special Conditions ',
                                style: TextStyle(
                                  color: AppColors.headingTextColor,
                                  fontSize:
                                      Responsive.isMobile(context) ? 16 : 28,
                                  fontFamily: 'aftika-regular',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    controller.texts.length,
                                    (index) => NumberedTextWidget(
                                      number: index + 1,
                                      text: controller.texts[index],
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: Responsive.isMobile(context) ||
                                          Responsive.isTablet(context)
                                      ? Get.width
                                      : Get.width * 0.7,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // First part: Menu items and before discount columns
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          // height: 420,
                                          color: Colors.white,
                                          child: Table(
                                            border: TableBorder.symmetric(
                                                inside: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey
                                                        .withOpacity(0.5))),
                                            // columnWidths: {
                                            //   0:   FixedColumnWidth(Get.width*0.2),
                                            //   1:   FlexColumnWidth(Get.width*0.2),
                                            // },
                                            children: [
                                              _buildTableHeader(context),
                                              _buildTableRow(
                                                context,
                                                image:
                                                    'assets/images/menu1.png',
                                                menuItem: 'Specialty',
                                                beforePrice: '\$30',
                                              ),
                                              _buildTableRow(
                                                context,
                                                image:
                                                    'assets/images/menu2.png',
                                                menuItem: 'Raddish Pastry',
                                                beforePrice: '\$20',
                                              ),
                                              _buildTableRow(
                                                context,
                                                image:
                                                    'assets/images/menu3.png',
                                                menuItem:
                                                    'Nam temporibus repellat ullam odit.',
                                                beforePrice: '\$30',
                                              ),
                                              _buildTableRow(
                                                context,
                                                image:
                                                    'assets/images/menu1.png',
                                                menuItem:
                                                    'Aut consectetur temporibus in',
                                                beforePrice: '\$40',
                                              ),
                                              _buildTableRow(
                                                context,
                                                image:
                                                    'assets/images/menu2.png',
                                                menuItem:
                                                    'Nam non eum velit tenetur',
                                                beforePrice: '\$20',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Second part: After discount (green column)
                                      Expanded(
                                        child: Container(
                                          height: 482,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 42),
                                            child: Table(
                                              border: TableBorder.symmetric(
                                                  inside: BorderSide(
                                                      width: 1,
                                                      color: Colors.grey
                                                          .withOpacity(0.5))),
                                              // columnWidths: {
                                              //   0: const FlexColumnWidth(),
                                              // },
                                              children: [
                                                _buildGreenHeader(context),
                                                _buildGreenRow(context,
                                                    afterPrice: '\$20'),
                                                _buildGreenRow(context,
                                                    afterPrice: '\$10'),
                                                _buildGreenRow(context,
                                                    afterPrice: '\$20'),
                                                _buildGreenRow(context,
                                                    afterPrice: '\$30'),
                                                _buildGreenRow(context,
                                                    afterPrice: '\$10'),
                                              ],
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
              }),
              SizedBox(height: Responsive.isMobile(context) ? 12 : 22),
              Text(
                'Map',
                style: TextStyle(
                  color: AppColors.headingTextColor,
                  fontSize: Responsive.isMobile(context) ? 16 : 24,
                  fontFamily: 'aftika-regular',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 2 : 22),
              Container(
                width: Get.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Row(
                  children: [
                    Responsive.isMobile(context) || Responsive.isTablet(context)
                        ? Padding(
                          padding: const EdgeInsets.only(left: 18.0, top: 30),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: Get.width * 0.8,
                                  height: 400,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16)),
                                  child: MapWidget(controller: controller),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                const MapDetailWidget()
                              ],
                            ),
                        )
                        : Row(
                            children: [
                              Container(
                                width: Get.width * 0.5,
                                height: 400,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16)),
                                child: MapWidget(controller: controller),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              const MapDetailWidget()
                            ],
                          ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // Normal table rows for "Menu Items" and "Before Discount" columns
  TableRow _buildTableRow(
    context, {
    required String image,
    required String menuItem,
    required String beforePrice,
  }) {
    return TableRow(
      children: [
        Container(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(image, width: 55, height: 49),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(menuItem,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: Responsive.isMobile(context) ? 10 : 14,
                        fontFamily: 'Nunito-Regular',
                        fontWeight: FontWeight.w500,
                      )),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(beforePrice,
                  style: TextStyle(
                    color: AppColors.botomSheetColor,
                    fontSize: Responsive.isMobile(context) ? 10 : 14,
                    fontFamily: 'Nunito-Regular',
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ),
        ),
      ],
    );
  } // Header for the green column (After discount)

  TableRow _buildGreenHeader(context) {
    return TableRow(
      children: [
        SizedBox(
          height: 64,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'After Discount',
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 14 : 20,
                  fontFamily: 'Nunito-Regular',
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
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Menu Items',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 14 : 20,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 80,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Before Discount',
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 14 : 20,
                  fontFamily: 'Nunito-Regular',
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
          height: 70,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                afterPrice,
                style: TextStyle(
                  color: AppColors.botomSheetColor,
                  fontSize: Responsive.isMobile(context) ? 10 : 14,
                  fontFamily: 'Nunito-Regular',
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

  const RatingRowWidget({super.key, required this.isImage});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return Container(
      width: Responsive.isMobile(context) ? 300 : Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Deanna Blanda',
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context)
                          ? 7
                          : isLargeScreen
                              ? 18
                              : 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Nunito-Regular',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '(4.0) ', // Rating text
                      style: TextStyle(
                        color: const Color(0xFF4F5761),
                        fontSize: Responsive.isMobile(context)
                            ? 7
                            : isLargeScreen
                                ? 18
                                : 14,
                        fontFamily: 'Nunito-Regular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    WidgetSpan(
                      child: SizedBox(
                        height: Responsive.isMobile(context)
                            ? 7
                            : isLargeScreen
                                ? 18
                                : 14,
                        child: RatingBar(
                          itemSize: 10,
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
                            ),
                            half: Image.asset(
                              'assets/images/star yellow.png',
                              height: 14,
                            ),
                            empty: Image.asset(
                              'assets/images/star_empty.png',
                              height: 14,
                            ),
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
                width: Responsive.isMobile(context)
                    ? 230
                    : isLargeScreen
                        ? 700
                        : 600,
                height: Responsive.isMobile(context)
                    ? 5
                    : isLargeScreen
                        ? 50
                        : 40,
                child: Text(
                  'Voluptatem atque molestiae numquam voluptatem veritatis nesciunt commodi.',
                  style: TextStyle(
                    fontFamily: 'Nunito-Regular',
                    fontSize: Responsive.isMobile(context)
                        ? 7
                        : isLargeScreen
                            ? 18
                            : 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.botomSheetColor,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              if (isImage) // Conditional rendering of image if isImage is true
                Container(
                  height: Responsive.isMobile(context)
                      ? 40
                      : isLargeScreen
                          ? 100
                          : 80,
                  width: Responsive.isMobile(context)
                      ? 60
                      : isLargeScreen
                          ? 200
                          : 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          Responsive.isMobile(context) ? 4 : 8),
                      image: const DecorationImage(
                          image: AssetImage('assets/images/img1.png'),
                          fit: BoxFit.cover)),
                ),
              Text(
                'June 30,2024',
                style: TextStyle(
                  color: AppColors.botomSheetColor,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w400,
                  fontSize: Responsive.isMobile(context)
                      ? 7
                      : isLargeScreen
                          ? 18
                          : 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
