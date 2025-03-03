import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/models/review_model.dart';
import 'package:kaistable_website/screens/auth_screens/signup/signup_screen.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_controller/onboarding_controller.dart';
import 'package:kaistable_website/utils/responsive.dart';
import 'package:kaistable_website/widgets/custom_button.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import 'package:kaistable_website/widgets/uplaod_dialogBox.dart';

class ReviewWidget extends StatelessWidget {
  ReviewWidget({
    super.key,
    this.restaurantModel,
  });
  RestaurantModel? restaurantModel;
  final controller = Get.find<HomeLocationController>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ReviewModel>>(
      stream: restaurantModel?.docID == ''
          ? null
          : controller.getReviews(restaurantModel?.docID ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
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
                            '(0)',
                            style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF281717),
                            ),
                          ),
                          SizedBox(
                            height: 14,
                            child: RatingBar(
                              itemSize: 14,
                              ignoreGestures: true,
                              initialRating: 0,
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
                          final starCount = 0;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                RatingBar(
                                  itemSize: 12,
                                  ignoreGestures: true,
                                  initialRating: 5 - index.toDouble(),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  ratingWidget: RatingWidget(
                                    full: Image.asset(
                                      'assets/images/star yellow.png',
                                      height: 32,
                                      width: 32,
                                    ),
                                    half: Image.asset(
                                      'assets/images/star yellow.png',
                                      height: 32,
                                      width: 32,
                                    ),
                                    empty: Image.asset(
                                      'assets/images/star_empty.png',
                                      color: const Color(0xFFBBBBBB),
                                      height: 32,
                                      width: 32,
                                    ),
                                  ),
                                  itemPadding: const EdgeInsets.only(left: 2.0),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                const SizedBox(width: 4),
                                SizedBox(
                                  width: 80,
                                  child: const Divider(
                                    thickness: 2,
                                    color: Color(0xFFBBBBBB),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '($starCount)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Nunito-Regular',
                                    fontSize: 12,
                                    color: AppColors.bottomSheetColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomButton(
                    ontapp: () {
                      if (auth.currentUser != null) {
                        Get.bottomSheet(
                          UploadImageSection(
                            restaurantId: restaurantModel?.docID ?? '',
                          ),
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                        );
                      } else {
                        showSignupDialog();
                      }
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
            ),
          );
        }

        final reviews = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
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
                          '(${(reviews.map((e) => e.starRating).reduce((a, b) => a! + b!)! / reviews.length).toStringAsFixed(1)})',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF281717),
                          ),
                        ),
                        SizedBox(
                          height: 14,
                          child: RatingBar(
                            itemSize: 14,
                            ignoreGestures: true,
                            initialRating: reviews
                                    .map((e) => e.starRating ?? 0)
                                    .reduce((a, b) => a + b) /
                                reviews.length,
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
                        final starCount = reviews
                            .where((review) => review.starRating == 5 - index)
                            .length;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              RatingBar(
                                itemSize: 12,
                                ignoreGestures: true,
                                initialRating: 5 - index.toDouble(),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: Image.asset(
                                    'assets/images/star yellow.png',
                                    height: 32,
                                    width: 32,
                                  ),
                                  half: Image.asset(
                                    'assets/images/star yellow.png',
                                    height: 32,
                                    width: 32,
                                  ),
                                  empty: Image.asset(
                                    'assets/images/star_empty.png',
                                    color: const Color(0xFFBBBBBB),
                                    height: 32,
                                    width: 32,
                                  ),
                                ),
                                itemPadding: const EdgeInsets.only(left: 2.0),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 80,
                                child: const Divider(
                                  thickness: 2,
                                  color: Color(0xFFBBBBBB),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '($starCount)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Nunito-Regular',
                                  fontSize: 12,
                                  color: AppColors.bottomSheetColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              SizedBox(height: 14),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return RatingRowWidget(
                    isImage: review.images != null && review.images!.isNotEmpty,
                    imagePaths: review.images ?? [],
                    user_name: review.userName ?? '',
                    description: review.description ?? '',
                    rating: review.starRating ?? 0.0,
                    date: formatDate(review.createdAt ?? DateTime.now()),
                  );
                },
              ),
              SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(
                  ontapp: () {
                    if (auth.currentUser != null) {
                      Get.bottomSheet(
                        UploadImageSection(
                          restaurantId: restaurantModel?.docID ?? '',
                        ),
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                      );
                    } else {
                      showSignupDialog();
                    }
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
          ),
        );
      },
    );
  }

  void showSignupDialog() {
    Get.defaultDialog(
      title: "Signup/Login Required",
      titleStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
        fontFamily: 'Nunito-Bold',
      ),
      middleText: "Please sign up to continue with this operation.",
      middleTextStyle: TextStyle(
        fontSize: 14,
        color: AppColors.textColor,
        fontFamily: 'Nunito-Regular',
      ),
      backgroundColor: Colors.white,
      radius: 12,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                ontapp: () {
                  Get.back();
                },
                laBelText: 'Cancel',
                height: 40,
                width: Get.width * 0.3,
                textColor: AppColors.whiteColor,
                fontSize: 15,
                fontFamily: 'Nunito-SemiBold',
                fontWeight: FontWeight.w600,
              ),
              CustomButton(
                ontapp: () {
                  Get.back(); // Close the dialog
                  Get.to(SignupScreen(), transition: Transition.rightToLeft);
                },
                laBelText: 'Sign Up',
                height: 40,
                width: Get.width * 0.3,
                textColor: AppColors.whiteColor,
                fontSize: 15,
                fontFamily: 'Nunito-SemiBold',
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
