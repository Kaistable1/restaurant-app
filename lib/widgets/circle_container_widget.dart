import 'package:flutter/material.dart';
import 'package:kaistable_website/constants/app_colors.dart';

import '../utils/responsive.dart';

class CircleContainerWidget extends StatelessWidget {
  final String imgPath;
  final String titleText;
  final String descriptionText;
  final bool isLocation;
  final VoidCallback? ontap;// changed islocation to isLocation for better readability

  const CircleContainerWidget({
    super.key,
    required this.imgPath,
    required this.titleText,
    required this.descriptionText,
    this.isLocation = false, this.ontap, // Default value remains false
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;

    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: Responsive.isMobile(context)
            ? 110
            : isLargeScreen
            ? 270
            : 200,
        height: Responsive.isMobile(context)
            ? 180
            : isLargeScreen
            ? 365
            : 280,
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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(150),
            topRight: Radius.circular(150),
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: Responsive.isMobile(context)
                      ? 105
                      : isLargeScreen
                      ? 230
                      : 170,
                  width: Responsive.isMobile(context)
                      ? 95
                      : isLargeScreen
                      ? 230
                      : 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(imgPath), // 'assets/images/circle_img.png'
                    ),
                  ),
                ),
                Positioned(
                  left: Responsive.isMobile(context)?20:isLargeScreen?40:30,
                  top: Responsive.isMobile(context)?20:isLargeScreen?40:30,
                  child: Image.asset('assets/images/heart_white_icon.png'),
                  height: Responsive.isMobile(context)?10:isLargeScreen?24:20,width:  Responsive.isMobile(context)?10:isLargeScreen?24:20,)
              ]
            ),
            SizedBox(
              height: Responsive.isMobile(context)
                  ? 20
                  : isLargeScreen
                  ? 25
                  : 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLocation) // Conditionally show the location icon
                  Icon(
                    Icons.location_on,
                    color: AppColors.primaryColor, // Adjust color if needed
                    size: Responsive.isMobile(context)
                        ? 14
                        : isLargeScreen
                        ? 26
                        : 18, // Adjust size if needed
                  ),
                const SizedBox(width: 4), // Space between icon and text
                Text(
                  titleText, // 'Super mega sale'
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Responsive.isMobile(context)
                        ? 8
                        : isLargeScreen
                        ? 22
                        : 16,
                    fontFamily: 'Nunito-Regular',
                    color: AppColors.botomSheetColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Responsive.isMobile(context)
                  ? 2
                  : isLargeScreen
                  ? 10
                  : 10,
            ),

            Text(
              descriptionText, // '14 restaurants'
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: Responsive.isMobile(context)
                    ? 8
                    : isLargeScreen
                    ? 18
                    : 14,
                fontFamily: 'Nunito-Regular',
                color: AppColors.textColor,
              ),
            ),
            SizedBox(
              height: Responsive.isMobile(context)
                  ? 12
                  : isLargeScreen
                  ? 2
                  : 2,
            ),
          ],
        ),
      ),
    );
  }
}
