import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_web_app/main.dart';
import 'package:restaurant_web_app/universal_models/reviews_model.dart';

import '../../../../utils/responsive.dart'; // Make sure your Responsive class is properly imported

class ReviewGridScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int itemsPerRow = screenWidth > 600 ? 3 : 2;
    int totalItems = 6;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('restaurants')
          .doc(auth.currentUser!.uid)
          .collection('reviews')
          .orderBy('dateTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox();
        }

        List<ReviewModel> reviews = snapshot.data!.docs
            .map((doc) =>
                ReviewModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                (reviews.length / 2).ceil(),
                (rowIndex) {
                  int startIndex = rowIndex * itemsPerRow;
                  int endIndex = (rowIndex + 1) * itemsPerRow;

                  return ReviewRow(
                    reviews: reviews.sublist(
                        startIndex, endIndex.clamp(0, reviews.length)),
                    startIndex: startIndex,
                    endIndex: endIndex.clamp(
                        0, reviews.length), // Ensures we don't exceed bounds
                    itemsPerRow: itemsPerRow,
                    totalItems: totalItems,
                    context: context,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class ReviewRow extends StatelessWidget {
  final List<ReviewModel> reviews;
  final int startIndex;
  final int endIndex;
  final int itemsPerRow;
  final int totalItems;
  final BuildContext context;

  const ReviewRow({
    Key? key,
    required this.reviews,
    required this.startIndex,
    required this.endIndex,
    required this.itemsPerRow,
    required this.totalItems,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        reviews.length,
        (index) {
          int currentIndex = startIndex + index;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReviewContainer(
                  context: context, review: reviews[currentIndex]),
            ),
          );
        },
      ),
    );
  }
}

class ReviewContainer extends StatelessWidget {
  final BuildContext context;
  final ReviewModel review;
  const ReviewContainer({Key? key, required this.context, required this.review})
      : super(key: key);

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
                ReviewHeader(
                  context: context,
                  review: review,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    review.description,
                    // 'Voluptatem atque molestiae numquam voluptatem veritatis nesciunt commodi.',
                    style: TextStyle(fontSize: 8),
                    // maxLines: 3,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),
                ImageRow(
                  images: review.images,
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReviewHeader(
                  context: context,
                  review: review,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    review.description,
                    // 'Voluptatem atque molestiae numquam voluptatem veritatis nesciunt commodi.',
                    style: TextStyle(fontSize: 12),
                    // maxLines: 2,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),
                ImageRow(images: review.images),
              ],
            ),
    );
  }
}

class ReviewHeader extends StatelessWidget {
  final BuildContext context;
  final ReviewModel review;
  const ReviewHeader({Key? key, required this.context, required this.review})
      : super(key: key);

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
              review.userName.isNotEmpty ? review.userName[0] : "U",
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
                        review.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.isMobile(context) ||
                                  Responsive.isTablet(context)
                              ? 12
                              : 14,
                        ),
                      ),
                      Text(
                        '(${review.starRating.toString()})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      StarRating(
                        rating: review.starRating,
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        review.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.isMobile(context) ||
                                  Responsive.isTablet(context)
                              ? 12
                              : 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '(${review.starRating.toString()})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      StarRating(
                        rating: review.starRating,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;

  const StarRating({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star,
              color: Colors.orange, size: 16); // Full star
        } else if (index < rating) {
          return const Icon(Icons.star_half,
              color: Colors.orange, size: 16); // Half star
        } else {
          return const Icon(Icons.star_border,
              color: Colors.orange, size: 16); // Empty star
        }
      }),
    );
  }
}

// class StarRating extends StatelessWidget {
//   const StarRating({Key? key, required this.rating}) : super(key: key);
//   final int rating;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: List.generate(5, (index) {
//         return const Icon(
//           Icons.star,
//           color: Colors.orange,
//           size: 16,
//         );
//       }),
//     );
//   }
// }

class ImageRow extends StatelessWidget {
  final List<String> images;

  const ImageRow({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return images.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: images
                  .map((image) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ImageContainer(imagePath: image),
                      ))
                  .toList(),
            ),
          )
        : const SizedBox();
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
          image: NetworkImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../../../utils/responsive.dart';
// import '../../../main.dart';
// import '../../../universal_models/reviews_model.dart';
//
//
// class ReviewGridScreen extends StatelessWidget {
//
//
//   const ReviewGridScreen({Key? key,}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('restaurants')
//           .doc(auth.currentUser!.uid)
//           .collection('reviews')
//           .orderBy('dateTime', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text("No reviews available."));
//         }
//
//         List<ReviewModel> reviews = snapshot.data!.docs
//             .map((doc) => ReviewModel.fromMap(doc.data() as Map<String, dynamic>))
//             .toList();

//         return Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: List.generate(
//                 (reviews.length / 2).ceil(),
//                     (rowIndex) {
//                   int startIndex = rowIndex * 2;
//                   int endIndex = (rowIndex + 1) * 2;
//
//                   return ReviewRow(
//                     reviews: reviews.sublist(startIndex, endIndex > reviews.length ? reviews.length : endIndex),
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class ReviewRow extends StatelessWidget {
//   final List<ReviewModel> reviews;
//
//   const ReviewRow({Key? key, required this.reviews}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: reviews.map((review) => Expanded(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ReviewContainer(review: review),
//         ),
//       )).toList(),
//     );
//   }
// }
//
// class ReviewContainer extends StatelessWidget {
//   final ReviewModel review;
//
//   const ReviewContainer({Key? key, required this.review}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(8),
//       padding: const EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 6,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ReviewHeader(userName: review.userName, starRating: review.starRating),
//           const SizedBox(height: 5),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: Text(
//               review.description,
//               style: const TextStyle(fontSize: 12),
//               maxLines: 3,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           const SizedBox(height: 10),
//           ImageRow(images: review.images),
//         ],
//       ),
//     );
//   }
// }
//
// class ReviewHeader extends StatelessWidget {
//   final String userName;
//   final int starRating;
//
//   const ReviewHeader({Key? key, required this.userName, required this.starRating}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.teal,
//             child: Text(userName.isNotEmpty ? userName[0] : "U", style: const TextStyle(color: Colors.white, fontSize: 14)),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   userName,
//                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//                 StarRating(rating: starRating),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class StarRating extends StatelessWidget {
//   final int rating;
//
//   const StarRating({Key? key, required this.rating}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: List.generate(5, (index) {
//         return Icon(
//           index < rating ? Icons.star : Icons.star_border,
//           color: Colors.orange,
//           size: 16,
//         );
//       }),
//     );
//   }
// }
//
// class ImageRow extends StatelessWidget {
//   final List<String> images;
//
//   const ImageRow({Key? key, required this.images}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return images.isNotEmpty
//         ? Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Row(
//         children: images
//             .map((image) => Padding(
//           padding: const EdgeInsets.only(right: 10),
//           child: ImageContainer(imagePath: image),
//         ))
//             .toList(),
//       ),
//     )
//         : const SizedBox();
//   }
// }
//
// class ImageContainer extends StatelessWidget {
//   final String imagePath;
//
//   const ImageContainer({Key? key, required this.imagePath}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     double containerSize = Responsive.isMobile(context) ? 36 : Responsive.isTablet(context) ? 60 : 72;
//
//     return Container(
//       width: containerSize,
//       height: containerSize,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         image: DecorationImage(
//           image: NetworkImage(imagePath),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
