import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../constants/app_colors.dart';
import '../screens/detail_screens/restaurant_detail_screen.dart';
import '../utils/responsive.dart';

class RectangleWidget extends StatelessWidget {
  final bool? isFromHappy;
  final bool isHappy;
  final String title;
  final String imagePath;
  final String description;
  final String timetext;
  final String? endTimeText;
  final String percentText;
  final RxBool isFavorite;
  final Function(int)? onNavigate;
  const RectangleWidget({
    super.key,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.timetext,
    required this.percentText,
    required this.isFavorite,
    this.onNavigate,
    this.isHappy = false, this.endTimeText, this.isFromHappy});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(RestaurantDetailScreen());
      },
      child: Container(
        height: 173,
        color: Colors.transparent,
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(
                height: 0),
            Container(
              height: 102,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(fit: BoxFit.cover,
                  image: AssetImage(imagePath)
                )
              ),
            ),


            SizedBox(
                height: 8),
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
                Obx(() {
                  return InkWell(
                      onTap: () {
                        print('jksdb');
                        isFavorite.value = !isFavorite.value;
                      },
                      child:
                      isFavorite.value ?Image.asset(
                        'assets/images/heart_icon.png',
                        color: AppColors.primaryColor,
                        height:16,
                        width: 16,
                      ):Icon(Icons.favorite_border_outlined,size: 18,color: AppColors.primaryColor,)

                  );
                }),
                SizedBox(width: 6,)
              ],
            ),
            SizedBox(
                height: 2),
            Text(
              description, // 'Duis aute irure dolor in reprehend voluptate velit esse cillum',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 8,
                fontFamily: 'Nunito-Regular',
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 6,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStarBox( context),
                SizedBox(width: 2,),
                _buildStarBox( context),
                // SizedBox(width: 2,),
                // _buildStarBox( context),
                // SizedBox(width: 2,),
                // _buildStarBox( context),
              ]

              // List.generate(4, (index) {
              //   return Row(
              //     children: [
              //       _buildStarBox( context),
              //       if (index < 1) // Add space only if it's not the last item
              //         SizedBox(width:1), // Adjust width to your desired spacing
              //     ],
              //   );
              // }),
            ),




          ],
        ),

      ),
    );
  }

  Widget _buildStarBox(BuildContext context) {
    return Container(
      height: (isHappy ?? false) ? 55 : 40,
      width: (isHappy ?? false) ? 55 : 40,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/star_img.png'),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0,bottom: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: isHappy ? 2:0,),
            Text(
              "$timetext",
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: 7,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
            ),
            // Show the second and third text widgets only if isHappy is true
            if (isHappy ?? true) ...[

              Text(
                "to",
                style: TextStyle(
                  fontFamily: 'Nunito-Regular',
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
              ),
              Text(
                "$endTimeText",
                style: TextStyle(
                  fontFamily: 'Nunito-Regular',
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
              ),
            ],
            // Last text widget (always visible)
            Text(
              percentText,
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
