import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import 'package:mailer/mailer.dart';
import '../constants/app_colors.dart';

// class RectangleWidget extends StatelessWidget {
//   final String title;
//   final String imagePath;
//   final String description;
//   final String timetext;
//   final String? endTimeText;
//   final String percentText;
//   final RxBool isFavorite;
//   // List<OfferModel>? percentageOff;
//   // List<OfferModel>? happyhour;
//   final double? width;
//   final double? height;
//   final double? imgHeight;
//   final Color? boxColor;

//   String? resturant_id;
//   final Function(int)? onNavigate;

//   RectangleWidget({
//     super.key,
//     required this.title,
//     // this.percentageOff,
//     // this.happyhour,
//     this.resturant_id,
//     required this.imagePath,
//     required this.description,
//     required this.timetext,
//     required this.percentText,
//     required this.isFavorite,
//     this.onNavigate,
//     this.endTimeText,
//     this.width,
//     this.height,
//     this.imgHeight,
//     this.boxColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width ?? Get.width,
//       height: height ?? 234,
//       decoration: BoxDecoration(
//         color: boxColor ?? Colors.transparent,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//               height: imgHeight ?? 82,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.transparent,
//                   image: DecorationImage(
//                       fit: BoxFit.cover,
//                       image: NetworkImage(
//                         imagePath,
//                       )))),
//           SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5),
//             child: Column(
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: 100,
//                       child: Text(
//                         title,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 14,
//                           fontFamily: 'Nunito-Regular',
//                           color: AppColors.textColor,
//                         ),
//                       ),
//                     ),
//                     Spacer(),
//                     auth.currentUser == null || resturant_id == ''
//                         ? SizedBox()
//                         : HomeLocationController()
//                             .favoriteHeart(resturant_id: resturant_id),
//                     SizedBox(
//                       width: 6,
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 2),
//                 Row(
//                   children: [
//                     Image.asset(
//                       'assets/images/location_icon2.png',
//                       height: 16,
//                       width: 16,
//                     ),
//                     SizedBox(
//                       child: Text(
//                         description,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 12,
//                           fontFamily: 'Nunito-Regular',
//                           color: AppColors.textColor,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 6,
//           ),
//         ],
//       ),
//     );
//   }

// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RectangleWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final String timetext;
  final String? endTimeText;
  final String percentText;
  final RxBool isFavorite;
  final double? width;
  final double? height;
  final double? imgHeight;
  final Color? boxColor;
  String? resturant_id;
  final Function(int)? onNavigate;

  RectangleWidget({
    super.key,
    required this.title,
    this.resturant_id,
    required this.imagePath,
    required this.description,
    required this.timetext,
    required this.percentText,
    required this.isFavorite,
    this.onNavigate,
    this.endTimeText,
    this.width,
    this.height,
    this.imgHeight,
    this.boxColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imagePath,
            height: 290,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.primaryColor.withOpacity(0.5),
                      AppColors.primaryColor.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'NunitoSans-Bold',
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'NunitoSans-Regular',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        /// Heart Icon at Top Right
        Positioned(
          top: 8,
          right: 8,
          child: Obx(() => GestureDetector(
                onTap: () {
                  isFavorite.value = !isFavorite.value;
                },
                child: Icon(
                  isFavorite.value ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.whiteColor,
                  size: 18,
                ),
              )),
        ),
      ],
    );
  }
}
