import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaistable_website/screens/detail_screens/controller/restaurant_detail_controller.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/responsive.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/uplaod_dialogBox.dart';
import '../home_screen/location_pages/location_controller/location_list_controller.dart';
import '../home_screen/location_pages/widget/location_star_widget.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  final controller = Get.put(RestaurantDetailController());
  final LocationListController locationController= LocationListController();
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Responsive.isMobile(context) ? 150:Responsive.isTablet(context)?280:isLargeScreen?610:410,
                      width: Responsive.isMobile(context) ?165:Responsive.isTablet(context)?370:isLargeScreen?864:544,

                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/img1.png'), // Replace with your image asset
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    SizedBox(width: Responsive.isMobile(context) ?2:10,),
                    Column(
                      children: [
                        Container(
                          height:Responsive.isMobile(context) ?75:Responsive.isTablet(context)?135:isLargeScreen?300: 200,
                          width:Responsive.isMobile(context) ?90:Responsive.isTablet(context)?260:isLargeScreen?464: 313,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/img1.png'), // Replace with your image asset
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        SizedBox(height: Responsive.isMobile(context) ?2:10,),

                        Container(
                          height:Responsive.isMobile(context) ?75:Responsive.isTablet(context)?135:isLargeScreen?300: 200,
                          width:Responsive.isMobile(context) ?90:Responsive.isTablet(context)?260:isLargeScreen?464: 313,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/img1.png'), // Replace with your image asset
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: Responsive.isMobile(context) ?2:10,),

                    Column(
                      children: [
                        Container(
                          height:Responsive.isMobile(context) ?75:Responsive.isTablet(context)?135:isLargeScreen?300: 200,
                          width:Responsive.isMobile(context) ?90:Responsive.isTablet(context)?260:isLargeScreen?464: 313,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/img1.png'), // Replace with your image asset
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        SizedBox(height: Responsive.isMobile(context) ?2:10,),
                        Container(
                          height:Responsive.isMobile(context) ?75:Responsive.isTablet(context)?135:isLargeScreen?300: 200,
                          width:Responsive.isMobile(context) ?90:Responsive.isTablet(context)?260:isLargeScreen?464: 313,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/img1.png'), // Replace with your image asset
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text("view all photos",

                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.whiteColor,
                                  fontFamily: 'Nunito-Regular',
                                  fontSize:  Responsive.isMobile(context) ? 6 :Responsive.isTablet(context) ? 12: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.whiteColor
                              ),

                            )  ,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: Responsive.isMobile(context) ? 10 : 18),
              Column(
                children: [
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
                  Stack(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(left: Responsive.isMobile(context)
                            ?40:62,right:10),
                        child: SizedBox(
                          height: Responsive.isMobile(context) ? 180 : isLargeScreen?  364: 270,
                          child: ListView.builder(
                            controller: locationController.scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: locationController.circleItems.length, // Number of items
                            itemBuilder: (context, index) {
                              final item = locationController.circleItems[index]; // Get item from model list
                              return Padding(
                                padding:  EdgeInsets.symmetric(horizontal: Responsive.isMobile(context)
                                    ?29: isLargeScreen?  48:21.0, vertical: Responsive.isMobile(context)
                                    ?6:6),
                                child: LocationStarWidget(
                                  //
                                  // isLocation: true,
                                  //
                                  timeText: item.timeText,
                                  persentText: item.persentText,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  // Left Arrow button with padding for spacing
                      Positioned(
                        left: 10, // Adjust the value to add space from the list
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () => locationController.scrollLeft(),
                          child: Image.asset(
                            'assets/images/arrow_back.png',
                            height: Responsive.isMobile(context)
                                ?32:52,
                            width: Responsive.isMobile(context)
                                ?32:52,
                          ),
                        ),
                      ),
                  // Right Arrow button with padding for spacing
                      Positioned(
                        right: 10, // Adjust the value to add space from the list
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () => locationController.scrollRight(),
                          child: Image.asset(
                            'assets/images/arrow_forward.png',
                            height: Responsive.isMobile(context)
                                ?32:52,
                            width: Responsive.isMobile(context)
                                ?32:52,
                          ),
                        ),
                      ),
                    ],
                  ),

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
                    : controller.selectedTop.value == 'reviews'?
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Column(

                            children: [
                              Text('(4.0)',
                                style: TextStyle(
                                  fontFamily: 'Nunito-Regular',
                                  fontSize: Responsive.isMobile(context) ?12:Responsive.isTablet(context) ?22:isLargeScreen?54:44,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF281717),
                                ),),
                              SizedBox(
                                height: Responsive.isMobile(context) ?7:Responsive.isTablet(context) ?10:isLargeScreen?24:14,
                                child: RatingBar(
                                  itemSize: Responsive.isMobile(context) ?7:Responsive.isTablet(context) ?10:isLargeScreen?24:14,
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
                            ],
                          ),
                          SizedBox(width: Responsive.isMobile(context) ?14:32,),
                          Column(
                            children: List.generate(5, (index){
                              return Row(
                                children: [
                                  RatingBar(
                                    itemSize: Responsive.isMobile(context) ?10:Responsive.isTablet(context) ?16:isLargeScreen?38:28,
                                    ignoreGestures: false,
                                    initialRating: 4,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    ratingWidget: RatingWidget(
                                      full: Image.asset(
                                        'assets/images/star yellow.png',
                                        height: Responsive.isMobile(context) ?32:56,
                                        width:Responsive.isMobile(context) ?32:56,
                                      ),
                                      half: Image.asset(
                                        'assets/images/star yellow.png',
                                        height: Responsive.isMobile(context) ?32:56,
                                        width:Responsive.isMobile(context) ?32:56,
                                      ),
                                      empty: Image.asset(
                                        'assets/images/star_empty.png',
                                        color: Color(0xFFBBBBBB),
                                        height: Responsive.isMobile(context) ?32:56,
                                        width:Responsive.isMobile(context) ?32:56,
                                      ),
                                    ),
                                    itemPadding: const EdgeInsets.only(left: 2.0),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                  SizedBox(width: 4,),

                                  SizedBox(
                                    width:Responsive.isMobile(context) ?60:Responsive.isTablet(context) ?90:232,
                                    child: Divider(thickness: 2,color: Color(0xFFBBBBBB)),
                                  ),
                                  SizedBox(width: 4,),
                                  Text('(0)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: Responsive.isMobile(context)?7 :Responsive.isTablet(context) ?10:isLargeScreen?18:14,
                                        color: AppColors.botomSheetColor
                                    ),

                                  ),
                                ],
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: RatingRowWidget(isImage: false,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: RatingRowWidget(isImage: true,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: RatingRowWidget(isImage: false,),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CustomButton(
                        ontapp: (){
                          Get.dialog(Dialog(child: uploadImageSection(context)));
                        },
                        laBelText: 'Write a review',
                        height:Responsive.isMobile(context) ?28:isLargeScreen?58: 48,
                        width: Responsive.isMobile(context) ?130:isLargeScreen?300:265,
                        textColor: AppColors.whiteColor,
                        fontSize: Responsive.isMobile(context) ?12:isLargeScreen?24:20,
                        fontFamily: 'Nunito-Regular',
                        fontWeight: FontWeight.w700,

                      ),
                    ),
                  ],
                )
                    :Column(
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
class RatingRowWidget extends StatelessWidget {
  final bool isImage;

  const RatingRowWidget({super.key, required this.isImage});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 1400;
    return Container(
      width: Responsive.isMobile(context) ?300:Get.width,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(

                children: [
                  Text(
                    'Deanna Blanda',
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context) ?7:isLargeScreen?18:14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Nunito-Regular',
                      color: Colors.black,
                    ),
                  ),


                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '(4.0) ',  // Rating text
                      style: TextStyle(
                        color: Color(0xFF4F5761),
                        fontSize: Responsive.isMobile(context) ?7:isLargeScreen?18:14,
                        fontFamily: 'Nunito-Regular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    WidgetSpan(
                      child: SizedBox(
                        height: Responsive.isMobile(context) ?7:isLargeScreen?18:14,
                        child: RatingBar(
                          itemSize: 10,
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
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Responsive.isMobile(context) ?230:isLargeScreen?700:600,
                height: Responsive.isMobile(context) ?5:isLargeScreen?50:40,
                child: Text(
                  'Voluptatem atque molestiae numquam voluptatem veritatis nesciunt commodi.',
                  style: TextStyle(
                    fontFamily: 'Nunito-Regular',
                    fontSize:Responsive.isMobile(context) ?7:isLargeScreen?18: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.botomSheetColor,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              if (isImage) // Conditional rendering of image if isImage is true
                Container(
                  height: Responsive.isMobile(context) ?40:isLargeScreen?100:80,
                  width: Responsive.isMobile(context) ?60:isLargeScreen?200:120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Responsive.isMobile(context) ?4:8),
                      image: DecorationImage(
                          image: AssetImage('assets/images/img1.png'),
                          fit: BoxFit.cover
                      )
                  ),


                ),

              Text(
                'June 30,2024',
                style: TextStyle(
                  color: AppColors.botomSheetColor,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w400,
                  fontSize: Responsive.isMobile(context) ?7:isLargeScreen?18:14,
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
}