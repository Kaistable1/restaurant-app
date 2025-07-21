// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kaistable_website/constants/app_colors.dart';

// import '../utils/responsive.dart';

// class CircleContainerWidget extends StatelessWidget {
//   final String imgPath;
//   final String titleText;
//   final String descriptionText;
//   final bool isLocation;
//   final RxBool isFavourite;
//   final double? width;
//   final double? height;
//   final VoidCallback? ontap;

//   const CircleContainerWidget({
//     super.key,
//     required this.imgPath,
//     required this.titleText,
//     required this.descriptionText,
//     this.isLocation = false,
//     this.ontap,
//     required this.isFavourite,
//     this.width,
//     this.height, // Default value remains false
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: ontap,
//       child: Container(
//         width: Get.width,
//         decoration: BoxDecoration(
//             color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: double.infinity,
//               height: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 image: DecorationImage(
//                   fit: BoxFit.fill,
//                   image: AssetImage(imgPath),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 5),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   if (isLocation)
//                     Icon(
//                       Icons.location_on,
//                       color: AppColors.primaryColor,
//                       size: 14,
//                     ),
//                   const SizedBox(width: 4),
//                   Text(
//                     titleText, // 'Super mega sale'
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 14,
//                       fontFamily: 'Nunito-Bold',
//                       color: AppColors.bottomSheetColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Row(
//                 children: [
//                   Text(
//                     descriptionText,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 13,
//                       fontFamily: 'Nunito-Regular',
//                       color: AppColors.textColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 12,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';

class CircleContainerWidget extends StatelessWidget {
  final String imgPath;
  final String titleText;
  final String descriptionText;
  final bool isLocation;

  final double? width;
  final double? height;
  final VoidCallback? ontap;

  const CircleContainerWidget({
    super.key,
    required this.imgPath,
    required this.titleText,
    required this.descriptionText,
    this.isLocation = false,
    this.ontap,
  
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Stack(
        children: [
          /// Main Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imgPath,
              width: double.infinity,
              height: height ?? 250,
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.primaryColor.withOpacity(0.6),
                        AppColors.primaryColor.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title
                      Text(
                        titleText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Nunito-Bold',
                        ),
                      ),
                      const SizedBox(height: 4),

                      /// Location
                      Row(
                        children: [
                          if (isLocation)
                            const Icon(Icons.location_on,
                                color: Colors.white, size: 14),
                          if (isLocation) const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              descriptionText,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontFamily: 'Nunito-Regular',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
