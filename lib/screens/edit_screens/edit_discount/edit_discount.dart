import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/screens/edit_screens/update_discount/update_discount.dart';
import 'package:restaurant_web_app/screens/main_screen/main_screen.dart';
import 'package:restaurant_web_app/screens/main_screen/mainscreen_controller/main_controller.dart';
import 'package:restaurant_web_app/utils/responsive.dart';

import '../../restaurant_detail_screen/widget/custom_tabbar.dart';
import '../../restaurant_detail_screen/widget/star_widget_gen_discount.dart';
import 'edit_discount_controller/edit_discount_controller.dart';

class EditDiscountScreen extends StatelessWidget {
  final RxList<int> discountItems = List.generate(6, (index) => index).obs;
  final controller = Get.put(DiscountController());

  final Function(int)? onNavigate;

  final mainController = Get.put(MainController());

  EditDiscountScreen({super.key, this.onNavigate, this.isFromButtonClick});
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

                                Get.offAll(MainScreen());
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * 1.3,
              child: Material(
                child: CustomTabBarWidget(
                  // width1: 600,
                  tabs: [
                    "Percentage Off",
                    "Happy Hours Specials",
                  ],
                  tabViews: [
                    _buildDiscountTab(context),
                    _buildDiscountTabHappy(context),
                  ],
                  activeColor: AppColors.primaryColor,
                  inactiveColor: AppColors.darkGrey.withOpacity(.5),
                  backgroundColor: AppColors.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header Widget
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _buildBackButton(context),
        SizedBox(width: Responsive.isMobile(context) ? 20 : 40),
        Text(
          'Edit Discounts',
          style: TextStyle(
            color: AppColors.text,
            decoration: TextDecoration.none,
            fontSize: Responsive.isMobile(context)
                ? 18
                : (Responsive.isTablet(context) ? 25 : 32),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      width: Responsive.isMobile(context) ? 30 : 42,
      height: Responsive.isMobile(context) ? 30 : 42,
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
            ? 16
            : (Responsive.isTablet(context) ? 20 : 24),
        icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
        onPressed: () {
          Navigator.of(context).pop(); // Back action
        },
      ),
    );
  }

  // Build Discount Tab
  // Build Discount Tab
  Widget _buildDiscountTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discount Times',
            style: TextStyle(
              color: AppColors.headingTextColor,
              fontSize: Responsive.isMobile(context) ? 16 : 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              // Set grid items per row based on the screen width
              int crossAxisCount = 3; // Default to 3 for mobile

              if (constraints.maxWidth >= 600 && constraints.maxWidth < 1200) {
                crossAxisCount = 4; // For tablet view, 4 containers
              } else if (constraints.maxWidth >= 1200) {
                crossAxisCount = 6; // For desktop view, 6 containers
              }

              return Obx(() {
                return SizedBox(
                  height: 500,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 211 / 238,
                    ),
                    itemCount: discountItems.length,
                    itemBuilder: (context, index) {
                      return _buildCustomContainer(index, context);
                    },
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountTabHappy(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discount Times',
            style: TextStyle(
              color: AppColors.headingTextColor,
              fontSize: Responsive.isMobile(context) ? 16 : 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              // Set grid items per row based on the screen width
              int crossAxisCount = 3; // Default to 3 for mobile

              if (constraints.maxWidth >= 600 && constraints.maxWidth < 1200) {
                crossAxisCount = 4; // For tablet view, 4 containers
              } else if (constraints.maxWidth >= 1200) {
                crossAxisCount = 6; // For desktop view, 6 containers
              }

              return Obx(() {
                return SizedBox(
                  height: 500,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 211 / 238,
                    ),
                    itemCount: discountItems.length,
                    itemBuilder: (context, index) {
                      return _buildCustomContainerHappy(index, context);
                    },
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  // Build Custom Container
  Widget _buildCustomContainer(int index, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1600;
    return Container(
      width: Responsive.isMobile(context)
          ? MediaQuery.of(context).size.width * 0.8
          : (Responsive.isTablet(context) ? 180 : 200),
      height: Responsive.isMobile(context)
          ? 200
          : (Responsive.isTablet(context) ? 250 : 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              'assets/images/p1.png',
              width: double.infinity,
              height: Responsive.isMobile(context)
                  ? 110
                  : (Responsive.isTablet(context)
                      ? 130
                      : isLargeScreen
                          ? 230
                          : 150),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: isLargeScreen ? 12 : 8,
            child: GestureDetector(
              onTap: () {
                discountItems.removeAt(index); // Remove item
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 10),
              ),
            ),
          ),
          Positioned(
            bottom: Responsive.isMobile(context)
                ? 70
                : (Responsive.isTablet(context)
                    ? 70
                    : isLargeScreen
                        ? 150
                        : 90),
            right: isLargeScreen ? 14 : 10,
            child: GestureDetector(
              onTap: () {
                Get.to(() => UpdateDiscount(
                      isFromButtonClick: true,
                    )); // Navigate to edit screen
              },
              child: Image.asset(
                'assets/images/btn_image.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 25,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // width: 80,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.primaryColor,
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text(
                      '03.10.2024 - 05.10.2024',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 1,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Percentage off 01',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: Responsive.isMobile(context)
                      ? 40
                      : Responsive.isDesktop(context)
                          ? 60
                          : 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Horizontal scrolling
                    itemCount:
                        controller.circleItems4.length, // Number of items
                    itemBuilder: (context, index) {
                      final item = controller
                          .circleItems4[index]; // Get item from model list
                      return SizedBox(
                        width: Responsive.isMobile(context)
                            ? 30
                            : Responsive.isDesktop(context)
                                ? 50
                                : 40, // Width of each item
                        child: LocationStarWidget(
                          timeText: '18:00-19:00',
                          persentText: '50% OFF',
                          persentTextStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor,
                            fontSize: Responsive.isMobile(context)
                                ? 4
                                : Responsive.isTablet(context)
                                    ? 5
                                    : 7,
                            fontFamily: 'Nunito-Regular',
                          ),
                          timeTextStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor,
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
        ],
      ),
    );
  }

  Widget _buildCustomContainerHappy(int index, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1600;
    return Container(
      width: Responsive.isMobile(context)
          ? MediaQuery.of(context).size.width * 0.8
          : (Responsive.isTablet(context) ? 180 : 200),
      height: Responsive.isMobile(context)
          ? 200
          : (Responsive.isTablet(context) ? 250 : 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              'assets/images/p1.png',
              width: double.infinity,
              height: Responsive.isMobile(context)
                  ? 110
                  : (Responsive.isTablet(context)
                      ? 130
                      : isLargeScreen
                          ? 230
                          : 150),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: isLargeScreen ? 12 : 8,
            child: GestureDetector(
              onTap: () {
                discountItems.removeAt(index); // Remove item
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 10),
              ),
            ),
          ),
          Positioned(
            bottom: Responsive.isMobile(context)
                ? 70
                : (Responsive.isTablet(context)
                    ? 70
                    : isLargeScreen
                        ? 150
                        : 90),
            right: isLargeScreen ? 14 : 10,
            child: GestureDetector(
              onTap: () {
                Get.to(() => UpdateDiscount(
                      isFromButtonClick: true,
                    )); // Navigate to edit screen
              },
              child: Image.asset(
                'assets/images/btn_image.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 25,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // width: 80,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.primaryColor,
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text(
                      '16.10.2024 - 24.10.2024',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 1,
            left: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Happy Hour Special',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: Responsive.isMobile(context)
                      ? 40
                      : Responsive.isDesktop(context)
                          ? 60
                          : 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Horizontal scrolling
                    itemCount:
                        controller.circleItems4.length, // Number of items
                    itemBuilder: (context, index) {
                      final item = controller
                          .circleItems4[index]; // Get item from model list
                      return SizedBox(
                        width: Responsive.isMobile(context)
                            ? 30
                            : Responsive.isDesktop(context)
                                ? 50
                                : 40, // Width of each item
                        child: LocationStarWidget(
                          timeText: '18:00-19:00',
                          persentText: '50% OFF',
                          persentTextStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor,
                            fontSize: Responsive.isMobile(context)
                                ? 4
                                : Responsive.isTablet(context)
                                    ? 5
                                    : 7,
                            fontFamily: 'Nunito-Regular',
                          ),
                          timeTextStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor,
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
        ],
      ),
    );
  }
}
