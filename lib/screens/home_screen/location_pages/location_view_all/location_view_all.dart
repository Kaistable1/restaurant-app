import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../constants/app_colors.dart';
import '../../../../widgets/circle_container_widget.dart';
import '../../home_controller/home_location_controller.dart';
import '../../my_home_screen.dart';
import '../location_screen.dart';

class LocationViewAll extends StatelessWidget {
  final HomeLocationController controller = Get.put(HomeLocationController());
  LocationViewAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        title: const Text(
          'Location',
          style: TextStyle(
            fontSize: 20,
            color: AppColors.botomSheetColor,
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
                Get.offAll(MyHomeScreen()); // Navigate back to the home screen
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
        padding: const EdgeInsets.only(left: 16.0,right: 16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 165,
            crossAxisCount: 3, // 3 items per row
            crossAxisSpacing: 10.0, // Space between columns
            mainAxisSpacing: 10.0, // Space between rows
           // childAspectRatio: 18.0, // Ratio to control the size of the items
          ),
          itemCount: controller.circleItems.length, // Number of items (3 rows * 3 columns = 9)
          itemBuilder: (context, index) {
            final item = controller.circleItems[index];
            return CircleContainerWidget(
              ontap: () {
                Get.to(LocationScreen());
              },
              isFavourite: false.obs,
             isLocation: true,
              imgPath: item.imgPath,
             titleText: item.titleText,
             descriptionText: item.descriptionText,// Example dynamic description
            );
          },
        ),
      ),
    );
  }
}
