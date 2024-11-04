import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import '../../utils/responsive.dart';
import '../screens/detail_screens/restaurant_detail_screen.dart';

class CustomRectangleWidget extends StatelessWidget {
 // final ScrollController scrollcontroller;
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
        this.onNavigate,
        //required this.scrollcontroller
      });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    bool isTablet = Responsive.isTablet(context);

    return

         GestureDetector(
          onTap: () {
            Get.to(RestaurantDetailScreen());
          },
          child: Stack(
            children: [
              Container(
                height: 180,


                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25,),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 22,
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
                            ? 18
                            : isLargeScreen
                            ? 50
                            : isTablet
                            ? 28
                            : 45),
                        bottomRight:
                        Radius.circular(Responsive.isMobile(context)
                            ? 18
                            : isLargeScreen
                            ? 50
                            : isTablet
                            ? 28
                            : 45),
                        bottomLeft:
                        Radius.circular(Responsive.isMobile(context)
                            ? 18
                            : isLargeScreen
                            ? 50
                            : isTablet
                            ? 28
                            : 45),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        // top: Responsive.isMobile(context)
                        //     ? 20
                        //     : isLargeScreen
                        //         ? 80
                        //         : isTablet
                        //             ? 65
                        //             : 72,
                          left: Responsive.isMobile(context)
                              ? 10
                              : isLargeScreen
                              ? 28
                              : isTablet
                              ? 22
                              : 22.0
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 0, right: 2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: List.generate(
                                          2,
                                              (index) => _buildStarBox(
                                              isLargeScreen,
                                              isTablet,
                                              context)),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: List.generate(
                                          2,
                                              (index) => _buildStarBox(
                                              isLargeScreen,
                                              isTablet,
                                              context)),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: Responsive.isMobile(context)
                                  ? 2
                                  : isLargeScreen
                                  ? 0
                                  : isTablet
                                  ? 6
                                  : 10),
                          Obx(() {
                            return InkWell(
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
                                    ? 16
                                    : isLargeScreen
                                    ? 32
                                    : isTablet
                                    ? 24
                                    : 21,
                                width: Responsive.isMobile(context)
                                    ? 16
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
                                  ? 5
                                  : isLargeScreen
                                  ? 0
                                  : isTablet
                                  ? 8
                                  : 10),
                          Text(
                            title, // 'Buffet',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: Responsive.isMobile(context)
                                  ? 14
                                  : isLargeScreen
                                  ? 22
                                  : isTablet
                                  ? 12
                                  : 14,
                              fontFamily: 'Nunito-Regular',
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(
                              height: Responsive.isMobile(context)
                                  ? 4
                                  : isLargeScreen
                                  ? 0
                                  : isTablet
                                  ? 3
                                  : 6),
                          Text(
                            description, // 'Duis aute irure dolor in reprehend voluptate velit esse cillum',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: Responsive.isMobile(context)
                                  ? 8
                                  : isLargeScreen
                                  ? 16
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
              Align(
                alignment: Alignment.topLeft,
                child: Container(

                  height: Responsive.isMobile(context)
                      ? 95
                      : isLargeScreen
                      ? 190
                      : isTablet
                      ? 130
                      : 170,
                  width: Responsive.isMobile(context)
                      ?95
                      : isLargeScreen
                      ? 190
                      : isTablet
                      ? 130
                      : 170,
                  decoration: BoxDecoration(
                    //color: Colors.t,
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black.withOpacity(0.1),
                    //     spreadRadius: 2,
                    //     blurRadius: 222,
                    //     offset: const Offset(0, 1),
                    //   ),
                    // ],
                    image: DecorationImage(
                      //fit: BoxFit.cover,

                      image: AssetImage(imagePath),
                    ),
                  ),
                ),
              ),

            ],
          ),


    );
  }

  Widget _buildStarBox(
      bool isLargeScreen, bool isTablet, BuildContext context) {
    return Container(
      height: Responsive.isMobile(context)
          ? 32
          : isLargeScreen
          ? 75
          : isTablet
          ? 40
          : 50,
      width: Responsive.isMobile(context)
          ? 36
          : isLargeScreen
          ? 75
          : isTablet
          ? 40
          : 50,
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
                    ? 14
                    : isTablet
                    ? 8
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