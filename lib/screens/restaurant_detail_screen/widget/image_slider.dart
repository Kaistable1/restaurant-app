import 'package:flutter/material.dart';
import 'package:restaurant_web_app/universal_models/restaurant_model.dart';

import '../../../../utils/responsive.dart';

class ImageSlider extends StatefulWidget {
  ImageSlider({Key? key, required this.resModel}) : super(key: key);
  RestaurantModel resModel;
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> _images = [
    'assets/images/img1.png',
    'assets/images/img1.png',
    'assets/images/img1.png',
  ];

  void _navigateTo(int index) {
    if (index >= 0 && index < _images.length) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: isLargeScreen ? 550 : 300,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: widget.resModel.resImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.resModel.resImages[index].value),
                        fit: BoxFit.fitHeight,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                  );
                },
              ),
            ),
            Positioned(
              left: 40, // Adjust the value to add space from the list
              // top: 0,
              // bottom: 0,
              child: InkWell(
                onTap: () => _navigateTo(_currentIndex - 1),
                child: Image.asset(
                  'assets/images/arrow_back.png',
                  height: Responsive.isMobile(context) ? 32 : 42,
                  width: Responsive.isMobile(context) ? 32 : 42,
                ),
              ),
            ),
            Positioned(
              right: 40, // Adjust the value to add space from the list
              // top: 0,
              // bottom: 0,
              child: InkWell(
                onTap: () => _navigateTo(_currentIndex + 1),
                child: Image.asset(
                  'assets/images/arrow_forward.png',
                  height: Responsive.isMobile(context) ? 32 : 42,
                  width: Responsive.isMobile(context) ? 32 : 42,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
