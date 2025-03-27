import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/screens/home_screen/cuisiness_viewall/cuisines_view_all.dart';
import 'package:kaistable_website/screens/home_screen/entertainment/entertainments.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import 'package:kaistable_website/screens/home_screen/new_view_all/new_viewall.dart';
import 'package:kaistable_website/screens/home_screen/trending_all/trending_view_all.dart';
import 'package:kaistable_website/screens/nav_bar/near_by_all.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import 'package:kaistable_website/widgets/rectangle_widget.dart';

import '../home_screen/events_screen/common_widget/days_tile.dart';
import '../home_screen/events_screen/controller/events_controller.dart';
import '../home_screen/events_screen/event_screen.dart';
import '../home_screen/events_screen/events_details_screen/event_details_screen.dart';
import 'controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final EventsController eventController = Get.put(EventsController());
  @override
  Widget build(BuildContext context) {
    requestLocationPermission();
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/top_banner.png',height: 183,width: Get.width,),

              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Row(
                  children: [
                    Text(
                      'Explore By Category',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 14,
              ),
              _buildCategories(),
              _buildTrendingSection(),
              ///Add image
              // Container(
              //   width: Get.width,
              //   height: 150,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.rectangle,
              //     borderRadius: BorderRadius.circular(18),
              //     image: DecorationImage(
              //       image: AssetImage(
              //         'assets/images/ad1.png',
              //       ),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              _featuredCategory(),
              SizedBox(
                height: 10,
              ),
              _buildNearBySection(),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 14,right: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Events',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Get.to(EventScreen());
                        },
                        child: Text(
                          "view all",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryColor,
                              fontFamily: 'Nunito-Regular',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor),
                        ))

                  ],
                ),
              ),
              SizedBox(height: 10,),

      ListView.builder(
          shrinkWrap: true, // Ensures it takes only the necessary space
          physics: ScrollPhysics(), // Prevents scrolling if inside another scrollable view
          itemCount: 3,
          itemBuilder: (context, index) {
            final event = eventController.eventsList[index];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: DaysTile(
                    onTap: ()=>Get.to(EventDetailsScreen()),
                    image: event.image,
                    title: event.title,
                    location: event.location,
                  ),
                ),
                if (index != eventController.eventsList.length - 1) // Avoid divider after last item
                  Divider(
                    thickness: 1,
                    color: AppColors.primaryColor.withOpacity(.2),
                  ),
              ],
            );
          },
        )
            ],
          ),
        ),
      ),
    );
  }
 Widget _featuredCategory(){
    return  Container(
      height: 426,
      width: Get.width,
      decoration: BoxDecoration(
          color:Color(0xFF708780)
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Text(
              'Featured',
              style: TextStyle(
                color: AppColors.bottomSheetColor,
                fontFamily: 'aftika-regular',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12,),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt labore magna aliqua.',
              style: TextStyle(
                color: AppColors.bottomSheetColor,
                fontFamily: 'Nunito-Regular',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 18,),
            Container(
              height: 300,
              width: Get.width,
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Image.asset('assets/images/feature_img.png',height: 169,width:Get.width),
                    SizedBox(height: 8,),
                    Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniamexercitation ullamco laboris aliquip ex ea commodo consequat.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.headingTextColor,
                          fontFamily: 'Nunito-Regular'
                      ),)

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
 }
  Widget _buildCategories() {
    return Obx(() => SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              var category = controller.categories[index];
              return GestureDetector(
                onTap: () {
                  if (category['name'] == 'Cuisines') {
                    Get.to(CuisinesViewAll());
                  } else if (category['name'] == 'New') {
                    Get.to(NewViewall());
                  } else if (category['name'] == 'Trending') {
                    Get.to(TrendingViewAll());
                  } else if (category['name'] == 'Experiences') {
                    Get.to(EntertainmentsScreen());
                  }else if (category['name'] == 'Events') {
                    Get.to(EventScreen());
                  }
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(category["image"] as String),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      category["name"] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.bottomSheetColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Nunito-Sans',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  Widget _buildTrendingSection() {
    final HomeLocationController controller = Get.put(HomeLocationController());

    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: StreamBuilder(
          stream: controller.getTrendingRestaurants(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(); // Show loading indicator
            }

            if (snapshot.hasError) {
              print('Error during stream call ${snapshot.error}');
              return Text(''); // Show error message if any
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Text(''); // Handle the case where data is null or empty
            }
            List<RestaurantModel> restaurants = snapshot.data!;
            // Initialize state after the widget build phase
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.initailizedSelectors(resaturantsList: restaurants);
            });

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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trending',
                                style: TextStyle(
                                  color: AppColors.bottomSheetColor,
                                  fontFamily: 'aftika-regular',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Places that are popular',
                                style: TextStyle(
                                  color: AppColors.bottomSheetColor,
                                  fontFamily: 'aftika-regular',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            Get.to(TrendingViewAll());
                          },
                          child: Text(
                            "view all",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primaryColor,
                                fontFamily: 'Nunito-Regular',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor),
                          ))
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height:
                      Get.height * 0.3, // Fixed height for the horizontal list
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final item = restaurants[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(RestaurantDetailScreen(
                            restaurantModel: item,
                          ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Container(
                                width: 274,
                                height: 181,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(item.logoImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 6,),
                            Text(
                              item.resName,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.headingTextColor,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Nunito-Sans',
                              ),
                            ),
                            SizedBox(height: 6,),
                            SizedBox(
                              width: Get.width * 0.3,
                              child: Row(
                                children: [
                                  Image.asset('assets/images/location_icon2.png',height: 16,width: 16,),
                                  SizedBox(width: 4,),
                                  Text(
                                    "${item.address}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Nunito-Sans',
                                    ),
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
                SizedBox(height: 20),
              ],
            );
          }),
    );
  }

  Widget _buildNearBySection() {
    final HomeLocationController controller = Get.put(HomeLocationController());
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: StreamBuilder(
          stream: controller.getRestaurants(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox();
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
                    return SizedBox();
                  }
                  if (snapshot.hasError) {
                    return Text('');
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('');
                  }

                  List<RestaurantModel> restaurants = futureSnapshot.data ?? [];
                  if (restaurants.isEmpty) {
                    return SizedBox();
                  }

                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You May Like This",
                                style: TextStyle(
                                  color: AppColors.bottomSheetColor,
                                  fontFamily: 'aftika-regular',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "For your best delicious food",
                                style: TextStyle(
                                  color: AppColors.bottomSheetColor,
                                  fontFamily: 'aftika-regular',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                              onTap: () {
                                Get.to(NearByAll());
                              },
                              child: Text(
                                "view all",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primaryColor,
                                    fontFamily: 'Nunito-Regular',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryColor),
                              ))
                        ],
                      ),
                      SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: Get.height * 0.2,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                        ),
                        itemCount:
                            restaurants.length > 4 ? 4 : restaurants.length,
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
                              description: item.address,
                              resturant_id: item.docID,
                              imagePath: item.logoImage,
                              timetext: '10 AM',
                              percentText: '25%',
                              endTimeText: '9 PM',
                              // percentageOff: item.menuList.percentageOff,
                              // happyhour: item.menuList.happyHourSpecials,
                              isFavorite: false.obs,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                });
          }),
    );
  }
}
