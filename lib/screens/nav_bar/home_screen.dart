import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/main.dart';
import 'package:kaistable_website/models/resaturant_model.dart';
import 'package:kaistable_website/screens/detail_screens/restaurant_detail_screen.dart';
import 'package:kaistable_website/screens/home_screen/cuisiness_viewall/cuisines_view_all.dart';
import 'package:kaistable_website/screens/home_screen/entertainment/entertainments.dart';
import 'package:kaistable_website/screens/home_screen/home_controller/home_location_controller.dart';
import 'package:kaistable_website/screens/home_screen/new_view_all/new_viewall.dart';
import 'package:kaistable_website/screens/home_screen/trending_all/trending_view_all.dart';
import 'package:kaistable_website/screens/nav_bar/near_by_all.dart';
import 'package:kaistable_website/widgets/carousel_slider_banner.dart';
import 'package:kaistable_website/widgets/global_functions.dart';
import 'package:kaistable_website/widgets/rectangle_widget.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../widgets/showcase_container.dart';
import '../home_screen/events_screen/common_widget/days_tile.dart';
import '../home_screen/events_screen/controller/events_controller.dart';
import '../home_screen/events_screen/event_screen.dart';
import '../home_screen/events_screen/events_details_screen/event_details_screen.dart';
import 'controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController controller = Get.put(HomeController());

  final EventsController eventController = Get.put(EventsController());

  final HomeLocationController homeController =
      Get.put(HomeLocationController());

  final GlobalKey _carouselKey = GlobalKey();

  final GlobalKey _categoryKey = GlobalKey();

  final GlobalKey _trendingKey = GlobalKey();

  final GlobalKey _featuredCategoryKey = GlobalKey();

  final GlobalKey _nearBySectionKey = GlobalKey();

  final GlobalKey _experienceKey = GlobalKey();

  final GlobalKey _eventsKey = GlobalKey();

  bool hasStartedShowcase = false;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    requestLocationPermission();
    eventController.onInit();
    return ShowCaseWidget(
      enableAutoScroll: true,
      builder: (context) {
        if (!hasStartedShowcase) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            bool isSpotlightFinish =
                await preferences?.getBool('isSpotLightViewd') ?? false;
            if (isSpotlightFinish == false) {
              hasStartedShowcase = !hasStartedShowcase;
              ShowCaseWidget.of(context).startShowCase([
                _carouselKey,
                _categoryKey,
                _trendingKey,
                _featuredCategoryKey,
                _nearBySectionKey,
                _experienceKey,
                _eventsKey,
              ]);
            } else {
              controller.isSpotlightFinish.value = true;
              controller.update();
              hasStartedShowcase = !hasStartedShowcase;
            }
          });
        }
        return Scaffold(
          backgroundColor: AppColors.bgColor,
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  hasStartedShowcase && !controller.isSpotlightFinish.value
                      ? Showcase.withWidget(
                          key: _carouselKey,
                          height: 190,
                          width: Get.width - 24,
                          tooltipPosition: TooltipPosition.bottom,
                          targetBorderRadius: BorderRadius.circular(20),
                          container: ShowCaseContainer(
                            width: Get.width - 32,
                            text:
                                "Check out the latest deals and promotions here!",
                            showcaseContext: context,
                            last: false,
                          ),
                          child: Image.asset(
                            'assets/images/top_banner.png',
                            height: Get.height * 0.25,
                            width: Get.width,
                          ),
                        )
                      : StreamBuilder(
                          stream: controller.fetchAllBanners(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CarouselWidget(imagePaths: [
                                'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
                              ]);
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return CarouselWidget(imagePaths: [
                                'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
                              ]);
                            }
                            final banners = snapshot.data!;
                            List<String> bannerImages =
                                banners.map((e) => e.bannerImage).toList();
                            if (bannerImages.isEmpty) {
                              return CarouselWidget(imagePaths: [
                                'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
                              ]);
                            }
                            return CarouselWidget(imagePaths: bannerImages);
                          },
                        ),
                  SizedBox(height: 10),
                  Showcase.withWidget(
                    height: 200,
                    width: Get.width - 24,
                    key: _categoryKey,
                    container: ShowCaseContainer(
                      width: Get.width - 32,
                      text:
                          "Browse different categories to find what you love!",
                      showcaseContext: context,
                      last: false,
                    ),
                    child: Center(child: _buildCategories()),
                  ),
                  hasStartedShowcase && !controller.isSpotlightFinish.value
                      ? Showcase.withWidget(
                          height: 200,
                          width: Get.width - 24,
                          key: _trendingKey,
                          container: ShowCaseContainer(
                            width: Get.width - 32,
                            text: "Discover the most popular items right now!",
                            showcaseContext: context,
                            last: false,
                          ),
                          child: trendingSection(),
                        )
                      : _buildTrendingSection(),
                  Showcase.withWidget(
                    height: 200,
                    width: Get.width - 24,
                    key: _featuredCategoryKey,
                    container: ShowCaseContainer(
                      width: Get.width - 32,
                      text: "Featured categories with exclusive offers!",
                      showcaseContext: context,
                      last: false,
                    ),
                    child: _featuredCategory(),
                  ),
                  SizedBox(height: 10),
                  hasStartedShowcase && !controller.isSpotlightFinish.value
                      ? Showcase.withWidget(
                          height: 200,
                          width: Get.width - 24,
                          key: _nearBySectionKey,
                          container: ShowCaseContainer(
                            width: Get.width - 32,
                            text: "Find amazing places near you!",
                            showcaseContext: context,
                            last: false,
                          ),
                          child: nearBySection(),
                        )
                      : _buildNearBySection(),
                  SizedBox(height: 10),
                  Showcase.withWidget(
                    height: 200,
                    width: Get.width - 24,
                    key: _experienceKey,
                    container: ShowCaseContainer(
                      width: Get.width - 32,
                      text: "Check out unique experiences waiting for you!",
                      showcaseContext: context,
                      last: false,
                    ),
                    child: experienceWidget(),
                  ),
                  Showcase.withWidget(
                    height: 200,
                    width: Get.width - 24,
                    key: _eventsKey,
                    onTargetClick: () {
                      controller.isSpotlightFinish.value = true;
                      controller.update();
                    },
                    container: ShowCaseContainer(
                      width: Get.width - 32,
                      text:
                          "Stay updated with the latest events happening around!",
                      showcaseContext: context,
                      last: true,
                    ),
                    child: eventsWidget(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Column eventsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14, right: 14),
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
                onTap: () => Get.to(EventScreen()),
                child: Text(
                  "view all",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'Events worth your time — always in the loop.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: AppColors.bottomSheetColor,
              fontFamily: 'Nunito-Regular',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 10),
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: eventController.events.length > 3
                ? 3
                : eventController.events.length,
            itemBuilder: (context, index) {
              final event = eventController.events[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: DaysTile(
                      onTap: () => Get.to(EventDetailsScreen(
                        event: event,
                      )),
                      image: event.imageUrls.first,
                      title: event.eventName,
                      location: event.location,
                      type: event.eventType,
                    ),
                  ),
                  if (index != eventController.eventsList.length - 1)
                    Divider(
                      thickness: 1,
                      color: AppColors.primaryColor.withOpacity(.2),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Column experienceWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14, right: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Experience',
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontFamily: 'aftika-regular',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              InkWell(
                onTap: () => Get.to(EntertainmentsScreen()),
                child: Text(
                  "view all",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: StreamBuilder(
            stream: homeController.getEntertainmentRestaurants(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return buildShimmerEffect();
              }
              if (snapshot.hasError) {
                print('Error during stream call ${snapshot.error}');
                return Text('');
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Text('No restaurants found');
              }
              List<RestaurantModel> restaurants = snapshot.data!;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                homeController.initializeSelectors(restaurants);
              });
              return GetBuilder<HomeLocationController>(
                builder: (controller) {
                  return SizedBox(
                    height: 270,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.filteredRestaurants.length,
                      itemBuilder: (context, index) {
                        final item = controller.filteredRestaurants[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                            onTap: () => Get.to(
                                RestaurantDetailScreen(restaurantModel: item)),
                            child: RectangleWidget(
                              boxColor: AppColors.whiteColor,
                              imgHeight: 203,
                              height: 304,
                              width: 230,
                              title: item.resName,
                              description: item.address,
                              resturant_id: item.docID,
                              imagePath: item.logoImage,
                              timetext: '10 AM',
                              percentText: '25%',
                              endTimeText: '9 PM',
                              // percentageOff:
                              //     item.menuList.percentageOff,
                              // happyhour:
                              //     item.menuList.happyHourSpecials,
                              isFavorite: false.obs,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _featuredCategory() {
    return StreamBuilder<String?>(
      stream: homeController.getFeaturedRestaurantID(),
      builder: (context, featuredIDSnapshot) {
        if (!featuredIDSnapshot.hasData ||
            featuredIDSnapshot.data == null ||
            featuredIDSnapshot.data!.isEmpty) {
          return const SizedBox(); // hide entire section if no featured ID
        }

        return StreamBuilder<RestaurantModel?>(
          stream: homeController.getFeaturedRestaurants(
              restID: featuredIDSnapshot.data!),
          builder: (context, restaurantSnapshot) {
            if (!restaurantSnapshot.hasData ||
                restaurantSnapshot.data == null) {
              return const SizedBox(); // hide entire section if no data
            }

            final restaurant = restaurantSnapshot.data!;

            return Container(
              height: Get.height * 0.45,
              width: Get.width,
              decoration: BoxDecoration(color: const Color(0xFF708780)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Featured',
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'aftika-regular',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Elevated picks for tastemakers and trendsetters. From chef-driven menus to unforgettable atmospheres, these restaurants define what it means to Savr. Curated with intention, crafted for your next great night out',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'Nunito-Regular',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () {
                        Get.to(RestaurantDetailScreen(
                          restaurantModel: restaurant,
                        ));
                      },
                      child: Container(
                        height: Get.height * 0.28,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Image.network(
                                restaurant.logoImage,
                                height: 169,
                                width: Get.width,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      restaurant.specialConditions,
                                      textAlign: TextAlign.justify,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.headingTextColor,
                                        fontFamily: 'Nunito-Regular',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    );
  }

  Widget _buildCategories() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text(
                'Explore By Category',
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontFamily: 'aftika-regular',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text(
                'Find whats New and Hot',
                style: TextStyle(
                  color: AppColors.bottomSheetColor,
                  fontFamily: 'aftika-regular',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 14),
            SizedBox(
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
                      } else if (category['name'] == 'Experience') {
                        Get.to(EntertainmentsScreen());
                      } else if (category['name'] == 'Events') {
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
            ),
          ],
        ));
  }

  Widget _buildTrendingSection() {
    final HomeLocationController controller = Get.put(HomeLocationController());
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: StreamBuilder(
        stream: controller.getTrendingRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SizedBox();
          if (snapshot.hasError) {
            print('Error during stream call ${snapshot.error}');
            return Text('');
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) return Text('');
          List<RestaurantModel> restaurants = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.initailizedSelectors(resaturantsList: restaurants);
          });

          return Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(right: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          'Whats Hot Right Now',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: AppColors.bottomSheetColor,
                            fontFamily: 'Nunito-Regular',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     print('presss view all');
                    //     Get.to(TrendingViewAll());
                    //   },
                    //   child: Text(
                    //     "view all",
                    //     style: TextStyle(
                    //       decoration: TextDecoration.underline,
                    //       decorationColor: AppColors.primaryColor,
                    //       fontFamily: 'Nunito-Regular',
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w500,
                    //       color: AppColors.primaryColor,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: Get.height * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final item = restaurants[index];
                    return GestureDetector(
                      onTap: () =>
                          Get.to(RestaurantDetailScreen(restaurantModel: item)),
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
                          SizedBox(height: 6),
                          Text(
                            item.resName,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.headingTextColor,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Nunito-Sans',
                            ),
                          ),
                          SizedBox(height: 6),
                          SizedBox(
                            width: Get.width * 0.3,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/location_icon2.png',
                                  height: 16,
                                  width: 16,
                                ),
                                SizedBox(width: 4),
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
        },
      ),
    );
  }

  Widget _buildNearBySection() {
    final HomeLocationController controller = Get.put(HomeLocationController());
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: StreamBuilder(
        stream: controller.getRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SizedBox();
          if (snapshot.hasError) {
            print('Error during stream call ${snapshot.error}');
            return Text('');
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) return Text('');
          List<RestaurantModel> all_restaurants = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.initailizedSelectors(resaturantsList: all_restaurants);
          });
          return FutureBuilder(
            future: controller.getNearbyRestaurants(all_restaurants, 50000),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting)
                return SizedBox();
              if (futureSnapshot.hasError) return Text('');
              if (!futureSnapshot.hasData || futureSnapshot.data!.isEmpty)
                return Text('');
              List<RestaurantModel> restaurants = futureSnapshot.data ?? [];
              if (restaurants.isEmpty) return SizedBox();
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You might like",
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: 'aftika-regular',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "For your best delicious food",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: AppColors.bottomSheetColor,
                              fontFamily: 'Nunito-Regular',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => Get.to(NearByAll()),
                        child: Text(
                          "view all",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryColor,
                            fontFamily: 'Nunito-Regular',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: restaurants.length > 2 ? 2 : restaurants.length,
                    itemBuilder: (context, index) {
                      final item = restaurants[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () => Get.to(
                              RestaurantDetailScreen(restaurantModel: item)),
                          child: RectangleWidget(
                            imgHeight: 169,
                            title: item.resName,
                            description: item.address,
                            resturant_id: item.docID,
                            imagePath: item.logoImage,
                            timetext: '10 AM',
                            percentText: '25%',
                            endTimeText: '9 PM',
                            isFavorite: false.obs,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget nearBySection() {
    List<String> img = [
      'assets/images/event_img5.png',
      'assets/images/event_ing2.png'
    ];
    List<String> nameOfRestaurant = ['ABSteak by Chef', 'Tsuri'];
    List<String> address = ['8500 Beverkt', ' 200 Manathan'];

    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You might like",
                    style: TextStyle(
                      color: AppColors.bottomSheetColor,
                      fontFamily: 'aftika-regular',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "For your best delicious food",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: AppColors.bottomSheetColor,
                      fontFamily: 'Nunito-Regular',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  "view all",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor,
                    fontFamily: 'Nunito-Regular',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: Container(
                  width: Get.width,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 82,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.transparent,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(img[index]))),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 140,
                                  child: Text(
                                    nameOfRestaurant[index],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: 'Nunito-Regular',
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 6,
                                )
                              ],
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/location_icon2.png',
                                  height: 16,
                                  width: 16,
                                ),
                                SizedBox(
                                  child: Text(
                                    address[index],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      fontFamily: 'Nunito-Regular',
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget trendingSection() {
    List<String> img = [
      'assets/images/aaa.jpg',
      'assets/images/event_ing2.png'
    ];
    List<String> nameOfRestaurant = ['Cactus Cantina', 'Tsuri'];
    List<String> address = ['Scottside', 'Manathan'];

    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: AppColors.bottomSheetColor,
                        fontFamily: 'Nunito-Regular',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: Get.height * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: img.length,
              itemBuilder: (context, index) {
                return Column(
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
                            image: AssetImage(img[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      nameOfRestaurant[index],
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.headingTextColor,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Nunito-Sans',
                      ),
                    ),
                    SizedBox(height: 6),
                    SizedBox(
                      width: Get.width * 0.3,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/location_icon2.png',
                            height: 16,
                            width: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            address[index],
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
                );
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
