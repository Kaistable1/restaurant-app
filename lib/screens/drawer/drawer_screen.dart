import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    Color hoverColor = lightColor;
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
          SizedBox(height: 70),
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
                    Icons.dashboard,
                    0,
                    "Dashboard",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    Icons.shopping_cart,
                    1,
                    "Restaurant Management",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),

                  _buildDrawerItem(
                    controller,
                    Icons.shopping_cart,
                    3,
                    "Event Management",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    Icons.list_alt,
                    4,
                    "Restaurant Claims",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    Icons.delivery_dining,
                    5,
                    "Banner",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    Icons.card_giftcard,
                    6,
                    "Sub Admin",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    Icons.local_offer,
                    7,
                    "Privacy Policy",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    Icons.bar_chart,
                    8,
                    "About App",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    Icons.payment,
                    9,
                    "Terms and Conditions",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    Icons.account_circle,
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
              width: drawerWidth * 0.6,
              height: drawerHeight * 0.059,
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
    IconData icon,
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
            // padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                // Left white strip for hover & selection
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
                const SizedBox(width: 10),

                // Icon
                Icon(
                  icon,
                  color:
                      controller.selectedScreen.value == number
                          ? selectedColor
                          : controller.hoveredItem.value == "$number"
                          ? lightColor
                          : Colors.white,
                  size: iconSize,
                ),
                const SizedBox(width: 12),

                // Title Text
                Text(
                  title,
                  style: TextStyle(
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
