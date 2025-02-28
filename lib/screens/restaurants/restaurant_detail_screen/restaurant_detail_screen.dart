// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
// import 'package:savrly_data_entry_app/constants/app_colors.dart';
// import 'package:savrly_data_entry_app/widgets/custom_button.dart';
//
// import '../../../constants/text_styles.dart';
// import '../../service/GoogleResponse.dart';
// import '../../service/api_model.dart';
// import '../restaurant_list_screen.dart';
// import 'controller/restaurant_detail_controller.dart';
//
// class RestaurantScreen extends StatelessWidget {
//   final RestaurantDetailController controller =
//   Get.put(RestaurantDetailController());
//
//   @override
//   Widget build(BuildContext context) {
//     final dynamic argument = Get.arguments;
//     YelpBusiness? yelpRestaurant;
//     BusinessModel? googleRestaurant;
//
//     if (argument is YelpBusiness) {
//       yelpRestaurant = argument;
//     } else if (argument is BusinessModel) {
//       googleRestaurant = argument;
//     }
//
//     return Scaffold(
//       backgroundColor: white,
//       appBar: AppBar(
//         backgroundColor: white,
//         title: Text(
//           yelpRestaurant?.name ?? googleRestaurant?.results. ?? "Restaurant",
//           textAlign: TextAlign.center,
//           style: headingText,
//         ),
//         centerTitle: true,
//         leading: GestureDetector(
//           onTap: () {
//             PersistentNavBarNavigator.pushNewScreen(
//               context,
//               screen: RestaurantListScreen(),
//               withNavBar: true,
//               pageTransitionAnimation: PageTransitionAnimation.cupertino,
//             );
//           },
//           child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Icon(
//                 Icons.arrow_back_outlined,
//                 size: 30,
//               )),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Restaurant Image & Name
//             Card(
//               color: white,
//               elevation: 6,
//               shadowColor: bdrColor,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: Column(
//                 children: [
//                   SizedBox(height: 10),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.network(
//                       yelpRestaurant?.imageUrl ?? googleRestaurant?.icon ?? "",
//                       width: Get.width * .85,
//                       errorBuilder: (context, error, stackTrace) => Icon(Icons.image),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           yelpRestaurant?.name ?? googleRestaurant?.name ?? "N/A",
//                           style: headingText,
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.star, color: Colors.amber, size: 18),
//                             Text(
//                               "${yelpRestaurant?.rating ?? googleRestaurant?.rating ?? 0} (${yelpRestaurant?.reviewCount ?? googleRestaurant?.userRatingsTotal ?? 0} reviews)",
//                               style: simpleText,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: 12),
//
//             // Address Section
//             _buildCard(
//               title: "Address",
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     yelpRestaurant?.displayAddress.join(", ") ?? googleRestaurant?.formattedAddress ?? "No Address",
//                     style: simpleText,
//                   ),
//                   SizedBox(height: 8),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.asset("assets/images/map.png",
//                         width: Get.width * .85, fit: BoxFit.cover),
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: 12),
//
//             // Contact Information
//             _buildCard(
//               title: "Contact Information",
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Phone: ${yelpRestaurant?.phone ?? 'N/A'}",
//                     style: simpleText,
//                   ),
//                   SizedBox(height: 12),
//                   CustomButton(btnText: 'Call now', onTap: () {}),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper function for reusable card sections
//   Widget _buildCard({required String title, required Widget child}) {
//     return Card(
//       color: white,
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: headingText),
//             SizedBox(height: 8),
//             child,
//           ],
//         ),
//       ),
//     );
//   }
// }
//
