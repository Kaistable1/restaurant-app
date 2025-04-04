import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../dashboard/dashboard_screen.dart';
import '../../controllers/drawer_controller.dart';
import '../drawer/drawer_screen.dart';

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DrawerControllerX controller = Get.put(DrawerControllerX());

    return Scaffold(
      backgroundColor: white,
      appBar: MediaQuery.of(context).size.width < 800
          ? AppBar(
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            )
          : null,
      drawer: MediaQuery.of(context).size.width < 800 ? CustomDrawer() : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width >= 800) CustomDrawer(),
          Expanded(
            child: Obx(() => _getScreen(controller)),
          ),
        ],
      ),
    );
  }

  Widget _getScreen(DrawerControllerX controller) {
    Widget screen;

    if (controller.addEditIngredient.value) {
      screen = SizedBox();
    } else if (controller.driverSetTarget.value) {
      screen = SizedBox( );
    } else {
      if (controller.selectedScreen.value == 0) {
        screen = DashboardScreen();
      } else if (controller.selectedScreen.value == 1) {
        screen = SizedBox();
      } else if (controller.selectedScreen.value == 2) {
        screen = SizedBox();
      } else if (controller.selectedScreen.value == 3) {
        screen = SizedBox();
      } else if (controller.selectedScreen.value == 4) {
        screen = SizedBox();
      } else if (controller.selectedScreen.value == 5) {
        screen = SizedBox();
      }else if (controller.selectedScreen.value == 6) {
        screen = SizedBox();
      }  else if (controller.selectedScreen.value == 7) {
        screen = SizedBox();
      } else if (controller.selectedScreen.value == 8) {
        screen = SizedBox();
      } else if (controller.selectedScreen.value == 9) {
        screen = SizedBox();
      }  else {
        screen = DashboardScreen();
      }
    }
    return screen;
  }
}
