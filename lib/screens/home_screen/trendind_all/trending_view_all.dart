import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kaistable_website/screens/home_screen/my_home_screen.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/fav_rectangle_widget.dart';
import '../home_controller/home_cusiness_controller.dart';
import '../home_controller/home_recently_viewed_controller.dart';
import '../home_controller/home_trending_controller.dart';

class TrendingViewAll extends StatelessWidget {

  final Function(int)? onNavigate;
  final HomeTrendingController trendingController =
  Get.put(HomeTrendingController());
   TrendingViewAll({super.key, this.onNavigate,});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return WillPopScope(
      onWillPop: ()async{
        Get.offAll(MyHomeScreen());
        return false;

      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          int itemsPerRow = Responsive.isMobile(context) ? 2 :Responsive.isTablet(context) ?3:4;
          double itemWidth = (constraints.maxWidth / itemsPerRow) - 16;
          double itemHeight = Responsive.isMobile(context)
              ? 320:(isLargeScreen ?500:500); // Set a fixed height for items

          return Scaffold(  backgroundColor: AppColors.bgColor,
            appBar: AppBar(  backgroundColor: AppColors.bgColor,
              iconTheme: IconThemeData(
                color: AppColors.primaryColor, // Set your desired color for the drawer icon
              ),
              centerTitle: true,
              automaticallyImplyLeading: true,
              leading: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.offAll(MyHomeScreen()); // Navigate back to the home screen
                    },
                    child: Icon(Icons.arrow_back, size: 18,color: AppColors.primaryColor,),
                  ),
                ),
              ),

              title: Text('Trending',
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.botomSheetColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito-Bold',
                ),),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 18 : 48.0,right: Responsive.isMobile(context) ? 18 : 48.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         'Trending',
                  //         style: TextStyle(
                  //           color: AppColors.botomSheetColor,
                  //           fontFamily: 'aftika-regular',
                  //           fontSize: Responsive.isMobile(context) ? 22 : 40,
                  //           fontWeight: FontWeight.w400,
                  //         ),
                  //       ),
                  //
                  //
                  //
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 30),
                  Obx(() {


                    return Padding(
                      padding: EdgeInsets.only(
                        left: Responsive.isMobile(context)
                            ? 18
                            : (isLargeScreen ? 48 : 46.0),
                        right: Responsive.isMobile(context)
                            ? 18
                            : (isLargeScreen ? 48 : 42.0),
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: Responsive.isMobile(context)
                              ? 180
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
                        itemCount: trendingController.trendingItem.length,
                        itemBuilder: (context, index) {
                          final item = trendingController.trendingItem[index];
                          return InkWell(
                            onTap: () {



                              if (onNavigate != null) {
                                onNavigate!(8); // Call the callback to navigate to the 7th screen
                              }
                            },
                            child: CustomRectangleWidget(
                              onNavigate: onNavigate,
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


                  }),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );

  }
}
