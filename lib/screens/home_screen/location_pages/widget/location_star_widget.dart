import 'package:flutter/material.dart';
import 'package:kaistable_website/constants/app_colors.dart';

class LocationStarWidget extends StatefulWidget {
  final String timeText;
  final String persentText;

  const LocationStarWidget({super.key, required this.timeText, required this.persentText});

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
    final String imagePath = _isTapped ? 'assets/images/star_img.png' : 'assets/images/star_img2.png';
    final Color textColor = _isTapped ? AppColors.whiteColor: AppColors.blackColor; // Change the color as desired

    return GestureDetector(
      onTap: _toggleTapped, // Handle tap
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.timeText,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: textColor,
                  fontFamily: 'Nunito-Regular'
                ),
              ),
              Text(
                widget.persentText,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: textColor,
                    fontFamily: 'Nunito-Regular'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

