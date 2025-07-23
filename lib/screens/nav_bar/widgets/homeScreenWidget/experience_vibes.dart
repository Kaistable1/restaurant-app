// import 'package:flutter/material.dart';

// class ExperienceVibesGrid extends StatelessWidget {
//   final List<VibeItem> vibeItems = [
//     VibeItem(title: 'DJ Night', image: 'assets/images/dj_night.jpg'),
//     VibeItem(title: 'Live Music', image: 'assets/images/live_music.jpg'),
//     VibeItem(title: 'Candlelight setup', image: 'assets/images/candle_light.jpg'),
//     VibeItem(title: 'Cozy cafes', image: 'assets/images/cozy_setup.jpg'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Header Section
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Experience & Vibes',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'More than meals — these places are designed to impress. Vibes, views, and experiences you won\'t forget.',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Grid View Section
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: GridView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               childAspectRatio: 0.8,
//             ),
//             itemCount: vibeItems.length,
//             itemBuilder: (context, index) {
//               return _buildVibeCard(vibeItems[index]);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildVibeCard(VibeItem item) {
//     return Stack(
//       children: [
//         // Image Container
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             image: DecorationImage(
//               image: AssetImage(item.image),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),

//         // Orange Circle
//         Positioned(
//           top: 8,
//           right: 8,
//           child: Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: Colors.orange,
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 2),
//             ),
//             child: Center(
//               child: Text(
//                 '25%', // You can replace with dynamic value
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//         ),

//         // Title at bottom
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.6),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(12),
//                 bottomRight: Radius.circular(12),
//               ),
//             ),
//             child: Text(
//               item.title,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class VibeItem {
//   final String title;
//   final String image;

//   VibeItem({required this.title, required this.image});
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/all_restaurant_screen.dart';

class ExperienceVibesGrid extends StatefulWidget {
  final List<RestaurantModel> allRestaurants;
  ExperienceVibesGrid({Key? key, required this.allRestaurants})
      : super(key: key);

  @override
  State<ExperienceVibesGrid> createState() => _ExperienceVibesGridState();
}

class _ExperienceVibesGridState extends State<ExperienceVibesGrid> {
  final List<VibeItem> vibeItems = [
    VibeItem(title: 'DJ Night', image: 'assets/images/dj_night.png'),
    VibeItem(title: 'Live Music', image: 'assets/images/live_music.png'),
    VibeItem(
        title: 'Candlelight Setup', image: 'assets/images/candel_light.png'),
    VibeItem(title: 'Cozy Cafes', image: 'assets/images/cozy_setup.png'),
  ];

  final List<Map<String, String>> items = const [
    {'label': 'DJ Night', 'type': 'experience', 'filter': 'Pet-Friendly'},
    {'label': 'Live Music', 'type': 'experience', 'filter': 'Rest room'},
    {'label': 'Candlelight Setup', 'type': 'vibe', 'filter': 'Casual Dining'},
    {'label': 'Cozy Cafes', 'type': 'vibe', 'filter': 'Fine Dining'},
  ];
  late List<bool> liked;

  @override
  void initState() {
    super.initState();
    liked = List.generate(vibeItems.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Experience & Vibes',
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontFamily: 'NunitoSans-Bold',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'More than meals — these places are designed to impress. Vibes, views, and experiences you won’t forget.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontFamily: 'NunitoSans-Regular',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        // Grid View
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: vibeItems.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final String type = item['type']!;

              return GestureDetector(
                  onTap: () {
                    final String filterValue = item['filter']!;
                    final filtered = widget.allRestaurants.where((restaurant) {
                      if (type == 'experience') {
                        return restaurant.facilityList.contains(filterValue);
                      } else if (type == 'vibe') {
                        return restaurant.atmosphereList.contains(filterValue);
                      }
                      return false;
                    }).toList();

                    Get.to(() => AllRestaurantsPage(restaurants: filtered));
                  },
                  child: _buildVibeCard(vibeItems[index], index));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVibeCard(VibeItem item, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(item.image, fit: BoxFit.cover),

          // Semi-transparent overlay for better text visibility
          Container(color: Colors.black.withOpacity(0.2)),

          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    liked[index] = !liked[index];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.blackColor
                        .withOpacity(0.75), // solid black background
                  ),
                  padding: const EdgeInsets.all(6), // adjust for size
                  child: Icon(
                    liked[index] ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white, // always white icon
                    size: 14, // match your design
                  ),
                )),
          ),

          // Bottom Title Button
          Positioned(
            bottom: 12,
            left: 12,
            //right: 12,
            child: Container(
              width: 120,
              height: 25,
              // padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.vibesCard,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'NunitoSans-Regular',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VibeItem {
  final String title;
  final String image;

  VibeItem({required this.title, required this.image});
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kaistable_website/constants/app_colors.dart';
// import 'package:kaistable_website/models/resaturant_model.dart';
// import 'package:kaistable_website/screens/nav_bar/widgets/homeScreenWidget/all_restaurant_screen.dart'; // Ensure this import is correct

// class ExperienceVibesGrid extends StatelessWidget {
//   final List<RestaurantModel> allRestaurants;

//   ExperienceVibesGrid({Key? key, required this.allRestaurants}) : super(key: key);

//   final List<Map<String, String>> items = const [
//     {'label': 'DJ Night', 'type': 'experience'},
//     {'label': 'Live Music', 'type': 'experience'},
//     {'label': 'Candlelight Setup', 'type': 'vibe'},
//     {'label': 'Cozy Cafes', 'type': 'vibe'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       physics: BouncingScrollPhysics(),
//       shrinkWrap: true,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 1.4,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//       ),
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         final item = items[index];
//         final String label = item['label']!;
//         final String type = item['type']!;

//         return GestureDetector(
//           onTap: () {
//             final filtered = allRestaurants.where((restaurant) {
//               if (type == 'experience') {
//                 return restaurant.facilityList.contains(label);
//               } else if (type == 'vibe') {
//                 return restaurant.atmosphereList.contains(label);
//               }
//               return false;
//             }).toList();

//             Get.to(() => AllRestaurantsPage(restaurants: filtered));
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               color: AppColors.primaryColor.withOpacity(0.1),
//               border: Border.all(color: AppColors.primaryColor),
//             ),
//             child: Center(
//               child: Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'aftika-regular',
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
