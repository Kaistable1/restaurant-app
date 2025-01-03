import 'package:flutter/material.dart';
import 'package:restaurant_web_app/constants/colors.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: AppColors.primaryColor, // The background color
      padding: EdgeInsets.symmetric(
        vertical: screenWidth > 600 ? 20.0 : 16.0, // Adjust vertical padding
        horizontal:
            screenWidth > 600 ? 40.0 : 20.0, // Adjust horizontal padding
      ),
      child: Column(
        children: [
          // Logo - adjust width and height based on screen size
          Image.asset(
            'assets/images/logo.png',
            width: screenWidth > 600 ? 250 : 198, // Adjust logo size
            height: screenWidth > 600 ? 90 : 71, // Adjust logo size
          ),
          const SizedBox(height: 8),
          Text(
            'Connect with Us and Explore',
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: screenWidth > 600 ? 36 : 32, // Adjust text size
              fontFamily: 'Nunito-Regular',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Social media icons with responsive sizes
              Image.asset(
                'assets/images/x_icon.png',
                width: screenWidth > 600 ? 40 : 32, // Adjust icon size
                height: screenWidth > 600 ? 40 : 32, // Adjust icon size
              ),
              SizedBox(width: screenWidth > 600 ? 40 : 30), // Adjust spacing
              Image.asset(
                'assets/images/insta.png',
                width: screenWidth > 600 ? 40 : 32, // Adjust icon size
                height: screenWidth > 600 ? 40 : 32, // Adjust icon size
              ),
              SizedBox(width: screenWidth > 600 ? 40 : 30), // Adjust spacing
              Image.asset(
                'assets/images/linkin.png',
                width: screenWidth > 600 ? 40 : 32, // Adjust icon size
                height: screenWidth > 600 ? 40 : 32, // Adjust icon size
              ),
            ],
          ),
        ],
      ),
    );
  }
}
