import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/text_styles.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/drawer_controller.dart';

final controller1 = ScrollController();

class DashboardScreen extends StatelessWidget {
  final controller = Get.put(DashboardController());
  final drawerController = Get.put(DrawerControllerX());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerWidth =
        screenWidth < 600 ? screenWidth * 0.9 : screenWidth * 0.22;
    double containerHeight = screenHeight * 0.15;
    double iconSize = screenWidth < 600 ? 18 : 30;
    double textSize = screenWidth < 600 ? 14 : 16;

    double graphWidth = screenWidth * 0.9;
    double graphHeight = screenHeight * 0.3;


    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}

