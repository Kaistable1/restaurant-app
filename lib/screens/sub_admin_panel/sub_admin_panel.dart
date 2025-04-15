import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/screens/events_managements/add_event/add_events.dart';
import 'package:savrly/screens/events_managements/view_events/view_event.dart';
import 'package:savrly/screens/events_managements/view_events/widget/event_details_gallary.dart';
import 'package:savrly/screens/restaurant_management/add_retaurants/add_restaurants_screen.dart';
import 'package:savrly/screens/restaurant_management/view_restaurant_details/view_restaurant_details.dart';
import '../../auth/login/login_screen.dart';
import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/button.dart';
import '../restaurant_management/restaurant_management_screen.dart';
import '../events_managements/events_managements.dart';
import '../../controllers/drawer_controller.dart';
import '../sub_admin_dashboard/sub_admin_dashboard_screen.dart';

class SubAdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DrawerControllerX controller = Get.put(DrawerControllerX());

    return Scaffold(
      backgroundColor: bgColor,
      appBar: MediaQuery.of(context).size.width < 800
          ? AppBar(
              backgroundColor: bgColor,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: primaryColor),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            )
          : null,
      drawer: MediaQuery.of(context).size.width < 800 ? SubAdminDrawer() : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width >= 800) SubAdminDrawer(),
          Expanded(child: Obx(() => _getSubAdminScreen(controller))),
        ],
      ),
    );
  }

  Widget _getSubAdminScreen(DrawerControllerX controller) {
    Widget screen;

    if (controller.viewRestaurantsDetails.value) {
      screen = ViewRestaurantDetails();
    } else if (controller.addRestaurants.value) {
      screen = AddRestaurantsScreen();
    } else if (controller.addEvent.value) {
      screen = AddEvents();
    } else if (controller.viewEvents.value) {
      screen = ViewEvent();
    } else if (controller.viewEventsGallery.value) {
      screen = EventDetailsGallery();
    } else {
      if (controller.selectedScreen.value == 0) {
        screen = SubAdminDashboardScreen();
      } else if (controller.selectedScreen.value == 1) {
        screen = RestaurantManagementScreen();
      } else {
        screen = EventsManagements();
      }
    }
    return screen;
  }
}

// Simple Drawer for Sub Admin
class SubAdminDrawer extends StatelessWidget {
  final DrawerControllerX controller = Get.find<DrawerControllerX>();

  @override
  Widget build(BuildContext context) {
    double drawerHeight = MediaQuery.of(context).size.height;
    double drawerWidth = MediaQuery.of(context).size.width < 600
        ? 257
        : MediaQuery.of(context).size.width < 900
            ? 280
            : MediaQuery.of(context).size.width < 1200
                ? 300
                : MediaQuery.of(context).size.width * 0.2;
    double iconSize = MediaQuery.of(context).size.width < 600 ? 20 : 24;
    double textSize = MediaQuery.of(context).size.width < 600 ? 14 : 16;
    Color hoverColor = lightColor.withOpacity(0.3);
    Color selectedColor = white;
    return Container(
      width: drawerWidth,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 80),
          Container(
            height: 70,
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            margin: EdgeInsets.only(bottom: 20),
            child: Center(
              child: Image.asset(
                'assets/images/logo_img_.png',
                height: Get.height,
                width: Get.width,
              ),
            ),
          ),
          // Scrollable Navigation Items
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDrawerItem(
                    controller,
                    'assets/images/dashboard_icon.png',
                    'assets/images/selected_dashboard_icon.png',
                    0,
                    "Dashboard",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    'assets/images/drawer_fork_icon.png',
                    'assets/images/selected_fork_icon.png',
                    1,
                    "Restaurant Management",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    'assets/images/event_icon.png',
                    'assets/images/selected_event_icon.png',
                    2,
                    "Event Management",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 18),
            // Adjusted 'custom' to 'top' assuming it was a typo
            child: CustomButton(
              laBelText: 'Logout',
              width: drawerWidth * 0.53,
              height: drawerHeight * 0.057,
              textColor: Colors.red,
              fontSize: 14,
              containerColor: Colors.white,
              isPrefixIcon: true,
              iconWidget: Icon(
                Icons.logout_outlined,
                color: Colors.red,
                size: iconSize,
              ),
              ontapp: () {
                // Show confirmation dialog
                showDialog(
                  context: Get.context!,
                  // Use Get.context to access the current context
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(
                        'Logout',
                        style: headingText.copyWith(fontSize: 18),
                      ),
                      content: Text(
                        'Are you sure you want to logout?',
                        style: simpleText.copyWith(
                          fontSize: 16,
                          color: secondaryColor,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text(
                            'Cancel',
                            style: headingText.copyWith(
                              fontSize: 14,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            Get.offAll(() => LoginScreen()); // Perform logout
                          },
                          child: Text(
                            'Logout',
                            style: headingText.copyWith(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    DrawerControllerX controller,
    String iconImage,
    String selectedIconImage,
    int number,
    String title,
    double iconSize,
    double textSize,
    Color hoverColor,
    Color selectedColor,
  ) {
    return Obx(
      () => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => controller.hoveredItem.value = "$number",
        onExit: (event) => controller.hoveredItem.value = "",
        child: GestureDetector(
          onTap: () {
            controller.changeScreen(number);
            controller.selectMainScreen(number);
          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: controller.selectedScreen.value == number
                  ? selectedColor.withOpacity(0.2)
                  : controller.hoveredItem.value == "$number"
                      ? hoverColor
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: Get.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                    color: controller.selectedScreen.value == number ||
                            controller.hoveredItem.value == "$number"
                        ? Colors.white
                        : Colors.transparent,
                  ),
                ),
                SizedBox(width: 10),
                Image.asset(
                  controller.selectedScreen.value == number
                      ? selectedIconImage
                      : iconImage,
                  height: iconSize,
                  width: iconSize,
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: simpleText.copyWith(
                    color: controller.selectedScreen.value == number
                        ? selectedColor
                        : controller.hoveredItem.value == "$number"
                            ? lightColor
                            : Colors.white,
                    fontSize: textSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
