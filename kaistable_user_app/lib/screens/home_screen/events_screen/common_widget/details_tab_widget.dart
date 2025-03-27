import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kaistable_website/constants/app_colors.dart';

import '../../../detail_screens/widget/map_widget.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  late GoogleMapController mapController;

  // Example event location (you can change it dynamically)
  final LatLng eventLocation = const LatLng(21.0285, 105.8542);

  // Marker List
  final RxSet<Marker> markers = <Marker>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _addMarker();
  }

  void _addMarker() {
    markers.add(
      Marker(
        markerId: const MarkerId('eventLocation'),
        position: eventLocation,
        infoWindow: const InfoWindow(title: 'Event Location'),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}

class DetailsTabWidget extends StatelessWidget {
  final controller= Get.put(MapController());
   DetailsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Details',
            style: TextStyle(
              fontFamily: 'Nunito-Sans',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.headingTextColor
            ),
            ),
            SizedBox(height: 10,),
            Text('Address',
              style: TextStyle(
                  fontFamily: 'Nunito-Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.textNormalColor
              ),
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Image.asset('assets/images/location_icon2.png', width: 16, height: 16),
                const SizedBox(width: 6),
                Text(
                  '1901 Thornridge Cir. Shiloh, Hawaii 81063',
                  style: const TextStyle(
                    color: AppColors.textNormalColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Nunito-Regular',
                  ),
                ),
              ],
            ),
            SizedBox(height: 12,),
            Container(
              height: 209,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Obx(
                      () => GoogleMap(
                    onMapCreated: controller.onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: controller.eventLocation,
                      zoom: 14.0,
                    ),
                    markers: controller.markers.value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
