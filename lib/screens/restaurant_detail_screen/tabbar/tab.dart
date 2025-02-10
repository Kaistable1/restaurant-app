// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../constants/colors.dart';
// import '../../../../utils/responsive.dart';
// import '../controller/restaurant_detail_controller.dart';
// import '../widget/custom_tabbar.dart';
// import '../widget/star_widget_gen_discount.dart';
//
// class MyScreen extends StatelessWidget {
//   MyScreen({Key? key}) : super(key: key);
//   final controller = Get.put(RestaurantDetailController());
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     bool isLargeScreen = screenWidth > 1400;
//     return CustomTabBarWidget(
//       tabs: [
//         "General Discount",
//         "Happy Hour",
//         "Dinner Discount",
//       ],
//       tabViews: [
//         Stack(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(
//                   left: Responsive.isMobile(context) ? 20 : 45,
//                   right: Responsive.isMobile(context) ? 2 : 30),
//               child: SizedBox(
//                 height: Responsive.isMobile(context)
//                     ? 140
//                     : isLargeScreen
//                         ? 200
//                         : 140,
//                 child: ListView.builder(
//                   controller: controller.scrollController,
//                   scrollDirection: Axis.horizontal,
//                   itemCount: controller.circleItems.length, // Number of items
//                   itemBuilder: (context, index) {
//                     final item = controller
//                         .circleItems[index]; // Get item from model list
//                     return Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: Responsive.isMobile(context)
//                               ? 10
//                               : isLargeScreen
//                                   ? 48
//                                   : 18.0,
//                           vertical: Responsive.isMobile(context) ? 6 : 6),
//                       child: LocationStarWidget(
//                         //
//                         // isLocation: true,
//                         //
//                         timeText: item.timeText,
//                         persentText: item.persentText,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             // Left Arrow button with padding for spacing
//             Positioned(
//               left: 0, // Adjust the value to add space from the list
//               top: 0,
//               bottom: 0,
//               child: InkWell(
//                 onTap: () => controller.scrollLeft(),
//                 child: Image.asset(
//                   'assets/images/arrow_back.png',
//                   height: Responsive.isMobile(context) ? 32 : 52,
//                   width: Responsive.isMobile(context) ? 32 : 52,
//                 ),
//               ),
//             ),
//             // Right Arrow button with padding for spacing
//             Positioned(
//               right: 0, // Adjust the value to add space from the list
//               top: 0,
//               bottom: 0,
//               child: InkWell(
//                 onTap: () => controller.scrollRight(),
//                 child: Image.asset(
//                   'assets/images/arrow_forward.png',
//                   height: Responsive.isMobile(context) ? 32 : 52,
//                   width: Responsive.isMobile(context) ? 32 : 52,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Center(
//           child: Text(
//             'Happy Hour Content',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//           ),
//         ),
//         Center(
//           child: Text(
//             'Dinner Discount Content',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//           ),
//         ),
//       ],
//       activeColor: AppColors.primaryColor,
//       inactiveColor: AppColors.darkGrey.withOpacity(.5),
//       backgroundColor: AppColors.whiteColor,
//     );
//   }
// }
