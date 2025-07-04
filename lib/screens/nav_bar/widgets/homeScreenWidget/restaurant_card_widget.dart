import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';
 // Your AppColors file

class TrendingRestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final Function()? onFilterTap;

  const TrendingRestaurantCard({
    Key? key,
    required this.restaurant,
    this.onFilterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(RestaurantDetailScreen(restaurantModel: restaurant));
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              restaurant.logoImage,
              height: 290,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          if (restaurant.distanceInMiles != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.primaryColor.withOpacity(0.5),
                          AppColors.primaryColor.withOpacity(0.5),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.resName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'NunitoSans-Bold',
                          ),
                        ),
                        Text(
                          restaurant.address,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'NunitoSans-Regular',
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${restaurant.distanceInMiles!.toStringAsFixed(1)} mi',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontFamily: 'NunitoSans-Regular',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Buttons (filter + direction)
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
                // Filter Button
                GestureDetector(
                  onTap: onFilterTap,
                  child: const Image(
                    image: AssetImage("assets/images/filter.png"),
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(height: 8),

                // Direction Button
                GestureDetector(
                  onTap: () async {
                    final lat = restaurant.latitude;
                    final lng = restaurant.longitude;
                    final name = Uri.encodeComponent(restaurant.resName);

                    final googleMapsUrl =
                        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_name=$name';

                    try {
                      if (await canLaunch(googleMapsUrl)) {
                        await launch(googleMapsUrl);
                      } else {
                        final fallback =
                            'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                        await launch(fallback);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch maps: $e')),
                      );
                    }
                  },
                  child: const Image(
                    image: AssetImage("assets/images/direction.png"),
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
