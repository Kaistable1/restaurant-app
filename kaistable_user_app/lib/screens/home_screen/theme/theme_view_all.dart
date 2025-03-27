import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../constants/app_colors.dart';
import '../../../../widgets/circle_container_widget.dart';
import '../home_controller/home_theme_controller.dart';
import '../location_pages/location_screen.dart';
import '../my_home_screen.dart';

class ThemeViewAll extends StatelessWidget {
  final HomeThemeController themeController = Get.put(HomeThemeController());
  ThemeViewAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        title: const Text(
          'Theme',
          style: TextStyle(
            fontSize: 17,
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito-Bold',
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                Get.back(); // Navigate back to the home screen
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.primaryColor,
                size: 18,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 165,
            crossAxisCount: 3, // 3 items per row
            crossAxisSpacing: 10.0, // Space between columns
            mainAxisSpacing: 10.0, // Space between rows
            // childAspectRatio: 18.0, // Ratio to control the size of the items
          ),
          itemCount: themeController
              .circleItems.length, // Number of items (3 rows * 3 columns = 9)
          itemBuilder: (context, index) {
            final item = themeController.circleItems[index];
            return CircleContainerWidget(
              ontap: () {
                Get.to(LocationScreen());
              },
              isFavourite: false.obs,
              isLocation: true,
              imgPath: item.imgPath,
              titleText: item.titleText,
              descriptionText:
                  item.descriptionText, // Example dynamic description
            );
          },
        ),
      ),
    );
  }
}
