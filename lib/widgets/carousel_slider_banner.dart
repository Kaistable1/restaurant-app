import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class CarouselWidget extends StatelessWidget {
  // List of image paths
  final List<String> imagePaths;

  const CarouselWidget({
    super.key,
    required this.imagePaths,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: Get.height * 0.22, // Match original height
        viewportFraction: 1.0, // Full width
        aspectRatio: Get.width / (Get.height * 0.25),
        autoPlay: true, // Enable auto-play
        autoPlayInterval: const Duration(seconds: 3), // Time between slides
        autoPlayAnimationDuration:
            const Duration(milliseconds: 800), // Smooth transition
        autoPlayCurve: Curves.easeInOut, // Animation curve
        enlargeCenterPage: false, // No zoom effect
      ),
      items: imagePaths.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Image.network(
              imagePath,
              height: Get.height * 0.25,
              width: Get.width,
              fit: BoxFit.cover, // Ensure image fills the space
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: Get.height * 0.25,
                  width: Get.width,
                  color: Colors.grey[300],
                  child: const Center(child: Text('Image not found')),
                );
              },
            );
          },
        );
      }).toList(),
    );
  }
}
