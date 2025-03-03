import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/auth_screens/login/login_screen.dart';
import 'package:kaistable_website/screens/auth_screens/signup/signup_screen.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/screens/home_screen/my_home_screen.dart';
import 'package:kaistable_website/screens/nav_bar/widgets/custom_button.dart';
import 'package:kaistable_website/widgets/rectangle_widget.dart';

import '../home_screen/home_controller/home_location_controller.dart';
import 'controller/favorite_controller.dart';

class FavoriteScreen extends StatelessWidget {
  final Function(int)? onNavigate;

  final controller = Get.put(FavoriteController());
  final HomeLocationController mycontroller = Get.put(HomeLocationController());

  FavoriteScreen({super.key, this.onNavigate}) {
    mycontroller.selectedTop.value = '';
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // bool isLargeScreen = screenWidth > 1400;
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          iconTheme: IconThemeData(
            color: AppColors.primaryColor,
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          // leading: Padding(
          //   padding: const EdgeInsets.all(12.0),
          //   child: Container(
          //     height: 16,
          //     width: 16,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       shape: BoxShape.circle,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.1),
          //           spreadRadius: 1,
          //           blurRadius: 3,
          //           offset: const Offset(0, 1),
          //         ),
          //       ],
          //     ),
          //     child: GestureDetector(
          //       onTap: () {
          //         Get.off(MyHomeScreen());
          //       },
          //       child: Icon(Icons.arrow_back, size: 18),
          //     ),
          //   ),
          // ),

          title: Text(
            'Favorites',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.bottomSheetColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito-Bold',
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                auth.currentUser == null
                    ? SizedBox(
                        height: Get.height * 0.7,
                        width: Get.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomButton(
                              laBelText: 'Log in',
                              fontSize: 20,
                              textColor: Colors.white,
                              fontWeight: FontWeight.w600,
                              height: 43,
                              width: Get.width * 0.5,
                              ontapp: () async {
                                await FirebaseAuth.instance.signOut();
                                Get.offAll(() => LoginScreen());
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              laBelText: 'Register',
                              fontSize: 20,
                              textColor: Colors.white,
                              fontWeight: FontWeight.w600,
                              height: 43,
                              width: Get.width * 0.5,
                              ontapp: () async {
                                await FirebaseAuth.instance.signOut();
                                Get.offAll(() => SignupScreen());
                              },
                            ),
                          ],
                        ),
                      )
                    : StreamBuilder(
                        stream: mycontroller.getRestaurants(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                                height: Get.height * 0.7,
                                child:
                                    Center(child: CircularProgressIndicator()));
                          }

                          if (snapshot.hasError) {
                            print(
                                'Error during stream call: ${snapshot.error}');
                            return const Center(
                                child: Text('Error loading data'));
                          }

                          if (snapshot.data == null || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No restaurants available.'));
                          }

                          List<RestaurantModel> restaurants = snapshot.data!;

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            mycontroller.initailizedSelectors(
                                resaturantsList: restaurants);
                          });
                          return SizedBox(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(auth.currentUser!
                                      .uid) // Current user's document
                                  .collection('favorite')
                                  .snapshots(), // Stream the favorite collection to listen for changes
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SizedBox(); // Show loading indicator
                                }
                                if (snapshot.hasError) {
                                  return Text(
                                      'Something went wrong!'); // Handle errors
                                }

                                // Extract restaurant IDs from the favorite collection
                                var favoriteRestaurantIds = snapshot.data!.docs
                                    .map((doc) => doc['resturantID'])
                                    .toList();

                                // Filter the restaurant list to show only the favorites
                                var favoriteRestaurants = restaurants
                                    .where((restaurant) => favoriteRestaurantIds
                                        .contains(restaurant
                                            .docID)) // Assuming 'id' is a property of restaurant
                                    .toList();
                                if (favoriteRestaurants.isEmpty) {
                                  return Container(
                                    width: double.infinity,
                                    height: Get.height * 0.6,
                                    child: Center(
                                      child: Text('No favorite restaurants!'),
                                    ),
                                  );
                                }
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisExtent: Get.height * 0.27,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 20,
                                  ),
                                  itemCount: favoriteRestaurants
                                      .length, // Set the item count to the length of favorite restaurants
                                  itemBuilder: (context, index) {
                                    final item = favoriteRestaurants[index];
                                    return InkWell(
                                      onTap: () {
                                        Get.to(RestaurantDetailScreen(
                                          restaurantModel: item,
                                        ));
                                      },
                                      child: RectangleWidget(
                                        onNavigate: onNavigate,
                                        title: item.resName,
                                        description: item.about,
                                        imagePath: item.logoImage,
                                        timetext: '',
                                        endTimeText: '',
                                        percentText: '',
                                        resturant_id: item.docID,
                                        percentageOff:
                                            item.menuList.percentageOff,
                                        happyhour:
                                            item.menuList.happyHourSpecials,
                                        isFavorite: true.obs,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        }),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
