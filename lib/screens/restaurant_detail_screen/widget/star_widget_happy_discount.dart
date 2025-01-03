import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../utils/responsive.dart';

class StarHappyDisount extends StatefulWidget {
  final String timeText;
  final String persentText;

  const StarHappyDisount(
      {super.key, required this.timeText, required this.persentText});

  @override
  _StarHappyDisountState createState() => _StarHappyDisountState();
}

class _StarHappyDisountState extends State<StarHappyDisount> {
  // Initial state
  bool _isTapped = false;

  // Method to toggle the state
  void _toggleTapped() {
    setState(() {
      _isTapped = !_isTapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Change image and text color based on _isTapped state
    final String imagePath = _isTapped
        ? 'assets/images/star_img.png'
        : 'assets/images/star_img2.png';
    final Color textColor = _isTapped
        ? AppColors.whiteColor
        : AppColors.blackColor; // Change the color as desired

    return InkWell(
      onTap: _toggleTapped, // Handle tap
      child: Container(
        height: 120,
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
          // Use Center to ensure content is perfectly centered
          child: Column(
            mainAxisSize: MainAxisSize.min, // Align children to the center
            children: [
              Text(
                widget.timeText,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Responsive.isMobile(context)
                      ? 8
                      : Responsive.isTablet(context)
                          ? 10
                          : 12,
                  color: textColor,
                  fontFamily: 'Nunito-Regular',
                ),
              ),
              SizedBox(height: 4), // Add spacing between the texts if needed
              Text(
                widget.persentText,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: Responsive.isMobile(context)
                      ? 8
                      : Responsive.isTablet(context)
                          ? 10
                          : 12,
                  color: textColor,
                  fontFamily: 'Nunito-Regular',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
