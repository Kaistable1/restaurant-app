import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaistable_website/constants/app_colors.dart';
import 'package:kaistable_website/screens/detail_screens/controller/restaurant_detail_controller.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({
    super.key,
    required this.controller,
  });

  final RestaurantDetailController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
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



class MapDetailWidget extends StatelessWidget {
  const MapDetailWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
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

        Text(
          '1. cozy \n2. casual dinning ',
          style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 14,
            fontFamily: 'Nunito-Regular',
            fontWeight: FontWeight.w400,
          ),
        )  , SizedBox(
          height: 50,
        ),
        Text(
          'Facilities',
          style: TextStyle(
            color: AppColors.headingTextColor,
            fontSize: 14,
            fontFamily: 'Nunito-Regular',
            fontWeight: FontWeight.w700,
          ),


        ),

        Text(
          '1. accept credit cards, \n2. indoor dinning ',
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
          'Spoken Languages',
          style: TextStyle(
            color: AppColors.headingTextColor,
            fontSize: 14,
            fontFamily: 'Nunito-Regular',
            fontWeight: FontWeight.w700,
          ),


        ),

        Text(
          'chinese',
          style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 14,
            fontFamily: 'Nunito-Regular',
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}