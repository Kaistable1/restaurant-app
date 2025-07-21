import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import 'package:kaistable_website/widgets/rectangle_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../custom_widget/separate_text_field.dart';
import '../home_controller/home_location_controller.dart';
import '../home_controller/home_new_controller.dart';

// ignore: must_be_immutable
class EntertainmentsScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  final HomeNewController newController = Get.put(HomeNewController());
  final HomeLocationController homeController =
      Get.put(HomeLocationController());
  EntertainmentsScreen({
    super.key,
    this.onNavigate,
  }) {
    homeController.selectedTop.value = '';
  }

  List<RestaurantModel> filteredRestaurants = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: AppBar(
              backgroundColor: AppColors.whiteColor,
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
                'Experience',
                style: const TextStyle(
                  fontSize: 17,
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
                    CustomSeparateTextField(
                      controller: homeController.searchController,
                      hintText: 'Try searching for restaurant name',
                      onChanged: (v) {
                        if (v.isNotEmpty) homeController.filterRestaurants(v);
                      },
                      // hintStyle: TextStyle(
                      //   color: AppColors.hintText,
                      //   fontFamily: "Nunito-Regular",
                      //   fontWeight: FontWeight.w400,
                      //   fontSize: 12,
                      // ),
                      // isPrefixIcon: true,
                      // isShadow: true,
                      // prefixIcon: Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 4, top: 8, bottom: 8, right: 0),
                      //   child: Image.asset(
                      //     'assets/images/search_icon.png',
                      //     fit: BoxFit.contain,
                      //     height: 20,
                      //     width: 20,
                      //   ),
                      // ),
                      // isSuffixIcon: true,
                    
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Explore Restaurants',
                          style: TextStyle(
                            color: AppColors.bottomSheetColor,
                            fontFamily: 'aftika-regular',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    StreamBuilder(
                        stream: homeController.getEntertainmentRestaurants(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return buildShimmerEffect();
                          }

                          if (snapshot.hasError) {
                            print('Error during stream call ${snapshot.error}');
                            return Text(''); // Show error message if any
                          }

                          if (snapshot.data == null || snapshot.data!.isEmpty) {
                            return Text(
                                'No restaurants found'); // Handle the case where data is null or empty
                          }

                          List<RestaurantModel> restaurants = snapshot.data!;
                          // Initialize filtered restaurants
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            homeController.initializeSelectors(restaurants);
                          });
                          return GetBuilder<HomeLocationController>(
                            builder: (controller) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                // gridDelegate:
                                //     SliverGridDelegateWithFixedCrossAxisCount(
                                //   mainAxisExtent: Get.height * 0.18,
                                //   crossAxisCount: 2,
                                //   crossAxisSpacing: 10,
                                //   mainAxisSpacing: 20,
                                // ),
                                itemCount:
                                    controller.filteredRestaurants.length,
                                itemBuilder: (context, index) {
                                  final item =
                                      controller.filteredRestaurants[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(RestaurantDetailScreen(
                                          restaurantModel: item,
                                        ));
                                      },
                                      child: RectangleWidget(
                                        title: item.resName,
                                        description: item.address,
                                        resturant_id: item.docID,
                                        imagePath: item.logoImage,
                                        timetext: '10 AM',
                                        percentText: '25%',
                                        endTimeText: '9 PM',
                                   
                                        width: double.infinity,
                                        height: 250,
                                      ),
                                    ),
                                  );
                                },
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
