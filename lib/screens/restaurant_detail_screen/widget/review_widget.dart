import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../constants/colors.dart';

class ReviewsAndRatings extends StatelessWidget {
  final List<int> ratingsCount;
  final double averageRating;

  const ReviewsAndRatings({
    Key? key,
    required this.ratingsCount,
    required this.averageRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Define responsive container height
    double containerHeight = screenHeight * 0.4;

    return Container(
      height: containerHeight.clamp(250.0, 400.0), // Set min and max height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Responsive Title
            Text(
              'Reviews and Ratings',
              style: TextStyle(
                fontSize: screenWidth < 400 ? 16 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Responsive Row Layout
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Column
                  _buildLeftColumn(averageRating, screenWidth, screenHeight),
                  SizedBox(width: screenWidth * 0.08),

                  // Right Column
                  Expanded(
                    child: _buildRightColumn(
                        ratingsCount, screenWidth, screenHeight),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(
      double averageRating, double screenWidth, double screenHeight) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Overall Rating & Reviews',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            averageRating.toString(),
            style: TextStyle(
              fontSize: screenWidth < 400 ? 40 : 48,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          RatingBarIndicator(
            rating: averageRating,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: AppColors.primaryColor,
            ),
            itemCount: 5,
            itemSize: screenWidth < 400 ? 20 : 24,
            direction: Axis.horizontal,
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn(
      List<int> ratingsCount, double screenWidth, double screenHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final int selectedStars = 5 - index;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
          child: Row(
            children: [
              // Stars
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < selectedStars ? Icons.star : Icons.star_border,
                    color: AppColors.primaryColor,
                    size: screenWidth < 400 ? 14 : 16,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              // Progress Indicator
              Expanded(
                child: LinearProgressIndicator(
                  value: ratingsCount[index] / 100,
                  backgroundColor: Colors.teal.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              // Rating Count
              Text(
                ratingsCount[index].toString(),
                style: TextStyle(
                  fontSize: screenWidth < 400 ? 12 : 14,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
