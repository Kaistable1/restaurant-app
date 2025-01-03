import 'package:flutter/material.dart';

import '../../../../utils/responsive.dart'; // Make sure your Responsive class is properly imported

class ReviewGridScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int itemsPerRow = screenWidth > 600 ? 3 : 2;
    int totalItems = 6;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            (totalItems / itemsPerRow).ceil(),
            (rowIndex) {
              int startIndex = rowIndex * itemsPerRow;
              int endIndex = (rowIndex + 1) * itemsPerRow;

              return ReviewRow(
                startIndex: startIndex,
                endIndex: endIndex,
                itemsPerRow: itemsPerRow,
                totalItems: totalItems,
                context: context,
              );
            },
          ),
        ),
      ),
    );
  }
}

class ReviewRow extends StatelessWidget {
  final int startIndex;
  final int endIndex;
  final int itemsPerRow;
  final int totalItems;
  final BuildContext context;

  const ReviewRow({
    Key? key,
    required this.startIndex,
    required this.endIndex,
    required this.itemsPerRow,
    required this.totalItems,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        endIndex <= totalItems ? itemsPerRow : totalItems - startIndex,
        (index) {
          int currentIndex = startIndex + index;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReviewContainer(context: context),
            ),
          );
        },
      ),
    );
  }
}

class ReviewContainer extends StatelessWidget {
  final BuildContext context;

  const ReviewContainer({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
          ),
        ],
      ),
      child: Responsive.isMobile(context)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReviewHeader(context: context),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Voluptatem atque molestiae numquam voluptatem veritatis nesciunt commodi.',
                    style: TextStyle(fontSize: 8),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),
                ImageRow(),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReviewHeader(context: context),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Voluptatem atque molestiae numquam voluptatem veritatis nesciunt commodi.',
                    style: TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),
                ImageRow(),
              ],
            ),
    );
  }
}

class ReviewHeader extends StatelessWidget {
  final BuildContext context;

  const ReviewHeader({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.teal,
            child: Text(
              'KW',
              style: TextStyle(
                color: Colors.white,
                fontSize:
                    Responsive.isMobile(context) || Responsive.isTablet(context)
                        ? 8
                        : 14,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Responsive.isMobile(context) || Responsive.isTablet(context)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deanna Blanda',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.isMobile(context) ||
                                  Responsive.isTablet(context)
                              ? 12
                              : 14,
                        ),
                      ),
                      const Text(
                        '(5.0)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      StarRating(),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Deanna Blanda',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.isMobile(context) ||
                                  Responsive.isTablet(context)
                              ? 12
                              : 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '(5.0)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      StarRating(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  const StarRating({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return const Icon(
          Icons.star,
          color: Colors.orange,
          size: 16,
        );
      }),
    );
  }
}

class ImageRow extends StatelessWidget {
  const ImageRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          ImageContainer(imagePath: 'assets/images/dish1.png'),
          SizedBox(width: 10),
          ImageContainer(imagePath: 'assets/images/dish1.png'),
          SizedBox(width: 10),
          ImageContainer(imagePath: 'assets/images/dish1.png'),
        ],
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final String imagePath;

  const ImageContainer({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double containerSize;

    if (Responsive.isMobile(context)) {
      containerSize = 36;
    } else if (Responsive.isTablet(context)) {
      containerSize = 60;
    } else {
      containerSize = 72;
    }

    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
