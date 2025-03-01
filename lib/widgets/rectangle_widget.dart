import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';

import '../constants/app_colors.dart';

class RectangleWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final String timetext;
  final String? endTimeText;
  final String percentText;
  final RxBool isFavorite;
  List<OfferModel>? percentageOff;
  List<OfferModel>? happyhour;

  String? resturant_id;
  final Function(int)? onNavigate;

  RectangleWidget({
    super.key,
    required this.title,
    this.percentageOff,
    this.happyhour,
    this.resturant_id,
    required this.imagePath,
    required this.description,
    required this.timetext,
    required this.percentText,
    required this.isFavorite,
    this.onNavigate,
    this.endTimeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 172,
            height: 124,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: imagePath.contains('http')
                        ? NetworkImage(
                            imagePath,
                          )
                        : AssetImage(imagePath))),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                    Spacer(),
                    HomeLocationController()
                        .favoriteHeart(resturant_id: resturant_id),
                    SizedBox(
                      width: 6,
                    )
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    SizedBox(
                      width: Get.width * 0.4,
                      child: Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 8,
                          fontFamily: 'Nunito-Regular',
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 6,
          ),
          percentageOff?.isNotEmpty ?? false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dynamically build StarBoxes based on the percentageOff list
                    ...percentageOff!.take(2).map((item) => Padding(
                          padding: const EdgeInsets.only(
                              right: 2.0), // Add spacing between items
                          child: _buildStarBox(context,
                              item:
                                  item), // Pass item to _buildStarBox if needed
                        )),
                  ],
                )
              : happyhour?.isNotEmpty ?? false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dynamically build StarBoxes based on the percentageOff list
                        ...happyhour!.take(2).map((item) => Padding(
                              padding: const EdgeInsets.only(
                                  right: 2.0), // Add spacing between items
                              child: _buildStarBox(context,
                                  item:
                                      item), // Pass item to _buildStarBox if needed
                            )),
                      ],
                    )
                  : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildStarBox(BuildContext context, {required OfferModel item}) {
    return Container(
      height: Get.height * 0.065,
      width: Get.height * 0.065,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/star_img.png'),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${item.startTime} to',
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: 7,
                fontWeight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),
            Text(
              "${item.endTime}",
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: 7,
                fontWeight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),
            Text(
              '${item.percentage} off',
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: 7,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
