import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import '../../utils/responsive.dart';

class CustomRectangleWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final String timetext;
  final String percentText;
  final RxBool isFavorite;
  final Function(int)? onNavigate;
  CustomRectangleWidget(
      {super.key,
      required this.title,
      required this.isFavorite,
      required this.imagePath,
      required this.description,
      required this.timetext,
      required this.percentText,
      this.onNavigate});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    bool isTablet = Responsive.isTablet(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        double widgetWidth = constraints.maxWidth * 0.3;

        return GestureDetector(
          onTap: () {
            if (onNavigate != null) {
              onNavigate!(8); // Call the callback to navigate to the 7th screen
            }
          },
          child: Stack(
            children: [
              Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      height: Responsive.isMobile(context)
                          ? 320
                          : isLargeScreen
                              ? 220
                              : isTablet
                                  ? 290
                                  : 240,
                      width: Responsive.isMobile(context)
                          ? 230
                          : isLargeScreen
                              ? 350
                              : isTablet
                                  ? 380
                                  : 300,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 12,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Responsive.isMobile(context)
                              ? 8
                              : isLargeScreen
                                  ? 20
                                  : isTablet
                                      ? 16
                                      : 16),
                          topRight: Radius.circular(Responsive.isMobile(context)
                              ? 12
                              : isLargeScreen
                                  ? 50
                                  : isTablet
                                      ? 28
                                      : 45),
                          bottomRight:
                              Radius.circular(Responsive.isMobile(context)
                                  ? 12
                                  : isLargeScreen
                                      ? 50
                                      : isTablet
                                          ? 28
                                          : 45),
                          bottomLeft:
                              Radius.circular(Responsive.isMobile(context)
                                  ? 12
                                  : isLargeScreen
                                      ? 50
                                      : isTablet
                                          ? 28
                                          : 45),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: Responsive.isMobile(context)
                                ? 20
                                : isLargeScreen
                                    ? 80
                                    : isTablet
                                        ? 65
                                        : 72,
                            left: Responsive.isMobile(context)
                                ? 10
                                : isLargeScreen
                                    ? 28
                                    : isTablet
                                        ? 22
                                        : 22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: Responsive.isMobile(context)
                                    ? 8
                                    : isLargeScreen
                                        ? 12
                                        : isTablet
                                            ? 8
                                            : 10),
                            Obx(() {
                              return GestureDetector(
                                onTap: () {
                                  print('jksdb');
                                  isFavorite.value = !isFavorite.value;
                                },
                                child: Image.asset(
                                  'assets/images/heart_icon.png',
                                  color: isFavorite.value
                                      ? Colors.red
                                      : AppColors.textColor,
                                  height: Responsive.isMobile(context)
                                      ? 12
                                      : isLargeScreen
                                          ? 32
                                          : isTablet
                                              ? 24
                                              : 21,
                                  width: Responsive.isMobile(context)
                                      ? 10
                                      : isLargeScreen
                                          ? 30
                                          : isTablet
                                              ? 24
                                              : 24,
                                ),
                              );
                            }),
                            SizedBox(
                                height: Responsive.isMobile(context)
                                    ? 8
                                    : isLargeScreen
                                        ? 15
                                        : isTablet
                                            ? 10
                                            : 10),
                            Text(
                              title, // 'Buffet',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Responsive.isMobile(context)
                                    ? 14
                                    : isLargeScreen
                                        ? 26
                                        : isTablet
                                            ? 12
                                            : 14,
                                fontFamily: 'Nunito-Regular',
                                color: AppColors.textColor,
                              ),
                            ),
                            SizedBox(
                                height: Responsive.isMobile(context)
                                    ? 8
                                    : isLargeScreen
                                        ? 12
                                        : isTablet
                                            ? 6
                                            : 6),
                            Text(
                              description, // 'Duis aute irure dolor in reprehend voluptate velit esse cillum',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: Responsive.isMobile(context)
                                    ? 8
                                    : isLargeScreen
                                        ? 18
                                        : isTablet
                                            ? 10
                                            : 16,
                                fontFamily: 'Nunito-Regular',
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: Responsive.isMobile(context) ? 55 : 0,
                child: Container(
                  height: Responsive.isMobile(context)
                      ? 85
                      : isLargeScreen
                          ? 190
                          : isTablet
                              ? 130
                              : 170,
                  width: Responsive.isMobile(context)
                      ? 85
                      : isLargeScreen
                          ? 190
                          : isTablet
                              ? 130
                              : 170,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 50,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: Responsive.isMobile(context) ? 90 : 90,
                right: Responsive.isMobile(context)
                    ? 12
                    : (isLargeScreen
                        ? 30
                        : isTablet
                            ? 1
                            : 10),
                child: Container(
                  height: Responsive.isMobile(context)
                      ? 90
                      : isLargeScreen
                          ? 210
                          : isTablet
                              ? 180
                              : 130,
                  width: Responsive.isMobile(context)
                      ? 95
                      : isLargeScreen
                          ? 210
                          : isTablet
                              ? 180
                              : 120,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Row(
                        children: List.generate(
                            2,
                            (index) => _buildStarBox(
                                isLargeScreen, isTablet, context)),
                      ),
                      Row(
                        children: List.generate(
                            2,
                            (index) => _buildStarBox(
                                isLargeScreen, isTablet, context)),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildStarBox(
      bool isLargeScreen, bool isTablet, BuildContext context) {
    return Container(
      height: Responsive.isMobile(context)
          ? 38
          : isLargeScreen
              ? 100
              : isTablet
                  ? 50
                  : 65,
      width: Responsive.isMobile(context)
          ? 38
          : isLargeScreen
              ? 100
              : isTablet
                  ? 50
                  : 60,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/star_img.png'),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              timetext,
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: Responsive.isMobile(context)
                    ? 7
                    : isLargeScreen
                        ? 16
                        : isTablet
                            ? 10
                            : 12,
                fontWeight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),
            Text(
              percentText,
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: Responsive.isMobile(context)
                    ? 5
                    : isLargeScreen
                        ? 16
                        : isTablet
                            ? 10
                            : 12,
                fontWeight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
