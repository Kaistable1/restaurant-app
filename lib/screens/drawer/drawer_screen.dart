import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_web_app/constants/text_styles.dart';
import 'package:restaurant_web_app/screens/auth_screens/login_screen/login_screen.dart';
import 'package:restaurant_web_app/widgets/button1.dart';
import '../../constants/app_colors.dart';
import '../../widgets/button.dart';
import '../../controllers/drawer_controller.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DrawerControllerX controller = Get.find();
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
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 80),
          Container(
            height: 70,
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            margin: const EdgeInsets.only(bottom: 20),
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
                    'assets/images/drawer_fork_icon.png',
                    'assets/images/selected_fork_icon.png',
                    0,
                    "Restaurant Management",
                    iconSize,
                    textSize,
                    hoverColor,
                    selectedColor,
                  ),
                  _buildDrawerItem(
                    controller,
                    'assets/images/privacy_icon.png',
                    'assets/images/selected_privacy_icon.png',
                    1,
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
                    2,
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
                    3,
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
                    4,
                    "Change Password",
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
            padding: const EdgeInsets.only(top: 20.0, bottom: 18),
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
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context).pop(); // Close the dialog
                            Get.offAll(
                                () => const LoginScreen()); // Perform logout
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
            controller.selectedType.value = '';
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
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                    color: controller.selectedScreen.value == number ||
                            controller.hoveredItem.value == "$number"
                        ? Colors.white
                        : Colors.transparent,
                  ),
                ),
                const SizedBox(width: 10),
                Image.asset(
                  controller.selectedScreen.value == number
                      ? selectedIconImage
                      : iconImage,
                  height: iconSize,
                  width: iconSize,
                ),
                const SizedBox(width: 12),
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
