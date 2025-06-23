import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
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
    return Container(
      width: width ?? 200,
      height: height ?? 290,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Stack(
        children: [
          /// Main Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imagePath,
              height: height ?? 290,
              width: double.infinity,
              fit: BoxFit.cover,
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

          /// Blur Gradient Info at Bottom
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
                  // height: 80,
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
                      /// Restaurant Name
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.whiteColor,
                          fontFamily: 'Nunito-regular',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      /// Location Text
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              description,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.whiteColor,
                                fontFamily: 'Nunito-regular',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                       SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
