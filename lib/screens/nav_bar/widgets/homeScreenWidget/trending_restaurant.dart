// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kaistable_website/constants/app_colors.dart';
// import 'package:kaistable_website/models/resaturant_model.dart';
// import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';

// class TrendingRestaurantsPage extends StatelessWidget {
//   final List<RestaurantModel> restaurants;

//   const TrendingRestaurantsPage({Key? key, required this.restaurants}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Trending Restaurants',),
//       ),
//       body: ListView.builder(
//         padding: EdgeInsets.all(12),
//         itemCount: restaurants.length,
//         itemBuilder: (context, index) {
//           final restaurant = restaurants[index];
//           return GestureDetector(
//             onTap: () => Get.to(RestaurantDetailScreen(restaurantModel: restaurant)),
//             child: Container(
//               margin: EdgeInsets.only(bottom: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 200,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       image: DecorationImage(
//                         image: NetworkImage(restaurant.logoImage),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     restaurant.resName,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primaryColor,
//                       fontFamily: 'aftika-bold',
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Icon(Icons.location_on, size: 16,color: AppColors.primaryColor,),
//                       SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           restaurant.address,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';

class TrendingRestaurantsPage extends StatelessWidget {
  final List<RestaurantModel> filteredRestaurants;
  final List<String> activeVibes;
  final List<String> activeExperiences;
  final List<String> activeCuisines;

  const TrendingRestaurantsPage({
    Key? key,
    required this.filteredRestaurants,
    this.activeVibes = const [],
    this.activeExperiences = const [],
    this.activeCuisines = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trending Restaurants',
          style: TextStyle(
            color: AppColors.bottomSheetColor,
            fontFamily: 'NunitoSans-Bold',
            fontSize: 18,
            fontWeight: FontWeight.w700,
           
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      body: Column(
        children: [
          // Display active filters

          // Restaurant list
          Expanded(
            child: filteredRestaurants.isEmpty
                ? Center(
                    child: Text(
                      'No restaurants match your filters',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontFamily: 'aftika-regular',
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filteredRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = filteredRestaurants[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Restaurant image
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                restaurant.logoImage,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Restaurant info
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant.resName,
                                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'NunitoSans-Bold',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                     
                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: AppColors.primaryColor,
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          restaurant.address,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            fontFamily: 'aftika-regular',
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
