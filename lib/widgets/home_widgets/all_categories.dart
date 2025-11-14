// lib/widgets/home_widgets/all_categories.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/rectangle_widget.dart';
import '../../screens/detail_screens/restaurant_detail_screen.dart';
import '../../screens/home_screen/home_controller/home_location_controller.dart';

class AllCategories extends StatelessWidget {
  AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopSection(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTopSection() {
    final HomeLocationController controller = Get.put(HomeLocationController());
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: StreamBuilder<List<RestaurantModel>>(
        stream: controller.getAllRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildShimmerEffect();
          }
          if (snapshot.hasError) {
            print('Error during stream call ${snapshot.error}');
            return const Text('');
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('');
          }

          final List<RestaurantModel> restaurants = snapshot.data!;

          // Initialize selectors after build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.initailizedSelectors(resaturantsList: restaurants);
          });

          List<RestaurantModel> filteredRestaurants = [];

          if (restaurants.isNotEmpty) {
            final List<String> recentView =
                preferences?.getStringList('recentView') ?? [];
            filteredRestaurants = recentView
                .map((resName) => restaurants.firstWhere(
                      (restaurant) =>
                          restaurant.resName.toLowerCase() ==
                          resName.toLowerCase(),
                      orElse: () => RestaurantModel.initialize(),
                    ))
                .where((restaurant) => restaurant.resName.isNotEmpty)
                .toList();
          }

          if (filteredRestaurants.isNotEmpty) {
            return Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recently Viewed',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: Get.height * 0.2,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 30,
                  ),
                  itemCount: filteredRestaurants.length,
                  itemBuilder: (context, index) {
                    final item = filteredRestaurants[index];
                    return InkWell(
                      onTap: () {
                        Get.to(() =>
                            RestaurantDetailScreen(restaurantModel: item));
                      },
                      child: SizedBox(
                        width: Get.width * 0.45,
                        child: RectangleWidget(
                          title: item.resName,
                          description: item.address,
                          resturant_id: item.docID,
                          imagePath: item.logoImage,
                          timetext: '10 AM',
                          // Removed undefined parameters:
                          // percentText: '25%',
                          // endTimeText: '9 PM',
                          // isFavorite: false.obs,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }

          return SizedBox(
            height: Get.height * 0.6,
            child: const Center(child: Text('No Restaurants Found!')),
          );
        },
      ),
    );
  }
}
