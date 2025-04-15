import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/text_styles.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/drawer_controller.dart';
import '../../widgets/customheader_widget.dart';
import '../dashboard/dashboard_widget.dart';

final controller1 = ScrollController();

class SubAdminDashboardScreen extends StatelessWidget {
  final controller = Get.put(DashboardController());
  final drawerController = Get.put(DrawerControllerX());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mobileView = screenWidth < 900;
    double paddingValue = mobileView ? 16 : 24;
    double cardWidth;
    if (screenWidth < 600) {
      cardWidth = 425;
    } else if (screenWidth < 1024) {
      cardWidth = 525;
    } else if (screenWidth < 1440) {
      cardWidth = 585;
    } else {
      cardWidth = 665;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeaderWidget(
              title: 'Dashboard',
              end: true,
              endWidget:
                  GetBuilder<DrawerControllerX>(builder: (drwaerController) {
                return Text(drawerController.subAdminsModel?.name ?? '',
                    style: simpleText);
              }),
            ),
            SizedBox(height: 80),
            Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      DashboardCard(
                        imagePath: 'assets/images/dash_con_1_icons.png',
                        title: "Total Events",
                        count: controller.totalEvents.toString(),
                        onTap: () {
                          drawerController.selectedScreen.value = 2;
                        },
                      ),
                      SizedBox(width: 24),
                      DashboardCard(
                        imagePath: 'assets/images/dash_con_2_icons.png',
                        title: "Total Restaurants",
                        count: controller.totalRestaurants.toString(),
                        onTap: () {
                          drawerController.selectedScreen.value = 1;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  DashboardCard(
                    imagePath: 'assets/images/completed_restaurants_icon..png',
                    title: "Completed Restaurants",
                    count: controller.registeredCount.toString(),
                    width: cardWidth,
                    onTap: () {
                      // drawerController.selectedScreen.value = 2;
                    },
                  ),
                ],
              );
            }),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
