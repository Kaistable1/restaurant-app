import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import '../utils/responsive.dart';
class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.botomSheetColor,
      height:  Responsive.isMobile(context) ? 210 :390,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(Responsive.isMobile(context) ? 4 :8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Business name',
                    style: TextStyle(
                      fontSize:  Responsive.isMobile(context) ? 8 : Responsive.isTablet(context)?14:18,
                      fontFamily: 'Nunito-Regular',
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500
                    ),
                    ),
                    SizedBox(height:  Responsive.isMobile(context) ? 10: Responsive.isTablet(context)?20 :30,),
                    Text('emerchant',
                      style: TextStyle(
                          fontSize:  Responsive.isMobile(context) ? 6 : Responsive.isTablet(context)?12:16,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(height:  Responsive.isMobile(context) ? 10: Responsive.isTablet(context)?20 :30,),
                    Text('about us',
                      style: TextStyle(
                          fontSize:  Responsive.isMobile(context) ? 6: Responsive.isTablet(context)?12 :16,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(height:  Responsive.isMobile(context) ? 10: Responsive.isTablet(context)?20 :30,),
                    Text('contact us',
                      style: TextStyle(
                          fontSize:  Responsive.isMobile(context) ? 6 : Responsive.isTablet(context)?12:16,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(height:  Responsive.isMobile(context) ? 10: Responsive.isTablet(context)?20 :30,),
                    Text('favorite',
                      style: TextStyle(
                          fontSize:  Responsive.isMobile(context) ? 6: Responsive.isTablet(context)?12 :16,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
                SizedBox(height:  Responsive.isMobile(context) ? 10: Responsive.isTablet(context)?20 :30,),
                Image(image: const AssetImage('assets/images/botomsheet_logo.png'),
                  height: Responsive.isMobile(context) ? 40 : Responsive.isTablet(context)?90:156,width:Responsive.isMobile(context) ? 200 : Responsive.isTablet(context)?320: 482,),
                SizedBox(width: Responsive.isMobile(context) ? 8 :60,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Support',
                      style: TextStyle(
                          fontSize: Responsive.isMobile(context) ? 8: Responsive.isTablet(context)?14 :18,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(height:  Responsive.isMobile(context) ? 10: Responsive.isTablet(context)?20 :30,),
                    Text("FAQ's",
                      style: TextStyle(
                          fontSize:  Responsive.isMobile(context) ? 6 : Responsive.isTablet(context)?12:16,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(height:  Responsive.isMobile(context) ? 10: Responsive.isTablet(context)?20 :30,),
                    Text('terms of use',
                      style: TextStyle(
                          fontSize:  Responsive.isMobile(context) ? 6 : Responsive.isTablet(context)?12:16,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(height:  Responsive.isMobile(context) ? 10: Responsive.isTablet(context)?20 :30,),
                    Text('privacy policy',
                      style: TextStyle(
                          fontSize:  Responsive.isMobile(context) ? 6: Responsive.isTablet(context)?12 :16,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(height:  Responsive.isMobile(context) ? 10: Responsive.isTablet(context)?20 :30,),
                    Text('fair uses policy',
                      style: TextStyle(
                          fontSize:  Responsive.isMobile(context) ? 6: Responsive.isTablet(context)?12 :16,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height:  Responsive.isMobile(context) ? 30: Responsive.isTablet(context)?20 :30,),
          Image(image:const AssetImage('assets/images/divider_line.png'),height:1,width: Get.width,fit: BoxFit.cover,),
          Padding(
            padding:  EdgeInsets.only(left:  Responsive.isMobile(context) ? 20 :90,
            right:  Responsive.isMobile(context) ? 30 :60, top: Responsive.isMobile(context) ? 12 :20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('© 2024  business name Inc. All rights reserved.',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize:  Responsive.isMobile(context) ? 6 : Responsive.isTablet(context)?8:12,
                  color: AppColors.whiteColor,
                  fontFamily: 'Nunito-Regular'
                )
                ),
                const Spacer(),
                Image(image: const AssetImage('assets/images/insta_light.png'),
                  height:  Responsive.isMobile(context) ? 16: Responsive.isTablet(context)?22 :40,width:  Responsive.isMobile(context) ? 16 : Responsive.isTablet(context)?22:40,),
                SizedBox(width: Responsive.isMobile(context) ? 6 :10,),
                Image(image: const AssetImage('assets/images/linkedin_light.png'),
                  height:  Responsive.isMobile(context) ? 16 : Responsive.isTablet(context)?22:40,width: Responsive.isMobile(context) ? 16: Responsive.isTablet(context)?22 : 40,),
                SizedBox(width: Responsive.isMobile(context) ? 6 :10,),
                Image(image: const AssetImage('assets/images/facebook_light.png'),
                  height:  Responsive.isMobile(context) ? 16 : Responsive.isTablet(context)?22 :40,width: Responsive.isMobile(context) ? 16 : Responsive.isTablet(context)?22 : 40,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
