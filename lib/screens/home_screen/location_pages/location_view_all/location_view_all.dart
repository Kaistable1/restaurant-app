import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../../../../custom_widget/separate_text_field.dart';
import '../../../../widgets/circle_container_widget.dart';
import '../../home_controller/home_location_controller.dart';
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
                Get.back();
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
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 38,
              child: CustomSeparateTextField(
                controller: controller.searchController,
                hintText: 'Try searching for restaurant locations',
                hintStyle: TextStyle(
                  color: AppColors.hintText,
                  fontFamily: "Nunito-Regular",
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
                isPrefixIcon: true,
                isShadow: true,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                      left: 4, top: 8, bottom: 8, right: 0),
                  child: Image.asset(
                    'assets/images/search_icon.png',
                    fit: BoxFit.contain,
                    height: 20,
                    width: 20,
                  ),
                ),
                isSuffixIcon: true,
                suffixIcon: Container(
                  height: 38,
                  width: 66,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: "Nunito-Bold",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16,),
            Text(
              'Explore Location',
              style: TextStyle(
                color: AppColors.bottomSheetColor,
                fontFamily: 'aftika-regular',
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 165,
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: controller.circleItems.length,
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
                    descriptionText: item.descriptionText,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

