import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../home_screen/home_controller/home_location_controller.dart';
import '../controller/search_controller.dart';
import '../restaurant_detail_screens/restaurant_detail_screen.dart';
import '../../../constants/app_colors.dart';
import '../../../models/resaturant_model.dart';
import 'discover_controller.dart';


class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({Key? key}) : super(key: key);

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  final TextEditingController searchController = TextEditingController();
  final HomeLocationController controller = Get.find<HomeLocationController>();
  final RestaurantController restaurantCtrl = Get.find<RestaurantController>();
  final FilterController filterCtrl = Get.find<FilterController>(); // NEW: Find the shared FilterController instance to access category filters
  final RxBool isLoading = false.obs;

  final RxInt selectedDistance = 0.obs;
  final RxList<RestaurantModel> categoryFilteredRestaurants = <RestaurantModel>[].obs; // NEW: RxList to hold the category-filtered restaurants from the stream
  final RxList<RestaurantModel> displayedRestaurants = <RestaurantModel>[].obs; // NEW: RxList to hold the final list after applying local search and distance

  @override
  void initState() {
    super.initState();
    // REMOVED: Old searchController listener and direct stream setup
    // NEW: Listen to the category-filtered stream from HomeLocationController
    // This stream provides restaurants filtered only by categories (Time, Cuisines, Dietary, Vibes, Experience)
    controller.getFilteredRestaurants().listen((list) {
      categoryFilteredRestaurants.value = list;
      applyLocalFilters(); // Apply local search and distance immediately
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = true;
      Future.delayed(const Duration(seconds: 1), () {
        applyLocalFilters();
        isLoading.value = false;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // NEW: Method to apply local filters (search by name and distance) to the category-filtered list
  // This is called whenever the category stream emits, or when local search/distance changes
  void applyLocalFilters() {
    var filtered = categoryFilteredRestaurants.toList();

    // Apply search query (local to RestaurantsPage)
    if (searchController.text.isNotEmpty) {
      final query = searchController.text.toLowerCase();
      filtered = filtered
          .where((restaurant) => restaurant.resName.toLowerCase().contains(query))
          .toList();
    }

    // Apply distance filter (local to RestaurantsPage)
    if (selectedDistance.value > 0 && controller.userPosition != null) {
      final maxDistanceKm = selectedDistance.value * 1.60934; // Convert miles to km
      filtered = filtered.where((restaurant) {
        if (restaurant.latitude == 0.0 && restaurant.longitude == 0.0) {
          return false;
        }
        final distance = Geolocator.distanceBetween(
          controller.userPosition!.latitude,
          controller.userPosition!.longitude,
          restaurant.latitude,
          restaurant.longitude,
        ) / 1000; // Distance in km
        return distance <= maxDistanceKm;
      }).toList();
    }

    displayedRestaurants.value = filtered;
  }

  // MODIFIED: Updated _buildSearchBar to trigger applyLocalFilters on submit
  Widget _buildSearchBar() {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              spreadRadius: 0,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search for restaurants',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
                onSubmitted: (value) {
                  isLoading.value = true; // Show loading during "processing"
                  applyLocalFilters();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    isLoading.value = false;
                  });
                },
              ),
            ),
            DropdownButtonHideUnderline(
              child: Obx(
                    () => DropdownButton2<String>(
                  buttonStyleData: ButtonStyleData(
                    width: 55,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    width: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  hint: Text(
                    'miles',
                    style: const TextStyle(fontSize: 14),
                  ),
                  value: selectedDistance.value == 0
                      ? 'All'
                      : selectedDistance.value.toString() + ' mi',
                  items: controller.distanceOptions
                      .map((ele) => DropdownMenuItem(
                    value: ele,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        ele,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ))
                      .toList(),
                  onChanged: (val) {
                    if (val == 'All') {
                      selectedDistance.value = 0;
                    } else {
                      selectedDistance.value =
                          int.parse(val!.replaceAll(' mi', ''));
                    }
                    isLoading.value = true; // Show loading during "processing"
                    applyLocalFilters();
                    Future.delayed(const Duration(milliseconds: 500), () {
                      isLoading.value = false;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 83,
          width: 362,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9.0),
            border: Border.all(color: Colors.grey[300]!),
          ),
        ),
      ),
    );
  }

  // MODIFIED: Updated build method to use Obx on displayedRestaurants instead of direct StreamBuilder
  // The StreamBuilder is removed; now we rely on the listener in initState for real-time updates from categories
  // Local filters are applied reactively via applyLocalFilters
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Center(child: Text('Restaurants in the area')),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSearchBar(),
          ),
          const SizedBox(height: 18.0),
          Expanded(
            child: Obx(() {
              if (isLoading.value) {
                return _buildShimmer();
              }
              if (displayedRestaurants.isEmpty) {
                return const Center(child: Text('No restaurants available'));
              }

              final restaurants = displayedRestaurants;
              return Obx(() {
                final favoriteIds = restaurantCtrl.bookmarkedIds.toSet();
                return ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    final isBookmarked = favoriteIds.contains(restaurant.docID);
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => RestaurantDetailScreen(restaurantModel: restaurant));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                          ),
                          border: Border.all(color: AppColors.borderColor),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 16,
                                spreadRadius: 0,
                                offset: Offset(0, 4))
                          ],
                        ),
                        child: SizedBox(
                          height: 84,
                          child: Row(
                            children: [
                              ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: controller.buildImage(
                                  restaurant.logoImage.isNotEmpty
                                      ? restaurant.logoImage
                                      : 'assets/images/event_img5.png',
                                  width: 124,
                                  height: 84,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              restaurant.resName.isNotEmpty
                                                  ? restaurant.resName
                                                  : 'Unknown Restaurant',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              restaurantCtrl.toggleBookmark(restaurant.docID);
                                            },
                                            child: Icon(
                                              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                              color: isBookmarked ? Colors.green : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      FutureBuilder<Map<String, Map<String, Map<String, dynamic>>>?>(
                                        future: controller.getOperatingHours2(restaurant.docID),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text(
                                              'Loading...',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                                color: Colors.black,
                                              ),
                                            );
                                          }
                                          final operatingHours = snapshot.data;
                                          final currentDay = DateFormat('EEEE').format(DateTime.now());
                                          final timeOfDay = 'Dinner';
                                          final dayHours = operatingHours?[currentDay] ?? null;

                                          String time = '';
                                          if (dayHours == null) {
                                            time = 'Unavailable';
                                          } else {
                                            final isClosed = dayHours[timeOfDay]?['isClosed'] ?? true;
                                            final startTime = dayHours[timeOfDay]?['startTime'] ?? '6:00 PM';
                                            final endTime = dayHours[timeOfDay]?['endTime'] ?? '9:00 PM';
                                            time = isClosed ? 'Closed' : '$startTime–$endTime';
                                          }

                                          return Text(
                                            time,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: const Color.fromRGBO(142, 142, 147, 1),
                                              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          );
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                'assets/images/Icon (1).png',
                                                width: 15,
                                                height: 13,
                                              ),
                                              FutureBuilder<double>(
                                                future: controller.getCurrentLocation(context).then((position) =>
                                                Geolocator.distanceBetween(
                                                  position.latitude,
                                                  position.longitude,
                                                  restaurant.latitude,
                                                  restaurant.longitude,
                                                ) / 1000),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Text(
                                                      'Calculating...',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                                        color: const Color.fromRGBO(142, 142, 147, 1),
                                                      ),
                                                    );
                                                  }
                                                  return Text(
                                                    snapshot.hasData
                                                        ? '${snapshot.data!.toStringAsFixed(1)} km away'
                                                        : 'Unknown',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                                      color: const Color.fromRGBO(142, 142, 147, 1),
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(width: 24),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                'assets/images/Group (5).png',
                                                width: 15,
                                                height: 15,
                                              ),
                                              const SizedBox(width: 4),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              });
            }),
          ),
        ],
      ),
    );
  }
}


// class RestaurantsPage extends StatefulWidget {
//   const RestaurantsPage({Key? key}) : super(key: key);
//
//   @override
//   State<RestaurantsPage> createState() => _RestaurantsPageState();
// }
//
// class _RestaurantsPageState extends State<RestaurantsPage> {
//   final TextEditingController searchController = TextEditingController();
//   final HomeLocationController controller = Get.find<HomeLocationController>();
//   final RestaurantController restaurantCtrl = Get.find<RestaurantController>();
//   final RxBool isLoading = false.obs;
//
//   final RxInt selectedDistance = 0.obs;
//   final Rx<Stream<List<RestaurantModel>>> filteredRestaurantsStream = Rx<Stream<List<RestaurantModel>>>(Stream.value([]));
//
//   @override
//   void initState() {
//     super.initState();
//     // searchController.addListener(() {
//     //   isLoading.value = true;
//     //   Future.delayed(const Duration(milliseconds: 500), () {
//     //     filterRestaurantsByNameAndDistance();
//     //     isLoading.value = false;
//     //   });
//     // });
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       isLoading.value = true;
//       Future.delayed(const Duration(seconds: 1), () {
//         filterRestaurantsByNameAndDistance();
//         isLoading.value = false;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   void filterRestaurantsByNameAndDistance() {
//     filteredRestaurantsStream.value = FirebaseFirestore.instance
//         .collection('restaurants')
//         .snapshots()
//         .map((snapshot) {
//       var restaurants = snapshot.docs
//           .map((doc) => RestaurantModel.fromDocumentSnapshot(doc))
//           .toList();
//
//       // Filter by restaurant name
//       if (searchController.text.isNotEmpty) {
//         final query = searchController.text.toLowerCase();
//         restaurants = restaurants
//             .where((restaurant) => restaurant.resName.toLowerCase().contains(query))
//             .toList();
//       }
//
//       // Filter by distance
//       if (selectedDistance.value > 0 && controller.userPosition != null) {
//         final maxDistanceKm = selectedDistance.value * 1.60934; // Convert miles to kilometers
//         restaurants = restaurants.where((restaurant) {
//           if (restaurant.latitude == 0.0 && restaurant.longitude == 0.0) {
//             return false;
//           }
//           final distance = Geolocator.distanceBetween(
//             controller.userPosition!.latitude,
//             controller.userPosition!.longitude,
//             restaurant.latitude,
//             restaurant.longitude,
//           ) / 1000; // Distance in kilometers
//           return distance <= maxDistanceKm;
//         }).toList();
//       }
//
//       return restaurants;
//     });
//   }
//
//   Widget _buildSearchBar() {
//     return Material(
//       elevation: 0,
//       borderRadius: BorderRadius.circular(30),
//       child: Container(
//         height: 48,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 16,
//               spreadRadius: 0,
//               offset: Offset(0, 4),
//             )
//           ],
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.search, size: 24),
//             const SizedBox(width: 8),
//             Expanded(
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search for restaurants',
//                   border: InputBorder.none,
//                   hintStyle: TextStyle(color: Colors.grey[600]),
//                 ),
//                 onSubmitted: (value) {
//                   filterRestaurantsByNameAndDistance();
//                 },
//               ),
//             ),
//             DropdownButtonHideUnderline(
//               child: Obx(
//                     () => DropdownButton2<String>(
//                   buttonStyleData: ButtonStyleData(
//                     width: 55,
//                   ),
//                   dropdownStyleData: DropdownStyleData(
//                     width: 65,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   hint: Text(
//                     'miles',
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                   value: selectedDistance.value == 0
//                       ? 'All'
//                       : selectedDistance.value.toString() + ' mi',
//                   items: controller.distanceOptions
//                       .map((ele) => DropdownMenuItem(
//                     value: ele,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: Text(
//                         ele,
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ),
//                   ))
//                       .toList(),
//                   onChanged: (val) {
//                     if (val == 'All') {
//                       selectedDistance.value = 0;
//                     } else {
//                       selectedDistance.value =
//                           int.parse(val!.replaceAll(' mi', ''));
//                     }
//                     isLoading.value = true;
//                     Future.delayed(const Duration(milliseconds: 500), () {
//                       filterRestaurantsByNameAndDistance();
//                       isLoading.value = false;
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildShimmer() {
//     return ListView.builder(
//       itemCount: 3,
//       itemBuilder: (context, index) => Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[100]!,
//         child: Container(
//           height: 83,
//           width: 362,
//           margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(9.0),
//             border: Border.all(color: Colors.grey[300]!),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         title: const Center(child: Text('Restaurants in the area')),
//         leading: const BackButton(),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: _buildSearchBar(),
//           ),
//           const SizedBox(height: 18.0),
//           Expanded(
//             child: Obx(() {
//               return StreamBuilder<List<RestaurantModel>>(
//                 stream: filteredRestaurantsStream.value,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting || isLoading.value) {
//                     return _buildShimmer();
//                   }
//                   if (snapshot.hasError) {
//                     return const Center(child: Text('Error loading restaurants'));
//                   }
//                   if (snapshot.data == null || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No restaurants available'));
//                   }
//
//                   final restaurants = snapshot.data!;
//                   return Obx(() {
//                     final favoriteIds = restaurantCtrl.bookmarkedIds.toSet();
//                     return ListView.builder(
//                       itemCount: restaurants.length,
//                       itemBuilder: (context, index) {
//                         final restaurant = restaurants[index];
//                         final isBookmarked = favoriteIds.contains(restaurant.docID);
//                         return GestureDetector(
//                           onTap: () {
//                             Get.to(() => RestaurantDetailScreen(restaurantModel: restaurant));
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(10),
//                               ),
//                               border: Border.all(color: AppColors.borderColor),
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: Colors.black.withOpacity(0.04),
//                                     blurRadius: 16,
//                                     spreadRadius: 0,
//                                     offset: Offset(0, 4))
//                               ],
//                             ),
//                             child: SizedBox(
//                               height: 84,
//                               child: Row(
//                                 children: [
//                                   ClipRRect(
//                                     clipBehavior: Clip.hardEdge,
//                                     borderRadius: const BorderRadius.only(
//                                       topLeft: Radius.circular(10),
//                                       topRight: Radius.circular(10),
//                                     ),
//                                     child: controller.buildImage(
//                                       restaurant.logoImage.isNotEmpty
//                                           ? restaurant.logoImage
//                                           : 'assets/images/event_img5.png',
//                                       width: 124,
//                                       height: 84,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Expanded(
//                                                 child: Text(
//                                                   restaurant.resName.isNotEmpty
//                                                       ? restaurant.resName
//                                                       : 'Unknown Restaurant',
//                                                   style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight: FontWeight.w700,
//                                                     fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                                   ),
//                                                   maxLines: 1,
//                                                   overflow: TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   restaurantCtrl.toggleBookmark(restaurant.docID);
//                                                 },
//                                                 child: Icon(
//                                                   isBookmarked ? Icons.bookmark : Icons.bookmark_border,
//                                                   color: isBookmarked ? Colors.green : Colors.grey,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           FutureBuilder<Map<String, Map<String, Map<String, dynamic>>>?>(
//                                             future: controller.getOperatingHours2(restaurant.docID),
//                                             builder: (context, snapshot) {
//                                               if (snapshot.connectionState == ConnectionState.waiting) {
//                                                 return Text(
//                                                   'Loading...',
//                                                   style: TextStyle(
//                                                     fontSize: 12,
//                                                     fontWeight: FontWeight.w500,
//                                                     fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                                     color: Colors.black,
//                                                   ),
//                                                 );
//                                               }
//                                               final operatingHours = snapshot.data;
//                                               final currentDay = DateFormat('EEEE').format(DateTime.now());
//                                               final timeOfDay = 'Dinner';
//                                               final dayHours = operatingHours?[currentDay] ?? null;
//
//                                               String time = '';
//                                               if (dayHours == null) {
//                                                 time = 'Unavailable';
//                                               } else {
//                                                 final isClosed = dayHours[timeOfDay]?['isClosed'] ?? true;
//                                                 final startTime = dayHours[timeOfDay]?['startTime'] ?? '6:00 PM';
//                                                 final endTime = dayHours[timeOfDay]?['endTime'] ?? '9:00 PM';
//                                                 time = isClosed ? 'Closed' : '$startTime–$endTime';
//                                               }
//
//                                               return Text(
//                                                 time,
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   color: const Color.fromRGBO(142, 142, 147, 1),
//                                                   fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                           Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Image.asset(
//                                                     'assets/images/Icon (1).png',
//                                                     width: 15,
//                                                     height: 13,
//                                                   ),
//                                                   FutureBuilder<double>(
//                                                     future: controller.getCurrentLocation(context).then((position) =>
//                                                     Geolocator.distanceBetween(
//                                                       position.latitude,
//                                                       position.longitude,
//                                                       restaurant.latitude,
//                                                       restaurant.longitude,
//                                                     ) / 1000),
//                                                     builder: (context, snapshot) {
//                                                       if (snapshot.connectionState == ConnectionState.waiting) {
//                                                         return Text(
//                                                           'Calculating...',
//                                                           style: TextStyle(
//                                                             fontSize: 12,
//                                                             fontWeight: FontWeight.w500,
//                                                             fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                                             color: const Color.fromRGBO(142, 142, 147, 1),
//                                                           ),
//                                                         );
//                                                       }
//                                                       return Text(
//                                                         snapshot.hasData
//                                                             ? '${snapshot.data!.toStringAsFixed(1)} km away'
//                                                             : 'Unknown',
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight: FontWeight.w500,
//                                                           fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                                           color: const Color.fromRGBO(142, 142, 147, 1),
//                                                         ),
//                                                       );
//                                                     },
//                                                   ),
//                                                   const SizedBox(width: 24),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Image.asset(
//                                                     'assets/images/Group (5).png',
//                                                     width: 15,
//                                                     height: 15,
//                                                   ),
//                                                   const SizedBox(width: 4),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   });
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }









// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:kaistable_website/models/resaturant_model.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../../constants/app_colors.dart';
// import '../../home_screen/home_controller/home_location_controller.dart';
// import '../controller/search_controller.dart';
// import '../restaurant_detail_screens/restaurant_detail_screen.dart';
// import 'discover_controller.dart';
//
// class RestaurantsPage extends StatefulWidget {
//   const RestaurantsPage({Key? key}) : super(key: key);
//
//   @override
//   State<RestaurantsPage> createState() => _RestaurantsPageState();
// }
//
// class _RestaurantsPageState extends State<RestaurantsPage> {
//   final TextEditingController searchController = TextEditingController();
//   final HomeLocationController controller = Get.find<HomeLocationController>();
//   final FilterController filterCtrl = Get.find<FilterController>();
//   final RestaurantController restaurantCtrl = Get.find<RestaurantController>();
//
//   @override
//   void initState() {
//     super.initState();
//     searchController.addListener(() {
//       controller.filterRestaurants(searchController.text);
//     });
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   Widget _buildSearchBar() {
//     return Material(
//       elevation: 0,
//       borderRadius: BorderRadius.circular(30),
//       child: Container(
//         height: 48,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 16,
//               spreadRadius: 0,
//               offset: Offset(0, 4),
//             )
//           ]
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.search, size: 24),
//             const SizedBox(width: 8),
//             Expanded(
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search for restaurant',
//                   border: InputBorder.none,
//                   hintStyle: TextStyle(color: Colors.grey[600]),
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {},
//               child: const Icon(Icons.arrow_drop_down, size: 24),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildShimmer() {
//     return ListView.builder(
//       itemCount: 3,
//       itemBuilder: (context, index) => Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[100]!,
//         child: Container(
//           height: 83,
//           width: 362,
//           margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(9.0),
//             border: Border.all(color: Colors.grey[300]!),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         title: const Center(child: Text('Restaurants in the area')),
//         leading: const BackButton(),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: _buildSearchBar(),
//           ),
//           const SizedBox(height: 18.0),
//           Expanded(
//             child: Obx(() {
//               return StreamBuilder<List<RestaurantModel>>(
//                 stream: filterCtrl.selectedFilters.values.any((list) => list.isNotEmpty)
//                     ? controller.getFilteredRestaurants()
//                     : controller.getAllRestaurants(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return _buildShimmer();
//                   }
//                   if (snapshot.hasError) {
//                     return const Center(child: Text('Error loading restaurants'));
//                   }
//                   if (snapshot.data == null || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No restaurants available'));
//                   }
//
//                   final restaurants = controller.filteredRestaurants.isNotEmpty
//                       ? controller.filteredRestaurants
//                       : snapshot.data!;
//                   return Obx(() {
//                     final favoriteIds = restaurantCtrl.bookmarkedIds.toSet();
//                     return ListView.builder(
//                       itemCount: restaurants.length,
//                       itemBuilder: (context, index) {
//                         final restaurant = restaurants[index];
//                         final isBookmarked = favoriteIds.contains(restaurant.docID);
//                         return GestureDetector(
//                           onTap: (){
//                             Get.to(()=>RestaurantDetailScreen(restaurantModel: restaurant));
//                           },
//                           child: Container(
//                             // elevation: 0,
//                             margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: BoxBorder.fromBorderSide(BorderSide(color: AppColors.borderColor, width: 1),),
//                               borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                           ),
//                               boxShadow: [
//                                 BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, spreadRadius: 0, offset: Offset(0, 4))
//                               ]
//                               // side: BorderSide(color: AppColors.borderColor, width: 1),
//                             ),
//                             child: SizedBox(
//                               height: 84,
//                               child: Row(
//                                 children: [
//                                   ClipRRect(
//                                     clipBehavior: Clip.hardEdge,
//                                     borderRadius: const BorderRadius.only(
//                                       topLeft: Radius.circular(10),
//                                       topRight: Radius.circular(10),
//                                     ),
//                                     child:
//                                     controller.buildImage(
//                                       restaurant.logoImage.isNotEmpty
//                                           ? restaurant.logoImage
//                                           : 'assets/images/event_img5.png',
//                                       width: 124,
//                                       height: 84,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Expanded(
//                                                 child: Text(
//                                                   restaurant.resName.isNotEmpty
//                                                       ? restaurant.resName
//                                                       : 'Unknown Restaurant',
//                                                   style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight: FontWeight.w700,
//                                                     fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                                   ),
//                                                   maxLines: 1,
//                                                   overflow: TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   restaurantCtrl.toggleBookmark(restaurant.docID);
//                                                 },
//                                                 child: Icon(
//                                                   isBookmarked ? Icons.bookmark : Icons.bookmark_border,
//                                                   color: isBookmarked ? Colors.green : Colors.grey,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           FutureBuilder<Map<String, dynamic>?>(
//                                             future: controller.getOperatingHours1(restaurant.docID),
//                                             builder: (context, snapshot) {
//                                               if (snapshot.connectionState == ConnectionState.waiting) {
//                                                 return Text(
//                                                   'Loading...',
//                                                   style: TextStyle(
//                                                     fontSize: 12,
//                                                     fontWeight: FontWeight.w500,
//                                                     fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                                     color: Colors.black,
//                                                   ),
//                                                 );
//                                               }
//                                               final timeOfDay = filterCtrl.selectedFilters['Time']?.isNotEmpty ?? false
//                                                   ? filterCtrl.selectedFilters['Time']!.first
//                                                   : 'Dinner';
//                                               final operatingHours = snapshot.data;
//                                               final isClosed = operatingHours?[timeOfDay]?['isClosed'] ?? true;
//                                               return Text(
//                                                 isClosed ? 'Closed' : operatingHours?[timeOfDay]?['hours'] ?? '6PM-9PM',
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                                   color: Colors.black,
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                           Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Image.asset(
//                                                     'assets/images/Icon (1).png',
//                                                     width: 15,
//                                                     height: 13,
//                                                   ),
//                                                   FutureBuilder<double>(
//                                                     future: controller.getCurrentLocation(context).then((position) =>
//                                                     Geolocator.distanceBetween(
//                                                       position.latitude,
//                                                       position.longitude,
//                                                       restaurant.latitude,
//                                                       restaurant.longitude,
//                                                     ) / 1000),
//                                                     builder: (context, snapshot) {
//                                                       if (snapshot.connectionState == ConnectionState.waiting) {
//                                                         return Text(
//                                                           'Calculating...',
//                                                           style: TextStyle(
//                                                             fontSize: 12,
//                                                             fontWeight: FontWeight.w500,
//                                                             fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                                             color: const Color.fromRGBO(142, 142, 147, 1),
//                                                           ),
//                                                         );
//                                                       }
//                                                       return Text(
//                                                         snapshot.hasData
//                                                             ? '${snapshot.data!.toStringAsFixed(1)} km away'
//                                                             : 'Unknown',
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           fontWeight: FontWeight.w500,
//                                                           fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                                           color: const Color.fromRGBO(142, 142, 147, 1),
//                                                         ),
//                                                       );
//                                                     },
//                                                   ),
//                                                   const SizedBox(width: 24),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Image.asset(
//                                                     'assets/images/Group (5).png',
//                                                     width: 15,
//                                                     height: 15,
//                                                   ),
//                                                   const SizedBox(width: 4),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   });
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }