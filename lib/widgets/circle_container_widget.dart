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
  final double? width;
  final double? height;
  final VoidCallback? ontap;

  const CircleContainerWidget({
    super.key,
    required this.imgPath,
    required this.titleText,
    required this.descriptionText,
    this.isLocation = false,
    this.ontap,
    required this.isFavourite,
    this.width,
    this.height, // Default value remains false
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: width ?? 113,
        height: height ?? 144,
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
            Container(
              height: 95,
              width: 95,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imgPath),
                ),
              ),
            ),
            // Positioned(
            //   left: 12,
            //   top: 16,
            //   child: Obx(() {
            //     return InkWell(
            //         onTap: () {
            //           isFavourite.value = !isFavourite.value;
            //         },
            //         child: isFavourite.value
            //             ? Icon(
            //                 size: 18,
            //                 Icons.favorite,
            //                 color: AppColors.primaryColor,
            //               )
            //             : Icon(
            //                 Icons.favorite,
            //                 size: 18,
            //                 color: AppColors.whiteColor,
            //               ));
            //   }),
            //   height: 10,
            //   width: 10,
            // )

            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLocation)
                  Icon(
                    Icons.location_on,
                    color: AppColors.primaryColor,
                    size: 14,
                  ),
                const SizedBox(width: 4),
                Text(
                  titleText, // 'Super mega sale'
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 9,
                    fontFamily: 'Nunito-Bold',
                    color: AppColors.bottomSheetColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              descriptionText,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 9,
                fontFamily: 'Nunito-Regular',
                color: AppColors.textColor,
              ),
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
