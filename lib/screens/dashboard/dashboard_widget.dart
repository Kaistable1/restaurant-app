import 'package:flutter/material.dart';

class DashboardCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String count;
  final double? width;
  final void Function()? onTap;

  const DashboardCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.count,
    this.onTap,
    this.width,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool _isTapped = false;

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
      cardWidth = 200;
      cardHeight = 150;
      iconSize = 40;
      titleFontSize = 14;
      countFontSize = 24;
    } else if (screenWidth < 1024) {
      cardWidth = 250;
      cardHeight = 180;
      iconSize = 50;
      titleFontSize = 16;
      countFontSize = 28;
    } else if (screenWidth < 1440) {
      cardWidth = 280;
      cardHeight = 200;
      iconSize = 55;
      titleFontSize = 18;
      countFontSize = 30;
    } else {
      cardWidth = 320;
      cardHeight = 220;
      iconSize = 60;
      titleFontSize = 20;
      countFontSize = 34;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isTapped = true),
      onTapUp: (_) {
        setState(() => _isTapped = false);
        if (widget.onTap != null) widget.onTap!();
      },
      onTapCancel: () => setState(() => _isTapped = false),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width ?? cardWidth,
          height: cardHeight,
          transform: _isTapped
              ? Matrix4.identity().scaled(1.03) // Scale up slightly
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isTapped ? 0.2 : 0.1),
                blurRadius: _isTapped ? 10 : 6,
                spreadRadius: _isTapped ? 4 : 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
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
                      widget.imagePath,
                      width: iconSize * 0.5,
                      height: iconSize * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: iconSize * 0.8),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.count,
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
        ),
      ),
    );
  }
}
