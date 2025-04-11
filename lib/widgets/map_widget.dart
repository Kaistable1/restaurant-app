import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:savrly/controllers/add_restaurants_controller.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final AddRestaurantTabController addController =
      Get.find<AddRestaurantTabController>();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _getCurrentLocationWeb();
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocationWeb() async {
    try {
      // Check if geolocation is supported
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled')),
        );
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Location permissions are permanently denied')),
        );
        return;
      }

      // Set initial coordinates
      if (addController.restaurantModel != null) {
        // Use restaurantModel coordinates if editing
        addController.latitude.value = addController.restaurantModel!.latitude;
        addController.longitude.value =
            addController.restaurantModel!.longitude;
      } else {
        // Fetch current location for new restaurant
        Position position = await Geolocator.getCurrentPosition();
        addController.latitude.value = position.latitude;
        addController.longitude.value = position.longitude;
      }

      // Update map camera
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              addController.latitude.value,
              addController.longitude.value,
            ),
            zoom: 14,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
      // Set fallback location
      addController.latitude.value = 37.7749; // San Francisco
      addController.longitude.value = -122.4194;
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              addController.latitude.value,
              addController.longitude.value,
            ),
            zoom: 14,
          ),
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      if (addController.restaurantModel != null) {
        // Use restaurantModel coordinates if editing
        addController.latitude.value = addController.restaurantModel!.latitude;
        addController.longitude.value =
            addController.restaurantModel!.longitude;
      } else {
        // Fetch current location for new restaurant
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        addController.latitude.value = position.latitude;
        addController.longitude.value = position.longitude;
      }

      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              addController.latitude.value,
              addController.longitude.value,
            ),
            zoom: 14,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive map height
          double mapHeight = kIsWeb
              ? MediaQuery.of(context).size.height * 0.5
              : constraints.maxWidth > 600
                  ? MediaQuery.of(context).size.height * 0.6
                  : MediaQuery.of(context).size.height * 0.4;

          return Obx(() {
            return SizedBox(
              height: mapHeight,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    addController.latitude.value != 0.0
                        ? addController.latitude.value
                        : 37.7749, // Fallback: San Francisco
                    addController.longitude.value != 0.0
                        ? addController.longitude.value
                        : -122.4194,
                  ),
                  zoom: 14,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
                markers: {
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    position: LatLng(
                      addController.latitude.value,
                      addController.longitude.value,
                    ),
                  ),
                },
                myLocationButtonEnabled: true,
                onCameraMove: (CameraPosition position) {
                  addController.latitude.value = position.target.latitude;
                  addController.longitude.value = position.target.longitude;
                  print('latitude ------- ${addController.latitude.value}');
                  print('longitude ------- ${addController.longitude.value}');
                },
              ),
            );
          });
        },
      ),
    );
  }
}
