import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';

import '../../../../utils/responsive.dart';

class LocationStarWidget extends StatefulWidget {
  final String timeText1;
  final String timeText2;
  final String percentageText;

  const LocationStarWidget(
      {super.key, required this.timeText1, required this.percentageText, required this.timeText2});

  @override
  _LocationStarWidgetState createState() => _LocationStarWidgetState();
}

class _LocationStarWidgetState extends State<LocationStarWidget> {
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
        : AppColors.blackColor;

    return InkWell(
      onTap: _toggleTapped, // Handle tap
      child: Container(
        height: 200,
        width: 85,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${widget.timeText1} to',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: textColor,
                  fontFamily: 'Nunito-Regular'),textAlign: TextAlign.center,
            ),
            Text(
              widget.timeText2,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: textColor,
                  fontFamily: 'Nunito-Regular'),textAlign: TextAlign.center,
            ),
            Text(
              '${widget.percentageText} off',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: textColor,
                  fontFamily: 'Nunito-Regular'),
            ),
          ],
        ),
      ),
    );
  }
}
