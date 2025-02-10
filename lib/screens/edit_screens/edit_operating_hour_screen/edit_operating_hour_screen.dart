import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/main.dart';

import '../../../constants/colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/round_button.dart';
import '../../../widgets/text_field.dart';
import '../../add_restaurant/edit_restaurant/edit_resturant.dart';
import '../../main_screen/mainscreen_controller/main_controller.dart';
import '../../restaurant_detail_screen/restaurant_detail_screen.dart';

class EditOperatingHourScreen extends GetxController {
  final TextEditingController aboutTextController = TextEditingController();
  ///add operating hour function
  /// Save all operating hours
  Future<void> saveAllOperatingHours() async {
    print("Saving Operating Hours...");

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print("Error: User not logged in.");
      return;
    }

    for (var day in mealTimes.keys) {
      Map<String, dynamic> mealsMap = {};

      if (dayToggles[day] == false) {
        print("$day is toggled off. Saving all meals as closed...");
        for (var meal in mealTimes[day]!.keys) {
          mealsMap[meal] = {"isClosed": true};
        }
      } else {
        for (var meal in mealTimes[day]!.keys) {
          if (cellToggles[day]![meal] == false) {
            mealsMap[meal] = {"isClosed": true};
            continue;
          }

          final fromTime = mealTimes[day]![meal]!['From'];
          final toTime = mealTimes[day]![meal]!['To'];

          if (fromTime == null || fromTime.isEmpty || toTime == null || toTime.isEmpty) {
            print("Skipping $meal on $day: Invalid times.");
            mealsMap[meal] = {"isClosed": true};
            continue;
          }

          mealsMap[meal] = {
            "isClosed": false,
            "startTime": fromTime,
            "endTime": toTime,
          };
        }
      }

      // Save using `merge: true` to avoid overwriting existing fields
      try {
        await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(uid)
            .collection('operatingHours')
            .doc(day)
            .set(mealsMap, SetOptions(merge: true)); // Merging instead of replacing
        print("$day saved successfully in Firestore.");
      } catch (e) {
        print("Error saving $day: $e");
      }
    }

    print("All operating hours saved successfully.");
  }


  RxString aboutError = ''.obs;

  void nextSave() {
    bool isValid = true;
    if (aboutTextController.text.isEmpty) {
      aboutError.value = "Enter your Text";
      isValid = false;
    } else {
      // You can add more validation rules here (e.g., minimum length, valid characters)
      if (aboutTextController.text.length < 3) {
        aboutError.value = "Text must be at least 3 characters";
        isValid = false;
      } else {
        aboutError.value = '';
      }

      if (isValid) {
        Get.snackbar("Success", "Data saved successfully!",
            backgroundColor: AppColors.primaryColor,
            colorText: Colors.white,
            maxWidth: 400);
        Get.to(() => EditRestaurantScreen(
              isFromButtonClick: true,
            ));
        aboutTextController.clear();
      }
    }
  }

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  // Stores the selected times for each meal of each day
  var mealTimes = <String, Map<String, Map<String, String>>>{}.obs;
  var dayToggles = <String, bool>{}.obs;
  var cellToggles = <String, Map<String, bool>>{}.obs;

  EditOperatingHourScreen() {
    for (var day in days) {
      mealTimes[day] = {
        'Breakfast': {'From': '', 'To': ''},
        'Brunch': {'From': '', 'To': ''},
        'Lunch': {'From': '', 'To': ''},
        'Dinner': {'From': '', 'To': ''},
        'Late Night': {'From': '', 'To': ''},
      };
      dayToggles[day] = true; // Default toggle is ON
      cellToggles[day] = {
        'Breakfast': true,
        'Brunch': true,
        'Lunch': true,
        'Dinner': true,
        'Late Night': true,
      };
    }
  }

  Future<void> selectTime(
      BuildContext context, String day, String meal, String type) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      mealTimes[day]![meal]![type] = picked.format(context);
      mealTimes.refresh();
    }
  }
}

class EditOperatingHourScreen1 extends StatelessWidget {
  final EditOperatingHourScreen controller = Get.put(EditOperatingHourScreen());
  final Function(int)? onNavigate;
  final mainController = Get.put(MainController());
  bool? isFromButtonClick;

  EditOperatingHourScreen1(
      {super.key, this.onNavigate, this.isFromButtonClick});

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
                  Text(
                    'Edit Operating Hours',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontFamily: 'Nunito-Regular',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('restaurants')
                      .doc(auth.currentUser!.uid)
                      .collection('operatingHours')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No operating hours found"));
                    }

                    // Process data from Firestore
                    var docs = snapshot.data!.docs;

                    controller.mealTimes.clear();
                    controller. dayToggles.clear();
                    controller.cellToggles.clear();

                    for (var doc in docs) {
                      String day = doc.id;
                      Map<String, dynamic> meals = doc.data() as Map<String, dynamic>;

                      controller.dayToggles[day] = meals.values.any((meal) => !meal["isClosed"]);
                      controller.cellToggles[day] = {};
                      controller.mealTimes[day] = {};

                      meals.forEach((mealName, mealData) {
                        bool isClosed = mealData["isClosed"] ?? true;
                        controller.cellToggles[day]![mealName] = !isClosed;

                        controller. mealTimes[day]![mealName] = {
                          "From": isClosed ? "" : mealData["startTime"],
                          "To": isClosed ? "" : mealData["endTime"],
                        };
                      });
                    }
                    return   LayoutBuilder(
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
                                        ? Get.width * 0.4
                                        : Get.width * 0.2,
                                    onPressed: () {
                                      controller.saveAllOperatingHours();
                                      // Get.snackbar('Update',
                                      //     'Your data is successfully updated.');
                                      // Get.to(() => RestaurantDetailScreen(
                                      //   isFromButtonClick: true,
                                      // ));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },)
            ],
          ),
        ),
      ),
    );
  }
}
