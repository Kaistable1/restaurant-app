import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String count;

  const DashboardCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Responsive width & height based on screen size
    double cardWidth;
    double cardHeight;
    double iconSize;
    double titleFontSize;
    double countFontSize;

    if (screenWidth < 600) {
      // Mobile
      cardWidth = 200;
      cardHeight = 150;
      iconSize = 40;
      titleFontSize = 14;
      countFontSize = 24;
    } else if (screenWidth < 1024) {
      // Tablet
      cardWidth = 250;
      cardHeight = 180;
      iconSize = 50;
      titleFontSize = 16;
      countFontSize = 28;
    } else if (screenWidth < 1440) {
      // Laptop
      cardWidth = 280;
      cardHeight = 200;
      iconSize = 55;
      titleFontSize = 18;
      countFontSize = 30;
    } else {
      // Desktop
      cardWidth = 320;
      cardHeight = 220;
      iconSize = 60;
      titleFontSize = 20;
      countFontSize = 34;
    }

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Primary color box at the top
          Positioned(
            top: -(iconSize / 2),
            child: Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF4ECCA3),
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  imagePath,
                  width: iconSize * 0.5,
                  height: iconSize * 0.5,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Text inside the container
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: iconSize * 0.8), // Space for the top icon
              Text(
                title,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                count,
                style: TextStyle(
                  fontSize: countFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

