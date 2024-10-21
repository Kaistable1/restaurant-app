import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/fav_rectangle_widget.dart';
import 'location_controller/location_controller.dart';

class LocationScreen extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());
  LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return LayoutBuilder(
      builder: (context, constraints) {
        int itemsPerRow = Responsive.isMobile(context)
            ? 2
            : Responsive.isTablet(context)
                ? 3
                : 4;
        double itemWidth = (constraints.maxWidth / itemsPerRow) - 16;
        double itemHeight = Responsive.isMobile(context)
            ? 320
            : (isLargeScreen ? 500 : 500); // Set a fixed height for items

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: Responsive.isMobile(context) ? 22 : 46.0),
              child: Text(
                'New york ',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontFamily: 'aftika-regular',
                  fontSize: Responsive.isMobile(context) ? 22 : 40,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 8 : 18),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMobile(context) ? 22 : 46.0),
              child: Text(
                'The area is lively with restaurants, bars and nightlife.',
                style: TextStyle(
                  color: Color(0xFF1E0E0E),
                  fontFamily: 'Nunito-Regular',
                  fontSize: Responsive.isMobile(context) ? 8 : 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 10 : 18),

            Padding(
              padding: EdgeInsets.only(
                  left: Responsive.isMobile(context) ? 22 : 46.0),
              child: Container(
                height: Responsive.isMobile(context) ? 25 : 55,
                 //width: Get.width * 0.1,
                decoration: BoxDecoration(
                    color: const Color(0xFFEEEFF2),
                    borderRadius: BorderRadius.circular(
                        Responsive.isMobile(context) ? 4 : 10)),
                child: Row(
                  children: [
                    SizedBox(
                      width:
                          Responsive.isMobile(context) ? 16 : Get.width * 0.06,
                    ),
                    Text(
                      'sort:',
                      style: TextStyle(
                          fontFamily: 'Nunito-Regular',
                          fontSize: Responsive.isMobile(context) ? 8 : 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        locationController.top.length,
                            (index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Obx(() {
                              return GestureDetector(
                                onTap: () {
                                  // Handle the tap for non-dropdown items
                                  if (locationController.top[index] != 'Discount') {
                                    locationController.selectedTop.value = locationController.top[index];
                                  }
                                },
                                child: Container(
                                  height: Responsive.isMobile(context) ? 20 : 40,
                                  width: Responsive.isMobile(context) ? 80 : 121,
                                  decoration: BoxDecoration(
                                    color: locationController.selectedTop.value != locationController.top[index]
                                        ? Colors.transparent
                                        : AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(Responsive.isMobile(context) ? 4 : 10),
                                  ),
                                  child: Center(
                                    child: locationController.top[index] == 'Discount'
                                        ? DropdownButton<String>(
                                      value: locationController.selectedTop.value == 'Discount'
                                          ? locationController.selectedDiscount.value
                                          : null,
                                      hint: Center(
                                        child: Text(
                                          'Discount',
                                          style: TextStyle(
                                            fontSize: Responsive.isMobile(context) ? 8 : 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.darkGrey,
                                            fontFamily: 'Nunito-Regular',
                                          ),
                                        ),
                                      ),
                                      items: ['10%', '20%', '30%', '40%', '50%']
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: ListTile(
                                            leading: Container(
                                              width: 18,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                color: locationController.selectedDiscount.value == value
                                                    ? AppColors.primaryColor
                                                    : AppColors.whiteColor,
                                                borderRadius: BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: AppColors.primaryColor,
                                                  width: 2,
                                                ),
                                              ),
                                              child: locationController.selectedDiscount.value == value
                                                  ? const Center(
                                                child: Icon(
                                                  Icons.check,
                                                  size: 12,
                                                  color: AppColors.whiteColor,
                                                ),
                                              )
                                                  : null,
                                            ),
                                            title: Text(
                                              value,
                                              style: TextStyle(
                                                fontSize: Responsive.isMobile(context) ? 8 : 14,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.blackColor,
                                                fontFamily: 'Nunito-Regular',
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          locationController.selectedDiscount.value = value;
                                          locationController.selectedTop.value = 'Discount';
                                        }
                                      },
                                      icon: Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'assets/images/drop_down_img.png',
                                            width: Responsive.isMobile(context) ? 8 : Responsive.isTablet(context) ? 12 : 12,
                                            height: Responsive.isMobile(context) ? 8 : Responsive.isTablet(context) ? 12 : 12,
                                          ),
                                        ),
                                      ),
                                      underline: SizedBox(),
                                      isExpanded: true,
                                    )
                                        : Text(
                                      locationController.top[index],
                                      style: TextStyle(
                                        fontWeight: locationController.selectedTop.value != locationController.top[index]
                                            ? FontWeight.w500
                                            : FontWeight.w700,
                                        fontSize: Responsive.isMobile(context) ? 8 : 14,
                                        color: locationController.selectedTop.value != locationController.top[index]
                                            ? AppColors.darkGrey
                                            : AppColors.primaryColor,
                                        fontFamily: 'Nunito-Regular',
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    )







                  ],
                ),
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 2 : 22),
            Obx(() {
              return Padding(
                padding: EdgeInsets.only(
                  left: Responsive.isMobile(context)
                      ? 18
                      : (isLargeScreen ? 48 : 30.0),
                  right: Responsive.isMobile(context)
                      ? 18
                      : (isLargeScreen ? 48 : 30.0),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: Responsive.isMobile(context)
                        ? 263
                        : (isLargeScreen ? 430 : 350),
                    crossAxisCount: Responsive.isMobile(context)
                        ? 2
                        : (Responsive.isTablet(context) ? 3 : 4),
                    crossAxisSpacing: Responsive.isMobile(context)
                        ? 10
                        : (Responsive.isTablet(context) ? 8 : 10),
                    mainAxisSpacing: Responsive.isMobile(context)
                        ? 0
                        : (Responsive.isTablet(context) ? 2 : 20),
                    childAspectRatio: itemWidth / itemHeight,
                  ),
                  itemCount: locationController.locationItem.length,
                  itemBuilder: (context, index) {
                    final item = locationController.locationItem[index];
                    return CustomRectangleWidget(
                      title: item.title,
                      description: item.description,
                      imagePath: item.imagePath,
                      timetext: item.timetext,
                      percentText: item.percentText,
                      isFavorite: false.obs,
                    );
                  },
                ),
              );
            })
          ],
        );
      },
    );
  }
}
