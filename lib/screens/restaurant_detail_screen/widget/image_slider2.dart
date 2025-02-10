// import 'package:flutter/material.dart';
//
// import '../../../../utils/responsive.dart';
// import '../../../constants/colors.dart';
//
// class ImageSlider2 extends StatefulWidget {
//   const ImageSlider2({Key? key}) : super(key: key);
//
//   @override
//   _ImageSlider2State createState() => _ImageSlider2State();
// }
//
// class _ImageSlider2State extends State<ImageSlider2> {
//   final PageController _pageController = PageController();
//   int _currentIndex = 0;
//
//   final List<String> _images = [
//     'assets/images/img12.png',
//     'assets/images/image22.png',
//     'assets/images/img1.png',
//     'assets/images/img12.png',
//     'assets/images/image22.png',
//   ];
//
//   void _navigateTo(int index) {
//     if (index >= 0 && index < _images.length) {
//       _pageController.animateToPage(
//         index,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//       setState(() {
//         _currentIndex = index;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     bool isLargeScreen = screenWidth > 1400;
//
//     return Column(
//       children: [
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             SizedBox(
//               width: Responsive.isMobile(context) ? 140 : 162,
//               height: isLargeScreen ? 90 : 100,
//               child: PageView.builder(
//                 controller: _pageController,
//                 onPageChanged: (index) {
//                   setState(() {
//                     _currentIndex = index;
//                   });
//                 },
//                 itemCount: _images.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(_images[index]),
//                         fit: BoxFit.cover,
//                       ),
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     margin: const EdgeInsets.symmetric(horizontal: 10),
//                   );
//                 },
//               ),
//             ),
//             Positioned(
//               // Adjust the value to add space from the list
//               right: 15,
//               top: 2,
//               child: Text(
//                 '+5',
//                 style: TextStyle(
//                   color: AppColors.whiteColor,
//                   fontFamily: 'Nunito-Regular',
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 15, // Adjust the value to add space from the list
//               // top: 0,
//               // bottom: 0,
//               child: InkWell(
//                 onTap: () => _navigateTo(_currentIndex - 1),
//                 child: Image.asset(
//                   'assets/images/arrow_back.png',
//                   height: Responsive.isMobile(context) ? 15 : 22,
//                   width: Responsive.isMobile(context) ? 15 : 22,
//                 ),
//               ),
//             ),
//             Positioned(
//               right: 15, // Adjust the value to add space from the list
//               // top: 0,
//               // bottom: 0,
//               child: InkWell(
//                 onTap: () => _navigateTo(_currentIndex + 1),
//                 child: Image.asset(
//                   'assets/images/arrow_forward.png',
//                   height: Responsive.isMobile(context) ? 15 : 22,
//                   width: Responsive.isMobile(context) ? 15 : 22,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/responsive.dart';
import '../../../constants/colors.dart';

class ImageSlider2 extends StatefulWidget {
  final List<RxString> images; // Accept images dynamically

  const ImageSlider2({Key? key, required this.images}) : super(key: key);

  @override
  _ImageSlider2State createState() => _ImageSlider2State();
}

class _ImageSlider2State extends State<ImageSlider2> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0); // Start at index 0
  }

  void _navigateTo(int index) {
    if (index < 0 || index >= widget.images.length) return; // Prevent out-of-range navigation

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut, // Smooth transition
    );

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;

    if (widget.images.isEmpty) return SizedBox(); // Hide if no images
    bool isSingleImage = widget.images.length == 1;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: Responsive.isMobile(context) ? 140 : 162,
              height: isLargeScreen ? 90 : 100,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.images[index].value),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                  );
                },
              ),
            ),
            if (!isSingleImage && widget.images.length > 1)
              Positioned(
                right: 15,
                top: 2,
                child: Text(
                  '+${widget.images.length - 1}', // Show remaining count
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            // Left Button (Hide if first image or only one image)
            if (!isSingleImage && _currentIndex > 0)
              Positioned(
                left: 15,
                child: InkWell(
                  onTap: () => _navigateTo(_currentIndex - 1),
                  child: Image.asset(
                    'assets/images/arrow_back.png',
                    height: Responsive.isMobile(context) ? 15 : 22,
                    width: Responsive.isMobile(context) ? 15 : 22,
                  ),
                ),
              ),
            // Right Button (Hide if last image or only one image)
            if (!isSingleImage && _currentIndex < widget.images.length - 1)
              Positioned(
                right: 15,
                child: InkWell(
                  onTap: () => _navigateTo(_currentIndex + 1),
                  child: Image.asset(
                    'assets/images/arrow_forward.png',
                    height: Responsive.isMobile(context) ? 15 : 22,
                    width: Responsive.isMobile(context) ? 15 : 22,
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
