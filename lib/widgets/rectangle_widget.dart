import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';

import '../constants/app_colors.dart';
import '../screens/detail_screens/restaurant_detail_screen.dart';
import '../utils/responsive.dart';

class RectangleWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final String timetext;
  final String? endTimeText;
  final String percentText;
  final RxBool isFavorite;
  List<PersentageModel>? percentageOff;
  String? resturant_id;
  final Function(int)? onNavigate;

  RectangleWidget({
    super.key,
    required this.title,
    this.percentageOff,
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
      height: 173,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 102,
            width: Get.width * 0.6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: imagePath.contains('http')
                        ? NetworkImage(imagePath)
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
                    Text(
                      title, // 'Buffet',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontFamily: 'Nunito-Regular',
                        color: AppColors.textColor,
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
                Text(
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
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildStarBox(BuildContext context, {required PersentageModel item}) {
    return Container(
      height: 55,
      width: 55,
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
