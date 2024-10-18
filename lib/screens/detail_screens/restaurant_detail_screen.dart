import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaistable_website/screens/detail_screens/controller/restaurant_detail_controller.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  final controller = Get.put(RestaurantDetailController());
  RestaurantDetailScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return LayoutBuilder(
      builder: (context, constraints) {
        int itemsPerRow = Responsive.isMobile(context)
            ? 2
            : Responsive.isTablet(context)
                ? 3
                : 4;
        double itemWidth = (constraints.maxWidth / itemsPerRow) - 16;
        double itemHeight = Responsive.isMobile(context)
            ? 320
            : (isLargeScreen ? 500 : 500); // Set a fixed height for items

        return Padding(
          padding:
              EdgeInsets.only(left: Responsive.isMobile(context) ? 22 : 46.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/ihop-restaurant-logo 1.png',
                        height: 40,
                        width: 40,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Ihop restaurant @ Tseug Kwan O',
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontFamily: 'Nunito-Regular',
                          fontSize: Responsive.isMobile(context) ? 20 : 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        '(4.0)',
                        style: TextStyle(
                          color: Color(0xFF4F5761),
                          fontSize: 16,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 14,
                        child: RatingBar(
                          itemSize: 14,
                          ignoreGestures: true,
                          initialRating: 4,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                            full: Image.asset(
                              'assets/images/star yellow.png',
                              height: 14,
                            ),
                            half: Image.asset(
                              'assets/images/star yellow.png',
                              height: 14,
                            ),
                            empty: Image.asset(
                              'assets/images/star_empty.png',
                              height: 14,
                            ),
                          ),
                          itemPadding: const EdgeInsets.only(left: 2.0),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '234 reviews',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 16,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Line10(),
                      const Text(
                        'Chinese',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 16,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Line10(),
                      const Icon(
                        Icons.favorite,
                        color: AppColors.darkGrey,
                      ),
                      const Text(
                        'add to favourite',
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 16,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: Responsive.isMobile(context) ? 10 : 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: Responsive.isMobile(context) ? 25 : 55,
                    width: Get.width * 0.6,
                    decoration: BoxDecoration(
                        color: const Color(0xFFEEEFF2),
                        borderRadius: BorderRadius.circular(
                            Responsive.isMobile(context) ? 4 : 10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        controller.top.length,
                        (index) {
                          return Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Obx(
                                () {
                                  return GestureDetector(
                                    onTap: () {
                                      controller.selectedTop.value =
                                          controller.top[index];
                                    },
                                    child: Container(
                                      height: Responsive.isMobile(context)
                                          ? 20
                                          : 40,
                                      width: Responsive.isMobile(context)
                                          ? 80
                                          : 121,
                                      decoration: BoxDecoration(
                                        color: controller.selectedTop.value !=
                                                controller.top[index]
                                            ? Colors.transparent
                                            : AppColors.whiteColor,
                                        borderRadius: BorderRadius.circular(
                                            Responsive.isMobile(context)
                                                ? 4
                                                : 10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          controller.top[index],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize:
                                                  Responsive.isMobile(context)
                                                      ? 12
                                                      : 20,
                                              color: controller
                                                          .selectedTop.value !=
                                                      controller.top[index]
                                                  ? AppColors.darkGrey
                                                  : AppColors.primaryColor,
                                              fontFamily: 'Nunito-Regular'),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ));
                        },
                      ),
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'choose time & discount',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF4F5761),
                          fontSize: 14,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400,
                          height: 0.16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: Responsive.isMobile(context) ? 2 : 22),
              Obx(() {
                return controller.selectedTop.value == 'about'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About XYZ ',
                            style: TextStyle(
                              color: AppColors.headingTextColor,
                              fontSize: Responsive.isMobile(context) ? 16 : 28,
                              fontFamily: 'aftika-regular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'The modern and elegant Flava Lite Rooftop Pool Bar & Cafe, located on the 11th floor, offers stunning views of the city\'s skyline. Guests can unwind and enjoy a drink or a meal in a serene and relaxing atmosphere from morning until late at night. Whether you choose to sit outdoors and soak in the panoramic views or dine indoors surrounded by chic and minimalistic decor, this rooftop pool bar provides a comfortable environment. Thai-style marinated beef skewers with coriander seed are great to pair with any of your favorite drinks, while salt and pepper kurobuta crispy pork with steamed jasmine rice and Thai-style fried eggs may be more suitable for the hungrier patrons.',
                            style: TextStyle(
                              color: Color(0xFF555555),
                              fontSize: Responsive.isMobile(context) ? 14 : 18,
                              fontFamily: 'Nunito-Regular',
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Special Conditions ',
                            style: TextStyle(
                              color: AppColors.headingTextColor,
                              fontSize: Responsive.isMobile(context) ? 16 : 28,
                              fontFamily: 'aftika-regular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: 1359,
                            child: Text(
                              'Ut nobis quo. Laudantium sint tempore voluptas illo quibusdam similique officiis. Natus ea similique sed rerum repudiandae deserunt. Deleniti et velit nam ut qui voluptatem voluptate.\nSaepe explicabo non odit. Necessitatibus eius et rem alias. Ipsa reprehenderit debitis repellendus voluptas nesciunt. Ut maiores perspiciatis illo deserunt voluptatum. Voluptatem iste ea aut non dolores ea eum.\nAssumenda deleniti corporis exercitationem ut blanditiis id aut quo. Nisi cupiditate nihil velit. Beatae similique suscipit dolor neque ut.\nAssumenda deleniti corporis exercitationem ut blanditiis id aut quo. Nisi cupiditate nihil velit. Beatae similique suscipit dolor neque ut.',
                              style: TextStyle(
                                color: Color(0xFF555555),
                                fontSize:
                                    Responsive.isMobile(context) ? 14 : 18,
                                fontFamily: 'Nunito-Regular',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          )
                        ],
                      );
              }),
              SizedBox(height: Responsive.isMobile(context) ? 12 : 22),
              Text(
                'Map',
                style: TextStyle(
                  color: AppColors.headingTextColor,
                  fontSize: Responsive.isMobile(context) ? 16 : 24,
                  fontFamily: 'aftika-regular',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 2 : 22),
              Container(
                width: Get.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: Get.width * 0.5,
                      height: 400,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16)),
                      child: MapWidget(controller: controller),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address',
                          style: TextStyle(
                            color: AppColors.headingTextColor,
                            fontSize: 14,
                            fontFamily: 'Nunito-Regular',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'shop g31, g/f, park central 9 tong tank, tseung kwan',
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: 14,
                            fontFamily: 'Nunito-Regular',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          'Atmospheres',
                          style: TextStyle(
                            color: AppColors.headingTextColor,
                            fontSize: 14,
                            fontFamily: 'Nunito-Regular',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class MapWidget extends StatelessWidget {
  const MapWidget({
    super.key,
    required this.controller,
  });

  final RestaurantDetailController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GoogleMap(
        markers: {
          const Marker(
            markerId: MarkerId('Property location'),
            position: LatLng(37.42796133580664,
                -122.085749655962), // Example coordinates (San Francisco)
          ),
        },
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.4746,
        ),
        // ListPropertyController.kGooglePlex,
        onMapCreated: (GoogleMapController gController) {
          controller.completer.complete(gController);
        },
      ),
    );
  }
}

class Line10 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Container(
        width: 1.5,
        height: 18,
        decoration: const BoxDecoration(color: AppColors.darkGrey),
      ),
    );
  }
}
