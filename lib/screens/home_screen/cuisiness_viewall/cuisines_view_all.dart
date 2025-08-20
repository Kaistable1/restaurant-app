import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_filter_controller.dart';
import 'package:kaistable_website/widgets/global_functions.dart';

import '../../../constants/app_colors.dart';
import '../../../custom_widget/separate_text_field.dart';
import '../../../widgets/circle_container_widget.dart';
import '../explore_restaurants/explore_restaurant.dart';
import '../home_controller/home_cusiness_controller.dart';
import '../home_controller/home_location_controller.dart';

class CuisinesViewAll extends StatelessWidget {
  final Function(int)? onNavigate;
  final HomeCusinessController cusinessController =
      Get.put(HomeCusinessController());
  final HomeFilterController filterController = Get.put(HomeFilterController());

  CuisinesViewAll({super.key, this.onNavigate}) {
    // Reset the selectedTop value when this screen is instantiated
    filterController.selectedTop.value = ''; // Clear any previous selections
  }

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
            backgroundColor: AppColors.bgColor,
            appBar: AppBar(
              backgroundColor: AppColors.bgColor,
              iconTheme: const IconThemeData(
                color: AppColors.primaryColor,
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
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back,
                        size: 18, color: AppColors.primaryColor),
                  ),
                ),
              ),
              title: const Text(
                'Cuisines',
                style: TextStyle(
                  fontSize: 17,
                  color: AppColors.bottomSheetColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito-Bold',
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 38,
                      child: CustomSeparateTextField(
                        controller: filterController.searchController,
                        hintText: 'Try searching for restaurant name',
                        hintStyle: TextStyle(
                          color: AppColors.hintText,
                          fontFamily: "Nunito-Regular",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                        isPrefixIcon: true,
                        isShadow: true,
                        onChanged: (v) {
                          filterController.update();
                        },
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
                      'Explore Cuisines',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 12),
                    StreamBuilder<Map<String, List<String>>>(
                      stream: filterController.getRestaurantsGroupedByCuisine(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return buildShimmerEffect();
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        final cuisineMap = snapshot.data ?? {};

                        // Initialize the cuisine selectors only if not already initialized
                        if (filterController.cusinesMapFilter.isEmpty) {
                          filterController
                              .initializeCuisinesSelectors(cuisineMap);
                        }

                        return Obx(() {
                          final filteredCuisineMap =
                              filterController.cusinesMapFilter;
                          return SizedBox(
                            height: Get.height * 0.8,
                            width: double.infinity,
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: Get.height * 0.22,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 20.0,
                              ),
                              itemCount: filteredCuisineMap.keys.length,
                              itemBuilder: (context, index) {
                                final cuisineName =
                                    filteredCuisineMap.keys.elementAt(index);
                                final restaurants =
                                    filteredCuisineMap[cuisineName]!
                                        .toSet()
                                        .toList()
                                      ..sort();

                                return CircleContainerWidget(
                                  ontap: () {
                                    Get.to(() => ExploreRestaurant(
                                          restaurantIDs: restaurants,
                                          cuisneName: cuisineName,
                                        ));
                                  },
                                  isFavourite: false.obs,
                                  isLocation: false,
                                  height: 150,
                                  width: 115,
                                  imgPath: 'assets/images/aaa.jpg',
                                  titleText: cuisineName,
                                  descriptionText:
                                      '${restaurants.length.toString()} restaurants',
                                );
                              },
                            ),
                          );
                        });
                      },
                    ),
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
