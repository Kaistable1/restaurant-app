import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import 'package:kaistable_website/widgets/rectangle_widget.dart';

import '../../../constants/app_colors.dart';
import 'widgets/homeScreenWidget/horizontal_card_widget.dart';

class NearByAll extends StatelessWidget {
   final List<RestaurantModel> filteredRestaurants;
  NearByAll({
    super.key,required this.filteredRestaurants
  });
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.whiteColor,
    appBar: AppBar(
      backgroundColor: AppColors.whiteColor,
      iconTheme: IconThemeData(color: AppColors.primaryColor),
      centerTitle: true,
      automaticallyImplyLeading: true,
      leading: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
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
            child: Icon(Icons.arrow_back, size: 18, color: AppColors.primaryColor),
          ),
        ),
      ),
      title: const Text(
        'Near By Restaurants',
        style: TextStyle(
          fontSize: 17,
          color: AppColors.bottomSheetColor,
          fontWeight: FontWeight.w700,
          fontFamily: 'Nunito-Bold',
        ),
      ),
    ),
    body:  filteredRestaurants.isEmpty
    ? Center(
        child: Text(
          "No nearby restaurants found.",
          style: TextStyle(
            color: AppColors.bottomSheetColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      )
    : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          // 👇 These 2 lines are the fix
          shrinkWrap: false, // don't force it to take only content height
          physics: AlwaysScrollableScrollPhysics(), // allow scrolling
          
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: Get.height * 0.2,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
          ),
          itemCount: filteredRestaurants.length,
          itemBuilder: (context, index) {
            final item = filteredRestaurants[index];
            return InkWell(
              onTap: () => Get.to(
                RestaurantDetailScreen(restaurantModel: item),
              ),
              child: HorizontalCardWidget(
                title: item.resName,
                imagePath: item.logoImage,
                description: item.address,
                isFavorite: false.obs,
                onTap: () => Get.to(
                  RestaurantDetailScreen(restaurantModel: item),
                ),
              ),
            );
          },
        ),
      ),

  );
}

}
