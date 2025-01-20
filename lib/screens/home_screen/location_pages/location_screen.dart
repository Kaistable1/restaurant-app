

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kaistable_website/screens/home_screen/my_home_screen.dart';
import 'package:kaistable_website/widgets/home_widgets/filter_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../custom_widget/separate_text_field.dart';
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
                  color: AppColors.bottomSheetColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito-Bold',
                ),),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'New york',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height:  8),
                    Text(
                      'The area is lively with restaurants, bars and nightlife.',
                      style: TextStyle(
                        color: Color(0xFF1E0E0E),
                        fontFamily: 'Nunito-Regular',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height:  10),
                    SizedBox(
                      height: 38,
                      child: CustomSeparateTextField(
                        controller: mycontroller.searchController,
                        hintText: 'Try searching for restaurant name',
                        hintStyle: TextStyle(
                          color: AppColors.hintText,
                          fontFamily: "Nunito-Regular",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                        isPrefixIcon: true,
                        isShadow: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                              left: 4, top: 8, bottom: 8, right: 0),
                          child: Image.asset(
                            'assets/images/search_icon.png',
                            fit: BoxFit.contain,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        isSuffixIcon: true,
                        suffixIcon: Container(
                          height: 38,
                          width: 66,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: AppColors.bottomSheetColor,
                                fontFamily: "Nunito-Bold",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:  16),
                    Text(
                      'Explore Restaurants',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height:  12),
                    Obx(() {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 220,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
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
                              endTimeText: item.endTimeText,
                              isFavorite: false.obs,
                            ),
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
