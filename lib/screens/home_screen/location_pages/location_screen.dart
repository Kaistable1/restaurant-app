

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kaistable_website/screens/home_screen/my_home_screen.dart';
import 'package:kaistable_website/widgets/home_widgets/filter_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/fav_rectangle_widget.dart';
import '../../../widgets/rectangle_widget.dart';
import '../../detail_screens/restaurant_detail_screen.dart';
import '../home_controller/home_location_controller.dart';
import 'location_controller/location_controller.dart';

class LocationScreen extends StatelessWidget {
 // final ScrollController scrollcontroller;
  final Function(int)? onNavigate;
  final List<String> items = [
    '10%',
    '20%',
    '30%',
    '40%',
    '50%',

  ];
  final LocationController locationController = Get.put(LocationController());
  final HomeLocationController mycontroller = Get.put(HomeLocationController());
  LocationScreen({super.key, this.onNavigate,})
  {
    mycontroller.selectedTop.value='';
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return WillPopScope(
      onWillPop: ()async{
         Get.back();
        return false;

      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          int itemsPerRow = Responsive.isMobile(context)
              ? 2
              : Responsive.isTablet(context)
              ? 3
              : 4;
          double itemWidth = (constraints.maxWidth / itemsPerRow) - 16;
          double itemHeight = Responsive.isMobile(context)
              ? 320
              : (isLargeScreen ? 500 : 500); // Set a fixed height for items

          return Scaffold(
            backgroundColor: AppColors.bgColor,
            appBar: AppBar(backgroundColor: AppColors.bgColor,
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
                      Get.back(); // Navigate back to the home screen
                    },
                    child: Icon(Icons.arrow_back, size: 18,color: AppColors.primaryColor,),
                  ),
                ),
              ),

              title: Text('Available restaurants',
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: Responsive.isMobile(context) ? 16 : 46.0),
                    child: Text(
                      'New york ',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: 'aftika-regular',
                        fontSize: Responsive.isMobile(context) ? 26 : 40,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.isMobile(context) ? 8 : 18),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Responsive.isMobile(context) ? 16 : 46.0),
                    child: Text(
                      'The area is lively with restaurants, bars and nightlife.',
                      style: TextStyle(
                        color: Color(0xFF1E0E0E),
                        fontFamily: 'Nunito-Regular',
                        fontSize: Responsive.isMobile(context) ? 10 : 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.isMobile(context) ? 10 : 18),

                  FilterBox(),

                  SizedBox(height: Responsive.isMobile(context) ? 20 : 22),
                  Obx(() {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: Responsive.isMobile(context)
                            ? 14
                            : (isLargeScreen ? 48 : 30.0),
                        right: Responsive.isMobile(context)
                            ? 14
                            : (isLargeScreen ? 48 : 30.0),
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: Responsive.isMobile(context)
                              ? 220
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
                          return InkWell(
                            onTap: () {
                              Get.to(RestaurantDetailScreen());
                            },
                            child: RectangleWidget(
                              onNavigate: onNavigate,
                              title: item.title,
                              description: item.description,
                              imagePath: item.imagePath,
                              timetext: item.timetext,
                              percentText: item.percentText,
                              isFavorite: false.obs,
                              //scrollcontroller: scrollcontroller,
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
