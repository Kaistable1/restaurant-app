import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savrly/constants/text_styles.dart';

import '../../auth/login/login_screen.dart';
import '../../constants/app_colors.dart';
import '../../widgets/button.dart';
import '../../controllers/drawer_controller.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DrawerControllerX controller = Get.find();
    double drawerHeight = MediaQuery.of(context).size.height;
    double drawerWidth =
        MediaQuery.of(context).size.width < 600
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
                    'assets/images/sub_admin_icon.png',
                    'assets/images/selected_sub_admin_icon.png',
                    1,
                    "User Management",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    'assets/images/drawer_fork_icon.png',
                    'assets/images/selected_fork_icon.png',
                    2,
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
                    3,
                    "Event Management",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    'assets/images/claims_icon.png',
                    'assets/images/selected_claims_icon.png',
                    4,
                    "Restaurant Claims",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    'assets/images/banner_icon.png',
                    'assets/images/selected_banner_icon.png',
                    5,
                    "Banner",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    'assets/images/sub_admin_icon.png',
                    'assets/images/selected_sub_admin_icon.png',
                    6,
                    "Sub Admin",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    'assets/images/privacy_icon.png',
                    'assets/images/selected_privacy_icon.png',
                    7,
                    "Privacy Policy",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    'assets/images/info_icon.png',
                    'assets/images/selected_about_icon.png',
                    8,
                    "About App",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    'assets/images/terms-and-conditions _icon.png',
                    'assets/images/selected_terms_icon.png',
                    9,
                    "Terms and Conditions",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    'assets/images/contact_us.png',
                    'assets/images/selected_contact_icon.png',
                    10,
                    "Contact Us",
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
            padding: EdgeInsets.only(bottom: 20.0),
            child: CustomButton(
              laBelText: 'Logout',
              width: drawerWidth * 0.53,
              height: drawerHeight * 0.057,
              textColor: Colors.red,
              fontSize: 14,
              containerColor: white,
              isPrefixIcon: true,
              iconWidget: Icon(
                Icons.logout_outlined,
                color: Colors.red,
                size: iconSize,
              ),
              ontapp: () {
                Get.offAll(() => LoginScreen());
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
              color:
                  controller.selectedScreen.value == number
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
                    color:
                        controller.selectedScreen.value == number ||
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
                    color:
                        controller.selectedScreen.value == number
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
