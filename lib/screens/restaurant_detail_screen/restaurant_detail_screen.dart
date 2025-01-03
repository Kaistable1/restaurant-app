import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/screens/edit_screens/edit_operating_hour_screen/edit_operating_hour_screen.dart';
import 'package:restaurant_web_app/screens/main_screen/main_screen.dart';
import 'package:restaurant_web_app/screens/main_screen/mainscreen_controller/main_controller.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/tabbar/tabbar_controller/tab_controller.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/widget/custom_tabbar.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/widget/footer_widget.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/widget/grid_view.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/widget/image_slider2.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/widget/map_widget.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/widget/number_text_widget.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/widget/operating_hours.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/widget/review_widget.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/widget/star_widget_gen_discount.dart';

import '../../../constants/colors.dart';
import '../../../utils/responsive.dart';
import '../edit_screens/edit_discount/edit_discount.dart';
import '../edit_screens/edit_entertainment/edit_entertainment_screen.dart';
import '../edit_screens/edit_facilities_screen/edit_facilities_screen.dart';
import '../edit_screens/edit_restaurant_discount_screen/edit_restaurant_detail_screen.dart';
import 'controller/restaurant_detail_controller.dart';
import 'widget/image_slider.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  final controller = Get.put(RestaurantDetailController());
  final TabControllerModel tabControllerModel = Get.put(TabControllerModel());

  RestaurantDetailScreen({super.key, this.onNavigate, this.isFromButtonClick});
  bool? isFromButtonClick;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLargeScreen = screenWidth > 1400;
    String? _selectedMenuItem;
    return GetBuilder<MainController>(builder: (mainController) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor.withOpacity(.3),
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
                            Text('Account Setting'),
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
                                  Get.offAll(() => MainScreen());
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            int itemsPerRow = Responsive.isMobile(context)
                ? 3
                : Responsive.isTablet(context)
                    ? 3
                    : 4;
            double itemWidth = (constraints.maxWidth / itemsPerRow) - 16;
            double itemHeight = Responsive.isMobile(context)
                ? 320
                : (isLargeScreen ? 500 : 500); // Set a fixed height for items

            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMobile(context) ? 22 : 22.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (isFromButtonClick == true)
                                  Container(
                                    width: Responsive.isMobile(context)
                                        ? 30 // Smaller size for mobile
                                        : (Responsive.isTablet(context)
                                            ? 36
                                            : 42), // Smaller tablet and desktop sizes
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
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      iconSize: Responsive.isMobile(context)
                                          ? 16 // Smaller icon size for mobile
                                          : (Responsive.isTablet(context)
                                              ? 20
                                              : 24), // Smaller tablet and desktop sizes
                                      icon: Icon(Icons.arrow_back,
                                          color: AppColors.primaryColor),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ),
                                SizedBox(
                                    width: Responsive.isMobile(context)
                                        ? 15
                                        : Responsive.isTablet(context)
                                            ? 20
                                            : 24),
                                Image.asset(
                                  'assets/images/ihop-restaurant-logo 1.png',
                                  height: 40,
                                  width: 40,
                                ),
                                SizedBox(
                                    width: Responsive.isMobile(context)
                                        ? 0
                                        : Responsive.isTablet(context)
                                            ? 4
                                            : 16),
                                Text(
                                  'Paradise Dynasity @ Tseug Kwan O',
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontFamily: 'Nunito-Regular',
                                    fontSize: Responsive.isMobile(context)
                                        ? 8
                                        : Responsive.isTablet(context)
                                            ? 14
                                            : 32,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Text(
                                      'Italian',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontFamily: 'Nunito-Regular',
                                        fontSize: Responsive.isMobile(context)
                                            ? 12
                                            : Responsive.isTablet(context)
                                                ? 16
                                                : 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/dropdown2.png', // Replace with your image path
                                            width: 36,
                                            height: 36,
                                          ),
                                        ],
                                      ),
                                      onSelected: (value) {
                                        _selectedMenuItem = value;

                                        // Perform navigation or actions based on the selected menu item
                                        switch (value) {
                                          case 'Edit Restaurant':
                                            Get.to(() =>
                                                EditRestaurantDetailScreen(
                                                  isFromButtonClick: true,
                                                )); // Navigate to Edit Restaurant screen
                                            break;
                                          case 'Edit Facilities':
                                            Get.to(EditFacilitiesScreen(
                                              isFromButtonClick: true,
                                            )); // Navigate to Facilities screen
                                            break;
                                          case 'Edit Entertainment':
                                            Get.to(EditEntertainmentScreen(
                                              isFromButtonClick: true,
                                            )); // Navigate to Facilities screen
                                            break;
                                          case 'Edit Operating Hour':
                                            Get.to(EditOperatingHourScreen1(
                                              isFromButtonClick: true,
                                            )); // Navigate to Operating Hour screen
                                            break;
                                          case 'Edit Discount':
                                            Get.to(EditDiscountScreen(
                                              isFromButtonClick: true,
                                            )); // Navigate to Discount screen
                                            break;
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'Edit Restaurant',
                                          child: Text('Edit Restaurant'),
                                        ),
                                        PopupMenuItem(
                                          value: 'Edit Facilities',
                                          child: Text('Edit Facilities'),
                                        ),
                                        PopupMenuItem(
                                          value: 'Edit Entertainment',
                                          child: Text('Edit Entertainment'),
                                        ),
                                        PopupMenuItem(
                                          value: 'Edit Operating Hour',
                                          child: Text('Edit Operating Hour'),
                                        ),
                                        PopupMenuItem(
                                          value: 'Edit Discount',
                                          child: Text('Edit Discount'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Responsive.isMobile(context) ? 20 : 22),
                      ImageSlider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tabs(controller: controller),
                            SizedBox(
                              height: isLargeScreen
                                  ? screenHeight * .9
                                  : screenHeight * 1.4,
                              child: Material(
                                color: AppColors.whiteColor,
                                child: CustomTabBarWidget(
                                  tabs: [
                                    "Percentage Off",
                                    "Happy Hours Specials",
                                    "Entertainment",
                                  ],
                                  tabViews: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.watch_later_outlined,
                                              color: AppColors.primaryColor,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'choose time & discount',
                                              style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontFamily: 'Nunito-Regular',
                                                fontSize:
                                                    Responsive.isMobile(context)
                                                        ? 16
                                                        : Responsive.isTablet(
                                                                context)
                                                            ? 18
                                                            : 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Stack(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: Responsive.isMobile(
                                                          context)
                                                      ? 20
                                                      : 45,
                                                  right: Responsive.isMobile(
                                                          context)
                                                      ? 2
                                                      : 30),
                                              child: SizedBox(
                                                height:
                                                    Responsive.isMobile(context)
                                                        ? 140
                                                        : isLargeScreen
                                                            ? 200
                                                            : 140,
                                                child: ListView.builder(
                                                  controller: controller
                                                      .scrollController,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: controller
                                                      .circleItems
                                                      .length, // Number of items
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item = controller
                                                            .circleItems[
                                                        index]; // Get item from model list
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: Responsive
                                                                      .isMobile(
                                                                          context)
                                                                  ? 10
                                                                  : isLargeScreen
                                                                      ? 48
                                                                      : 18.0,
                                                              vertical: Responsive
                                                                      .isMobile(
                                                                          context)
                                                                  ? 6
                                                                  : 6),
                                                      child: LocationStarWidget(
                                                        // isLocation: true,

                                                        timeText: item.timeText,
                                                        persentText:
                                                            item.persentText,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            // Left Arrow button with padding for spacing

                                            Positioned(
                                              left:
                                                  0, // Adjust the value to add space from the list
                                              top: 0,
                                              bottom: 0,
                                              child: InkWell(
                                                onTap: () =>
                                                    controller.scrollLeft(),
                                                child: Image.asset(
                                                  'assets/images/arrow_back.png',
                                                  height: Responsive.isMobile(
                                                          context)
                                                      ? 32
                                                      : 52,
                                                  width: Responsive.isMobile(
                                                          context)
                                                      ? 32
                                                      : 52,
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
                                                onTap: () =>
                                                    controller.scrollRight(),
                                                child: Image.asset(
                                                  'assets/images/arrow_forward.png',
                                                  height: Responsive.isMobile(
                                                          context)
                                                      ? 32
                                                      : 52,
                                                  width: Responsive.isMobile(
                                                          context)
                                                      ? 32
                                                      : 52,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: Responsive.isMobile(context)
                                                ? 2
                                                : 22),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Meals',
                                              style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontFamily: 'Nunito-Regular',
                                                fontSize:
                                                    Responsive.isMobile(context)
                                                        ? 16
                                                        : Responsive.isTablet(
                                                                context)
                                                            ? 18
                                                            : 20,
                                                // fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Italian ',
                                                style: TextStyle(
                                                  fontSize: Responsive.isMobile(
                                                          context)
                                                      ? 16
                                                      : Responsive.isTablet(
                                                              context)
                                                          ? 18
                                                          : 20,
                                                  // fontWeight: FontWeight.w700,
                                                ),
                                                children: [
                                                  WidgetSpan(
                                                    child: Image.asset(
                                                      'assets/images/dish.png', // Replace with your image path
                                                      width:
                                                          30, // Adjust image width
                                                      height:
                                                          30, // Adjust image height
                                                      color: Colors
                                                          .teal, // Optional: Apply a color overlay
                                                    ),
                                                    alignment: PlaceholderAlignment
                                                        .middle, // Align the image with the text
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: Responsive.isMobile(context)
                                                ? 2
                                                : 22),
                                        Center(
                                          child: Container(
                                            width: Responsive.isMobile(
                                                        context) ||
                                                    Responsive.isTablet(context)
                                                ? Get.width
                                                : Get.width * 0.7,
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

                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5), // Shadow color with opacity
                                                            spreadRadius:
                                                                2, // How wide the shadow spreads
                                                            blurRadius:
                                                                5, // How much the shadow blurs
                                                            offset: Offset(2,
                                                                3), // Horizontal and vertical offset
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10))),

                                                    child: Table(
                                                      border: TableBorder.symmetric(
                                                          inside: BorderSide(
                                                              width: 1,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5))),
                                                      // columnWidths: {
                                                      //   0:   FixedColumnWidth(Get.width*0.2),
                                                      //   1:   FlexColumnWidth(Get.width*0.2),
                                                      // },
                                                      children: [
                                                        _buildTableHeader(
                                                            context, ""),
                                                        _buildTableRow(
                                                          context,

                                                          image:
                                                              'assets/images/menu1.png',
                                                          menuItem: 'Food menu',
                                                          // beforePrice: '\$30',
                                                        ),
                                                        _buildTableRow(
                                                          context,
                                                          image:
                                                              'assets/images/menu2.png',
                                                          menuItem:
                                                              'Drink menu',
                                                          // beforePrice: '\$20',
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
                                                      color: AppColors
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: Responsive
                                                                  .isMobile(
                                                                      context)
                                                              ? 41
                                                              : 71.0),
                                                      child: Table(
                                                        border: TableBorder.symmetric(
                                                            inside: BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5))),
                                                        // columnWidths: {
                                                        //   0: const FlexColumnWidth(),
                                                        // },
                                                        children: [
                                                          _buildGreenHeader(
                                                              context),
                                                          _buildGreenRow(
                                                              context,
                                                              afterPrice:
                                                                  '50 % off'),
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
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.watch_later_outlined,
                                              color: AppColors.primaryColor,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'choose time & discount',
                                              style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontFamily: 'Nunito-Regular',
                                                fontSize:
                                                    Responsive.isMobile(context)
                                                        ? 16
                                                        : Responsive.isTablet(
                                                                context)
                                                            ? 18
                                                            : 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Stack(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: Responsive.isMobile(
                                                          context)
                                                      ? 20
                                                      : 45,
                                                  right: Responsive.isMobile(
                                                          context)
                                                      ? 2
                                                      : 30),
                                              child: SizedBox(
                                                height:
                                                    Responsive.isMobile(context)
                                                        ? 140
                                                        : isLargeScreen
                                                            ? 200
                                                            : 140,
                                                child: ListView.builder(
                                                  controller: controller
                                                      .scrollController,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: controller
                                                      .circleItems2
                                                      .length, // Number of items
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item = controller
                                                            .circleItems2[
                                                        index]; // Get item from model list
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: Responsive
                                                                      .isMobile(
                                                                          context)
                                                                  ? 10
                                                                  : isLargeScreen
                                                                      ? 48
                                                                      : 18.0,
                                                              vertical: Responsive
                                                                      .isMobile(
                                                                          context)
                                                                  ? 6
                                                                  : 6),
                                                      child: LocationStarWidget(
                                                        // isLocation: true,

                                                        timeText: item.timeText,
                                                        persentText:
                                                            item.persentText,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            // Left Arrow button with padding for spacing
                                            Positioned(
                                              left:
                                                  0, // Adjust the value to add space from the list
                                              top: 0,
                                              bottom: 0,
                                              child: InkWell(
                                                onTap: () =>
                                                    controller.scrollLeft(),
                                                child: Image.asset(
                                                  'assets/images/arrow_back.png',
                                                  height: Responsive.isMobile(
                                                          context)
                                                      ? 32
                                                      : 52,
                                                  width: Responsive.isMobile(
                                                          context)
                                                      ? 32
                                                      : 52,
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
                                                onTap: () =>
                                                    controller.scrollRight(),
                                                child: Image.asset(
                                                  'assets/images/arrow_forward.png',
                                                  height: Responsive.isMobile(
                                                          context)
                                                      ? 32
                                                      : 52,
                                                  width: Responsive.isMobile(
                                                          context)
                                                      ? 32
                                                      : 52,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: Responsive.isMobile(context)
                                                ? 2
                                                : 22),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Meals',
                                              style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontFamily: 'Nunito-Regular',
                                                fontSize:
                                                    Responsive.isMobile(context)
                                                        ? 16
                                                        : Responsive.isTablet(
                                                                context)
                                                            ? 18
                                                            : 20,
                                                // fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Italian ',
                                                style: TextStyle(
                                                  fontSize: Responsive.isMobile(
                                                          context)
                                                      ? 16
                                                      : Responsive.isTablet(
                                                              context)
                                                          ? 18
                                                          : 20,
                                                  // fontWeight: FontWeight.w700,
                                                ),
                                                children: [
                                                  WidgetSpan(
                                                    child: Image.asset(
                                                      'assets/images/dish.png', // Replace with your image path
                                                      width:
                                                          30, // Adjust image width
                                                      height:
                                                          30, // Adjust image height
                                                      color: Colors
                                                          .teal, // Optional: Apply a color overlay
                                                    ),
                                                    alignment: PlaceholderAlignment
                                                        .middle, // Align the image with the text
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: Responsive.isMobile(context)
                                                ? 2
                                                : 22),
                                        Center(
                                          child: Container(
                                            width: Responsive.isMobile(
                                                        context) ||
                                                    Responsive.isTablet(context)
                                                ? Get.width
                                                : Get.width * 0.7,
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

                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5), // Shadow color with opacity
                                                            spreadRadius:
                                                                2, // How wide the shadow spreads
                                                            blurRadius:
                                                                5, // How much the shadow blurs
                                                            offset: Offset(2,
                                                                3), // Horizontal and vertical offset
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10))),

                                                    child: Table(
                                                      border: TableBorder.symmetric(
                                                          inside: BorderSide(
                                                              width: 1,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5))),
                                                      // columnWidths: {
                                                      //   0:   FixedColumnWidth(Get.width*0.2),
                                                      //   1:   FlexColumnWidth(Get.width*0.2),
                                                      // },
                                                      children: [
                                                        _buildTableHeader(
                                                            context, ""),
                                                        _buildTableRow(
                                                          context,

                                                          image:
                                                              'assets/images/menu1.png',
                                                          menuItem:
                                                              'Drink menu',
                                                          // beforePrice: '\$30',
                                                        ),
                                                        _buildTableRow(
                                                          context,
                                                          image:
                                                              'assets/images/menu2.png',
                                                          menuItem: 'Food menu',
                                                          // beforePrice: '\$20',
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
                                                      color: AppColors
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: Responsive
                                                                  .isMobile(
                                                                      context)
                                                              ? 41
                                                              : 71.0),
                                                      child: Table(
                                                        border: TableBorder.symmetric(
                                                            inside: BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5))),
                                                        // columnWidths: {
                                                        //   0: const FlexColumnWidth(),
                                                        // },
                                                        children: [
                                                          _buildGreenHeader(
                                                              context),
                                                          _buildGreenRow(
                                                              context,
                                                              afterPrice:
                                                                  '30 % off'),
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
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          'Entertainment',
                                          style: TextStyle(
                                            color: AppColors.headingTextColor,
                                            fontSize:
                                                Responsive.isMobile(context)
                                                    ? 16
                                                    : 24,
                                            fontFamily: 'aftika-regular',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  minWidth:
                                                      constraints.maxWidth,
                                                ),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: DataTable(
                                                    border: TableBorder.all(
                                                      color: Colors.grey,
                                                      width: 1,
                                                    ),
                                                    headingRowColor:
                                                        MaterialStateProperty
                                                            .resolveWith((states) =>
                                                                AppColors
                                                                    .lightbgColor),
                                                    columns: const [
                                                      DataColumn(
                                                        label: Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              'Name',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              'By',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              'Day',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              'Date',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              'Time',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    rows: const [
                                                      DataRow(cells: [
                                                        DataCell(
                                                            Text('Live Music')),
                                                        DataCell(
                                                            Text('Neil Young')),
                                                        DataCell(
                                                            Text('Monday')),
                                                        DataCell(Text(
                                                            '31 Dec, 2024')),
                                                        DataCell(Text(
                                                            '09:00 am - 11:00 am')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(
                                                            Text('Live Music')),
                                                        DataCell(
                                                            Text('Neil Young')),
                                                        DataCell(
                                                            Text('Monday')),
                                                        DataCell(Text(
                                                            '31 Dec, 2024')),
                                                        DataCell(Text(
                                                            '09:00 am - 11:00 am')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(
                                                            Text('Live Music')),
                                                        DataCell(
                                                            Text('Neil Young')),
                                                        DataCell(
                                                            Text('Monday')),
                                                        DataCell(Text(
                                                            '31 Dec, 2024')),
                                                        DataCell(Text(
                                                            '09:00 am - 11:00 am')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(
                                                            Text('Live Music')),
                                                        DataCell(
                                                            Text('Neil Young')),
                                                        DataCell(
                                                            Text('Monday')),
                                                        DataCell(Text(
                                                            '31 Dec, 2024')),
                                                        DataCell(Text(
                                                            '09:00 am - 11:00 am')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(
                                                            Text('Live Music')),
                                                        DataCell(
                                                            Text('Neil Young')),
                                                        DataCell(
                                                            Text('Monday')),
                                                        DataCell(Text(
                                                            '31 Dec, 2024')),
                                                        DataCell(Text(
                                                            '09:00 am - 11:00 am')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(
                                                            Text('Live Music')),
                                                        DataCell(
                                                            Text('Neil Young')),
                                                        DataCell(
                                                            Text('Monday')),
                                                        DataCell(Text(
                                                            '31 Dec, 2024')),
                                                        DataCell(Text(
                                                            '09:00 am - 11:00 am')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(
                                                            Text('Live Music')),
                                                        DataCell(
                                                            Text('Neil Young')),
                                                        DataCell(
                                                            Text('Monday')),
                                                        DataCell(Text(
                                                            '31 Dec, 2024')),
                                                        DataCell(Text(
                                                            '09:00 am - 11:00 am')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(
                                                            Text('Live Music')),
                                                        DataCell(
                                                            Text('Neil Young')),
                                                        DataCell(
                                                            Text('Monday')),
                                                        DataCell(Text(
                                                            '31 Dec, 2024')),
                                                        DataCell(Text(
                                                            '09:00 am - 11:00 am')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(
                                                            Text('DJ Nights')),
                                                        DataCell(
                                                            Text('Neil Young')),
                                                        DataCell(
                                                            Text('Monday')),
                                                        DataCell(Text(
                                                            '31 Dec, 2024')),
                                                        DataCell(Text(
                                                            '09:00 am - 11:00 am')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(
                                                            Text('Karaoke')),
                                                        DataCell(
                                                            Text('Neil Young')),
                                                        DataCell(
                                                            Text('Monday')),
                                                        DataCell(Text(
                                                            '31 Dec, 2024')),
                                                        DataCell(Text(
                                                            '09:00 am - 11:00 am')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(Text(
                                                            'Trivia Nights')),
                                                        DataCell(
                                                            Text('Neil Young')),
                                                        DataCell(
                                                            Text('Monday')),
                                                        DataCell(Text(
                                                            '31 Dec, 2024')),
                                                        DataCell(Text(
                                                            '09:00 am - 11:00 am')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(Text(
                                                            'Sports Screenings')),
                                                        DataCell(
                                                            Text('Neil Young')),
                                                        DataCell(
                                                            Text('Monday')),
                                                        DataCell(Text(
                                                            '31 Dec, 2024')),
                                                        DataCell(Text(
                                                            '09:00 am - 11:00 am')),
                                                      ]),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                  activeColor: AppColors.primaryColor,
                                  inactiveColor:
                                      AppColors.darkGrey.withOpacity(.5),
                                  backgroundColor: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      OperatingHours(),
                      Text(
                        'Specials Conditions',
                        style: TextStyle(
                          color: AppColors.headingTextColor,
                          fontSize: Responsive.isMobile(context) ? 16 : 24,
                          fontFamily: 'aftika-regular',
                          fontWeight: FontWeight.w700,
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
                      SizedBox(height: Responsive.isMobile(context) ? 12 : 22),
                      ReviewsAndRatings(
                        ratingsCount: [53, 53, 53, 53, 53],
                        averageRating: 4.5,
                      ),
                      SizedBox(height: Responsive.isMobile(context) ? 12 : 22),
                      ReviewGridScreen(),
                      SizedBox(height: Responsive.isMobile(context) ? 12 : 22),
                      Text(
                        'About',
                        style: TextStyle(
                          color: AppColors.headingTextColor,
                          fontSize: Responsive.isMobile(context) ? 16 : 24,
                          fontFamily: 'aftika-regular',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: Responsive.isMobile(context) ? 12 : 22),
                      Padding(
                        padding: const EdgeInsets.only(right: 28.0),
                        child: Text(
                          'The modern and elegant Flava Lite Rooftop Pool Bar & Cafe, located on the 11th floor, offers stunning views of the city skyline. Guests can unwind and enjoy a drink or a meal in a serene and relaxing atmosphere from morning until late at night. Whether you choose to sit outdoors and soak in the panoramic views or dine indoors surrounded by chic and minimalistic decor, this rooftop pool bar provides a comfortable environment. Thai-style marinated beef skewers with coriander seed are great to pair with any of your favorite drinks, while salt and pepper kurobuta crispy pork with steamed jasmine rice and Thai-style fried eggs may be more suitable for the hungrier patrons.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: AppColors.headingTextColor,
                            fontSize: Responsive.isMobile(context) ? 12 : 16,
                            fontFamily: 'aftika-regular',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: Responsive.isMobile(context) ? 12 : 22),
                      Text(
                        'Map',
                        style: TextStyle(
                          color: AppColors.headingTextColor,
                          fontSize: Responsive.isMobile(context) ? 16 : 24,
                          fontFamily: 'aftika-regular',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: Responsive.isMobile(context) ? 12 : 22),
                      Container(
                        width: Get.width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          children: [
                            Responsive.isMobile(context) ||
                                    Responsive.isTablet(context)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18.0, top: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: Get.width * 0.8,
                                          height: 400,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child:
                                              MapWidget(controller: controller),
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
                                        width: Get.width * 0.4,
                                        height: 400,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        child:
                                            MapWidget(controller: controller),
                                      ),
                                      const SizedBox(
                                        width: 40,
                                      ),
                                      const MapDetailWidget()
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(height: Responsive.isMobile(context) ? 22 : 42),
                      FooterWidget(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // Normal table rows for "Menu Items" and "Before Discount" columns
  TableRow _buildTableRow(
    context, {
    required String image,
    required String menuItem,
    // required String beforePrice,
  }) {
    return TableRow(
      children: [
        Container(
          height: Responsive.isDesktop(context) ? 130 : 160,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
            child: Responsive.isDesktop(context)
                ? Row(
                    children: [
                      // Image.asset(image, width: 55, height: 49),
                      ImageSlider2(),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(menuItem,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: Responsive.isMobile(context) ? 14 : 16,
                              fontFamily: 'Nunito-Regular',
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      // Image.asset(image, width: 55, height: 49),
                      ImageSlider2(),
                      const SizedBox(height: 6),
                      Text(menuItem,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: Responsive.isMobile(context) ? 14 : 16,
                            fontFamily: 'Nunito-Regular',
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
          ),
        ),
        // Container(
        //   height: 80,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Center(
        //       child: Text('',
        //           style: TextStyle(
        //             decoration: TextDecoration.lineThrough,
        //             decorationColor: AppColors.botomSheetColor,
        //             color: AppColors.botomSheetColor,
        //             fontSize: Responsive.isMobile(context) ? 10 : 14,
        //             fontFamily: 'Nunito-Regular',
        //             fontWeight: FontWeight.w700,
        //           )),
        //     ),
        //   ),
        // ),
      ],
    );
  } // Header for the green column (After discount)

  TableRow _buildGreenHeader(context) {
    return TableRow(
      children: [
        SizedBox(
          height: 80,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Offer',
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

  TableRow _buildTableHeader(context, String price) {
    return TableRow(
      children: [
        Container(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Menu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 14 : 26,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        // Container(
        //   height: 80,
        //   child: Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: Center(
        //       child: Text(
        //         price,
        //         style: TextStyle(
        //           fontSize: Responsive.isMobile(context) ? 14 : 26,
        //           fontFamily: 'Nunito-Regular',
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // Rows for the green column
  TableRow _buildGreenRow(context, {required String afterPrice}) {
    return TableRow(
      children: [
        Container(
          height: Responsive.isDesktop(context) ? 130 : 160,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                afterPrice,
                style: TextStyle(
                  color: AppColors.botomSheetColor,
                  fontSize: Responsive.isMobile(context) ? 14 : 16,
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
