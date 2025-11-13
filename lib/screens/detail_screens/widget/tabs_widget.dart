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
          height: 40,
          width: Get.width,
          decoration: BoxDecoration(
            color: const Color(0xFFEEEFF2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              controller.top.length,
              (index) {
                return Obx(() {
                  return InkWell(
                    onTap: () {
                      controller.selectedTop.value = controller.top[index];
                    },
                    child: IntrinsicWidth(
                      child: Container(
                        height: 26,
                        decoration: BoxDecoration(
                          color: controller.selectedTop.value !=
                                  controller.top[index]
                              ? Colors.transparent
                              : AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(
                            controller.top[index],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: controller.selectedTop.value !=
                                      controller.top[index]
                                  ? AppColors.darkGrey
                                  : AppColors.primaryColor,
                              fontFamily: 'Nunito-Regular',
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
