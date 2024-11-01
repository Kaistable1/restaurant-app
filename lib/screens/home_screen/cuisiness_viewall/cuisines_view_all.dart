import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/fav_rectangle_widget.dart';
import '../home_controller/home_cusiness_controller.dart';
import '../home_controller/home_recently_viewed_controller.dart';

class CuisinesViewAll extends StatelessWidget {
  final ScrollController scrollcontroller;
  final Function(int)? onNavigate;
  final HomeCusinessController cusinessController = Get.put(HomeCusinessController());
  CuisinesViewAll({super.key, this.onNavigate, required this.scrollcontroller});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return WillPopScope(
      onWillPop: ()async{
        if (onNavigate != null) {
          onNavigate!(0); // Call the callback to navigate to the 7th screen
        }
        return false;

      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          int itemsPerRow = Responsive.isMobile(context) ? 2 :Responsive.isTablet(context) ?3:4;
          double itemWidth = (constraints.maxWidth / itemsPerRow) - 16;
          double itemHeight = Responsive.isMobile(context)
              ? 320:(isLargeScreen ?500:500); // Set a fixed height for items
      
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 18 : 48.0,right: Responsive.isMobile(context) ? 18 : 48.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Cuisines',
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
                    itemCount: cusinessController.cusinessItem.length,
                    itemBuilder: (context, index) {
                      final item = cusinessController.cusinessItem[index];
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
                          percentText: item.percentText, isFavorite: false.obs, scrollcontroller: scrollcontroller,
                        ),
                      );
                    },
                  ),
                );
      
      
              })
            ],
          );
        },
      ),
    );

  }
}
