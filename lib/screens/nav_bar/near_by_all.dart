import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import 'package:kaistable_website/widgets/rectangle_widget.dart';

import '../../../constants/app_colors.dart';

class NearByAll extends StatelessWidget {
  NearByAll({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
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
          'Near By Restaurants',
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
          child: _buildTopSection(),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    final HomeLocationController controller = Get.put(HomeLocationController());
    return StreamBuilder(
        stream: controller.getRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
                height: Get.height * 0.7,
                child: Center(
                    child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                )));
          }

          if (snapshot.hasError) {
            print('Error during stream call ${snapshot.error}');
            return Text(''); // Show error message if any
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Text(''); // Handle the case where data is null or empty
          }
          List<RestaurantModel> all_restaurants = snapshot.data!;
          // Initialize state after the widget build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.initailizedSelectors(resaturantsList: all_restaurants);
          });

          return FutureBuilder(
              future: controller.getNearbyRestaurants(all_restaurants, 50000),
              builder: (context, futureSnapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                      height: Get.height * 0.5,
                      child: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No nearby restaurants found.');
                }
                print('futureSnapshot.data: ${futureSnapshot.data?.length}');

                List<RestaurantModel> restaurants = futureSnapshot.data ?? [];
                if (restaurants.isEmpty) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You May Like",
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: 'aftika-regular',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: Get.height * 0.5,
                          child: Center(
                              child: Text('No nearby restaurants found.'))),
                    ],
                  );
                }

                return Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 0,
                        right: 18,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You May Like",
                                style: TextStyle(
                                  color: AppColors.bottomSheetColor,
                                  fontFamily: 'aftika-regular',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: Get.height * 0.27,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        final item = restaurants[index];
                        return InkWell(
                          onTap: () {
                            Get.to(RestaurantDetailScreen(
                              restaurantModel: item,
                            ));
                          },
                          child: RectangleWidget(
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
                    ),
                  ],
                );
              });
        });
  }
}
