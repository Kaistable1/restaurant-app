import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/nav_bar/controller/home_controller.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/home_filter_bottomsheet.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/restaurant_card_widget.dart';

class AllRestaurantsPage extends StatelessWidget {
  final List<RestaurantModel> restaurants;

  AllRestaurantsPage({Key? key, required List<RestaurantModel> restaurants})
      : restaurants = List.of(restaurants)..shuffle(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Restaurants',
          style: TextStyle(
              fontFamily: 'aftika-bold',
              color: AppColors.bottomSheetColor,
              fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.bottomSheetColor),
      ),

      body:  Column(
        children: [
          // You can optionally show filter tags here

          // ✅ Wrap ListView.builder in Expanded
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                final controller = Get.put(HomeController());

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TrendingRestaurantCard(
                    restaurant: restaurant,
                    onFilterTap: () {
                      final filters = controller.getAllFilters(restaurant);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) =>
                            HomeFilterBottomsheet(filters: filters),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // body: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //   child: ListView.builder(
      //     physics: BouncingScrollPhysics(),
      //     itemCount: restaurants.length,
      //     itemBuilder: (context, index) {
      //       final restaurant = restaurants[index];
      //       return GestureDetector(
      //         onTap: () => Get.to(
      //           RestaurantDetailScreen(restaurantModel: restaurant),
      //           transition: Transition.rightToLeft,
      //         ),
      //         child: Container(
      //           margin: EdgeInsets.only(bottom: 20),
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(12),
      //             color: Colors.white,
      //             boxShadow: [
      //               BoxShadow(
      //                 color: Colors.black.withOpacity(0.1),
      //                 blurRadius: 10,
      //                 offset: Offset(0, 4),
      //               ),
      //             ],
      //           ),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               ClipRRect(
      //                 borderRadius:
      //                     BorderRadius.vertical(top: Radius.circular(12)),
      //                 child: Image.network(
      //                   restaurant.logoImage,
      //                   height: 180,
      //                   width: double.infinity,
      //                   fit: BoxFit.cover,
      //                   loadingBuilder: (context, child, loadingProgress) {
      //                     if (loadingProgress == null) return child;
      //                     return Container(
      //                       height: 180,
      //                       color: Colors.grey[200],
      //                       child: Center(
      //                         child: CircularProgressIndicator(
      //                           value: loadingProgress.expectedTotalBytes !=
      //                                   null
      //                               ? loadingProgress.cumulativeBytesLoaded /
      //                                   loadingProgress.expectedTotalBytes!
      //                               : null,
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                   errorBuilder: (context, error, stackTrace) => Container(
      //                     height: 180,
      //                     color: Colors.grey[200],
      //                     child: Icon(Icons.error_outline, color: Colors.grey),
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: EdgeInsets.all(16),
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Text(
      //                       restaurant.resName,
      //                       style: TextStyle(
      //                         fontSize: 14,
      //                         fontWeight: FontWeight.bold,
      //                         color: AppColors.primaryColor,
      //                         fontFamily: 'aftika-regular',
      //                       ),
      //                     ),
      //                     SizedBox(height: 8),
      //                     Row(
      //                       children: [
      //                         Icon(
      //                           Icons.location_on,
      //                           size: 16,
      //                           color: AppColors.primaryColor.withOpacity(0.7),
      //                         ),
      //                         SizedBox(width: 8),
      //                         Expanded(
      //                           child: Text(
      //                             restaurant.address,
      //                             style: TextStyle(
      //                               fontSize: 14,
                                   
      //                               color: AppColors.bottomSheetColor,
      //                               fontFamily: 'aftika-regular',
      //                             ),
      //                             overflow: TextOverflow.ellipsis,
      //                             maxLines: 2,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
