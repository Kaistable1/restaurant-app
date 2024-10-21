import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/fav_rectangle_widget.dart';
import 'location_controller/location_controller.dart';

class LocationScreen extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());
   LocationScreen({super.key});

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: Responsive.isMobile(context) ? 22: 46.0),
              child: Text(
                'New york ',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontFamily: 'aftika-regular',
                  fontSize: Responsive.isMobile(context) ? 22 : 40,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 8 :18),
            Padding(
              padding:  EdgeInsets.only(left:Responsive.isMobile(context) ? 22: 46.0),
              child: Text(
                'The area is lively with restaurants, bars and nightlife.',
                style: TextStyle(
                  color: Color(0xFF1E0E0E),
                  fontFamily: 'Nunito-Regular',
                  fontSize: Responsive.isMobile(context) ? 8 : 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
             SizedBox(height: Responsive.isMobile(context) ? 10 :18),


            Padding(
              padding:  EdgeInsets.only(left:Responsive.isMobile(context) ? 22: 46.0,right: Responsive.isMobile(context) ? 22: 46.0,),
              child: Container(
                height: Responsive.isMobile(context) ? 25:50,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEFF2),
                  borderRadius: BorderRadius.circular(Responsive.isMobile(context) ? 4:10)
                ),
                child: Padding(
                  padding:  EdgeInsets.only(left:Responsive.isMobile(context) ? 22: 26.0,right: Responsive.isMobile(context) ? 22: 26.0,),
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: Responsive.isMobile(context) ? 372:Responsive.isTablet(context) ? 572:672,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('sort:',
                            style: TextStyle(
                              fontFamily: 'Nunito-Regular',
                              fontSize: Responsive.isMobile(context) ? 8:14,
                                fontWeight: FontWeight.w400,
                              color: AppColors.textColor

                            ),

                            ),
                            Container(
                              height:Responsive.isMobile(context) ? 20:38,
                              width: Responsive.isMobile(context) ? 80:121,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(Responsive.isMobile(context) ? 4:10),

                              ),
                              child: Center(
                                child: Text('most reviewed',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Responsive.isMobile(context) ? 8:14,
                                  color: AppColors.primaryColor,
                                  fontFamily: 'Nunito-Regular'

                                ),),
                              ),

                            ),
                            Text('Discount:',
                              style: TextStyle(
                                  fontFamily: 'Nunito-Regular',
                                  fontSize:Responsive.isMobile(context) ? 8:14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textColor

                              ),

                            ),
                            Text('minimum:',
                              style: TextStyle(
                                  fontFamily: 'Nunito-Regular',
                                  fontSize: Responsive.isMobile(context) ? 8:14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textColor

                              ),

                            ),
                            Text('maximum:',
                              style: TextStyle(
                                  fontFamily: 'Nunito-Regular',
                                  fontSize: Responsive.isMobile(context) ? 8:14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textColor

                              ),

                            ),
                          ],
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 2 :22),
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
                        : (isLargeScreen ? 430 : 350),
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
                  itemCount: locationController.locationItem.length,
                  itemBuilder: (context, index) {
                    final item = locationController.locationItem[index];
                    return CustomRectangleWidget(
                      title: item.title,
                      description: item.description,
                      imagePath: item.imagePath,
                      timetext: item.timetext,
                      percentText: item.percentText, isFavorite: false.obs,
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
