import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../utils/responsive.dart';

class LocationStarWidget extends StatefulWidget {
  final String timeText;
  final String persentText;
  final TextStyle? timeTextStyle;
  final TextStyle? persentTextStyle;

  const LocationStarWidget({
    super.key,
    required this.timeText,
    required this.persentText,
    this.timeTextStyle,
    this.persentTextStyle,
  });

  @override
  _LocationStarWidgetState createState() => _LocationStarWidgetState();
}

class _LocationStarWidgetState extends State<LocationStarWidget> {
  bool _isTapped = false;

  void _toggleTapped() {
    setState(() {
      _isTapped = !_isTapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = _isTapped
        ? 'assets/images/star_img.png'
        : 'assets/images/star_img2.png';
    final Color textColor = _isTapped
        ? AppColors.whiteColor
        : AppColors.blackColor;

    return InkWell(
      onTap: _toggleTapped,
      child: SizedBox(
        height: 120,
        width: Responsive.isMobile(context)
            ? Get.width * 0.15
            : Responsive.isTablet(context)
            ? Get.width * 0.09
            : Get.width * 0.09,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.timeText,
                  style: widget.timeTextStyle ??
                      TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Responsive.isMobile(context)
                            ? 8
                            : Responsive.isTablet(context)
                            ? 10
                            : 12,
                        color: textColor,
                        fontFamily: 'Nunito-Regular',
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  widget.persentText,
                  style: widget.persentTextStyle ??
                      TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Responsive.isMobile(context)
                            ? 8
                            : Responsive.isTablet(context)
                            ? 10
                            : 12,
                        color: textColor,
                        fontFamily: 'Nunito-Regular',
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
