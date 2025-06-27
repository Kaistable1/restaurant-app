import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/recent_view.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/widgets/rectangle_widget.dart';
import '../../../constants/app_colors.dart';
import '../../../custom_widget/separate_text_field.dart';
import '../home_controller/home_location_controller.dart';
import '../home_controller/home_recently_viewed_controller.dart';

class RecentlyViewed extends StatelessWidget {
  final Function(int)? onNavigate;
  final HomeRecentlyViewedController recentlyViewedController =
      Get.put(HomeRecentlyViewedController());
  final HomeLocationController homeController =
      Get.put(HomeLocationController());

  RecentlyViewed({
    super.key,
    this.onNavigate,
  }) {
    homeController.selectedTop.value = '';
  }

  List<RestaurantModel> filteredRestaurants = [];
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.bgColor,
          iconTheme: IconThemeData(
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
                child: Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
          title: Text(
            'Recently Viewed',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.bottomSheetColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito-Bold',
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
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
                        borderRadius: const BorderRadius.only(
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
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
              ),
              const SizedBox(height: 12),
              StreamBuilder(
                stream: homeController.getAllRestaurants(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print('Error during stream call: ${snapshot.error}');
                    return const Center(child: Text('Error loading data'));
                  }

                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No restaurants available.'));
                  }

                  List<RestaurantModel> restaurants = snapshot.data!;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    homeController.initailizedSelectors(
                        resaturantsList: restaurants);
                  });

                  return StreamBuilder<List<RecentViewModel>>(
                    stream: homeController.getRecentViews(),
                    builder: (context, snapshot) {
                      List<RecentViewModel> restaurantIDs = snapshot.data ?? [];

                      restaurantIDs
                          .sort((a, b) => b.dateTime.compareTo(a.dateTime));

                      List<String> sortedRestaurantIds = restaurantIDs
                          .map((recentView) => recentView.restaurantID)
                          .toList();

                      List<RestaurantModel> filteredIDSRestaurants = [];
                      if (restaurants.isNotEmpty) {
                        filteredIDSRestaurants = sortedRestaurantIds
                            .map((id) => restaurants
                                .where((restaurant) => restaurant.docID == id)
                                .toList())
                            .expand((element) => element)
                            .toList();
                      }
                      filteredRestaurants = filteredIDSRestaurants;
                      homeController.searchController.addListener(() {
                        filteredRestaurants = filteredIDSRestaurants
                            .where((item) => item.resName
                                .toLowerCase()
                                .contains(homeController.searchController.text
                                    .toLowerCase()))
                            .toList();
                        homeController.update();
                      });

                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GetBuilder<HomeLocationController>(
                                  builder: (homeLocationController) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  // gridDelegate:
                                  //     SliverGridDelegateWithFixedCrossAxisCount(
                                  //   mainAxisExtent: Get.height * 0.2,
                                  //   crossAxisCount: 2,
                                  //   crossAxisSpacing: 10,
                                  //   mainAxisSpacing: 30,
                                  // ),
                                  itemCount: filteredRestaurants.length,
                                  itemBuilder: (context, index) {
                                    final item = filteredRestaurants[index];
                                    return InkWell(
                                      onTap: () {
                                        Get.to(RestaurantDetailScreen(
                                          restaurantModel: item,
                                        ));
                                      },
                                      child: RectangleWidget(
                                        onNavigate: onNavigate,
                                        title: item.resName,
                                        description: item.address,
                                        resturant_id: item.docID,
                                        imagePath: item.logoImage,
                                        timetext: '10 AM',
                                        percentText: '25%',
                                        endTimeText: '9 PM',
                                        isFavorite: false.obs,
                                         height: 250,
                                      ),
                                    );
                                  },
                                );
                              }),
                              const SizedBox(height: 30),
                            ],
                          ),
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
