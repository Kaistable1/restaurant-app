import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/fav_rectangle_widget.dart';
import '../home_controller/home_recently_viewed_controller.dart';
class RecentlyViewed extends StatelessWidget {
  final Function(int)? onNavigate;
  final HomeRecentlyViewedController recentlyViewedController = Get.put(HomeRecentlyViewedController());
   RecentlyViewed({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
     bool isLargeScreen = screenWidth > 1400;
     return LayoutBuilder(
       builder: (context, constraints) {
         int itemsPerRow = Responsive.isMobile(context) ? 2 :Responsive.isTablet(context) ?3:4;
         double itemWidth = (constraints.maxWidth / itemsPerRow) - 16;
         double itemHeight = Responsive.isMobile(context)
             ? 320:(isLargeScreen ?500:500); // Set a fixed height for items

         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Padding(
               padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 18 : 48.0,right: Responsive.isMobile(context) ? 18 : 48.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   Text(
                     'recently viewed',
                     style: TextStyle(
                       color: AppColors.botomSheetColor,
                       fontFamily: 'aftika-regular',
                       fontSize: Responsive.isMobile(context) ? 22 : 40,
                       fontWeight: FontWeight.w400,
                     ),
                   ),
                   Spacer(),
                   Expanded(
                     child: Container(
                       height: Responsive.isMobile(context) ?34:Responsive.isTablet(context) ? 36:60,
                       width: Responsive.isMobile(context) ?160:Responsive.isTablet(context) ? 170:200,
                       decoration: BoxDecoration(
                         color: Color(0xFFE4E7EC),
                         borderRadius: BorderRadius.circular(Responsive.isMobile(context) ? 4:Responsive.isTablet(context) ? 5:6)
                       ),
                       child: TextFormField(
                         maxLines: 1,

                         style: TextStyle(
                           color: AppColors.blackColor,
                           fontFamily: "Lora-Regular",
                           fontSize: Responsive.isMobile(context) ? 12 :Responsive.isTablet(context) ? 12: 18,
                         ),
                         cursorColor: AppColors.textColor,
                         decoration: InputDecoration(

                           hintText: 'search',
                           hintStyle: TextStyle(
                             color: AppColors.blackColor,
                             fontFamily: "Lora-Regular",
                             fontWeight: FontWeight.w500,

                             fontSize: Responsive.isMobile(context) ? 12 :Responsive.isTablet(context) ? 12: 18,
                           ),
                           border: InputBorder.none,
                           contentPadding: EdgeInsets.only(
                             top: Responsive.isMobile(context) ? 4:Responsive.isTablet(context) ? 17: 18,
                             bottom: Responsive.isMobile(context) ? 4 :Responsive.isTablet(context) ? 17: 12,
                             left: Responsive.isMobile(context) ? 9 : 20,
                           ),
                           prefixIcon: Padding(
                             padding:  EdgeInsets.all(Responsive.isMobile(context) ? 12 :Responsive.isTablet(context) ? 14:18.0),
                             child: Image.asset(
                               'assets/images/search_black_icon.png',
                               fit: BoxFit.contain,
                               height: Responsive.isMobile(context) ?3:20,
                               width: Responsive.isMobile(context) ?3:20,
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),


                 ],
               ),
             ),
             const SizedBox(height: 20),
             Obx(() {


               return Padding(
                 padding: EdgeInsets.only(
                   left: Responsive.isMobile(context)
                       ? 18
                       : (isLargeScreen ? 48 : 30.0),
                   right: Responsive.isMobile(context)
                       ? 18
                       : (isLargeScreen ? 48 : 30.0),
                 ),
                 child: GridView.builder(
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                     mainAxisExtent: Responsive.isMobile(context)
                         ? 263
                         : (isLargeScreen ? 400 : 350),
                     crossAxisCount: Responsive.isMobile(context)
                         ? 2
                         : (Responsive.isTablet(context) ? 3 : 4),
                     crossAxisSpacing: Responsive.isMobile(context)
                         ? 10
                         : (Responsive.isTablet(context) ? 8 : 10),
                     mainAxisSpacing: Responsive.isMobile(context)
                         ? 0
                         : (Responsive.isTablet(context) ? 2 : 20),
                     childAspectRatio: itemWidth / itemHeight,
                   ),
                   itemCount: recentlyViewedController.recentlyViewedItem.length,
                   itemBuilder: (context, index) {
                     final item = recentlyViewedController.recentlyViewedItem[index];
                     return GestureDetector(
                       onTap: () {



                         if (onNavigate != null) {
                           onNavigate!(8); // Call the callback to navigate to the 7th screen
                         }
                       },
                       child: CustomRectangleWidget(
                         title: item.title,
                         description: item.description,
                         imagePath: item.imagePath,
                         timetext: item.timetext,
                         percentText: item.percentText, isFavorite: false.obs,
                       ),
                     );
                   },
                 ),
               );


             })
           ],
         );
       },
     );

  }
}
