import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/colors.dart';
import 'package:restaurant_web_app/main.dart';
import 'package:restaurant_web_app/screens/edit_screens/update_discount/update_discount.dart';
import 'package:restaurant_web_app/screens/main_screen/main_screen.dart';
import 'package:restaurant_web_app/screens/main_screen/mainscreen_controller/main_controller.dart';
import 'package:restaurant_web_app/universal_models/discount_model.dart';
import 'package:restaurant_web_app/utils/responsive.dart';

import '../../../widgets/account_settings_popup_widget.dart';
import '../../../widgets/global_functions.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
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
                    _buildDiscountTab(context, "Percentage Off"),
                    _buildDiscountTab(context, "Happy Hours Specials"),
                    // _buildDiscountTabHappy(context),
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        iconSize: Responsive.isMobile(context)
            ? 16
            : (Responsive.isTablet(context) ? 20 : 24),
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
        onPressed: () {
          Navigator.of(context).pop(); // Back action
        },
      ),
    );
  }

  // Build Discount Tab
  Widget _buildDiscountTab(BuildContext context, String selectedTab) {
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
          const SizedBox(
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
              // Apply Firestore query based on the selected tab
              Query query = FirebaseFirestore.instance
                  .collection('restaurants')
                  .doc(auth.currentUser!.uid)
                  .collection('MealMenu');

              if (selectedTab == "Percentage Off") {
                query =
                    query.where('discountType', isEqualTo: 'Percentage Off');
              } else if (selectedTab == "Happy Hours Specials") {
                query = query.where('discountType',
                    isEqualTo: 'Happy Hour Special ');
              }
              return SizedBox(
                  height: 500,
                  child: StreamBuilder(
                    stream: query.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          width: Get.width,
                          height: 246,
                          child: const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primaryColor),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        print("Firestore Error: ${snapshot.error}");
                        return const Center(
                            child: Text("Something went wrong!"));
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        print("Firestore Data: ${snapshot.data!.docs.length}");
                        return const Center(
                            child: Text("No Discounts Found."));
                      }

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 211 / 238,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final docData = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>?;
                          if (docData == null) return const SizedBox();
                          DiscountModel discountModel =
                              DiscountModel.fromJson(docData);

                          String docID = snapshot.data!.docs[index].id;
                          return _buildCustomContainer(
                              index, context, discountModel, docID);
                        },
                      );
                    },
                  ));
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
          const SizedBox(
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
  Widget _buildCustomContainer(int index, BuildContext context,
      DiscountModel discountModel, String docID) {
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
            child: Image.network(
              discountModel.menu[0].items[0].itemImages.isNotEmpty
                  ? discountModel.menu[0].items[0].itemImages[0].value
                  : '', // Empty string to trigger errorBuilder
              width: double.infinity,
              height: Responsive.isMobile(context)
                  ? 95
                  : (Responsive.isTablet(context)
                      ? 120
                      : isLargeScreen
                          ? 210
                          : 140),
              fit: BoxFit.fitHeight,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: Responsive.isMobile(context)
                      ? 100
                      : (Responsive.isTablet(context)
                          ? 120
                          : isLargeScreen
                              ? 215
                              : 140),
                  color: Colors.grey[300], // Placeholder background color
                  child:
                      Icon(Icons.image_not_supported, color: Colors.grey[600]),
                );
              },
            ),
          ),
          Positioned(
            top: 8,
            right: isLargeScreen ? 12 : 8,
            child: GestureDetector(
              onTap: () async {
                await FirebaseFirestore.instance
                    .collection('restaurants')
                    .doc(auth.currentUser!.uid)
                    .collection('MealMenu')
                    .doc(docID)
                    .delete()
                    .then((value) {
                  print('done');
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
                child: const Icon(Icons.close, color: Colors.white, size: 10),
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
                    discountModel: discountModel,
                    docID: docID)); // Navigate to edit screen
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
                      discountModel.fromDate == '' && discountModel.toDate == ''
                          ? '  Lifetime  '
                          : '${formatDate(discountModel.fromDate)} - ${formatDate(discountModel.toDate)}',
                      style: const TextStyle(
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
                  discountModel.discountType,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: Responsive.isMobile(context)
                      ? 40
                      : Responsive.isDesktop(context)
                          ? 60
                          : 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Horizontal scrolling
                    itemCount: discountModel.menu.length, // Number of items
                    itemBuilder: (context, index) {
                      CategoryModel menuModel = discountModel.menu[index];
                      return SizedBox(
                        width: Responsive.isMobile(context)
                            ? 30
                            : Responsive.isDesktop(context)
                                ? 50
                                : 40, // Width of each item
                        child: LocationStarWidget(
                          timeText:
                              '${menuModel.fromTime} - ${menuModel.toTime}',
                          persentText: '${menuModel.percentageValue}% OFF',
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
              onTap: () async {
                // await FirebaseFirestore.instance
                //     .collection('restaurants')
                //     .doc(auth.currentUser!.uid)
                //     .collection('MealMenu')
                //     .doc(docID)
                //     .delete()
                //     .then((value) {
                //   print('done');
                // }).onError((error, stackTrace) {
                //   print('error');
                // });
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 10),
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
                // Get.to(() => UpdateDiscount(
                //       isFromButtonClick: true,
                //     )); // Navigate to edit screen
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.0),
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
                const Text(
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
        ],
      ),
    );
  }
}
