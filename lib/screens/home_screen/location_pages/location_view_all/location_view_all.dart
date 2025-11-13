import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/screens/home_screen/explore_restaurants/explore_restaurant.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_filter_controller.dart';
import 'package:kaistable_website/screens/onboarding_screen/onboarding_controller/onboarding_controller.dart';

import '../../../../constants/app_colors.dart';
import '../../../../custom_widget/separate_text_field.dart';
import '../../../../widgets/circle_container_widget.dart';
import '../../home_controller/home_location_controller.dart';

class LocationViewAll extends StatelessWidget {
  final HomeLocationController controller = Get.put(HomeLocationController());
  final HomeFilterController filterController = Get.put(HomeFilterController());

  LocationViewAll({super.key});
  final onboradingController = Get.put(OnboardingController());
  @override
  Widget build(BuildContext context) {
    bool isOnboarding = onboradingController.selectedCountry.value != 'Country';

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        title: const Text(
          'Location',
          style: TextStyle(
            fontSize: 17,
            color: AppColors.bottomSheetColor,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito-Bold',
          ),
        ),
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
              child: Icon(
                Icons.arrow_back,
                color: AppColors.primaryColor,
                size: 18,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 38,
                child: CustomSeparateTextField(
                  controller: controller.searchController,
                  hintText: 'Try searching for restaurant locations',
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
                      left: 4,
                      top: 8,
                      bottom: 8,
                      right: 0,
                    ),
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
                'Explore Location',
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontFamily: 'aftika-regular',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 16),
              FutureBuilder(
                future: filterController.getRestaurantsGroupedByAddress(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 113 / 144,
                            ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(150),
                                topRight: Radius.circular(150),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  final addressMap = snapshot.data as Map<String, List<String>>;

                  Map<String, List<String>> filteredCuisineMap = {};

                  controller.searchController.addListener(() {
                    filteredCuisineMap = addressMap.entries
                        .where(
                          (entry) => entry.key.toLowerCase().contains(
                            controller.searchController.text.toLowerCase(),
                          ),
                        )
                        .fold<Map<String, List<String>>>({}, (map, entry) {
                          map[entry.key] = entry.value;
                          return map;
                        });

                    controller.cusinesMapFilter = filteredCuisineMap;
                    controller.update();
                  });

                  controller.initializeCuisinesSelectors(addressMap);

                  return GetBuilder<HomeLocationController>(
                    builder: (controller) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height,
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: Get.height * 0.23,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 20.0,
                              ),
                          itemCount: controller.cusinesMapFilter.keys.length,
                          itemBuilder: (context, index) {
                            final cuisineName = controller.cusinesMapFilter.keys
                                .elementAt(index);
                            final restaurants =
                                controller.cusinesMapFilter[cuisineName]!
                                    .toSet()
                                    .toList()
                                  ..sort();

                            return CircleContainerWidget(
                              ontap: () {
                                Get.to(
                                  () => ExploreRestaurant(
                                    restaurantIDs: restaurants,
                                    cuisneName: cuisineName,
                                  ),
                                );
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
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
