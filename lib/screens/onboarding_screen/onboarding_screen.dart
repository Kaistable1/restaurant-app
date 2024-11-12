import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/home_screen/my_home_screen.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_controller/onboarding_controller.dart';
import '../../utils/responsive.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';


class OnboardingScreen extends StatelessWidget {
  final controller = Get.put(OnboardingController());
  OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width,
                height: Responsive.isMobile(context) ? 250 : 791,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image:AssetImage("assets/images/onboarding_background.png"),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/onboarding_top2.png',
                    width: 180,
                    height: 180,
                  ),
                ),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 14 : 40),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Lorem ipsum dolor sit amet",
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context)
                        ? 26
                        : Responsive.isTablet(context)
                            ? 46
                            : 60,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'aftika-regular',
                    color: AppColors.headingTextColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context)
                        ? 12
                        : Responsive.isTablet(context)
                            ? 18
                            : 24,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Lora-Regular',
                    color: AppColors.headingTextColor,
                  ),
                ),
              ),
              const SizedBox(
                  height:0),
              Container(
                color: AppColors.whiteColor,
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Responsive.isMobile(context) ? 20 : 90,
                    ),
                    Responsive.isMobile(context)||Responsive.isTablet(context)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/off image.png',
                                width: 370,
                                height: 250,
                              ),
                              const SizedBox(
                                height:30,
                              ),
                              Padding(
                                padding:  EdgeInsets.only(
                                    left:Responsive.isMobile(context)
                                        ||Responsive.isTablet(context)? 0.0:0
                                ),
                                child: ChooseLocationWidget(
                                    controller: controller
                                ),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ChooseLocationWidget(controller: controller),
                              SizedBox(
                                  width: Responsive.isMobile(context)
                                      ? 12
                                      : Responsive.isTablet(context)
                                          ? 50
                                          : isLargeScreen
                                              ? 64
                                              : 122),
      
                              Image.asset(
                                'assets/images/off image.png',
                                width:Responsive.isMobile(context)?390:464,
                                height:Responsive.isMobile(context)?300:540,
                              )
                              // Container(
                              //   width: Responsive.isMobile(context)? 170 :Responsive.isTablet(context)?250:475,
                              //   height: Responsive.isMobile(context)? 300 :Responsive.isTablet(context)?550:610,
                              //   color: AppColors.whiteColor,
                              //
                              //   child: Stack(
                              //     children: [
                              //       Padding(
                              //         padding: const EdgeInsets.only(top: 8.0),
                              //         child: Image.asset('assets/images/onboarding_container_img.png',
                              //           width: Responsive.isMobile(context)? 390 :464,
                              //
                              //           height: Responsive.isMobile(context)? 300 :540,),
                              //       ),
                              //       Positioned(
                              //           bottom: Responsive.isMobile(context)? 153 :Responsive.isTablet(context)?298:368,
                              //           left: Responsive.isMobile(context)? 90 :Responsive.isTablet(context)?110:207,
                              //           child: Image.asset('assets/images/corner_image.png',
                              //             height: Responsive.isMobile(context)? 120 :Responsive.isTablet(context)?130:240,
                              //             width:Responsive.isMobile(context)? 80 :Responsive.isTablet(context)?147: 247,)
                              //       ),
                              //       Positioned(
                              //           top: Responsive.isMobile(context)? 160 :Responsive.isTablet(context)?302:312,
                              //           right: Responsive.isMobile(context)? 91 :Responsive.isTablet(context)?110:220,
                              //
                              //           child:
                              //           Image.asset('assets/images/botm_corner_img.png',
                              //             height: Responsive.isMobile(context)? 120 :Responsive.isTablet(context)?130:240,
                              //             width:Responsive.isMobile(context)? 80 :Responsive.isTablet(context)?147: 247,)),
                              //
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 50 : 90,
                    ),
                  ],
                ),
              ),
              // Center(
              //   child: Stack(
              //     children: [
              //       Container(
              //         height: Responsive.isMobile(context)
              //             ? 400
              //             : Responsive.isTablet(context)
              //                 ? 600
              //                 : 730,
              //         child: Image.asset(
              //           'assets/images/botm_rectangle.png',
              //           height: Responsive.isMobile(context)
              //               ? 300
              //               : Responsive.isTablet(context)
              //                   ? 500
              //                   : 600,
              //           width: Responsive.isMobile(context)
              //               ? 400
              //               : Responsive.isTablet(context)
              //                   ? 1000
              //                   : 1400,
              //         ),
              //       ),
              //       Positioned(
              //           left: Responsive.isMobile(context)
              //               ? 12
              //               : Responsive.isTablet(context)
              //                   ? 60
              //                   : 120,
              //           bottom: Responsive.isMobile(context) ? 134 : 122,
              //           child: Image.asset(
              //             'assets/images/mobile_screen_img.png',
              //             height: Responsive.isMobile(context)
              //                 ? 205
              //                 : Responsive.isTablet(context)
              //                     ? 480
              //                     : 605,
              //             width: Responsive.isMobile(context)
              //                 ? 130
              //                 : Responsive.isTablet(context)
              //                     ? 190
              //                     : 303,
              //           )),
              //       Positioned(
              //           left: Responsive.isMobile(context)
              //               ? 150
              //               : Responsive.isTablet(context)
              //                   ? 280
              //                   : 500,
              //           top: Responsive.isMobile(context)
              //               ? 140
              //               : Responsive.isTablet(context)
              //                   ? 200
              //                   : 280,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 'DOWNLOAD MOBILE APP',
              //                 style: TextStyle(
              //                     fontSize: Responsive.isMobile(context)
              //                         ? 20
              //                         : Responsive.isTablet(context)
              //                             ? 26
              //                             : 40,
              //                     fontWeight: FontWeight.w300,
              //                     color: Color(0xFF213539),
              //                     fontFamily: 'Lemonado'),
              //               ),
              //               SizedBox(
              //                 height: Responsive.isMobile(context) ? 12 : 20,
              //               ),
              //               SizedBox(
              //                 height: Responsive.isMobile(context)
              //                     ? 35
              //                     : Responsive.isTablet(context)
              //                         ? 60
              //                         : 70,
              //                 width: Responsive.isMobile(context)
              //                     ? 220
              //                     : Responsive.isTablet(context)
              //                         ? 500
              //                         : 700,
              //                 child: Text(
              //                   'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
              //                   maxLines: 4,
              //                   textAlign: TextAlign.start,
              //                   style: TextStyle(
              //                     fontFamily: 'Lora-Regular',
              //                     fontWeight: FontWeight.w400,
              //                     fontSize: Responsive.isMobile(context)
              //                         ? 8
              //                         : Responsive.isTablet(context)
              //                             ? 16
              //                             : 24,
              //                     color: Color(0xFF213539),
              //                   ),
              //                 ),
              //               ),
              //               SizedBox(
              //                 height: Responsive.isMobile(context)
              //                     ? 4
              //                     : Responsive.isTablet(context)
              //                         ? 14
              //                         : 30,
              //               ),
              //               Row(
              //                 children: [
              //                   InkWell(
              //                       onTap: () async{
              //                         if (!await launchUrl(
              //                         Uri.parse('https://play.google.com/store'))) {
              //                         throw Exception('Could not launch ');
              //                         }
              //                       },
              //                       child: Image(
              //                         image: AssetImage(
              //                           'assets/images/googleplay_img.png',
              //                         ),
              //                         height:
              //                             Responsive.isMobile(context) ? 18 : 36,
              //                         width:
              //                             Responsive.isMobile(context) ? 70 : 149,
              //                       )),
              //                   SizedBox(
              //                     width: 40,
              //                   ),
              //                   InkWell(
              //                       onTap: () async {
              //                         if (!await launchUrl(
              //                             Uri.parse('https://www.apple.com/app-store'))) {
              //                           throw Exception('Could not launch ');
              //                         }
              //                       },
              //
              //                       child: Image(
              //                         image: AssetImage(
              //                           'assets/images/appstore_img.png',
              //                         ),
              //                         height:
              //                             Responsive.isMobile(context) ? 18 : 36,
              //                         width:
              //                             Responsive.isMobile(context) ? 70 : 149,
              //                       )),
              //                 ],
              //               )
              //             ],
              //           ))
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: Responsive.isMobile(context) ? 20 : 70,
              // ),
              // Container(
              //   height: Responsive.isMobile(context)
              //       ? 60
              //       : Responsive.isTablet(context)
              //           ? 90
              //           : 153,
              //   color: AppColors.botomSheetColor,
              //   child: Center(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             InkWell(
              //                 onTap: () async {
              //                   if (!await launchUrl(
              //                       Uri.parse('https://www.instagram.com'))) {
              //                     throw Exception('Could not launch ');
              //                   }
              //                 },
              //
              //
              //                 child: Image(
              //                   image: AssetImage(
              //                     'assets/images/insta_img.png',
              //                   ),
              //                   height: Responsive.isMobile(context) ? 20 : 40,
              //                   width: Responsive.isMobile(context)
              //                       ? 20
              //                       : Responsive.isTablet(context)
              //                           ? 30
              //                           : 40,
              //                 )),
              //             SizedBox(
              //               width: 8,
              //             ),
              //             InkWell(
              //                 onTap: () async {
              //                   if (!await launchUrl(
              //                       Uri.parse('https://www.linkedin.com'))) {
              //                     throw Exception('Could not launch ');
              //                   }
              //                 },
              //                 child: Image(
              //                   image: AssetImage(
              //                     'assets/images/linkedin_img.png',
              //                   ),
              //                   height: Responsive.isMobile(context) ? 20 : 40,
              //                   width: Responsive.isMobile(context)
              //                       ? 20
              //                       : Responsive.isTablet(context)
              //                           ? 30
              //                           : 40,
              //                 )),
              //             SizedBox(
              //               width: 8,
              //             ),
              //             InkWell(
              //                 onTap: () async{
              //                   if (!await launchUrl(
              //                       Uri.parse('https://www.facebook.com'))) {
              //                     throw Exception('Could not launch ');
              //                   }
              //
              //                 },
              //
              //                 child: Image(
              //                   image: AssetImage(
              //                     'assets/images/facebook_img.png',
              //                   ),
              //                   height: Responsive.isMobile(context) ? 20 : 40,
              //                   width: Responsive.isMobile(context)
              //                       ? 20
              //                       : Responsive.isTablet(context)
              //                           ? 30
              //                           : 40,
              //                 )),
              //           ],
              //         ),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         Text(
              //           'Copyright ©️ 2024. All rights reserved.',
              //           style: TextStyle(
              //               fontSize: Responsive.isMobile(context)
              //                   ? 8
              //                   : Responsive.isTablet(context)
              //                       ? 12
              //                       : 16,
              //               fontWeight: FontWeight.w500,
              //               fontFamily: 'Lora-Regular',
              //               color: AppColors.whiteColor),
              //         )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
class ChooseLocationWidget extends StatelessWidget {
  const ChooseLocationWidget({
    super.key,
    required this.controller,
  });
  final OnboardingController controller;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Choose Location",
            style: TextStyle(
              fontSize: Responsive.isMobile(context)
                  ? 22
                  : Responsive.isTablet(context)
                      ? 35
                      : 60,
              fontWeight: FontWeight.w400,
              fontFamily: 'aftika-regular',
              color: AppColors.headingTextColor,
            ),
          ),
           SizedBox(height:Responsive.isMobile(context)
              ? 10: 22),
          Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropDownButton(
                    hintText: 'Country',
                    items: const ["Pakistan", "USA", "UAE","Turkey","Thailand"],
                    containerColor: const Color(0xFFFFFFFF),
                    textColor: Colors.grey,
                    onChanged: (value) {
                      controller.selectedCountry.value = value!;
                      controller.hasError.value = false;
                    },
                    selectedValue: controller.selectedCountry.value,
                    height: Responsive.isMobile(context)
                        ? 52
                        : Responsive.isTablet(context)
                        ? 44
                        : 60,
                    width: Responsive.isMobile(context)
                        ? 320
                        : Responsive.isTablet(context)
                        ? 320
                        : 501,
                    hintfontsize: Responsive.isMobile(context)
                        ? 12
                        : Responsive.isTablet(context)
                        ? 14
                        : 18,),
                  SizedBox(height:Responsive.isMobile(context)
                      ? 10: 22),
                  DropDownButton(
                    height: Responsive.isMobile(context)
                        ? 52
                        : Responsive.isTablet(context)
                        ? 44
                        : 60,
                    width: Responsive.isMobile(context)
                        ? 320
                        : Responsive.isTablet(context)
                        ? 320
                        : 501,
                    hintText: "City",
                    hintfontsize: Responsive.isMobile(context)
                        ? 14
                        : Responsive.isTablet(context)
                        ? 14
                        : 18,
                    dropdownItemWidth: Responsive.isMobile(context)
                        ? 100
                        : Responsive.isTablet(context)
                        ? 320
                        : 101,
                    items: const ["Islamabad", "London", "New York","Washington","Dubai","Istanbul","Bangkok"],
                    selectedValue: controller.selectedCity.value,
                    onChanged: (value) {
                      controller.selectedCity.value = value!;
                      controller.hasError.value = false;
                    },
                    containerColor: const Color(0xFFFFFFFF),
                    textColor: Colors.grey,),
                  const SizedBox(height: 20,),

                  if (controller.hasError.value)
                    Padding(
                      padding: const EdgeInsets.only(
                        // left: Responsive.isMobile(context)
                        //     ? 90
                        //     : Responsive.isTablet(context)
                        //     ? 2
                        //     : 2.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: Responsive.isMobile(context)
                                ? 12
                                : Responsive.isTablet(context)
                                ? 16
                                : 16 ,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Please select both country and city.',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: Responsive.isMobile(context)
                                    ? 10
                                    : Responsive.isTablet(context)
                                        ? 14
                                        : 14),
                          ),
                        ],
                      ),
                    ),
                ],
              )),
          SizedBox(height: Responsive.isMobile(context) ?8 : Responsive.isTablet(context)
              ?18: 32),
          Padding(
            padding: EdgeInsets.only(
              left: Responsive.isMobile(context)
                  ? 2
                  : Responsive.isTablet(context)
                      ? 2
                      : 2.0,
            ),
            child: CustomButton(
              laBelText: 'Next',
              height: Responsive.isMobile(context)
                  ? 48
                  : Responsive.isTablet(context)
                      ? 32
                      : 50,
              width: Responsive.isMobile(context)
                  ? 200
                  : Responsive.isTablet(context)
                      ? 170
                      : 250,
              textColor: AppColors.whiteColor,
              fontSize: Responsive.isMobile(context)
                  ? 20
                  : Responsive.isTablet(context)
                      ? 18
                      : 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Lora-Regular',
              ontapp: () {
                if (controller.selectedCountry.value == 'Country' ||
                    controller.selectedCity.value == 'City') {
                  controller.hasError.value = true; // Show error
                } else {
                  // Proceed with the next step
                  controller.hasError.value = false;
                  Get.offAll(() => MyHomeScreen());
                  // Your next logic here
                }
              },
            ),
          ),
          const SizedBox(height: 100,)
        ],
      ),
    );
  }
}
// Positioned(
//
// bottom:480,
// left: 560,
// child: Image.asset('assets/images/star_img.png',
// height: Responsive.isMobile(context)? 120 :150,width:Responsive.isMobile(context)? 80 : 155,),
//
// ),
