import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/responsive.dart';

class BottomContainer extends StatelessWidget {
  final Function(int)? onNavigate;
  final ScrollController scrollcontroller;
  const BottomContainer({
    super.key,
    this.onNavigate,
    required this.scrollcontroller,
  });
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return Container(
      color: AppColors.bottomSheetColor,
      height: Responsive.isMobile(context) ? 210 : 390,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(Responsive.isMobile(context) ? 4 : 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reference',
                      style: TextStyle(
                        fontSize: Responsive.isMobile(context)
                            ? 8
                            : Responsive.isTablet(context)
                            ? 14
                            : isLargeScreen
                            ? 20
                            : 18,
                        fontFamily: 'Nunito-Regular',
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context)
                          ? 10
                          : Responsive.isTablet(context)
                          ? 20
                          : 30,
                    ),
                    InkWell(
                      onTap: () {
                        if (onNavigate != null) {
                          onNavigate!(1);
                          scrollcontroller.jumpTo(
                            0,
                          ); // Call the callback to navigate to the 7th screen
                          // scrollcontroller.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                        }
                      },
                      child: Text(
                        'Favorites',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 6
                              : Responsive.isTablet(context)
                              ? 12
                              : isLargeScreen
                              ? 18
                              : 16,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context)
                          ? 10
                          : Responsive.isTablet(context)
                          ? 20
                          : 30,
                    ),
                    InkWell(
                      onTap: () {
                        if (onNavigate != null) {
                          onNavigate!(4);
                          scrollcontroller.jumpTo(0);
                          // scrollcontroller.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);// Call the callback to navigate to the 7th screen
                        }
                      },
                      child: Text(
                        'About app',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 6
                              : Responsive.isTablet(context)
                              ? 12
                              : isLargeScreen
                              ? 18
                              : 16,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context)
                          ? 10
                          : Responsive.isTablet(context)
                          ? 20
                          : 30,
                    ),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: Responsive.isMobile(context)
                            ? 6
                            : Responsive.isTablet(context)
                            ? 12
                            : isLargeScreen
                            ? 18
                            : 16,
                        fontFamily: 'Nunito-Regular',
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context)
                          ? 10
                          : Responsive.isTablet(context)
                          ? 20
                          : 30,
                    ),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: Responsive.isMobile(context)
                            ? 6
                            : Responsive.isTablet(context)
                            ? 12
                            : isLargeScreen
                            ? 18
                            : 16,
                        fontFamily: 'Nunito-Regular',
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: Responsive.isMobile(context)
                      ? 10
                      : Responsive.isTablet(context)
                      ? 20
                      : isLargeScreen
                      ? 90
                      : 60,
                ),
                InkWell(
                  onTap: () {
                    if (onNavigate != null) {
                      onNavigate!(0);
                      scrollcontroller.jumpTo(0);
                      // scrollcontroller.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);// Call the callback to navigate to the 7th screen
                    }
                  },
                  child: Image(
                    image: const AssetImage(
                      'assets/images/botomsheet_logo.png',
                    ),
                    height: Responsive.isMobile(context)
                        ? 40
                        : Responsive.isTablet(context)
                        ? 90
                        : 156,
                    width: Responsive.isMobile(context)
                        ? 200
                        : Responsive.isTablet(context)
                        ? 320
                        : 482,
                  ),
                ),
                SizedBox(
                  width: Responsive.isMobile(context)
                      ? 8
                      : isLargeScreen
                      ? 90
                      : 60,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support',
                      style: TextStyle(
                        fontSize: Responsive.isMobile(context)
                            ? 8
                            : Responsive.isTablet(context)
                            ? 14
                            : isLargeScreen
                            ? 20
                            : 18,
                        fontFamily: 'Nunito-Regular',
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context)
                          ? 10
                          : Responsive.isTablet(context)
                          ? 20
                          : 30,
                    ),
                    InkWell(
                      onTap: () {
                        if (onNavigate != null) {
                          onNavigate!(5);
                          scrollcontroller.jumpTo(0);
                          // scrollcontroller.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);// Call the callback to navigate to the 7th screen
                        }
                      },
                      child: Text(
                        "Contact us",
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 6
                              : Responsive.isTablet(context)
                              ? 12
                              : isLargeScreen
                              ? 18
                              : 16,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context)
                          ? 10
                          : Responsive.isTablet(context)
                          ? 20
                          : 30,
                    ),
                    InkWell(
                      onTap: () {
                        if (onNavigate != null) {
                          onNavigate!(2);
                          scrollcontroller.jumpTo(0);
                          // scrollcontroller.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);// Call the callback to navigate to the 7th screen
                        }
                      },
                      child: Text(
                        'Terms and conditions',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 6
                              : Responsive.isTablet(context)
                              ? 12
                              : isLargeScreen
                              ? 18
                              : 16,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context)
                          ? 10
                          : Responsive.isTablet(context)
                          ? 20
                          : 30,
                    ),
                    InkWell(
                      onTap: () {
                        if (onNavigate != null) {
                          onNavigate!(3);
                          scrollcontroller.jumpTo(0);
                          //scrollcontroller.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);// Call the callback to navigate to the 7th screen
                        }
                      },
                      child: Text(
                        'Privacy policy',
                        style: TextStyle(
                          fontSize: Responsive.isMobile(context)
                              ? 6
                              : Responsive.isTablet(context)
                              ? 12
                              : isLargeScreen
                              ? 18
                              : 16,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context)
                          ? 10
                          : Responsive.isTablet(context)
                          ? 20
                          : 30,
                    ),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: Responsive.isMobile(context)
                            ? 6
                            : Responsive.isTablet(context)
                            ? 12
                            : isLargeScreen
                            ? 18
                            : 16,
                        fontFamily: 'Nunito-Regular',
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: Responsive.isMobile(context)
                ? 30
                : Responsive.isTablet(context)
                ? 20
                : 30,
          ),
          Image(
            image: const AssetImage('assets/images/divider_line.png'),
            height: 1,
            width: Get.width,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: Responsive.isMobile(context) ? 20 : 90,
              right: Responsive.isMobile(context) ? 30 : 60,
              top: Responsive.isMobile(context) ? 12 : 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '© 2024  business name Inc. All rights reserved.',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Responsive.isMobile(context)
                        ? 6
                        : Responsive.isTablet(context)
                        ? 8
                        : 12,
                    color: AppColors.whiteColor,
                    fontFamily: 'Nunito-Regular',
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    if (!await launchUrl(
                      Uri.parse('https://www.instagram.com'),
                    )) {
                      throw Exception('Could not launch ');
                    }
                  },
                  child: Image(
                    image: const AssetImage('assets/images/insta_light.png'),
                    height: Responsive.isMobile(context)
                        ? 16
                        : Responsive.isTablet(context)
                        ? 22
                        : 40,
                    width: Responsive.isMobile(context)
                        ? 16
                        : Responsive.isTablet(context)
                        ? 22
                        : 40,
                  ),
                ),
                SizedBox(width: Responsive.isMobile(context) ? 6 : 10),
                InkWell(
                  onTap: () async {
                    if (!await launchUrl(
                      Uri.parse('https://www.linkedin.com'),
                    )) {
                      throw Exception('Could not launch ');
                    }
                  },
                  child: Image(
                    image: const AssetImage('assets/images/linkedin_light.png'),
                    height: Responsive.isMobile(context)
                        ? 16
                        : Responsive.isTablet(context)
                        ? 22
                        : 40,
                    width: Responsive.isMobile(context)
                        ? 16
                        : Responsive.isTablet(context)
                        ? 22
                        : 40,
                  ),
                ),
                SizedBox(width: Responsive.isMobile(context) ? 6 : 10),
                InkWell(
                  onTap: () async {
                    if (!await launchUrl(
                      Uri.parse('https://www.facebook.com'),
                    )) {
                      throw Exception('Could not launch ');
                    }
                  },
                  child: Image(
                    image: const AssetImage('assets/images/facebook_light.png'),
                    height: Responsive.isMobile(context)
                        ? 16
                        : Responsive.isTablet(context)
                        ? 22
                        : 40,
                    width: Responsive.isMobile(context)
                        ? 16
                        : Responsive.isTablet(context)
                        ? 22
                        : 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
