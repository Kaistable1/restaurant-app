import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/screens/add_restaurant/add_resturant_controller/add_resturant%20_controller.dart';

import '../../constants/colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/round_button.dart';
import '../../widgets/text_field.dart';
import '../add_restaurant/edit_restaurant/edit_resturant.dart';
import '../main_screen/mainscreen_controller/main_controller.dart';

class OperatingHourScreen1 extends StatelessWidget {
  final controller = Get.put(AddRestaurantController());
  final Function(int)? onNavigate;
  final mainController = Get.put(MainController());
  bool? isFromButtonClick;

  OperatingHourScreen1({super.key, this.onNavigate, this.isFromButtonClick});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1600;
    controller.aboutError.value = '';
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
                                mainController.showLogoutDialog(context);
                              } else {
                                mainController.selectedMenuItem = value;
                                mainController.isAddingRestaurant = false;
                                mainController.update();
                                Get.close(3);
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      controller.saveOperatingHours();
                    },
                    child: const Text(
                      'Add Operating Hours',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontFamily: 'Nunito-Regular',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            text: 'Operating hours ',
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
                        SizedBox(height: 10),
                        ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: constraints.maxWidth),
                          child: Obx(
                            () => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(30.0),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .white, // Set background color to white
                                    borderRadius: BorderRadius.circular(
                                        10), // Set circular border with radius 6
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: DataTable(
                                    columnSpacing: 10,
                                    columns: [
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'Days',
                                              style: TextStyle(
                                                fontSize:
                                                    Responsive.isMobile(context)
                                                        ? 12
                                                        : Responsive.isTablet(
                                                                context)
                                                            ? 16
                                                            : 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'Breakfast',
                                              style: TextStyle(
                                                fontSize:
                                                    Responsive.isMobile(context)
                                                        ? 12
                                                        : Responsive.isTablet(
                                                                context)
                                                            ? 16
                                                            : 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'Brunch',
                                              style: TextStyle(
                                                fontSize:
                                                    Responsive.isMobile(context)
                                                        ? 12
                                                        : Responsive.isTablet(
                                                                context)
                                                            ? 16
                                                            : 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'Lunch',
                                              style: TextStyle(
                                                fontSize:
                                                    Responsive.isMobile(context)
                                                        ? 12
                                                        : Responsive.isTablet(
                                                                context)
                                                            ? 16
                                                            : 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'Dinner',
                                              style: TextStyle(
                                                fontSize:
                                                    Responsive.isMobile(context)
                                                        ? 12
                                                        : Responsive.isTablet(
                                                                context)
                                                            ? 16
                                                            : 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Center(
                                            child: Text(
                                              'Late Night',
                                              style: TextStyle(
                                                fontSize:
                                                    Responsive.isMobile(context)
                                                        ? 12
                                                        : Responsive.isTablet(
                                                                context)
                                                            ? 16
                                                            : 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: controller.days.map((day) {
                                      bool isDayActive =
                                          controller.dayToggles[day]!;
                                      return DataRow(cells: [
                                        DataCell(
                                          Row(
                                            children: [
                                              Transform.scale(
                                                scale: 0.6,
                                                child: Switch(
                                                  value: isDayActive,
                                                  activeColor:
                                                      AppColors.whiteColor,
                                                  activeTrackColor:
                                                      AppColors.primaryColor,
                                                  inactiveThumbColor:
                                                      AppColors.primaryColor,
                                                  onChanged: (value) {
                                                    controller.dayToggles[day] =
                                                        value;
                                                    controller.dayToggles
                                                        .refresh();
                                                  },
                                                ),
                                              ),
                                              Text(
                                                day,
                                                style: TextStyle(
                                                  fontSize: Responsive.isMobile(
                                                          context)
                                                      ? 12
                                                      : Responsive.isTablet(
                                                              context)
                                                          ? 16
                                                          : 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ...[
                                          'Breakfast',
                                          'Brunch',
                                          'Lunch',
                                          'Dinner',
                                          'Late Night'
                                        ].map((meal) {
                                          bool isMealActive = controller
                                              .cellToggles[day]![meal]!;
                                          return DataCell(
                                            isDayActive
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                        child: InkWell(
                                                          onTap: isMealActive
                                                              ? () async {
                                                                  await controller
                                                                      .selectTime(
                                                                          context,
                                                                          day,
                                                                          meal,
                                                                          'From');
                                                                  await controller
                                                                      .selectTime(
                                                                          context,
                                                                          day,
                                                                          meal,
                                                                          'To');
                                                                }
                                                              : null,
                                                          child: Container(
                                                            height: 40,
                                                            width: 150,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: AppColors
                                                                      .darkGrey
                                                                      .withOpacity(
                                                                          .1)),
                                                              color: isMealActive
                                                                  ? AppColors
                                                                      .primaryColor
                                                                  : AppColors
                                                                      .darkGrey
                                                                      .withOpacity(
                                                                          .3),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Text(
                                                              isMealActive
                                                                  ? (controller
                                                                              .mealTimes[day]![meal]![
                                                                                  'From']!
                                                                              .isEmpty &&
                                                                          controller
                                                                              .mealTimes[day]![meal]!['To']!
                                                                              .isEmpty
                                                                      ? 'Set Time'
                                                                      : '${controller.mealTimes[day]![meal]!['From']} - ${controller.mealTimes[day]![meal]!['To']}')
                                                                  : 'Closed',
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .whiteColor),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Column(
                                                        children: [
                                                          ToggleButtons(
                                                            isSelected: [
                                                              isMealActive,
                                                              !isMealActive,
                                                            ],
                                                            onPressed: (index) {
                                                              controller.cellToggles[
                                                                          day]![
                                                                      meal] =
                                                                  index == 0;
                                                              controller
                                                                  .cellToggles
                                                                  .refresh();
                                                            },
                                                            direction:
                                                                Axis.vertical,
                                                            children: [
                                                              Container(
                                                                width: 30,
                                                                height: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            6),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            6),
                                                                  ),
                                                                  color: isMealActive
                                                                      ? AppColors
                                                                          .primaryColor
                                                                      : AppColors
                                                                          .darkGrey
                                                                          .withOpacity(
                                                                              .3),
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  'On',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 30,
                                                                height: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            6),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            6),
                                                                  ),
                                                                  color: !isMealActive
                                                                      ? AppColors
                                                                          .primaryColor
                                                                      : AppColors
                                                                          .darkGrey
                                                                          .withOpacity(
                                                                              .3),
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  'Off',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                            constraints:
                                                                BoxConstraints(
                                                                    minWidth:
                                                                        30,
                                                                    minHeight:
                                                                        20),
                                                            borderColor: Colors
                                                                .transparent, // No outer border
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Container(
                                                    height: 40,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.darkGrey
                                                          .withOpacity(.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      'Closed',
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                          );
                                        }).toList(),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            text: 'About ',
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
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: CustomTextField(
                            controller: controller.aboutTextController,
                            borderColor: AppColors.darkGrey.withOpacity(.1),
                            width:
                                isLargeScreen ? Get.width * .5 : Get.width * .9,
                            maxLine: 6,
                            borderRadius: 10,
                            hintText: "Add Text",
                            fillColor: AppColors.whiteColor,
                            cursorColor: AppColors.primaryColor,
                            inputStyle:
                                const TextStyle(color: AppColors.blackColor),
                            hintStyle:
                                const TextStyle(color: AppColors.blackColor),
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(() => controller.aboutError.value.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0),
                                child: Text(
                                  controller.aboutError.value,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              )
                            : const SizedBox.shrink()),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              title: "Save and Continue",
                              textStyle: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize:
                                    Responsive.isMobile(context) ? 16 : 18,
                                fontWeight: FontWeight.w600,
                              ),
                              backgroundColor: AppColors.primaryColor,
                              borderRadius: 8,
                              width: Responsive.isMobile(context)
                                  ? Get.width * 0.4
                                  : Get.width * 0.2,
                              onPressed: () {
                                controller.nextSave();
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            // CustomButton(
                            //   title: "Next",
                            //   textStyle: TextStyle(
                            //     color: AppColors.primaryColor,
                            //     fontSize:
                            //         Responsive.isMobile(context) ? 16 : 18,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            //   backgroundColor: AppColors.whiteColor,
                            //   borderClr: AppColors.primaryColor,
                            //   borderRadius: 8,
                            //   width: Responsive.isMobile(context)
                            //       ? Get.width * 0.1
                            //       : Get.width * 0.2,
                            //   onPressed: () {
                            //     Get.to(() => EditRestaurantScreen(
                            //           isFromButtonClick: true,
                            //         ));
                            //   },
                            // ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
