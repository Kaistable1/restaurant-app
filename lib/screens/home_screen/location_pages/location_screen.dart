import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/resaturant_model.dart';

import '../../../constants/app_colors.dart';
import '../../../custom_widget/separate_text_field.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/rectangle_widget.dart';
import '../../detail_screens/restaurant_detail_screen.dart';
import '../home_controller/home_location_controller.dart';
import 'location_controller/location_controller.dart';

class LocationScreen extends StatelessWidget {
  // final ScrollController scrollcontroller;
  final Function(int)? onNavigate;

  final LocationController locationController = Get.put(LocationController());
  final HomeLocationController homeController =
      Get.put(HomeLocationController());
  LocationScreen({
    super.key,
    this.onNavigate,
  }) {
    homeController.selectedTop.value = '';
  }
  List<RestaurantModel> filteredRestaurants = [];


  @override
  Widget build(BuildContext context) {
    filteredRestaurants=homeController.resaturant_list;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return WillPopScope(
      onWillPop: () async {
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
            appBar: AppBar(
              backgroundColor: AppColors.bgColor,
              iconTheme: IconThemeData(
                color: AppColors
                    .primaryColor, // Set your desired color for the drawer icon
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
                    child: Icon(
                      Icons.arrow_back,
                      size: 18,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              title: Text(
                'Available restaurants',
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.bottomSheetColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito-Bold',
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      currentUserDataModel?.value.city ?? "",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'The area is lively with restaurants, bars and nightlife.',
                      style: TextStyle(
                        color: Color(0xFF1E0E0E),
                        fontFamily: 'Nunito-Regular',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 38,
                      child: CustomSeparateTextField(
                        controller: homeController.searchController,
                        hintText: 'Try searching for restaurant name',
                        onChanged: (v) {
                          filteredRestaurants =homeController.resaturant_list
                              .where((item) => item.resName
                              .toLowerCase()
                              .contains(homeController
                              .searchController.text
                              .toLowerCase()))
                              .toList();
                          homeController.update();
                        },
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
                    SizedBox(height: 16),
                    Text(
                      'Explore Restaurants',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 12),
                    GetBuilder<HomeLocationController>(
                        builder: (homeLocationController) {
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
                        itemCount:filteredRestaurants.length,
                        itemBuilder: (context, index) {
                          final item = filteredRestaurants[index];
                          return InkWell(
                            onTap: () {
                              print('item ${item.logoImage}');
                              Get.to(RestaurantDetailScreen(
                                restaurantModel: item,
                              ));
                            },
                            child: RectangleWidget(
                              onNavigate: onNavigate,
                              title: item.resName,
                              description: item.about,
                              resturant_id: item.docID,
                              imagePath: item.logoImage,
                              timetext: '10 AM',
                              percentText: '25%',
                              endTimeText: '9 PM',
                              percentageOff: item.menuList.percentageOff,
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
