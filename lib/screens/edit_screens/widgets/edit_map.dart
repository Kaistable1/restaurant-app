import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_web_app/screens/add_restaurant/add_resturant_controller/add_resturant%20_controller.dart';
import 'package:restaurant_web_app/screens/restaurant_detail_screen/controller/restaurant_detail_controller.dart';
import 'package:restaurant_web_app/models/resaturant_model.dart';

import '../../../widgets/global_functions.dart';

class EditMapWidget extends StatelessWidget {
  EditMapWidget({
    super.key,
    required this.restaurantModel,
  });
  final RestaurantModel restaurantModel;

  final editController = Get.put(AddRestaurantController());
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
          return Container(
            height: mapHeight,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(restaurantModel.latitude, restaurantModel.longitude),
                zoom: 14,
              ),
              onMapCreated: (mapController) {
                mapControllerr.complete(mapController);
              },
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: LatLng(
                      restaurantModel.latitude, restaurantModel.longitude),
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
            ),
          );
        },
      ),
    );
  }
}
