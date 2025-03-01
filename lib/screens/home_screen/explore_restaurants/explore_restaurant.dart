import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/widgets/rectangle_widget.dart';

import '../../../constants/app_colors.dart';
import '../../../custom_widget/separate_text_field.dart';
import '../home_controller/home_cusiness_controller.dart';
import '../home_controller/home_location_controller.dart';

class ExploreRestaurant extends StatelessWidget {
  final Function(int)? onNavigate;
  final HomeCusinessController cusinessController =
      Get.put(HomeCusinessController());
  final HomeLocationController controller = Get.put(HomeLocationController());

  ExploreRestaurant(
      {super.key, this.onNavigate, this.cuisneName, this.restaurantIDs}) {
    // Reset the selectedTop value when this screen is instantiated
    controller.selectedTop.value = ''; // Clear any previous selections
  }
  List<String>? restaurantIDs;
  String? cuisneName;
  @override
  Widget build(BuildContext context) {
    print('restaurantIDs $restaurantIDs');
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
              title: Text(
                cuisneName ?? '',
                style: TextStyle(
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
                  children: [
                    SizedBox(height: 10),
                    SizedBox(
                      height: 38,
                      child: CustomSeparateTextField(
                        controller: controller.searchController,
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
                    StreamBuilder(
                      stream: controller.getRestaurants(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: Get.height * 0.5,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return Text('No restaurants found');
                        }

                        List<RestaurantModel> restaurants = snapshot.data!;

                        if (restaurantIDs?.isNotEmpty ?? false) {
                          // Filter restaurants where the ID is in the selected IDs list
                          restaurants = restaurants
                              .where((restaurant) =>
                                  restaurantIDs!.contains(restaurant.docID))
                              .toList();
                        }
                        controller.searchController.addListener(() {
                          controller.filteredRestaurants = restaurants
                              .where((item) => item.resName
                                  .toLowerCase()
                                  .contains(controller.searchController.text
                                      .toLowerCase()))
                              .toList();
                          controller.update();
                        });
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          controller.initializeSelectors(restaurants);
                        });

                        return GetBuilder<HomeLocationController>(
                          builder: (controller) {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: Get.height * 0.27,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 20,
                              ),
                              itemCount: controller.filteredRestaurants.length,
                              itemBuilder: (context, index) {
                                final item =
                                    controller.filteredRestaurants[index];
                                return InkWell(
                                  onTap: () {
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
                                    happyhour: item.menuList.happyHourSpecials,
                                    isFavorite: false.obs,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 30),
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
