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
  });


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
                      fontSize:  20,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF281717),
                    ),
                  ),
                  SizedBox(
                    height:  14,
                    child: RatingBar(
                      itemSize: 14,
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
                          itemSize: 12,
                          ignoreGestures: false,
                          initialRating: 5 - index.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                            full: Image.asset(
                              'assets/images/star yellow.png',
                              height: 32 ,
                              width:  32,
                            ),
                            half: Image.asset(
                              'assets/images/star yellow.png',
                              height:  32,
                              width:  32,
                            ),
                            empty: Image.asset(
                              'assets/images/star_empty.png',
                              color: const Color(0xFFBBBBBB),
                              height: 32 ,
                              width: 32 ,
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
                          width: 80,
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
                              fontSize:12,
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
