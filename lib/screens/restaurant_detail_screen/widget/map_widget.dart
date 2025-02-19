import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_web_app/screens/add_restaurant/add_resturant_controller/add_resturant%20_controller.dart';
import 'package:restaurant_web_app/universal_models/restaurant_model.dart';
import 'package:restaurant_web_app/widgets/global_functions.dart';

import '../../../../constants/colors.dart';
import '../../../../utils/responsive.dart';
import '../../../widgets/global_functions.dart';
import '../controller/restaurant_detail_controller.dart';

class MapWidget extends StatelessWidget {
  MapWidget({
    super.key,
    required this.controller,
  });

  final RestaurantDetailController controller;
  final addController = Get.put(AddRestaurantController());
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Adjust the map size based on screen width for responsiveness
          double mapHeight = MediaQuery.of(context).size.width > 600
              ? 500
              : 300; // Adjust for tablet/desktop
          return Obx(() {
            return Container(
              height: mapHeight,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng( latitude.value,
                      longitude.value),
                  zoom: 14,
                ),
                onMapCreated: (mapController) {
                   mapControllerr.complete(mapController);
                },
                markers: {
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    position: LatLng( latitude.value,
                       longitude.value),
                  ),
                },
                onCameraIdle: () async {
                  // await controller.getAddress();
                },
                myLocationButtonEnabled: true,
                onCameraMove: (position) async {
                  latitude.value = position.target.latitude;
                  longitude.value = position.target.longitude;
                },
              ), /*GoogleMap(
              markers: {
                const Marker(
                  markerId: MarkerId('Property location'),
                  position: LatLng(37.42796133580664, -122.085749655962),
                ),
              },
              mapType: MapType.normal,
              initialCameraPosition: const CameraPosition(
                target: LatLng(37.42796133580664, -122.085749655962),
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController gController) {
                controller.completer.complete(gController);
              },
              onTap: (LatLng) {

                addController.restaurantModel.latitude = LatLng.latitude;
                addController.restaurantModel.longitude = LatLng.longitude;
              },
            ),*/
            );
          });
        },
      ),
    );
  }
}

class MapDetailWidget extends StatelessWidget {
  const MapDetailWidget({
    super.key,
    required this.restaurantModel,
  });
  final RestaurantModel restaurantModel;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Determine the number of columns based on screen width
          int columns = MediaQuery.of(context).size.width > 600 ? 3 : 2;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Responsive.isMobile(context) ? 22 : 42),
              // Address Section
              Text(
                'Address',
                style: TextStyle(
                  color: AppColors.headingTextColor,
                  fontSize: Responsive.isMobile(context) ? 8 : 16,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
               restaurantModel.address.text,
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: Responsive.isMobile(context) ? 6 : 14,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),

              // Atmospheres Section
              Text(
                'Atmospheres',
                style: TextStyle(
                  color: AppColors.headingTextColor,
                  fontSize: Responsive.isMobile(context) ? 8 : 16,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              // ListView.builder(
              //   itemBuilder: (context, index) {
              //     return _buildAtmosphere(context, 'Cozy');
              //   },
              // ),
              Wrap(
                  spacing: Responsive.isMobile(context) ? 6 : 10,
                  runSpacing: Responsive.isMobile(context) ? 6 : 10,
                  children: restaurantModel.atmopshereList.map((atmosphere) {
                    return _buildAtmosphere(context, atmosphere);
                  }).toList()),
              const SizedBox(height: 16),

              // Facilities Section
              Text(
                'Facilities/service',
                style: TextStyle(
                  color: AppColors.headingTextColor,
                  fontSize: Responsive.isMobile(context) ? 6 : 14,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                  spacing: Responsive.isMobile(context) ? 6 : 10,
                  runSpacing: Responsive.isMobile(context) ? 6 : 10,
                  children: restaurantModel.facilityList.map((facility) {
                    return _buildAtmosphere(context, facility);
                  }).toList()),
              // Wrap(
              //   spacing: Responsive.isMobile(context) ? 4 : 10,
              //   runSpacing: Responsive.isMobile(context) ? 4 : 10,
              //   children: [
              //     _buildFacility(context, 'Outdoor Seating'),
              //     _buildFacility(context, 'Kid-Friendly'),
              //     _buildFacility(context, 'Pet-Friendly'),
              //     _buildFacility(context, 'Private Dining'),
              //     _buildFacility(context, 'Wheelchair accessibility'),
              //     _buildFacility(context, 'High chairs'),
              //   ],
              // ),
              const SizedBox(height: 16),
              Text(
                'Dietary Preferences',
                style: TextStyle(
                  color: AppColors.headingTextColor,
                  fontSize: Responsive.isMobile(context) ? 6 : 14,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                  spacing: Responsive.isMobile(context) ? 6 : 10,
                  runSpacing: Responsive.isMobile(context) ? 6 : 10,
                  children: restaurantModel.dietaryList.map((dietaryData) {
                    return _buildAtmosphere(context, dietaryData);
                  }).toList()),
              const SizedBox(height: 16),

              // Text(
              //   'Entertainment',
              //   style: TextStyle(
              //     color: AppColors.headingTextColor,
              //     fontSize: Responsive.isMobile(context) ? 6 : 14,
              //     fontFamily: 'Nunito-Regular',
              //     fontWeight: FontWeight.w700,
              //   ),
              // ),
              // const SizedBox(height: 8),
              // Wrap(
              //     spacing: Responsive.isMobile(context) ? 6 : 10,
              //     runSpacing: Responsive.isMobile(context) ? 6 : 10,
              //     children: restaurantModel.ent.map((facility) {
              //       return _buildAtmosphere(context, facility);
              //     }).toList()),
              // const SizedBox(height: 16),
              Text(
                'Price Range',
                style: TextStyle(
                  color: AppColors.headingTextColor,
                  fontSize: Responsive.isMobile(context) ? 6 : 14,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),

              Wrap(
                  spacing: Responsive.isMobile(context) ? 6 : 10,
                  runSpacing: Responsive.isMobile(context) ? 6 : 10,
                  children: [

                    _buildPriceRange(context, restaurantModel.priceRange.value),
                  ]),
              // Wrap(
              //   spacing: Responsive.isMobile(context) ? 4 : 10,
              //   runSpacing: Responsive.isMobile(context) ? 4 : 10,
              //   children: [
              //     _buildPriceRange(context, '\$(Budget-Friendly)'),
              //   ],
              // ),
              const SizedBox(height: 16),
              // Spoken Languages Section
              Text(
                'Spoken Languages',
                style: TextStyle(
                  color: AppColors.headingTextColor,
                  fontSize: Responsive.isMobile(context) ? 8 : 16,
                  fontFamily: 'Nunito-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0XFFB2E6D6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
               restaurantModel.spokenLanguage.value,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: Responsive.isMobile(context) ? 6 : 12,
                    fontFamily: 'Nunito-Regular',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAtmosphere(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0XFFB2E6D6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.blackColor,
          fontSize: Responsive.isMobile(context) ? 6 : 12,
          fontFamily: 'Nunito-Regular',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildFacility(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0XFFB2E6D6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.blackColor,
          fontSize: Responsive.isMobile(context) ? 6 : 12,
          fontFamily: 'Nunito-Regular',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildEntertainment(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0XFFB2E6D6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.blackColor,
          fontSize: Responsive.isMobile(context) ? 6 : 12,
          fontFamily: 'Nunito-Regular',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildPriceRange(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0XFFB2E6D6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.blackColor,
          fontSize: Responsive.isMobile(context) ? 6 : 12,
          fontFamily: 'Nunito-Regular',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildDietary(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0XFFB2E6D6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.blackColor,
          fontSize: Responsive.isMobile(context) ? 6 : 12,
          fontFamily: 'Nunito-Regular',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
