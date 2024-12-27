

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      borderRadius: BorderRadius.only(topRight: Radius.circular(10),
        topLeft:  Radius.circular(10)
          ),
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
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Address',
            style: TextStyle(
              color: AppColors.headingTextColor,
              fontSize: 14,
              fontFamily: 'Nunito-Regular',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            height:40,
            width: 290,
            child: Text(
              'shop g31, g/f, park central 9 tong tank, tseung kwan',
              style: TextStyle(
                color: AppColors.darkGrey,
                fontSize: 14,
                fontFamily: 'Nunito-Regular',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Atmospheres',
            style: TextStyle(
              color: AppColors.headingTextColor,
              fontSize: 14,
              fontFamily: 'Nunito-Regular',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 10,),
        SizedBox(
          height: 70,
          width: 325,
          child: Column(
            children: [
              Row(

                children: [
                  SizedBox(width: 4,),
                  _buildStarBox(title: "cozy",context,),
                  SizedBox(width: 4,),
                  _buildStarBox(title: "casual dining",context, ),
                  SizedBox(width: 4,),
                  _buildStarBox(title: "private dining rooms",context, ),

                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  SizedBox(width: 4,),
                  _buildStarBox(title: "outdoor seating",context,),
                  SizedBox(width: 4,),
                  _buildStarBox(title: "bar/lounge area",context, ),
                ],
              ),
            ],
          ),
        )
        ,
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Facilities/services',
            style: TextStyle(
              color: AppColors.headingTextColor,
              fontSize: 14,
              fontFamily: 'Nunito-Regular',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 10,),
        SizedBox(
          height: 70,
          width: 325,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 4,),
                  _buildStarBox(title: "free wi-fi",context,),
                  SizedBox(width: 4,),
                  _buildStarBox(title: "parking",context, ),
                  SizedBox(width: 4,),
                  _buildStarBox(title: "takeout",context, ),
                  SizedBox(width: 4,),
                  _buildStarBox(title: "drive-thru",context, ),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  SizedBox(width: 4,),
                  _buildStarBox(title: "wheelchair accessibility",context,),
                  SizedBox(width: 4,),
                  _buildStarBox(title: "high chairs",context, ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Dietary Preferences',
            style: TextStyle(
              color: AppColors.headingTextColor,
              fontSize: 14,
              fontFamily: 'Nunito-Regular',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 16,),
        SizedBox(
          height: 70,
          width: 325,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 4,),
                  _buildStarBox(title: "vegetarian",context,),
                  SizedBox(width: 4,),
                  _buildStarBox(title: "vegan",context, ),
                  SizedBox(width: 4,),
                  _buildStarBox(title: "gluten-free",context, ),
                  SizedBox(width: 4,),
                  _buildStarBox(title: "dairy-free",context, ),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  SizedBox(width: 4,),
                  _buildStarBox(title: "keto-friendly",context,),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Entertainment',
            style: TextStyle(
              color: AppColors.headingTextColor,
              fontSize: 14,
              fontFamily: 'Nunito-Regular',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 10,),
        SizedBox(
          height: 40,
          width: 325,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 4,),
                  _buildStarBox(title: "Live Music",context,),
                  SizedBox(width: 4,),
                  _buildStarBox(title: "Karaoke",context, ),
                  SizedBox(width: 4,),
                  _buildStarBox(title: "DJ Nights",context, ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Price Range',
            style: TextStyle(
              color: AppColors.headingTextColor,
              fontSize: 14,
              fontFamily: 'Nunito-Regular',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 10,),
        SizedBox(
          height: 50,
          width: 325,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 4,),
                  _buildStarBox(title: "\$ (budget-friendly)",context,),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Spoken language',
            style: TextStyle(
              color: AppColors.headingTextColor,
              fontSize: 14,
              fontFamily: 'Nunito-Regular',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: _buildStarBox(title: "chinese",context,),
        ),
        SizedBox(height: 20,)

      ],
    );
  }
  Widget _buildStarBox(BuildContext context, {
    required String title,
  }) {
    return Container(
      height: 30,
      padding: EdgeInsets.only(left: 12,right: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(.5),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Nunito-Regular',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor,
          ),
        ),
      ),
    );
  }


}
