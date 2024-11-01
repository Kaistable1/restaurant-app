import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/utils/responsive.dart';

import '../controller/restaurant_detail_controller.dart';

class Tabs extends StatelessWidget {
  const Tabs({
    super.key,
    required this.controller,
  });

  final RestaurantDetailController controller;

  @override
  Widget build(BuildContext context) {
    return OverflowBar(
      overflowAlignment: OverflowBarAlignment.center,
      children: [
        Container(
          height: Responsive.isMobile(context) ? 35 :Responsive.isTablet(context) ?40 :55,
          width: Get.width * 0.9,
          decoration: BoxDecoration(
              color: const Color(0xFFEEEFF2),
              borderRadius: BorderRadius.circular(
                  Responsive.isMobile(context) ? 4 :Responsive.isTablet(context) ?6: 10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.top.length,
                  (index) {
                return Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16),
                    child: Obx(
                          () {
                        return InkWell(
                          onTap: () {
                            controller.selectedTop.value =
                            controller.top[index];
                          },
                          child: Container(
                            height: Responsive.isMobile(context)
                                ? 25
                                :Responsive.isTablet(context) ?30

                                : 40,
                            width: Responsive.isMobile(context)
                                ? 60
                                :Responsive.isTablet(context) ?80

                                : 121,
                            decoration: BoxDecoration(
                              color:
                              controller.selectedTop.value !=
                                  controller.top[index]
                                  ? Colors.transparent
                                  : AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(
                                  Responsive.isMobile(context)
                                      ? 4
                                      :Responsive.isTablet(context) ?6
                                      : 10),
                            ),
                            child: Center(
                              child: Text(
                                controller.top[index],
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Responsive.isMobile(
                                        context)
                                        ? 13
                                        :Responsive.isTablet(context) ?14
                                        : 20,
                                    color: controller.selectedTop
                                        .value !=
                                        controller.top[index]
                                        ? AppColors.darkGrey
                                        : AppColors.primaryColor,
                                    fontFamily: 'Nunito-Regular'),
                              ),
                            ),
                          ),
                        );
                      },
                    ));
              },
            ),
          ),
        ),
         Column(
           children: [
             SizedBox(height: 14,),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Icon(
                  Icons.access_time_filled,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'choose time & discount',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF4F5761),
                    fontSize: Responsive.isMobile(context) ? 11 :Responsive.isTablet(context) ?10:14,
                    fontFamily: 'Nunito-Regular',
                    fontWeight: FontWeight.w400,
                    height: 0.16,
                  ),
                ),
              ],
                     ),
           ],
         )
      ],
    );
  }
}