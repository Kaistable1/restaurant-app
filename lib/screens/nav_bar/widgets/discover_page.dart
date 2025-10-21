import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../main.dart';
import '../../../constants/app_colors.dart';
import '../../../models/discover_list_model.dart';
import '../discover_list_details/discover_list_details_screen.dart';

class DiscoverListsPage extends StatefulWidget {
  final bool fromHome;
  const DiscoverListsPage({Key? key, required this.fromHome}) : super(key: key);

  @override
  State<DiscoverListsPage> createState() => _DiscoverListsPageState();
}

class _DiscoverListsPageState extends State<DiscoverListsPage> {
  final RxBool isLoading = false.obs;

  // Fetch discover lists from Firestore
  Future<List<DiscoverListModel>> fetchDiscoverLists() async {
    try {
      isLoading.value = true;
      final snapshot = await FirebaseFirestore.instance.collection('discoverLists').get();
      final lists = snapshot.docs.map((doc) => DiscoverListModel.fromDocumentSnapshot(doc)).toList();
      isLoading.value = false;
      print('Fetched ${lists.length} discover lists');
      return lists;
    } catch (e) {
      isLoading.value = false;
      print('Error fetching discover lists: $e');
      Get.snackbar('Error', 'Failed to load discover lists: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return [];
    }
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 176,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          "Discover What's New",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => widget.fromHome ? Get.back() : navbarController.jumpToTab(0),
        ),
      ),
      body: FutureBuilder<List<DiscoverListModel>>(
        future: fetchDiscoverLists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || isLoading.value) {
            return _buildShimmer();
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading discover lists'));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No discover lists available'));
          }

          final discoverLists = snapshot.data!;
          return ListView.builder(
            itemCount: discoverLists.length,
            itemBuilder: (context, index) {
              final discoverList = discoverLists[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => DiscoverListDetailScreen(discoverListModel: discoverList));
                },
                child: Container(
                  height: 176,
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
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: SizedBox(
                          height: 176,
                          width: 124,
                          child: Image.network(
                            discoverList.image.isNotEmpty
                                ? discoverList.image
                                : 'assets/images/event_img5.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/event_img5.png',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Expanded(
                              //       child:
                          Text(
                                      discoverList.name.isNotEmpty
                                          ? discoverList.name
                                          : 'Unnamed List',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  // ),
                                  // const Icon(
                                  //   Icons.bookmark_border,
                                  //   color: Colors.grey,
                                  // ),
                              //   ],
                              // ),
                              Text(
                                discoverList.by.isNotEmpty
                                    ? 'by ${discoverList.by}'
                                    : 'by Savrli',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(),
                              // Text(
                              //   discoverList.description.isNotEmpty
                              //       ? discoverList.description
                              //       : 'No description',
                              //   style: TextStyle(
                              //     fontSize: 12,
                              //     fontWeight: FontWeight.w500,
                              //     fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                              //     color: const Color.fromRGBO(142, 142, 147, 1),
                              //   ),
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../main.dart';
// import '../../home_screen/home_controller/home_location_controller.dart';
// import '../controller/search_controller.dart';
// import '../restaurant_detail_screens/restaurant_detail_screen.dart';
// import '../../../constants/app_colors.dart';
// import '../../../models/restaurant_model.dart';
// import 'discover_controller.dart';
//
//
// class RestaurantsPage extends StatefulWidget {
//   bool fromHome = false;
//   RestaurantsPage({Key? key, required this.fromHome}) : super(key: key);
//
//   @override
//   State<RestaurantsPage> createState() => _RestaurantsPageState();
// }
//
// class _RestaurantsPageState extends State<RestaurantsPage> with WidgetsBindingObserver {
//   final TextEditingController searchController = TextEditingController();
//   final HomeLocationController controller = Get.find<HomeLocationController>();
//   final RestaurantController restaurantCtrl = Get.find<RestaurantController>();
//   final FilterController filterCtrl = Get.find<FilterController>(); // NEW: Find the shared FilterController instance to access category filters
//   final RxBool isLoading = false.obs;
//
//   final RxList<RestaurantModel> categoryFilteredRestaurants = <RestaurantModel>[].obs; // NEW: RxList to hold the category-filtered restaurants from the stream
//   final RxList<RestaurantModel> displayedRestaurants = <RestaurantModel>[].obs; // NEW: RxList to hold the final list after applying local search and distance
//
//   @override
//   void initState() {
//     super.initState();
//     // WidgetsBinding.instance.addObserver(this);
//     //
//     // if (controller.userPosition.value == null) {
//     //   controller.fetchUserPosition(context);
//     // }
//     //
//     // // This stream provides restaurants filtered only by categories (Time, Cuisines, Dietary, Vibes, Experience)
//     // controller.getFilteredRestaurants().listen((list) {
//     //   categoryFilteredRestaurants.value = list;
//     //   applyLocalFilters(); // Apply local search and distance immediately
//     // });
//     //
//     // // Explanation: For authenticated users, listen to Firestore stream; for unauthenticated, fetch from SharedPreferences.
//     // if (auth.currentUser != null) {
//     //   final userId = auth.currentUser!.uid;
//     //   FirebaseFirestore.instance
//     //       .collection('users')
//     //       .doc(userId)
//     //       .collection('favorite')
//     //       .snapshots()
//     //       // .distinct() // Avoid redundant updates
//     //       .listen((snapshot) async {
//     //     restaurantCtrl.favoriteIds.value = snapshot.docs.map((doc) => doc.id).toList();
//     //       final prefs = await SharedPreferences.getInstance();
//     //       prefs.setStringList('favorite_restaurants', restaurantCtrl.favoriteIds);
//     //     },
//     //     onError: (e) {
//     //       print('Error streaming favorite IDs: $e');
//     //       Get.snackbar('Error', 'Failed to load favorites: $e',
//     //           snackPosition: SnackPosition.BOTTOM);
//     //     },
//     //   );
//     // } else {
//     //   _fetchFavoriteIds();
//     // }
//     //
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   isLoading.value = true;
//     //   Future.delayed(const Duration(seconds: 1), () {
//     //     applyLocalFilters();
//     //     isLoading.value = false;
//     //   });
//     // });
//   }
//
//   @override
//   void dispose() {
//     // WidgetsBinding.instance.removeObserver(this);
//     searchController.dispose();
//     super.dispose();
//   }
//
//   // @override
//   // void didChangeAppLifecycleState(AppLifecycleState state) {
//   //   if (state == AppLifecycleState.resumed) {
//   //     Geolocator.isLocationServiceEnabled().then((enabled) {
//   //       if (enabled && controller.userPosition.value == null) {
//   //         controller.fetchUserPosition(context);
//   //       }
//   //     });
//   //   }
//   // }
//
//   // Explanation: Fetches favorite IDs from SharedPreferences for unauthenticated users.
//   // Future<void> _fetchFavoriteIds() async {
//   //   try {
//   //     final prefs = await SharedPreferences.getInstance();
//   //     restaurantCtrl.favoriteIds.value = prefs.getStringList('favorite_restaurants') ?? [];
//   //   } catch (e) {
//   //     print('Error fetching favorite IDs: $e');
//   //     Get.snackbar('Error', 'Failed to load favorites: $e',
//   //         snackPosition: SnackPosition.BOTTOM);
//   //   }
//   // }
//
//   // Explanation: Adds or removes a restaurant from favorites, updating favoriteIds reactively.
//   // Future<void> toggleFavoriteRestaurant(String restaurantId, bool isFavorited) async {
//   //   try {
//   //     if (isFavorited) {
//   //       // Remove from favorites
//   //       if (auth.currentUser != null) {
//   //         final userId = auth.currentUser!.uid;
//   //         await FirebaseFirestore.instance
//   //             .collection('users')
//   //             .doc(userId)
//   //             .collection('favorite')
//   //             .doc(restaurantId)
//   //             .delete();
//   //         print('Removed restaurant $restaurantId from Firestore favorites');
//   //       }
//   //         final prefs = await SharedPreferences.getInstance();
//   //         final favoriteIdsList = prefs.getStringList('favorite_restaurants') ?? [];
//   //         favoriteIdsList.remove(restaurantId);
//   //         await prefs.setStringList('favorite_restaurants', favoriteIdsList);
//   //         print('Removed restaurant $restaurantId from SharedPreferences');
//   //       restaurantCtrl.favoriteIds.remove(restaurantId); // Update RxList for unauthenticated users
//   //
//   //     } else {
//   //       // Add to favorites
//   //       if (auth.currentUser != null) {
//   //         final userId = auth.currentUser!.uid;
//   //         await FirebaseFirestore.instance
//   //             .collection('users')
//   //             .doc(userId)
//   //             .collection('favorite')
//   //             .doc(restaurantId)
//   //             .set({'restaurantID': restaurantId});
//   //         print('Added restaurant $restaurantId to Firestore favorites');
//   //       }
//   //         final prefs = await SharedPreferences.getInstance();
//   //         final favoriteIdsList = prefs.getStringList('favorite_restaurants') ?? [];
//   //         if (!favoriteIdsList.contains(restaurantId)) {
//   //           favoriteIdsList.add(restaurantId);
//   //           await prefs.setStringList('favorite_restaurants', favoriteIdsList);
//   //           print('Added restaurant $restaurantId to SharedPreferences');
//   //           restaurantCtrl.favoriteIds.add(restaurantId); // Update RxList for unauthenticated users
//   //         }
//   //
//   //     }
//   //   } catch (e) {
//   //     print('Error toggling favorite restaurant: $e');
//   //     Get.snackbar('Error', 'Failed to update favorite: $e',
//   //         snackPosition: SnackPosition.BOTTOM);
//   //   }
//   // }
//
//   // Method to apply local filters (search by name and distance) to the category-filtered list
//   // This is called whenever the category stream emits, or when local search/distance changes
//   // void applyLocalFilters() async {
//   //   var filtered = categoryFilteredRestaurants.toList();
//   //
//   //   // Apply search query
//   //   if (searchController.text.isNotEmpty) {
//   //     final query = searchController.text.toLowerCase();
//   //     filtered = filtered
//   //         .where((restaurant) => restaurant.resName.toLowerCase().contains(query))
//   //         .toList();
//   //   }
//   //
//   //   // Apply distance filter
//   //   if (controller.selectedDistance.value > 0 && controller.userPosition.value != null) {
//   //     final maxDistanceKm = controller.selectedDistance.value * 1.60934;
//   //     filtered = filtered.where((restaurant) {
//   //       if (restaurant.latitude == 0.0 && restaurant.longitude == 0.0) {
//   //         return false;
//   //       }
//   //       final distance = Geolocator.distanceBetween(
//   //         controller.userPosition.value!.latitude,
//   //         controller.userPosition.value!.longitude,
//   //         restaurant.latitude,
//   //         restaurant.longitude,
//   //       ) / 1000;
//   //       return distance <= maxDistanceKm;
//   //     }).toList();
//   //   }
//   //
//   //   // Sort by distance if user position is available
//   //   if (controller.userPosition.value != null) {
//   //     filtered.sort((a, b) {
//   //       if (a.latitude == 0.0 && a.longitude == 0.0) return 1;
//   //       if (b.latitude == 0.0 && b.longitude == 0.0) return -1;
//   //       final distanceA = Geolocator.distanceBetween(
//   //         controller.userPosition.value!.latitude,
//   //         controller.userPosition.value!.longitude,
//   //         a.latitude,
//   //         a.longitude,
//   //       );
//   //       final distanceB = Geolocator.distanceBetween(
//   //         controller.userPosition.value!.latitude,
//   //         controller.userPosition.value!.longitude,
//   //         b.latitude,
//   //         b.longitude,
//   //       );
//   //       return distanceA.compareTo(distanceB);
//   //     });
//   //   }
//   //
//   //   // Pre-fetch operating hours for all filtered restaurants
//   //   await Future.wait(filtered.map((restaurant) {
//   //     if (!controller.operatingHoursCache.containsKey(restaurant.docID)) {
//   //       return controller.getOperatingHours(restaurant.docID, triggerFilterUpdate: false);
//   //     }
//   //     return Future.value();
//   //   }));
//   //
//   //   displayedRestaurants.value = filtered;
//   // }
//
//   // MODIFIED: Updated _buildSearchBar to trigger applyLocalFilters on submit
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
//                   isLoading.value = true; // Show loading during "processing"
//                   // applyLocalFilters();
//                   Future.delayed(const Duration(milliseconds: 500), () {
//                     isLoading.value = false;
//                   });
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
//                   value: controller.selectedDistance.value == 0
//                       ? 'All'
//                       : controller.selectedDistance.value.toString() + ' mi',
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
//                       controller.selectedDistance.value = 0;
//                     } else {
//                       controller.selectedDistance.value =
//                           int.parse(val!.replaceAll(' mi', ''));
//                     }
//                     isLoading.value = true; // Show loading during "processing"
//                     // applyLocalFilters();
//                     Future.delayed(const Duration(milliseconds: 500), () {
//                       isLoading.value = false;
//                     });
//                     controller.applySearchAndFilters();
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
//   // Updated build method to use Obx on displayedRestaurants instead of direct StreamBuilder
//   // The StreamBuilder is removed; now we rely on the listener in initState for real-time updates from categories
//   // Local filters are applied reactively via applyLocalFilters
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         title: Text("Discover What's New" ,
//           style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),),
//         centerTitle: true,
//         leading: BackButton(
//           onPressed: () => widget.fromHome ? Get.back() : navbarController.jumpToTab(0),
//         ),
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
//               if (isLoading.value) {
//                 return _buildShimmer();
//               }
//               if (displayedRestaurants.isEmpty) {
//                 return const Center(child: Text('No restaurants available'));
//               }
//
//               final restaurants = displayedRestaurants;
//               return Obx(() {
//                 return ListView.builder(
//                   itemCount: restaurants.length,
//                   itemBuilder: (context, index) {
//                     final restaurant = restaurants[index];
//
//                     return Obx(
//                         (){
//                           final isBookmarked = restaurantCtrl.favoriteIds.contains(restaurant.docID).obs;
//                           return GestureDetector(
//                         onTap: () {
//                           Get.to(() => RestaurantDetailScreen(restaurantModel: restaurant));
//                         },
//                         child: Container(
//                           height: 176, // 88,
//                           margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(10),
//                             ),
//                             border: Border.all(color: AppColors.borderColor),
//                             boxShadow: [
//                               BoxShadow(
//                                   color: Colors.black.withOpacity(0.04),
//                                   blurRadius: 16,
//                                   spreadRadius: 0,
//                                   offset: Offset(0, 4))
//                             ],
//                           ),
//                           child: Row(
//                             children: [
//                               ClipRRect(
//                                 clipBehavior: Clip.hardEdge,
//                                 borderRadius: const BorderRadius.only(
//                                   topLeft: Radius.circular(10),
//                                   topRight: Radius.circular(10),
//                                 ),
//                                 child: SizedBox(
//                                   height: 176,
//                                   width: 124,
//                                   child: controller.buildImage(
//                                     restaurant.logoImage.isNotEmpty
//                                         ? restaurant.logoImage
//                                         : 'assets/images/event_img5.png',
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Expanded(
//                                             child: Text(
//                                               restaurant.resName.isNotEmpty
//                                                   ? restaurant.resName
//                                                   : 'Unknown Restaurant',
//                                               style: TextStyle(
//                                                 fontSize: 28,
//                                                 fontWeight: FontWeight.w700,
//                                                 fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                               ),
//                                             ),
//                                           ),
//                                           GestureDetector(
//                                             onTap: () {
//                                               // toggleFavoriteRestaurant(restaurant.docID, isBookmarked.value);
//                                               isBookmarked.toggle();
//                                             },
//                                             child: Obx(
//                                               ()=> Icon(
//                                                 isBookmarked.value ? Icons.bookmark : Icons.bookmark_border,
//                                                 color: isBookmarked.value ? Colors.green : Colors.grey,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Text(
//                                         restaurant.resName.isNotEmpty
//                                             ? restaurant.resName
//                                             : 'by Savrli',
//                                         style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w700,
//                                           fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                           color: Colors.black87
//                                         ),
//                                       ),
//                                       const SizedBox(),
//                                       // Obx(() {
//                                       //   final operatingHours = controller.operatingHoursCache[restaurant.docID];
//                                       //   final isFetching = controller.fetchingOperatingHours.contains(restaurant.docID);
//                                       //   final currentDay = DateFormat('EEEE').format(DateTime.now());
//                                       //   final timeFilter = filterCtrl.selectedFilters['Time'];
//                                       //
//                                       //   if (operatingHours == null || operatingHours[currentDay] == null) {
//                                       //     if (!isFetching) {
//                                       //       controller.getOperatingHours(restaurant.docID, triggerFilterUpdate: false);
//                                       //     }
//                                       //     return Text(
//                                       //       isFetching ? 'Loading...' : 'Unavailable',
//                                       //       style: TextStyle(
//                                       //         fontSize: 12,
//                                       //         fontWeight: FontWeight.w500,
//                                       //         fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                       //         color: const Color.fromRGBO(142, 142, 147, 1),
//                                       //       ),
//                                       //     );
//                                       //   }
//                                       //
//                                       //   if (operatingHours.isEmpty) {
//                                       //     return Text(
//                                       //       'Unavailable',
//                                       //       style: TextStyle(
//                                       //         fontSize: 12,
//                                       //         fontWeight: FontWeight.w500,
//                                       //         fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                       //         color: const Color.fromRGBO(142, 142, 147, 1),
//                                       //       ),
//                                       //     );
//                                       //   }
//                                       //
//                                       //   final dayHours = operatingHours[currentDay]!;
//                                       //   // Check if no time filter is selected
//                                       //   if (timeFilter == null || timeFilter.isEmpty) {
//                                       //     return Text(
//                                       //       controller.getFullDayHours(dayHours),
//                                       //       style: TextStyle(
//                                       //         fontSize: 12,
//                                       //         fontWeight: FontWeight.w500,
//                                       //         fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                       //         color: const Color.fromRGBO(142, 142, 147, 1),
//                                       //       ),
//                                       //     );
//                                       //   }
//                                       //
//                                       //   // Use selected time slot
//                                       //   final timeOfDay = timeFilter.first;
//                                       //   final isClosed = dayHours[timeOfDay]?['isClosed'] ?? true;
//                                       //   final startTime = dayHours[timeOfDay]?['startTime'] ?? '6:00 PM';
//                                       //   final endTime = dayHours[timeOfDay]?['endTime'] ?? '9:00 PM';
//                                       //   return Text(
//                                       //     isClosed ? 'Closed' : '$startTime–$endTime',
//                                       //     style: TextStyle(
//                                       //       fontSize: 12,
//                                       //       fontWeight: FontWeight.w500,
//                                       //       fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                       //       color: const Color.fromRGBO(142, 142, 147, 1),
//                                       //     ),
//                                       //   );
//                                       // }),
//                                       // Row(
//                                       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       //   children: [
//                                       //     Row(
//                                       //       mainAxisSize: MainAxisSize.min,
//                                       //       children: [
//                                       //         Image.asset(
//                                       //           'assets/images/Icon (1).png',
//                                       //           width: 15,
//                                       //           height: 13,
//                                       //         ),
//                                       //         // Replace the per-restaurant getCurrentLocation call with a shared positionFuture. This calculates distance only if position is available, showing 'Unknown' if location is disabled or error occurred, preventing multiple dialogs.
//                                       //         Obx(() {
//                                       //           final pos = controller.userPosition.value;
//                                       //           if (pos == null) {
//                                       //             return Text(
//                                       //               controller.isFetchingInitialData.value ? 'Fetching...' : 'Location disabled',
//                                       //               style: TextStyle(
//                                       //                 fontSize: 12,
//                                       //                 fontWeight: FontWeight.w500,
//                                       //                 fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                       //                 color: const Color.fromRGBO(142, 142, 147, 1),
//                                       //               ),
//                                       //             );
//                                       //           } else {
//                                       //             double distance = Geolocator.distanceBetween(
//                                       //               pos.latitude,
//                                       //               pos.longitude,
//                                       //               restaurant.latitude,
//                                       //               restaurant.longitude,
//                                       //             ) / 1000;
//                                       //             return Text(
//                                       //               '${distance.toStringAsFixed(1)} km away',
//                                       //               style: TextStyle(
//                                       //                 fontSize: 12,
//                                       //                 fontWeight: FontWeight.w500,
//                                       //                 fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//                                       //                 color: const Color.fromRGBO(142, 142, 147, 1),
//                                       //               ),
//                                       //             );
//                                       //           }
//                                       //         }),
//                                       //         const SizedBox(width: 24),
//                                       //       ],
//                                       //     ),
//                                       //     Row(
//                                       //       mainAxisSize: MainAxisSize.min,
//                                       //       children: [
//                                       //         Image.asset(
//                                       //           'assets/images/Group (5).png',
//                                       //           width: 15,
//                                       //           height: 15,
//                                       //         ),
//                                       //         const SizedBox(width: 4),
//                                       //       ],
//                                       //     ),
//                                       //   ],
//                                       // ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );},
//                     );
//                   },
//                 );
//               });
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// // class RestaurantsPage extends StatefulWidget {
// //   const RestaurantsPage({Key? key}) : super(key: key);
// //
// //   @override
// //   State<RestaurantsPage> createState() => _RestaurantsPageState();
// // }
// //
// // class _RestaurantsPageState extends State<RestaurantsPage> {
// //   final TextEditingController searchController = TextEditingController();
// //   final HomeLocationController controller = Get.find<HomeLocationController>();
// //   final RestaurantController restaurantCtrl = Get.find<RestaurantController>();
// //   final RxBool isLoading = false.obs;
// //
// //   final RxInt selectedDistance = 0.obs;
// //   final Rx<Stream<List<RestaurantModel>>> filteredRestaurantsStream = Rx<Stream<List<RestaurantModel>>>(Stream.value([]));
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // searchController.addListener(() {
// //     //   isLoading.value = true;
// //     //   Future.delayed(const Duration(milliseconds: 500), () {
// //     //     filterRestaurantsByNameAndDistance();
// //     //     isLoading.value = false;
// //     //   });
// //     // });
// //
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       isLoading.value = true;
// //       Future.delayed(const Duration(seconds: 1), () {
// //         filterRestaurantsByNameAndDistance();
// //         isLoading.value = false;
// //       });
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     searchController.dispose();
// //     super.dispose();
// //   }
// //
// //   void filterRestaurantsByNameAndDistance() {
// //     filteredRestaurantsStream.value = FirebaseFirestore.instance
// //         .collection('restaurants')
// //         .snapshots()
// //         .map((snapshot) {
// //       var restaurants = snapshot.docs
// //           .map((doc) => RestaurantModel.fromDocumentSnapshot(doc))
// //           .toList();
// //
// //       // Filter by restaurant name
// //       if (searchController.text.isNotEmpty) {
// //         final query = searchController.text.toLowerCase();
// //         restaurants = restaurants
// //             .where((restaurant) => restaurant.resName.toLowerCase().contains(query))
// //             .toList();
// //       }
// //
// //       // Filter by distance
// //       if (selectedDistance.value > 0 && controller.userPosition != null) {
// //         final maxDistanceKm = selectedDistance.value * 1.60934; // Convert miles to kilometers
// //         restaurants = restaurants.where((restaurant) {
// //           if (restaurant.latitude == 0.0 && restaurant.longitude == 0.0) {
// //             return false;
// //           }
// //           final distance = Geolocator.distanceBetween(
// //             controller.userPosition!.latitude,
// //             controller.userPosition!.longitude,
// //             restaurant.latitude,
// //             restaurant.longitude,
// //           ) / 1000; // Distance in kilometers
// //           return distance <= maxDistanceKm;
// //         }).toList();
// //       }
// //
// //       return restaurants;
// //     });
// //   }
// //
// //   Widget _buildSearchBar() {
// //     return Material(
// //       elevation: 0,
// //       borderRadius: BorderRadius.circular(30),
// //       child: Container(
// //         height: 48,
// //         padding: const EdgeInsets.symmetric(horizontal: 16),
// //         alignment: Alignment.center,
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(30),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.04),
// //               blurRadius: 16,
// //               spreadRadius: 0,
// //               offset: Offset(0, 4),
// //             )
// //           ],
// //         ),
// //         child: Row(
// //           children: [
// //             const Icon(Icons.search, size: 24),
// //             const SizedBox(width: 8),
// //             Expanded(
// //               child: TextField(
// //                 controller: searchController,
// //                 decoration: InputDecoration(
// //                   hintText: 'Search for restaurants',
// //                   border: InputBorder.none,
// //                   hintStyle: TextStyle(color: Colors.grey[600]),
// //                 ),
// //                 onSubmitted: (value) {
// //                   filterRestaurantsByNameAndDistance();
// //                 },
// //               ),
// //             ),
// //             DropdownButtonHideUnderline(
// //               child: Obx(
// //                     () => DropdownButton2<String>(
// //                   buttonStyleData: ButtonStyleData(
// //                     width: 55,
// //                   ),
// //                   dropdownStyleData: DropdownStyleData(
// //                     width: 65,
// //                     decoration: BoxDecoration(
// //                       color: Colors.white,
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                   hint: Text(
// //                     'miles',
// //                     style: const TextStyle(fontSize: 14),
// //                   ),
// //                   value: selectedDistance.value == 0
// //                       ? 'All'
// //                       : selectedDistance.value.toString() + ' mi',
// //                   items: controller.distanceOptions
// //                       .map((ele) => DropdownMenuItem(
// //                     value: ele,
// //                     child: Padding(
// //                       padding: const EdgeInsets.symmetric(vertical: 8),
// //                       child: Text(
// //                         ele,
// //                         style: const TextStyle(fontSize: 14),
// //                       ),
// //                     ),
// //                   ))
// //                       .toList(),
// //                   onChanged: (val) {
// //                     if (val == 'All') {
// //                       selectedDistance.value = 0;
// //                     } else {
// //                       selectedDistance.value =
// //                           int.parse(val!.replaceAll(' mi', ''));
// //                     }
// //                     isLoading.value = true;
// //                     Future.delayed(const Duration(milliseconds: 500), () {
// //                       filterRestaurantsByNameAndDistance();
// //                       isLoading.value = false;
// //                     });
// //                   },
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildShimmer() {
// //     return ListView.builder(
// //       itemCount: 3,
// //       itemBuilder: (context, index) => Shimmer.fromColors(
// //         baseColor: Colors.grey[300]!,
// //         highlightColor: Colors.grey[100]!,
// //         child: Container(
// //           height: 83,
// //           width: 362,
// //           margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(9.0),
// //             border: Border.all(color: Colors.grey[300]!),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         surfaceTintColor: Colors.white,
// //         title: const Center(child: Text('Restaurants in the area')),
// //         leading: const BackButton(),
// //       ),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: _buildSearchBar(),
// //           ),
// //           const SizedBox(height: 18.0),
// //           Expanded(
// //             child: Obx(() {
// //               return StreamBuilder<List<RestaurantModel>>(
// //                 stream: filteredRestaurantsStream.value,
// //                 builder: (context, snapshot) {
// //                   if (snapshot.connectionState == ConnectionState.waiting || isLoading.value) {
// //                     return _buildShimmer();
// //                   }
// //                   if (snapshot.hasError) {
// //                     return const Center(child: Text('Error loading restaurants'));
// //                   }
// //                   if (snapshot.data == null || snapshot.data!.isEmpty) {
// //                     return const Center(child: Text('No restaurants available'));
// //                   }
// //
// //                   final restaurants = snapshot.data!;
// //                   return Obx(() {
// //                     final favoriteIds = restaurantCtrl.bookmarkedIds.toSet();
// //                     return ListView.builder(
// //                       itemCount: restaurants.length,
// //                       itemBuilder: (context, index) {
// //                         final restaurant = restaurants[index];
// //                         final isBookmarked = favoriteIds.contains(restaurant.docID);
// //                         return GestureDetector(
// //                           onTap: () {
// //                             Get.to(() => RestaurantDetailScreen(restaurantModel: restaurant));
// //                           },
// //                           child: Container(
// //                             margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               borderRadius: const BorderRadius.only(
// //                                 topLeft: Radius.circular(10),
// //                               ),
// //                               border: Border.all(color: AppColors.borderColor),
// //                               boxShadow: [
// //                                 BoxShadow(
// //                                     color: Colors.black.withOpacity(0.04),
// //                                     blurRadius: 16,
// //                                     spreadRadius: 0,
// //                                     offset: Offset(0, 4))
// //                               ],
// //                             ),
// //                             child: SizedBox(
// //                               height: 84,
// //                               child: Row(
// //                                 children: [
// //                                   ClipRRect(
// //                                     clipBehavior: Clip.hardEdge,
// //                                     borderRadius: const BorderRadius.only(
// //                                       topLeft: Radius.circular(10),
// //                                       topRight: Radius.circular(10),
// //                                     ),
// //                                     child: controller.buildImage(
// //                                       restaurant.logoImage.isNotEmpty
// //                                           ? restaurant.logoImage
// //                                           : 'assets/images/event_img5.png',
// //                                       width: 124,
// //                                       height: 84,
// //                                       fit: BoxFit.cover,
// //                                     ),
// //                                   ),
// //                                   Expanded(
// //                                     child: Padding(
// //                                       padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
// //                                       child: Column(
// //                                         crossAxisAlignment: CrossAxisAlignment.start,
// //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                         children: [
// //                                           Row(
// //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                             children: [
// //                                               Expanded(
// //                                                 child: Text(
// //                                                   restaurant.resName.isNotEmpty
// //                                                       ? restaurant.resName
// //                                                       : 'Unknown Restaurant',
// //                                                   style: TextStyle(
// //                                                     fontSize: 15,
// //                                                     fontWeight: FontWeight.w700,
// //                                                     fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
// //                                                   ),
// //                                                   maxLines: 1,
// //                                                   overflow: TextOverflow.ellipsis,
// //                                                 ),
// //                                               ),
// //                                               GestureDetector(
// //                                                 onTap: () {
// //                                                   restaurantCtrl.toggleBookmark(restaurant.docID);
// //                                                 },
// //                                                 child: Icon(
// //                                                   isBookmarked ? Icons.bookmark : Icons.bookmark_border,
// //                                                   color: isBookmarked ? Colors.green : Colors.grey,
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                           FutureBuilder<Map<String, Map<String, Map<String, dynamic>>>?>(
// //                                             future: controller.getOperatingHours2(restaurant.docID),
// //                                             builder: (context, snapshot) {
// //                                               if (snapshot.connectionState == ConnectionState.waiting) {
// //                                                 return Text(
// //                                                   'Loading...',
// //                                                   style: TextStyle(
// //                                                     fontSize: 12,
// //                                                     fontWeight: FontWeight.w500,
// //                                                     fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
// //                                                     color: Colors.black,
// //                                                   ),
// //                                                 );
// //                                               }
// //                                               final operatingHours = snapshot.data;
// //                                               final currentDay = DateFormat('EEEE').format(DateTime.now());
// //                                               final timeOfDay = 'Dinner';
// //                                               final dayHours = operatingHours?[currentDay] ?? null;
// //
// //                                               String time = '';
// //                                               if (dayHours == null) {
// //                                                 time = 'Unavailable';
// //                                               } else {
// //                                                 final isClosed = dayHours[timeOfDay]?['isClosed'] ?? true;
// //                                                 final startTime = dayHours[timeOfDay]?['startTime'] ?? '6:00 PM';
// //                                                 final endTime = dayHours[timeOfDay]?['endTime'] ?? '9:00 PM';
// //                                                 time = isClosed ? 'Closed' : '$startTime–$endTime';
// //                                               }
// //
// //                                               return Text(
// //                                                 time,
// //                                                 style: TextStyle(
// //                                                   fontSize: 12,
// //                                                   color: const Color.fromRGBO(142, 142, 147, 1),
// //                                                   fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
// //                                                   fontWeight: FontWeight.w500,
// //                                                 ),
// //                                               );
// //                                             },
// //                                           ),
// //                                           Row(
// //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                             children: [
// //                                               Row(
// //                                                 mainAxisSize: MainAxisSize.min,
// //                                                 children: [
// //                                                   Image.asset(
// //                                                     'assets/images/Icon (1).png',
// //                                                     width: 15,
// //                                                     height: 13,
// //                                                   ),
// //                                                   FutureBuilder<double>(
// //                                                     future: controller.getCurrentLocation(context).then((position) =>
// //                                                     Geolocator.distanceBetween(
// //                                                       position.latitude,
// //                                                       position.longitude,
// //                                                       restaurant.latitude,
// //                                                       restaurant.longitude,
// //                                                     ) / 1000),
// //                                                     builder: (context, snapshot) {
// //                                                       if (snapshot.connectionState == ConnectionState.waiting) {
// //                                                         return Text(
// //                                                           'Calculating...',
// //                                                           style: TextStyle(
// //                                                             fontSize: 12,
// //                                                             fontWeight: FontWeight.w500,
// //                                                             fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
// //                                                             color: const Color.fromRGBO(142, 142, 147, 1),
// //                                                           ),
// //                                                         );
// //                                                       }
// //                                                       return Text(
// //                                                         snapshot.hasData
// //                                                             ? '${snapshot.data!.toStringAsFixed(1)} km away'
// //                                                             : 'Unknown',
// //                                                         style: TextStyle(
// //                                                           fontSize: 12,
// //                                                           fontWeight: FontWeight.w500,
// //                                                           fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
// //                                                           color: const Color.fromRGBO(142, 142, 147, 1),
// //                                                         ),
// //                                                       );
// //                                                     },
// //                                                   ),
// //                                                   const SizedBox(width: 24),
// //                                                 ],
// //                                               ),
// //                                               Row(
// //                                                 mainAxisSize: MainAxisSize.min,
// //                                                 children: [
// //                                                   Image.asset(
// //                                                     'assets/images/Group (5).png',
// //                                                     width: 15,
// //                                                     height: 15,
// //                                                   ),
// //                                                   const SizedBox(width: 4),
// //                                                 ],
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     );
// //                   });
// //                 },
// //               );
// //             }),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
//
//
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:kaistable_website/models/restaurant_model.dart';
// // import 'package:shimmer/shimmer.dart';
// //
// // import '../../../constants/app_colors.dart';
// // import '../../home_screen/home_controller/home_location_controller.dart';
// // import '../controller/search_controller.dart';
// // import '../restaurant_detail_screens/restaurant_detail_screen.dart';
// // import 'discover_controller.dart';
// //
// // class RestaurantsPage extends StatefulWidget {
// //   const RestaurantsPage({Key? key}) : super(key: key);
// //
// //   @override
// //   State<RestaurantsPage> createState() => _RestaurantsPageState();
// // }
// //
// // class _RestaurantsPageState extends State<RestaurantsPage> {
// //   final TextEditingController searchController = TextEditingController();
// //   final HomeLocationController controller = Get.find<HomeLocationController>();
// //   final FilterController filterCtrl = Get.find<FilterController>();
// //   final RestaurantController restaurantCtrl = Get.find<RestaurantController>();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     searchController.addListener(() {
// //       controller.filterRestaurants(searchController.text);
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     searchController.dispose();
// //     super.dispose();
// //   }
// //
// //   Widget _buildSearchBar() {
// //     return Material(
// //       elevation: 0,
// //       borderRadius: BorderRadius.circular(30),
// //       child: Container(
// //         height: 48,
// //         padding: const EdgeInsets.symmetric(horizontal: 16),
// //         alignment: Alignment.center,
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(30),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.04),
// //               blurRadius: 16,
// //               spreadRadius: 0,
// //               offset: Offset(0, 4),
// //             )
// //           ]
// //         ),
// //         child: Row(
// //           children: [
// //             const Icon(Icons.search, size: 24),
// //             const SizedBox(width: 8),
// //             Expanded(
// //               child: TextField(
// //                 controller: searchController,
// //                 decoration: InputDecoration(
// //                   hintText: 'Search for restaurant',
// //                   border: InputBorder.none,
// //                   hintStyle: TextStyle(color: Colors.grey[600]),
// //                 ),
// //               ),
// //             ),
// //             GestureDetector(
// //               onTap: () {},
// //               child: const Icon(Icons.arrow_drop_down, size: 24),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildShimmer() {
// //     return ListView.builder(
// //       itemCount: 3,
// //       itemBuilder: (context, index) => Shimmer.fromColors(
// //         baseColor: Colors.grey[300]!,
// //         highlightColor: Colors.grey[100]!,
// //         child: Container(
// //           height: 83,
// //           width: 362,
// //           margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(9.0),
// //             border: Border.all(color: Colors.grey[300]!),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         surfaceTintColor: Colors.white,
// //         title: const Center(child: Text('Restaurants in the area')),
// //         leading: const BackButton(),
// //       ),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: _buildSearchBar(),
// //           ),
// //           const SizedBox(height: 18.0),
// //           Expanded(
// //             child: Obx(() {
// //               return StreamBuilder<List<RestaurantModel>>(
// //                 stream: filterCtrl.selectedFilters.values.any((list) => list.isNotEmpty)
// //                     ? controller.getFilteredRestaurants()
// //                     : controller.getAllRestaurants(),
// //                 builder: (context, snapshot) {
// //                   if (snapshot.connectionState == ConnectionState.waiting) {
// //                     return _buildShimmer();
// //                   }
// //                   if (snapshot.hasError) {
// //                     return const Center(child: Text('Error loading restaurants'));
// //                   }
// //                   if (snapshot.data == null || snapshot.data!.isEmpty) {
// //                     return const Center(child: Text('No restaurants available'));
// //                   }
// //
// //                   final restaurants = controller.filteredRestaurants.isNotEmpty
// //                       ? controller.filteredRestaurants
// //                       : snapshot.data!;
// //                   return Obx(() {
// //                     final favoriteIds = restaurantCtrl.bookmarkedIds.toSet();
// //                     return ListView.builder(
// //                       itemCount: restaurants.length,
// //                       itemBuilder: (context, index) {
// //                         final restaurant = restaurants[index];
// //                         final isBookmarked = favoriteIds.contains(restaurant.docID);
// //                         return GestureDetector(
// //                           onTap: (){
// //                             Get.to(()=>RestaurantDetailScreen(restaurantModel: restaurant));
// //                           },
// //                           child: Container(
// //                             // elevation: 0,
// //                             margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               border: BoxBorder.fromBorderSide(BorderSide(color: AppColors.borderColor, width: 1),),
// //                               borderRadius: const BorderRadius.only(
// //                             topLeft: Radius.circular(10),
// //                           ),
// //                               boxShadow: [
// //                                 BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, spreadRadius: 0, offset: Offset(0, 4))
// //                               ]
// //                               // side: BorderSide(color: AppColors.borderColor, width: 1),
// //                             ),
// //                             child: SizedBox(
// //                               height: 84,
// //                               child: Row(
// //                                 children: [
// //                                   ClipRRect(
// //                                     clipBehavior: Clip.hardEdge,
// //                                     borderRadius: const BorderRadius.only(
// //                                       topLeft: Radius.circular(10),
// //                                       topRight: Radius.circular(10),
// //                                     ),
// //                                     child:
// //                                     controller.buildImage(
// //                                       restaurant.logoImage.isNotEmpty
// //                                           ? restaurant.logoImage
// //                                           : 'assets/images/event_img5.png',
// //                                       width: 124,
// //                                       height: 84,
// //                                       fit: BoxFit.cover,
// //                                     ),
// //                                   ),
// //                                   Expanded(
// //                                     child: Padding(
// //                                       padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
// //                                       child: Column(
// //                                         crossAxisAlignment: CrossAxisAlignment.start,
// //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                         children: [
// //                                           Row(
// //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                             children: [
// //                                               Expanded(
// //                                                 child: Text(
// //                                                   restaurant.resName.isNotEmpty
// //                                                       ? restaurant.resName
// //                                                       : 'Unknown Restaurant',
// //                                                   style: TextStyle(
// //                                                     fontSize: 15,
// //                                                     fontWeight: FontWeight.w700,
// //                                                     fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
// //                                                   ),
// //                                                   maxLines: 1,
// //                                                   overflow: TextOverflow.ellipsis,
// //                                                 ),
// //                                               ),
// //                                               GestureDetector(
// //                                                 onTap: () {
// //                                                   restaurantCtrl.toggleBookmark(restaurant.docID);
// //                                                 },
// //                                                 child: Icon(
// //                                                   isBookmarked ? Icons.bookmark : Icons.bookmark_border,
// //                                                   color: isBookmarked ? Colors.green : Colors.grey,
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                           FutureBuilder<Map<String, dynamic>?>(
// //                                             future: controller.getOperatingHours1(restaurant.docID),
// //                                             builder: (context, snapshot) {
// //                                               if (snapshot.connectionState == ConnectionState.waiting) {
// //                                                 return Text(
// //                                                   'Loading...',
// //                                                   style: TextStyle(
// //                                                     fontSize: 12,
// //                                                     fontWeight: FontWeight.w500,
// //                                                     fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
// //                                                     color: Colors.black,
// //                                                   ),
// //                                                 );
// //                                               }
// //                                               final timeOfDay = filterCtrl.selectedFilters['Time']?.isNotEmpty ?? false
// //                                                   ? filterCtrl.selectedFilters['Time']!.first
// //                                                   : 'Dinner';
// //                                               final operatingHours = snapshot.data;
// //                                               final isClosed = operatingHours?[timeOfDay]?['isClosed'] ?? true;
// //                                               return Text(
// //                                                 isClosed ? 'Closed' : operatingHours?[timeOfDay]?['hours'] ?? '6PM-9PM',
// //                                                 style: TextStyle(
// //                                                   fontSize: 12,
// //                                                   fontWeight: FontWeight.w500,
// //                                                   fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
// //                                                   color: Colors.black,
// //                                                 ),
// //                                               );
// //                                             },
// //                                           ),
// //                                           Row(
// //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                             children: [
// //                                               Row(
// //                                                 mainAxisSize: MainAxisSize.min,
// //                                                 children: [
// //                                                   Image.asset(
// //                                                     'assets/images/Icon (1).png',
// //                                                     width: 15,
// //                                                     height: 13,
// //                                                   ),
// //                                                   FutureBuilder<double>(
// //                                                     future: controller.getCurrentLocation(context).then((position) =>
// //                                                     Geolocator.distanceBetween(
// //                                                       position.latitude,
// //                                                       position.longitude,
// //                                                       restaurant.latitude,
// //                                                       restaurant.longitude,
// //                                                     ) / 1000),
// //                                                     builder: (context, snapshot) {
// //                                                       if (snapshot.connectionState == ConnectionState.waiting) {
// //                                                         return Text(
// //                                                           'Calculating...',
// //                                                           style: TextStyle(
// //                                                             fontSize: 12,
// //                                                             fontWeight: FontWeight.w500,
// //                                                             fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
// //                                                             color: const Color.fromRGBO(142, 142, 147, 1),
// //                                                           ),
// //                                                         );
// //                                                       }
// //                                                       return Text(
// //                                                         snapshot.hasData
// //                                                             ? '${snapshot.data!.toStringAsFixed(1)} km away'
// //                                                             : 'Unknown',
// //                                                         style: TextStyle(
// //                                                           fontSize: 12,
// //                                                           fontWeight: FontWeight.w500,
// //                                                           fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
// //                                                           color: const Color.fromRGBO(142, 142, 147, 1),
// //                                                         ),
// //                                                       );
// //                                                     },
// //                                                   ),
// //                                                   const SizedBox(width: 24),
// //                                                 ],
// //                                               ),
// //                                               Row(
// //                                                 mainAxisSize: MainAxisSize.min,
// //                                                 children: [
// //                                                   Image.asset(
// //                                                     'assets/images/Group (5).png',
// //                                                     width: 15,
// //                                                     height: 15,
// //                                                   ),
// //                                                   const SizedBox(width: 4),
// //                                                 ],
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     );
// //                   });
// //                 },
// //               );
// //             }),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }