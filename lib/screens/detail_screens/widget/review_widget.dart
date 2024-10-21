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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    '(4.0)',
                    style: TextStyle(
                      fontFamily: 'Nunito-Regular',
                      fontSize: Responsive.isMobile(
                          context)
                          ? 12
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
                        ? 7
                        : Responsive.isTablet(context)
                        ? 10
                        : isLargeScreen
                        ? 24
                        : 14,
                    child: RatingBar(
                      itemSize: Responsive.isMobile(
                          context)
                          ? 7
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
                        ),
                      ),
                      itemPadding: const EdgeInsets.only(
                          left: 2.0),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: Responsive.isMobile(context)
                    ? 14
                    : 32,
              ),
              Column(
                children: List.generate(5, (index) {
                  return Row(
                    children: [
                      RatingBar(
                        itemSize: Responsive.isMobile(
                            context)
                            ? 10
                            : Responsive.isTablet(context)
                            ? 16
                            : isLargeScreen
                            ? 38
                            : 28,
                        ignoreGestures: false,
                        initialRating: 4,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: Image.asset(
                            'assets/images/star yellow.png',
                            height: Responsive.isMobile(
                                context)
                                ? 32
                                : 56,
                            width: Responsive.isMobile(
                                context)
                                ? 32
                                : 56,
                          ),
                          half: Image.asset(
                            'assets/images/star yellow.png',
                            height: Responsive.isMobile(
                                context)
                                ? 32
                                : 56,
                            width: Responsive.isMobile(
                                context)
                                ? 32
                                : 56,
                          ),
                          empty: Image.asset(
                            'assets/images/star_empty.png',
                            color:
                            const Color(0xFFBBBBBB),
                            height: Responsive.isMobile(
                                context)
                                ? 32
                                : 56,
                            width: Responsive.isMobile(
                                context)
                                ? 32
                                : 56,
                          ),
                        ),
                        itemPadding:
                        const EdgeInsets.only(
                            left: 2.0),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      SizedBox(
                        width: Responsive.isMobile(
                            context)
                            ? 60
                            : Responsive.isTablet(context)
                            ? 90
                            : 232,
                        child: const Divider(
                            thickness: 2,
                            color: Color(0xFFBBBBBB)),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        '(0)',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: Responsive.isMobile(
                                context)
                                ? 7
                                : Responsive.isTablet(
                                context)
                                ? 10
                                : isLargeScreen
                                ? 18
                                : 14,
                            color: AppColors
                                .botomSheetColor),
                      ),
                    ],
                  );
                }),
              )
            ],
          ),
        ),
        const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: RatingRowWidget(
                isImage: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: RatingRowWidget(
                isImage: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: RatingRowWidget(
                isImage: false,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomButton(
            ontapp: () {
              Get.dialog(Dialog(
                  child: UploadImageSection()));
            },
            laBelText: 'Write a review',
            height: Responsive.isMobile(context)
                ? 28
                : isLargeScreen
                ? 58
                : 48,
            width: Responsive.isMobile(context)
                ? 130
                : isLargeScreen
                ? 300
                : 265,
            textColor: AppColors.whiteColor,
            fontSize: Responsive.isMobile(context)
                ? 12
                : isLargeScreen
                ? 24
                : 20,
            fontFamily: 'Nunito-Regular',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}