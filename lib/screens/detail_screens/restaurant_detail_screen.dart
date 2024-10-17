import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kaistable_website/screens/detail_screens/controller/restaurant_detail_controller.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/fav_rectangle_widget.dart';
import '../home_screen/location_pages/location_controller/location_controller.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  final controller = Get.put(RestaurantDetailController());
  RestaurantDetailScreen({super.key, this.onNavigate});

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/ihop-restaurant-logo 1.png',
                        height: 40,
                        width: 40,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Ihop restaurant @ Tseug Kwan O',
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontFamily: 'Nunito-Regular',
                          fontSize: Responsive.isMobile(context) ? 20 : 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        '(4.0)',
                        style: TextStyle(
                          color: Color(0xFF4F5761),
                          fontSize: 16,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 14,
                        child: RatingBar(
                          itemSize: 14,
                          ignoreGestures: true,
                          initialRating: 4,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                            full: Image.asset(
                              'assets/images/star yellow.png',
                              height: 14,
                            ),
                            half: Image.asset(
                              'assets/images/star yellow.png',
                              height: 14,
                            ),
                            empty: Image.asset(
                              'assets/images/star_empty.png',
                              height: 14,
                            ),
                          ),
                          itemPadding: const EdgeInsets.only(left: 2.0),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '234 reviews',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 16,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Line10(),
                      const Text(
                        'Chinese',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 16,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Line10(),
                      const Icon(
                        Icons.favorite,
                        color: AppColors.darkGrey,
                      ),
                      const Text(
                        'add to favourite',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 16,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 10 : 18),

            Padding(
              padding: EdgeInsets.only(
                left: Responsive.isMobile(context) ? 22 : 46.0,
                right: Responsive.isMobile(context) ? 22 : 46.0,
              ),
              child: Container(
                height: Responsive.isMobile(context) ? 25 : 55,
                width: Get.width * 0.6,
                decoration: BoxDecoration(
                    color: const Color(0xFFEEEFF2),
                    borderRadius: BorderRadius.circular(
                        Responsive.isMobile(context) ? 4 : 10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    controller.top.length,
                    (index) {
                      return Padding(
                          padding: const EdgeInsets.only(
                              left: 16,right: 16

                              ),
                          child: Obx(
                            () {
                              return GestureDetector(
                                onTap: () {
                                  controller.selectedTop.value =
                                      controller.top[index];
                                },
                                child: Container(
                                  height: Responsive.isMobile(context)
                                      ? 20
                                      : 40,
                                  width: Responsive.isMobile(context)
                                      ? 80
                                      : 121,
                                  decoration: BoxDecoration(
                                    color: controller.selectedTop.value !=
                                            controller.top[index]
                                        ? Colors.transparent
                                        : AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(
                                        Responsive.isMobile(context)
                                            ? 4
                                            : 10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      controller.top[index],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              Responsive.isMobile(context)
                                                  ? 12
                                                  : 20,
                                          color: controller
                                                      .selectedTop.value !=
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
            ),

            SizedBox(height: Responsive.isMobile(context) ? 2 : 22),
          ],
        );
      },
    );
  }
}

class Line10 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Container(
        width: 1.5,
        height: 18,
        decoration: const BoxDecoration(color: AppColors.darkGrey),
      ),
    );
  }
}
