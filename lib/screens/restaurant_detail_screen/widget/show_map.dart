import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_web_app/screens/add_restaurant/add_resturant_controller/add_resturant%20_controller.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/controller/restaurant_detail_controller.dart';
import 'package:restaurant_web_app/models/resaturant_model.dart';

class ShowMapWidget extends StatelessWidget {
  const ShowMapWidget({
    super.key,
    required this.controller,
    required this.resModel,
  });

  final RestaurantDetailController controller;
  final RestaurantModel resModel;

  @override
  Widget build(BuildContext context) {
    print("Latitude: ${resModel.latitude}, Longitude: ${resModel.longitude}");

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Adjust the map size based on screen width for responsiveness
          double mapHeight = MediaQuery.of(context).size.width > 600
              ? 500
              : 300; // Adjust for tablet/desktop
          return Container(
            height: mapHeight,
            child: GoogleMap(
              markers: {
                Marker(
                  markerId: MarkerId('Property location'),
                  position: LatLng(resModel.latitude, resModel.longitude),
                ),
              },
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(resModel.latitude, resModel.longitude),
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController gController) {
                controller.completer.complete(gController);
              },
            ),
          );
        },
      ),
    );
  }
}
