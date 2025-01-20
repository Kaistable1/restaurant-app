import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/responsive.dart';
class CustomFilterWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imgPath;
  const CustomFilterWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imgPath});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool ismedium = screenWidth == 1200;
    bool isLargeScreen = screenWidth > 1400;
    return Container(
      height: Responsive.isMobile(context) ? 50 :Responsive.isTablet(context) ? 68 :isLargeScreen ? 118 :90,
      width: Responsive.isMobile(context) ? 190 :Responsive.isTablet(context) ? 345 :isLargeScreen ? 490:412,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Responsive.isMobile(context) ? 6 :10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 12,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child:  Row(

        children: [
          SizedBox(width: Responsive.isMobile(context) ? 6 :10,),
          Image(image: AssetImage(imgPath),height:Responsive.isMobile(context) ? 36 :Responsive.isTablet(context) ? 58:isLargeScreen ? 104
              : 78,width:Responsive.isMobile(context) ? 40 :Responsive.isTablet(context) ? 60 :isLargeScreen ? 109: 80,),
          SizedBox(width:Responsive.isMobile(context) ? 10 : 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Responsive.isMobile(context) ? 8 :isLargeScreen?10:1,),
              Text(title,//'Abc restaurant',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: Responsive.isMobile(context) ? 8 :Responsive.isTablet(context) ? 15:isLargeScreen ? 22:20,
                    fontFamily: 'Nunito-Bold',
                    color: AppColors.textColor
                ),),
              SizedBox(height: Responsive.isMobile(context) ? 1:isLargeScreen?6:1,),
              SizedBox(
                width: Responsive.isMobile(context) ? 100 :Responsive.isTablet(context) ? 210:isLargeScreen ? 330:300,
                height: Responsive.isMobile(context) ? 30:Responsive.isTablet(context) ? 33:isLargeScreen ? 54:40,
                child: Text(description,//'Duis aute irure dolor in reprehend voluptate velit esse cillum',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: Responsive.isMobile(context) ? 6 :Responsive.isTablet(context) ? 12:isLargeScreen ? 18:16,
                      fontFamily: 'Nunito-Regilar',
                      color: AppColors.textColor
                  ),),
              ),
            ],
          )
        ],
      ),


    );
  }
}
