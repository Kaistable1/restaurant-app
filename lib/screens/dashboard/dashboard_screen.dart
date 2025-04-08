import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/drawer_controller.dart';
import '../../widgets/customheader_widget.dart';
import 'dashboard_widget.dart';

final controller1 = ScrollController();

class DashboardScreen extends StatelessWidget {
  final controller = Get.put(DashboardController());
  final drawerController = Get.put(DrawerControllerX());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;
    double paddingValue = mobileView ? 16 : 24;
    double iconSize = screenWidth < 600 ? 18 : 30;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomHeaderWidget(
                      title: 'Dashboard',
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        drawerController.showCreateNotifications.value =true;
                        //drawerController.showNotifications.value=true;
                      },
                      child: Image.asset(
                        'assets/images/notifications_icon.png',
                        height: iconSize,
                        width: iconSize,
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: (){
                        drawerController.showProfile.value =true;
                      },
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                        child: Image.asset(
                          'assets/images/profile_image.png',
                          height: iconSize,
                          width: iconSize,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('Guy Hawkins', style: simpleText),
                  ],
                ),
              ],
            ),
            SizedBox(height: 80),
            Row(
              children: [
                DashboardCard(
                  imagePath: 'assets/images/dash_con_1_icons.png',
                  title: "Total Events",
                  count: '125',
                ),
                SizedBox(width: 24),
                DashboardCard(
                  imagePath: 'assets/images/dash_con_2_icons.png',
                  title: "Total Restaurants",
                  count: '129',
                ),
              ],
            ),
            SizedBox(height: 60),
            Row(
              children: [
                DashboardCard(
                  imagePath: 'assets/images/dash_con_3_icons.png',
                  title: "Registered Restaurants",
                  count: ' 25',
                ),
                SizedBox(width: 24),
                DashboardCard(
                  imagePath: 'assets/images/dash_con_4_icons.png',
                  title: "Pending Restaurants",
                  count: '1250',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
