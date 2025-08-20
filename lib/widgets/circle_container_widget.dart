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
        width: Get.width * 0.45,
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 172,
              height: 124,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(imgPath),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                      fontSize: 14,
                      fontFamily: 'Nunito-Bold',
                      color: AppColors.bottomSheetColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Text(
                    descriptionText,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      fontFamily: 'Nunito-Regular',
                      color: AppColors.textColor,
                    ),
                  ),
                ],
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
