
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';
import '../../../../utils/responsive.dart';

class StarWidget extends StatelessWidget {
  final String timeText;
  final String persentText;
  final TextStyle? timeTextStyle;
  final TextStyle? persentTextStyle;
  final bool isSelected;
  final VoidCallback onTap;

  const StarWidget({
    super.key,
    required this.timeText,
    required this.persentText,
    this.timeTextStyle,
    this.persentTextStyle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String imagePath = isSelected
        ? 'assets/images/star_img.png'
        : 'assets/images/star_img2.png';
    final Color textColor =
    isSelected ? AppColors.whiteColor : AppColors.blackColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        width: Responsive.isMobile(context)
            ? Get.width * 0.15
            : Responsive.isTablet(context)
            ? Get.width * 0.09
            : Get.width * 0.09,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          SizedBox(
          width: Get.width * 0.08, // Limit width of text inside the star
            child: Text(
              timeText,
              textAlign: TextAlign.center, // Ensures text remains inside
              overflow: TextOverflow.ellipsis, // Clips text if too long
              maxLines: 2, // Limits to two lines
              style: timeTextStyle ??
                  TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: Responsive.isDesktop(context) ? 14: 10,
                    color: textColor,
                    fontFamily: 'Nunito-Regular',
                  ),
            ),
          ),
          const SizedBox(height: 2), // Reduce spacing
          SizedBox(
            width: Get.width * 0.08,
            child: Text(
              '${persentText}% off',
              textAlign: TextAlign.center,
              style: persentTextStyle ??
                  TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: Responsive.isDesktop(context) ? 14 : 10,
                    color: textColor,
                    fontFamily: 'Nunito-Regular',
                  ),)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
