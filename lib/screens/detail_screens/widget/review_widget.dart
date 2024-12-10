import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/utils/responsive.dart';
import 'package:kaistable_website/widgets/custom_button.dart';
import 'package:kaistable_website/widgets/uplaod_dialogBox.dart';

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({
    super.key,
    required this.isLargeScreen,
  });

  final bool isLargeScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '(4.0)',
                    style: TextStyle(
                      fontFamily: 'Nunito-Bold',
                      fontSize: Responsive.isMobile(context)
                          ? 20
                          : Responsive.isTablet(context)
                              ? 22
                              : isLargeScreen
                                  ? 54
                                  : 44,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF281717),
                    ),
                  ),
                  SizedBox(
                    height: Responsive.isMobile(context)
                        ? 14
                        : Responsive.isTablet(context)
                            ? 10
                            : isLargeScreen
                                ? 24
                                : 14,
                    child: RatingBar(
                      itemSize: Responsive.isMobile(context)
                          ? 14
                          : Responsive.isTablet(context)
                              ? 10
                              : isLargeScreen
                                  ? 24
                                  : 14,
                      ignoreGestures: true,
                      initialRating: 4,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ratingWidget: RatingWidget(
                        full: Image.asset(
                          'assets/images/star yellow.png',
                          height: 14,
                        ),
                        half: Image.asset(
                          'assets/images/star yellow.png',
                          height: 14,
                        ),
                        empty: Image.asset(
                          'assets/images/star_empty.png',
                          height: 14,
                          color: const Color(0xFFBBBBBB),
                        ),
                      ),
                      itemPadding: const EdgeInsets.only(left: 2.0),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        RatingBar(
                          itemSize: Responsive.isMobile(context)
                              ? 12
                              : Responsive.isTablet(context)
                                  ? 16
                                  : isLargeScreen
                                      ? 38
                                      : 28,
                          ignoreGestures: false,
                          initialRating: 5 - index.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                            full: Image.asset(
                              'assets/images/star yellow.png',
                              height: Responsive.isMobile(context) ? 32 : 56,
                              width: Responsive.isMobile(context) ? 32 : 56,
                            ),
                            half: Image.asset(
                              'assets/images/star yellow.png',
                              height: Responsive.isMobile(context) ? 32 : 56,
                              width: Responsive.isMobile(context) ? 32 : 56,
                            ),
                            empty: Image.asset(
                              'assets/images/star_empty.png',
                              color: const Color(0xFFBBBBBB),
                              height: Responsive.isMobile(context) ? 32 : 56,
                              width: Responsive.isMobile(context) ? 32 : 56,
                            ),
                          ),
                          itemPadding: const EdgeInsets.only(left: 2.0),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        SizedBox(
                          width: Responsive.isMobile(context)
                              ? 80
                              : Responsive.isTablet(context)
                                  ? 90
                                  : 232,
                          child: const Divider(
                              thickness: 2, color: Color(0xFFBBBBBB)),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          '(${5 - index})',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Nunito-Regular',
                              fontSize: Responsive.isMobile(context)
                                  ? 12
                                  : Responsive.isTablet(context)
                                      ? 10
                                      : isLargeScreen
                                          ? 18
                                          : 14,
                              color: AppColors.bottomSheetColor),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 14,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 0.0, left: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              RatingRowWidget(
                isImage: false,
                imagePaths: [],
              ),
              SizedBox(
                height: 14,
              ),
              RatingRowWidget(
                isImage: true,
                imagePaths: [
                  "assets/images/img1.png",
                  "assets/images/img1.png",
                  "assets/images/img1.png",
                  "assets/images/img1.png",
                  "assets/images/img1.png",
                  "assets/images/img1.png",
                ],
              ),
              SizedBox(
                height: 14,
              ),
              RatingRowWidget(
                isImage: false,
                imagePaths: [],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomButton(
            ontapp: () {
              Get.bottomSheet(
                UploadImageSection(),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20)),
                ),
              );
            },
            laBelText: 'Write a review',
            height: 48,
            width: 200,
            textColor: AppColors.whiteColor,
            fontSize: 20,
            fontFamily: 'Nunito-Regular',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
//class RatingRowWidget extends StatelessWidget {
//   final bool isImage;
//   final List<String> imagePaths;
//
//   const RatingRowWidget({super.key, required this.isImage, required this.imagePaths});
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     bool isLargeScreen = screenWidth > 1400;
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               'Deanna Blanda',
//               style: TextStyle(
//                 fontSize: Responsive.isMobile(context) ? 14 : isLargeScreen ? 18 : 14,
//                 fontWeight: FontWeight.w700,
//                 fontFamily: 'Nunito-Regular',
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//         RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: '(4.0) ', // Rating text
//                 style: TextStyle(
//                   color: const Color(0xFF4F5761),
//                   fontSize: Responsive.isMobile(context) ? 14 : isLargeScreen ? 18 : 14,
//                   fontFamily: 'Nunito-Regular',
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               WidgetSpan(
//                 child: SizedBox(
//                   height: Responsive.isMobile(context) ? 14 : isLargeScreen ? 18 : 14,
//                   child: RatingBar(
//                     itemSize: 12,
//                     ignoreGestures: true,
//                     initialRating: 4,
//                     minRating: 1,
//                     direction: Axis.horizontal,
//                     allowHalfRating: true,
//                     itemCount: 5,
//                     ratingWidget: RatingWidget(
//                       full: Image.asset('assets/images/star yellow.png', height: 14),
//                       half: Image.asset('assets/images/star yellow.png', height: 14),
//                       empty: Image.asset('assets/images/star_empty.png', height: 14),
//                     ),
//                     itemPadding: const EdgeInsets.only(left: 2.0),
//                     onRatingUpdate: (rating) {
//                       print(rating);
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           width: Responsive.isMobile(context) ? Get.width : isLargeScreen ? 700 : 600,
//           height: Responsive.isMobile(context) ? 34 : isLargeScreen ? 50 : 40,
//           child: Text(
//             'Voluptatem atque molestiae numquam voluptatem bxca veritatis nesciunt comm odi.',
//             style: TextStyle(
//               fontFamily: 'Nunito-Regular',
//               fontSize: Responsive.isMobile(context) ? 12 : isLargeScreen ? 18 : 14,
//               fontWeight: FontWeight.w400,
//               color: AppColors.botomSheetColor,
//             ),
//           ),
//         ),
//         Column(
//           children: [
//             const SizedBox(height: 3),
//             if (isImage) // Display images only if isImage is true
//               SizedBox(
//                 height: Responsive.isMobile(context) ? 50 : isLargeScreen ? 100 : 80,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: imagePaths.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       margin: EdgeInsets.only(right: 8.0), // Space between images
//                       height: Responsive.isMobile(context) ? 50 : isLargeScreen ? 100 : 80,
//                       width: Responsive.isMobile(context) ? 100 : isLargeScreen ? 200 : 120,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(Responsive.isMobile(context) ? 4 : 8),
//                         image: DecorationImage(
//                           image: AssetImage(imagePaths[index]),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             const SizedBox(height: 5),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'June 30, 2024',
//                 style: TextStyle(
//                   color: AppColors.botomSheetColor,
//                   fontFamily: 'Nunito-Regular',
//                   fontWeight: FontWeight.w400,
//                   fontSize: Responsive.isMobile(context) ? 12 : isLargeScreen ? 18 : 14,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
