import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_controller/onboarding_controller.dart';

import '../../../constants/app_colors.dart';
import '../../../custom_widget/separate_text_field.dart';
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
    this.city,
    this.country,
  }) {
    homeController.selectedTop.value = '';
  }
  List<RestaurantModel> filteredRestaurants = [];
  String? city;
  String? country;
  final onboradingController = Get.put(OnboardingController());
  @override
  Widget build(BuildContext context) {
    bool isOnboarding = onboradingController.selectedCountry.value != 'Country';
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
                    Text(
                      '',
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
                        onChanged: (value) {
                          if (value.trim() != '') {
                            homeController.filterRestaurants(value);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Explore Restaurants',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 12),
                    StreamBuilder(
                      stream: homeController.getRestaurants(),
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
                          return SizedBox(
                              height: Get.height * 0.5,
                              child:
                                  Center(child: Text('No restaurants found')));
                        }

                        List<RestaurantModel> restaurants = snapshot.data!;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          homeController.initializeSelectors(restaurants);
                        });

                        return GetBuilder<HomeLocationController>(
                          builder: (controller) {
                            if (city != null && country != null) {
                              controller.filteredRestaurants = controller
                                  .filteredRestaurants
                                  .where((restaurant) {
                                return restaurant.city == city &&
                                    restaurant.country == country;
                              }).toList();
                            }

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
