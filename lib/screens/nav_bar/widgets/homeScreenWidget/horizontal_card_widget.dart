import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';

// class HorizontalCardWidget extends StatelessWidget {
//   final String title;
//   final String imagePath;
//   final String description;
//   final RxBool isFavorite;
//   final VoidCallback onTap;

//   const HorizontalCardWidget({
//     required this.title,
//     required this.imagePath,
//     required this.description,
//     required this.isFavorite,
//     required this.onTap,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 200,
//         height: 215,
//        // margin: const EdgeInsets.only(right: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 2,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Image with favorite icon
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   child: Image.network(
//                     imagePath,
//                     height: 135,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10,),
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0,right: 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w800,
//                         color: AppColors.bottomSheetColor,
//                         fontFamily: 'Nunito-regular',
//                       ),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                     ),
//                   ),
//                   Obx(() => GestureDetector(
//                         onTap: () {
//                           isFavorite.value = !isFavorite.value;
//                         },
//                         child: Icon(
//                           isFavorite.value
//                               ? Icons.favorite
//                               : Icons.favorite_border,
//                           size: 18,
//                           color: AppColors.primaryColor,
//                         ),
//                       )),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0,right: 8.0),
//               child: Row(
//                 children: [
//                   const Icon(
//                     Icons.location_on,
//                     size: 14,
//                     color: Colors.grey,
//                   ),
//                   const SizedBox(width: 4),
//                   Expanded(
//                     child: Text(
//                       description,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w800,
//                         color: AppColors.tableHeadingColor,
//                         fontFamily: 'Nunito-regular',
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class HorizontalCardWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final RxBool isFavorite;
  final VoidCallback onTap;
  final double imageHeight;
  final double containerHeight;

  const HorizontalCardWidget({
    required this.title,
    required this.imagePath,
    required this.description,
    required this.isFavorite,
    required this.onTap,
    required this.imageHeight,
    required this.containerHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: containerHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with full width rounded corners
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                imagePath,
                height: imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant name with favorite icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.bottomSheetColor,
                            fontFamily: 'NunitoSans-Regular',
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Obx(() => GestureDetector(
                            onTap: () => isFavorite.toggle(),
                            child: Icon(
                              isFavorite.value
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: AppColors.blackColor,
                              size: 18,
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Location information
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.bottomSheetColor,
                            fontFamily: 'NunitoSans-Regular',
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
