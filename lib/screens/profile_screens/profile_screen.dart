// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:kaistable_website/constants/app_colors.dart';
// import 'package:kaistable_website/screens/terms_and_condition/terms_and_condition.dart';
//
// import '../home_screen/my_home_screen.dart';
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: ()async{
//         Get.offAll(MyHomeScreen());
//         return false;
//
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.bgColor,
//         appBar: AppBar(
//           backgroundColor: AppColors.bgColor,
//           title: const Text('Profile',
//             style: TextStyle(
//               fontSize: 20,
//               color: AppColors.botomSheetColor,
//               fontWeight: FontWeight.w700,
//               fontFamily: 'Nunito-Bold',
//             ),),
//           centerTitle: true,
//           leading: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Container(
//               height: 16,
//               width: 16,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 3,
//                     offset: const Offset(0, 1),
//                   ),
//                 ],
//               ),
//               child: GestureDetector(
//                 onTap: () {
//                   Get.offAll(MyHomeScreen()); // Navigate back to the home screen
//                 },
//                 child: Icon(Icons.arrow_back, size: 18,color: AppColors.primaryColor,),
//               ),
//             ),
//           ),
//         ),
//         body: Column(
//
//           children: [
//             SizedBox(height: 20,),
//             Container(
//               height: 30,
//               width: Get.width,
//               color: AppColors.whiteColor,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 32.0,top: 4),
//                 child: Text(
//                   'Account & Privacy',
//                   style: TextStyle(
//                     color: AppColors.botomSheetColor,
//                     fontFamily: 'Nunito-Bold',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20,),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Image.asset("assets/images/terms_condition-icon.png",height: 24,width: 24,),
//                       SizedBox(width: 16,),
//                       Text("Terms and conditions",
//                       style: TextStyle(
//                         fontFamily: "Nunito-Regular",
//                         fontWeight: FontWeight.w400,
//                         fontSize: 16,
//                         color: AppColors.textColor
//                       ),
//                       ),
//                       Spacer(),
//                       Image.asset("assets/images/arrow_forward.png",height: 24,width: 24,)
//
//                     ],
//                   ),
//                   Divider(thickness: 1,color: Color(0xFF98A2B34D).withOpacity(.2),),
//                   SizedBox(height: 12,),
//                   Row(
//                     children: [
//                       Image.asset("assets/images/privacy_img.png",height: 24,width: 24,),
//                       SizedBox(width: 16,),
//                       Text("Privacy policy",
//                         style: TextStyle(
//                             fontFamily: "Nunito-Regular",
//                             fontWeight: FontWeight.w400,
//                             fontSize: 16,
//                             color: AppColors.textColor
//                         ),
//                       ),
//                       Spacer(),
//                       GestureDetector(
//                         onTap: (){
//                           Get.to(TermsAndCondition());
//                         },
//
//                           child: Image.asset("assets/images/arrow_forward.png",height: 24,width: 24,))
//
//                     ],
//                   ),
//                   Divider(thickness: 1,color: const Color(0xFF98A2B34D).withOpacity(.2),),
//                   const SizedBox(height: 12,),
//                   Row(
//                     children: [
//                       Image.asset("assets/images/about_img.png",height: 24,width: 24,),
//                       const SizedBox(width: 16,),
//                       const Text("About app",
//                         style: TextStyle(
//                             fontFamily: "Nunito-Regular",
//                             fontWeight: FontWeight.w400,
//                             fontSize: 16,
//                             color: AppColors.textColor
//                         ),
//                       ),
//                       const Spacer(),
//                       Image.asset("assets/images/arrow_forward.png",height: 24,width: 24,)
//
//                     ],
//                   ),
//                   Divider(thickness: 1,color: const Color(0xFF98A2B34D).withOpacity(.2),),
//                   const SizedBox(height: 12,),
//                   Row(
//                     children: [
//                       Image.asset("assets/images/contact_us_img.png",height: 24,width: 24,),
//                       SizedBox(width: 16,),
//                       Text("Contact us",
//                         style: TextStyle(
//                             fontFamily: "Nunito-Regular",
//                             fontWeight: FontWeight.w400,
//                             fontSize: 16,
//                             color: AppColors.textColor
//                         ),
//                       ),
//                       Spacer(),
//                       Image.asset("assets/images/arrow_forward.png",height: 24,width: 24,)
//
//                     ],
//                   ),
//                   Divider(thickness: 1,color: Color(0xFF98A2B34D).withOpacity(.2),),
//                   SizedBox(height: 12,),
//                 ],
//               ),
//             )
//
//           ],
//         ),
//       ),
//     );
//   }
// }
