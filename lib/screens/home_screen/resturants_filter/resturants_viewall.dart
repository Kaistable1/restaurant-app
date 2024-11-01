import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/custom_filter_widget.dart';
import '../../../widgets/fav_rectangle_widget.dart';
import '../home_controller/home_cusiness_controller.dart';
import '../home_controller/home_filter_controller.dart';
import '../home_controller/home_recently_viewed_controller.dart';
import '../home_controller/home_trending_controller.dart';

class ResturantsViewall extends StatelessWidget {

  final Function(int)? onNavigate;
  final HomeFilterController filterController = Get.put(HomeFilterController());
  ResturantsViewall({super.key, this.onNavigate});

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
              ? 320:(isLargeScreen ?500:500);
          int filterItemperRow = Responsive.isMobile(context)
              ? 2
              : Responsive.isTablet(context)
              ? 2
              : 3;
          double filterItemWidth = (constraints.maxWidth / filterItemperRow) - 8;
          double filterItemHeight =
          Responsive.isMobile(context) ? 320 : (isLargeScreen ? 400 : 200);// Set a fixed height for items

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 18 : 48.0,right: Responsive.isMobile(context) ? 18 : 48.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Resturants',
                      style: TextStyle(
                        color: AppColors.botomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: Responsive.isMobile(context) ? 22 : 40,
                        fontWeight: FontWeight.w400,
                      ),
                    ),



                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(height: Responsive.isMobile(context) ? 8 : 20),
              Obx(() {
                //Determine item count based on screen type
                int itemCount;
                if (Responsive.isMobile(context)) {
                  itemCount = filterController.filterItem.length;
                } else if (Responsive.isTablet(context)) {
                  itemCount = filterController.filterItem.length > 3
                      ? 6
                      : filterController.filterItem.length;
                } else {
                  itemCount = filterController.filterItem.length > 4
                      ? filterController.filterItem.length
                      : filterController.filterItem.length;
                }

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
                          ? 50
                          : (isLargeScreen ? 120 : 100),
                      crossAxisCount: Responsive.isMobile(context)
                          ? 2
                          : (Responsive.isTablet(context) ? 2 : 3),
                      crossAxisSpacing: Responsive.isMobile(context)
                          ? 10
                          : (Responsive.isTablet(context) ? 8 : 10),
                      mainAxisSpacing: Responsive.isMobile(context)
                          ? 12
                          : (Responsive.isTablet(context) ? 2 : 30),
                      childAspectRatio: filterItemWidth / filterItemHeight,
                    ),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final item = filterController.filterItem[index];
                      return InkWell(
                        onTap: (){
                          if (onNavigate != null) {
                            onNavigate!(8); // Call the callback to navigate to the 7th screen
                          }
                        },
                        child: CustomFilterWidget(
                          title: item.title,
                          description: item.description,
                          imgPath: item.imagePath,
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          );
        },
      ),
    );

  }
}
