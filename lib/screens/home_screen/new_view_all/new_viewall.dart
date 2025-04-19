import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import 'package:kaistable_website/widgets/rectangle_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/app_colors.dart';
import '../../../custom_widget/separate_text_field.dart';
import '../../../utils/responsive.dart';
import '../home_controller/home_location_controller.dart';
import '../home_controller/home_new_controller.dart';

class NewViewall extends StatelessWidget {
  final Function(int)? onNavigate;
  final HomeNewController newController = Get.put(HomeNewController());
  final HomeLocationController homeController =
      Get.put(HomeLocationController());

  NewViewall({super.key, this.onNavigate}) {
    homeController.selectedTop.value = '';
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          iconTheme: IconThemeData(color: AppColors.primaryColor),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(Icons.arrow_back,
                  size: 18, color: AppColors.primaryColor),
            ),
          ),
          title: Text(
            'New',
            style: const TextStyle(
              fontSize: 17,
              color: AppColors.bottomSheetColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito-Bold',
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Expanded(
                child: StreamBuilder(
                  stream: homeController.getRestaurants(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return buildShimmerEffect(); // Show shimmer while loading
                    }

                    if (snapshot.hasError) {
                      print('Error during stream call ${snapshot.error}');
                      return Center(child: Text('Error loading restaurants'));
                    }

                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return Center(child: Text('No restaurants found'));
                    }
                    List<RestaurantModel> filterResturatns = [];
                    filterResturatns = homeController.restaurants;

                    return GetBuilder<HomeLocationController>(
                      builder: (controller) {
                        controller.searchController.addListener(() {
                          String inputText =
                              controller.searchController.text.trim();
                          filterResturatns = controller.restaurants
                              .where((item) => item.resName
                                  .toLowerCase()
                                  .contains(inputText))
                              .toList();
                          controller.update();
                        });

                        return NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent * 0.8 &&
                                !homeController.isLoading) {
                              homeController
                                  .loadMoreRestaurants(); // Load more when scrolling down
                              filterResturatns = homeController.restaurants;
                            }
                            return true;
                          },
                          child: Column(
                            children: [
                              Flexible(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisExtent: Get.height * 0.2,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 20,
                                  ),
                                  itemCount: filterResturatns.length,
                                  itemBuilder: (context, index) {
                                    final item = filterResturatns[index];
                                    return InkWell(
                                      onTap: () {
                                        Get.to(RestaurantDetailScreen(
                                            restaurantModel: item));
                                      },
                                      child: RectangleWidget(
                                        title: item.resName,
                                        description: item.address,
                                        resturant_id: item.docID,
                                        imagePath: item.logoImage,
                                        timetext: '10 AM',
                                        percentText: '25%',
                                        endTimeText: '9 PM',
                                        isFavorite: false.obs,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              if (homeController.isLoading)
                                Padding(
                                  padding: EdgeInsets.all(30),
                                  child: Text('Loading More .....'),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
