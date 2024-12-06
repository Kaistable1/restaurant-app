import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';

import '../utils/responsive.dart';

class CircleContainerWidget extends StatelessWidget {
  final String imgPath;
  final String titleText;
  final String descriptionText;
  final bool isLocation;
  final RxBool isFavourite;
  final VoidCallback?
      ontap; // changed islocation to isLocation for better readability

  const CircleContainerWidget({
    super.key,
    required this.imgPath,
    required this.titleText,
    required this.descriptionText,
    this.isLocation = false,
    this.ontap,
    required this.isFavourite, // Default value remains false
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;

    return InkWell(
      onTap: ontap,
      child: Container(
        width: Responsive.isMobile(context)
            ? 113
            : isLargeScreen
                ? 270
                : 200,
        height: Responsive.isMobile(context)
            ? 144
            : isLargeScreen
                ? 365
                : 280,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 2,
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
                height: 95,
                width:95,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image:
                        AssetImage(imgPath), // 'assets/images/circle_img.png'
                  ),
                ),
              ),
              Positioned(
                left: Responsive.isMobile(context)
                    ? 12
                    : isLargeScreen
                        ? 40
                        : 30,
                top: Responsive.isMobile(context)
                    ? 16
                    : isLargeScreen
                        ? 40
                        : 30,
                child: Obx(() {
                  return InkWell(
                      onTap: () {
                        isFavourite.value = !isFavourite.value;
                      },
                      child: isFavourite.value
                          ? Icon(size: 18 ,
                              Icons.favorite,
                              color: AppColors.primaryColor,
                            )
                          : Icon(Icons.favorite,size: 18,color: AppColors.whiteColor   ,));
                }
                ),
                height: Responsive.isMobile(context)
                    ? 10
                    : isLargeScreen
                        ? 24
                        : 20,
                width: Responsive.isMobile(context)
                    ? 10
                    : isLargeScreen
                        ? 24
                        : 20,
              )
            ]),

            SizedBox(
              height: Responsive.isMobile(context)
                  ?16
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
                    fontWeight: FontWeight.w700,
                    fontSize: Responsive.isMobile(context)
                        ? 9
                        : isLargeScreen
                            ? 22
                            : 16,
                    fontFamily: 'Nunito-Bold',
                    color: AppColors.bottomSheetColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Responsive.isMobile(context)
                  ? 6
                  : isLargeScreen
                      ? 10
                      : 10,
            ),
            Text(
              descriptionText, // '14 restaurants'
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: Responsive.isMobile(context)
                    ? 9
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
