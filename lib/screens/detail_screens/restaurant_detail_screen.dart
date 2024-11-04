import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaistable_website/screens/detail_screens/controller/restaurant_detail_controller.dart';
import 'package:kaistable_website/screens/detail_screens/widget/gallary_container.dart';
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
import '../home_screen/my_home_screen.dart';
import 'widget/about_section_widget.dart';

class RestaurantDetailScreen extends StatelessWidget {

  final controller = Get.put(RestaurantDetailController());
  final LocationListController locationController = LocationListController();
  RestaurantDetailScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return WillPopScope(
      onWillPop: ()async{
        Get.back();
        return false;

      },
      child:
           Scaffold(
             appBar: AppBar(
               iconTheme: IconThemeData(
                 color: AppColors.primaryColor, // Set your desired color for the drawer icon
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
                       Get.offAll(MyHomeScreen()); // Navigate back to the home screen
                     },
                     child: Icon(Icons.arrow_back, size: 18),
                   ),
                 ),
               ),

               title: Text('Resturant details',
                 style: const TextStyle(
                   fontSize: 20,
                   color: AppColors.primaryColor,
                   fontWeight: FontWeight.w700,
                   fontFamily: 'Nunito-Bold',
                 ),),
             ),
             body: SingleChildScrollView(
               child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isMobile(context) ? 22 : 46.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0,right: 6),
                      child: OverflowBar(
                        overflowAlignment: OverflowBarAlignment.center,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/ihop-restaurant-logo 1.png',
                                height: 40,
                                width: 40,
                              ),
                               SizedBox(width:  Responsive.isMobile(context) ? 6 :Responsive.isTablet(context) ?4: 16),
                              Text(
                                'Ihop restaurant @ Tseug Kwan O',
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontFamily: 'Nunito-Regular',
                                  fontSize: Responsive.isMobile(context) ?13 :Responsive.isTablet(context) ?14: 32,
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
                                  fontSize: Responsive.isMobile(context) ? 12 :Responsive.isTablet(context) ?10:16,
                                  fontFamily: 'Nunito-Regular',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: Responsive.isMobile(context) ? 10 :14,
                                child: RatingBar(
                                  itemSize: Responsive.isMobile(context) ? 10 :Responsive.isTablet(context) ?12:14,
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
                                  itemPadding: const EdgeInsets.only(left: 2.0,bottom: 20),
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
                                  fontSize: Responsive.isMobile(context) ? 12 :Responsive.isTablet(context) ?10:16,
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
                                  fontSize: Responsive.isMobile(context) ? 12 :Responsive.isTablet(context) ?10:16,
                                  fontFamily: 'Nunito-Regular',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),


                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                          SizedBox(height: 10,),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Obx(() {
                                  return InkWell(
                                    onTap: () {
                                      controller.isFavorite.toggle();
                                    },
                                    child: Icon(
                                      Icons.favorite,
                                      size: 18,
                                      color: controller.isFavorite.value
                                          ? Colors.red
                                          : AppColors.darkGrey,
                                    ),
                                  );
                                }),
                                SizedBox(width: 10,),
                                Text(
                                  'add to favourite',
                                  style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontSize: Responsive.isMobile(context) ? 12 :Responsive.isTablet(context) ?10:16,
                                    fontFamily: 'Nunito-Regular',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.isMobile(context) ? 10 : 18),
                    GallaryContainer(),
                    SizedBox(height: Responsive.isMobile(context) ? 10 : 18),
                    Column(
                      children: [
                        Tabs(controller: controller),
                        Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: Responsive.isMobile(context) ? 20 : 45,
                                  right: Responsive.isMobile(context) ? 19 :30),
                              child: SizedBox(
                                height: Responsive.isMobile(context)
                                    ? 80
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
                                              ? 10
                                              : isLargeScreen
                                                  ? 48
                                                  : 18.0,
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
                              left: 0, // Adjust the value to add space from the list
                              top: 0,
                              bottom: 0,
                              child: InkWell(
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
                                  0, // Adjust the value to add space from the list
                              top: 0,
                              bottom: 0,
                              child: InkWell(
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
                      return controller.selectedTop.value == 'About'
                          ? AboutSectionWidget()
                          : controller.selectedTop.value == 'Reviews'
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
                                      padding: const EdgeInsets.all(8.0),
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

                                                decoration:const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft:Radius.circular(10),
                                                    bottomLeft: Radius.circular(10)
                                                  )
                                                ),

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
                                                      menuItem: 'Our Specialty ',
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
                                                      BorderRadius.circular(10),
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
                        fontSize: Responsive.isMobile(context) ? 16 : 28,
                        fontFamily: 'aftika-regular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: Responsive.isMobile(context) ? 30 : 22),
                    Container(
                      width: Get.width,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        children: [
                          Responsive.isMobile(context) || Responsive.isTablet(context)
                              ? Padding(
                                padding: const EdgeInsets.all(13),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                      width: Get.width * 0.7,
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
                         ),
             ),
           )

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(image, width: 65, height: 43 ),
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
                    decoration: TextDecoration.lineThrough,
                    decorationColor: AppColors.botomSheetColor,
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
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'After Discount',
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 14 : 26,
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
                  fontSize: Responsive.isMobile(context) ? 13 : 26,
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
            padding: EdgeInsets.all(18.0),
            child: Center(
              child: Text(
                'Before Discount',
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 13 : 26,
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
  final List<String> imagePaths;

  const RatingRowWidget({super.key, required this.isImage, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Deanna Blanda',
              style: TextStyle(
                fontSize: Responsive.isMobile(context) ? 14 : isLargeScreen ? 18 : 14,
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
                  fontSize: Responsive.isMobile(context) ? 14 : isLargeScreen ? 18 : 14,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w400,
                ),
              ),
              WidgetSpan(
                child: SizedBox(
                  height: Responsive.isMobile(context) ? 14 : isLargeScreen ? 18 : 14,
                  child: RatingBar(
                    itemSize: 12,
                    ignoreGestures: true,
                    initialRating: 4,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                      full: Image.asset('assets/images/star yellow.png', height: 14),
                      half: Image.asset('assets/images/star yellow.png', height: 14),
                      empty: Image.asset('assets/images/star_empty.png', height: 14),
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
          width: Responsive.isMobile(context) ? Get.width : isLargeScreen ? 700 : 600,
          height: Responsive.isMobile(context) ? 34 : isLargeScreen ? 50 : 40,
          child: Text(
            'Voluptatem atque molestiae numquam voluptatem bxca veritatis nesciunt comm odi.',
            style: TextStyle(
              fontFamily: 'Nunito-Regular',
              fontSize: Responsive.isMobile(context) ? 12 : isLargeScreen ? 18 : 14,
              fontWeight: FontWeight.w400,
              color: AppColors.botomSheetColor,
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 3),
            if (isImage) // Display images only if isImage is true
              SizedBox(
                height: Responsive.isMobile(context) ? 50 : isLargeScreen ? 100 : 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 8.0), // Space between images
                      height: Responsive.isMobile(context) ? 50 : isLargeScreen ? 100 : 80,
                      width: Responsive.isMobile(context) ? 100 : isLargeScreen ? 200 : 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Responsive.isMobile(context) ? 4 : 8),
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'June 30, 2024',
                style: TextStyle(
                  color: AppColors.botomSheetColor,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w400,
                  fontSize: Responsive.isMobile(context) ? 12 : isLargeScreen ? 18 : 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


